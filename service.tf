module "ecs-service" {
  source = "./ecs-services"
  cluster_id = aws_ecs_cluster.ecs-cluster.id
  alb_id = aws_alb.alb.id
  vpc_id = aws_vpc.vpc.id
  ecs_role_arn = aws_iam_role.ecs-role.arn
}