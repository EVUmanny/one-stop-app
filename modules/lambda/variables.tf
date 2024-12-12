variable "function_name" {
  description = "Name of the Lambda function"
  type        = string
}

variable "runtime" {
  description = "Runtime environment for the Lambda function"
  type        = string
  default     = "python3.8"
}

variable "handler" {
  description = "The entry point for the Lambda function"
  type        = string
  default     = "index.handler"
}

variable "role_arn" {
  description = "The ARN of the IAM role for the Lambda function"
  type        = string
}

variable "source_code" {
  description = "Path to the ZIP file containing the Lambda function code"
  type        = string
}

variable "environment_variables" {
  description = "Environment variables for the Lambda function"
  type        = map(string)
  default     = {}
}

variable "environment" {
  description = "The environment for the Lambda function (e.g., dev, prod)"
  type        = string
  default     = "dev"
}