#!/bin/bash

set -eu

# https://sourceforge.net/projects/libusb/files/libusb-1.0/
LIBUSB1="libusb-1.0.20"
SRC_DIR="/project/src"
BUILD_DIR="/project/build/libusb"
INSTALL_DIR="/project/install-root"
HOST="x86_64-w64-mingw32"

#curl  -L http://sourceforge.net/projects/libusb/files/libusb-1.0/libusb-1.0.20/${LIBUSB1}.tar.bz2 \
#      -o libusb.tar.bz2

mkdir -p ${SRC_DIR}
mkdir -p ${BUILD_DIR}
mkdir -p ${INSTALL_DIR}

tar -xjf libusb.tar.bz2 -C ${SRC_DIR}

cd ${BUILD_DIR}

# Configure
CFLAGS="-Wno-non-literal-null-conversion -m64" \
  "${SRC_DIR}/${LIBUSB1}/configure" \
  --host="${HOST}" \
  --prefix="${INSTALL_DIR}"

# Build
make -j $(nproc --all) clean install