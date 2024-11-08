output "batch_fargate_compute_env_arn" {
    description = "Batch fargate compute env arn"
    value       = aws_batch_compute_environment.batch_env_fargate.arn
}

output "batch_fargate_job_queue_arn" {
    description = "Job queue arn"
    value       = aws_batch_job_queue.batch_env_fargate_jq.arn
}
