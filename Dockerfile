FROM ubuntu:16.04

RUN apt-get update -yqq \
  && apt-get install -yqq git wget libxt-dev libgl1-mesa-glx libgl1-mesa-dev libglapi-mesa libosmesa-dev build-essential cmake cmake-curses-gui \
  && rm -rf /var/lib/apt/lists/*

# Configure environment
ENV LC_ALL=C.UTF-8
ENV LANG=C.UTF-8

RUN mkdir -p /work/bin
# Install Python 3 from miniconda
ADD https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh miniconda.sh
RUN bash miniconda.sh -b -p /work/miniconda && rm miniconda.sh

# keep conda in user dir, so can do conda install
ENV PATH="/work/bin:/work/miniconda/bin:$PATH"

RUN conda config --set always_yes yes --set changeps1 no --set auto_update_conda yes
RUN conda install conda-build anaconda-client \
  && conda update conda 

ENV TINI_VERSION v0.9.0
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /usr/bin/tini
RUN chmod +x /usr/bin/tini

WORKDIR /work

ENTRYPOINT ["/usr/bin/tini", "--"]
CMD ["/bin/bash"]
