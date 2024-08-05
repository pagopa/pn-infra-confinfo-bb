variable "dynamic_partitioning_enabled" {
  type        = bool
  default     = true
  description = "Enable firehose with dynamic partition."
}


variable "firehose_name" {
  description = "The name of the Kinesis Firehose"
  type        = string
}

variable "stream_arn" {
  description = "ARN of the Kinesis stream source"
  type        = string
}

variable "stream_kms_arn" {
  description = "ARN of the KMS Kinesis stream source"
  type        = string
}


variable "s3_bucket_arn" {
  description = "The ARN of the S3 bucket"
  type        = string
}


variable "loggroup_retention" {
  description = "log group retention"
  type        = number
}

variable "StreamNamePrefix" {
  description = "To distinguish different log groups streams"
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
  description = "The name for the alarm's associated metric."
}

variable "namespace" {
  type        = string
  default     = "LogsExport"
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
  default     = "Sum"
  description = "The statistic to apply to the alarm's associated metric."
}

variable "threshold" {
  type        = number
  default     = 1
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

variable "filter_name" {
  type        = string
  description = "The name for the alarm's associated metric."
}

variable "filter_pattern" {
  type        = string
  sensitive   = true
}

