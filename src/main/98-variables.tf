variable "aws_region" {
  type        = string
  description = "AWS region to create resources. Default Milan"
  default     = "eu-south-1"
}

variable "environment" {
  type        = string
  default     = "dev"
  description = "Environment"
}

variable "how_many_az" {
  type        = number
  default     = 3
  description = "How many Availability Zone we have to use"
}

variable "core_aws_account_id" {
  type        = string
  description = "core current environment AWS Account id"
}

variable "pn_confinfo_aws_account_id" {
  type        = string
  description = "pn-confidential current environment AWS Account id"
}

variable "vpc_pn_confinfo_aws_services_interface_endpoints_subnets_cidr" {
  type        = list(string)
  description = "AWS services interfaces endpoints list of cidr."
}


variable "vpc_pn_confinfo_name" {
  type        = string
  description = "Name of the PN Confidential Informations VPC"
}

variable "vpc_pn_confinfo_primary_cidr" {
  type        = string
  description = "Primary CIDR of the PN Confidential Informations VPC"
}


variable "vpc_pn_confinfo_private_subnets_cidr" {
  type        = list(string)
  description = "Private subnets list of cidr."
}
variable "vpc_pn_confinfo_private_subnets_names" {
  type        = list(string)
  description = "Private subnets list of names."
}

variable "vpc_pn_confinfo_public_subnets_cidr" {
  type        = list(string)
  description = "Private subnets list of cidr."
}
variable "vpc_pn_confinfo_public_subnets_names" {
  type        = list(string)
  description = "Private subnets list of names."
}

variable "vpc_pn_confinfo_internal_subnets_cidr" {
  type        = list(string)
  description = "Internal subnets list of cidr"
}
variable "vpc_pn_confinfo_internal_subnets_names" {
  type        = list(string)
  description = "Internal subnets list of names"
}



variable "vpc_endpoints_pn_confinfo" {
  type        = list(string)
  description = "Endpoint List"
}

variable "vpc_pn_confinfo_confinfo_subnets_cidrs" {
  type        = list(string)
  description = "Cidr list of Confinfo subnets in VPC pn-confinfo"
}

variable "vpc_pn_confinfo_confinfo_egres_subnets_cidrs" {
  type        = list(string)
  description = "Cidr list of EgressConfinfo subnets in VPC pn-confinfo"
}

variable "vpc_pn_confinfo_ecssin_subnets_cidrs" {
  type        = list(string)
  description = "Cidr list of ExternalChannel and SafeStorage Ingress subnets in VPC pn-confinfo"
}

variable "pn_cost_anomaly_detection_email" {
  type        = string
  description = "pn-core cost anomaly detection email"
}

variable "pn_cost_anomaly_detection_threshold" {
  type        = string
  description = "pn-core cost anomaly detection threshold (percentage)"
}

variable "core_event_bus_arn" {
  type        = string
  description = "core account event bus arn"
}

variable "ProjectName" {
  type        = string
  default     = "pn"
  description = "Project Name"
}

#s3 buckets variables
variable "pn_logs_bucket_name" {
  type        = string
  description = "name of logs s3 bucket"
}

variable "pn_runtime_env_bucket_name" {
  type        = string
  description = "name of runtime environment variable s3 bucket"
}

#CdcKinesisStream Kinesis variables

variable "pn_cdc_kinesis_stream_name" {
  description = "CdcKinesisStream-name"
  type        = string
  default     = "pn_confinfo_CdcKinesisStream"
}

variable "pn_cdc_kinesis_stream_retention_hours" {
  description = "Change Data Capture Kinesis Data Stream retention period in hours"
  type        = number
  default     = 24
}

variable "pn_cdc_kinesis_stream_shard_count" {
  description = "Number of shards in the stream"
  type        = number
  default     = 0
}

variable "pn_cdc_kinesis_stream_mode" {
  description = "Stream Mode. ON_DEMAND, PROVISIONED]"
  type        = string
  default     = "ON_DEMAND"
}

#LogsKinesisStream Kinesis variables

variable "pn_logs_kinesis_stream_name" {
  description = "CdcKinesisStream-name"
  type        = string
  default     = "pn_confinfo_LogsKinesisStream"
}

variable "pn_logs_kinesis_stream_retention_hours" {
  description = "Change Data Capture Kinesis Data Stream retention period in hours"
  type        = number
  default     = 24
}

variable "pn_logs_kinesis_stream_shard_count" {
  description = "Number of shards in the stream"
  type        = number
  default     = 0
}

variable "pn_logs_kinesis_stream_mode" {
  description = "Stream Mode. ON_DEMAND, PROVISIONED]"
  type        = string
  default     = "ON_DEMAND"
}

variable "pn_alarm_topic_name" {
  description = "AlarmSNSTopic-name"
  type        = string
  default     = "AlarmSNSTopic"
}

variable "pn_logs_retention_days" {
  description = "Logs retention in days"
  type        = number
  default     = 14
}

variable "pn_logs_kinesis_stream_alarm_threshold" {
  description = "Logs Kinesis Stream Alarm Threshold"
  type        = number
  default     = 3600000
}

variable "pn_logs_kinesis_stream_oncall_alarm_threshold" {
  description = "Logs Kinesis Stream Oncall Alarm Threshold"
  type        = number
  default     = 216000000
}

variable "pn_cdc_kinesis_stream_alarm_threshold" {
  description = "Cdc Kinesis Stream Alarm Threshold"
  type        = number
  default     = 3600000
}

variable "pn_cdc_kinesis_stream_oncall_alarm_threshold" {
  description = "Cdc Kinesis Stream Oncall Alarm Threshold"
  type        = number
  default     = 43200000
}

variable "pn_event_bus_dlq_maximum_retention_period" {
  description = "EventBus DeadLetterQueue Maximum Retention Period"
  type        = number
  default     = 1209600
}

variable "pn_event_bus_oncall_dlq_ratio" {
  description = "EventBus OnCall DeadLetterQueue Ratio"
  type        = number
  default     = 0.1
}

## BACKUP

variable "pn_backup_completion_window" {
  description = "Backup completion window in minutes"
  type        = number
  default     = 600
}

variable "pn_backup_start_window" {
  description = "Backup start window in minutes"
  type        = number
  default     = 60
}

variable "pn_backup_cron_expression" {
  description = "Backup cron expression"
  type        = string
  default     = "cron(0 4 * * ? *)"
}

variable "pn_backup_delete_after" {
  description = "Backup delete after in days"
  type        = number
  default     = 35
}