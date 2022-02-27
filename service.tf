module "ecs-service" {
  source = "./ecs-services"
  cluster = aws_ecs_cluster.ecs-cluster.id
  alb = aws_alb.alb.id
  vpc = aws_vpc.vpc.id
  ecs_role = aws_iam_role.ecs-role.arn
  depends_on = [aws_alb.alb]
}