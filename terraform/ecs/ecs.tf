# Store logs from ECS
resource "aws_cloudwatch_log_group" "ecs_log_group" {
  name = "/aws/ecs/${var.project_name}-cluster-${var.env}"
}

# Create ECS cluster
resource "aws_ecs_cluster" "cluster" {
  name = "${var.project_name}-cluster-${var.env}"

  # Log results to cloudwatch
  configuration {
    execute_command_configuration {
      logging = "OVERRIDE"

      log_configuration {
        cloud_watch_encryption_enabled = true
        cloud_watch_log_group_name     = aws_cloudwatch_log_group.ecs_log_group.name
      }
    }
  }
} # End of cluster

module "iam" {
  source = "./iam"
  project_name = var.project_name
  env          = var.env
  vpc_id       = var.vpc_id


}

# Deploy docker container with flask app inside to ECS
resource "aws_ecs_task_definition" "task_definition" {

  # Name of ECS instance
  family = "${var.project_name}-task-${var.env}"

  enableExecuteCommand: true

  cpu                      = 256
  memory                   = 512

  # Serverless container instead of EC2
  requires_compatibilities = ["FARGATE"]

  # Gives each task its own Elastic Network Interface (ENI) and private IP
  network_mode             = "awsvpc"

  # The IAM role that grants permissions for ECS to pull images & write logs
  task_role_arn            = module.iam.ecs_task_role_arn

  # IAM role that the container itself uses
  execution_role_arn       = module.iam.ecs_task_execution_role_arn

  # Define docker container to put in ECS
  container_definitions = jsonencode([
    {
      # Container name
      name      = "${var.project_name}-${var.env}"

      # Docker image name 
      image     = var.container_image
      essential = true

      # This can't be passed in directly to dockerfile
      environment = [
        {
          name: "DB_PASSWORD",
          value: var.db_password
        }
      ]

      portMappings = [
        {
          name          = "http"

          # Port inside the container where the Flask application is running 
          containerPort = 8080

          # Port on the Fargate instance that will be mapped to the container port.
          hostPort      = 8080

          # These ports must be the same for Fargate
        }
      ]

      logConfiguration = {
        logDriver = "awslogs"

        options = {

          # Name of the CloudWatch log group to which the logs will be sent
          "awslogs-group"         = "/aws/ecs/${var.project_name}"

          # Automatically creates the log group if it doesn't already exist
          "awslogs-create-group"  = "true"

          # Specifies the AWS region where CloudWatch logs will be stored 
          "awslogs-region"        = var.region

          # Adds a prefix to the log stream name, eg dev, prod
          "awslogs-stream-prefix" = var.env
        }
      }

      healthCheck = {
        # Check if the container is running
        command     = ["CMD-SHELL", "wget -qO- localhost:8080/"]
        interval    = 30
        timeout     = 5
        retries     = 10
        startPeriod = 60
      }
    },
  ]) # End of container_definitions

  runtime_platform {
    operating_system_family = "LINUX"
  }
} # End of cluster


resource "aws_service_discovery_http_namespace" "namespace" {
  name = "${var.env}.${var.project_name}.local"
}

resource "aws_ecs_service" "service" {

  # Name of ECS service
  name                              = "${var.project_name}-service-${var.env}"

  # The ECS cluster where this service will run
  cluster                           = aws_ecs_cluster.cluster.id

  # The task definition that will be used by this ECS service
  task_definition                   = aws_ecs_task_definition.task_definition.arn
  
  # The number of tasks (containers) you want to run in this ECS service
  desired_count                     = 1

  # Serverless computer engine
  launch_type                       = "FARGATE"

  # Ensures service runs a specified number of task replicas (based on desired_count). The service will keep that number of tasks running and replace any that fail.
  scheduling_strategy               = "REPLICA"

  # Will wait 60 seconds after the container starts before running health checks to give it time to initialize
  health_check_grace_period_seconds = 60

  # Enabling this allows you to run commands in the containers from the ECS console or AWS CLI
  enable_execute_command            = true 

  network_configuration {

    # Defines the subnets in which the ECS tasks will run
    subnets          = var.public_subnets

    # Specifies the security groups that will be applied to the ECS service's tasks
    security_groups  = [aws_security_group.service_security_group.id]

    # ECS tasks will get a public IP address so they can be accessed from the internet
    assign_public_ip = true

  } # End of network_configuration

  deployment_circuit_breaker {

    # ECS will automatically roll back to the previous healthy version if a deployment fails
    enable   = true

    # CS will revert to the last known good state if there is a problem with the deployment
    rollback = true
    
  } # End of deployment_circuit_breaker

  # Maximum number of tasks you can have during a deployment, as a percentage of the desired task count
  deployment_maximum_percent         = 200

  # Minimum number of healthy tasks during a deployment, as a percentage of the desired task count
  deployment_minimum_healthy_percent = 100

}


