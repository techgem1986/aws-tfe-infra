variable "cluster_id" {
  description = "ECS Cluster ID"
  type        = string
}

variable "alb_id" {
  description = "Application Load Balancer ID"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}
variable "ecs_role_arn" {
  description = "ECS IAM Role ARN"
  type        = string
}