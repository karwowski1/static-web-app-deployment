variable "location" {
  description = "Default Region"
  type        = string
  default     = "polandcentral"
}

variable "project_name" {
  description = "Main prefix for all resources"
  type        = string
  default     = "jenkins-platform"
}

variable "common_tags" {
  description = "Common tags applied to all resources"
  type        = map(string)
  default = {
    project = "jenkins-platform"
  }
}

variable "vm_size" {
  description = "VM Size for Jenkins"
  type        = string
  default     = "Standard_D2s_v3"
}
