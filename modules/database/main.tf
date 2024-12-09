resource "aws_db_instance" "this" {
  allocated_storage    = var.allocated_storage
  engine               = var.engine
  engine_version       = var.engine_version
  instance_class       = var.instance_class
  db_name              = var.db_name  # Correct argument
  username             = var.username
  password             = var.password
  publicly_accessible  = false
  vpc_security_group_ids = var.security_group_ids
  db_subnet_group_name = var.subnet_group_name

skip_final_snapshot  = true  # Skip the final snapshot

  tags = {
    Name        = var.db_name
    Environment = var.environment
  }
}
