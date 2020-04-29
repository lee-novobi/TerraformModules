output "launch_template_arn" {
  value = aws_launch_template.this.arn
  description = "The ARN of the launch template"
}
output "launch_template_id" {
  value = aws_launch_template.this.id
  description = "The ID of the launch template"
}
output "launch_template_default_version" {
  value = aws_launch_template.this.default_version
  description = "The default version of the launch template"
}
output "launch_template_latest_version" {
  value = aws_launch_template.this.latest_version
  description = "The latest version of the launch template"
}

output "asg_arn" {
  value = aws_autoscaling_group.this.arn
  description = "The ARN of the autoscaling group"
}
output "asg_id" {
  value = aws_autoscaling_group.this.id
  description = "The ID of the autoscaling group"
}
output "asg_name" {
  value = aws_autoscaling_group.this.name
  description = "The name of the autoscaling group"
}