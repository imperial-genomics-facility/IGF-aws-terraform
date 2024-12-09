locals {
    container_maps   = var.container_maps
    ecr_repo_url_list = distinct([
        for obj in local.container_maps: obj["ecr_repo_url"]
    ])
}

module "fargate_ecr_job_description_builder" {
    source = "../fargate_base"
    count  = length(local.ecr_repo_url_list)

    ecr_image_url = local.ecr_repo_url_list[count.index]
}