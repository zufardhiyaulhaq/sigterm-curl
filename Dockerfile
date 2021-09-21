#################
# Base image
#################
FROM alpine:3.12 as sigterm-curl-base

USER root

RUN addgroup -g 10001 sigterm-curl && \
    adduser --disabled-password --system --gecos "" --home "/home/sigterm-curl" --shell "/sbin/nologin" --uid 10001 sigterm-curl && \
    mkdir -p "/home/sigterm-curl" && \
    chown sigterm-curl:0 /home/sigterm-curl && \
    chmod g=u /home/sigterm-curl && \
    chmod g=u /etc/passwd
RUN apk add --update --no-cache alpine-sdk curl

ENV USER=sigterm-curl
USER 10001
WORKDIR /home/sigterm-curl

#################
# Builder image
#################
FROM golang:1.16-alpine AS sigterm-curl-builder
RUN apk add --update --no-cache alpine-sdk
WORKDIR /app
COPY . .
RUN make build

#################
# Final image
#################
FROM sigterm-curl-base

COPY --from=sigterm-curl-builder /app/bin/sigterm-curl /usr/local/bin

# Command to run the executable
ENTRYPOINT ["sigterm-curl"]
