#!/bin/bash

CONTAINER_NAME="${1:-docker-cicd-app-production}"

echo "Monitoring container: $CONTAINER_NAME"
echo "=================================="

if ! docker ps | grep -q $CONTAINER_NAME; then
  echo "ERROR: Container $CONTAINER_NAME is not running!"
  exit 1
fi

echo "Container Status:"
docker ps --filter "name=$CONTAINER_NAME" --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"

echo -e "\nHealth Status:"
docker inspect --format='{{.State.Health.Status}}' $CONTAINER_NAME 2>/dev/null || echo "No health check configured"

echo -e "\nResource Usage:"
docker stats --no-stream --format "table {{.Container}}\t{{.CPUPerc}}\t{{.MemUsage}}\t{{.NetIO}}" $CONTAINER_NAME

echo -e "\nRecent Logs (last 20 lines):"
docker logs --tail 20 $CONTAINER_NAME

echo -e "\nContainer Details:"
docker inspect $CONTAINER_NAME | grep -E "(Image|Created|StartedAt)" | head -3
