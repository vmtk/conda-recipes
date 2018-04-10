This directory contains a collection of files which have been changed in the conda constructor package when making PKG builds on MacOSX.

As of conda constructor 2.0.3, there is no way to change the installer background or intro / exit text. 

Before building on MacOSX, copy these files to the lib/pythonX.X/site-packages/constructor/osx directory (where X.X is replaced with the version of python included in the base anaconda environment from which constructor is run.)