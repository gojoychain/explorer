FROM dwalintukan/bionic-elixir-phoenix:1.7.4

RUN apt-get -y install \
    make \
    gcc \
    build-essential \
    automake \
    libtool \
    inotify-tools \
    autoconf \
    libgmp3-dev

# Define build args
ARG PORT
ARG MIX_ENV
ARG NETWORK
ARG SUBNETWORK
ARG COIN
ARG ETHEREUM_JSONRPC_VARIANT
ARG ETHEREUM_JSONRPC_HTTP_URL
ARG ETHEREUM_JSONRPC_WS_URL
ARG DATABASE_URL
ARG SECRET_KEY_BASE
ARG ECTO_USE_SSL
ARG GECCEX_APP_ID
ARG GECCEX_CODE

# Expose ports
EXPOSE ${PORT}

# Map build args to env args
ENV PORT=$PORT \
    MIX_ENV=$MIX_ENV \
    NETWORK=$NETWORK \
    SUBNETWORK=$SUBNETWORK \
    COIN=$COIN \
    ETHEREUM_JSONRPC_VARIANT=$ETHEREUM_JSONRPC_VARIANT \
    ETHEREUM_JSONRPC_HTTP_URL=$ETHEREUM_JSONRPC_HTTP_URL \
    ETHEREUM_JSONRPC_WS_URL=$ETHEREUM_JSONRPC_WS_URL \
    DATABASE_URL=$DATABASE_URL \
    SECRET_KEY_BASE=$SECRET_KEY_BASE \
    ECTO_USE_SSL=$ECTO_USE_SSL \
    GECCEX_APP_ID=$GECCEX_APP_ID \
    GECCEX_CODE=$GECCEX_CODE

# Cache elixir deps
ADD mix.exs mix.lock ./
ADD apps/block_scout_web/mix.exs ./apps/block_scout_web/
ADD apps/explorer/mix.exs ./apps/explorer/
ADD apps/ethereum_jsonrpc/mix.exs ./apps/ethereum_jsonrpc/
ADD apps/indexer/mix.exs ./apps/indexer/

# Compile dependencies
RUN mix do deps.get, deps.compile

# Copy files
ADD . .

# Change coin name for gettexts
RUN if [ "$COIN" != "" ]; then sed -i s/"POA"/"${COIN}"/g apps/block_scout_web/priv/gettext/en/LC_MESSAGES/default.po; fi

# Run forderground build and phoenix digest
RUN mix compile

# Install blockscout npm deps
RUN cd apps/block_scout_web/assets/ && \
    npm install && \
    npm run deploy && \
    cd -
RUN cd apps/explorer/ && \
    npm install && \
    cd -

# Migrate or rebuild db if build-arg is specified
ARG DB_ACTION
RUN if [ "$DB_ACTION" = "create" ]; then \
        mix ecto.create && mix ecto.migrate; \
    fi
RUN if [ "$DB_ACTION" = "drop" ]; then \
        mix do ecto.drop --force, ecto.create, ecto.migrate; \
    fi

CMD ["mix", "phx.server"]
