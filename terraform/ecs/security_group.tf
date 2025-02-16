resource "aws_security_group" "service_security_group" {
  name        = "${var.project_name}-service-sg-${var.env}"
  description = "${var.project_name} ECS service security group"

  # This was created manually from AWS console
  vpc_id      = var.vpc_id

# Allows ECS to send outbound traffic to anywhere on the internet
# Needed to get data from RDS (as long as on the same VPC)

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

# Allow incoming traffic from port 8080 (where Flask app is running)
# This means external clients (e.g., browsers, other services) can reach Flask app running inside ECS by sending requests to port 8080
  
  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Allow traffic from anywhere on port 8080
  }
}
