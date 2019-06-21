#!/bin/sh
# Runs the explorer locally.

CHAIN=$1
ACTION=$2
MESSAGE="$ ./run.sh [mainnet/testnet/local] [create/drop/start]"

# Check for chain var
if [ -z "${CHAIN}" ]
then
    echo "chain not specified"
    echo ${MESSAGE}
    exit 2
fi

# Import .env vars for correct chain
if [ "${CHAIN}" = "mainnet" ]; then
    export $(cat ./docker/mainnet/.env | xargs)
elif [ "${CHAIN}" = "testnet" ]; then
    export $(cat ./docker/testnet/.env | xargs)
elif [ "${CHAIN}" = "local" ]; then
    export $(cat ./docker/local/.env | xargs)
else
    echo "invalid chain"
    echo ${MESSAGE}
    exit 2
fi

if [ "$ACTION" = "create" ]; then
    # Create and migrate DB
    mix ecto.create && mix ecto.migrate
elif [ "$ACTION" = "drop" ]; then
    # Drop, create, and migrate DB
    mix do ecto.drop, ecto.create, ecto.migrate
elif [ "$ACTION" = "start" ]; then
    # Run server
    mix phx.server
else
    echo "invalid action"
    echo ${MESSAGE}
    exit 2
fi
