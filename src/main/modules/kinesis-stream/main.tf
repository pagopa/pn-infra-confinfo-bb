resource "aws_kinesis_stream" "stream" {
  name             = var.name
  shard_count      = var.stream_mode_details == "PROVISIONED" ? var.shard_count : null
  retention_period = var.retention_period
  encryption_type  = var.encryption_type
  kms_key_id       = var.kms_key_id
  
  enforce_consumer_deletion = var.enforce_consumer_deletion

  shard_level_metrics = var.shard_level_metrics

  stream_mode_details {
    stream_mode = var.stream_mode_details
  }
}