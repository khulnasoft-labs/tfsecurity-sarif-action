# tfsecurity-sarif-action

## Description

This Github Action will run the tfsecurity sarif check then add the report to the repo for upload.

Example usage

```yaml
name: tfsecurity
on:
  push:
    branches:
      - main
  pull_request:
jobs:
  tfsecurity:
    name: tfsecurity sarif report
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

      - name: tfsecurity
        uses: khulnasoft-labs/tfsecurity-sarif-action@v0.0.2
        with:
          sarif_file: tfsecurity.sarif          

      - name: Upload SARIF file
        uses: github/codeql-action/upload-sarif@v1
        with:
          # Path to SARIF file relative to the root of the repository
          sarif_file: tfsecurity.sarif         
```

## Optional inputs
There are a number of optional inputs that can be used in the `with:` block.

**working_directory** - the directory to scan in, defaults to `.`, ie current working directory

**tfsecurity_version** - the version of tfsecurity to use, defaults to `latest`

**tfsecurity_args** - the args for tfsecurity to use (space-separated)

**config_file** - The path to the config file. (eg. ./tfsecurity.yml)

**full_repo_scan** - This is the equivalent of running `--force-all-dirs` and will ensure that a Terraform in the repo will be scanned
