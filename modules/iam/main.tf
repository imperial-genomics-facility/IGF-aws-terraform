locals {
  iam_role_prefix = var.iam_role_prefix
}

## ECS Instance Role
data "aws_iam_policy_document" "ec2_assume_role_data" {
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
  name               = "${local.iam_role_prefix}_ecs_instance_role"
  assume_role_policy = data.aws_iam_policy_document.ec2_assume_role_data.json
}

resource "aws_iam_role_policy_attachment" "ecs_instance_role_policy" {
  role       = aws_iam_role.ecs_instance_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}

resource "aws_iam_instance_profile" "ecs_instance_role_profile" {
  name = "${local.iam_role_prefix}_ecs_instance_role_profile"
  role = aws_iam_role.ecs_instance_role.name
}

## Batch Service Role
data "aws_iam_policy_document" "batch_assume_role_data" {
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
  name               = "${local.iam_role_prefix}_aws_batch_service_role"
  assume_role_policy = data.aws_iam_policy_document.batch_assume_role_data.json
}

resource "aws_iam_role_policy_attachment" "aws_batch_service_role_policy" {
  role       = aws_iam_role.aws_batch_service_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSBatchServiceRole"
}

resource "aws_iam_instance_profile" "aws_batch_service_role_profile" {
  name = "${local.iam_role_prefix}_aws_batch_service_role_profile"
  role = aws_iam_role.aws_batch_service_role.name
}

## Job Role
data "aws_iam_policy_document" "batch_job_role_data" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "batch_job_role" {
  name               = "${local.iam_role_prefix}_batch_job_role"
  assume_role_policy = data.aws_iam_policy_document.batch_job_role_data.json
}

resource "aws_iam_role_policy_attachment" "batch_job_role_ec2_role_profile" {
  role       = aws_iam_role.batch_job_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}

resource "aws_iam_role_policy_attachment" "batch_job_role_ecs_task_execution_policy" {
  role       = aws_iam_role.batch_job_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_iam_role_policy_attachment" "batch_job_role_efs_access_policy" {
  role       = aws_iam_role.batch_job_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonElasticFileSystemClientReadWriteAccess"
}

resource "aws_iam_role_policy_attachment" "batch_job_role_s3_access_policy" {
  role       = aws_iam_role.batch_job_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

resource "aws_iam_instance_profile" "batch_job_role_profile" {
  name = "${local.iam_role_prefix}_batch_job_role_profile"
  role = aws_iam_role.batch_job_role.name
}

## Execution Role
data "aws_iam_policy_document" "batch_execution_role_data" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "batch_execution_role" {
  name               = "${local.iam_role_prefix}_batch_execution_role"
  assume_role_policy = data.aws_iam_policy_document.batch_execution_role_data.json
}

resource "aws_iam_role_policy_attachment" "batch_execution_role_ec2_role_policy" {
  role       = aws_iam_role.batch_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}

resource "aws_iam_role_policy_attachment" "batch_execution_role_task_execution_policy" {
  role       = aws_iam_role.batch_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_iam_instance_profile" "batch_execution_role_profile" {
  name = "${local.iam_role_prefix}_batch_execution_role_profile"
  role = aws_iam_role.batch_execution_role.name
}

## SPOT fleet role
data "aws_iam_policy_document" "batch_spot_fleet_tagging_role_data" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["spotfleet.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "batch_spot_fleet_tagging_role" {
  name               = "${local.iam_role_prefix}_batch_spot_fleet_tagging_role"
  assume_role_policy = data.aws_iam_policy_document.batch_spot_fleet_tagging_role_data.json
}

resource "aws_iam_role_policy_attachment" "batch_spot_fleet_tagging_role_policy" {
  role       = aws_iam_role.batch_spot_fleet_tagging_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2SpotFleetTaggingRole"
}

resource "aws_iam_instance_profile" "batch_spot_fleet_tagging_role_profile" {
  name = "${local.iam_role_prefix}_batch_spot_fleet_tagging_role_profile"
  role = aws_iam_role.batch_spot_fleet_tagging_role.name
}