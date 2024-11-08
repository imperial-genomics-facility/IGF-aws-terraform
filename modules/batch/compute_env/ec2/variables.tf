
## vpc public subnets
variable "subnets" {
  description = "Available cidr blocks for public subnets."
  type        = list(string)
  default     = []
  # validation {
  #   condition     = length(var.public_subnet_cidr_blocks) == 3
  #   error_message = "Three public subnet cids list required"
  # }
}


## project name
variable "project_name" {
  description = "A project name for the resource"
  type        = string
  default     = "Test"
  validation {
    condition     = can(regex("^[a-zA-Z-_]+$", var.project_name))
    error_message = "Project name is not correctly formatted"
  }
}

## environment
variable "environment" {
  description = "An environment name for the resource"
  type        = string
  default     = "DEV"
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

variable "service_role_arn" {
  description = "Batch service role ARN"
  type        = string
  default     = ""
}

variable "service_role_profile_arn" {
  description = "Batch service role profile"
  type        = string
  default     = ""
}

variable "ecs_instance_role_arn" {
  description = "ECS service role ARN"
  type        = string
  default     = ""
}

variable "service_role_name" {
  description = "Batch service role name"
  type        = string
  default     = ""
}

variable "ami_id" {
    description = "AMI id"
    type        = string
    default     = ""
}

variable "spot_iam_fleet_role" {
  description = "SPOT fleet role"
  type        = string
  default     = ""
}

variable "image_type" {
  description = "Image type"
  type        = string
  default     = ""
}

variable "vpc_id" {
  description = "VPC id"
  type        = string
  default     = ""
}