# Use a specific version of Alpine for reproducibility
FROM alpine:3.18

# Arguments for PocketBase version and architecture
ARG PB_VERSION=0.22.13
ARG TARGETARCH

# Map TARGETARCH to the correct PocketBase architecture format
RUN case "${TARGETARCH}" in \
    "amd64") export ARCH="amd64" ;; \
    "arm64") export ARCH="arm64" ;; \
    "arm/v7") export ARCH="armv7" ;; \
    *) echo "Unsupported architecture: ${TARGETARCH}" && exit 1 ;; \
    esac \
    && apk add --no-cache unzip ca-certificates wget \
    && wget -q -O /tmp/pb.zip https://github.com/pocketbase/pocketbase/releases/download/v${PB_VERSION}/pocketbase_${PB_VERSION}_linux_${ARCH}.zip \
    && unzip /tmp/pb.zip -d /pb/ \
    && rm /tmp/pb.zip

# Expose the default PocketBase HTTP port
EXPOSE 8080

# Start PocketBase server
CMD ["/pb/pocketbase", "serve", "--http=0.0.0.0:8080"]
