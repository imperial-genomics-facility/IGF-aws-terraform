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