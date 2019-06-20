#!/bin/sh
# Runs the explorer in dev mode as a local process

CHAIN=$1
DB_ACTION=$2
MESSAGE="$ ./run.sh [mainnet/testnet]"

# Check for chain var
if [ -z "${CHAIN}" ]
then
    echo "chain not specified"
    echo ${MESSAGE}
    exit 2
fi

# Assign vars for correct chain
if [ "${CHAIN}" = "mainnet" ]; then
    export PORT=5000
    export MIX_ENV=dev
    export NETWORK=Gojoychain
    export SUBNETWORK=Mainnet
    export COIN=JOY
    export ETHEREUM_JSONRPC_VARIANT=geth
    export ETHEREUM_JSONRPC_HTTP_URL=https://api.gojoychain.com
    export ETHEREUM_JSONRPC_WS_URL=wss://api.gojoychain.com/ws
    export ETHEREUM_JSONRPC_TRACE_URL=https://api.gojoychain.com
    export ECTO_USE_SSL=true
elif [ "${CHAIN}" = "testnet" ]; then
    export PORT=4000
    export MIX_ENV=dev
    export NETWORK=Gojoychain
    export SUBNETWORK=Testnet
    export COIN=JOY
    export ETHEREUM_JSONRPC_VARIANT=geth
    export ETHEREUM_JSONRPC_HTTP_URL=https://testapi.gojoychain.com
    export ETHEREUM_JSONRPC_WS_URL=wss://testapi.gojoychain.com/ws
    export ETHEREUM_JSONRPC_TRACE_URL=https://testapi.gojoychain.com
    export ECTO_USE_SSL=true
else
    echo "invalid chain"
    echo ${MESSAGE}
    exit 2
fi

# Run local server
mix phx.server
