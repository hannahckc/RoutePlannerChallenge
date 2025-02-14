resource "aws_security_group" "db_security_group" {
  name        = "${var.app_name}-${var.env}-db-sg"
  description = "${var.app_name}-${var.env}-db-sg"
  vpc_id      = var.vpc_id

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  timeouts {
    delete = "2m"
  }
}

resource "aws_security_group_rule" "security_group_rule" {
  for_each = var.ingress_access
  type      = "ingress"
  from_port = 5432
  to_port   = 5432
  protocol  = "tcp"
  description = "Allow traffic from anywhere to database"
  cidr_blocks = ["0.0.0.0/0"]  # Allow HTTP from anywhere

}