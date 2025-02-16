# Create an ECR repository to store the docker image in
resource "aws_ecr_repository" "ecr_repo_for_docker_image" {
  name = var.repository_name

  force_delete = true 
}