#!/bin/bash

mkdir /home/lo
exec > >(tee -a "/var/log/install_log") 2>&1

echo "Writing db host name to env"
echo "DB_HOST=${aws_db_instance.postgresdb.endpoint}" | sudo tee -a /etc/environment

sudo yum update -y
sudo amazon-linux-extras enable docker
sudo yum install -y docker
sudo systemctl start docker
sudo systemctl enable docker
sudo usermod -aG docker ec2-user
sudo yum install -y aws-cli

# Add a message to indicate successful installation
echo "Flask application setup is complete!"
