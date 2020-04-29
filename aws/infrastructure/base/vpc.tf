module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name             = "${var.name}-VPC"
  cidr             = var.cidr_block
  azs              = var.azs
  private_subnets  = var.private_subnets
  #database_subnets = var.database_subnets
  public_subnets   = var.public_subnets

  create_database_subnet_group = false

  enable_nat_gateway     = var.enable_nat_gateway
  single_nat_gateway     = var.single_nat_gateway
  one_nat_gateway_per_az = var.one_nat_gateway_per_az
  enable_vpn_gateway     = false
  enable_dns_hostnames   = true


  tags = {
    Terraform   = "true"
    Environment = var.environment
  }
}