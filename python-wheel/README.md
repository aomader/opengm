# OpenGM Python wheel package

This docker container creates a Python 3 wheel package that should work on
most Linux systems with Python 3.6 and 3.7.

To build the whl package, issue the following commands:

```shell
docker build -t opengm .
docker run --rm -v $PWD:/io opengm sh -c 'cp /wheelhouse/*.whl /io'
```

The `*.whl` package will be copied to the current directory.
