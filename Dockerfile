FROM alpine:3

ENV DIGITALOCEAN_ACCESS_TOKEN=itsasecret

COPY ./bin/*.sh ./
COPY ./policies/*.yaml ./

RUN apk add --no-cache bash git && \
    bash build.sh && \
    rm build.sh && \
    apk del bash && \
    chmod 777 docker-entrypoint.sh

ENTRYPOINT ["/bin/sh", "docker-entrypoint.sh"]
