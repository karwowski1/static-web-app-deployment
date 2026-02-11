variable "cluster_name" {
    description = "Name of the EKS cluster"
    type        = string
    default = "my-eks-cluster"
}
variable "subnet_ids" {
  type = list(string)
}

variable "private_subnet_ids" {
  type = list(string)
}

variable "bastion_role_arn" {
  description = "IAM Role ARN of the Bastion Host to allow cluster access"
  type        = string
}

variable "bastion_security_group_id" {
  description = "Security Group ID of the Bastion Host to allow HTTPS access"
  type        = string
}