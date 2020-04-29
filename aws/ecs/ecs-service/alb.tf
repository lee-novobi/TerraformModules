resource "aws_lb_target_group" "this" {
  count                = length(var.alb_listener_rules) > 0 ? 1 : 0
  name                 = "${var.service_name}-tg"
  port                 = 80
  protocol             = "HTTP"
  vpc_id               = data.terraform_remote_state.base_layout.outputs.vpc_id
  target_type          = "instance"
  deregistration_delay = 45

  health_check {
    healthy_threshold   = lookup(var.health_check,"healthy_threshold","5")
    interval            = lookup(var.health_check,"interval","60")
    path                = lookup(var.health_check,"path","/")
    timeout             = lookup(var.health_check,"timeout","45")
    unhealthy_threshold = lookup(var.health_check,"unhealthy_threshold","5")
    matcher             = lookup(var.health_check, "matcher", "200,303")
  }
}

resource "aws_lb_listener_rule" "host_based_routing" {
  count        = length(var.alb_listener_rules)
  listener_arn = data.terraform_remote_state.base_layout.outputs.aws_lb_listener_https_arn
  priority     = var.alb_listener_rules[count.index].priority

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.this[0].arn
  }


  dynamic "condition" {
    for_each = var.alb_listener_rules[count.index].conditions
    content {
      field  = condition.value.field
      values = condition.value.values
    }
  }
  depends_on = [
    aws_lb_target_group.this
  ]
}

resource "aws_lb_listener_rule" "redirect_routing" {
  count        = length(var.alb_listener_redirect_rules)
  listener_arn = data.terraform_remote_state.base_layout.outputs.aws_lb_listener_https_arn
  priority     = var.alb_listener_redirect_rules[count.index].priority

  action {
    type = "redirect"
    redirect {
      host        = var.alb_listener_redirect_rules[count.index].redirect.host
      port        = var.alb_listener_redirect_rules[count.index].redirect.port
      protocol    = var.alb_listener_redirect_rules[count.index].redirect.protocol
      status_code = "HTTP_301"
    }
  }


  dynamic "condition" {
    for_each = var.alb_listener_redirect_rules[count.index].conditions
    content {
      field  = condition.value.field
      values = condition.value.values
    }
  }
}


resource "aws_lb_listener_rule" "fixed_response_routing" {
  count        = length(var.alb_listener_fix_response_rules)
  listener_arn = data.terraform_remote_state.base_layout.outputs.aws_lb_listener_https_arn
  priority     = var.alb_listener_fix_response_rules[count.index].priority

  action {
    type = "fixed-response"
    fixed_response {
      content_type = var.alb_listener_fix_response_rules[count.index].fixed_response.content_type
      message_body = var.alb_listener_fix_response_rules[count.index].fixed_response.message_body
      status_code  = var.alb_listener_fix_response_rules[count.index].fixed_response.status_code
    }
  }

  dynamic "condition" {
    for_each = var.alb_listener_fix_response_rules[count.index].conditions
    content {
      field  = condition.value.field
      values = condition.value.values
    }
  }
}