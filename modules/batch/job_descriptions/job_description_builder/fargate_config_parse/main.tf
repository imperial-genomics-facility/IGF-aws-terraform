locals {
    container_maps   = var.container_maps
    execution_role_arn = var.execution_role_arn
    job_role_arn       = var.job_role_arn
}

module "fargate_ecr_job_description_builder" {
    source             = "../fargate_base"
    count              = length(local.container_maps)
    container_map      = local.container_maps[count.index]
    execution_role_arn = local.execution_role_arn
    job_role_arn       = local.job_role_arn
}