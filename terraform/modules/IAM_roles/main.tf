module "label" {
  source  = "cloudposse/label/null"
  version = "0.24.1"

  namespace   = var.namespace
  environment = var.environment
  name        = var.name
  tags        = var.tags
}

# A role, with no permissions, which can be assumed by users within the same account
resource "aws_iam_role" "this" {
  name               = module.label.id
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json
  tags               = module.label.tags
}
data "aws_caller_identity" "this" {}

data "aws_iam_policy_document" "assume_role_policy" {
  statement {
    effect = "Allow"
    actions = [
      "sts:AssumeRole",
    ]
    principals {
      identifiers = [data.aws_caller_identity.this.account_id]
      type        = "AWS"
    }
  }
}

# A policy, allowing users / entities to assume the above role
data "aws_iam_policy_document" "group_policy" {
  statement {
    effect    = "Allow"
    actions   = ["sts:AssumeRole"]
    resources = [aws_iam_role.this.arn]
  }
}

resource "aws_iam_policy" "group_policy" {
  name   = module.label.id
  policy = data.aws_iam_policy_document.group_policy.json
}

# A group, with the above policy attached
resource "aws_iam_group" "group" {
  name = module.label.id
  path = "/users/"
}


resource "aws_iam_group_policy_attachment" "group_policy" {
  group      = aws_iam_group.group.name
  policy_arn = aws_iam_policy.group_policy.arn
}

# A user, belonging to the above group.
resource "aws_iam_user" "user" {
  name = module.label.id
}

resource "aws_iam_group_membership" "this" {
  name = module.label.id

  users = [
    aws_iam_user.user.name,
  ]

  group = aws_iam_group.group.name
}