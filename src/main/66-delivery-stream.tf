module "LogsKinesisDeliveryStreamPartitioned" {
  source = "./modules/kinesis-firehose"
  dynamic_partitioning_enabled = false
  firehose_name = "${var.ProjectName}-logsTos3-delivery-stream-v1"
  stream_arn= module.kinesis_pn_confinfo_LogsKinesisStream.arn
  stream_kms_arn = module.kinesis_pn_confinfo_LogsKinesisStream.kms_arn
  s3_bucket_arn = module.s3_pn_confinfo_LogsBucket.bucket_arn
  loggroup_retention = 120
  StreamNamePrefix = "logsTos3"

  # CloudWatch Alarm variables
  alarm_name           = "${var.ProjectName}-logsTos3-Kinesis-Alarm"
  alarm_description    = ""
  ok_actions = [aws_sns_topic.sns_pn_confinfo_sns_topic.arn]
  alarm_actions = [aws_sns_topic.sns_pn_confinfo_sns_topic.arn]
  dimensions = {
    StreamName = "${var.ProjectName}-logKinesis"
  }
    
  # filter variables
  metric_name = "${var.ProjectName}-logsTos3-kinesis-error"
  filter_name = "DeliveryStreamErrorLogsMetricFilter"
  filter_pattern = "?S3 ?InternalError"
}

module "LogsKinesisDeliveryStreamPartitioned-cdc" {
  source = "./modules/kinesis-firehose"
  dynamic_partitioning_enabled = true
  firehose_name = "${var.ProjectName}-cdcTos3-delivery-stream-v1"
  stream_arn= module.kinesis_pn_confinfo_CdcKinesisStream.arn
  stream_kms_arn = module.kinesis_pn_confinfo_CdcKinesisStream.kms_arn
  s3_bucket_arn = module.s3_pn_confinfo_LogsBucket.bucket_arn
  loggroup_retention = 120
  StreamNamePrefix = "cdcTos3"

  # CloudWatch Alarm variables
  alarm_name           = "${var.ProjectName}-cdcTos3-Kinesis-Alarm"
  alarm_description    = ""
  ok_actions = [aws_sns_topic.sns_pn_confinfo_sns_topic.arn]
  alarm_actions = [aws_sns_topic.sns_pn_confinfo_sns_topic.arn]
  dimensions = {
    StreamName = "${var.ProjectName}-logKinesis"
  }
    
  # filter variables
  metric_name = "${var.ProjectName}-cdcTos3-kinesis-error"
  filter_name = "DeliveryStreamErrorLogsMetricFilter"
  filter_pattern = "?S3 ?InternalError"
}

