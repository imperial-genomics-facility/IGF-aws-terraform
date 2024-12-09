variable "job_description_name" {
    description = "job_description_name"
    type = string
    default = ""
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

variable "deregister_on_new_revision" {
  description = "deregister_on_new_revision"
  type        = bool
  default     = true
}

variable "ecr_image_url" {
  description = "ecr_image_url"
  type        = string
  default     = ""
}