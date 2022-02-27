# account-service
resource "aws_ecs_service" "account-service" {
  name            = "account-service"
  cluster         = var.cluster
  task_definition = aws_ecs_task_definition.task-definition-account-service.arn
  iam_role        = var.ecs_role
  desired_count   = 1

  load_balancer {
    target_group_arn = aws_alb_target_group.alb-target-group-account-service.id
    container_name   = "account-service"
    container_port   = "80"
  }
  lifecycle {
    ignore_changes = [task_definition]
  }
}

resource "aws_ecs_task_definition" "task-definition-account-service" {
  family = "account-service"

  container_definitions = <<EOF
[
  {
    "portMappings": [
      {
        "hostPort": 0,
        "protocol": "tcp",
        "containerPort": 80
      }
    ],
    "cpu": 256,
    "memory": 300,
    "image": "docker.io/techgem1986/account-service:latest",
    "essential": true,
    "name": "account-service",
    "logConfiguration": {
    "logDriver": "awslogs",
      "options": {
        "awslogs-group": "/techgem1986/account-service",
        "awslogs-region": "us-east-1",
        "awslogs-stream-prefix": "ecs"
      }
    }
  }
]
EOF
}

resource "aws_cloudwatch_log_group" "log-group-account-service" {
  name = "/techgem1986/account-service"
}

resource "aws_alb_target_group" "alb-target-group-account-service" {
  name       = "account-service"
  port       = 80
  protocol   = "HTTP"
  vpc_id     = var.vpc

  stickiness {
    type            = "lb_cookie"
    cookie_duration = 86400
  }

  health_check {
    path                = "/"
    healthy_threshold   = 2
    unhealthy_threshold = 10
    timeout             = 60
    interval            = 300
    matcher             = "200,301,302"
  }
}

resource "aws_alb_listener" "alb-listener-account-service" {
  load_balancer_arn = var.alb
  port              = 80
  protocol          = "HTTP"
  default_action {
    target_group_arn = aws_alb_target_group.alb-target-group-account-service.id
    type             = "forward"
  }
}