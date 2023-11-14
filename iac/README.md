# Vulnmap Infrastructure as Code Action

A [GitHub Action](https://github.com/features/actions) for using [Vulnmap](https://khulnasoft.com) to check for
issues in your Infrastructure as Code files.

You can use the Action as follows:

```yaml
name: Example workflow for Vulnmap Infrastructure as Code
on: push
jobs:
  security:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - name: Run Vulnmap to check Kubernetes manifest file for issues
        uses: khulnasoft-lab/vulnmap-actions/iac@master
        env:
          VULNMAP_TOKEN: ${{ secrets.VULNMAP_TOKEN }}
```

In order to use the Vulnmap Infrastructure as Code Test Action, you will need to have a Vulnmap API token. 
More details in [Getting Your Vulnmap Token](https://github.com/khulnasoft-lab/vulnmap-actions#getting-your-vulnmap-token), or you can [sign up for free](https://khulnasoft.com/login).  


The Vulnmap Infrastructure as Code Action has properties which are passed to the underlying image. These are
passed to the action using `with`:

| Property  | Default | Description                                                        |
|-----------|----------|-------------------------------------------------------------------|
| `args`    |          | Override the default arguments to the Vulnmap image.                 |
| `command` | `"test"` | Specify which command to run, currently only `test` is supported. |
| `file`    |          | The paths in which to scan files with issues.                     |
| `json`    | `false`  | In addition to the stdout, save the results as vulnmap.json          |
| `sarif`   | `true`   | In addition to the stdout, save the results as vulnmap.sarif         |

## Examples
### Specifying paths
You can specify the paths to the configuration files and directories to target during the test.  
When no path is specified, the whole repository is scanned by default:

```yaml
name: Example workflow for Vulnmap Infrastructure as Code
on: push
jobs:
  security:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - name: Run Vulnmap to check Kubernetes manifest file for issues
        uses: khulnasoft-lab/vulnmap-actions/iac@master
        env:
          VULNMAP_TOKEN: ${{ secrets.VULNMAP_TOKEN }}
        with:
          file: your/kubernetes-manifest.yaml your/terraform/directory
```

### Specifying severity threshold
You can also choose to only report on high severity vulnerabilities:

```yaml
name: Example workflow for Vulnmap Infrastructure as Code
on: push
jobs:
  security:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - name: Run Vulnmap to check Kubernetes manifest file for issues
        uses: khulnasoft-lab/vulnmap-actions/iac@master
        env:
          VULNMAP_TOKEN: ${{ secrets.VULNMAP_TOKEN }}
        with:
          file: your/kubernetes-manifest.yaml
          args: --severity-threshold=high
```
### Sharing test results
You can [share your test results](https://docs.khulnasoft.com/products/vulnmap-infrastructure-as-code/share-cli-results-with-the-vulnmap-web-ui) to the Vulnmap platform:

```yaml
name: Example workflow for Vulnmap Infrastructure as Code
on: push
jobs:
  security:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - name: Run Vulnmap to check Kubernetes manifest file for issues
        uses: khulnasoft-lab/vulnmap-actions/iac@master
        env:
          VULNMAP_TOKEN: ${{ secrets.VULNMAP_TOKEN }}
        with:
          args: --report
```
### Specifying scan mode for Terraform Plan
You can also choose the [scan mode](https://docs.khulnasoft.com/products/vulnmap-infrastructure-as-code/vulnmap-cli-for-infrastructure-as-code/test-your-terraform-files-with-the-cli-tool#terraform-plan), when scanning Terraform Plan files:

```yaml
name: Example workflow for Vulnmap Infrastructure as Code
on: push
jobs:
  security:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - name: Run Vulnmap to check Kubernetes manifest file for issues
        uses: khulnasoft-lab/vulnmap-actions/iac@master
        env:
          VULNMAP_TOKEN: ${{ secrets.VULNMAP_TOKEN }}
        with:
          args: --scan=resource-changes
```

### Integrating with GitHub Code Scanning

The Infrastructure as Code Action also supports integrating with GitHub Code Scanning and can show issues in the GitHub Security tab. When run, a `vulnmap.sarif` file will be generated which can be uploaded to GitHub Code Scanning:

```yaml
name: Vulnmap Infrastructure as Code
on: push
jobs:
  vulnmap:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - name: Run Vulnmap to check configuration files for security issues
        # Vulnmap can be used to break the build when it detects security issues.
        # In this case we want to upload the issues to GitHub Code Scanning
        continue-on-error: true
        uses: khulnasoft-lab/vulnmap-actions/iac@master
        env:
          VULNMAP_TOKEN: ${{ secrets.VULNMAP_TOKEN }}
      - name: Upload result to GitHub Code Scanning
        uses: github/codeql-action/upload-sarif@v2
        with:
          sarif_file: vulnmap.sarif
```

## Related Documentation
For more information on how to use the `vulnmap iac test` command, see the following: 
- [Vulnmap CLI for Infastructure as Code](https://docs.khulnasoft.com/products/vulnmap-infrastructure-as-code/vulnmap-cli-for-infrastructure-as-code)
- [Vulnmap Infrastructure as Code Test Command](https://docs.khulnasoft.com/vulnmap-cli/commands/iac-test)
