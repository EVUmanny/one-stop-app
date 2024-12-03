variable "cidr_block" {
  description = "CIDR block for the VPC"
  default     = "10.0.0.0/16"
}

variable "subnet_count" {
  description = "Number of public subnets"
  default     = 2
}
