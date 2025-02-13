output "public_ip" {
  value = aws_instance.routePlanner.public_ip
}

output "rds_endpoint" {
  value = aws_db_instance.postgresdb.endpoint
}

output "rds_port" {
  value = aws_db_instance.postgresdb.port
}

output "ecr_repo_url" {
  value = aws_ecr_repository.flask_app.repository_url
}