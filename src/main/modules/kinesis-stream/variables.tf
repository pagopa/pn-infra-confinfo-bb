variable "name" {
  description = "The name to give to the new stream"
  type        = string
}

variable "shard_count" {
  description = "The number of shards to create the stream with"
  type        = number
}

variable "shard_level_metrics" {
  description = "A list of shard-level CloudWatch metrics which can be enabled for the stream"
  default     = []
  type        = list(string)
}

variable "retention_period" {
  description = "The number of hours that a shard should retain data for"
  default     = 24
  type        = number
}

variable "enforce_consumer_deletion" {
  description = "A boolean that indicates all registered consumers should be deregistered from the stream so that the stream can be destroyed without error"
  default     = true
  type        = bool
}

variable "encryption_type" {
  description = "The encryption type to use for data at rest"
  default     = "KMS"
  type        = string
}

variable "kms_key_id" {
  description = "The KMS Key ID to use for encryption of data at rest"
  type        = string
}

variable "tags" {
  description = "The tags to append to this resource"
  default     = {}
  type        = map(string)
}

variable "stream_mode_details" {
  description = "Capacity mode of the stream, either ON_DEMAND or PROVISIONED (note: ON_DEMAND comes with a much higher base cost for lower throughput - https://aws.amazon.com/kinesis/data-streams/pricing/)"
  type        = string
  default     = "ON_DEMAND"
}