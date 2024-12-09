variable "repo_name_prefix" {
    description = "value"
    type        = string
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

variable "region" {
  description = "Region"
  type        = string
  default     = ""
}

variable "container_maps" {
  description = "value"
  type        = list(map(string))

  validation {
        condition = alltrue([
            for item in var.container_maps:
                contains(keys(item), "ecr_repo_name")

        ])
        error_message = "Not correctly formatted, missing ecr_repo_name"
    }
    validation {
        condition = alltrue([
            for item in var.container_maps:
                contains(keys(item), "container_version")

        ])
        error_message = "Not correctly formatted, missing container_version"
    }
    validation {
        condition = alltrue([
            for item in var.container_maps:
                contains(keys(item), "name")

        ])
        error_message = "Not correctly formatted, missing name"
    }
    validation {
        condition = alltrue([
            for item in var.container_maps:
                contains(keys(item), "container")

        ])
        error_message = "Not correctly formatted, missing container"
    }
}