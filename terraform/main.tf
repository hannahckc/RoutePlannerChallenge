# Provider Configuration
provider "aws" {
  region     = var.aws_region
  access_key = var.aws_access_key_id
  secret_key = var.aws_secret_access_key
  version = "~> 5.84.0" # Specify the version

}

# Define an EC2 instance
resource "aws_instance" "routePlanner" {
  ami           = "ami-0c55b159cbfafe1f0" 
  instance_type = "t2.micro" 

  tags = {
    # Name that will appear on AWS console
    Name = "myRoutePlanner"
  }

  security_groups = [aws_security_group.django_sg.name]
}