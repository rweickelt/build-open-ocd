#!/bin/bash

set -eu

#wget -nv --continue --tries=20 --waitretry=10 --retry-connrefused \
#        --no-dns-cache --timeout 300 \
#        "http://software-dl.ti.com/msp430/msp430_public_sw/mcu/msp430/simplelink-openocd/latest/exports/simplelink_openocd_1_0.zip"


#RUN unzip -q -o -d /opt/ti/ \
#        "${XDC}__linux.zip"

SRC_DIR="/project/src/openocd"
BUILD_DIR="/project/build/openocd"
INSTALL_DIR="/project/install-root"
HOST="x86_64-w64-mingw32"

mkdir -p ${SRC_DIR}
mkdir -p ${BUILD_DIR}
mkdir -p ${INSTALL_DIR}

#git clone --depth 1 git://git.ti.com/sdo-emu/openocd.git ${SRC_DIR}/openocd

cd ${BUILD_DIR}

CFLAGS="-m64 -Wno-implicit-fallthrough" \
PKG_CONFIG_PATH="${INSTALL_DIR}/lib/pkgconfig" \
PKG_CONFIG_LIBDIR="${INSTALL_DIR}/lib" \
${SRC_DIR}/openocd/configure \
    --enable-xds110 \
    --host="x86_64-w64-mingw32" \
    --prefix="${INSTALL_DIR}"

make -j $(nproc --all)
make install
