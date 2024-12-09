locals {
    config_data = try(
        jsondecode(file(var.config_json_file)),
        {}
    )
    repo_name_prefix = local.config_data.repo_name_prefix
    container_maps   = local.config_data.container_maps
}

module "fargate_ecr_repo_and_job_desccription_wrapper" {
    source = "../fargate_config_parse"

    repo_name_prefix = local.repo_name_prefix
    container_maps   = local.container_maps
}
