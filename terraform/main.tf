data "aws_ami" "latest_arm_ami" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "architecture"
    values = ["arm64"]
  }

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-arm64-gp2"]  # Amazon Linux 2
  }
}

# Provider Configuration
provider "aws" {

}

resource "aws_instance" "routePlanner" {
  ami           = data.aws_ami.latest_arm_ami.id
  instance_type = "t4g.micro"  # ARM64-compatible instance
  key_name      = var.private_key_name

  tags = {
    # Name that will appear on AWS console
    Name = "myRoutePlanner"
  }

  security_groups = [aws_security_group.django_sg.name]

   # User data script to install PostgreSQL
  user_data = <<-EOT
              #!/bin/bash
              sudo yum update -y
              sudo amazon-linux-extras enable postgresql13
              sudo yum install -y postgresql-server postgresql-contrib
              sudo postgresql-setup initdb
              sudo systemctl enable postgresql
              sudo systemctl start postgresql
              sudo systemctl status postgresql
              EOT
  
}

resource "aws_db_instance" "postgresdb" {
  allocated_storage    = 20            # Storage in GB
  instance_class       = "db.t4g.micro"  # Database instance type
  engine               = "postgres"     # PostgreSQL engine
  engine_version       = "17.2"         # PostgreSQL version
  identifier           = "my-postgresdb-instance"  # This is your DB instance name
  username             = var.db_username
  password             = var.db_password
  db_name              = "gatedb"

  # Make instance private (set to false for public access)
  publicly_accessible    = false

  vpc_security_group_ids = [aws_security_group.django_sg.id]

  skip_final_snapshot = true

}