
environment = "interop_prod"
how_many_az = 3
dns_zone = "undefined"
api_domains = []
cdn_domains = []
apigw_custom_domains = []
  
core_aws_account_id = "123"
pn_core_event_bus_arn = "arn:aws:events:eu-central-1:123:event-bus/pn-bb-eb"
pn_confinfo_aws_account_id = "350578575906"
pn_cost_anomaly_detection_email = "pn-irt-team@pagopa.it"
pn_cost_anomaly_detection_threshold = "10"


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


