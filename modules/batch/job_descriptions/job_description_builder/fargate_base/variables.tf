variable "region" {
  description = "region"
  type        = string#
  default     = ""
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
    condition = contains(keys(var.container_map), "ecr_image_url")
    error_message = "Not correctly formatted, missing ecr_image_url"
  }
  validation {
    condition = contains(keys(var.container_map), "name")
    error_message = "Not correctly formatted, missing name"
  }
}