resource "aws_iam_role" "ecs_execution_role" {
  name = "${var.name}-${var.service_name}-iam-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ecs-tasks.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}


resource "aws_iam_policy" "extra" {
  count       = var.has_task_role_policies ? 1 : 0
  name        = "${var.name}-${data.terraform_remote_state.ecs_ecr.outputs.registry_id}-extra-policies"
  description = "extra policies for task role"

  policy = var.extra_task_role_policies
}

resource "aws_iam_role_policy_attachment" "ecs-access-ecr-attach" {
  count      = var.has_task_role_policies ? 1 : 0
  role       = aws_iam_role.ecs_execution_role.name
  policy_arn = aws_iam_policy.extra[0].arn
}


resource "aws_iam_role_policy" "ecr_policy" {
  name = "ecr_policy"
  role = aws_iam_role.ecs_execution_role.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
            "Effect": "Allow",
            "Action": [
                "ecr:GetDownloadUrlForLayer",
                "ecr:BatchGetImage",
                "ecr:DescribeImages",
                "ecr:ListImages",
                "ecr:BatchCheckLayerAvailability",
                "ecr:GetAuthorizationToken"
            ],
            "Resource": "*"
        }
  ]
}
EOF
}