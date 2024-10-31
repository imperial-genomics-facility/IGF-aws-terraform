## DATA
data "aws_availability_zones" "available" {
  state = "available"
}

## LOCALS
locals {
  required_tags = {
    project     = var.project_name
    environment = var.environment
  }
  vpc_cidr_block     = var.vpc_cidr_block
  enable_nat_gateway = var.enable_nat_gateway
  enable_vpn_gateway = var.enable_vpn_gateway
  vpc_name           = var.vpc_name
  aws_region         = var.aws_region

  public_subnet_cidr_blocks  = var.public_subnet_cidr_blocks
  private_subnet_cidr_blocks = var.private_subnet_cidr_blocks

  private_subnets = slice(local.private_subnet_cidr_blocks, 0, 1)
  public_subnets  = slice(local.public_subnet_cidr_blocks, 0, 1)

  azs  = slice(data.aws_availability_zones.available.names, 0, 1)
  tags = merge(var.resource_tags, local.required_tags)
}

## VPC
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.13.0"

  cidr                   = local.vpc_cidr_block
  azs                    = local.azs
  private_subnets        = local.private_subnets
  public_subnets         = local.public_subnets
  enable_nat_gateway     = local.enable_nat_gateway
  enable_vpn_gateway     = local.enable_vpn_gateway
  create_egress_only_igw = var.create_egress_only_igw
  create_igw             = var.create_igw
  enable_ipv6            = var.enable_ipv6
  name                   = var.vpc_name
  tags                   = local.tags
}

resource "aws_security_group" "endpoint_security_group" {
  name        = "endpoint_security_group"
  description = "Endpoint security group"
  vpc_id      = module.vpc.vpc_id

  dynamic "ingress" {
    for_each = local.private_subnets
    content {
      from_port      = 443
      protocol       = "tcp"
      to_port        = 443
      cidr_blocks    = [ingress.value]
    }
  }
}

resource "aws_vpc_security_group_egress_rule" "endpoint_security_group" {
  security_group_id = aws_security_group.endpoint_security_group.id

  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}


resource "aws_vpc_endpoint" "batch-test-endpoint" {
  vpc_id            = module.vpc.vpc_id
  service_name      = "com.amazonaws.${local.aws_region}.batch"
  vpc_endpoint_type = "Interface"

  subnet_ids = module.vpc.public_subnets
  security_group_ids = [
    aws_security_group.endpoint_security_group.id
  ]
  tags = tags
}

resource "aws_vpc_endpoint" "ecr-dkr-test-endpoint" {
  vpc_id            = module.vpc.vpc_id
  service_name      = "com.amazonaws.${local.aws_region}.ecr.dkr"
  vpc_endpoint_type = "Interface"

  subnet_ids = module.vpc.public_subnets
  security_group_ids = [
    aws_security_group.endpoint_security_group.id
  ]
  tags = tags
}

resource "aws_vpc_endpoint" "ecr-api-test-endpoint" {
  vpc_id            = module.vpc.vpc_id
  service_name      = "com.amazonaws.${local.aws_region}.ecr.api"
  vpc_endpoint_type = "Interface"

  subnet_ids = module.vpc.public_subnets
  security_group_ids = [
    aws_security_group.endpoint_security_group.id
  ]
  tags = tags
}

resource "aws_vpc_endpoint" "logs-test-endpoint" {
  vpc_id            = module.vpc.vpc_id
  service_name      = "com.amazonaws.${local.aws_region}.logs"
  vpc_endpoint_type = "Interface"

  subnet_ids = module.vpc.public_subnets
  security_group_ids = [
    aws_security_group.endpoint_security_group.id
  ]
  tags = tags
}

resource "aws_vpc_endpoint" "ecs-test-endpoint" {
  vpc_id            = module.vpc.vpc_id
  service_name      = "com.amazonaws.${local.aws_region}.ecs"
  vpc_endpoint_type = "Interface"

  subnet_ids = module.vpc.public_subnets
  security_group_ids = [
    aws_security_group.endpoint_security_group.id
  ]
  tags = tags
}

resource "aws_vpc_endpoint" "ecs-agent-test-endpoint" {
  vpc_id            = module.vpc.vpc_id
  service_name      = "com.amazonaws.${local.aws_region}.ecs-agent"
  vpc_endpoint_type = "Interface"

  subnet_ids = module.vpc.public_subnets
  security_group_ids = [
    aws_security_group.endpoint_security_group.id
  ]
  tags = tags
}

resource "aws_vpc_endpoint" "ecs-telemetry-test-endpoint" {
  vpc_id            = module.vpc.vpc_id
  service_name      = "com.amazonaws.${local.aws_region}.ecs-telemetry"
  vpc_endpoint_type = "Interface"

  subnet_ids = module.vpc.public_subnets
  security_group_ids = [
    aws_security_group.endpoint_security_group.id
  ]
  tags = tags
}

resource "aws_vpc_endpoint" "s3-test-endpoint" {
  vpc_id            = module.vpc.vpc_id
  service_name      = "com.amazonaws.${local.aws_region}.s3"
  vpc_endpoint_type = "Gateway"

  route_table_ids  = module.vpc.private_route_table_ids
  tags = tags
}