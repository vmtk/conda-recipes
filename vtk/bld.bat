@echo off
setlocal EnableDelayedExpansion

mkdir build
cd build

if "%PY_VER%" == "3.4" (
    set GENERATOR=Visual Studio 10 2010
) else (
    if "%PY_VER%" == "3.5" (
        set GENERATOR=Visual Studio 14 2015
    ) else (
      if "%PY_VER%" == "3.6" (
          set GENERATOR=Visual Studio 15 2017
      ) else (
        set GENERATOR=Visual Studio 9 2008
      )
    )
)

if %ARCH% EQU 64 (
    set GENERATOR=%GENERATOR% Win64
)

cmake -LAH .. -G"%GENERATOR%" ^
-DCMAKE_INSTALL_PREFIX=%LIBRARY_PREFIX% ^
-DCMAKE_BUILD_TYPE=Release ^
-DINSTALL_BIN_DIR=%LIBRARY_BIN% ^
-DINSTALL_INC_DIR=%LIBRARY_INC% ^
-DINSTALL_LIB_DIR=%LIBRARY_LIB% ^
-DBUILD_SHARED_LIBS=1 ^
-DBUILD_EXAMPLES=0 ^
-DBUILD_TESTING=0 ^
-DBUILD_DOCUMENTATION=0 ^
-DBUILD_SHARED_LIBS=1 ^
-DPYTHON_EXECUTABLE=%PYTHON% ^
-DVTK_WRAP_PYTHON=1 ^
-DVTK_RENDERING_BACKEND=%BACKEND% ^
-DVTK_INSTALL_PYTHON_MODULE_DIR=%SP_DIR%

cmake --build . --config Release --target ALL_BUILD
cmake --build . --config Release --target INSTALL
