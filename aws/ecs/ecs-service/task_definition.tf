resource "aws_ecs_task_definition" "task_definition" {
  container_definitions    = var.task_definitions
  #execution_role_arn       = "arn:aws:iam::366936653413:role/AWSServiceRoleForECS"
  family                   = "terraform-nginx"
  network_mode             = "bridge"
  memory                   = "200"
  cpu                      = "200"
  requires_compatibilities = ["EC2"]
  #task_role_arn            = "arn:aws:iam::366936653413:role/Task-ECS-Test"
}

data "template_file" "task_definition_json" {
  template = file("${path.module}/template/task_definition.json")

  vars = {
    container_name = var.container_name
    image          = var.image
    version        = var.version_image
    cpu            = var.cpu
    memory         = var.memory
    hostPort       = var.hostPort
  }
}
