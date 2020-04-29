locals {
  sg_public  = var.allow_public_subnets ? ["${data.terraform_remote_state.base_layout.outputs.sg_public}"] : []
  sg_private = var.allow_private_subnets ? ["${data.terraform_remote_state.base_layout.outputs.sg_private}"] : []
}

resource "aws_security_group" "sg_efs" {
  name        = "${lower(var.name)}-efs-sg"
  description = "[${lower(var.name)}] Security group for EFS"
  vpc_id      = "${data.terraform_remote_state.base_layout.outputs.vpc_id}"

  ingress {
    from_port       = 2049
    to_port         = 2049
    protocol        = "tcp"
    security_groups = local.sg_public
    description     = "NFS Port for Public SG"
  }

  ingress {
    from_port       = 2049
    to_port         = 2049
    protocol        = "tcp"
    security_groups = local.sg_private
    description     = "NFS Port for Private SG"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.name}-efs-sg"
  }
}