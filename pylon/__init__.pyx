#!/usr/bin/env cython

#---- licence header
###############################################################################
## file :               __init__.pyx
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

#---- In this init file there are included the cython files needed. They are 
#     separated in different descendant levels to have this distinshion as 
#     well as have each level alphabetically sorted.

from libcpp cimport bool
from libcpp.string cimport string

#necessary includes from pylonAPI
include "pylon/stdinclude.pyx"

#highest level of python module includes
include "Logger.pyx"

#second level of python module includes
include "DevInfo.pyx"

#third level of python module includes
include "Camera.pyx"
include "Factory.pyx"
include "versionAPI.pyx"
include "versionWrapper.py"

