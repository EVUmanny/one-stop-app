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


# Database module
module "database" {
  source            = "./modules/database"
  db_name           = "onestopapp"
  username          = "admin"
  password          = "securepassword123"
  security_group_ids = [module.networking.security_group_id]
  subnet_group_name = module.networking.db_subnet_group_name
  environment       = "development"
}



# Random string for unique names
resource "random_string" "suffix" {
  length  = 6
  special = false
  upper   = false
}


module "lambda" {
  source                 = "./modules/lambda"
  function_name          = "one-stop-app-function"
  runtime                = "python3.8"
  handler                = "index.handler"
  role_arn               = aws_iam_role.lambda_role.arn
  source_code            = "lambda_function.zip"
  environment_variables  = { DB_HOST = module.database.db_instance_endpoint }
  environment            = "development"
}

module "api_gateway" {
  source                     = "./modules/api_gateway"
  api_name                   = "one-stop-app-api"
  resource_path              = "bookings"
  lambda_function_invoke_arn = module.lambda.lambda_function_arn
  stage_name                 = "development"
}