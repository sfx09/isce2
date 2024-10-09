FROM ubuntu:24.04

WORKDIR /app

RUN apt-get update 

RUN apt-get install -y cmake \
  curl \
  cython3 \
  g++ \
  gcc \
  gfortran \
  git \
  vim \
  libfftw3-dev \
  libfftw3-single3 \
  libgdal-dev \
  libhdf5-dev \
  libmotif-dev \
  libopencv-dev \
  make \
  python3-asf-search \
  python3-gdal \
  python3-h5py \
  python3-numpy \
  wget
  
COPY . . 

RUN task/do build

CMD ["/bin/bash"]
