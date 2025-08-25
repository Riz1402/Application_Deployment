#!/bin/bash

# Exit immediately if any command fails
set -e

# Variables
IMAGE_NAME="App_Deployment"
IMAGE_TAG="latest"

echo "Building Docker image: ${IMAGE_NAME}:${IMAGE_TAG}"

# Build the Docker image
docker build -t ${IMAGE_NAME}:${IMAGE_TAG} .

echo "Docker image built successfully"