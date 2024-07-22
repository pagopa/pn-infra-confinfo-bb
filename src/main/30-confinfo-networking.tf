  
module "vpc_pn_confinfo" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.19.0"

  name = var.vpc_pn_confinfo_name
  cidr = var.vpc_pn_confinfo_primary_cidr

  azs                 = local.azs_names
  private_subnets     = var.vpc_pn_confinfo_private_subnets_cidr
  public_subnets      = var.vpc_pn_confinfo_public_subnets_cidr
  intra_subnets       = var.vpc_pn_confinfo_internal_subnets_cidr

  private_subnet_names     = var.vpc_pn_confinfo_private_subnets_names
  public_subnet_names      = var.vpc_pn_confinfo_public_subnets_names
  intra_subnet_names       = var.vpc_pn_confinfo_internal_subnets_names

  create_database_subnet_group = false

  enable_dns_hostnames = true
  enable_dns_support   = true

  enable_nat_gateway = true
  single_nat_gateway = false
  one_nat_gateway_per_az = true

  enable_vpn_gateway = false

  enable_dhcp_options              = false

  # VPC Flow Logs (Cloudwatch log group and IAM role will be created)
  enable_flow_log                      = false
  create_flow_log_cloudwatch_log_group = false
  create_flow_log_cloudwatch_iam_role  = false
  flow_log_max_aggregation_interval    = 60

  tags = { 
    "Code" = "pn-confinfo",
    "Terraform" = "true",
    "Environment" = var.environment
  }
}

resource "aws_security_group" "vpc_pn_confinfo__secgrp_tls" {
  
  name_prefix = "pn-confinfo_vpc-tls-secgrp"
  description = "Allow TLS inbound traffic"
  vpc_id      = module.vpc_pn_confinfo.vpc_id

  tags = {
    "pn-eni-related": "true",
    "pn-eni-related-groupName-regexp": base64encode("^pn-confinfo_vpc-tls-.*$")
  }
  
  ingress {
    description = "TLS from VPC"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [var.vpc_pn_confinfo_primary_cidr]
  }

}

module "vpc_endpoints_pn_confinfo" {
  source = "terraform-aws-modules/vpc/aws//modules/vpc-endpoints"
  version = "3.19.0"

  vpc_id             = module.vpc_pn_confinfo.vpc_id
  security_group_ids = [ aws_security_group.vpc_pn_confinfo__secgrp_tls.id ]
  subnet_ids         = [ 
        for cidr in var.vpc_pn_confinfo_aws_services_interface_endpoints_subnets_cidr:
          module.vpc_pn_confinfo.intra_subnets[
              index( module.vpc_pn_confinfo.intra_subnets_cidr_blocks, cidr )
            ]
      ]
  
  endpoints = merge(
    {
      for svc_name in var.vpc_endpoints_pn_confinfo:
        svc_name => {
          service             = svc_name
          private_dns_enabled = true  
          tags                = { Name = "AWS Endpoint ${svc_name} - pn-confinfo - ${var.environment}"}
        }
    },
    {
      dynamodb = {
        service         = "dynamodb"
        service_type    = "Gateway"
        route_table_ids = flatten([
          module.vpc_pn_confinfo.intra_route_table_ids, 
          module.vpc_pn_confinfo.private_route_table_ids 
        ])
        tags                = { Name = "AWS Endpoint dynamodb - pn-confinfo - ${var.environment}"}
      },
      s3 = {
        service         = "s3"
        service_type    = "Gateway"
        route_table_ids = flatten([
          module.vpc_pn_confinfo.intra_route_table_ids, 
          module.vpc_pn_confinfo.private_route_table_ids 
        ])
        tags                = { Name = "AWS Endpoint s3 - pn-confinfo - ${var.environment}"}
      },
    }
  )
}