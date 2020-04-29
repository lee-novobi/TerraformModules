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
  default     = ""
}

variable "aws_region" {
  description = "The AWS region to deploy to (e.g. us-east-1)"
  type        = string
}

variable "azs" {
  description = "The cidr_block of the cluster"
  type        = list(string)
}

variable "cidr_block" {
  description = "The cidr_block of the cluster"
  type        = string
}

variable "alb_idle_timeout" {
  type    = number
  default = 90
}

variable "private_subnets" {
  description = "The cidr_block of the cluster"
  type        = list(string)
}

variable "public_subnets" {
  description = "The cidr_block of the cluster"
  type        = list(string)
}

variable "enable_nat_gateway" {
  type    = bool
  default = true
}

variable "single_nat_gateway" {
  type    = bool
  default = true
}

variable "one_nat_gateway_per_az" {
  type    = bool
  default = false
}

variable "enable_alb" {
  type    = bool
  default = false
}

variable "enable_kms" {
  type    = bool
  default = false
}

variable "enable_codepipeline_s3" {
  type    = bool
  default = false
}