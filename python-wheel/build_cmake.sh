#!/bin/sh

set -e
set -x

CMAKE_VERSION=3.12.0

curl -L -O https://cmake.org/files/v3.12/cmake-${CMAKE_VERSION}.tar.gz
tar zxfv cmake-${CMAKE_VERSION}.tar.gz
cd cmake-${CMAKE_VERSION}
./bootstrap
make -j4
make install
cd ..
