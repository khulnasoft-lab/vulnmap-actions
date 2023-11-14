# Vulnmap Setup Action

A [GitHub Action](https://github.com/features/actions) for installing [Vulnmap](https://khulnasoft.com/VulnmapGH) to check for
vulnerabilities.

You can use the Action as follows:

```yaml
name: Vulnmap example 
on: push
jobs:
  security:
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@master
    - uses: khulnasoft-lab/vulnmap-actions/setup@master
    - uses: actions/setup-go@v1
      with:
        go-version: "1.13"
    - name: Vulnmap monitor 
      run: vulnmap test
      env:
        VULNMAP_TOKEN: ${{ secrets.VULNMAP_TOKEN }}
```

When using the Setup Action you are responsible for setting up the development environment required to run Vulnmap.
In this case this is a Go project so `actions/setup-go` was used, but this would be specific to your project. The [language and frameworks guides](https://docs.github.com/en/actions/language-and-framework-guides) are a good starting point.

The Vulnmap Setup Action has properties which are passed to the underlying image. These are
passed to the action using `with`.

| Property | Default | Description |
| --- | --- | --- |
| vulnmap-version | latest | Install a specific version of Vulnmap |

The Action also has outputs:

| Property | Default | Description |
| --- | --- | --- |
| version |   | The full version of the Vulnmap CLI installed |

For example, you can choose to install a specific version of Vulnmap. The installed version can be
grabbed from the output:

```yaml
name: Vulnmap example
on: push
jobs:
  security:
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@master
    - uses: khulnasoft-lab/vulnmap-actions/setup@master
      id: vulnmap
      with:
        vulnmap-version: v1.391.0
    - uses: actions/setup-go@v1
      with:
        go-version: "1.13"
    - name: Vulnmap version
      run: echo "${{ steps.vulnmap.outputs.version }}"
    - name: Vulnmap monitor 
      run: vulnmap monitor
      env:
        VULNMAP_TOKEN: ${{ secrets.VULNMAP_TOKEN }}
```
