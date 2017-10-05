# conda-recipes

This repository holds the packaging and distribution files 
to create anaconda python packages for the Vascular Modeling
Toolkit (VMTK). 

Please refer to https://vmtk.org for details 

The source code is available at https://github.com/vmtk/vmtk

## Docker Container

A docker container has been created containing all the dependencies needed for building the vmtk packages on a linux system. 

The container image repository is hosted on dockerhub at: https://hub.docker.com/r/rlizzo/vmtk-conda-build/. Simply `docker pull rlizzo/vmtk-conda-build` to get the latest container image. 

The conda-recipes repository is meant to be mounted as a volume inside the container at run time. To run this container interactively, issue the following command (substituting the source directory of the conda-recipes repo for the path to your own source):

```
docker run -i -v /home/rick/projects/vmtk/conda-recipes/:/work/conda-recipes -t vmtk-conda-build:latest
```

The mounted volume will appear as a folder in the home directory. Any changes make on the host files will be reflected in the container files while the container is running. Build the conda package and upload to anaconda cloud as usual. Remember that you must upload the conda packages before exiting the container, as operations performed outside a volume are ephemeral between runs. 


