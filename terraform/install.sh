#!/bin/bash

exec > >(tee -a "/home/logs/install_log") 2>&1

# Update and install dependencies
sudo apt update -y
sudo apt install -y python python-pip python-venv git

# Navigate to the app directory
cd /home/ec2-user/flask-app

# Set up virtual environment
python3 -m venv venv
source venv/bin/activate

# Install required Python packages
pip install --upgrade pip
pip install -r requirements.txt

# Ensure Flask app is executable
chmod +x app.py

# Set Flask environment variables
export FLASK_APP=app.py
export FLASK_RUN_HOST=0.0.0.0
export FLASK_ENV=production

# Run Flask app in the background
nohup flask run --host=0.0.0.0 --port=5000 > flask.log 2>&1 &

# Add a message to indicate successful installation
echo "Flask application setup is complete!"
