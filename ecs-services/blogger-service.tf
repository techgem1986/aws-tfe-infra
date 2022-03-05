# blogger-service
resource "aws_ecs_service" "blogger-service" {
  name            = "blogger-service"
  cluster         = var.cluster
  task_definition = aws_ecs_task_definition.task-definition-blogger-service.arn
  iam_role        = var.ecs_role
  desired_count   = 1

  load_balancer {
    target_group_arn = aws_alb_target_group.alb-target-group-blogger-service.id
    container_name   = "blogger-service"
    container_port   = "8080"
  }
  lifecycle {
    ignore_changes = [task_definition]
  }
}

resource "aws_ecs_task_definition" "task-definition-blogger-service" {
  family = "blogger-service"

  container_definitions = <<EOF
[
  {
    "portMappings": [
      {
        "hostPort": 0,
        "protocol": "tcp",
        "containerPort": 8080
      }
    ],
    "cpu": 256,
    "memory": 300,
    "image": "docker.io/techgem1986/blogger-service:latest",
    "essential": true,
    "name": "blogger-service",
    "logConfiguration": {
    "logDriver": "awslogs",
      "options": {
        "awslogs-group": "/techgem1986/blogger-service",
        "awslogs-region": "us-east-1",
        "awslogs-stream-prefix": "ecs"
      }
    }
  }
]
EOF
}

resource "aws_cloudwatch_log_group" "log-group-blogger-service" {
  name = "/techgem1986/blogger-service"
}

resource "aws_alb_target_group" "alb-target-group-blogger-service" {
  name       = "blogger-service"
  port       = 8901
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

resource "aws_alb_listener" "alb-listener-blogger-service" {
  load_balancer_arn = var.alb
  port              = 8901
  protocol          = "HTTP"
  default_action {
    target_group_arn = aws_alb_target_group.alb-target-group-blogger-service.id
    type             = "forward"
  }
}