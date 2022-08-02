FROM docker.io/archlinux:base-devel AS builder

ARG ICECC_VERSION=1.4.0

RUN pacman -Syu --noconfirm && \
    pacman -S --needed --noconfirm \
        lzo \
        wget \
        && \
    wget https://github.com/icecc/icecream/releases/download/${ICECC_VERSION:0:3}/icecc-${ICECC_VERSION}.tar.gz && \
    tar -xf icecc-${ICECC_VERSION}.tar.gz && \
    rm -rf icecc-${ICECC_VERSION}.tar.gz && \
    cd icecc-${ICECC_VERSION} && \
    ./configure --prefix=/usr/local && \
    make && \
    make install DESTDIR=/icecc-install

FROM docker.io/archlinux:base-devel

RUN pacman -Syu --noconfirm && \
    pacman -S --needed --noconfirm \
        lzo \
        && \
    find /var/cache/pacman/ -type f -delete

COPY --from=builder /icecc-install/usr/local /usr/local
