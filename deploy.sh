#!/bin/bash
set -e

IMAGE_TAG=$1   # get value from Jenkins argument
export IMAGE_TAG

echo "Deploying container with image: $IMAGE_TAG"

docker-compose up -d