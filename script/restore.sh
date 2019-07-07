#!/bin/sh

CHAIN=$1
DB_HOST="localhost"
DB_USER="postgres"
DB_NAME="explorer"
MESSAGE="$ ./restore.sh [mainnet/testnet]"

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

# # Drop all tables
psql \
-h ${DB_HOST} \
-p ${DB_PORT} \
-U ${DB_USER} \
-d ${DB_NAME} \
-c 'DROP SCHEMA public CASCADE;'

# # Create schema
psql \
-h ${DB_HOST} \
-p ${DB_PORT} \
-U ${DB_USER} \
-d ${DB_NAME} \
-c 'CREATE SCHEMA public;'

# Restore db
echo "Restoring ${CHAIN} explorer"
psql \
-1 \
--set ON_ERROR_STOP=on \
-h ${DB_HOST} \
-p ${DB_PORT} \
-U ${DB_USER} \
-d ${DB_NAME} \
-f "${DB_BACKUP_PATH}/explorer-backup.sql"

echo "Finished restoring ${CHAIN} explorer"
