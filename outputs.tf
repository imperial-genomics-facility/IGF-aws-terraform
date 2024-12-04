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
