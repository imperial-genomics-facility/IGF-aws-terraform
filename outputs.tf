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