mkdir build
cd build

set BUILD_CONFIG=Release

:: tell cmake where Python is
set PYTHON_LIBRARY=%PREFIX%\libs\python%PY_VER:~0,1%%PY_VER:~2,1%.lib

cmake .. -G "NMake Makefiles" ^
    -Wno-dev ^
    -DCMAKE_BUILD_TYPE=%BUILD_CONFIG% ^
    -DCMAKE_INSTALL_PREFIX:PATH=%LIBRARY_PREFIX% ^
    -DITK_USE_FLAT_DIRECTORY_INSTALL:BOOL=ON ^
    -DBUILD_SHARED_LIBS:BOOL=ON ^
    -DBUILD_EXAMPLES:BOOL=OFF ^
    -DBUILD_TESTING:BOOL=OFF ^
    -DITK_USE_REVIEW:BOOL=ON ^
    -DITK_USE_REVIEW_STATISTICS:BOOL=ON ^
    -DITK_USE_OPTIMIZED_REGISTRATION_METHODS:BOOL=ON
if errorlevel 1 exit 1

cmake --build . --target INSTALL --config Release
if errorlevel 1 exit 1