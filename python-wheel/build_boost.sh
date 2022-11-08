#!/bin/sh

set -e
set -x

BOOST_VERSION=1.62.0
BOOST_VERSION_ARCHIVE=${BOOST_VERSION//./_}

curl -fSsL -o boost_${BOOST_VERSION_ARCHIVE}.tar.gz https://downloads.sourceforge.net/project/boost/boost/${BOOST_VERSION}/boost_${BOOST_VERSION_ARCHIVE}.tar.gz

for PYTHON_ROOT in /opt/python/cp310*
do
    rm -rf boost_$BOOST_VERSION_ARCHIVE


    # Build Boost.Python.
    tar xf boost_$BOOST_VERSION_ARCHIVE.tar.gz
    cd boost_$BOOST_VERSION_ARCHIVE
    sed -i 's/_Py_fopen/fopen/g' libs/python/src/exec.cpp
    sed -i '0,/#else/s//#elif PY_VERSION_HEX < 0x03070000/' libs/python/src/converter/builtin_converters.cpp
    sed -i '0,/#endif/s//#else\n void* convert_to_cstring(PyObject* obj){return PyUnicode_Check(obj) ? const_cast<void*>(reinterpret_cast<const void*>(_PyUnicode_AsString(obj))) : 0; }\n #endif/' libs/python/src/converter/builtin_converters.cpp
    export BOOST_ROOT=$PYTHON_ROOT/boost
    ./bootstrap.sh --prefix=$BOOST_ROOT --with-libraries=python --with-python=$PYTHON_ROOT/bin/python
    ./b2 install
    cd ..
done