## LOCALS
locals {
  required_tags = {
    project     = var.project_name
    environment = var.environment
  }
  tags = merge(var.resource_tags, local.required_tags)

  subnets = var.subnets
  vpc_id  = var.vpc_id

  service_role_arn         = var.service_role_arn
  service_role_profile_arn = var.service_role_profile_arn
  ecs_instance_role_arn    = var.ecs_instance_role_arn

  service_role_name = var.service_role_name

}

resource "aws_security_group" "demult_batch_sg_fargate" {
  name        = "demult_batch_sg"
  description = "Allow all egress for public images"
  vpc_id      = local.vpc_id

  tags = {
    Name = "Test"
  }
}

resource "aws_vpc_security_group_egress_rule" "fargate_allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.demult_batch_sg_fargate.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}

resource "aws_batch_compute_environment" "batch_env_fargate" {
  compute_environment_name = "batch_env_fargate"

  compute_resources {
    max_vcpus = 64

    security_group_ids = [
      aws_security_group.demult_batch_sg_fargate.id
    ]

    ## USING PUBLIC SUBNET
    subnets = local.subnets

    type = "FARGATE"
  }

  service_role = local.service_role_arn
  type         = "MANAGED"
  depends_on   = [local.service_role_profile_arn]

  tags = local.tags
}

resource "aws_batch_job_queue" "batch_env_fargate_jq" {
  name     = "batch_env_fargate_jq"
  state    = "ENABLED"
  priority = 1

  compute_environment_order {
    order               = 1
    compute_environment = aws_batch_compute_environment.batch_env_fargate.arn
  }
  tags = local.tags
}