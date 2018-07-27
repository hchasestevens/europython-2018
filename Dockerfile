FROM ubuntu:latest

# latest python:
RUN apt-get update \
  && apt-get install -y python3-pip python3-dev \
  && cd /usr/local/bin \
  && ln -s /usr/bin/python3 python \
  && pip3 install --upgrade pip

# unix utilities:
RUN apt-get update \
  && apt-get install -y --no-install-recommends \
    build-essential \
    curl \
    git \
  && rm -rf /var/lib/apt/lists/*

# anaconda:
RUN curl -qsSLkO \
    https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-`uname -p`.sh \
  && bash Miniconda3-latest-Linux-`uname -p`.sh -b \
  && rm Miniconda3-latest-Linux-`uname -p`.sh

ENV PATH=/root/miniconda3/bin:$PATH

RUN conda install -y python=3.6.6

# tensorflow:
RUN conda install -y \
    h5py \
    pandas \
    theano \
  && conda clean --yes --tarballs --packages --source-cache \
  && pip install --upgrade -I setuptools \
  && pip install --upgrade keras

# dataviz:
RUN conda install -y jupyter matplotlib seaborn

# ipyparallel:
RUN conda install -y ipyparallel && \
    ipcluster nbextension enable && \
    jupyter nbextension install --sys-prefix --py ipyparallel && \
    jupyter nbextension enable --sys-prefix --py ipyparallel && \
    jupyter serverextension enable --sys-prefix --py ipyparallel && \
    ipcluster start -n 4 --daemonize

# graphviz:
RUN conda install -y graphviz && \
    pip install graphviz

# RISE:
RUN conda install -y -c damianavila82 rise && \
    conda install -y -c conda-forge jupyter_nbextensions_configurator

# europython
RUN pip install astpath[xpath] bellybutton xpyth asttools cosmic_ray patterns yield-from redbaron astor codegen showast astsearch pytest protobuf

VOLUME /notebook
WORKDIR /notebook
EXPOSE 8888
CMD jupyter notebook --allow-root --no-browser --ip=0.0.0.0
