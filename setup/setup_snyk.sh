#!/bin/bash
set -e

# This script takes two positional arguments. The first is the version of Vulnmap to install.
# This can be a standard version (ie. v1.390.0) or it can be latest, in which case the
# latest released version will be used.
#
# The second argument is the platform, in the format used by the `runner.os` context variable
# in GitHub Actions. Note that this script does not currently support Windows based environments.
#
# As an example, the following would install the latest version of Vulnmap for GitHub Actions for
# a Linux runner:
#
#     ./vulnmap-setup.sh latest Linux
#

die () {
    echo >&2 "$@"
    exit 1
}

[ "$#" -eq 2 ] || die "Setup Vulnmap requires two argument, $# provided"

cd "$(mktemp -d)"

echo "Installing the $1 version of Vulnmap on $2"

VERSION=$1
BASE_URL="https://static.khulnasoft.com/cli"

case "$2" in
    Linux)
        PREFIX=linux
        ;;
    Windows)
        die "Windows runner not currently supported"
        ;;
    macOS)
        PREFIX=macos
        ;;
    *)
        die "Invalid running specified: $2"
esac

{
    echo "#!/bin/bash"
    echo export VULNMAP_INTEGRATION_NAME="GITHUB_ACTIONS"
    echo export VULNMAP_INTEGRATION_VERSION=\"setup \(${2}\)\"
    echo export FORCE_COLOR=2
    echo eval vulnmap-${PREFIX} \$@
} > vulnmap

chmod +x vulnmap
sudo mv vulnmap /usr/local/bin

curl --compressed --retry 2 --output vulnmap-${PREFIX} "$BASE_URL/$VERSION/vulnmap-${PREFIX}" 
curl --compressed --retry 2 --output vulnmap-${PREFIX}.sha256 "$BASE_URL/$VERSION/vulnmap-${PREFIX}.sha256"

sha256sum -c vulnmap-${PREFIX}.sha256
chmod +x vulnmap-${PREFIX}
sudo mv vulnmap-${PREFIX} /usr/local/bin
rm -rf vulnmap*
