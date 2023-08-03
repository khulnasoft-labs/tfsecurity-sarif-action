#!/bin/bash

set -xe

# Check for a github workkspace, exit if not found
if [ -n "${GITHUB_WORKSPACE}" ]; then
  cd "${GITHUB_WORKSPACE}" || exit
fi

# default to latest
TERRASEC_VERSION="latest"

# if INPUT_TERRASEC_VERSION set and not latest
if [[ -n "${INPUT_TERRASEC_VERSION}" && "$INPUT_TERRASEC_VERSION" != "latest" ]]; then
  TERRASEC_VERSION="tags/${INPUT_TERRASEC_VERSION}"
fi

# # Pull https://api.github.com/repos/khulnasoft-labs/terrasec/releases for the full list of releases. NOTE no trailing slash
# wget --inet4-only -O - -q "$(wget --inet4-only -q https://api.github.com/repos/khulnasoft-labs/terrasec/releases/${TERRASEC_VERSION} -O - | grep -m 1 -o -E "https://.+?terrasec-linux-amd64" | head -n1)" > terrasec-linux-amd64
# wget --inet4-only -O - -q "$(wget --inet4-only -q https://api.github.com/repos/khulnasoft-labs/terrasec/releases/${TERRASEC_VERSION} -O - | grep -m 1 -o -E "https://.+?terrasec_checksums.txt" | head -n1)" > terrasec.checksums

# # pipe out the checksum and validate
# grep terrasec-linux-amd64 terrasec.checksums > terrasec-linux-amd64.checksum
# sha256sum -c terrasec-linux-amd64.checksum
# install terrasec-linux-amd64 /usr/local/bin/terrasec

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
if [ -n "${INPUT_TERRASEC_ARGS}" ]; then
  echo "Using specified args: ${INPUT_TERRASEC_ARGS}"
  TERRASEC_ARGS_OPTION="${INPUT_TERRASEC_ARGS}"
fi

# if set,  all dirs to be included,
if [ -n "${INPUT_FULL_REPO_SCAN}" ]; then
  echo "Forcing all directories to be scanned"
  TERRASEC_ARGS_OPTION="--force-all-dirs ${TERRASEC_ARGS_OPTION}"
fi


# prime the sarif file with empty results
echo {} > ${INPUT_SARIF_FILE}

terrasec --soft-fail --out=${INPUT_SARIF_FILE} --format=sarif ${TERRASEC_ARGS_OPTION} ${CONFIG_FILE_OPTION} ${TFVARS_OPTION} "${INPUT_WORKING_DIRECTORY}" 

terrasec_return="${PIPESTATUS[0]}" exit_code=$?

echo "terrasec-return-code=${terrasec_return}" >> $GITHUB_OUTPUT
