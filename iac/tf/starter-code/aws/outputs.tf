# Outputs
output "s3_bucket_id" {
  description = "The name of the bucket."
  value       = module.s3_bucket.s3_bucket_id
}

output "s3_bucket_arn" {
  description = "The arn of the bucket."
  value       = module.s3_bucket.s3_bucket_arn
}