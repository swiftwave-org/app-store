FROM alpine:latest

ARG PB_VERSION=0.22.13

ARG TARGETARCH

RUN apk add --no-cache \
    unzip \
    ca-certificates \
    wget

# Download and unzip PocketBase based on architecture
RUN wget -q -O /tmp/pb.zip https://github.com/pocketbase/pocketbase/releases/download/v${PB_VERSION}/pocketbase_${PB_VERSION}_linux_${TARGETARCH}.zip \
    && unzip /tmp/pb.zip -d /pb/ \
    && rm /tmp/pb.zip

EXPOSE 8080

CMD ["/pb/pocketbase", "serve", "--http=0.0.0.0:8080"]