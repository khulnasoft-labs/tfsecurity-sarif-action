#!/bin/bash

set -xe

# Check for a github workkspace, exit if not found
if [ -n "${GITHUB_WORKSPACE}" ]; then
  cd "${GITHUB_WORKSPACE}" || exit
fi

# default to latest
TFSECURITY_VERSION="latest"

# if INPUT_TFSECURITY_VERSION set and not latest
if [[ -n "${INPUT_TFSECURITY_VERSION}" && "$INPUT_TFSECURITY_VERSION" != "latest" ]]; then
  TFSECURITY_VERSION="tags/${INPUT_TFSECURITY_VERSION}"
fi

# # Pull https://api.github.com/repos/khulnasoft/tfsecurity/releases for the full list of releases. NOTE no trailing slash
# wget --inet4-only -O - -q "$(wget --inet4-only -q https://api.github.com/repos/khulnasoft/tfsecurity/releases/${TFSECURITY_VERSION} -O - | grep -m 1 -o -E "https://.+?tfsecurity-linux-amd64" | head -n1)" > tfsecurity-linux-amd64
# wget --inet4-only -O - -q "$(wget --inet4-only -q https://api.github.com/repos/khulnasoft/tfsecurity/releases/${TFSECURITY_VERSION} -O - | grep -m 1 -o -E "https://.+?tfsecurity_checksums.txt" | head -n1)" > tfsecurity.checksums

# # pipe out the checksum and validate
# grep tfsecurity-linux-amd64 tfsecurity.checksums > tfsecurity-linux-amd64.checksum
# sha256sum -c tfsecurity-linux-amd64.checksum
# install tfsecurity-linux-amd64 /usr/local/bin/tfsecurity

# if input vars file then add to arguments
if [ -n "${INPUT_TFVARS_FILE}" ]; then
  echo "Using tfvars file ${INPUT_TFVARS_FILE}"
  TFVARS_OPTION="--tfvars-file ${INPUT_TFVARS_FILE}"
fi

# if config file passed, add config to the arguments 
if [ -n "${INPUT_CONFIG_FILE}" ]; then
  echo "Using config file ${INPUT_CONFIG_FILE}"
  CONFIG_FILE_OPTION="--config-file ${INPUT_CONFIG_FILE}"
fi

# if any additional args included, add them on
if [ -n "${INPUT_TFSECURITY_ARGS}" ]; then
  echo "Using specified args: ${INPUT_TFSECURITY_ARGS}"
  TFSECURITY_ARGS_OPTION="${INPUT_TFSECURITY_ARGS}"
fi

# if set,  all dirs to be included,
if [ -n "${INPUT_FULL_REPO_SCAN}" ]; then
  echo "Forcing all directories to be scanned"
  TFSECURITY_ARGS_OPTION="--force-all-dirs ${TFSECURITY_ARGS_OPTION}"
fi


# prime the sarif file with empty results
echo {} > ${INPUT_SARIF_FILE}

tfsecurity --soft-fail --out=${INPUT_SARIF_FILE} --format=sarif ${TFSECURITY_ARGS_OPTION} ${CONFIG_FILE_OPTION} ${TFVARS_OPTION} "${INPUT_WORKING_DIRECTORY}" 

tfsecurity_return="${PIPESTATUS[0]}" exit_code=$?

echo "tfsecurity-return-code=${tfsecurity_return}" >> $GITHUB_OUTPUT
