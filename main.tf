provider "aws" {
  region = "eu-west-2"
}

module "networking" {
  source       = "./modules/networking"
  cidr_block   = "10.0.0.0/16"
  subnet_count = 2
}


# S3 module

module "s3" {
  source      = "./modules/s3"
  bucket_name = "one-stop-app-bucket-${random_string.suffix.result}"  # Bucket name should now be valid
  environment = "development"
}

# Random string to append to bucket name to ensure it's unique
resource "random_string" "suffix" {
  length  = 6
  special = false
  upper   = false   # Ensure that we only get lowercase characters
}
