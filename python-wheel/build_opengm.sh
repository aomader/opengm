#!/bin/bash

# Script to build Python wheels in the manylinux1 Docker environment.

# docker pull quay.io/pypa/manylinux1_x86_64
# mkdir docker
# docker run --rm -ti -v $PWD/docker:/docker -w /docker quay.io/pypa/manylinux1_x86_64 bash
# curl -L -O https://raw.githubusercontent.com/OpenNMT/Tokenizer/master/bindings/python/tools/build_wheel.sh
# bash build_wheel.sh v1.3.0
# twine upload wheelhouse/*.whl

set -e
set -x

curl -fSsL -o opengm-python3.zip https://github.com/b52/opengm/archive/python3.zip


mkdir -p wheelhouse

for PYTHON_ROOT in /opt/python/cp36*
do
    # Start from scratch to not deal with previously generated files.
    rm -rf opengm-python3

    # Build Boost.Python.
    unzip opengm-python3.zip
    cd opengm-python3

    export PYTHON_BIN=$PYTHON_ROOT/bin/python
    export PIP_BIN=$PYTHON_ROOT/bin/pip

    $PIP_BIN install numpy==1.16.1
    $PIP_BIN install h5py==2.9.0

    cmake \
        -DBUILD_TUTORIALS=OFF \
        -DBUILD_EXAMPLES=OFF \
        -DBUILD_TESTING=OFF \
        -DWITH_BOOST=ON \
        -DBOOST_ROOT=$PYTHON_ROOT/boost \
        -DWITH_HDF5=ON \
        -DBUILD_PYTHON_WRAPPER=ON \
        -DPYTHON_EXECUTABLE=$PYTHON_BIN \
        -DPYTHON_INCLUDE_DIR=`$PYTHON_BIN -c 'from sysconfig import get_paths; print(get_paths()["include"], end="")'` \
        -DPYTHON_NUMPY_INCLUDE_DIR=`$PYTHON_BIN -c 'import numpy; print(numpy.get_include(), end="")'` \
        -DWITH_OPENMP=ON \
        .
    make -j4
    make install
done