# conda-recipes

This repository holds the packaging and distribution files 
to create anaconda python packages for the Vascular Modeling
Toolkit (VMTK). 

Please refer to https://vmtk.org for details 

The source code is available at https://github.com/vmtk/vmtk

## Conda Build Varients 

This package uses the conda build varients as documented in https://conda.io/docs/user-guide/tasks/build-packages/variants.html. Each subdirectory contains the standard meta.yaml, build.sh, & build.bat files, along with a conda_build_config.yaml file. The conda_build_config.yaml file contains the specifications for which python/vtk/itk/compilers to use for each respective subdirectory. 

When `conda build .` is called within a subdirectory, each varient of the recipe is rendered. This behavior can be observed in a dry run by calling `conda render .`. Once the package specifications are rendered, conda will compile each varient in the package as normal. 

## Anaconda Compilers

With conda build 3.0+, we have transitioned to using the anaconda compiler packages for MacOS and Windows. This ensures that package builds are standardized across every machine. 

#### MacOS Builds

The MacOSX-10.9sdk is required to build packages on MacOS. The sdk can be downloaded from the following repository: https://github.com/phracker/MacOSX-SDKs. Licensing terms prevent us from including the SDK in this repo. As is standard practice, we have chosen the default location for the SDK to reside at `/opt/MacOSX10.9.sdk`. If you wish to install this elsewhere, update the locatino in the conda_build_config.yaml files befire trying to compile. 

## Docker Container

A docker container has been created containing all the dependencies needed for building the vmtk packages on a linux system. 

The container image repository is hosted on dockerhub at: https://hub.docker.com/r/rlizzo/vmtk-conda-build/. Simply `docker pull rlizzo/vmtk-conda-build` to get the latest container image. 

The conda-recipes repository is meant to be mounted as a volume inside the container at run time. To run this container interactively, issue the following command (substituting the source directory of the conda-recipes repo for the path to your own source):

```
docker run -i -v /home/rick/projects/vmtk/conda-recipes/:/work/conda-recipes -t vmtk-conda-build:latest
```

The mounted volume will appear as a folder in the home directory. Any changes make on the host files will be reflected in the container files while the container is running. Build the conda package and upload to anaconda cloud as usual. Remember that you must upload the conda packages before exiting the container, as operations performed outside a volume are ephemeral between runs. 

## Windows Requirements 

Building on windows (for python versions 3.5+) requires Visual Studios 2015 (VS version 14 / cl.exe version 19). Aquire the following programs and install into the default path:
- VS 2015 Community or Professional https://www.visualstudio.com/vs/older-downloads/ . Be sure to install the native build tools as per [this tutorial](https://blogs.msdn.microsoft.com/vcblog/2015/07/24/setup-changes-in-visual-studio-2015-affecting-c-developers/)

## Build Instructions

_**SETUP**_

1) install anaconda/miniconda on your system ([anaconda download link](https://www.continuum.io/downloads), [miniconda download link](https://conda.io/miniconda.html))
- miniconda is typically recommended for a number of reasons (I won't get into that here since it's a long explanation). If you decide to use miniconda, just replace `anaconda3` with `miniconda3` anytime I reference the anaconda install directory. 

2) run the following commands in the root (default) anaconda environment. (note: use the root anaconda environment for the entire build process or conda build will not work properly - it will not alter the packages in root in any way,)
- `conda install conda-build anaconda-client`
- `conda update conda conda-build anaconda-client`

3) navigate to a directory where you want to store the conda-recipes repo

3) `git clone https://github.com/vmtk/conda-recipes.git`

4) `cd foo/conda-recipes/`

The packages need to be built in the following order: 1) itk, 2) vtk, 3) vmtk

**_BUILDING ITK_**

5) `cd ./itk/`

6) `conda build ./`
- at this point the files in the `foo/conda-recipes/itk/` files will be read (starting with the meta.yaml file). a bunch of work will then happen in the `anaconda3/conda-bld/itk_foo`. The meta.yaml file specifies the desired version branch and source-location of itk to clone into, and (on linux/mac) the build.sh file specifies the cmake commands to use (windows uses the analogous build.bat file in the recipe directory). 
- once the binaries are built, conda does some magic to collate and zip up all the files, and creates a tarball. on my LINUX machine the directory/filename is `~/anaconda3/conda-bld/linux-64/itk-4.10.1-0.tar.bz2`. Obviously the `../linux-64/..` part will change the the analogous macOS name. 
- at this point check out the contents of the tarball to make sure the files were installed correctly. There should be contents in each of the `/info/` `/bin/` `/lib/` `/include/` & `/share/` folders. The tarball comes to ~16Mb on a linux build, I'd imagine it should be similar in size on a mac. 
- NOTE: if the tarball is empty, or something seems to be wrong, delete the itk tarball, and from the `foo/conda-recipes/itk/` directory rebuild the package with the following parameter added `conda build --dirty ./`. This will save the intermediate build directory in the `/anaconda3/conda-bld/` folder under a label `./itk_foo/`, and can be usefull for debugging. If you use this step, BE SURE TO RUN `conda build purge` from any directory before your next build attempt so that the saved intermediates are cleaned up before the following build. 

As ITK does not depend on python in any way, we only need to build it once. The package is saved on your local machine, and will be used from there when building vtk and vmtk in the following steps. 

**_BUILDING VTK_**

7) cd into the `foo/conda-recipes/vtk/` directory

Since VTK depends on the python version for correct wrapping, VTK will be built 3 seperate times, once specifying each python version we are building VMTK for: `python 2.7, 3.5, & 3.6`. this is handled automatically by the conda build varients tool. 

8)  run `conda build .`
- this will clone the VTK source, checkout the desired version, create a temporary python environment with the requested version interpreter / default packages, build the binaries, and create a tarball in the macOS folder equivalent of `/anaconda3/conda-bld/linux-64/`.

**_BUILDING VMTK_**

The paradigm is the same as for building VTK. We will build VMTK built 3 seperate times, once specifying each python version we are building VMTK for: `python 2.7, 3.5, & 3.6`. this is handled automatically by the conda build varients tool.  NOTE: Before building VMTK with the requested python version, VTK must have been previously built with that same python version. 

9) cd into `foo/conda-recipes/vmtk/`. 

10)  run `conda build .`
- this will clone the VMTK source, checkout the master branch, create a temporary python environment with the requested version interpreter / default packages (and in the case of python 2.7, the `future` module indicated in the meta.yaml file), build the binaries, and create a tarball in the macOS folder equivalent of `/anaconda3/conda-bld/linux-64/`.

**_TESTING VMTK CONDA PACKAGE_**

11) Create a new conda encvironment with the desired python version, ie: `conda create -n foo python=2.7`

12) `source activate foo`

13) `conda install --use-local vmtk`

14) check to make sure everything works. 

**_UPLOAD TO ANACONDA CLOUD_**

Once you have tested each of the vmtk version built, it is time to upload the packages to anaconda cloud. Since we haven't released these publically yet, upload to the `dev` label, so that users have to specifically specify `conda install -c vmtk/label/dev vmtk` if they wanted to use them. (which is a bit more complicated to figure out than what your average user would want to go through). 

15) upload itk to the anaconda cloud `anaconda upload --user VMTK itk* --label dev`
- you may be asked to login, you can use the vmtk account or your personal anaconda cloud account if you linked it to the vmtk organization. 

16) upload vtk: `anaconda upload --user VMTK vtk* --label dev`

17 upload vmtk: `anaconda upload --user VMTK vmtk* --label dev`. 

18) to test that this worked, delete the local packages in your analagous `anaconda3/conda-bld/linux-64/` directory. create a new conda repo, activate it, and run `conda install -c vmtk/label/dev vmtk` and test the packages. 

**NOTE ON BUILDING WITH AN ENCRYPTED MACHINE**
If you use any sort of full disk encryption to protect your machine the default settings for the conda build process will fail with the message `[Errno 36] File name too long: /foo/bar/...`. This essentially happens because the conda build process creates a 255 character long directory name placeholder as the intermediate install location prefix (255 characters is the maximum directory name length on all modern systems). Normally, once the install directory tree generates completely, the placeholder directory name is replaced automatically to the appropriate form for the anaconda-client. However, encrypted disks scramble this directory name and append a number of additional characters to the file name during this process. When this occurs, the encrypted directory name is longer than the 255 character max, and the OS freaks out. The solution is to append the following parameter into the `conda build --foo bar ./` command: `--prefix-length 128` . 

Specifying a 128 character prefix length worked just fine on my system before I moved to building on an (un-encrypted) large multicore server I spunup on google cloud (I needed to do this for my own sanity since building ITK/VTK takes a decent chunk of time on a 4 core system, and the only way to test if the meta.yaml / build.sh files worked correctly was to do a full build and check the results after each change).
