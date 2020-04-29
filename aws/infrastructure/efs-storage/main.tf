terraform {
  backend "s3" {}
}

provider "aws" {
  region = var.aws_region
  assume_role {
    role_arn = var.aws_assume_role
  }
}

data "terraform_remote_state" "base_infrastructure" {
  backend = "s3"
  config = {
    bucket = "${var.base_infrastructure_state_config.bucket}"
    key    = "${var.base_infrastructure_state_config.key}"
    region = "${var.base_infrastructure_state_config.region}"
  }
}