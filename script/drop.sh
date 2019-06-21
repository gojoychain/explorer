#!/bin/sh
# Runs the commands to drop and recreate the DB

CHAIN=$1
DB_ACTION=$2
MESSAGE="$ ./run.sh [mainnet/testnet/local]"

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

# Drop and recreate DB
mix do ecto.drop, ecto.create, ecto.migrate
