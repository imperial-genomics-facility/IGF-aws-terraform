provider "aws" {
  region = var.aws_region
}

## iam

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

## iam
module "igf_batch_roles" {
  source = "./modules/iam"

  iam_role_prefix = "test_igf"
}

## create s3 buckets
module "igf_s3_bucket" {
  source = "./modules/s3_bucket"

  s3_main_bucket_name = "test-012345678"
  s3_logging_bucket_name = "test-012345678-log"
  s3_static_resource_bucket_name = "test-012345678-resource"

  aws_batch_execution_role = module.igf_batch_roles.batch_execution_role_arn
}

## batch - compute env - fargate
module "igf_batch_compute_env_fargate" {
  source  = "./modules/batch/compute_env/fargate"
  subnets = module.igf_vpc.vpc_private_subnets
  vpc_id  = module.igf_vpc.vpc_id

  service_role_arn         = module.igf_batch_roles.batch_service_role_arn
  service_role_profile_arn = module.igf_batch_roles.batch_service_role_profile_arn
  ecs_instance_role_arn    = module.igf_batch_roles.batch_ecs_instance_role_arn
  service_role_name        = module.igf_batch_roles.batch_service_role_name
}

## batch - compute env - ec2
module "igf_batch_compute_env_ec2" {
  source                   = "./modules/batch/compute_env/ec2"
  subnets                  = module.igf_vpc.vpc_private_subnets
  vpc_id                   = module.igf_vpc.vpc_id
  service_role_arn         = module.igf_batch_roles.batch_service_role_arn
  ecs_instance_role_arn    = module.igf_batch_roles.batch_ecs_instance_role_arn
  service_role_profile_arn = module.igf_batch_roles.batch_service_role_profile_arn
  service_role_name        = module.igf_batch_roles.batch_service_role_name
  image_type               = "ECS_AL2023"
  spot_iam_fleet_role      = module.igf_batch_roles.batch_spot_fleet_tagging_role_arn
  ami_id                   = "ami-0d8c895399d776b1e"
}

module "igf_nextflow_ecr_and_job_desccription" {
  source = "./modules/batch/job_descriptions/ecr_job_description_builder/wrapper"
  config_json_file = var.nf_rnaseq_ecr_input_json
}