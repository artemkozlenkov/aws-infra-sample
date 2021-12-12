locals {
  lock_key_id = "LockID"
}

module "dynamodb" {
  source  = "terraform-aws-modules/dynamodb-table/aws"
  version = "1.1.0"

  name     = var.dynamodb_table_name
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
