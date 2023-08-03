FROM alpine:3.16.2

RUN apk --no-cache --update add bash wget git mercurial

SHELL ["/bin/bash", "-eo", "pipefail", "-c"]

COPY entrypoint.sh /entrypoint.sh
ADD https://github.com/khulnasoft-labs/terrasec/releases/download/v1.28.1/terrasec-linux-amd64 .
RUN install terrasec-linux-amd64 /usr/local/bin/terrasec

ENTRYPOINT ["/entrypoint.sh"]
