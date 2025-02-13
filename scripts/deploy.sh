#!/bin/bash

# Check for necessary arguments
if [ -z "$1" ]; then
  echo "Usage: $0 <image_tag>"
  exit 1
fi

# Variables
AWS_REGION=${AWS_REGION}
REPOSITORY_NAME="my-docker-repo" # This should match the repository name in Terraform
IMAGE_TAG=$1
AWS_ACCOUNT_ID=$(aws sts get-caller-identity --query "Account" --output text)
ECR_URI="${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/${REPOSITORY_NAME}:${IMAGE_TAG}"

# Build the Docker image
echo "Building Docker image..."
docker build -t ${ECR_URI} .

# Authenticate Docker to ECR
echo "Authenticating Docker to ECR..."
aws ecr get-login-password --region ${AWS_REGION} | docker login --username AWS --password-stdin ${ECR_URI}

# Push the image to ECR
echo "Pushing Docker image to ECR..."
docker push ${ECR_URI}

echo "Image pushed to ECR: ${ECR_URI}"
