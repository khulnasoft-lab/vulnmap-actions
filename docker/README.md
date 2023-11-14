# Vulnmap Docker Action

A [GitHub Action](https://github.com/features/actions) for using [Vulnmap](https://khulnasoft.com) to check for
vulnerabilities in your Docker images.

You can use the Action as follows:

```yaml
name: Example workflow for Docker using Vulnmap 
on: push
jobs:
  security:
    runs-on: ubuntu-latest
    steps:
    - name: Run Vulnmap to check Docker image for vulnerabilities
      uses: khulnasoft-lab/vulnmap-actions/docker@master
      env:
        VULNMAP_TOKEN: ${{ secrets.VULNMAP_TOKEN }}
      with:
        image: your/image-to-test
```

The Vulnmap Docker Action has properties which are passed to the underlying image. These are
passed to the action using `with`.

| Property | Default | Description |
| --- | --- | --- |
| args |   | Override the default arguments to the Vulnmap image |
| command | test | Specifiy which command to run, for instance test or monitor |
| image |    | The name of the image to test |
| json | false | In addition to the stdout, save the results as vulnmap.json |
| sarif | true | In addition to the stdout, save the results as vulnmap.sarif |

For example, you can choose to only report on high severity vulnerabilities.

```yaml
name: Example workflow for Docker using Vulnmap 
on: push
jobs:
  security:
    runs-on: ubuntu-latest
    steps:
    - name: Run Vulnmap to check Docker images for vulnerabilities
      uses: khulnasoft-lab/vulnmap-actions/docker@master
      env:
        VULNMAP_TOKEN: ${{ secrets.VULNMAP_TOKEN }}
      with:
        image: your/image-to-test
        args: --severity-threshold=high
```

The Docker Action also supports integrating with GitHub Code Scanning and can show issues in the GitHub Security tab. As long as you reference a Dockerfile with `--file=Dockerfile` then a `vulnmap.sarif` file will be generated which can be uploaded to GitHub Code Scanning.

![GitHub Code Scanning and Vulnmap](codescanning.png)

```yaml
name: Vulnmap Container
on: push
jobs:
  vulnmap:
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v2
    - name: Build a Docker image
      run: docker build -t your/image-to-test .
    - name: Run Vulnmap to check Docker image for vulnerabilities
      # Vulnmap can be used to break the build when it detects vulnerabilities.
      # In this case we want to upload the issues to GitHub Code Scanning
      continue-on-error: true
      uses: khulnasoft-lab/vulnmap-actions/docker@master
      env:
        # In order to use the Vulnmap Action you will need to have a Vulnmap API token.
        # More details in https://github.com/khulnasoft-lab/vulnmap-actions#getting-your-vulnmap-token
        # or you can signup for free at https://khulnasoft.com/login
        VULNMAP_TOKEN: ${{ secrets.VULNMAP_TOKEN }}
      with:
        image: your/image-to-test
        args: --file=Dockerfile
    - name: Upload result to GitHub Code Scanning
      uses: github/codeql-action/upload-sarif@v2
      with:
        sarif_file: vulnmap.sarif
```
