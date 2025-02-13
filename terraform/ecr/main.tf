# Create an ECR repository
resource "aws_ecr_repository" "ecr_repo_for_docker_image" {
  name = var.repository_name
}

# Run the deploy.sh script after ECR repository is created
resource "null_resource" "deploy_docker_image" {
  depends_on = [aws_ecr_repository.ecr_repo_for_docker_image]

  provisioner "local-exec" {
    command = "bash deploy.sh v1.0"
    environment = {
      AWS_REGION     = var.region
      REPO_NAME      = var.repository_name
      REPOSITORY_URI = aws_ecr_repository.ecr_repo_for_docker_image.repository_url
    }
  }
}