#!/bin/sh
# Build the Kumalichat image locally and push it to Docker Hub for Coolify to pull.
# Usage: docker/build-and-push.sh [image] [platform]
#   image defaults to olushola/kumalichat; platform defaults to linux/amd64
#   (use linux/arm64 for ARM servers).
set -eu

IMAGE="${1:-olushola/kumalichat}"
PLATFORM="${2:-linux/amd64}"

cd "$(dirname "$0")/.."

# The image is built from the working tree, so refuse to ship uncommitted changes.
if [ -n "$(git status --porcelain)" ]; then
  echo "Working tree has uncommitted changes; commit or stash them first." >&2
  exit 1
fi

SHA="$(git rev-parse --short HEAD)"

docker buildx build \
  --platform "$PLATFORM" \
  --file docker/Dockerfile \
  --tag "$IMAGE:$SHA" \
  --tag "$IMAGE:latest" \
  --push \
  .

echo "Pushed $IMAGE:$SHA and $IMAGE:latest"
