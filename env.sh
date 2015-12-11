#!/bin/bash

#---- licence header
###############################################################################
## file :               env.sh
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

export PYLON_BASE=/opt
if [[ "$1" == 'pylon' && "$2" != '' ]]; then
	export PYLON_MAJORVERSION=$2
else
	export PYLON_MAJORVERSION=2
fi

if [ "$PYLON_MAJORVERSION" == '2' ]; then
	export PYLON_ROOT=$PYLON_BASE/pylon
	export GENICAM_ROOT_V2_1=$PYLON_ROOT/genicam
else
	export PYLON_ROOT=$PYLON_BASE/pylon$PYLON_MAJORVERSION
	export GENICAM_ROOT_V2_3=$PYLON_ROOT/genicam
fi

export GENICAM_ROOT=$PYLON_ROOT/genicam

if [ -d /lib64 ] ; then
    echo "Environment for Pylon $PYLON_MAJORVERSION arch64"
    PYLONLIBDIR=$PYLON_ROOT/lib64
    GCLIBDIR=$GENICAM_ROOT/bin/Linux64_x64
else
    echo "Environment for Pylon $PYLON_MAJORVERSION arch32"
    PYLONLIBDIR=$PYLON_ROOT/lib
    GCLIBDIR=$GENICAM_ROOT/bin/Linux32_i86
fi
export LD_LIBRARY_PATH=$GCLIBDIR:$LD_LIBRARY_PATH
export LD_LIBRARY_PATH=$PYLONLIBDIR:$PYLONLIBDIR/pylon/tl/:$LD_LIBRARY_PATH
