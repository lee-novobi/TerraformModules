
output "vpc_id" {
  value       = module.vpc.vpc_id
  description = "VPC ID"
}

output "sg_private" {
  value       = aws_security_group.sg_private.id
  description = "Security group of Private Instances"
}

output "sg_public" {
  value       = aws_security_group.sg_public.id
  description = "Security group of Public Instances"
}

output "aws_region" {
  value       = var.aws_region
  description = "AWS Regions"
}

output "azs" {
  value       = var.azs
  description = "availability_zones"
}

output "private_subnets" {
  value       = module.vpc.private_subnets
  description = "Security group of ECS Instances"
}

output "public_subnets" {
  value       = module.vpc.public_subnets
  description = "Security group of ECS Instances"
}

output "kms_key_id" {
  value       = var.enable_kms ? aws_kms_key.cluster_key[0].arn : ""
  description = "Cluster Key for Encryption"
}

output "alb_dns_name" {
  value       = var.enable_alb ? aws_lb.lb[0].dns_name : ""
  description = "ALB Http Listener ARN"
}

output "aws_lb_listener_http_arn" {
  value       = var.enable_alb ? aws_lb_listener.http_frontend[0].arn : ""
  description = "ALB Http Listener ARN"
}

//output "aws_lb_listener_https_arn" {
//  value       = var.enable_alb ? aws_lb_listener.https_frontend[0].arn : ""
//  description = "ALB Https Listener ARN"
//}

//output "codepipeline_s3_bucket" {
//  value       = var.enable_codepipeline_s3 ? aws_s3_bucket.this[0].bucket : ""
//  description = "S3 Buckets for CodePipeline"
//}

//output "codepipeline_s3_bucket_arn" {
//  value       = var.enable_codepipeline_s3 ? aws_s3_bucket.this[0].arn : ""
//  description = "S3 Buckets for CodePipeline"
//}

//output "lambda_function_codepipeline_github" {
//  value       = aws_lambda_function.run_lambda_codepipeline.function_name
//  description = "ARN of Lambda Function run_lambda_codepipeline"
//}