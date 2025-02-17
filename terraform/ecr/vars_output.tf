output "repository_url" {
  description = "URL of ECR repo"
  value = aws_ecr_repository.ecr_repo_for_docker_image.repository_url
}