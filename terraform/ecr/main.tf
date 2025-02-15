# Create an ECR repository
resource "aws_ecr_repository" "ecr_repo_for_docker_image" {
  name = var.repository_name

  force_delete = true 
}