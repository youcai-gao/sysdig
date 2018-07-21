FROM fedora:28

RUN dnf -y update && dnf -y install \
    wget \
    git \
    gcc \
    gcc-c++ \
    autoconf \
    make \
    cmake \
    python-lxml \
    cpio \
    elfutils-libelf-devel \
    findutils \
    kmod \
&& dnf clean all

WORKDIR /build

