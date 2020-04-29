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
  default     = "us-east-1"
}

variable "base_infrastructure_state_config" {
  description = "The cidr_block of the cluster"
  type        = map
  default = {
    "bucket" = "bucket"
    "key"    = "image-4567"
    "region" = ""
  }
}

variable "ecs_cluster_state_config" {
  description = "The cidr_block of the cluster"
  type        = map
  default = {
    "bucket" = "bucket"
    "key"    = "image-4567"
    "region" = ""
  }
}

variable "public_key" {
  type        = string
  description = "Public key"
  default     = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDUTzauz4gGYEGGdHhGEXCk/DTIB07J25B0CZ0Rq3KzQQNqJCYklorp6m2kayhT80L9ZyS3V/sSNLxCRHp2DMh8hudIn15ch4YUCUO2EMEZDkmRToRuQV/3mJLsgEUrcVjBS2XqPzAMUaWy6L/inSTPPGQPz/I7mi84X/I6bTwOzNYwJjXNu/VrV2GikfC3BbduTadtZy7V6AScTQIfUDvvWpxahQD2hqmyRYv0y3TaurB8y1L4A6iykyPOBE21C7vamaIOgoaaPYfYiOH9D8DkQWGaqWcjhLCsGPKRjNr01p/sMMKVFTwNwb5pdIVVqE8PQS19ExH3oV7JMU7UP7v3"
}


variable "has_efs" {
  type    = bool
  default = false
}

variable "run_in_public_subnets" {
  type        = bool
  description = "Define if the cluster run in Private or Public subnets"
  default     = false
}


variable "efs_state_config" {
  description = "The cidr_block of the cluster"
  type        = map
  default = {
    "bucket" = "bucket"
    "key"    = "image-4567"
    "region" = ""
  }
}

variable "instance_type" {
  type    = string
  default = "t3.micro"
}

variable "max_size" {
  type        = number
  description = "Max Size of the SG"
  default     = 0
}

variable "min_size" {
  type        = number
  description = "Min Size of the SG"
  default     = 0
}

variable "desired_capacity" {
  type        = number
  description = "desired_capacity of the SG"
  default     = 0
}

variable "volume_size" {
  type        = number
  description = "Volume size"
  default     = 100
}