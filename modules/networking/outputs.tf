output "vpc_id" {
  value = aws_vpc.main.id
}

output "private_subnets" {
  description = "IDs of private subnets"
  value       = aws_subnet.private[*].id
}

output "public_subnets" {
  description = "IDs of public subnets"
  value       = aws_subnet.public[*].id
}
output "security_group_id" {
  description = "The ID of the security group"
  value       = aws_security_group.default.id
}

output "db_subnet_group_name" {
  description = "The name of the database subnet group"
  value       = aws_db_subnet_group.db_subnet_group.name
}
