set -e

ROOT_SRC=`pwd`/src
ROOT_LIB=`pwd`/lib
BUILD_OUTPUT=`pwd`/output
test -e ${ROOT_SRC}
test -e ${ROOT_LIB} && rm -r ${ROOT_LIB}
mkdir ${ROOT_LIB}
test -e ${BUILD_OUTPUT} && rm -r ${BUILD_OUTPUT}
mkdir ${BUILD_OUTPUT}

# Build dependencies
cd $ROOT_SRC

# Qt
cd qt5
if [ ! -e qtbase/src ]; then
    git submodule init qtbase qtdeclarative qtgraphicaleffects qtimageformats qtquickcontrols qtsvg qtx11extras
    git submodule update
fi
git submodule foreach clean -dfx .
git submodule foreach reset --hard
./configure -opensource -confirm-license -static -no-qml-debug -qt-zlib -qt-libpng -qt-libjpeg -qt-freetype -no-nis -no-openssl -qt-pcre -qt-xcb -qt-xkbcommon -nomake tests -nomake examples -no-cups -prefix "${ROOT_LIB}/qt5/"
make
make install
cd ..

# Openssl
cd openssl
git clean -dfx .
git reset --hard
./config no-shared no-zlib --prefix="${ROOT_LIB}/openssl/" -fPIC
make
make install
cd ..

# Tor
cd tor
git clean -dfx .
git reset --hard
./autogen.sh
CFLAGS=-fPIC ./configure --prefix="${ROOT_LIB}/tor" --with-openssl-dir="${ROOT_LIB}/openssl/" --with-libevent-dir=`pkg-config --variable=libdir libevent` --with-zlib-dir=`pkg-config --variable=libdir zlib` --enable-static-tor --disable-asciidoc
make
make install
cp ${ROOT_LIB}/tor/bin/tor ${BUILD_OUTPUT}/
cd ..

# Protobuf
cd protobuf
git clean -dfx .
git reset --hard
./autogen.sh
./configure --prefix="${ROOT_LIB}/protobuf/" --disable-shared --without-zlib --with-pic
make
make install
cd ..

cd ..
echo "build-deps: done"
