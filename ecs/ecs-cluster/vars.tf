variable "environment" {
  description = "The environment identification (eg: Dev, QA, Production)"
  type        = string
}

variable "name" {
  description = "The name of the system"
  type        = string
}

variable "cluster_name" {
  description = "The name of the cluster"
  type        = string
  default     = ""
}

variable "aws_region" {
  description = "The AWS region to deploy to (e.g. us-east-1)"
  type        = string
}

variable "aws_assume_role" {
  description = "The ARN of the role to assume."
  type        = string
  default     = ""
}