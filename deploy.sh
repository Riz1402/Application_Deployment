#!/bin/bash
set -e

COMPOSE_FILE="docker-compose.yml"

echo "Deploying application using Docker Compose..."
docker-compose -f $COMPOSE_FILE up -d

echo "Application deployed successfully"