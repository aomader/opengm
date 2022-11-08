#!/bin/bash

set -e
set -x

mkdir /wheelhouse

for PYTHON_ROOT in /opt/python/cp310*
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
        'numpy>=1.23.4',
        'h5py>=3.7.0'
    ]
)
EOF

    cp -r $PYTHON_ROOT/lib/python3.10/site-packages/opengm .

    $PYTHON_ROOT/bin/python setup.py bdist_wheel

    auditwheel repair dist/*.whl

    cp wheelhouse/*.whl /wheelhouse
done
