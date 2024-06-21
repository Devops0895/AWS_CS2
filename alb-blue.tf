
resource "aws_alb" "alb_blue" {
  count              = length(var.availability_zones)
  name               = "alb-blue"
  subnets            = [aws_subnet.subnets[count.index].id]
  security_groups    = [aws_security_group.alb_application_sg.id]
  internal           = false
  ip_address_type    = "ipv4"
  load_balancer_type = "application"

  tags = {
    Name = "blue_alb"
  }
}

resource "aws_alb_target_group" "blue-tg" {
  name        = "blue-alb-tg"
  port        = 80
  protocol    = "HTTP"
  target_type = "instance"
  vpc_id      = aws_vpc.vpc_bg.id

  health_check {
    port                = local.tg_ports
    protocol            = local.health_check_protocol
    path                = local.healthcheck_url_path
    interval            = local.alb_healthcheck_interval
    unhealthy_threshold = local.unhealthy_threshold
    healthy_threshold   = local.healthy_threshold
    timeout             = local.alb_healthcheck_timeout
  }
}



resource "aws_alb_listener" "alb-listner-blue" {
  count             = length(var.availability_zones)
  load_balancer_arn = aws_alb.alb_blue[count.index].arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

resource "aws_alb_listener_rule" "static_blue" {
  count        = length(var.availability_zones)
  listener_arn = aws_alb_listener.alb-listner-blue[count.index].arn

  action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.blue-tg.arn
  }
  condition {
    path_pattern {
      values = ["${local.context_path}/*"]
    }
  }
  lifecycle {
    ignore_changes = [
      action
    ]
  }
}

resource "aws_lb_target_group_attachment" "attach_instance_blue" {
  count            = length(var.instance_names_blue)
  target_group_arn = aws_alb_target_group.blue-tg.arn
  target_id        = aws_instance.instances_blue_env[count.index].id
}