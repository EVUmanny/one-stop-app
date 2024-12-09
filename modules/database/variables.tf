variable "db_name" {
  description = "The name of the database"
  type        = string
}

variable "username" {
  description = "The master username for the database"
  type        = string
}

variable "password" {
  description = "The master password for the database"
  type        = string
  sensitive   = true
}

variable "engine" {
  description = "The database engine (e.g., mysql or postgres)"
  type        = string
  default     = "mysql"
}

variable "engine_version" {
  description = "The version of the database engine"
  type        = string
  default     = "8.0"
}

variable "instance_class" {
  description = "The size of the RDS instance"
  type        = string
  default     = "db.t3.micro"
}

variable "allocated_storage" {
  description = "The allocated storage for the database in GB"
  type        = number
  default     = 20
}

variable "security_group_ids" {
  description = "The security group IDs to attach to the database"
  type        = list(string)
}

variable "subnet_group_name" {
  description = "The DB subnet group name"
  type        = string
}

variable "environment" {
  description = "The environment for the database (e.g., dev, prod)"
  type        = string
  default     = "dev"
}
