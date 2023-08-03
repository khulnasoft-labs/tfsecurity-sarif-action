# terrasec-sarif-action

## Description

This Github Action will run the terrasec sarif check then add the report to the repo for upload.

Example usage

```yaml
name: terrasec
on:
  push:
    branches:
      - main
  pull_request:
jobs:
  terrasec:
    name: terrasec sarif report
    runs-on: ubuntu-latest
    permissions:
      actions: read
      contents: read
      security-events: write
    steps:
      - name: Clone repo
        uses: actions/checkout@v2
        with:
          persist-credentials: false

      - name: terrasec
        uses: khulnasoft-labs/terrasec-sarif-action@v0.1.0
        with:
          sarif_file: terrasec.sarif          

      - name: Upload SARIF file
        uses: github/codeql-action/upload-sarif@v1
        with:
          # Path to SARIF file relative to the root of the repository
          sarif_file: terrasec.sarif         
```

## Optional inputs
There are a number of optional inputs that can be used in the `with:` block.

**working_directory** - the directory to scan in, defaults to `.`, ie current working directory

**terrasec_version** - the version of terrasec to use, defaults to `latest`

**terrasec_args** - the args for terrasec to use (space-separated)

**config_file** - The path to the config file. (eg. ./terrasec.yml)

**full_repo_scan** - This is the equivalent of running `--force-all-dirs` and will ensure that a Terraform in the repo will be scanned
