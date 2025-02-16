# Generates an IAM policy document to allow creation of log groups in Cloudwatch for task execution role

data "aws_iam_policy_document" "ecs_task_execution_policy_logs_document" {
  statement {
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:DescribeLogGroups",
      "logs:DescribeLogStreams",
      "logs:PutLogEvents",
      "logs:PutRetentionPolicy",
      "logs:PutResourcePolicy"
    ]
    resources = ["*"]
  }
}

# This converts the above document into an actual IAM policy.

resource "aws_iam_policy" "ecs_task_execution_role_policy_logs" {
  name   = "${var.project_name}-task-exec-role-policy-${var.env}"
  policy = data.aws_iam_policy_document.ecs_task_execution_policy_logs_document.json
}

# Create policy document for task role to allow SSM and CloudWatch interaction 

data "aws_iam_policy_document" "ecs_task_role_policy_document" {

# These permissions allow the ECS task to communicate with AWS Systems Manager (SSM)
# This is required for ECS exec

  statement {
    actions = [
      "ssmmessages:CreateControlChannel",
      "ssmmessages:OpenControlChannel",
      "ssmmessages:CreateDataChannel",
      "ssmmessages:OpenDataChannel"
    ]
    resources = ["*"]
  }

# These permissions allow the ECS task to interact with AWS CloudWatch Logs
  statement {
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:DescribeLogGroups",
      "logs:DescribeLogStreams",
      "logs:PutLogEvents"
    ]
    resources = ["*"]
  }
}

# Create actual policy for task role from policy documen above

resource "aws_iam_policy" "ecs_task_role_policy" {
  name   = "${var.project_name}-task-role-policy-${var.env}"
  policy = data.aws_iam_policy_document.ecs_task_role_policy_document.json
}

# Create policy document that allows running ECS Exec, which lets you execute shell commands inside a running container

data "aws_iam_policy_document" "ecs_exec_policy_document" {
  statement {
    actions = [
      "ecs:ExecuteCommand",
      "ssm:StartSession",
      "ssm:DescribeSessions",
      "ssm:GetConnectionStatus",
      "ssm:TerminateSession"
    ]
    resources = ["*"]
  }
}

# Create policy for above document

resource "aws_iam_policy" "ecs_exec_policy" {
  name        = "ECSExecPolicy"
  description = "Allow ECS Exec to run commands"
  policy      = data.aws_iam_policy_document.ecs_exec_policy_document.json
}