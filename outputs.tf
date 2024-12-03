output "s3_bucket_name" {
  description = "The name of the S3 bucket"
  value       = module.s3.bucket_name
}

output "vpc_id" {
  value = module.networking.vpc_id
}
