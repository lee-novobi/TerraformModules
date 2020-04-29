resource "aws_kms_key" "cluster_key" {
  count                   = var.enable_kms ? 1 : 0
  description             = "KMS key for {$var.name}"
  deletion_window_in_days = 30

  tags = {
    Environment = "${var.environment}"
    Name        = "${var.name} KMS Key"
  }
}