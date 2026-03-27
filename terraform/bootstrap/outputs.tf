output "s3_bucket" {
  value = module.tf_state_bucket.s3_bucket_id
}

output "dynamodb_table" {
  value = module.tf_state_lock_table.dynamodb_table_id
}
