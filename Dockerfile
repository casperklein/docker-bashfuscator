FROM	debian:11-slim as build

ARG	GIT_USER="Bashfuscator"
ARG	GIT_REPO="Bashfuscator"
ARG	GIT_COMMIT="7487348da2d0112213f8540ae28bf12b652f924a"
ARG	GIT_ARCHIVE="https://github.com/$GIT_USER/$GIT_REPO/archive/$GIT_COMMIT.tar.gz"

ARG	PACKAGES="python3 python3-pip python3-argcomplete python3-setuptools"
ARG	PACKAGES_CLEAN="python3-pip"

SHELL	["/bin/bash", "-o", "pipefail", "-c"]

# Install packages
ARG	DEBIAN_FRONTEND=noninteractive
RUN	apt-get update \
&&	apt-get -y upgrade \
&&	apt-get -y --no-install-recommends install $PACKAGES \
&&	rm -rf /var/lib/apt/lists/*

# Download source
WORKDIR	/$GIT_REPO
ADD	$GIT_ARCHIVE /
RUN	tar --strip-component 1 -xzvf /$GIT_COMMIT.tar.gz && rm /$GIT_COMMIT.tar.gz

# Install Bashfuscator
RUN	python3 setup.py install --user

# Cleanup
RUN	apt-get -y purge $PACKAGES_CLEAN \
&&	apt-get -y autoremove \
&&	rm -rf /$GIT_REPO \
&&	find /usr/ -name '*.pyc' -delete

# Build final image
FROM	scratch

ARG	VERSION="unknown"

LABEL	org.opencontainers.image.description="Dockerized bashfuscator"
LABEL	org.opencontainers.image.source="https://github.com/casperklein/docker-bashfuscator/"
LABEL	org.opencontainers.image.title="docker-bashfuscator"
LABEL	org.opencontainers.image.version="$VERSION"

ENTRYPOINT ["/root/.local/bin/bashfuscator"]

COPY	--from=build / /
