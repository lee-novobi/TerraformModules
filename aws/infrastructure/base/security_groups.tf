resource "aws_security_group" "sg_alb" {
  count       = var.enable_alb ? 1 : 0
  name        = "${lower(var.name)}-alb-sg"
  description = "[${lower(var.name)}] Security group for ALB"
  vpc_id      = module.vpc.vpc_id

  ingress {

    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
    description      = "HTTPS"
  }

  ingress {

    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
    description      = "HTTP"
  }
  tags = {
    Name = "${var.name}-alb-sg"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }


}

resource "aws_security_group" "sg_public" {
  name        = "${lower(var.name)}-public-sg"
  description = "[${lower(var.name)}] Security group for Applications in Public Subnet and LB"
  vpc_id      = module.vpc.vpc_id

  ingress {

    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
    description      = "HTTPS"
  }

  ingress {

    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
    description      = "HTTP"
  }

  ingress {


    from_port       = 32000
    to_port         = 65535
    protocol        = "tcp"
    security_groups = aws_security_group.sg_alb.*.id
    description     = "HTTPS"
  }


  ingress {

    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["10.1.0.0/24"]
    description = "SSH from vpn"
  }


  tags = {
    Name = "${var.name}-public-sg"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }


}


resource "aws_security_group" "sg_private" {
  name        = "${lower(var.name)}-private-sg"
  description = "[${lower(var.name)}] Security group for Applications in Private Subnet"
  vpc_id      = module.vpc.vpc_id

  ingress {

    from_port       = 32000
    to_port         = 65535
    protocol        = "tcp"
    security_groups = aws_security_group.sg_alb.*.id
    description     = "HTTPS"
  }

  ingress {

    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["10.1.0.0/24"]
    description = "SSH from vpn"
  }


  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "${var.name}-sg_private"
  }


}