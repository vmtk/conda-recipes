#!/bin/sh

## Program:   VMTK
## Module:    Anaconda Distribution
## Language:  Python
## Date:      May 29, 2017

##   Copyright (c) Richard Izzo, Luca Antiga, David Steinman. All rights reserved.
##   See LICENCE file for details.
##      This software is distributed WITHOUT ANY WARRANTY; without even
##      the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR
##      PURPOSE.  See the above copyright notices for more information.

## Note: this script was contributed by
##       Richard Izzo (Github @rlizzo)
##       University at Buffalo; The Jacobs Institute

## This file contains the packaging and distribution shell script data for packaging
## VMTK via the Continuum Analytics Anaconda Python distribution.
## See https://www.continuum.io/ for distribution info

mkdir vmtk-build
cd ./vmtk-build

BUILD_CONFIG="Release"
if [ `uname` = "Darwin" ]; then
    cmake \
    -Wno-dev \
	-DSUPERBUILD_INSTALL_PREFIX:STRING=${PREFIX} \
    -DCMAKE_BUILD_TYPE:STRING=$BUILD_CONFIG \
    -DVTK_VMTK_USE_COCOA:BOOL=ON \
    -DVMTK_RENDERING_BACKEND:STRING=OpenGL2 \
    -DUSE_SYSTEM_VTK:BOOL=ON \
    -DUSE_SYSTEM_ITK:BOOL=ON \
    -DVMTK_BREW_PYTHON:BOOL=OFF \
    -DVMTK_USE_SUPERBUILD:BOOL=ON \
    ../

    make -j${CPU_COUNT}
fi

if [ `uname` = "Linux" ]; then
    cmake ../ \
        -Wno-dev \
        -DCMAKE_BUILD_TYPE:STRING=$BUILD_CONFIG \
        -DUSE_SYSTEM_VTK:BOOL=ON \
        -DUSE_SYSTEM_ITK:BOOL=ON \
        -DSUPERBUILD_INSTALL_PREFIX:STRING=${PREFIX}

    make -j${CPU_COUNT}
fi
