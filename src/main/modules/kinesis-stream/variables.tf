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

#variable "kms_key_id" {
#  description = "The KMS Key ID to use for encryption of data at rest"
#  type        = string
#}

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

#KMS
variable "kms_alias" {
  description = "The KMS alias to use for encryption of data at rest"
  type        = string
}


#Alarm

variable "alarm_name" {
  type        = string
  description = "The descriptive name for the alarm."
}

variable "alarm_description" {
  type        = string
  default     = ""
  description = "The description for the alarm."
}

variable "comparison_operator" {
  type        = string
  description = "The arithmetic operation to use when comparing the specified Statistic and Threshold."
  sensitive   = true
  default = "GreaterThanOrEqualToThreshold"
}

variable "evaluation_periods" {
  type        = number
  description = "The number of periods over which data is compared to the specified threshold."
  default = 60
}

variable "metric_name" {
  type        = string
  default     = "GetRecords.IteratorAgeMilliseconds"
  description = "The name for the alarm's associated metric."
}

variable "namespace" {
  type        = string
  default     = "AWS/Kinesis"
  description = "The namespace for the alarm's associated metric."
  sensitive   = true
}

variable "period" {
  type        = number
  default     = 60
  description = "The period in seconds over which the specified statistic is applied."
}

variable "statistic" {
  type        = string
  default     = "Maximum"
  description = "The statistic to apply to the alarm's associated metric."
}

variable "threshold" {
  type        = number
  default     = 40
  description = "The value against which the specified statistic is compared."
}

variable "oncall_threshold" {
  type        = number
  default     = 60
  description = "The value against which the specified statistic is compared."
}



variable "alarm_actions" {
  type        = list(any)
  default     = []
  description = "The list of actions to execute when this alarm transitions into an ALARM state from any other state."
}


variable "insufficient_data_actions" {
  type        = list(any)
  default     = []
  description = "The list of actions to execute when this alarm transitions into an INSUFFICIENT_DATA state from any other state."
}

variable "treat_missing_data" {
  type        = string
  default     = "notBreaching"
  description = "Sets how an alarm is going to handle missing data points."
}

variable "datapoints_to_alarm" {
  type        = number
  default     = 1
  description = "Sets the number of datapoints that must be breaching to trigger the alarm."
}

variable "ok_actions" {
  type        = list(any)
  default     = []
  description = "The list of actions to execute when this alarm transitions into an OK state from any other state."
}

variable "dimensions" {
  type        = map(any)
  default     = {}
  description = "Dimensions for metrics."
}

variable "with_alarm" {
  description = "Whether to create CloudWatch alarm for the Kinesis Stream"
  type        = bool
  default     = false
}

variable "with_oncall_alarm" {
  description = "Whether to create CloudWatch oncall alarm for the Kinesis Stream"
  type        = bool
  default     = false
}



