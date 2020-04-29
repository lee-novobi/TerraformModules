
resource "aws_iam_role" "ecs_events" {
  count              = var.enable_cron ? 1 : 0
  name               = "ecs_events-${var.name}-${var.service_name}"
  assume_role_policy = <<DOC
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "events.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
DOC
}

resource "aws_iam_role_policy" "ecs_events_run_task_with_any_role" {
  count = var.enable_cron ? 1 : 0
  name  = "ecs_events_run_task_with_any_role-${var.name}-${var.service_name}"
  role  = aws_iam_role.ecs_events[0].id

  policy = <<DOC
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "iam:PassRole",
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": "ecs:RunTask",
            "Resource": "${replace(aws_ecs_task_definition.task_definition[0].arn, "/:\\d+$/", ":*")}"
        }
    ]
}
DOC
}



resource "aws_cloudwatch_event_target" "ecs_scheduled_task" {
  count     = var.enable_cron ? 1 : 0
  target_id = "ecs-target-${var.name}-${var.service_name}"
  arn       = data.terraform_remote_state.ecs_cluster.outputs.cluster_name_arn
  rule      = aws_cloudwatch_event_rule.cron[0].name
  role_arn  = aws_iam_role.ecs_events[0].arn


  ecs_target {
    launch_type         = local.launch_type
    task_count          = 1
    task_definition_arn = replace(aws_ecs_task_definition.task_definition[0].arn, "/:\\d+$/", "")

    dynamic "network_configuration" {
      for_each = local.network_mode == "awsvpc" ? ["yes"] : []
      content {
        subnets          = var.awsvpc_network_configuration["run_in_public_subnets"] ? data.terraform_remote_state.base_layout.outputs.public_subnets : data.terraform_remote_state.base_layout.outputs.private_subnets
        security_groups  = var.awsvpc_network_configuration["run_in_public_subnets"] ? [data.terraform_remote_state.base_layout.outputs.sg_public] : [data.terraform_remote_state.base_layout.outputs.sg_private]
        assign_public_ip = var.awsvpc_network_configuration["assign_public_ip"]
      }
    }
  }
}


resource "aws_cloudwatch_event_rule" "cron" {
  count               = var.enable_cron ? 1 : 0
  name                = "cron-${var.name}-${var.service_name}"
  description         = "Base by cron"
  schedule_expression = var.cron_schedule_expression
}