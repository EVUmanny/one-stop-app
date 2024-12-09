output "vpc_id" {
  value = module.networking.vpc_id
}

output "s3_bucket_name" {
  value = module.s3.bucket_name
}

output "db_instance_endpoint" {
  value = module.database.db_instance_endpoint
}
