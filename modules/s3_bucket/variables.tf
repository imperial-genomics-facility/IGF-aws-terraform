variable "s3_main_bucket_name" {
    description = "S3 main bucket name"
    type        = string
    default     = ""
    validation {
        condition     = can(regex("^[a-zA-Z0-9-]+$", var.s3_main_bucket_name))
        error_message = "S3 raw run bucket is not correctly formatted"
    }
    validation {
        condition     = length(var.s3_main_bucket_name) >= 8
        error_message = "S3 raw run bucket name is too small"
    }
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

variable "prevent_destroy" {
    description = "Lifecycle - prefent destroy"
    type        = bool
    default     = false
}

variable "s3_main_bucket_expiration_days" {
  description = "S3 bucket expiration days"
  type        = number
  default     = 30
}

variable "s3_logging_bucket_name" {
    description = "S3 logging bucket name"
    type        = string
    default     = ""
    validation {
        condition     = can(regex("^[a-zA-Z0-9-]+$", var.s3_logging_bucket_name))
        error_message = "S3 raw run bucket is not correctly formatted"
    }
    validation {
        condition     = length(var.s3_logging_bucket_name) >= 8
        error_message = "S3 raw run bucket name is too small"
    }
}

variable "s3_static_resource_bucket_name" {
    description = "S3 static reource bucket name"
    type        = string
    default     = ""
    validation {
        condition     = can(regex("^[a-zA-Z0-9-]+$", var.s3_static_resource_bucket_name))
        error_message = "S3 raw run bucket is not correctly formatted"
    }
    validation {
        condition     = length(var.s3_static_resource_bucket_name) >= 8
        error_message = "S3 raw run bucket name is too small"
    }
}