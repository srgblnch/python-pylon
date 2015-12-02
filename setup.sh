#!/bin/bash

#---- licence header
###############################################################################
## file :               setup.sh
##
## description :        This file has been made to provide a python access to
##                      the Pylon SDK from python.
##
## project :            TANGO
##
## author(s) :          S.Blanch-Torn\'e
##
## Copyright (C) :      2015
##                      CELLS / ALBA Synchrotron,
##                      08290 Bellaterra,
##                      Spain
##
## This file is part of Tango.
##
## Tango is free software: you can redistribute it and/or modify
## it under the terms of the GNU Lesser General Public License as published by
## the Free Software Foundation, either version 3 of the License, or
## (at your option) any later version.
##
## Tango is distributed in the hope that it will be useful,
## but WITHOUT ANY WARRANTY; without even the implied warranty of
## MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
## GNU Lesser General Public License for more details.
##
## You should have received a copy of the GNU Lesser General Public License
## along with Tango.  If not, see <http:##www.gnu.org/licenses/>.
##
###############################################################################

if [ "$1" == 'clean' ]; then
	echo "Proceeding with clean operation."
	rm -rf ~/.pyxbld > /dev/null 2>&1
	rm -rf build/ > /dev/null 2>&1
	rm pylon/*.pyc > /dev/null 2>&1
	rm pylon/__init__.cpp > /dev/null 2>&1
	exit
fi

source env.sh

echo $LD_LIBRARY_PATH

export CFLAGS="-I$PYLON_ROOT/include "
export CFLAGS+="-I$PYLON_ROOT/genicam/library/CPP/include "
export CFLAGS+="-I./pylon "
export CFLAGS+="-L$PYLONLIBDIR -L$PYLONLIBDIR/pylon/tl/ "
export CFLAGS+="-lpylonbase -lpylongigesupp -lpylonutility "
# -lpyloncamemu -lpylongige "

export GCCVERSION=$(gcc --version | grep ^gcc | sed 's/^.* //g')
export CFLAGS+="-I/usr/include/c++/$GCCVERSION "
export CFLAGS+="-I/usr/include/x86_64-linux-gnu/c++/4.9 "
#!!!!! hardcoded

export CC='g++'

python setup.py build
