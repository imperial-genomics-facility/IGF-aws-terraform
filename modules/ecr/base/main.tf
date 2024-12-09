## ECR - demult
locals {
  encryption_type = "AES256"
}
resource "aws_ecr_repository" "igf-pipeline-ecr" {
  name                 = "${var.project_name}/${var.ecr_repo_name}"
  image_tag_mutability = "MUTABLE"
  force_delete         = var.force_delete
  tags                 = var.tags

  # image_scanning_configuration {
  #   scan_on_push = true
  # }

  encryption_configuration {
    encryption_type = local.encryption_type
  }

  lifecycle {
    prevent_destroy = false
  }
}