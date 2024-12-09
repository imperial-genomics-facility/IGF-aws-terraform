locals {
    config_data = try(
        jsondecode(file(var.config_json_file)),
        {}
    )
    container_maps   = local.config_data.container_maps
}

module "fargate_job_description_wrapper" {
    source = "../fargate_config_parse"
    
    container_maps   = local.container_maps
}
