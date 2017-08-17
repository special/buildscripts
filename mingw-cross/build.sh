#!/bin/bash

set -e

ROOT_SRC=`pwd`/src
ROOT_LIB=`pwd`/lib
BUILD_DIR=`pwd`/build
BUILD_OUTPUT=`pwd`/output

cd $ROOT_SRC

# Ricochet
test -e ricochet || git clone https://github.com/ricochet-im/ricochet.git
cd ricochet
git clean -dfx .

RICOCHET_VERSION=`git describe --tags HEAD`

test -e ${BUILD_DIR} && rm -r ${BUILD_DIR}
mkdir ${BUILD_DIR}
cd ${BUILD_DIR}

export PATH=${ROOT_LIB}/qt5/bin/:${ROOT_LIB}/protobuf-native/bin/:${PATH}
qmake CONFIG+=release OPENSSLDIR="${ROOT_LIB}/openssl/" PROTOBUFDIR="${ROOT_LIB}/protobuf/" ${ROOT_SRC}/ricochet
make ${MAKEOPTS}
cp release/ricochet.exe ${BUILD_OUTPUT}/

mkdir -p staging/ricochet
cd staging/ricochet
cp ${BUILD_OUTPUT}/ricochet.exe .
cp ${BUILD_OUTPUT}/tor.exe .
# windeployqt is (hackishly) patched to support reading PE binaries on non-windows
${ROOT_LIB}/qt5/bin/windeployqt --qmldir ${ROOT_SRC}/ricochet/src/ui/qml ricochet.exe
test -e qmltooling && rm -r qmltooling
test -e imageformats && rm -r imageformats
test -e playlistformats && rm -r playlistformats
cd ..
zip -r ${BUILD_OUTPUT}/ricochet-${RICOCHET_VERSION}.zip ricochet

mkdir installer
cd installer
cp ${BUILD_OUTPUT}/ricochet.exe .
cp ${BUILD_OUTPUT}/tor.exe .
cp ${ROOT_SRC}/ricochet/packaging/installer/* ${ROOT_SRC}/ricochet/icons/ricochet.ico ${ROOT_SRC}/ricochet/LICENSE .
mkdir translation
cp -r ${ROOT_SRC}/ricochet/translation/{inno,installer_*.isl} translation
${ROOT_LIB}/qt5/bin/windeployqt --qmldir ${ROOT_SRC}/ricochet/src/ui/qml --dir Qt ricochet.exe
test -e Qt/qmltooling && rm -r Qt/qmltooling
test -e Qt/imageformats && rm -r Qt/imageformats
test -e Qt/playlistformats && rm -r Qt/playlistformats
cd ..
zip -r ${BUILD_OUTPUT}/ricochet-${RICOCHET_VERSION}-installer-build.zip installer

echo "---------------------"
ls -la ${BUILD_OUTPUT}/
echo "build: done"
