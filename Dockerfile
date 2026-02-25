FROM mdcng/mdc:latest AS builder

FROM node:22-trixie-slim

COPY --from=builder /etc/openssl.cnf /etc/openssl.cnf
COPY --from=builder /usr/local/bin/deeplx /usr/local/bin/deeplx
COPY --from=builder /usr/local/bin/ffprobe /usr/local/bin/ffprobe
COPY --from=builder /usr/local/bin/curl-impersonate /usr/local/bin/curl-impersonate
COPY --from=builder /usr/local/bin/entrypoint.sh /usr/local/bin/entrypoint.sh
COPY --from=builder /usr/local/bin/mdc_ng_app /usr/local/bin/mdc_ng_app
COPY --from=builder /opt/frontend /opt/frontend

RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends gosu tzdata libxml2 \
    && rm -rf /var/lib/apt/lists/* \
    && mkdir -p /app /config

ENV MDC_CONFIG_PATH=/config/config.json
ENV OPENSSL_CONF=/etc/openssl.cnf

EXPOSE 9208
VOLUME [/config]
ENTRYPOINT ["entrypoint.sh"]
