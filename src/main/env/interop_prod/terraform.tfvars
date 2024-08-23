
environment = "interop_prod"
how_many_az = 3
dns_zone = "undefined"
api_domains = []
cdn_domains = []
apigw_custom_domains = []
  
core_aws_account_id = "697818730278"
pn_core_event_bus_arn = "arn:aws:events:eu-central-1:697818730278:event-bus/pn-bb-eb"
pn_confinfo_aws_account_id = "730335668132"
pn_cost_anomaly_detection_email = "pn-irt-team@pagopa.it"
pn_cost_anomaly_detection_threshold = "10"
pn_logs_retention_days = "180"
pn_alarm_topic_name = "once-prod-AlarmTopic"
pn_logs_bucket_name = "pn-logs-bucket-eu-south-1-730335668132-001"
pn_runtime_env_bucket_name = "pn-runtime-environment-variables-eu-south-1-730335668132"
pn_cd_bucket_name = "cd-confinfo-pipeline-cdartifactbucket-eu-south-1-730335668132"
pn_cdc_kinesis_stream_name = "pn-confidential-cdc-source-stream"
pn_cdc_kinesis_stream_retention_hours = "96"
pn_cdc_kinesis_stream_shard_count = "0"
pn_cdc_kinesis_stream_mode = "ON_DEMAND"
pn_logs_kinesis_stream_name = "pn-confidential-logs-source-stream"
pn_logs_kinesis_stream_retention_hours = "96"
pn_logs_kinesis_stream_shard_count = "0"
pn_logs_kinesis_stream_mode = "ON_DEMAND"
pn_backup_delete_after = "35"
pn_backup_cron_expression = "cron(0 4 * * ? *)"
pn_backup_start_window = "60"
pn_macro_service_name = "pn-confinfo-bb"
pn_ss_bucket_name = "pn-safestorage-eu-south-1-730335668132"


vpc_pn_confinfo_name = "PN ConfInfo BB"
vpc_pn_confinfo_primary_cidr = "10.11.0.0/16"
vpc_pn_confinfo_aws_services_interface_endpoints_subnets_cidr = ["10.11.50.0/24","10.11.51.0/24","10.11.52.0/24"]
vpc_endpoints_pn_confinfo = ["sqs","logs","sns","kms","kinesis-streams","elasticloadbalancing","events","ecr.api","ecr.dkr","ssmmessages","ssm","ec2messages","ecs-agent","ecs-telemetry","ecs","secretsmanager","monitoring","xray"]

vpc_pn_confinfo_private_subnets_cidr = ["10.11.10.0/24","10.11.11.0/24","10.11.12.0/24"]
vpc_pn_confinfo_private_subnets_names = ["PN ConfInfo BB - ConfInfo Egress Subnet (interop_prod) AZ 0","PN ConfInfo BB - ConfInfo Egress Subnet (interop_prod) AZ 1","PN ConfInfo BB - ConfInfo Egress Subnet (interop_prod) AZ 2"]
vpc_pn_confinfo_public_subnets_cidr = ["10.11.1.0/28","10.11.1.16/28","10.11.1.32/28"]
vpc_pn_confinfo_public_subnets_names = ["PN ConfInfo BB - Public Subnet (interop_prod) AZ 0","PN ConfInfo BB - Public Subnet (interop_prod) AZ 1","PN ConfInfo BB - Public Subnet (interop_prod) AZ 2"]
vpc_pn_confinfo_internal_subnets_cidr = ["10.11.3.0/28","10.11.3.16/28","10.11.3.32/28","10.11.30.0/24","10.11.31.0/24","10.11.32.0/24","10.11.50.0/24","10.11.51.0/24","10.11.52.0/24"]
vpc_pn_confinfo_internal_subnets_names = ["PN ConfInfo BB - ExternalChannels SafeStorage Ingress Subnet (interop_prod) AZ 0","PN ConfInfo BB - ExternalChannels SafeStorage Ingress Subnet (interop_prod) AZ 1","PN ConfInfo BB - ExternalChannels SafeStorage Ingress Subnet (interop_prod) AZ 2","PN ConfInfo BB - ConfInfo Subnet (interop_prod) AZ 0","PN ConfInfo BB - ConfInfo Subnet (interop_prod) AZ 1","PN ConfInfo BB - ConfInfo Subnet (interop_prod) AZ 2","PN ConfInfo BB - AWS Services Subnet (interop_prod) AZ 0","PN ConfInfo BB - AWS Services Subnet (interop_prod) AZ 1","PN ConfInfo BB - AWS Services Subnet (interop_prod) AZ 2"]

vpc_pn_confinfo_ecssin_subnets_cidrs = ["10.11.3.0/28","10.11.3.16/28","10.11.3.32/28"]
vpc_pn_confinfo_confinfo_egres_subnets_cidrs = ["10.11.10.0/24","10.11.11.0/24","10.11.12.0/24"]
vpc_pn_confinfo_confinfo_subnets_cidrs = ["10.11.30.0/24","10.11.31.0/24","10.11.32.0/24"]


