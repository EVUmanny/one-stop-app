variable "api_name" {
  description = "Name of the API Gateway"
  type        = string
}

variable "resource_path" {
  description = "Path for the API resource"
  type        = string
}

variable "lambda_function_invoke_arn" {
  description = "The ARN of the Lambda function to invoke"
  type        = string
}

variable "stage_name" {
  description = "The deployment stage name (e.g., dev, prod)"
  type        = string
  default     = "dev"
}