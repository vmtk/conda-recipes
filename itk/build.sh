#!/bin/bash

mkdir build
cd build

BUILD_CONFIG=Release

# choose different settings for OS X and Linux
if [ `uname` = "Darwin" ]; then
    SCREEN_ARGS=(
        "-DCMAKE_OSX_DEPLOYMENT_TARGET:STRING=10.11"
        "-DCMAKE_INSTALL_RPATH:PATH=${PREFIX}/lib"
    )
else
    SCREEN_ARGS=(
    )
fi

cmake .. -G "Ninja" \
    -Wno-dev \
    -DCMAKE_BUILD_TYPE:STRING=$BUILD_CONFIG \
    -DCMAKE_INSTALL_PREFIX:PATH=${PREFIX} \
    -DITK_USE_FLAT_DIRECTORY_INSTALL:BOOL=ON \
    -DBUILD_SHARED_LIBS:BOOL=ON \
    -DBUILD_EXAMPLES:BOOL=OFF \
    -DBUILD_TESTING:BOOL=OFF \
    -DITK_USE_REVIEW:BOOL=OFF \
    -DITK_USE_REVIEW_STATISTICS:BOOL=OFF \
    -DITK_USE_OPTIMIZED_REGISTRATION_METHODS:BOOL=ON \
    ${SCREEN_ARGS[@]}

ninja install
