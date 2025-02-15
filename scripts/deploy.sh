#!/bin/bash

# Check for necessary arguments
if [ -z "$1" ]; then
  echo "Usage: $0 <image_tag>"
  exit 1
fi

# Variables
AWS_REGION=${AWS_REGION}
IMAGE_TAG=$1
AWS_ACCOUNT_ID=$(aws sts get-caller-identity --query "Account" --output text)
ECR_URI="${ECR_URI}:${IMAGE_TAG}"

echo "Region: $AWS_REGION"
echo "AWS_ACCOUNT = $AWS_ACCOUNT_ID"
echo "ECR_URI = $ECR_URI"

# Build the Docker image
echo "Building Docker image..."
docker build \
    --build-arg DB_HOST="$DB_HOST" \
    --build-arg DB_USER="$DB_USER" \
    --build-arg DB_PASSWORD="$DB_PASSWORD" \
    --build-arg DB_PORT="$DB_PORT" \
    --build-arg DB_NAME="$DB_NAME" \
    -t $ECR_URI .

# Authenticate Docker to ECR
echo "Authenticating Docker to ECR..."
aws ecr get-login-password --region $AWS_REGION | docker login --username AWS --password-stdin $ECR_URI

# Push the image to ECR
echo "Pushing Docker image to ECR..."
docker push $ECR_URI

echo "Image pushed to ECR: ${ECR_URI}"
