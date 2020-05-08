FROM registry.hub.docker.com/library/debian:buster

LABEL Maintainer="software-embedded-platform@ultimaker.com" \
      Comment="Ultimaker Bootloader build environment"

RUN apt-get update && \
    apt-get install -y \
    --fix-missing \
    make \
    wget \
    gcc-multilib \
    git \
    bzip2 \
    libz-dev \
    openjdk-11-jre \
    && \
    apt-get clean && \
    rm -rf /var/cache/apt/*

COPY docker_env/buildenv_check.sh buildenv_check.sh
COPY tools/buildroot-gcc342.tar.bz2 buildroot.tar.bz2

RUN tar xvfj buildroot.tar.bz2 -C /opt/
