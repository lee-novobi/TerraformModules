variable "environment" {
  description = "The environment identification (eg: Dev, QA, Production)"
  type        = string
}
variable "name" {
  description = "The name of the cluster"
  type        = string
}
variable "aws_assume_role" {
  description = "The ARN of the role to assume."
  type        = string
}

variable "aws_region" {
  description = "The AWS region to deploy to (e.g. us-east-1)"
  type        = string
}

variable "base_infrastructure_state_config" {
  description = "The infrastructure of the cluster"
  type        = map
  default = {
    "bucket" = "bucket"
    "key"    = "image-4567"
    "region" = ""
  }
}
variable "allow_public_subnets" {
  type        = bool
  description = "Allow NFS Mount from Public Subnets"
  default     = false
}

variable "allow_private_subnets" {
  type        = bool
  description = "Allow NFS Mount from Private Subnets"
  default     = false
}