output "security_group_id" {
  description = "ID of the database security group, so that it can be used elsewhere"
  value       = aws_security_group.db_security_group.id
}

# Output the RDS instance host
output "rds_host" {
  value = aws_db_instance.application_database.address
}

# Output the DB instance port
output "rds_port" {
  value = aws_db_instance.application_database.port
}