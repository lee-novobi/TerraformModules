resource "tls_private_key" "this" {
  algorithm = "RSA"
  rsa_bits  = 4096
}
resource "aws_key_pair" "this" {
  key_name   = "${var.name}_keypair"
  public_key = var.public_key
}


data "aws_ami" "ecs_ami" {
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn2-ami-ecs-hvm-*-x86_64-ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["amazon"]
}

resource "aws_ami_copy" "ecs_ami_encrypted" {
  name              = "${data.aws_ami.ecs_ami.id}-ECS-Encrypted"
  description       = "A copy of ${data.aws_ami.ecs_ami.id}"
  source_ami_id     = "${data.aws_ami.ecs_ami.id}"
  source_ami_region = "${data.terraform_remote_state.base_layout.outputs.aws_region}"
  encrypted         = true

  tags = {
    Name = "[${var.name}] ECS AMI encrypted"
  }
}


resource "aws_iam_instance_profile" "this" {
  name = "${lower(var.name)}_ecs_instance_profile"
  role = "${data.terraform_remote_state.ecs_cluster.outputs.ecs_cluster_iam_role_arn}"
}


resource "aws_launch_template" "this" {
  name          = "${var.name}-launch-template"
  image_id      = "${aws_ami_copy.ecs_ami_encrypted.id}"
  instance_type = var.instance_type
  key_name      = "${aws_key_pair.this.key_name}"

  vpc_security_group_ids = ["${var.run_in_public_subnets ? data.terraform_remote_state.base_layout.outputs.sg_public : data.terraform_remote_state.base_layout.outputs.sg_private}"]
  iam_instance_profile {
    arn = "${aws_iam_instance_profile.this.arn}"
  }
  block_device_mappings {
    device_name = "/dev/xvda"

    ebs {
      volume_size = "${var.volume_size}"
    }
  }

  ebs_optimized = true
  user_data = "${base64encode(templatefile("templates/user-data.sh", {
    cluster_name = "${data.terraform_remote_state.ecs_cluster.outputs.cluster_name}"
    efs_dns_name = var.has_efs ? data.terraform_remote_state.efs[0].outputs.efs_dns_name : ""
  }))}"

}