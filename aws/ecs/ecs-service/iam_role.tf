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


#Mysql

resource "aws_iam_policy" "read-mysql-credential" {
  count       = var.has_mysql_database ? 1 : 0
  name        = "${var.name}-${var.service_name}-read-mysql-credential-policy"
  description = "lambda-read_mysql-root-credential-policy"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "ssm:GetParameters",
        "ssm:GetParameter"
      ],
      "Effect": "Allow",
      "Resource": "${data.terraform_remote_state.mysql_database[0].outputs.ssm_db_credential_arn}"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "read-mysql-credential-attach" {
  count      = var.has_mysql_database ? 1 : 0
  role       = aws_iam_role.ecs_execution_role.name
  policy_arn = aws_iam_policy.read-mysql-credential[0].arn
}


#Postgres

resource "aws_iam_policy" "read-postgres-credential" {
  count       = var.has_postgres_database ? 1 : 0
  name        = "${var.name}-${var.service_name}-read-mysql-credential-policy"
  description = "lambda-read_mysql-root-mysqlcredential-policy"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "ssm:GetParameters",
        "ssm:GetParameter"
      ],
      "Effect": "Allow",
      "Resource": "${data.terraform_remote_state.postgres_database[0].outputs.ssm_db_credential_arn}"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "read-postgres-credential-attach" {
  count      = var.has_postgres_database ? 1 : 0
  role       = aws_iam_role.ecs_execution_role.name
  policy_arn = aws_iam_policy.read-postgres-credential[0].arn
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

#Redis

resource "aws_iam_policy" "read-redis-host" {
  count       = var.has_redis ? 1 : 0
  name        = "${var.name}-${var.service_name}-read-redis-host-policy-parameter-store"
  description = "read_postgres_master_credential-policy"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "ssm:GetParameters",
        "ssm:GetParameter"
      ],
      "Effect": "Allow",
      "Resource": ["${data.terraform_remote_state.redis[0].outputs.aws_ssm_parameter_redis_host_arn}"]
    },{
      "Effect": "Allow",
      "Action": [
         "kms:ListKeys",
         "kms:ListAliases",
         "kms:Describe*",
         "kms:Decrypt"
      ],
      "Resource": ["${data.terraform_remote_state.base_layout.outputs.kms_key_id}"]
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "read-redis-host-attach" {
  count      = var.has_redis ? 1 : 0
  role       = aws_iam_role.ecs_execution_role.name
  policy_arn = aws_iam_policy.read-redis-host[0].arn
}


#SQS


resource "aws_iam_policy" "sqs_policy" {
  name   = "sqs_policy-${var.service_name}"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
            "Effect": "Allow",
            "Action": [
                "sqs:*"
            ],
            "Resource": "*"
        }
  ]
}
EOF
}


resource "aws_iam_role_policy_attachment" "sqs_policy_attachment" {
  role       = aws_iam_role.ecs_execution_role.name
  policy_arn = aws_iam_policy.sqs_policy.arn
}
