mkdir wk
cd wk

set BUILD_CONFIG=Release

:: tell cmake where Python is
set PYTHON_LIBRARY=%PREFIX%\libs\python%PY_VER:~0,1%%PY_VER:~2,1%.lib

cmake .. -G "Ninja" ^
    -Wno-dev ^
    -DCMAKE_BUILD_TYPE:STRING=%BUILD_CONFIG% ^
	-DCMAKE_INSTALL_PREFIX=%LIBRARY_PREFIX% ^
	-DINSTALL_BIN_DIR=%LIBRARY_BIN% ^
	-DINSTALL_INC_DIR=%LIBRARY_INC% ^
	-DINSTALL_LIB_DIR=%LIBRARY_LIB% ^
    -DITK_USE_FLAT_DIRECTORY_INSTALL:BOOL=ON ^
    -DBUILD_SHARED_LIBS:BOOL=ON ^
    -DBUILD_EXAMPLES:BOOL=OFF ^
    -DBUILD_TESTING:BOOL=OFF ^
    -DITK_USE_REVIEW:BOOL=ON ^
    -DITK_USE_REVIEW_STATISTICS:BOOL=OFF ^
    -DITK_USE_OPTIMIZED_REGISTRATION_METHODS:BOOL=ON
if errorlevel 1 exit 1

ninja install
if errorlevel 1 exit 1
