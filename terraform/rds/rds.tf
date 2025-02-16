resource "aws_db_instance" "application_database" {
  identifier        = "gatus-${var.env}"
  allocated_storage = var.allocated_storage
  instance_class    = var.instance_class

  username = var.username
  password = var.password
  db_name  = "gatedb"


  auto_minor_version_upgrade      = true
  backup_retention_period         = var.retention_days
  db_subnet_group_name            = var.db_subnet_group_name
  vpc_security_group_ids          = [aws_security_group.db_security_group.id]
  storage_type                    = "gp2"
  storage_encrypted               = true
  engine                          = "postgres"
  engine_version                  = var.engine_version
  enabled_cloudwatch_logs_exports = ["postgresql"]
  skip_final_snapshot             = "true"
  publicly_accessible             = true
  ca_cert_identifier              = "rds-ca-rsa2048-g1"
  apply_immediately               = true

  tags = {
    Project     = title(var.app_name)
    Environment = var.env
    Area        = "Development Tools"
    SubArea     = "Monitoring"
    Team        = "Technology"
  }

  lifecycle {
    ignore_changes = [
      availability_zone,
      db_subnet_group_name,
      storage_type,
      engine,
      publicly_accessible,
      vpc_security_group_ids,
      backup_window,
      password,
      engine_version
    ]
  }
}