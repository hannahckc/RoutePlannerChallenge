resource "aws_cloudwatch_log_group" "ecs_log_group" {
  name = "/aws/ecs/${var.project_name}-cluster-${var.env}"
}

resource "aws_ecs_cluster" "cluster" {
  name = "${var.project_name}-cluster-${var.env}"

  configuration {
    execute_command_configuration {
      logging = "OVERRIDE"

      log_configuration {
        cloud_watch_encryption_enabled = true
        cloud_watch_log_group_name     = aws_cloudwatch_log_group.ecs_log_group.name
      }
    }
  }
}

resource "aws_ecs_task_definition" "task_definition" {
  family = "${var.project_name}-task-${var.env}"
  container_definitions = jsonencode([
    {
      name      = "${var.project_name}-${var.env}"
      image     = var.container_image
      essential = true

      portMappings = [
        {
          name          = "http"
          containerPort = 5000
          hostPort      = 8080
        }
      ]

      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = "/aws/ecs/${var.project_name}"
          "awslogs-create-group"  = "true"
          "awslogs-region"        = var.region
          "awslogs-stream-prefix" = var.env
        }
      }

      healthCheck = {
        command     = ["CMD-SHELL", "wget -qO- localhost:8080/"]
        interval    = 30
        timeout     = 5
        retries     = 10
        startPeriod = 60
      }
    },
  ])
  cpu                      = 256
  memory                   = 512
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  task_role_arn            = aws_iam_role.ecs_task_role.arn
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  runtime_platform {
    operating_system_family = "LINUX"
  }
}



resource "aws_service_discovery_http_namespace" "namespace" {
  name = "${var.env}.${var.project_name}.local"
}

resource "aws_ecs_service" "service" {
  name                              = "${var.project_name}-service-${var.env}"
  cluster                           = aws_ecs_cluster.cluster.id
  task_definition                   = aws_ecs_task_definition.task_definition.arn
  desired_count                     = 1
  launch_type                       = "FARGATE"
  scheduling_strategy               = "REPLICA"
  health_check_grace_period_seconds = 60
  enable_execute_command            = true 

  network_configuration {
    subnets          = var.public_subnets
    security_groups  = [aws_security_group.service_security_group.id]
    assign_public_ip = true
  }

  deployment_circuit_breaker {
    enable   = true
    rollback = true
  }

  deployment_maximum_percent         = 200
  deployment_minimum_healthy_percent = 100


  service_connect_configuration {
    enabled   = true
    namespace = aws_service_discovery_http_namespace.namespace.arn
    service {
      discovery_name = "${var.project_name}-sc"
      port_name      = "http"

      client_alias {
        dns_name = var.project_name
        port     = "8080"
      }
    }

    log_configuration {
      log_driver = "awslogs"
      options = {
        "awslogs-group"         = "/aws/ecs/${var.project_name}"
        "awslogs-create-group"  = "true"
        "awslogs-region"        = var.region
        "awslogs-stream-prefix" = var.env
      }
    }
  }
}

