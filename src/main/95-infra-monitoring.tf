resource "aws_cloudwatch_event_rule" "ECSOutOfMemoryStoppedTasksEvent" {
  name        = "${var.ProjectName}-ECSOutOfMemoryStoppedTasksEvent"
  description = "Triggered when an Amazon ECS Task is stopped due to OOM"

  event_pattern = jsonencode({
    source      = ["aws.ecs"]
    detail-type = ["ECS Task State Change"]
    detail = {
      desiredStatus = ["STOPPED"]
      lastStatus    = ["STOPPED"]
      containers = {
        reason = [{
          prefix = "OutOfMemory"
        }]
      }
    }
  })
  is_enabled = true
}

resource "aws_cloudwatch_event_target" "ECSOutOfMemoryStoppedTasksEvent" {
  rule      = aws_cloudwatch_event_rule.ECSOutOfMemoryStoppedTasksEvent.name
  target_id = "LogTarget"
  arn       = aws_cloudwatch_log_group.LogGroupOOMEvents.arn
}

resource "aws_cloudwatch_log_group" "LogGroupOOMEvents" {
  name = "/aws/events/${var.ProjectName}-ecs-oom-errors"
  retention_in_days = 90
}

data "aws_iam_policy_document" "LogGroupOOMEventsPolicy" {
  statement {
    sid    = "EventBridgetoCWLogsCreateLogStreamPolicy"
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["events.amazonaws.com"]
    }

    actions   = ["logs:CreateLogStream"]
    resources = [aws_cloudwatch_log_group.LogGroupOOMEvents.arn]
  }

  statement {
    sid    = "EventBridgetoCWLogsPutLogEventsPolicy"
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["events.amazonaws.com"]
    }

    actions   = ["logs:PutLogEvents"]
    resources = [aws_cloudwatch_log_group.LogGroupOOMEvents.arn]

    condition {
      test     = "ArnEquals"
      variable = "AWS:SourceArn"
      values   = [aws_cloudwatch_event_rule.ECSOutOfMemoryStoppedTasksEvent.arn]
    }
  }
}

resource "aws_cloudwatch_log_resource_policy" "eventbridge_to_cwlogs_policy" {
  policy_name     = "${var.ProjectName}-EventBridgeToCWLogsPolicy"
  policy_document = data.aws_iam_policy_document.LogGroupOOMEventsPolicy.json
}

resource "aws_cloudwatch_log_metric_filter" "OutOfMemoryLogsMetricFilter" {
  name           = "DeliveryStreamErrorLogsMetricFilter-cdc"
  pattern        = ""
  log_group_name = aws_cloudwatch_log_group.LogGroupOOMEvents.name

  metric_transformation {
    name      = "${var.ProjectName}-ECSOutOfMemory"
    namespace = "OutOfMemoryErrors"
    value     = 1
  }
}

resource "aws_cloudwatch_metric_alarm" "CloudWatchAlarmOOM-cdc" {
  alarm_name                = "${var.ProjectName}-ECSOutOfMemory-Alarm"
  alarm_description = "CloudWatch alarm for when ECS task stop with OOM errors."
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = 60
  metric_name               = "${var.ProjectName}-ECSOutOfMemory"
  namespace                 = "OutOfMemoryErrors"
  period                    = 60
  statistic                 = "Sum"
  threshold                 = 1
  treat_missing_data = "notBreaching"
  datapoints_to_alarm = 1
  alarm_actions = [aws_sns_topic.sns_pn_confinfo_sns_topic.arn]
}

data "aws_iam_policy_document" "SubscriptionFilterServiceRole" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["logs.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "SubscriptionFilterServiceRole" {
  name = "SubscriptionFilterServiceRole"
  assume_role_policy = data.aws_iam_policy_document.SubscriptionFilterServiceRole.json
}


data "aws_iam_policy_document" "SubscriptionFilterService" {
  statement {
    sid    = ""
    effect = "Allow"
    actions = [
      "kinesis:PutRecord"
    ]
    resources = ["*"]
  }

  statement {
    effect = "Allow"
    actions = [
      "kms:Encrypt",
      "kms:GenerateDataKey",
      "kms:Decrypt"
    ]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "SubscriptionFilterServiceRole" {
  name   = "${var.ProjectName}-monitoring-subscription-role"
  policy = data.aws_iam_policy_document.SubscriptionFilterService.json
}



resource "aws_iam_role_policy_attachment" "SubscriptionFilterServiceRole" {
  role       = aws_iam_role.SubscriptionFilterServiceRole.name
  policy_arn = aws_iam_policy.SubscriptionFilterServiceRole.arn
}

resource "aws_cloudwatch_log_subscription_filter" "OomSubscriptionFilter" {
  name            = "${var.ProjectName}-oom-events-subscription"
  role_arn        = aws_iam_role.SubscriptionFilterServiceRole.arn
  log_group_name  = aws_cloudwatch_log_group.LogGroupOOMEvents.name
  filter_pattern  = " "
  destination_arn = module.kinesis_pn_confinfo_LogsKinesisStream.arn
}

resource "aws_cloudwatch_metric_alarm" "ClockErrorBoundAlarm" {
  alarm_name          = "pn-Clock-Error-Bound-Alarm"
  alarm_description   = "CloudWatch Alarm for Clock Error Bound limit over threshold"
  treat_missing_data  = "notBreaching"
  threshold           = 1
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 2
  datapoints_to_alarm = 2

  metric_query {
    id          = "q1"
    expression  = "SELECT MAX(ClockErrorBound) FROM SCHEMA(\"ECS/ContainerInsights\", ClusterName,Family,TaskID) WHERE ClusterName = 'pn-confidential-ecs-cluster' GROUP BY ClusterName"
    period      = 600
    return_data = false
  }

  metric_query {
    id          = "e2"
    expression  = "IF(MAX(q1) < 100, 0, 1)"
    period      = 600
    return_data = true
  }
}

resource "aws_cloudwatch_metric_alarm" "SynchronizationAlarm" {
  alarm_name          = "pn-Synchronization-Alarm"
  alarm_description   = "CloudWatch Alarm for Synchronization value different by Synchronized"
  treat_missing_data  = "notBreaching"
  threshold           = 1
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 2
  datapoints_to_alarm = 2

  metric_query {
    id          = "q1"
    expression  = "SELECT MAX(Synchronization) FROM SCHEMA(\"ECS/ContainerInsights\", ClusterName,Family,TaskID) WHERE ClusterName = 'pn-confidential-ecs-cluster' GROUP BY ClusterName"
    period      = 600
    return_data = false
  }

  metric_query {
    id          = "e2"
    expression  = "IF(MAX(q1) < 1, 0, 1)"
    period      = 600
    return_data = true
  }
}
