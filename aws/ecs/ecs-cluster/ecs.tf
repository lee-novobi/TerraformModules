locals {
  cluster_name = "${lower(coalesce(var.cluster_name, var.name))}-cluster"
}

resource "aws_ecs_cluster" "ecs" {
  name = "${local.cluster_name}"
}