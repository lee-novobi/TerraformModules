resource "aws_ecs_service" "service" {
  cluster         = aws_ecs_cluster.ecs.id
  desired_count   = 2
  launch_type     = "EC2"
  name            = var.service_name
  task_definition = aws_ecs_task_definition.task_definition.arn

  load_balancer {
    container_name   = var.container_name
    container_port   = "80"
    target_group_arn = aws_lb_target_group.lb_target_group.arn
  }

  depends_on = ["aws_lb_listener.lb_listener"]
}
