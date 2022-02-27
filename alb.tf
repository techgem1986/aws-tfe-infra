## ALB
resource "aws_alb" "alb" {
  name            = local.name
  subnets         = [aws_subnet.public-subnet-1.id, aws_subnet.public-subnet-2.id]
  security_groups = [aws_security_group.security-group-alb.id]
  enable_http2    = "true"
  idle_timeout    = 180

}


