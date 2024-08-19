#LogsBucket
module "s3_pn_confinfo_LogsBucket" {
  source = "./modules/s3"
  name = var.pn_logs_bucket_name
}

resource "aws_s3_bucket_server_side_encryption_configuration" "s3_pn_confinfo_LogsBucket" {
  bucket = module.s3_pn_confinfo_LogsBucket.bucket_name

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.kms_pn_confinfo_LogsBucket.arn
      sse_algorithm     = "aws:kms"
    }
  }
}

#LogsBucketKmsKey
resource "aws_kms_key" "kms_pn_confinfo_LogsBucket" {
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
      },
      {
        Sid    = "Allow target accounts to use key for encrypt/decrypt"
        Effect = "Allow"
        Principal = {
          AWS = [
             "arn:aws:iam::${var.pn_confinfo_aws_account_id}:root"
          ]
        },
        Action = [
          "kms:Encrypt",
          "kms:Decrypt",
          "kms:ReEncrypt*",
          "kms:GenerateDataKey*",
          "kms:DescribeKey"
        ],
        Resource = "*"
      }
    ]
  })
}

resource "aws_kms_alias" "kms_pn_confinfo_LogsBucket" {
  name          = "alias/kms_pn_confinfo_LogsBucket"
  target_key_id = aws_kms_key.kms_pn_confinfo_LogsBucket.key_id
}
##############################

#Continuous Delivery Bucket
module "s3_pn_confinfo_CdBucket" {
  source = "./modules/s3"
  name = var.pn_cd_bucket_name
}

#RuntimeEnvironmentVariablesBucket
module "s3_pn_confinfo_RuntimeEnvironmentVariablesBucket" {
  source = "./modules/s3"
  name = var.pn_runtime_env_bucket_name
}

##############################
#CdcKinesisStream
# Kinesis Stream variables
module "kinesis_pn_confinfo_CdcKinesisStream" {
  source = "./modules/kinesis-stream"
  name = var.pn_cdc_kinesis_stream_name
  shard_count = var.pn_cdc_kinesis_stream_shard_count
  stream_mode_details = var.pn_cdc_kinesis_stream_mode
  retention_period = var.pn_cdc_kinesis_stream_retention_hours

  ## KMS variables
  kms_alias = "alias/${var.ProjectName}-CdcKinesis-kms"

# CloudWatch Alarm variables
  alarm_name           = "${var.ProjectName}-CdcKinesis-IteratorAge-Alarm"
  alarm_description    = "CloudWatch alarm for when Kinesis Cdc GetRecords.IteratorAgeMilliseconds is too high."
  alarm_actions = [aws_sns_topic.sns_pn_confinfo_sns_topic.arn]
  ok_actions = [aws_sns_topic.sns_pn_confinfo_sns_topic.arn]
  oncall_threshold = var.pn_cdc_kinesis_stream_oncall_alarm_threshold
  threshold = var.pn_cdc_kinesis_stream_alarm_threshold
  dimensions = {
    StreamName = var.pn_cdc_kinesis_stream_name
  }
}



##############################
#kinesis_pn_confinfo_LogsKinesisStream

module "kinesis_pn_confinfo_LogsKinesisStream" {
# Kinesis Stream variables

  source = "./modules/kinesis-stream"
  name =  var.pn_logs_kinesis_stream_name
  shard_count = var.pn_logs_kinesis_stream_shard_count
  stream_mode_details = var.pn_logs_kinesis_stream_mode
  retention_period = var.pn_logs_kinesis_stream_retention_hours

# KMS variables
  kms_alias = "alias/${var.ProjectName}-logKinesis-kms"

# CloudWatch Alarm variables
  alarm_name           = "${var.ProjectName}-logKinesis-IteratorAge-Alarm"
  alarm_description    = "CloudWatch alarm for when Kinesis Cdc GetRecords.IteratorAgeMilliseconds is too high."
  alarm_actions = [aws_sns_topic.sns_pn_confinfo_sns_topic.arn]
  ok_actions = [aws_sns_topic.sns_pn_confinfo_sns_topic.arn]
  oncall_threshold = var.pn_logs_kinesis_stream_oncall_alarm_threshold
  threshold = var.pn_logs_kinesis_stream_alarm_threshold
  
  dimensions = {
    StreamName = var.pn_logs_kinesis_stream_name
  }
}






