# This role is used inside ECS tasks (the application itself) to interact with AWS services
resource "aws_iam_role" "ecs_task_role" {
  name               = "${var.project_name}-task-role-${var.env}"
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
      "Sid": ""
    }
  ]
}
EOF 
}