## LOCALS
locals {
  required_tags = {
    project     = var.project_name
    environment = var.environment
  }
  tags    = merge(var.resource_tags, local.required_tags)
  ami_id  = var.ami_id
  subnets = var.subnets
  vpc_id  = var.vpc_id

  image_type            = var.image_type
  service_role_arn      = var.service_role_arn
  ecs_instance_role_arn = var.ecs_instance_role_arn
  service_role_name     = var.service_role_name
  spot_iam_fleet_role   = var.spot_iam_fleet_role

  service_role_profile_arn = var.service_role_profile_arn
}

resource "aws_security_group" "demult_batch_sg_ec2" {
  name        = "demult_batch_sg_ec2"
  description = "Allow all egress for public images"
  vpc_id      = local.vpc_id

  tags = {
    Name = "Test"
  }
}

resource "aws_vpc_security_group_egress_rule" "ec2_allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.demult_batch_sg_ec2.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}

resource "aws_placement_group" "batch_env_ec2" {
  name     = "batch_env_ec2"
  strategy = "cluster"
}

resource "aws_batch_compute_environment" "batch_env_ec2" {
  compute_environment_name = "batch_env_ec2"

  compute_resources {
    instance_role       = local.ecs_instance_role_arn
    allocation_strategy = "SPOT_PRICE_CAPACITY_OPTIMIZED"
    instance_type       = ["optimal"]
    placement_group     = aws_placement_group.batch_env_ec2.name
    security_group_ids = [
      aws_security_group.demult_batch_sg_ec2.id,
    ]
    max_vcpus = 16
    min_vcpus = 0
    subnets   = local.subnets
    type      = "SPOT"
    spot_iam_fleet_role = local.spot_iam_fleet_role
    ec2_configuration {
        image_type        = local.image_type
        image_id_override = local.ami_id
      }
  }

  service_role = local.service_role_arn
  type         = "MANAGED"
  depends_on   = [local.service_role_profile_arn]
}

resource "aws_batch_job_queue" "batch_env_ec2_jq" {
  name     = "batch_env_ec2_jq"
  state    = "ENABLED"
  priority = 1

  compute_environment_order {
    order               = 1
    compute_environment = aws_batch_compute_environment.batch_env_ec2.arn
  }
  tags = local.tags
}