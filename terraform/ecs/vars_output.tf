output "ecs_task_public_ip" {
  description = "Public IP of ECS Task"
  value       = data.aws_network_interface.ecs_task_eni.association[0].public_ip
}
