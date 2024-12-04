locals {
    container_maps   = var.container_maps
    repo_name_prefix = var.repo_name_prefix
    region           = var.region
}

module "ecr_job_description_builder" {
    source = "../base"

    repo_prefix = local.repo_name_prefix
    region      = local.region
}