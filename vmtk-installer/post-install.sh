#!/bin/bash

mkdir -p "$PREFIX/Menu"
cp "$RECIPE_DIR/menu-osx.json" "$PREFIX/Menu"
cp "$RECIPE_DIR/vmtk-icon.icns" "$PREFIX/Menu"

conda install -y numpy=1.13
