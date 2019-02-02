# Builds a wheel package from OpenGM that can be used with Python 3.6 and 3.7
#
# docker build -t opengm .
# docker run --rm -v $PWD:/io opengm sh -c 'cp /wheelhouse/*.whl /io'

FROM quay.io/pypa/manylinux1_x86_64

WORKDIR /tmp

COPY build_hdf5.sh .
RUN ./build_hdf5.sh

COPY build_cmake.sh .
RUN ./build_cmake.sh

COPY build_boost.sh .
RUN ./build_boost.sh

COPY build_opengm.sh .
RUN ./build_opengm.sh

COPY build_wheel.sh .
RUN ./build_wheel.sh
