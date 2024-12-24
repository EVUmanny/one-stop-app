variable "region" {
  description = "The AWS region where the API Gateway is deployed"
  type        = string
}

variable "lambda_function_invoke_arn" {
  description = "The ARN of the Lambda function to integrate with API Gateway"
  type        = string
}

variable "api_name" {
  description = "The name of the API Gateway"
  type        = string
}

variable "resource_path" {
  description = "The path for the API resource"
  type        = string
}

variable "stage_name" {
  description = "The stage name for the API Gateway (e.g., dev, prod)"
  type        = string
}

variable "cognito_user_pool_arn" {
  description = "The ARN of the Cognito User Pool to secure API Gateway"
  type        = string
}