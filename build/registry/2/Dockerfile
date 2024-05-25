FROM --platform=$TARGETPLATFORM registry:2

RUN apk add apache2-utils
RUN mkdir -p /auth
ENV REGISTRY_AUTH="htpasswd"
ENV REGISTRY_AUTH_HTPASSWD_REALM="Registry Realm"
ENV REGISTRY_AUTH_HTPASSWD_PATH="/auth/htpasswd"
COPY ./entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh