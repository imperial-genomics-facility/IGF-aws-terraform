locals {
    job_description_name       = var.job_description_name
    deregister_on_new_revision = var.deregister_on_new_revision
    ecr_image_url              = var.ecr_image_url
    execution_role_arn         = var.execution_role_arn
    job_role_arn               = var.job_role_arn
}

resource "aws_batch_job_definition" "fargate_base_job_definition" {
    name = local.job_description_name
    type = "container"
    deregister_on_new_revision = local.deregister_on_new_revision
    platform_capabilities = [
      "FARGATE",
    ]
    container_properties = jsonencode({
    command    = ["echo", "hello"]
    image      = local.ecr_image_url
    volumes = [{
        host = {
            sourcePath = "/data/"
        }
        name = "data"
    }]
    mountPoints = [{
        sourceVolume  = "data"
        containerPath = "/data/"
        readOnly      = false
    }]
    fargatePlatformConfiguration = {
      platformVersion = "LATEST"
    }
    resourceRequirements = [{
        type  = "VCPU"
        value = "0.25"
      },{
        type  = "MEMORY"
        value = "512"
      }]
    executionRoleArn = local.execution_role_arn
    jobRoleArn       = local.job_role_arn
  })
}