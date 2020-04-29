terraform {
  backend "s3" {}
}

provider "aws" {
  region = var.aws_region
  dynamic "assume_role" {
    for_each = var.aws_assume_role = "" ? [] : [var.aws_assume_role]
    content {
      role_arn = assume_role.value
    }
  }
}

data "terraform_remote_state" "base_layout" {
  backend = "s3"
  config = {
    bucket = "${var.base_infrastructure_state_config.bucket}"
    key = "${var.base_infrastructure_state_config.key}"
    region = "${var.base_infrastructure_state_config.region}"
  }
}

data "terraform_remote_state" "ecs_cluster" {
  backend = "s3"
  config = {
    bucket = "${var.ecs_cluster_state_config.bucket}"
    key = "${var.ecs_cluster_state_config.key}"
    region = "${var.ecs_cluster_state_config.region}"
  }
}


data "terraform_remote_state" "efs" {
  count   = var.has_efs ? 1 : 0
  backend = "s3"
  config = {
    bucket = "${var.efs_state_config.bucket}"
    key    = "${var.efs_state_config.key}"
    region = "${var.efs_state_config.region}"

  }
}