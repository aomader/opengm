# OpenGM Python wheel package

This docker container creates a Python 3 wheel package that should work on
most Linux systems with Python 3.6 and 3.7.

To build the whl package, issue the following commands:

```shell
docker build -t opengm .
docker run --rm -v $PWD:/io opengm sh -c 'cp /wheelhouse/*.whl /io'
```

The `*.whl` package will be copied to the current directory.

## Building on Windows 10

To build a Windows version, you have to do everything manually. Here are the essential steps.

Install Python 3.6 and the [build tools for Python 3.6](https://wiki.python.org/moin/WindowsCompilers#Microsoft_Visual_C.2B-.2B-_14.0_standalone:_Build_Tools_for_Visual_Studio_2017_.28x86.2C_x64.2C_ARM.2C_ARM64.29) ([Microsoft Build Tools for Visual Studio 2017](https://www.visualstudio.com/downloads/#build-tools-for-visual-studio-2017)). Also install [CMake 3.13.3](https://cmake.org/files/v3.13/cmake-3.13.3-win64-x64.msi) (a later version might work as well) and run all build steps in a `x64 Native Tools Command Prompt for VS 2017` shell.

### Boost

1. Get [Boost 1.62.0](https://sourceforge.net/projects/boost/files/boost/1.62.0/boost_1_62_0.zip/download) (it HAS TO BE that version)
2. Extract it and run `bootstrap.bat --with-libraries=python`
3. After that, check the `project-config.jam` file and place the following content in it:
   ```
   import option ; 

   using msvc : 14.0 : "c:\Program Files (x86)\Microsoft Visual Studio\2017\Community\VC\Tools\MSVC\14.10.25017\bin\HostX64\x64\cl.exe"; 

   option.set keep-going : false ;

   using python : 3.6 : "C:\\Program Files\\Python36\\python.exe" : "C:\\Program Files\\Python36\\include" : "C:\\Program Files\\Python36\\libs\\" ;
   ```
4. Build it: `b2 -q --build-type=complete variant=release toolset=msvc-14.0 address-model=64 stage`

### HDF 5

1. Download [hdf5 1.10.4 for CMake](https://support.hdfgroup.org/ftp/HDF5/releases/hdf5-1.10/hdf5-1.10.4/src/CMake-hdf5-1.10.4.zip)
2. Build it using the script provided in the zip file.

### OpenGM

1. Get the sources from the `python3` branch
2. Install `numpy` and `h5py` using `pip`
3. Configure it using CMake (**you have to adapt the paths**):
   ```
   cmake -G "NMake Makefiles" -DCMAKE_BUILD_TYPE=Release -DBUILD_TUTORIALS=OFF -DBUILD_EXAMPLES=OFF -DBUILD_TESTING=OFF -DWITH_BOOST=ON -DBOOST_ROOT=C:\built\boost_1_62_0 -DBOOST_LIBRARYDIR=C:\built\boost_1_62_0\stage\lib -DWITH_HDF5=ON -DHDF5_INCLUDE_DIR=C:\built\CMake-hdf5-1.10.4\HDF5-1.10.4-win64\include -DHDF5_IMPORT_LIB=C:\built\CMake-hdf5-1.10.4\HDF5-1.10.4-win64\lib\libhdf5.lib -DHDF5_HL_IMPORT_LIB=C:\built\CMake-hdf5-1.10.4\HDF5-1.10.4-win64\lib\libhdf5_hl.lib -DBUILD_PYTHON_WRAPPER=ON -DPYTHON_INCLUDE_DIR="C:\Program Files\Python36\include" -DPYTHON_EXECUTABLE="C:\Program Files\Python36\python.exe" -DPYTHON_LIBRARY="C:\Program Files\Python36\libs\python36.lib" -DPYTHON_NUMPY_INCLUDE_DIR="C:\Program Files\Python36\lib\site-packages\numpy\core\include" -DWITH_OPENMP=ON ..
   ```
4. Build it using `nmake`
5. Copy the new `site-packages\opengm` directory into a clean directory and place a `setup.py` next to it with the following contents:
   ```python
   from setuptools import setup, find_packages
   setup(
       name='opengm',
       version='2.5',
       packages=find_packages(),
       package_data={'': ['*.dll', '*.pyd']},
       install_requires=[
           'numpy>=1.16',
           'h5py>=2.9'
       ]
   )
   ```
6. Finally, create a wheel binary package by running `"C:\Program Files\Python36\python.exe" setup.py bdist_wheel --python-tag=cp36 --py-limited-api=cp36m --plat-name=win_amd64`

1. 
