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

  bclconvert_image_url = "637423521863.dkr.ecr.eu-west-2.amazonaws.com/igf_pipeline-demult/bclconvert:4.3.6"
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

## ECR - demult
resource "aws_ecr_repository" "igf-pipeline-ecr-bclconvert" {
  name                 = "${var.name}-demult/bclconvert"
  image_tag_mutability = "MUTABLE"
  force_delete         = false
  tags                 = local.tags

  image_scanning_configuration {
    scan_on_push = true
  }

  encryption_configuration {
    encryption_type = "AES256"
  }
}

resource "aws_security_group" "demult_batch_sg" {
  name        = "demult_batch_sg"
  description = "place holder"
  vpc_id      = module.vpc.vpc_id

  tags = {
    Name = "TO DO"
  }
}

## BATCH - demult
module "batch-demult-bclconvert" {
  source = "terraform-aws-modules/batch/aws"

  create_instance_iam_role              = true
  #instance_iam_role_additional_policies = []
  #instance_iam_role_description         = null
  instance_iam_role_name                = "${var.name}-demult-instance"
  #instance_iam_role_path                = null
  #instance_iam_role_tags                = local.tags

  create_service_iam_role              = true
  #service_iam_role_additional_policies = []
  #service_iam_role_description         = null
  service_iam_role_name                = "${var.name}-demult-service"
  #service_iam_role_path                = null
  #service_iam_role_tags                = local.tags

  create_spot_fleet_iam_role              = true
  #spot_fleet_iam_role_additional_policies = []
  #spot_fleet_iam_role_description         = null
  spot_fleet_iam_role_name                = "${var.name}-demult-spot-fleet"
  #spot_fleet_iam_role_path                = null
  #spot_fleet_iam_role_tags                = local.tags

  ## BATCH - demult - compute env
  compute_environments = {
    a_fargate_spot = {
      name_prefix = "fargate_spot"

      compute_resources = {
        type      = "FARGATE_SPOT"
        max_vcpus = 16
        subnets   = module.vpc.public_subnets
        security_group_ids = [aws_security_group.demult_batch_sg.id]
        tags      = local.tags
      }
    }
  }

  # BATCH - demult - job queus and scheduling policies
  job_queues = {
    compute_environments = ["a_fargate_spot"]

    tags = {
      JobQueue = "Single job queue"
    }
  }


  ## BATCH - demult - job definitions
  job_definitions = {
    name           = "${var.name}-bclconvert"
    propagate_tags = true

    container_properties = jsonencode({
      image   = local.bclconvert_image_url
      command = ["bcl-convert", "-h"]
      mountPoints = [{
        sourceVolume  = "efs-scratch"
        containerPath = "/mount/efs"
        readOnly      = false
      }]

      volumes = [{
        name = "efs-scratch"
        efsVolumeConfiguration = {
          fileSystemId = module.efs-scratch.id
        }
      }]


      fargatePlatformConfiguration = {
        platformVersion = "LATEST"
      }
      resourceRequirements = [
        { type = "VCPU", value = "1" },
        { type = "MEMORY", value = "4096" }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = "/aws/batch/demult-bclconvert"
          awslogs-region        = var.aws_region
          awslogs-stream-prefix = "ec2"
        }
      }
    })
    attempt_duration_seconds = 3600
    retry_strategy = {
      attempts = 3
      evaluate_on_exit = {
        retry_error = {
          action       = "RETRY"
          on_exit_code = 1
        }
        exit_success = {
          action       = "EXIT"
          on_exit_code = 0
        }
      }
    }

    tags = {
      JobDefinition = "Example"
    }
  }
  tags = local.tags
}