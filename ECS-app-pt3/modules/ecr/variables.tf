variable "project_name" {
  description = "The name of the project to prefix resource names"
  type        = string
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
}