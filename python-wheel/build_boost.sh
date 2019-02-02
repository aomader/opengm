#!/bin/sh

set -e
set -x

BOOST_VERSION=1.62.0
BOOST_VERSION_ARCHIVE=${BOOST_VERSION//./_}

curl -fSsL -o boost_${BOOST_VERSION_ARCHIVE}.tar.gz https://downloads.sourceforge.net/project/boost/boost/${BOOST_VERSION}/boost_${BOOST_VERSION_ARCHIVE}.tar.gz

# Boost default search path do not include the "m" suffix.
ln -s -f /opt/python/cp36-cp36m/include/python3.6m/ /opt/python/cp36-cp36m/include/python3.6

for PYTHON_ROOT in /opt/python/cp36*
do
    rm -rf boost_$BOOST_VERSION_ARCHIVE

    # Build Boost.Python.
    tar xf boost_$BOOST_VERSION_ARCHIVE.tar.gz
    cd boost_$BOOST_VERSION_ARCHIVE
    export BOOST_ROOT=$PYTHON_ROOT/boost
    ./bootstrap.sh --prefix=$BOOST_ROOT --with-libraries=python --with-python=$PYTHON_ROOT/bin/python
    ./b2 install
    cd ..
done