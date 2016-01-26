#!/bin/bash

#---- licence header
###############################################################################
## file :               32bit.sh
##
## description :        This file has been made to provide a python access to
##                      the Pylon SDK from python.
##
## project :            python-pylon
##
## author(s) :          S.Blanch-Torn\'e
##
## Copyright (C) :      2015
##                      CELLS / ALBA Synchrotron,
##                      08290 Bellaterra,
##                      Spain
##
## This file is part of python-pylon.
##
## python-pylon is free software: you can redistribute it and/or modify
## it under the terms of the GNU Lesser General Public License as published by
## the Free Software Foundation, either version 3 of the License, or
## (at your option) any later version.
##
## python-pylon is distributed in the hope that it will be useful,
## but WITHOUT ANY WARRANTY; without even the implied warranty of
## MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
## GNU Lesser General Public License for more details.
##
## You should have received a copy of the GNU Lesser General Public License
## along with python-pylon.  If not, see <http://www.gnu.org/licenses/>.
##
#############################################################################

export SYSTEMARCH="arch32"

export PYLONLIBDIR=$PYLON_ROOT/lib
if [ -d $GENICAM_ROOT ]; then
	export CFLAGS+="-I$GENICAM_ROOT/library/CPP/include "
	export GCLIBDIR=$GENICAM_ROOT/bin/Linux32_i86
	export LD_LIBRARY_PATH=$GCLIBDIR:$LD_LIBRARY_PATH
	export CFLAGS+="-L$GCLIBDIR "
else
	echo "No genicam root"
fi
