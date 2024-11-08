## name
variable "project_name" {
  description = "Project name of ECR repo"
  type        = string
  default     = ""
}

variable "ecr_repo_name" {
  description = "Name of ECR repo"
  type        = string
  default     = ""
}

## resource tags
variable "tags" {
  description = "Map of resource tags"
  type        = map(string)
  default     = {}
}

variable "force_delete" {
  description = "Force delete ecr image"
  type        = bool
  default     = false
}

variable "prevent_destroy" {
  description = "ECR lifecycle prevent_destroy"
  type        = bool
  default     = false
}