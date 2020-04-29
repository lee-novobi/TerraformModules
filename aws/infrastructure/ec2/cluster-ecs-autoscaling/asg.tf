resource "aws_autoscaling_group" "this" {
  name               = "${var.name}-autoscaling_groups"
  availability_zones = data.terraform_remote_state.base_layout.outputs.azs
  desired_capacity   = "${var.desired_capacity}"
  max_size           = "${var.max_size}"
  min_size           = "${var.min_size}"

  launch_template {
    id      = "${aws_launch_template.this.id}"
    version = "${aws_launch_template.this.latest_version}"
  }

  vpc_zone_identifier = var.run_in_public_subnets ? data.terraform_remote_state.base_layout.outputs.public_subnets : data.terraform_remote_state.base_layout.outputs.private_subnets


  lifecycle {
    create_before_destroy = true
  }

  tag {
    key    = "Name"
    value  = "${var.name}"
    propagate_at_launch = true
  }

}