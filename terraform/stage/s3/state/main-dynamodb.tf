locals {
  lock_key_id = "LockID"
  dynamodb_table_name = "tfstate_dynamodb_lock"
}

data "aws_iam_policy_document" "dynamodb_policy" {
  statement {
    principals {
      type        = "AWS"
      identifiers = [aws_iam_role.this.arn]
    }
    actions = [
      "dynamodb:GetItem",
      "dynamodb:PutItem",
      "dynamodb:DeleteItem"
    ]
    resources = ["${module.dynamodb.dynamodb_table_arn}/${module.dynamodb.dynamodb_table_id}"]
    effect    = "Allow"
  }
}

module "dynamodb" {
  source  = "terraform-aws-modules/dynamodb-table/aws"
  version = "1.1.0"

  name     = local.dynamodb_table_name
  hash_key = local.lock_key_id

  attributes = [
    {
      name = local.lock_key_id
      type = "S"
    }
  ]

  point_in_time_recovery_enabled = true

  tags = var.tags
}
