#
# Copyright (c) 2021 Matthew Penner
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
#

# Use Ubuntu 24.04 for GLIBC 2.39 support (needed for modern SourceMod extensions)
FROM --platform=$TARGETOS/$TARGETARCH ubuntu:24.04

LABEL author="saka" maintainer="github@sakoa.xyz"
LABEL org.opencontainers.image.source="https://github.com/sak0a/pterodactyl-source-ubuntu"
LABEL org.opencontainers.image.licenses=MIT
LABEL description="Ubuntu 24.04 Source Engine image"

ENV DEBIAN_FRONTEND=noninteractive

# Add i386 architecture and install minimal required packages
RUN dpkg --add-architecture i386 \
    && apt update \
    && apt install -y --no-install-recommends \
        tar curl gcc g++ \
        lib32gcc-s1 libgcc-s1:i386 \
        libcurl4-gnutls-dev:i386 libssl3:i386 \
        libcurl4:i386 lib32tinfo6 libtinfo6:i386 \
        lib32z1 lib32stdc++6 \
        libncurses5:i386 libcurl3-gnutls:i386 \
        libsdl2-2.0-0:i386 \
        iproute2 gdb libsdl1.2debian \
        libfontconfig1 telnet net-tools \
        netcat-traditional tzdata \
    && apt clean \
    && rm -rf /var/lib/apt/lists/*

# Create container user
RUN useradd -m -d /home/container container

# Switch to container user
USER container
ENV USER=container HOME=/home/container

# Set working directory
WORKDIR /home/container

# Copy entrypoint script
COPY ./entrypoint.sh /entrypoint.sh

# Default command
CMD [ "/bin/bash", "/entrypoint.sh" ]
