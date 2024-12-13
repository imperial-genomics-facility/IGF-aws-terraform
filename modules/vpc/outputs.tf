output "vpc_public_subnets" {
    description = "VCP public subnet lists"
    value       = module.vpc.public_subnets
}

output "vpc_private_subnets" {
    description = "VCP private subnet lists"
    value       = module.vpc.private_subnets
}

output "vpc_id" {
    description = "VPC id"
    value       = module.vpc.vpc_id
}

output "endpoint_security_group_arn" {
    description = "endpoint_security_group"
    value       = aws_security_group.endpoint_security_group.arn
}

output "pipeline-batch-endpoint-arn" {
  description = "pipeline-batch-endpoint"
  value       = aws_vpc_endpoint.pipeline-batch-endpoint.arn
}

output "pipeline-ecr-dkr-endpoint-arn" {
  description = "pipeline-ecr-dkr-endpoint"
  value       = aws_vpc_endpoint.pipeline-ecr-dkr-endpoint.arn
}

output "pipeline-ecr-api-endpoint-arn" {
  description = "pipeline-ecr-api-endpoint"
  value       = aws_vpc_endpoint.pipeline-ecr-api-endpoint.arn
}

output "pipeline-logs-endpoint-arn" {
  description = "pipeline-logs-endpoint"
  value       = aws_vpc_endpoint.pipeline-logs-endpoint.arn
}

output "pipeline-ecs-endpoint-arn" {
  description = "pipeline-ecs-endpoint"
  value       = aws_vpc_endpoint.pipeline-ecs-endpoint
}

output "pipeline-ecs-agent-endpoint-arn" {
  description = "pipeline-ecs-agent-endpoint"
  value = aws_vpc_endpoint.pipeline-ecs-agent-endpoint.arn
}

output "pipeline-ecs-telemetry-endpoint-arn" {
  description = "pipeline-ecs-telemetry-endpoint"
  value = aws_vpc_endpoint.pipeline-ecs-telemetry-endpoint.arn
}

output "pipeline-s3-endpoint-arn" {
  description = "pipeline-s3-endpoint"
  value = aws_vpc_endpoint.pipeline-s3-endpoint.arn
}