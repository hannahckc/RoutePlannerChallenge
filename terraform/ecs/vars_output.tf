output "ecs_cluster_name" {
  value = aws_ecs_cluster.cluster.name
  description = "The name of the ECS cluster"
}

output "ecs_service_name" {
  value = aws_ecs_service.service.name
  description = "The name of the ECS service"
}
