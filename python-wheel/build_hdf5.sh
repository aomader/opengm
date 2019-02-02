#!/bin/sh

set -e
set -x

HDF5_VERSION=1.10.4

curl -L -O https://support.hdfgroup.org/ftp/HDF5/releases/hdf5-1.10/hdf5-${HDF5_VERSION}/src/hdf5-${HDF5_VERSION}.tar.gz
tar zxfv hdf5-${HDF5_VERSION}.tar.gz
cd hdf5-${HDF5_VERSION}
./configure --prefix=/usr
make -j4
make install
cd ..
