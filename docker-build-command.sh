set -e

# version number argument 3.1.0.2
VERSION="3.1.0.2"

docker build -f Dockerfile --build-arg VERSION="${VERSION}" -t vjtc0n/pivx:"latest" .