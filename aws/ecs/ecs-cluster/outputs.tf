output "cluster_name" {
  value       = local.cluster_name
  description = "ECS ID"
}

output "cluster_name_arn" {
  value       = aws_ecs_cluster.ecs.arn
  description = "ECS ID"
}

output "ecs_cluster_iam_role_arn" {
  value       = aws_iam_role.this.name
  description = "AWS IAM Role"
}