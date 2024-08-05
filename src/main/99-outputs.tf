
output "ConfInfo_VpcId" {
  value = module.vpc_pn_confinfo.vpc_id
  description = "Id della VPC contenete i microservizi di PN che trattano informazioni Personali"
}

output "ConfInfo_VpcCidr" {
  value = var.vpc_pn_confinfo_primary_cidr
  description = "CIDR della VPC contenete i microservizi di PN che trattano informazioni Personali"
}

output "ConfInfo_EcsDefaultSecurityGroup" {
  value = ""
  description = "Default security group for ECS services"
}

output "ConfInfo_PnVPCDefaultSecurityGroup" {
  value = module.vpc_pn_confinfo.default_security_group_id
  description = "Default VPC security group"
}

output "ConfInfo_VpcEndpointsRequired" { 
  value       = "false"
  description = "AWS services endpoints already created"
}


output "ConfInfo_VpcSubnets" {
  value = local.ConfInfo_SubnetsIds
}

output "ConfInfo_VpcSubnetsCidrs" {
  value = local.ConfInfo_SubnetsCidrs
}

output "ConfInfo_VpcEgressSubnetsIds" {
  value = local.ConfInfo_EgressSubnetsIds
}

output "ConfInfo_VpcEgressSubnetsCidrs" {
  value = local.ConfInfo_EgressSubnetsCidrs
}


output "ConfInfo_ApplicationLoadBalancerArn" {
  value = aws_lb.pn_confinfo_ecs_alb.arn
  description = "ECS cluster Application Load Balancer ARN, attach microservice listeners here"
}

output "ConfInfo_ApplicationLoadBalancerMetricsDimensionName" {
  value = replace( aws_lb.pn_confinfo_ecs_alb.arn, "/.*:[0-9]{12}:loadbalancer.app.(.*)/", "app/$1")
  description = "ECS cluster Application Load Balancer name used for metrics"
}


output "ConfInfo_ApplicationLoadBalancerAwsDns" {
  value = aws_lb.pn_confinfo_ecs_alb.dns_name 
  description = "ECS cluster Application Load Balancer AWS released DNS, can be used to call microservices"
}

output "ConfInfo_ApplicationLoadBalancerAwsDnsZoneId" {
  value = aws_lb.pn_confinfo_ecs_alb.zone_id 
  description = "ECS cluster Application Load Balancer AWS hosted Zone, usefull for aliases"
}

output "ConfInfo_ApplicationLoadBalancerListenerArn" {
  value = aws_lb_listener.pn_confinfo_ecs_alb_8080.arn
  description = "ECS cluster Application Load Balancer Listener ARN, attach here new microservice routing rule"
}


output "ConfInfo_WebappSecurityGroupId" {
  value = aws_security_group.vpc_pn_confinfo__secgrp_webapp.id
  description = "WebApp security group id"
}

output "ConfInfo_WebappSecurityGroupArn" {
  value = aws_security_group.vpc_pn_confinfo__secgrp_webapp.arn
  description = "WebApp security group ARN"
}

output "ConfInfo_ServiceEndpoint_ToExternalChannelSafeStorage" {
  value = aws_vpc_endpoint_service.pn_confinfo_ecssin_endpoint_svc.service_name
  description = "Service endpoint for External Channel and Safe storage connections"
}

output "ConfInfo_CoreAwsAccountId" {
  value = var.core_aws_account_id
  description = "AWS account id of core. Usefull for resource policy and EventBridge Routes"
}

output "ConfInfo_PnCoreTargetEventBus" {
  value = var.core_event_bus_arn
  description = "core event bridge bus"
}

output "ConfInfo_AlarmSNSTopicArn" {
  value = aws_sns_topic.sns_pn_confinfo_sns_topic.arn
  description = "Alarm SNS Topic ARN"
}

output "ConfInfo_AlarmSNSTopicName" {
  value = aws_sns_topic.sns_pn_confinfo_sns_topic.name
  description = "Alarm SNS Topic Name"
}

output "ConfInfo_CdcKinesisStreamArn" {
  value = aws_kinesis_stream.stream.arn
  description = "CDC Kinesis Stream ARN"
}

output "ConfInfo_CdcKinesisStreamName" {
  value = aws_kinesis_stream.stream.name
  description = "CDC Kinesis Stream Name"
}

output "ConfInfo_CdcKinesisStreamKeyArn" {
  value = aws_kms_key.kms_pn_confinfo_CdcKinesisServerSideEncryptionKey.arn
  description = "CDC Kinesis Stream Key ARN"
}

output "ConfInfo_LogsBucketKmsKeyArn" {
  value = aws_kms_key.kms_pn_confinfo_LogsBucket.arn
  description = "Logs Bucket KMS Key ARN"
}

output "ConfInfo_LogsBucketName" {
  value = var.pn_logs_bucket_name
  description = "Logs Bucket Name"
} 

output "ConfInfo_LogsKinesisStreamArn" {
  value = module.kinesis_pn_confinfo_CdcKinesisStream.stream_arn
  description = "Logs Kinesis Stream ARN"
}

output "ConfInfo_LogsKinesisStreamName" {
  value = module.kinesis_pn_confinfo_CdcKinesisStream.stream_name
  description = "Logs Kinesis Stream Name"
}

output "ConfInfo_LogsKinesisStreamKeyArn" {
  value = aws_kms_key.kms_pn_confinfo_CdcKinesisServerSideEncryptionKey.arn
  description = "Logs Kinesis Stream Key ARN"
}

output "ConfInfo_LogRetention" {
  value = var.pn_logs_retention_days
  description = "Logs retention in days"
}

#EFS 
output "ConfInfo_FargateEFSFileSystemID" {
  value = aws_efs_file_system.pn_confinfo_fargate_efs.id
  description = "Fargate EFS File System ID"
}


# Confinfo Event Bus
  output "ConfInfo_ConfinfoEventBusName" {
    value = aws_cloudwatch_event_bus.pn_confinfo_event_bus.name
    description = "Confinfo Event Bus Name"
  }

  output "ConfInfo_ConfinfoEventBusArn" {
    value = aws_cloudwatch_event_bus.pn_confinfo_event_bus.arn
    description = "Confinfo Event Bus Arn"
  }

  output "ConfInfo_EventBusDeadLetterQueueArn" {
    value = aws_sqs_queue.pn_confinfo_event_bus_dead_letter_queue.arn
    description = "Event Bus Dead Letter Queue Arn"
  }

  output "ConfInfo_EventBusDeadLetterQueueUrl" {
    value = aws_sqs_queue.pn_confinfo_event_bus_dead_letter_queue.id
    description = "Event Bus Dead Letter Queue Url"
  }

  output "ConfInfo_EventBusDeadLetterQueueName" {
    value = aws_sqs_queue.pn_confinfo_event_bus_dead_letter_queue.name
    description = "Event Bus Dead Letter Queue Name"
  }
