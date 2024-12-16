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
  function_name          = "one-stop-app-lambda"
  runtime                = "python3.8"
  handler                = "lambda_function.handler"
  role_arn               = aws_iam_role.lambda_role.arn
  source_code            = "lambda/lambda_function.zip"
  environment_variables  = { DB_HOST = module.database.db_instance_endpoint }
  environment            = "development"
}# In ./modules/lambda/variables.tf

module "api_gateway" {
  source                     = "./modules/api_gateway"
region                       = "eu-west-2"
  api_name                   = "one-stop-app-api"
  resource_path              = "bookings"
  stage_name                 = "development"
  lambda_function_invoke_arn = module.lambda.lambda_function_arn # Referencing the Lambda module output
}
variable "timeout" {
  description = "The amount of time your Lambda Function has to run in seconds"
  type        = number
  default     = 30
}

variable "memory_size" {
  description = "Amount of memory in MB your Lambda Function can use at runtime"
  type        = number
  default     = 128
}# In ./modules/lambda/variables.tf


variable "tags" {
  description = "A map of tags to assign to resources"
  type        = map(string)
  default     = {}
}


resource "aws_iam_policy" "lambda_rds_policy" {
  name        = "lambda-rds-policy"
  description = "IAM policy for Lambda to access RDS"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect   = "Allow",
        Action   = [
          "rds:DescribeDBInstances",
          "rds:Connect"
        ],
        Resource = "arn:aws:rds:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:db/onestopapp"
      }
    ]
  })
}

data "aws_region" "current" {}

data "aws_caller_identity" "current" {}
resource "aws_iam_role_policy_attachment" "lambda_rds_policy_attachment" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.lambda_rds_policy.arn
}

resource "aws_iam_role_policy_attachment" "lambda_basic_execution" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_iam_role_policy_attachment" "lambda_access_rds" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonRDSFullAccess"
}
resource "aws_iam_role" "lambda_role" {
  name               = "one-stop-app-lambda-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "lambda.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })

  tags = {
    Name = "one-stop-app-lambda-role"
  }
}