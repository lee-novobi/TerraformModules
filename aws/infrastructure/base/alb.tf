resource "aws_lb" "lb" {
  count              = var.enable_alb ? 1 : 0
  name               = "${lower(var.name)}-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = ["${aws_security_group.sg_alb[count.index].id}"]
  subnets            = module.vpc.public_subnets
  idle_timeout       = var.alb_idle_timeout

  enable_deletion_protection = false

  tags = {
    Environment = "${var.environment}"
  }
}

resource "aws_lb_listener" "http_frontend" {
  count             = var.enable_alb ? 1 : 0
  load_balancer_arn = aws_lb.lb[count.index].arn
  port              = "80"
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


resource "aws_lb_listener" "https_frontend" {
  count             = var.enable_alb ? 1 : 0
  load_balancer_arn = aws_lb.lb[count.index].arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = aws_acm_certificate.cert[count.index].arn

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "Hello"
      status_code  = "200"
    }
  }
}