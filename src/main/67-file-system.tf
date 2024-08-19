#EFS

resource "aws_security_group" "EFSSecurityGroup" {
  name        = "EFSSecurityGroup"
  description = "EFS Security Group"
  vpc_id      =  module.vpc_pn_confinfo.vpc_id
}

resource "aws_vpc_security_group_ingress_rule" "EFSSecurityGroup" {
  security_group_id = aws_security_group.EFSSecurityGroup.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 2049
  ip_protocol       = "tcp"
  to_port           = 2049
}

resource "aws_efs_file_system" "FargateEFSFileSystem" {
  encrypted =  true
  throughput_mode = "bursting" 
  performance_mode = "generalPurpose"

  tags = {
    Name = "Fargate-EFS"
  }
}

resource "aws_efs_mount_target" "MountFargateEfsTarget" {
  for_each = toset(local.ConfInfo_SubnetsIds)
  file_system_id = aws_efs_file_system.FargateEFSFileSystem.id
  subnet_id      = each.value
  security_groups = [aws_security_group.EFSSecurityGroup.id]
}
