FROM bitnami/minideb:jessie

LABEL maintainer="Michalina A"

ENV VERSION=0.18.1

WORKDIR /litecoin

# Create a non root user without home directory
RUN useradd -r litecoin

RUN apt-get update  \
#    && apt-get -y install curl=7.38.0-4+deb8u16 --no-install-recommends \
    && apt-get -y install curl apt-utils --no-install-recommends \
# After update /var/lib/apt/lists can be huge as it stores a list of packages, not required anymore
    && rm -rf /var/lib/apt/lists/* \
# Remove cache *.deb packages
    && apt-get clean

# Info about release, gpg etc. https://github.com/litecoin-project/litecoin/releases/tag/v0.18.1
# Download public gpg key
RUN gpg --no-tty --keyserver pgp.mit.edu --recv-keys FE3348877809386C

# Download the package, show errors, follow redirection and write output to a local file named like the remote file

RUN curl -SLO https://download.litecoin.org/litecoin-${VERSION}/linux/litecoin-${VERSION}-x86_64-linux-gnu.tar.gz \
    && curl -SLO https://download.litecoin.org/litecoin-${VERSION}/linux/litecoin-${VERSION}-linux-signatures.asc  \
    && gpg --verify litecoin-${VERSION}-linux-signatures.asc

# Compare checksum
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
RUN "grep $(sha256sum litecoin-${VERSION}-x86_64-linux-gnu.tar.gz | awk '{ print $1 }') litecoin-${VERSION}-linux-signatures.asc"

# Extract the package
RUN tar -xvfz litecoin-${VERSION}-x86_64-linux-gnu.tar.gz

CMD ["litecoind"]
