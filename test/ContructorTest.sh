#!/bin/bash

#---- licence header
###############################################################################
## file :               ConstructorTest.sh
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

source ../env.sh

#echo $LD_LIBRARY_PATH

export CFLAGS="-I$PYLON_ROOT/include "
export CFLAGS+="-I$PYLON_ROOT/genicam/library/CPP/include "
export CFLAGS+="-I./pylon "
export CFLAGS+="-L$PYLONLIBDIR -L$PYLONLIBDIR/pylon/tl/ "
export CFLAGS+="-L$GCLIBDIR "
export CFLAGS+="-lpylonbase -lpylongigesupp -lpylonutility "

if [[ "$1" == 'pylon' && "$2" != '2' ]]; then
	export CFLAGS+="-lGCBase_gcc40_v2_3 "
else
	export CFLAGS+="-lGCBase_gcc40_v2_1 "
fi

export GCCVERSION=$(gcc --version | grep ^gcc | sed 's/^.* //g')
export CFLAGS+="-I/usr/include/c++/$GCCVERSION "
export CFLAGS+="-I/usr/include/x86_64-linux-gnu/c++/4.9 "
#!!!!! hardcoded

export CC='g++'

#-Wall

${CC} ${CFLAGS} ContructorTest.cpp -o ContructorTest
