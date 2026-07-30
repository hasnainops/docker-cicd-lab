#!/bin/bash

set -e

DOCKER_USERNAME="${1:-your-docker-username}"
IMAGE_TAG="${2:-latest}"
CONTAINER_NAME="docker-cicd-app-staging"
PORT="3001"

echo "Starting staging deployment..."
echo "Docker Username: $DOCKER_USERNAME"
echo "Image Tag: $IMAGE_TAG"

echo "Pulling Docker image..."
docker pull $DOCKER_USERNAME/docker-cicd-app:$IMAGE_TAG

echo "Stopping existing container..."
docker stop $CONTAINER_NAME 2>/dev/null || true
docker rm $CONTAINER_NAME 2>/dev/null || true

echo "Starting new container..."
docker run -d \
  --name $CONTAINER_NAME \
  --restart unless-stopped \
  -p $PORT:3000 \
  -e NODE_ENV=staging \
  -e PORT=3000 \
  --health-cmd="curl -f http://localhost:3000/health || exit 1" \
  --health-interval=30s \
  --health-timeout=10s \
  --health-retries=3 \
  $DOCKER_USERNAME/docker-cicd-app:$IMAGE_TAG

sleep 10

echo "Staging deployment completed successfully!"
echo "Application is running on port $PORT"

echo "Testing deployment..."
curl -f http://localhost:$PORT/health || echo "Health check failed"

docker ps | grep $CONTAINER_NAME
