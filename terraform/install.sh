#!/bin/bash

set -e
exec > /var/log/user-data.log 2>&1

# Install and start up postgres on ec2 instance
sudo yum update -y
sudo amazon-linux-extras enable postgresql
sudo yum install -y postgresql-server postgresql-contrib
sudo postgresql-setup initdb
sudo systemctl enable postgresql
sudo systemctl start postgresql
sudo systemctl status postgresql

# Update system and install dependencies
sudo yum update -y
sudo yum install -y python3 python3-pip python3-virtualenv git

# Move into Django app directory
cd /home/ec2-user/djangoApp

# Set up virtual environment
python3 -m venv venv
source venv/bin/activate

# Install dependencies
pip install --upgrade pip
pip install -r requirements.txt

python manage.py migrate
nohup python manage.py runserver 0.0.0.0:8000 &
