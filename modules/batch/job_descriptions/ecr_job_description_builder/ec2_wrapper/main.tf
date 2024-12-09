locals {
    config_data = try(
        jsondecode(file(var.config_json_file)),
        {}
    )
    repo_name_prefix = local.config_data.repo_name_prefix
    container_maps   = local.config_data.container_maps
}

module "ecr_repo_and_job_desccription_wrapper" {
    source = "../ec2_config_parse"

    repo_name_prefix    = local.repo_name_prefix
    container_maps      = local.container_maps
    execution_role_arn  = var.execution_role_arn
    job_role_arn        = var.job_role_arn
}
