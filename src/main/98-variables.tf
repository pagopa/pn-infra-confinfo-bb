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
