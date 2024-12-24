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

#Cognito User Pool
resource "aws_cognito_user_pool" "this" {
  name = "one-stop-app-user-pool"

  password_policy {
    minimum_length    = 8
    require_lowercase = true
    require_numbers   = true
    require_symbols   = true
    require_uppercase = true
  }

  auto_verified_attributes = ["email"]
}

#Cognito User Pool Client

resource "aws_cognito_user_pool_client" "this" {
  name         = "one-stop-app-client"
  user_pool_id = aws_cognito_user_pool.this.id

  explicit_auth_flows = [
    "ALLOW_USER_PASSWORD_AUTH",
    "ALLOW_REFRESH_TOKEN_AUTH",
    "ALLOW_USER_SRP_AUTH",
  ]

  allowed_oauth_flows       = ["code"]
  allowed_oauth_scopes      = ["email", "openid", "profile"]
  allowed_oauth_flows_user_pool_client = true

  callback_urls = ["https://your-frontend-domain.com/callback"] # Replace with your frontend URL
  logout_urls   = ["https://your-frontend-domain.com/logout"]  # Replace with your frontend URL
}

# Cognito Identity Pool

resource "aws_cognito_identity_pool" "this" {
  identity_pool_name               = "one-stop-app-identity-pool"
  allow_unauthenticated_identities = false

  cognito_identity_providers {
    client_id       = aws_cognito_user_pool_client.this.id
    provider_name   = aws_cognito_user_pool.this.endpoint
    server_side_token_check = true
  }
}

# IAM Roles for Cognito

resource "aws_iam_role" "authenticated_role" {
  name = "one-stop-app-authenticated-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Federated = "cognito-identity.amazonaws.com"
        },
        Action = "sts:AssumeRoleWithWebIdentity",
        Condition = {
          StringEquals = {
            "cognito-identity.amazonaws.com:aud" = aws_cognito_identity_pool.this.id
          },
          "ForAnyValue:StringLike" = {
            "cognito-identity.amazonaws.com:amr" = "authenticated"
          }
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "authenticated_role_policy" {
  role       = aws_iam_role.authenticated_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess" # Example policy; adjust as needed
}

