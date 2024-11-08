output "batch_ecs_instance_role_arn" {
    description = "ECS instance role ARN"
    value       = aws_iam_instance_profile.ecs_instance_role_profile.arn
}

output "batch_ecs_instance_role_name" {
    description = "ECS instance role name"
    value       = aws_iam_role.ecs_instance_role.name
}

output "batch_service_role_arn" {
    description = "Batch service role ARN"
    value       = aws_iam_role.aws_batch_service_role.arn
}

output "batch_service_role_profile_arn" {
    description = "Batch service role ARN"
    value       = aws_iam_instance_profile.aws_batch_service_role_profile.arn
}

output "batch_service_role_name" {
    description = "Batch service role name"
    value       = aws_iam_role.aws_batch_service_role.name
}

output "batch_job_role_arn" {
    description = "Batch job role"
    value       = aws_iam_role.batch_job_role.arn
}

output "batch_job_role_name" {
    description = "Batch job role name"
    value       = aws_iam_role.batch_job_role.name
}

output "batch_execution_role_arn" {
    description = "Batch service role ARN"
    value       = aws_iam_role.batch_execution_role.arn
}

output "batch_execution_role_name" {
    description = "Batch service role name"
    value       = aws_iam_role.batch_execution_role.name
}

output "batch_spot_fleet_tagging_role_arn" {
    description = "SPOT Fleet Tagging role ARN"
    value       = aws_iam_role.batch_spot_fleet_tagging_role.arn
}

output "batch_spot_fleet_tagging_role_name" {
    description = "SPOT Fleet Tagging role name"
    value       = aws_iam_role.batch_spot_fleet_tagging_role.name
}