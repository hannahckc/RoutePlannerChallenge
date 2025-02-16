# This role allows ECS tasks to pull container images and write logs to CloudWatch.
# Service allows AWS ECS tasks (running containers) to use this IAM role

resource "aws_iam_role" "ecs_task_execution_role" {
  name               = "${var.project_name}-task-execution-role-${var.env}"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ecs-tasks.amazonaws.com"
      },
      "Effect": "Allow",
    }
  ]
}
EOF
}