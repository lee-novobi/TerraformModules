output "efs_dns_name" {
  value = aws_efs_file_system.efs.dns_name
  description = "DNS Name of EFS"
}
output "efs_id" {
  value = aws_efs_file_system.efs.id
  description = "ID of EFS"
}

output "efs_arn" {
  value = aws_efs_file_system.efs.arn
  description = "ARN of EFS"
}