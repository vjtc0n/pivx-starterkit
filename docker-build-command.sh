set -e

# version number argument 3.1.0.2
VERSION="$1"

docker build --build-arg VERSION="${VERSION}" -t vjtc0n/pivx:"${VERSION}" -t vjtc0n/pivx:latest .