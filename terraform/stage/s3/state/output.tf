output "tfstate_bucket_name" {
  value = module.state_bucket.s3_bucket_id
}

output "tfstate_dynamodb_lock" {
  value = module.dynamodb.dynamodb_table_id
}
