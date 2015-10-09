#!/usr/bin/env python

#---- licence header
###############################################################################
## file :               version.pyx
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

#https://python-packaging-user-guide.readthedocs.org/en/latest/distributing/#choosing-a-versioning-scheme

_MAJOR_VERSION=0
_MINOR_VERSION=0
_MAINTENANCE_VERSION=0
_BUILD_VERSION=0

def pyversion():
    return (_MAJOR_VERSION,_MINOR_VERSION,
            _MAINTENANCE_VERSION,_BUILD_VERSION)

def pyversionstr():
    return '%d.%d.%d-%d'%(_MAJOR_VERSION,_MINOR_VERSION,
                          _MAINTENANCE_VERSION,_BUILD_VERSION)

cdef extern from "pylon/PylonVersionNumber.h":
    int PYLON_VERSION_MAJOR
    int PYLON_VERSION_MINOR
    int PYLON_VERSION_SUBMINOR
    int PYLON_VERSION_BUILD
    
def pylonversion():
    return (PYLON_VERSION_MAJOR,PYLON_VERSION_MINOR,
            PYLON_VERSION_SUBMINOR,PYLON_VERSION_BUILD)
    
def pylonversionstr():
    return '%d.%d.%d-%d'%(PYLON_VERSION_MAJOR,PYLON_VERSION_MINOR,
            PYLON_VERSION_SUBMINOR,PYLON_VERSION_BUILD)
