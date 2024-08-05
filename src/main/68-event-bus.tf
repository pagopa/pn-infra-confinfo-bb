#EVENTBUS
#############################

resource "aws_cloudwatch_event_bus" "PnConfinfoEventBus" {
  name = "${var.ProjectName}-ConfinfoEventBus"
}

resource "aws_sqs_queue" "EventBusDeadLetterQueue" {
  name                      = "${var.ProjectName}-ConfinfoEventBus-DLQ"
  message_retention_seconds = var.pn_event_bus_dlq_maximum_retention_period
  receive_wait_time_seconds = 10
}

data "aws_iam_policy_document" "PnConfinfoEventBusAccessPolicy" {
  statement {
    sid    = "AccountAccess"
    effect = "Allow"
    actions = [
      "events:PutEvents",
    ]
    resources = [
      "${aws_cloudwatch_event_bus.PnConfinfoEventBus.arn}"
    ]

    principals {
      type        = "AWS"
      identifiers = ["${data.aws_caller_identity.current.account_id}"]
    }
  }
}

resource "aws_cloudwatch_event_bus_policy" "PnConfinfoEventBusAccessPolicy" {
  policy         = data.aws_iam_policy_document.PnConfinfoEventBusAccessPolicy.json
  event_bus_name = aws_cloudwatch_event_bus.PnConfinfoEventBus.name
}

data "aws_iam_policy_document" "EventBusDeadLetterQueuePolicy" {
  statement {
    sid    = "sqspolicy"
    effect = "Allow"
    actions = [
      "sqs:SendMessage",
    ]
    resources = [
      "${aws_sqs_queue.EventBusDeadLetterQueue.arn}"
    ]

    principals {
      type        = "Service"
      identifiers = ["events.amazonaws.com"]
    }
  }
}

resource "aws_sqs_queue_policy" "teEventBusDeadLetterQueuePolicyst" {
  queue_url = "${aws_sqs_queue.EventBusDeadLetterQueue.id}"
  policy = data.aws_iam_policy_document.EventBusDeadLetterQueuePolicy.json
}


resource "aws_cloudwatch_metric_alarm" "DLQHasMessagesAlarm" {
  alarm_name                = "${var.ProjectName}-ConfinfoEventBus-DLQ-HasMessage"
  alarm_description = "CloudWatch alarm for when DLQ has 1 or more messages."
  namespace                 = "AWS/SQS"
  metric_name               = "ApproximateNumberOfMessagesVisible"
  dimensions = {
    QueueName = aws_sqs_queue.EventBusDeadLetterQueue.name
  }
  statistic                 = "Sum"
  treat_missing_data = "notBreaching"
  period                    = 60
  threshold                 = 1
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = 1
  ok_actions  = [aws_sns_topic.sns_pn_confinfo_sns_topic.arn]
  alarm_actions = [aws_sns_topic.sns_pn_confinfo_sns_topic.arn]
  insufficient_data_actions = [aws_sns_topic.sns_pn_confinfo_sns_topic.arn]
}

resource "aws_cloudwatch_metric_alarm" "OncallDLQHasMessagesAlarm" {
  alarm_name          = "oncall-${var.ProjectName}-ConfinfoEventBus-DLQ-HasMessage"
  alarm_description   = "CloudWatch alarm for when DLQ has 1 or more messages."
  treat_missing_data  = "notBreaching"
  threshold           = 1
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 5

  metric_query {
    id          = "m1"
    return_data = false

    metric {
      metric_name = "NumberOfMessagesReceived"
      namespace   = "AWS/SQS"
      period      = 60
      stat        = "Sum"

      dimensions = {
        QueueName = aws_sqs_queue.EventBusDeadLetterQueue.name
      }
    }
  }

  metric_query {
    id          = "m2"
    return_data = false

    metric {
      metric_name = "MatchedEvents"
      namespace   = "AWS/Events"
      period      = 60
      stat        = "Sum"

      dimensions = {
        EventBusName = "${var.ProjectName}-ConfinfoEventBus"
      }
    }
  }

  metric_query {
    id          = "e1"
    expression  = "IF(m2>0 AND m1/m2>${var.pn_event_bus_oncall_dlq_ratio}, 1, 0)"
    label       = "${var.ProjectName}-ConfinfoEventBus-HasDLQMessage-OnCall-Metric"
    return_data = true
  }

  ok_actions  = [aws_sns_topic.sns_pn_confinfo_sns_topic.arn]
  alarm_actions = [aws_sns_topic.sns_pn_confinfo_sns_topic.arn]
  insufficient_data_actions = [aws_sns_topic.sns_pn_confinfo_sns_topic.arn]
}
