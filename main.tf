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
        expired_object_delete_marker = false
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

## BATCH

data "aws_iam_policy_document" "ec2_assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "ecs_instance_role" {
  name               = "ecs_instance_role"
  assume_role_policy = data.aws_iam_policy_document.ec2_assume_role.json
}

resource "aws_iam_role_policy_attachment" "ecs_instance_role" {
  role       = aws_iam_role.ecs_instance_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}

resource "aws_iam_instance_profile" "ecs_instance_role" {
  name = "ecs_instance_role"
  role = aws_iam_role.ecs_instance_role.name
}

data "aws_iam_policy_document" "batch_assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["batch.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "aws_batch_service_role" {
  name               = "aws_batch_service_role"
  assume_role_policy = data.aws_iam_policy_document.batch_assume_role.json
}

resource "aws_iam_role_policy_attachment" "aws_batch_service_role" {
  role       = aws_iam_role.aws_batch_service_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSBatchServiceRole"
}

resource "aws_security_group" "demult_batch_sg" {
  name        = "demult_batch_sg"
  description = "Allow all egress for public images"
  vpc_id      = module.vpc.vpc_id

  tags = {
    Name = "Test"
  }
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.demult_batch_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}

resource "aws_batch_compute_environment" "igf-pipeline-fargate" {
  compute_environment_name = "${var.name}-fargate"

  compute_resources {
    max_vcpus = 16

    security_group_ids = [
      aws_security_group.demult_batch_sg.id
    ]

    ## USING PUBLIC SUBNET
    subnets = module.vpc.public_subnets

    type = "FARGATE"
  }

  service_role = aws_iam_role.aws_batch_service_role.arn
  type         = "MANAGED"
  depends_on   = [aws_iam_role_policy_attachment.aws_batch_service_role]

  tags = local.tags
}

resource "aws_batch_job_queue" "igf-pipeline-demult" {
  name     = "${var.name}-demult"
  state    = "ENABLED"
  priority = 1

  compute_environment_order {
    order               = 1
    compute_environment = aws_batch_compute_environment.igf-pipeline-fargate.arn
  }
  tags = local.tags
}

resource "aws_iam_role" "ecs_task_execution_role" {
  name               = "${var.name}-_batch_exec_role"
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json
}

data "aws_iam_policy_document" "assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution_role_policy" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_batch_job_definition" "igf-pipeline-bclconvert" {
  name = "${var.name}-bclconvert"
  type = "container"

  deregister_on_new_revision = true

  platform_capabilities = [
    "FARGATE",
  ]

  container_properties = jsonencode({
    command    = ["bcl-convert", "-h"]
    image      = local.bclconvert_image_url

    fargatePlatformConfiguration = {
      platformVersion = "LATEST"
    }

    resourceRequirements = [
      {
        type  = "VCPU"
        value = "0.25"
      },
      {
        type  = "MEMORY"
        value = "512"
      }
    ]

    executionRoleArn = aws_iam_role.ecs_task_execution_role.arn
    jobRoleArn       = aws_iam_role.ecs_task_execution_role.arn

    networkConfiguration = {
      assignPublicIp  = "ENABLED"
    }
  })
}