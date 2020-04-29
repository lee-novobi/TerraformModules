locals {
  launch_type = var.enable_fargate ? "FARGATE" : "EC2"
}


resource "aws_ecs_service" "service_single" {
  count           = var.has_autoscaling_group ? 0 : 1
  name            = "${var.name}-${var.service_name}"
  cluster         = data.terraform_remote_state.ecs_cluster.outputs.cluster_name
  task_definition = aws_ecs_task_definition.task_definition[0].arn
  desired_count   = var.task_count

  launch_type = local.launch_type


  dynamic "network_configuration" {
    for_each = local.network_mode == "awsvpc" ? ["yes"] : []
    content {
      subnets          = var.awsvpc_network_configuration["run_in_public_subnets"] ? data.terraform_remote_state.base_layout.outputs.public_subnets : data.terraform_remote_state.base_layout.outputs.private_subnets
      security_groups  = var.awsvpc_network_configuration["run_in_public_subnets"] ? [data.terraform_remote_state.base_layout.outputs.sg_public] : [data.terraform_remote_state.base_layout.outputs.sg_private]
      assign_public_ip = var.awsvpc_network_configuration["assign_public_ip"]
    }
  }

  dynamic "ordered_placement_strategy" {
    for_each = var.enable_fargate ? [] : ["yes"]
    content {
      type  = "binpack"
      field = "cpu"
    }
  }

  dynamic "load_balancer" {
    for_each = length(var.alb_listener_rules) > 0 ? [var.target_group_maping["container_name"]] : []
    content {
      target_group_arn = aws_lb_target_group.this[0].arn
      container_name   = load_balancer.value
      container_port   = var.target_group_maping["container_port"]
    }
  }


}


resource "aws_ecs_service" "service_autoscale" {
  count           = var.has_autoscaling_group ? 1 : 0
  name            = "${var.name}-${var.service_name}"
  cluster         = data.terraform_remote_state.ecs_cluster.outputs.cluster_name
  task_definition = aws_ecs_task_definition.task_definition[0].arn
  desired_count   = var.task_count

  launch_type = local.launch_type

  dynamic "ordered_placement_strategy" {
    for_each = var.enable_fargate ? [] : ["yes"]
    content {
      type  = "binpack"
      field = "cpu"
    }
  }

  dynamic "load_balancer" {
    for_each = length(var.alb_listener_rules) > 0 ? [var.target_group_maping["container_name"]] : []
    content {
      target_group_arn = aws_lb_target_group.this[0].arn
      container_name   = load_balancer.value
      container_port   = var.target_group_maping["container_port"]
    }
  }


  lifecycle {
    ignore_changes = [desired_count]
  }
}