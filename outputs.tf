## list of private subnets
output "private_subnets" {
  description = "List of private subnets for the VPC"
  value       = module.igf_vpc.vpc_private_subnets
}

## list of public subnets
output "public_subnets" {
  description = "List of public subnets for the VPC"
  value       = module.igf_vpc.vpc_public_subnets
}

## vpc id
output "vpc_id" {
  description = "VPC id"
  value       = module.igf_vpc.vpc_id
}

output "endpoint_security_group_arn" {
  description = "endpoint_security_group_arn"
  value       = module.igf_vpc.endpoint_security_group_arn
}

output "pipeline-batch-endpoint-arn" {
  description = "pipeline-batch-endpoint-arn"
  value       = module.igf_vpc.pipeline-batch-endpoint-arn
}

output "pipeline-ecr-dkr-endpoint-arn" {
  description = "pipeline-ecr-dkr-endpoint-arn"
  value       = module.igf_vpc.pipeline-ecr-dkr-endpoint-arn
}

output "pipeline-ecr-api-endpoint-arn" {
  description = "pipeline-ecr-api-endpoint-arn"
  value       = module.igf_vpc.pipeline-ecr-api-endpoint-arn
}

output "pipeline-logs-endpoint-arn" {
  description = "pipeline-logs-endpoint-arn"
  value       = module.igf_vpc.pipeline-logs-endpoint-arn
}

output "pipeline-ecs-endpoint-arn" {
  description = "pipeline-ecs-endpoint-arn"
  value       = module.igf_vpc.pipeline-ecs-endpoint-arn
}

output "pipeline-ecs-agent-endpoint-arn" {
  description = "pipeline-ecs-agent-endpoint-arn"
  value       = module.igf_vpc.pipeline-ecs-agent-endpoint-arn
}

output "pipeline-ecs-telemetry-endpoint-arn" {
  description = "pipeline-ecs-telemetry-endpoint-arn"
  value       = module.igf_vpc.pipeline-ecs-telemetry-endpoint-arn
}

output "pipeline-s3-endpoint-arn" {
  description = "pipeline-s3-endpoint-arn"
  value       = module.igf_vpc.pipeline-s3-endpoint-arn
}

output "batch_ecs_instance_role_arn" {
    description = "ECS instance role ARN"
    value       = module.igf_batch_roles.batch_ecs_instance_role_arn
}

output "batch_ecs_instance_role_name" {
    description = "ECS instance role name"
    value       = module.igf_batch_roles.batch_ecs_instance_role_name
}

output "batch_service_role_arn" {
    description = "Batch service role ARN"
    value       = module.igf_batch_roles.batch_service_role_arn
}

output "batch_service_role_profile_arn" {
    description = "Batch service role ARN"
    value       = module.igf_batch_roles.batch_service_role_profile_arn
}

output "batch_service_role_name" {
    description = "Batch service role name"
    value       = module.igf_batch_roles.batch_service_role_name
}

output "batch_job_role_arn" {
    description = "Batch job role"
    value       = module.igf_batch_roles.batch_job_role_arn
}

output "batch_job_role_name" {
    description = "Batch job role name"
    value       = module.igf_batch_roles.batch_job_role_name
}

output "batch_execution_role_arn" {
    description = "Batch service role ARN"
    value       = module.igf_batch_roles.batch_execution_role_arn
}

output "batch_execution_role_name" {
    description = "Batch service role name"
    value       = module.igf_batch_roles.batch_execution_role_name
}

output "batch_spot_fleet_tagging_role_arn" {
    description = "SPOT Fleet Tagging role ARN"
    value       = module.igf_batch_roles.batch_spot_fleet_tagging_role_arn
}

output "batch_spot_fleet_tagging_role_name" {
    description = "SPOT Fleet Tagging role name"
    value       = module.igf_batch_roles.batch_spot_fleet_tagging_role_name
}

output "main_s3_bucket_arn" {
  description = "main_s3_bucket"
  value = module.igf_s3_bucket.main_s3_bucket_arn
}

output "log_bucket_arn" {
  description = "log_bucket"
  value = module.igf_s3_bucket.log_bucket_arn
}

output "static_resource_s3_bucket_arn" {
  description = "static_resource_s3_bucket"
  value = module.igf_s3_bucket.static_resource_s3_bucket_arn
}