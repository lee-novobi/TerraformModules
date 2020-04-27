terraform {
  backend "s3" {}
}

provider "aws" {
  region = var.aws_region
//  dynamic "assume_role" {
//    for_each = var.aws_assume_role == "" ? [] : [var.aws_assume_role]
//    content {
//      role_arn = assume_role.value
//    }
//  }
}

data "terraform_remote_state" "ecs_cluster" {
  backend = "s3"
  config = {
    bucket = "${var.ecs_cluster_state_config.bucket}"
    key    = "${var.ecs_cluster_state_config.key}"
    region = "${var.ecs_cluster_state_config.region}"
  }
}