# locals {
#     region = var.region

#     execution_role_arn = var.execution_role_arn
#     job_role_arn       = var.job_role_arn
#     repo_prefix        = "test-ecr-repo" #var.repo_prefix

#   ecr_repo_list = distinct([for obj in local.nf_core_rna_seq_jobs: obj["ecr_repo_name"]])
#   container_map = distinct({
#     for obj in local.nf_core_rna_seq_jobs: obj["container"] => "${obj["ecr_repo_name"]}:${obj["container_version"]}"
#   })
# }

locals {
    job_description_name       = var.job_description_name
    deregister_on_new_revision = var.deregister_on_new_revision
    ecr_image_url              = var.ecr_image_url
    execution_role_arn         = var.execution_role_arn
    job_role_arn               = var.job_role_arn
}

resource "aws_batch_job_definition" "ec2_base_job_definition" {
    name = local.job_description_name
    type = "container"
    deregister_on_new_revision = local.deregister_on_new_revision
    platform_capabilities = [
        "EC2",
    ]
    container_properties = jsonencode({
        command    = ["echo", "hello"]
        image      = local.ecr_image_url
        resourceRequirements = [{
            type  = "VCPU"
            value = "1"
        },{
            type  = "MEMORY"
            value = "2048"
        }]
        ## currently this is hard coded in AMI
        ## TO DO: CHANGE IT TO /aws-cli/
        volumes = [{
            host = {
                sourcePath = "/nextflow_tools/"
            }
            name = "nextflow_tools"
        }]
        mountPoints = [{
            sourceVolume  = "nextflow_tools"
            containerPath = "/nextflow_tools/"
            readOnly      = false
        }]
        executionRoleArn = local.execution_role_arn
        jobRoleArn       = local.job_role_arn
    })
}

# module "igf-ecr-nfcore-rnaseq" {
#     source = "../../../ecr/base"
#     count  = length(local.ecr_repo_list)

#     project_name  = local.repo_prefix
#     ecr_repo_name = local.ecr_repo_list[count.index]
# }

# resource "aws_batch_job_definition" "igf-jd-nfcore-rnaseq" {
#   for_each = local.nf_core_rna_seq_jobs

#   name = "nfcore-rnaseq-${each.key}"
#   type = "container"

#   deregister_on_new_revision = true

#   platform_capabilities = [
#     "EC2",
#   ]
  

#   container_properties = jsonencode({
#     command    = ["echo", "hello"]
#     image      = "${data.aws_caller_identity.current.account_id}.dkr.ecr.${local.region}.amazonaws.com/${local.repo_prefix}/${each.value}"
#     resourceRequirements = [
#       {
#         type  = "VCPU"
#         value = "1"
#       },
#       {
#         type  = "MEMORY"
#         value = "2048"
#       }
#     ]
#     volumes = [
#       {
#         host = {
#           sourcePath = "/nextflow_tools/"
#         }
#         name = "nextflow_tools"
#       }
#     ]
#     mountPoints = [
#       {
#         sourceVolume  = "nextflow_tools"
#         containerPath = "/nextflow_tools/"
#         readOnly      = false
#       }
#     ]
#     executionRoleArn = local.execution_role_arn
#     jobRoleArn       = local.job_role_arn
#   })
# }
