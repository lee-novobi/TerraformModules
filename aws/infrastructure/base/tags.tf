locals {
  tags = {
    SystemName  = "${var.name}"
    Environment = "${var.environment}"
  }
}