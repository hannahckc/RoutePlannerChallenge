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

  # Copy the Django app directory from repo to EC2
  provisioner "file" {
    source      = "../djangoApp"  # Local path to Django project
    destination = "/home/ec2-user/djangoApp"  # Amazon Linux 2 default user
  }

  # SSH Connection for provisioner
  connection {
    type        = "ssh"
    user        = "ec2-user"  # Default Amazon Linux 2 user
    private_key = var.private_key_value  # Path to your private key
    host        = self.public_ip  # Connect using the instance's public IP
  }

  security_groups = [aws_security_group.django_sg.name]

   # User data script to install PostgreSQL
  user_data = file("install.sh")
              
  
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

  publicly_accessible    = true

  vpc_security_group_ids = [aws_security_group.django_sg.id]

  skip_final_snapshot = true

}