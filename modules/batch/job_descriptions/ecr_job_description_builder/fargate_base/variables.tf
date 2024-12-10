variable "repo_prefix" {
  description = "repo_prefix"
  type        = string
  default     = ""
}

variable "ecr_repo_name" {
  description = "ecr_repo_name"
  type        = string
  default     = ""
}

variable "region" {
  description = "region"
  type        = string#
  default     = ""
}

variable "job_description_name" {
    description = "job_description_name"
    type = string
    default = ""
}

variable "deregister_on_new_revision" {
  description = "deregister_on_new_revision"
  type        = bool
  default     = true
}

variable "job_role_arn" {
    description = "Job role ARN"
    type        = string
    default     = ""
}

variable "execution_role_arn" {
  description = "Execution role arn"
  type        = string
  default     = ""
}

variable "container_map" {
  description = "container_map"
  type        = map(string)
  default     = {}
  validation {
    condition = contains(keys(var.container_map), "ecr_repo_name")
    error_message = "Not correctly formatted, missing ecr_repo_name"
  }
  validation {
    condition = contains(keys(var.container_map), "name")
    error_message = "Not correctly formatted, missing name"
  }
  validation {
    condition = contains(keys(var.container_map), "container")
    error_message = "Not correctly formatted, missing container"
  }
}