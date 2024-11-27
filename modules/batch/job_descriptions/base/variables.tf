variable "region" {
    description = "Region name"
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

variable "container_version" {
  description = "Container version"
  type        = string
  default     = "latest"
}

variable "repo_prefix" {
  description = "Repository prefix name"
  type        = string
  default     = ""
}