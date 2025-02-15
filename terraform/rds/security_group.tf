resource "aws_security_group" "db_security_group" {
  name        = "${var.app_name}-${var.env}-db-sg"
  description = "${var.app_name}-${var.env}-db-sg"
  vpc_id      = var.vpc_id

  # Allow outbound traffic to anywhere
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Allow traffic from anywhere
  }
}
