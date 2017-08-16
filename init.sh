set -e

git submodule update --init
cd src/qt5
git submodule update --init qtbase qtdeclarative qtgraphicaleffects qtimageformats qtquickcontrols qtsvg qttools qtmultimedia
