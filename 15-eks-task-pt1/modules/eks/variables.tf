variable "cluster_name" {
    description = "Name of the EKS cluster"
    type        = string
    default = "my-eks-cluster"
}
variable "subnet_ids" {
  type = list(string)
}