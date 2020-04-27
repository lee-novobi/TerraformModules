terraform {
  backend "s3" {
    bucket              = "terraform-state"
    key                 = "stage/ecs-cluster/terraform.tfstate"
    region              = "us-west-2"
    encrypt             = true
    dynamodb_table      = "my-lock-table"
  }
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