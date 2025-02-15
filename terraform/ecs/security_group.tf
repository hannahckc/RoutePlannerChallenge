resource "aws_security_group" "service_security_group" {
  name        = "${var.project_name}-service-sg-${var.env}"
  description = "${var.project_name} ECS service security group"
  vpc_id      = var.vpc_id
}

resource "aws_vpc_security_group_ingress_rule" "allow_internal_traffic" {
  security_group_id            = aws_security_group.service_security_group.id
  ip_protocol                  = "-1"
  referenced_security_group_id = aws_security_group.service_security_group.id
}

resource "aws_vpc_security_group_egress_rule" "ecs_allow_egress" {
  security_group_id = aws_security_group.service_security_group.id
  ip_protocol       = -1
  cidr_ipv4         = "0.0.0.0/0"
}

# Allow inbound traffic from the public internet on port 8080 (HTTP)
resource "aws_vpc_security_group_ingress_rule" "allow_http_traffic" {
  security_group_id = aws_security_group.service_security_group.id
  from_port         = 8080
  to_port           = 8080
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]  # This allows public access, you can restrict this to your IP
}
