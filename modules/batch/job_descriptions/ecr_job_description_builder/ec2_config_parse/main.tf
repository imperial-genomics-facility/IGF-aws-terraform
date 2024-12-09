locals {
    container_maps     = var.container_maps
    repo_name_prefix   = var.repo_name_prefix
    region             = var.region
    execution_role_arn = var.execution_role_arn
    job_role_arn      = var.job_role_arn
}

module "ecr_job_description_builder" {
    source = "../ec2_base"

    count = length(local.container_maps)

    container_map       = local.container_maps[count.index]
    repo_prefix         = local.repo_name_prefix
    region              = local.region
    execution_role_arn  = local.execution_role_arn
    job_role_arn        = local.job_role_arn
}