# Attatches policy to create log groups to task execution role

resource "aws_iam_role_policy_attachment" "ecs_task_execution_role_logs_pol_att" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = aws_iam_policy.ecs_task_execution_role_policy_logs.arn
}

# Attach exec policy to run commands from within container to task execution role

resource "aws_iam_role_policy_attachment" "ecs_exec_attachment" {
  policy_arn = aws_iam_policy.ecs_exec_policy.arn
  role       = aws_iam_role.ecs_task_execution_role.name
}

# Attatch policy for pulling containers to task execution role

resource "aws_iam_role_policy_attachment" "ecs_task_execution_role_pol_att" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

# Attaches policy to interact with SSM (needed for exec policy), 
# and interact with cloudwatch logs to task role

resource "aws_iam_role_policy_attachment" "ecs_task_role_pol_att" {
  role       = aws_iam_role.ecs_task_role.name
  policy_arn = aws_iam_policy.ecs_task_role_policy.arn
}



