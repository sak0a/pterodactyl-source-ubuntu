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

# Add i386 architecture and install packages in stages
RUN dpkg --add-architecture i386 \
    && apt update \
    && apt upgrade -y

# Install basic tools first
RUN apt install -y \
        tar curl gcc g++ \
        iproute2 gdb telnet net-tools \
        netcat-openbsd tzdata

# Install 32-bit libraries
RUN apt install -y \
        lib32gcc-s1 \
        libcurl4:i386 \
        lib32z1 lib32stdc++6 \
        libsdl2-2.0-0:i386 \
        lib32tinfo6 libtinfo6:i386 \
        lib32ncurses6 libncurses6:i386 \
        libc6:i386 \
        libssl3:i386 \
        libcrypto3:i386 \
        libstdc++6:i386 \
        zlib1g:i386

# Create compatibility symlinks for older library versions
RUN ln -sf /lib32/libtinfo.so.6 /lib32/libtinfo.so.5 || true \
    && ln -sf /usr/lib/i386-linux-gnu/libtinfo.so.6 /usr/lib/i386-linux-gnu/libtinfo.so.5 || true \
    && ln -sf /lib32/libncurses.so.6 /lib32/libncurses.so.5 || true \
    && ln -sf /usr/lib/i386-linux-gnu/libncurses.so.6 /usr/lib/i386-linux-gnu/libncurses.so.5 || true

# Create user and cleanup
RUN useradd -m -d /home/container container \
    && apt clean  \
    #\
    #&& rm -rf /var/lib/apt/lists/*

USER container
ENV USER=container HOME=/home/container
WORKDIR /home/container

COPY ./entrypoint.sh /entrypoint.sh
CMD [ "/bin/bash", "/entrypoint.sh" ]
