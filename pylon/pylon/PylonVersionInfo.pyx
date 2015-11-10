#!/usr/bin/env cython

#---- licence header
###############################################################################
## file :               PylonVersionInfo.pyx
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


cdef extern from "pylon/PylonVersionInfo.h" namespace "Pylon":
    cdef cppclass VersionInfo:
        VersionInfo(bool) except +
        VersionInfo(unsigned int major,unsigned int minor,
                    unsigned int subminor) except +
        VersionInfo(unsigned int major,unsigned int minor,
                    unsigned int subminor,unsigned int build) except +
        unsigned int getMajor() except +
        unsigned int getMinor() except +
        unsigned int getSubminor() except +
        unsigned int getBuild() except +
        bool operator > (VersionInfo& rhs) except +
        bool operator == (const VersionInfo& rhs) except +
        bool operator >= (const VersionInfo& rhs) except +
        bool operator < (const VersionInfo& rhs) except +
        bool operator != (const VersionInfo& rhs) except +
        bool operator <= (const VersionInfo& rhs) except +
    cdef string_t GetPylonVersionString \
    "Pylon::VersionInfo::getVersionString"() except +
