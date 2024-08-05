data "aws_caller_identity" "current" {}
resource "aws_kinesis_stream" "stream" {
  name             = var.name
  shard_count      = var.stream_mode_details == "PROVISIONED" ? var.shard_count : null
  retention_period = var.retention_period
  encryption_type  = var.encryption_type
  kms_key_id       = aws_kms_key.kms.id

  enforce_consumer_deletion = var.enforce_consumer_deletion

  shard_level_metrics = var.shard_level_metrics

  stream_mode_details {
    stream_mode = var.stream_mode_details
  }
}

resource "aws_kms_key" "kms" {
  description             = "Used by Assumed Roles to Encrypt/Decrypt raw data"
  enable_key_rotation     = true
  deletion_window_in_days = 20
  policy = jsonencode({
    Version = "2012-10-17"
    Id      = "key-default-1"
    Statement = [
      {
        Sid    = "Allow data account to do everything"
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
        },
        Action   = "kms:*"
        Resource = "*"
      }
    ]
  })
}


resource "aws_kms_alias" "alias" {
  name          = var.kms_alias
  target_key_id = aws_kms_key.kms.key_id
}


resource "aws_cloudwatch_metric_alarm" "alarm" {

  alarm_name                = var.alarm_name
  alarm_description         = var.alarm_description
  comparison_operator       = var.comparison_operator
  evaluation_periods        = var.evaluation_periods
  metric_name               = var.metric_name
  namespace                 = var.namespace
  period                    = var.period
  statistic                 = var.statistic
  threshold                 = var.threshold
  alarm_actions             = var.alarm_actions
  insufficient_data_actions = var.insufficient_data_actions
  ok_actions                = var.ok_actions
  treat_missing_data        = var.treat_missing_data
  datapoints_to_alarm       = var.datapoints_to_alarm

  dimensions = var.dimensions
}

resource "aws_cloudwatch_metric_alarm" "oncall-alarm" {

  alarm_name                = "oncall-${var.alarm_name}"
  alarm_description         = var.alarm_description
  comparison_operator       = var.comparison_operator
  evaluation_periods        = var.evaluation_periods
  metric_name               = var.metric_name
  namespace                 = var.namespace
  period                    = var.period
  statistic                 = var.statistic
  threshold                 = var.oncall_threshold
  alarm_actions             = var.alarm_actions
  insufficient_data_actions = var.insufficient_data_actions
  ok_actions                = var.ok_actions
  treat_missing_data        = var.treat_missing_data
  datapoints_to_alarm       = var.datapoints_to_alarm

  dimensions = var.dimensions
}