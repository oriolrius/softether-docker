# syntax=docker/dockerfile:1
FROM arm64v8/alpine AS builder

RUN apk add \
  musl-dev \
  git \
  cmake \
  make \
  gcc \
  g++ \
  ncurses-dev \
  openssl-dev \
  libsodium-dev \
  readline-dev \
  zlib-dev

ARG USE_MUSL=YES
WORKDIR /tmp
RUN git clone --depth 1 https://github.com/SoftEtherVPN/SoftEtherVPN.git

WORKDIR /tmp/SoftEtherVPN
RUN git submodule init && git submodule update
RUN ./configure
RUN make -C build
RUN make -C build install DESTDIR=/vpn


###
FROM arm64v8/alpine

RUN apk add \
  openssl \
  libsodium-dev \
   readline

WORKDIR /root
COPY --from=builder /vpn/* /usr/

CMD ["/usr/local/libexec/softether/vpnclient/vpnclient", "execsvc"]
