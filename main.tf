provider "aws" {
  region = var.aws_region
}

## LOCALS
locals {
  required_tags = {
    project     = var.project_name
    environment = var.environment
  }
}

## DATA
data "aws_availability_zones" "available" {
  state = "available"
}

## VPC
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.13.0"

  cidr = var.vpc_cidr_block

  azs             = data.aws_availability_zones.available.names
  private_subnets = var.private_subnet_cidr_blocks
  public_subnets  = var.public_subnet_cidr_blocks

  enable_nat_gateway     = var.enable_nat_gateway
  enable_vpn_gateway     = var.enable_vpn_gateway
  create_egress_only_igw = var.create_egress_only_igw
  create_igw             = var.create_igw
  enable_ipv6            = var.enable_ipv6
  name                   = var.name

  tags = merge(var.resource_tags, local.required_tags)
}

## S3
module "s3_bucket_raw_runs" {
  source = "terraform-aws-modules/s3-bucket/aws"

  bucket = var.s3_raw_run_bucket_id
  acl    = "private"

  force_destroy = false
  block_public_acls = true

  control_object_ownership = true
  object_ownership         = "ObjectWriter"

  versioning = {
    enabled = true
  }
  
  tags = merge(var.resource_tags, local.required_tags)

  lifecycle_rule = [
    {
      id      = "lifecycle-runs"
      enabled = true
      filter = {
        prefix = "runs/"
      }

      expiration = {
        days = 30
        expired_object_delete_marker = true
      }

      noncurrent_version_expiration = {
        days = 7
      }
    }
  ]
}