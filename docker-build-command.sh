set -e

# version number argument 3.1.0.2
VERSION="latest"

docker build -f Dockerfile -t vjtc0n/pivx:"${VERSION}" .