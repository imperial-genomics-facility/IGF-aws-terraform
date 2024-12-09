data "aws_caller_identity" "current" {}

locals {
    job_description_name       = var.job_description_name
    deregister_on_new_revision = var.deregister_on_new_revision
    ecr_image_url              = var.ecr_image_url
    execution_role_arn         = var.execution_role_arn
    job_role_arn               = var.job_role_arn
}


module "fargate_build_batch_job_decrtiption" {
    source = "../../fargate_base"
    job_description_name       = local.job_description_name
    deregister_on_new_revision = local.deregister_on_new_revision
    ecr_image_url              = local.ecr_image_url
    execution_role_arn         = local.execution_role_arn
    job_role_arn               = local.job_role_arn
}