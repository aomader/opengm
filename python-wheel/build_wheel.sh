#!/bin/bash

set -e
set -x

mkdir /wheelhouse

for PYTHON_ROOT in /opt/python/cp36*
do
    rm -rf /tmp/python-pkg
    mkdir /tmp/python-pkg
    cd /tmp/python-pkg

    cat <<EOF >setup.py
from setuptools import setup, find_packages


setup(
    name='opengm',
    version='2.5',
    packages=find_packages(),
    package_data={'': ['*.so']},
    install_requires=[
        'numpy>=1.16',
        'h5py>=2.9'
    ]
)
EOF

    cp -r $PYTHON_ROOT/lib/python3.6/site-packages/opengm .

    $PYTHON_ROOT/bin/python setup.py bdist_wheel

    auditwheel repair dist/*.whl

    cp wheelhouse/*.whl /wheelhouse
done
