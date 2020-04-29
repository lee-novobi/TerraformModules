locals {
  container_definitions = var.task_definitions

  requires_compatibilities = var.enable_fargate ? ["EC2", "FARGATE"] : ["EC2"]

  network_mode = var.enable_fargate ? "awsvpc" : var.network_mode
  system_variables = []
}

resource "aws_ecs_task_definition" "task_definition" {
  count                    = var.enable_fargate ? 0 : 1
  family                   = lower(var.service_name)
  requires_compatibilities = local.requires_compatibilities
  network_mode             = local.network_mode

  # Add database secret and remove null item of ecr image
  container_definitions = replace(jsonencode(
    [for s in local.container_definitions : merge(s, { secrets : local.system_variables })]
  ), "ECR_IMAGE_TAG", "${data.terraform_remote_state.ecs_ecr.outputs.ecr_repository_url}:${var.environment}-${var.image_tag}")

  memory = var.memory

  dynamic "volume" {
    for_each = var.volumes
    content {
      name      = volume.value.name
      host_path = volume.value.host_path

    }
  }
  task_role_arn      = aws_iam_role.ecs_execution_role.arn
  execution_role_arn = aws_iam_role.ecs_execution_role.arn

  lifecycle {
    create_before_destroy = true
  }
}
