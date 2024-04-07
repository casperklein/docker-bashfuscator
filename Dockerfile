FROM	debian:12-slim as build

ARG	GIT_USER="Bashfuscator"
ARG	GIT_REPO="Bashfuscator"
ARG	GIT_COMMIT="7487348da2d0112213f8540ae28bf12b652f924a"
ARG	GIT_ARCHIVE="https://github.com/$GIT_USER/$GIT_REPO/archive/$GIT_COMMIT.tar.gz"

ARG	PACKAGES="python3 python3-pip python3-argcomplete python3-setuptools python3-venv"
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

# If this is set to a non-empty string, Python won’t try to write .pyc files on the import of source modules.
ENV	PYTHONDONTWRITEBYTECODE 1
# Force the stdout and stderr streams to be unbuffered. This option has no effect on the stdin stream.
ENV	PYTHONUNBUFFERED 1

ENV	VIRTUAL_ENV=/venv
RUN	python3 -m venv "$VIRTUAL_ENV"
ENV	PATH="$VIRTUAL_ENV/bin:$PATH"

# Install Bashfuscator
# RUN	python3 setup.py install --user
RUN	pip3 install .

FROM	alpine as final

ARG	PACKAGES="python3"

RUN	apk upgrade --no-cache \
&&	apk add --no-cache $PACKAGES

COPY --from=build /venv /venv

# Build final image
FROM	scratch

# If this is set to a non-empty string, Python won’t try to write .pyc files on the import of source modules.
ENV	PYTHONDONTWRITEBYTECODE 1
# Force the stdout and stderr streams to be unbuffered. This option has no effect on the stdin stream.
ENV	PYTHONUNBUFFERED 1

ENV	VIRTUAL_ENV=/venv
ENV	PATH="$VIRTUAL_ENV/bin:$PATH"

ARG	VERSION="unknown"

LABEL	org.opencontainers.image.description="Dockerized bashfuscator"
LABEL	org.opencontainers.image.source="https://github.com/casperklein/docker-bashfuscator/"
LABEL	org.opencontainers.image.title="docker-bashfuscator"
LABEL	org.opencontainers.image.version="$VERSION"

ENTRYPOINT ["/venv/bin/bashfuscator"]

COPY	--from=final / /
