FROM --platform=$BUILDPLATFORM alpine as builder

ARG TARGETPLATFORM
ARG USE_MUSL=YES

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

WORKDIR /tmp
RUN git clone --depth 1 "https://github.com/SoftEtherVPN/SoftEtherVPN.git"

WORKDIR /tmp/SoftEtherVPN
RUN git submodule init && git submodule update
RUN ./configure
RUN make -C build
RUN make -C build install DESTDIR=/vpn

# building final image
FROM --platform=$BUILDPLATFORM alpine
ARG TARGETPLATFORM
ARG SOFTETHER_VERSION
ARG SOFTETHER_REPOSITORY
ARG MODE
ARG BUILD_DATE

ENV MODE ${MODE}

LABEL org.label-schema.build-date=${BUILD_DATE} \
      org.label-schema.platform=${TARGETPLATFORM} \
      org.label-schema.version=${SOFTETHER_VERSION} \
      org.label-schema.repository=${SOFTETHER_REPOSITORY} \
      org.label-schema.mode=${MODE} \
      authors="Oriol Rius"

RUN apk add \
    openssl \
    libsodium-dev \
    readline

WORKDIR /root
COPY --from=builder /vpn/* /usr/

CMD /usr/local/libexec/softether/${MODE}/${MODE} execsvc