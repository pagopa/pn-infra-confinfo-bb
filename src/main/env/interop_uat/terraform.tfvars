
environment = "interop_uat"
how_many_az = 3
dns_zone = "undefined"
api_domains = []
cdn_domains = []
apigw_custom_domains = []
  
core_aws_account_id = "895646477129"
pn_core_event_bus_arn = "arn:aws:events:eu-central-1:895646477129:event-bus/pn-bb-eb"
pn_confinfo_aws_account_id = "891377202032"
pn_cost_anomaly_detection_email = "pn-irt-team@pagopa.it"
pn_cost_anomaly_detection_threshold = "10"
pn_logs_retention_days = "14"
pn_alarm_topic_name = "once-uat-AlarmTopic"
pn_logs_bucket_name = "pn-logs-bucket-eu-south-1-891377202032-001"
pn_runtime_env_bucket_name = "pn-runtime-environment-variables-eu-south-1-891377202032"
pn_cdc_kinesis_stream_name = "pn-confidential-cdc-source-stream"
pn_cdc_kinesis_stream_retention_hours = "72"
pn_cdc_kinesis_stream_shard_count = "0"
pn_cdc_kinesis_stream_mode = "ON_DEMAND"
pn_logs_kinesis_stream_name = "pn-confidential-logs-source-stream"
pn_logs_kinesis_stream_retention_hours = "72"
pn_logs_kinesis_stream_shard_count = "0"
pn_logs_kinesis_stream_mode = "ON_DEMAND"


vpc_pn_confinfo_name = "PN ConfInfo BB"
vpc_pn_confinfo_primary_cidr = "10.8.0.0/16"
vpc_pn_confinfo_aws_services_interface_endpoints_subnets_cidr = ["10.8.50.0/24","10.8.51.0/24","10.8.52.0/24"]
vpc_endpoints_pn_confinfo = ["sqs","logs","sns","kms","kinesis-streams","elasticloadbalancing","events","ecr.api","ecr.dkr","ssmmessages","ssm","ec2messages","ecs-agent","ecs-telemetry","ecs","secretsmanager","monitoring","xray"]

vpc_pn_confinfo_private_subnets_cidr = ["10.8.10.0/24","10.8.11.0/24","10.8.12.0/24"]
vpc_pn_confinfo_private_subnets_names = ["PN ConfInfo BB - ConfInfo Egress Subnet (interop_uat) AZ 0","PN ConfInfo BB - ConfInfo Egress Subnet (interop_uat) AZ 1","PN ConfInfo BB - ConfInfo Egress Subnet (interop_uat) AZ 2"]
vpc_pn_confinfo_public_subnets_cidr = ["10.8.1.0/28","10.8.1.16/28","10.8.1.32/28"]
vpc_pn_confinfo_public_subnets_names = ["PN ConfInfo BB - Public Subnet (interop_uat) AZ 0","PN ConfInfo BB - Public Subnet (interop_uat) AZ 1","PN ConfInfo BB - Public Subnet (interop_uat) AZ 2"]
vpc_pn_confinfo_internal_subnets_cidr = ["10.8.3.0/28","10.8.3.16/28","10.8.3.32/28","10.8.30.0/24","10.8.31.0/24","10.8.32.0/24","10.8.50.0/24","10.8.51.0/24","10.8.52.0/24"]
vpc_pn_confinfo_internal_subnets_names = ["PN ConfInfo BB - ExternalChannels SafeStorage Ingress Subnet (interop_uat) AZ 0","PN ConfInfo BB - ExternalChannels SafeStorage Ingress Subnet (interop_uat) AZ 1","PN ConfInfo BB - ExternalChannels SafeStorage Ingress Subnet (interop_uat) AZ 2","PN ConfInfo BB - ConfInfo Subnet (interop_uat) AZ 0","PN ConfInfo BB - ConfInfo Subnet (interop_uat) AZ 1","PN ConfInfo BB - ConfInfo Subnet (interop_uat) AZ 2","PN ConfInfo BB - AWS Services Subnet (interop_uat) AZ 0","PN ConfInfo BB - AWS Services Subnet (interop_uat) AZ 1","PN ConfInfo BB - AWS Services Subnet (interop_uat) AZ 2"]

vpc_pn_confinfo_ecssin_subnets_cidrs = ["10.8.3.0/28","10.8.3.16/28","10.8.3.32/28"]
vpc_pn_confinfo_confinfo_egres_subnets_cidrs = ["10.8.10.0/24","10.8.11.0/24","10.8.12.0/24"]
vpc_pn_confinfo_confinfo_subnets_cidrs = ["10.8.30.0/24","10.8.31.0/24","10.8.32.0/24"]


