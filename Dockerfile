# Build stage
FROM elixir:1.17-alpine AS builder

RUN apk add --no-cache build-base git

WORKDIR /app

ENV MIX_ENV=prod

RUN mix local.hex --force && \
    mix local.rebar --force

COPY mix.exs mix.lock ./
RUN mix deps.get --only prod
RUN mix deps.compile

COPY config config
COPY lib lib
COPY priv priv

RUN mix compile
RUN mix release

# Runtime stage
FROM alpine:3.20 AS runner

RUN apk add --no-cache libstdc++ openssl ncurses-libs curl

WORKDIR /app

ENV MIX_ENV=prod

COPY --from=builder /app/_build/prod/rel/url_shortener ./

RUN chown -R nobody: nobody /app
USER nobody

EXPOSE 4000

CMD ["bin/url_shortener", "start"]
