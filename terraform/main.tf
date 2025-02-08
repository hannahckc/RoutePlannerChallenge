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

  user_data = <<-EOF
              #!/bin/bash
              
              # Update package list and install PostgreSQL client
              sudo yum update -y
              sudo yum install -y postgresql postgresql-server

              # Start PostgreSQL service
              sudo service postgresql initdb
              sudo service postgresql start
              sudo chkconfig postgresql on

              # Create database and user
              sudo -u postgres psql -c "CREATE DATABASE gatedb;"
              
              # Save the SQL script to a file on the EC2 instance
              echo "${file("${path.module}/create-local-postgres-db.sql")}" > /home/ec2-user/database_script.sql

              # Run the SQL script on the RDS instance
              psql -h localhost -U postgres -d gatedb -f /home/ec2-user/database_script.sql

              # (Optional) Run any additional setup steps, like starting Django, etc.
              EOF

  tags = {
    # Name that will appear on AWS console
    Name = "myRoutePlanner"
  }

  security_groups = [aws_security_group.django_sg.name]
  
}
