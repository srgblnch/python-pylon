#!/bin/bash

#---- licence header
###############################################################################
## file :               env.sh
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
###############################################################################

export PYLON_BASE=/opt
if [[ "$1" == 'pylon' && "$2" != '' ]]; then
	export PYLON_MAJORVERSION=$2
else
	echo "Not understood the pylon's major release."
	echo "First argument is expected to be 'pylon' followed by the "\
	     "major release number to be used."
	return
fi

export BASEDIR=`dirname $0`

if [ "$PYLON_MAJORVERSION" == '2' ]; then
	. $BASEDIR/env/pylon2.sh
elif [ "$PYLON_MAJORVERSION" == '3' ]; then
	. $BASEDIR/env/pylon3.sh
elif [ "$PYLON_MAJORVERSION" == '4' ]; then
	. $BASEDIR/env/pylon4.sh
elif [ "$PYLON_MAJORVERSION" == '5' ]; then
	. $BASEDIR/env/pylon5.sh
else
	echo "$PYLON_MAJORVERSION pylon's major release is not supported."
fi

echo "Environment for Pylon $PYLON_MAJORVERSION $SYSTEMARCH."

