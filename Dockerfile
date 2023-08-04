FROM alpine:3.16.2

ARG VERSION=latest

RUN apk --no-cache --update add bash wget git mercurial

SHELL ["/bin/bash", "-eo", "pipefail", "-c"]

COPY entrypoint.sh /entrypoint.sh

RUN LATEST_URL=$(wget -qO- https://api.github.com/repos/khulnasoft-labs/tfsecurity/releases/latest | grep -o "https://.*tfsecurity-linux-amd64") && \
    wget -q -O /tfsecurity-linux-amd64 $LATEST_URL && \
    chmod +x /tfsecurity-linux-amd64 && \
    mv /tfsecurity-linux-amd64 /usr/local/bin/tfsecurity

ENTRYPOINT ["/entrypoint.sh"]
