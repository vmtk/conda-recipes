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

mkdir build
cd build

set BUILD_CONFIG=Release

:: tell cmake where Python is
set PYTHON_LIBRARY=%PREFIX%\libs\python%PY_VER:~0,1%%PY_VER:~2,1%.lib

cmake .. -G "NMake Makefiles" ^
    -Wno-dev ^
    -DCMAKE_BUILD_TYPE:STRING=%BUILD_CONFIG% ^
    -DUSE_SYSTEM_VTK:BOOL=ON ^
    -DUSE_SYSTEM_ITK:BOOL=ON ^
    -DSUPERBUILD_INSTALL_PREFIX:STRING=${PREFIX}
if errorlevel 1 exit 1

cmake --build .
if errorlevel 1 exit 1