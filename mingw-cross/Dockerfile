FROM debian:stretch

# for wine32
RUN dpkg --add-architecture i386
RUN apt-get update
RUN apt-get install -y git build-essential python curl vim zip libtool autoconf automake
RUN apt-get install -y mingw-w64 libz-mingw-w64-dev mingw-w64-tools mingw-w64-i686-dev
RUN apt-get install -y wine wine32 innoextract

ENV MAKEOPTS=-j6

ADD . /build
WORKDIR /build
RUN ./mingw-cross/build-deps.sh

# URL for innosetup's installer
ENV INNOSETUP_URL http://files.jrsoftware.org/is/5/innosetup-5.5.9-unicode.exe
# result of shasum -a 256 on the above file
ENV INNOSETUP_SHA256 5b51ae6977bebba937ac18e0e80c1899e37dfaa12f51ccd817978ef07ae19cb3  innosetup-5.5.9-unicode.exe
WORKDIR /build/inno
RUN curl -L -O "${INNOSETUP_URL}" && echo "${INNOSETUP_SHA256}" | shasum -a 256 -c - && innoextract -e *.exe -m

WORKDIR /build
ENTRYPOINT ./mingw-cross/build.sh
