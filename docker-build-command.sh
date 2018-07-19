set -e

# version number argument 3.1.1
VERSION="3.1.1"
BDBVERSION="4.8.30.NC"

docker build -f Dockerfile --build-arg VERSION="${VERSION}" --build-arg BDBVERSION="${BDBVERSION}" -t vjtc0n/pivx:latest .