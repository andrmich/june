FROM debian:stable-slim

LABEL maintainer="andrmich andrmichgithub@mismail.xyz"

ENV VERSION=0.18.1

WORKDIR /litecoin

# https://github.com/uphold/docker-litecoin-core/blob/master/-1.18/Dockerfile

RUN apt-get update \
    && apt-get -y install gpg=2.2.27-2+deb11u1 gnupg=2.2.27-2+deb11u1 curl=7.74.0-1.3+deb11u1 ca-certificates=20210119 --no-install-recommends \
# After update /var/lib/apt/lists can be huge as it stores a list of packages, not required anymore
    && rm -rf /var/lib/apt/lists/* \
# Remove cache *.deb packages
    && apt-get clean


# Info about release, gpg etc. https://github.com/litecoin-project/litecoin/releases/tag/v-1.18.1
# Download public gpg key
RUN gpg --no-tty --keyserver pgp.mit.edu --recv-keys FE3348877809386C

# Download the package, show errors, follow redirection and write output to a local file named like the remote file
RUN curl -SLO https://download.litecoin.org/litecoin-${VERSION}/linux/litecoin-${VERSION}-x86_64-linux-gnu.tar.gz \
    && curl -SLO https://download.litecoin.org/litecoin-${VERSION}/linux/litecoin-${VERSION}-linux-signatures.asc  \
    && gpg --verify litecoin-${VERSION}-linux-signatures.asc

# Compare checksum
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
RUN grep $(sha256sum litecoin-${VERSION}-x86_64-linux-gnu.tar.gz | awk '{ print $1 }') litecoin-${VERSION}-linux-signatures.asc

# Extract the package
# Strip NUMBER leading components from file => litecoin-0.18.1/bin/litecoin-cli to litecoin-cli/bin
RUN tar --strip=1 -xvzf litecoin-${VERSION}-x86_64-linux-gnu.tar.gz

FROM debian:stable-slim

# Create a non root user with a home directory
RUN useradd -rmU litecoin
# Using --chown requires building with DOCKER_BUILDKIT=1
COPY --from=0 --chown=litecoin:litecoin  /litecoin/bin/* /usr/local/bin/
USER litecoin
ENTRYPOINT ["litecoind"]