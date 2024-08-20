
data "aws_availability_zones" "available" {
  state = "available"
}

data "aws_caller_identity" "current" {
}

locals {
  region = data.aws_availability_zones.available.id
  azs_names = slice(data.aws_availability_zones.available.names, 0, var.how_many_az)
}

