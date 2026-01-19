variable "project_name" {
  description = "The name of the project to prefix resource names"
  type        = string
}

variable "vpc_id" {
  description = "The VPC ID where the ECS cluster will be deployed"
  type        = string
}

variable "container_image" {
  description = "The container image to use for the ECS task"
  type        = string
}

variable "private_subnet_ids" {
  description = "List of subnet IDs for the ECS tasks"
  type        = list(string)
}

variable "alb_security_group_id" {
  description = "The security group ID for the ALB"
  type        = string

}

variable "target_group_arn" {
  description = "The ARN of the target group for the ALB"
  type        = string

}

variable "ecs_cluster_name" {
  description = "Cluster name"
  type        = string
}