module "ecs-service" {
  source = "./ecs-services"
  cluster_id = aws_ecs_cluster.ecs-cluster.id
}