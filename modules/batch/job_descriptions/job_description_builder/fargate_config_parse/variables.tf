variable "container_maps" {
  description = "value"
  type        = list(map(string))

  validation {
        condition = alltrue([
            for item in var.container_maps:
                contains(keys(item), "ecr_repo_url")

        ])
        error_message = "Not correctly formatted, missing ecr_repo_url"
    }
    validation {
        condition = alltrue([
            for item in var.container_maps:
                contains(keys(item), "name")

        ])
        error_message = "Not correctly formatted, missing name"
    }
}