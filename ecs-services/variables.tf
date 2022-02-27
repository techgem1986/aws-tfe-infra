variable "cluster" {
  description = "ECS Cluster ID"
  type        = string
}

variable "alb" {
  description = "Application Load Balancer ID"
  type        = string
}

variable "vpc" {
  description = "VPC ID"
  type        = string
}
variable "ecs_role" {
  description = "ECS IAM Role ARN"
  type        = string
}