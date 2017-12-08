:: Program:   VMTK
:: Module:    Anaconda Distribution
:: Language:  Python
:: Date:      May 29, 2017

::   Copyright (c) Richard Izzo, Luca Antiga, David Steinman. All rights reserved.
::   See LICENCE file for details.

::      This software is distributed WITHOUT ANY WARRANTY; without even
::      the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR
::      PURPOSE.  See the above copyright notices for more information.

:: Note: this script was contributed by
::       Richard Izzo (Github @rlizzo)
::       University at Buffalo; The Jacobs Institute

:: This file contains the packaging and distribution shell script data for packaging
:: VMTK via the Continuum Analytics Anaconda Python distribution.
:: See https://www.continuum.io/ for distribution info

mkdir wk
cd wk

:: tell cmake where Python is
set PYTHON_LIBRARY=%PREFIX%\libs\python%PY_VER:~0,1%%PY_VER:~2,1%.lib

cmake .. -G "Ninja" ^
	-DSUPERBUILD_INSTALL_PREFIX:STRING=%LIBRARY_PREFIX% ^
	-DCMAKE_BUILD_TYPE:STRING=Release ^
	-DCMAKE_INSTALL_PREFIX=%LIBRARY_PREFIX% ^
	-DBUILD_SHARED_LIBS:BOOL=ON ^
    -DVMTK_RENDERING_BACKEND:STRING=OpenGL2 ^
    -DUSE_SYSTEM_VTK:BOOL=ON ^
    -DUSE_SYSTEM_ITK:BOOL=ON ^
    -DPYTHON_EXECUTABLE:FILEPATH="%PYTHON%" ^
    -DPYTHON_INCLUDE_DIR:PATH="%PREFIX%\include" ^
    -DPYTHON_LIBRARY:FILEPATH="%PYTHON_LIBRARY%" ^
	-DINSTALL_BIN_DIR="%LIBRARY_BIN%" ^
	-DINSTALL_INC_DIR="%LIBRARY_INC%" ^
	-DINSTALL_LIB_DIR="%LIBRARY_LIB%" ^
	-DVMTK_SCRIPTS_INSTALL_BIN_DIR="%LIBRARY_BIN%" ^
	-DVMTK_SCRIPTS_INSTALL_LIB_DIR="%SP_DIR%/vmtk" ^
	-DPYPES_INSTALL_BIN_DIR="%LIBRARY_BIN%" ^
	-DPYPES_MODULE_INSTALL_LIB_DIR="%SP_DIR%/vmtk" ^
    -DVMTK_USE_SUPERBUILD:BOOL=OFF
if errorlevel 1 exit 1

ninja install
if errorlevel 1 exit 1