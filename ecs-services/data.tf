data "aws_ecs_cluster" "ecs-cluster" {
  name= local.name
}

data "aws_alb" "alb" {
  name = local.name
}

data "aws_vpc" "vpc" {
  name = local.name
}
data "aws_iam_role" "ecs-role" {
  name = local.name + "-ecs-role"
}