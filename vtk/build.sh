#!/bin/bash
mkdir build
cd build || exit -1

export BACKEND=OpenGL2

# for Linux
# export CPPFLAGS="$CPPFLAGS"
# export CXXFLAGS="-stdlib=libc++ $CXXFLAGS"
# export LDFLAGS="-l GL -L${PREFIX}/lib $LDFLAGS"

# for Mac
#export CPPFLAGS="-I/opt/X11/include $CPPFLAGS"
#export CXXFLAGS="-stdlib=libc++ -I/opt/X11/include $CXXFLAGS"
#export LDFLAGS="-l gl -L/opt/X11/lib -L${PREFIX}/lib $LDFLAGS"


if [ "$(uname -s)" == "Linux" ]; then
  DYNAMIC_EXT="so"
fi

if [ "$(uname -s)" == "Darwin" ]; then
  DYNAMIC_EXT="dylib"
fi

if [[ $PY3K -eq 1 || $PY3K == "True" ]]; then
  export PY_STR="${PY_VER}m"
else
  export PY_STR="${PY_VER}"
fi

cmake -LAH .. \
-DBUILD_DOCUMENTATION=0 \
-DBUILD_EXAMPLES=0 \
-DBUILD_SHARED_LIBS=1 \
-DBUILD_TESTING=0 \
-DCMAKE_BUILD_TYPE=Release \
-DCMAKE_INSTALL_PREFIX="$PREFIX" \
-DINSTALL_BIN_DIR="$PREFIX"/bin \
-DINSTALL_INC_DIR="$PREFIX"/include \
-DINSTALL_LIB_DIR="$PREFIX"/lib \
-DINSTALL_PKGCONFIG_DIR="$PREFIX"/lib/pkgconfig \
-DPYTHON_EXECUTABLE="$PYTHON" \
-DPYTHON_LIBRARY="$PREFIX/lib/libpython$PY_STR.$DYNAMIC_EXT" \
-DVTK_INSTALL_PYTHON_MODULE_DIR="$SP_DIR" \
-DVTK_PYTHON_VERSION="$PY_VER" \
-DVTK_RENDERING_BACKEND="$BACKEND" \
-DVTK_USE_X=0 \
-DVTK_WRAP_PYTHON=1

make -j"$CPU_COUNT" && make install
