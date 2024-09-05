provider "aws" {
  region = var.aws_region
}

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
  azs  = slice(data.aws_availability_zones.available.names, 0, 1)
  tags = merge(var.resource_tags, local.required_tags)

  private_subnets = slice(var.private_subnet_cidr_blocks, 0, 1)
  public_subnets  = slice(var.public_subnet_cidr_blocks, 0, 1)
}

## VPC
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.13.0"

  cidr                   = var.vpc_cidr_block
  azs                    = local.azs
  private_subnets        = local.private_subnets
  public_subnets         = local.public_subnets
  enable_nat_gateway     = var.enable_nat_gateway
  enable_vpn_gateway     = var.enable_vpn_gateway
  create_egress_only_igw = var.create_egress_only_igw
  create_igw             = var.create_igw
  enable_ipv6            = var.enable_ipv6
  name                   = var.name
  tags                   = local.tags
}

## S3
module "s3_bucket_raw_runs" {
  source = "terraform-aws-modules/s3-bucket/aws"

  bucket                   = var.s3_raw_run_bucket_id
  acl                      = "private"
  force_destroy            = false
  block_public_acls        = true
  tags                     = local.tags
  control_object_ownership = true
  object_ownership         = "ObjectWriter"

  versioning = {
    enabled = true
  }

  # lifecycle rules
  lifecycle_rule = [
    {
      id      = "lifecycle-runs"
      enabled = true

      abort_incomplete_multipart_upload_days = 7

      filter = {
        prefix = "runs/"
      }

      expiration = {
        days                         = 30
        expired_object_delete_marker = true
      }

      noncurrent_version_expiration = {
        days = 7
      }
    }
  ]
}

## EFS
module "efs-scratch" {
  source  = "terraform-aws-modules/efs/aws"
  version = "1.6.3"

  ## vpc
  availability_zone_name = local.azs[0]
  # File system
  name             = "${var.name}-scratch-storage"
  encrypted        = true
  throughput_mode  = "elastic"
  performance_mode = "generalPurpose"
  create           = true

  # Backup policy
  enable_backup_policy = true

  # Replication configuration
  create_replication_configuration = false
  tags                             = local.tags
  # Mount targets / security group
  create_security_group      = true
  mount_targets              = { for k, v in zipmap(local.azs, module.vpc.public_subnets) : k => { subnet_id = v } }
  security_group_description = "EFS security group for pipeline run"
  security_group_vpc_id      = module.vpc.vpc_id

  security_group_rules = {
    vpc = {
      description = "NFS ingress from VPC public subnets"
      cidr_blocks = module.vpc.public_subnets_cidr_blocks
    }
  }
}