resource "aws_ecr_repository" "this" {
  name                 = "${lower(var.repository_name)}"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}


data "aws_iam_policy_document" "aws_ecr_repository_policy" {
  count   = length(var.aws_accounts) > 0 ? 1 : 0
  version = "2008-10-17"
  statement {
    sid = "Allow All from another accounts"

    actions = [
      "ecr:GetAuthorizationToken",
      "ecr:BatchCheckLayerAvailability",
      "ecr:BatchGetImage",
      "ecr:DescribeImages",
      "ecr:GetDownloadUrlForLayer"
    ]

    principals {
      type        = "AWS"
      identifiers = formatlist("arn:aws:iam::%s:root", var.aws_accounts)
    }
  }
}

resource "aws_ecr_repository_policy" "this" {
  count      = length(var.aws_accounts) > 0 ? 1 : 0
  repository = "${aws_ecr_repository.this.name}"

  policy = "${data.aws_iam_policy_document.aws_ecr_repository_policy[0].json}"
}