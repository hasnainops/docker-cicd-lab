#!/bin/bash

set -e

DOCKER_USERNAME="${1:-your-docker-username}"
PREVIOUS_TAG="${2:-previous}"
CONTAINER_NAME="${3:-docker-cicd-app-production}"

echo "Rolling back to $PREVIOUS_TAG"

docker pull $DOCKER_USERNAME/docker-cicd-app:$PREVIOUS_TAG

docker stop $CONTAINER_NAME 2>/dev/null || true
docker rm $CONTAINER_NAME 2>/dev/null || true

docker run -d \
 --name $CONTAINER_NAME \
 --restart always \
 -p 80:3000 \
 -e NODE_ENV=production \
 $DOCKER_USERNAME/docker-cicd-app:$PREVIOUS_TAG

docker ps | grep $CONTAINER_NAME
