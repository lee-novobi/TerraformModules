output "ecr_repository_url" {
  value       = aws_ecr_repository.this.repository_url
  description = "ECR repository ID"
}

output "registry_id" {
  value       = aws_ecr_repository.this.registry_id
  description = "ECR Registry ID"
}