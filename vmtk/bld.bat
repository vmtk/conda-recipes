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

mkdir wk
cd wk

set BUILD_CONFIG="RELEASE"

cmake -LAH .. -G "Ninja" ^
	-DCMAKE_INSTALL_PREFIX=%LIBRARY_PREFIX% ^
	-DCMAKE_BUILD_TYPE=Release ^
	-DVMTK_INSTALL_BIN_DIR=%LIBRARY_BIN% ^
	-DVMTK_INSTALL_INC_DIR=%LIBRARY_INC% ^
	-DVMTK_INSTALL_LIB_DIR=%LIBRARY_LIB% ^
    -DUSE_SYSTEM_VTK:BOOL=ON ^
    -DUSE_SYSTEM_ITK:BOOL=ON ^
	-DPYTHON_EXECUTABLE=%PYTHON% ^
	-DVMTK_USE_SUPERBUILD:BOOL=ON ^
	-DSUPERBUILD_INSTALL_PREFIX=%PREFIX%
if errorlevel 1 exit 1

ninja install
if errorlevel 1 exit 1