locals {

  ConfInfo_SubnetsIds = [
      for idx, cidr in module.vpc_pn_confinfo.intra_subnets_cidr_blocks:
          module.vpc_pn_confinfo.intra_subnets[idx]
            if contains( var.vpc_pn_confinfo_confinfo_subnets_cidrs, cidr)
    ]
  
  ConfInfo_SubnetsCidrs = [
      for idx, cidr in module.vpc_pn_confinfo.intra_subnets_cidr_blocks:
          cidr
            if contains( var.vpc_pn_confinfo_confinfo_subnets_cidrs, cidr)
    ]

  ConfInfo_EgressSubnetsIds = [
      for idx, cidr in module.vpc_pn_confinfo.private_subnets_cidr_blocks:
          module.vpc_pn_confinfo.private_subnets[idx]
            if contains( var.vpc_pn_confinfo_confinfo_egres_subnets_cidrs, cidr)
    ]
  
  ConfInfo_EgressSubnetsCidrs = [
      for idx, cidr in module.vpc_pn_confinfo.private_subnets_cidr_blocks:
          cidr
            if contains( var.vpc_pn_confinfo_confinfo_egres_subnets_cidrs, cidr)
    ]
  
  ConfInfo_NlbEcss_SubnetsIds = [
      for idx, cidr in module.vpc_pn_confinfo.intra_subnets_cidr_blocks:
          module.vpc_pn_confinfo.intra_subnets[idx]
            if contains( var.vpc_pn_confinfo_ecssin_subnets_cidrs, cidr)
    ]
  
  ConfInfo_NlbEcss_SubnetsCidrs = [
      for idx, cidr in module.vpc_pn_confinfo.intra_subnets_cidr_blocks:
          cidr
            if contains( var.vpc_pn_confinfo_ecssin_subnets_cidrs, cidr)
    ]
  
}
