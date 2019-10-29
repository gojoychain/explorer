#!/bin/sh
# build.sh
# Builds the Gojoy Explorer Docker image.

# Get version from package.json
TAG=$(cat package.json | python -c "import json,sys;obj=json.load(sys.stdin);print obj['version'];")

# Build image
echo "Building Gojoy Explorer $TAG image..."
docker build \
-f Dockerfile \
-t "gojoychain/explorer:$TAG" \
../
