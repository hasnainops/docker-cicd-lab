#!/bin/bash

CONTAINER_NAME="${1:-docker-cicd-app-production}"

echo "Monitoring container: $CONTAINER_NAME"

docker ps --filter "name=$CONTAINER_NAME"

echo ""
echo "Health:"
docker inspect --format='{{.State.Health.Status}}' $CONTAINER_NAME 2>/dev/null || echo "No health data"

echo ""
echo "Resources:"
docker stats --no-stream $CONTAINER_NAME

echo ""
echo "Logs:"
docker logs --tail 20 $CONTAINER_NAME
