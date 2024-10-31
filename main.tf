provider "aws" {
  region = var.aws_region
}

## create vpc, subnets and endpoints
module "igf_vpc" {
  source = "./modules/vpc"

  project_name = var.project_name
  environment  = var.environment
  vpc_name     = var.vpc_name
  aws_region   = var.aws_region
  create_igw   = var.create_igw
  enable_ipv6  = var.enable_ipv6

  vpc_cidr_block     = var.vpc_cidr_block
  enable_nat_gateway = var.enable_nat_gateway
  enable_vpn_gateway = var.enable_vpn_gateway
  resource_tags      = var.resource_tags

  public_subnet_cidr_blocks  = var.public_subnet_cidr_blocks
  private_subnet_cidr_blocks = var.private_subnet_cidr_blocks
}

## create s3 buckets
module "igf_s3_bucket" {
  source = "./modules/s3_bucket"
}

