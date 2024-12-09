output "ecr_image_arn" {
    description = "ECR image arn"
    value       = aws_ecr_repository.igf-pipeline-ecr.arn
}