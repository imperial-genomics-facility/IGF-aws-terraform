data "aws_caller_identity" "current" {}

locals {
    container_map              = var.container_map
    repo_prefix                = var.repo_prefix
    ecr_repo_name              = local.container_map.ecr_repo_name
    region                     = var.region
    job_description_name       = local.container_map.name
    deregister_on_new_revision = var.deregister_on_new_revision
    ecr_image_url              = "${data.aws_caller_identity.current.account_id}.dkr.ecr.${local.region}.amazonaws.com/${local.repo_prefix}/${local.ecr_repo_name}"
    execution_role_arn         = var.execution_role_arn
    job_role_arn               = var.job_role_arn

}

module "build_ecr_repo" {
    source        = "../../../../ecr/base"
    project_name  = local.repo_prefix
    ecr_repo_name = local.ecr_repo_name
}

module "build_batch_job_decrtiption" {
    source                     = "../../ec2_base"
    job_description_name       = local.job_description_name
    deregister_on_new_revision = local.deregister_on_new_revision
    ecr_image_url              = local.ecr_image_url
    execution_role_arn         = local.execution_role_arn
    job_role_arn               = local.job_role_arn

    depends_on = [ module.build_ecr_repo.ecr_image_arn ]

}