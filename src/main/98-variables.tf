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