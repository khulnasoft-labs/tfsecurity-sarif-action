#!/bin/bash

set -x

if [ -n "${GITHUB_WORKSPACE}" ]; then
  cd "${GITHUB_WORKSPACE}" || exit
fi

VERSION="latest"
if [ "$INPUT_TFSECURITY_VERSION" != "latest" ]; then
  VERSION="tags/${INPUT_TFSECURITY_VERSION}"
fi

# Download the required tfsecurity version
wget -O - -q "$(wget -q https://api.github.com/repos/khulnasoft/tfsecurity/releases/${VERSION} -O - | grep -o -E "https://.+?tfsecurity-linux-amd64" | head -n1)" >tfsecurity
install tfsecurity /usr/local/bin/tfsecurity

if [ -n "${INPUT_TFVARS_FILE}" ]; then
  echo "::debug::Using tfvars file ${INPUT_TFVARS_FILE}"
  TFVARS_OPTION="--tfvars-file ${INPUT_TFVARS_FILE}"
fi

echo {} >${INPUT_SARIF_FILE}

tfsecurity --format=sarif "${INPUT_WORKING_DIRECTORY}" ${TFVARS_OPTION} >${INPUT_SARIF_FILE}

tfsecurity_return="${PIPESTATUS[0]}" exit_code=$?

echo ::set-output name=tfsecurity-return-code::"${tfsecurity_return}"
