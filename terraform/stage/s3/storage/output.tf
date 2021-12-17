output "arn" {
  value = module.storage_bucket.s3_bucket_arn
}

output "name" {
  value = module.storage_bucket.s3_bucket_id
}
