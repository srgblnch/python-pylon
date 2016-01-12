#!/usr/bin/env python

#---- licence header
###############################################################################
## file :               version.py
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

#https://python-packaging-user-guide.readthedocs.org/en/latest/distributing/#choosing-a-versioning-scheme

_MAJOR_VERSION=0
_MINOR_VERSION=0
_MAINTENANCE_VERSION=0
_BUILD_VERSION=0

#FIXME: this shall be standarized, there must be many wrappers that already 
#have develop an smart way for this.

def version_python_pylon():
    return (_MAJOR_VERSION,_MINOR_VERSION,
            _MAINTENANCE_VERSION,_BUILD_VERSION)

def version_python_pylon_string():
    return '%d.%d.%d-%d'%(_MAJOR_VERSION,_MINOR_VERSION,
                          _MAINTENANCE_VERSION,_BUILD_VERSION)
