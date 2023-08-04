FROM alpine:3.16.2

RUN apk --no-cache --update add bash wget git mercurial

SHELL ["/bin/bash", "-eo", "pipefail", "-c"]

COPY entrypoint.sh /entrypoint.sh
ADD https://github.com/khulnasoft-labs/tfsecurity/releases/download/v1.0.0/tfsecurity-linux-amd64 .
RUN install tfsecurity-linux-amd64 /usr/local/bin/tfsecurity

ENTRYPOINT ["/entrypoint.sh"]
