resource "aws_efs_file_system" "efs" {
  creation_token = "${lower(var.name)}-efs"
  encrypted = true

  lifecycle_policy {
    transition_to_ia = "AFTER_30_DAYS"
  }
  tags = {
    Name = "${var.name}-EFS"
  }
}

resource "aws_efs_mount_target" "efs-mounts" {
  file_system_id = "${aws_efs_file_system.efs.id}"
  subnet_id      = data.terraform_remote_state.base_infrastructure.outputs.private_subnets[0]
  security_groups = ["${aws_security_group.sg_efs.id}"]
}