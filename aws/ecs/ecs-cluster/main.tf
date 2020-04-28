terraform {
  backend "s3" {}
}

provider "aws" {
  region = var.aws_region

  dynamic "assume_role" {
    for_each = var.aws_assume_role == "" ? [] : [var.aws_assume_role]
    content {
      role_arn = assume_role.value
    }
  }
}