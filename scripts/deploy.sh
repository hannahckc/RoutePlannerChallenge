#!/bin/bash

# Check for necessary arguments
if [ -z "$1" ]; then
  echo "Usage: $0 <image_tag>"
  exit 1
fi

# Variables
AWS_REGION=${AWS_REGION}
IMAGE_TAG=$1
ECR_URI=${ECR_URI}
ECR_WITH_TAG="${ECR_URI}:${IMAGE_TAG}"

echo "ECR_WITH_TAG=$ECR_WITH_TAG" >> $GITHUB_ENV

echo "Region: $AWS_REGION"
echo "ECR_URI = $ECR_URI"
echo "With tag: $ECR_WITH_TAG"

pwd
cd flaskApp
pwd
ls -ltr

# Build the Docker image
echo "Building Docker image..."
docker build --platform linux/amd64 \
    --no-cache \
    --build-arg DB_HOST="$DB_HOST" \
    --build-arg DB_USERNAME="$DB_USERNAME" \
    --build-arg DB_PASSWORD="$DB_PASSWORD" \
    --build-arg DB_PORT="$DB_PORT" \
    -t $ECR_WITH_TAG .

docker tag $ECR_WITH_TAG $ECR_URI


# Authenticate Docker to ECR
echo "Authenticating Docker to ECR..."
aws ecr get-login-password --region $AWS_REGION | docker login --username AWS --password-stdin $ECR_WITH_TAG

# Push the image to ECR
echo "Pushing Docker image to ECR..."
docker push $ECR_WITH_TAG

echo "Image pushed to ECR: ${ECR_WITH_TAG}"
