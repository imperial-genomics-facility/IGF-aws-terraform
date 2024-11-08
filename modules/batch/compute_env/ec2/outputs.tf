output "batch_ec2_compute_env_arn" {
    description = "Batch ec2 compute env arn"
    value       = aws_batch_compute_environment.batch_env_ec2.arn
}

output "batch_ec2_job_queue_arn" {
    description = "Job queue arn"
    value       = aws_batch_job_queue.batch_env_ec2_jq.arn
}
