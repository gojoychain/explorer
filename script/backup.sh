#!/bin/sh

CHAIN=$1
DB_HOST="localhost"
DB_USER="postgres"
DB_NAME="explorer"
MESSAGE="$ ./backup.sh [mainnet/testnet]"

# Check for chain var
if [ -z "${CHAIN}" ]
then
    echo "chain not specified"
    echo ${MESSAGE}
    exit 2
fi

# Assign vars for correct chain
if [ "${CHAIN}" = "mainnet" ]; then
    DB_PORT=5432
    DB_BACKUP_PATH="/home/ubuntu/.naka/mainnet/explorer"
elif [ "${CHAIN}" = "testnet" ]; then
    DB_PORT=6432
    DB_BACKUP_PATH="/home/ubuntu/.naka/testnet/explorer"
else
    echo "invalid chain"
    echo ${MESSAGE}
    exit 2
fi

# Make dirs if needed
mkdir -p ${DB_BACKUP_PATH}

# Backup db
echo "Backing up ${CHAIN} explorer"
pg_dump \
-h ${DB_HOST} \
-p ${DB_PORT} \
-U ${DB_USER} \
-d ${DB_NAME} \
-f "${DB_BACKUP_PATH}/explorer-backup.sql"

echo "Finished backing up ${CHAIN} explorer"
