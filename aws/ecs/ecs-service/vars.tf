variable "environment" {
  description = "The environment identification (eg: Dev, QA, Production)"
  type        = string
}
variable "name" {
  description = "The name of the service"
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

variable "service_name" {
  description = "The name of the service"
  type        = string
}

variable "enable_fargate" {
  description = "Enable Fargate"
  type        = bool
  default     = false
}

variable "enable_cron" {
  description = "Enable Cron via Cloudwatch event"
  type        = bool
  default     = false
}

variable "cron_schedule_expression" {
  description = "Cron Schedule expression"
  type        = string
  default     = "cron(*/5 * * * ? *)"
}

variable "network_mode" {
  description = "none, bridge, awsvpc, and host"
  type        = string
  default     = "bridge"
}

variable "awsvpc_network_configuration" {
  description = "Configure awsvpc configuration"
  type        = map
  default = {
    "run_in_public_subnets" = false
    "assign_public_ip"      = false
  }
}

variable "base_infrastructure_state_config" {
  description = "The base infrastructure state config"
  type        = map
  default = {
    "bucket" = "bucket"
    "key"    = "image-4567"
    "region" = ""
  }
}

variable "ecs_cluster_state_config" {
  description = "The ecs cluster state config"
  type        = map
  default = {
    "bucket" = "bucket"
    "key"    = "image-4567"
    "region" = ""
  }
}

variable "ecs_ecr_state_config" {
  description = "The State file of ECR"
  type        = map
  default = {
    "bucket" = "bucket"
    "key"    = "image-4567"
    "region" = ""
  }
}

variable "image_tag" {
  description = "Image Tag"
  type        = string
  default     = "latest"
}
variable "cpu" {
  description = "cpu"
  type        = number
  default     = 128
}

variable "memory" {
  description = "memory"
  type        = number
  default     = 1024
}



variable "volumes" {
  type = list(object({
    name      = string
    host_path = string
  }))
  default = []
}

variable "task_definitions" {
  type = list(any)
}

variable "alb_listener_rules" {
  type = list(object({
  priority = number
  conditions = list(object({
  field  = string
  values = list(string)
  })
  )
  }))

  default = []
}

variable "alb_listener_fix_response_rules" {
  type = list(object({
  priority = number
  fixed_response = object({
  content_type = string
  message_body = string
  status_code  = string
  })
  conditions = list(object({
  field  = string
  values = list(string)
  })
  )
  }))

  default = []
}

variable "alb_listener_redirect_rules" {
  type = list(object({
  priority = number
  redirect = object({
  host     = string
  port     = number
  protocol = string
  })
  conditions = list(object({
  field  = string
  values = list(string)
  })
  )
  }))

  default = []
}

variable "target_group_maping" {
  description = "Specify the cointainer in target group"
  type        = map
  default = {
  "container_name" = "nginx"
  "container_port" = 80
  }

}


variable "extra_task_role_policies" {
  type    = any
  default = "{}"
}
variable "has_task_role_policies" {
  type    = bool
  default = false
}

variable "task_count" {
  type    = number
  default = 1
}
variable "has_autoscaling_group" {
  type        = bool
  description = "Indicate that we manage task count or ignore"
  default     = false
}

variable "has_redis" {
  type    = bool
  default = false
}
variable "redis_state_config" {
  description = "The State file of redis"
  type        = map
  default = {
  "bucket" = "bucket"
  "key"    = "image-4567"
  "region" = ""
  }
}


variable "sqs_queue_state_configs" {
  description = "List of SQS queues state config to grant permissions"
  type = list(object({
  bucket = string
  key    = string
  region = string
  }))
  default = []
}

variable "health_check" {
  type = map
  default = {
  "healthy_threshold"   = "5"
  "interval"            = "60"
  "path"                = "/"
  "timeout"             = "45"
  "unhealthy_threshold" = "5"
  "matcher"             = "200,303"
  }
}