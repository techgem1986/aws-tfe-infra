# ECS cluster
resource "aws_ecs_cluster" "ecs-cluster" {
  name = local.name
}
#Compute
resource "aws_autoscaling_group" "autoscaling-group" {
  name = local.name
  vpc_zone_identifier = [
  aws_subnet.public-subnet-1.id, aws_subnet.public-subnet-2.id]
  min_size                  = "1"
  max_size                  = "5"
  desired_capacity          = "1"
  launch_configuration      = aws_launch_configuration.launch-config.name
  health_check_grace_period = 120
  default_cooldown          = 30
  termination_policies      = ["OldestInstance"]

  tag {
    key                 = "Name"
    value               = local.name
    propagate_at_launch = true
  }
}

resource "aws_autoscaling_policy" "autoscaling-policy" {
  name                      = local.name
  policy_type               = "TargetTrackingScaling"
  estimated_instance_warmup = "90"
  adjustment_type           = "ChangeInCapacity"
  autoscaling_group_name    = aws_autoscaling_group.autoscaling-group.name

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }
    target_value = 40.0
  }
}

resource "aws_launch_configuration" "launch-config" {
  name_prefix     = local.name
  security_groups = [aws_security_group.security-group-ec2.id]

  image_id                    = "ami-0f06fc190dd71269e"
  instance_type               = var.instance
  iam_instance_profile        = aws_iam_instance_profile.ec2-profile.id
  user_data                   = data.template_file.ecs-cluster.rendered
  associate_public_ip_address = true

  lifecycle {
    create_before_destroy = true
  }
}