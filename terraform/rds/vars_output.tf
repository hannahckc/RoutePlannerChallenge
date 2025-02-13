output "security_group_id" {
  description = "ID of the database security group, so that it can be used elsewhere"
  value       = aws_security_group.db_security_group.id
}

output "db_host" {
  description = "Hostname of the database"
  value = aws_db_instance.application_database.address
}