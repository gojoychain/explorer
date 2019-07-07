#!/bin/sh

CHAIN=$1
DB_ACTION=$2
MESSAGE="$ ./start.sh [mainnet/testnet] [create/drop](optional)"

# Check for chain var
if [ -z "${CHAIN}" ]
then
    echo "chain not specified"
    echo ${MESSAGE}
    exit 2
fi

# Assign vars for correct chain
if [ "${CHAIN}" = "mainnet" ]; then
    DOCKERFILE_PATH="../docker/mainnet/Dockerfile"
    CONTAINER_NAME="blockscout_mainnet"
elif [ "${CHAIN}" = "testnet" ]; then
    DOCKERFILE_PATH="../docker/testnet/Dockerfile"
    CONTAINER_NAME="blockscout_testnet"
else
    echo "invalid chain"
    echo ${MESSAGE}
    exit 2
fi

# Build image
docker build \
-f ${DOCKERFILE_PATH} \
-t ${CONTAINER_NAME} \
--build-arg DB_ACTION=${DB_ACTION} \
../
