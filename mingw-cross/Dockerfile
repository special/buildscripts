FROM debian:stretch

RUN apt-get update
RUN apt-get install -y git build-essential python curl vim zip libtool autoconf automake
RUN apt-get install -y mingw-w64 libz-mingw-w64-dev mingw-w64-tools mingw-w64-i686-dev

ENV MAKEOPTS=-j6

ADD . /build
WORKDIR /build
RUN ./mingw-cross/build-deps.sh

ENTRYPOINT ./mingw-cross/build.sh
