FROM dwalintukan/bionic-elixir-phoenix:1.8.2

# Install system deps
RUN apt-get -y install make gcc build-essential automake libtool inotify-tools autoconf libgmp3-dev

# Cache elixir deps
COPY mix.exs mix.lock ./
COPY apps/block_scout_web/mix.exs ./apps/block_scout_web/
COPY apps/explorer/mix.exs ./apps/explorer/
COPY apps/ethereum_jsonrpc/mix.exs ./apps/ethereum_jsonrpc/
COPY apps/indexer/mix.exs ./apps/indexer/
RUN mix do deps.get, deps.compile

# Copy files
COPY . .

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

CMD ["mix", "phx.server"]
