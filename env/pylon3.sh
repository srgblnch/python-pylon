#!/bin/bash

#---- licence header
###############################################################################
## file :               pylon3.sh
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

export PYLON_ROOT=$PYLON_BASE/pylon$PYLON_MAJORVERSION
export GENICAM_ROOT_V2_3=$PYLON_ROOT/genicam
export GENICAM_ROOT=$PYLON_ROOT/genicam

source arch.sh

echo $LD_LIBRARY_PATH
export LD_LIBRARY_PATH=$PYLONLIBDIR:$PYLONLIBDIR/pylon/tl/:$LD_LIBRARY_PATH

export CFLAGS+="-L$PYLONLIBDIR/pylon/tl/ "
export CFLAGS+="-lpylonbase -lpylongigesupp -lpylonutility "
