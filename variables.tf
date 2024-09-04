## AWS region variable
variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "eu-west-2"
}

## vpc cidr block variable
variable "vpc_cidr_block" {
  description = "CIDR block for VPC"
  type        = string
  default     = ""
  validation {
    condition     = can(regex("\\d+\\.\\d+\\.\\d+\\.\\d+\\/\\d+", var.vpc_cidr_block))
    error_message = "VPC CIDR block is incorrectly formatted"
  }
}

## vpc public subnets
variable "public_subnet_cidr_blocks" {
  description = "Available cidr blocks for public subnets."
  type        = list(string)
  default     = []
  validation {
    condition     = length(var.public_subnet_cidr_blocks) == 3
    error_message = "Three public subnet cids list required"
  }
}

## vpc private subnets
variable "private_subnet_cidr_blocks" {
  description = "Available cidr blocks for private subnets."
  type        = list(string)
  default     = []
  validation {
    condition     = length(var.private_subnet_cidr_blocks) == 3
    error_message = "Three private subnet cids list required"
  }
}

## vpc enable_nat_gateway
variable "enable_nat_gateway" {
  description = "Enable Nat Gateway in your VPC"
  type        = bool
  default     = false
}

## vpc enable_vpn_gateway
variable "enable_vpn_gateway" {
  description = "Enable VPN Gateway in your VPC"
  type        = bool
  default     = false
}

## project name
variable "project_name" {
  description = "A project name for the resource"
  type        = string
  default     = ""
  validation {
    condition     = can(regex("^[a-zA-Z-_]+$", var.project_name))
    error_message = "Project name is not correctly formatted"
  }
}

## environment
variable "environment" {
  description = "An environment name for the resource"
  type        = string
  default     = ""
  validation {
    condition     = contains(["DEV", "PROD"], var.environment)
    error_message = "VPC environment is not PROD or DEV"
  }
}

## resource tags
variable "resource_tags" {
  description = "Map of resource tags"
  type        = map(string)
  default     = {}
}

## create_egress_only_igw
variable "create_egress_only_igw" {
  description = "Create egress only IGW"
  type        = bool
  default     = true
}

## create_igw
variable "create_igw" {
  description = "Create IGW"
  type        = bool
  default     = true
}

## enable_ipv6
variable "enable_ipv6" {
  description = "Enable IPv6 for VPC"
  type        = bool
  default     = false
}

## name
variable "name" {
  description = "Name of VPC"
  type        = string
  default     = ""
}