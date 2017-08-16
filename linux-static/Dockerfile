FROM debian:wheezy

RUN apt-get update
RUN apt-get install -y git build-essential python curl vim unzip libtool
# Qt
RUN apt-get install -y "^libxcb.*" libx11-xcb-dev libglu1-mesa-dev libxrender-dev
RUN apt-get install -y libfontconfig1-dev libglu1-mesa-dev libxrender-dev xkb-data libasound2-dev
# Tor
RUN apt-get install -y autoconf automake

ENV MAKEOPTS=-j6

ADD . /build
WORKDIR /build
RUN ./linux-static/build-deps.sh

ENTRYPOINT ./linux-static/build.sh
