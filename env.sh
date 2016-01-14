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

echo "Preparing a work environment for pylon $PYLON_MAJORVERSION..."
echo "Python version `python -c 'import sys; print(".".join(map(str, sys.version_info[:3])))'`"
echo "gcc version `gcc -dumpversion`"
echo $(cython -V)

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

pushd $SCRIPT_DIR/env > /dev/null

if [ "$PYLON_MAJORVERSION" == '2' ]; then
	source pylon2.sh
elif [ "$PYLON_MAJORVERSION" == '3' ]; then
	source pylon3.sh
elif [ "$PYLON_MAJORVERSION" == '4' ]; then
	source pylon4.sh
elif [ "$PYLON_MAJORVERSION" == '5' ]; then
	source pylon5.sh
else
	echo "Pylon's major release $PYLON_MAJORVERSION is not supported."
	return
fi

echo "Environment set for Pylon $PYLON_MAJORVERSION $SYSTEMARCH."
#echo "LD_LIBRARY_PATH = $LD_LIBRARY_PATH"


if [ ! -d $PYLON_ROOT ]; then
	echo -e "\e[31mNot found Pylon installed in $PYLON_ROOT\e[0m"
    echo "At least it is necessary to have a symbolic link in /opt"
    exit -1
fi

popd > /dev/null
