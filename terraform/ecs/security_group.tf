resource "aws_security_group" "service_security_group" {
  name        = "${var.project_name}-service-sg-${var.env}"
  description = "ECS service security group"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # HTTP traffic from anywhere (you can limit this to your IP)
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]  # Allow all outbound traffic (can be restricted)
  }
}

resource "aws_security_group_rule" "ecs_to_rds" {
  type                     = "ingress"
  from_port                = 5432
  to_port                  = 5432
  protocol                 = "tcp"
  security_group_id        = module.database.aws_security_group.db_security_group.id  # Targeting RDS SG
  source_security_group_id = module.database.aws_security_group.service_security_group.id  # Allow traffic from ECS service SG
  description              = "Allow ECS service to connect to RDS database"
}
