#!/bin/bash

# Set the ECS cluster and task ARN as environment variables (or pass them from your CI/CD system)
ECS_CLUSTER_NAME="${ECS_CLUSTER_NAME}"
TASK_ID="${TASK_ID}"

# Timeout after waiting too long (e.g., 300 seconds or 5 minutes)
TIMEOUT=300
INTERVAL=15
START_TIME=$(date +%s)

# Polling loop
while true; do
  # Get the current status of the task's ExecuteCommandAgent
  AGENT_STATUS=$(aws ecs describe-tasks \
    --cluster "$ECS_CLUSTER_NAME" \
    --tasks "$TASK_ID" \
    --query "tasks[0].managedAgents[?name=='ExecuteCommandAgent'].lastStatus" \
    --output text)

  echo "Current ExecuteCommandAgent status: $AGENT_STATUS"

  # Check if the agent status is "RUNNING"
  if [[ "$AGENT_STATUS" == "RUNNING" ]]; then
    echo "ExecuteCommandAgent is running, you can now execute commands."
    break
  fi

  # Check if we have timed out
  CURRENT_TIME=$(date +%s)
  ELAPSED_TIME=$((CURRENT_TIME - START_TIME))

  if [[ $ELAPSED_TIME -ge $TIMEOUT ]]; then
    echo "Timed out waiting for ExecuteCommandAgent to become RUNNING."
    exit 1
  fi

  # Wait before the next poll
  sleep $INTERVAL
done
