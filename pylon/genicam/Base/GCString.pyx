#!/usr/bin/env cython

#---- licence header
###############################################################################
## file :               GCString.pyx
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

cdef extern from "Base/GCString.h" namespace "GenICam":
    cdef cppclass gcstring:
        gcstring( char *pc = 0 )
        gcstring( size_t, char )
        gcstring( gcstring& )
        char *c_str() except+
        #gcstring& append( gcstring& )
        #gcstring& append( size_t count, char ch )

cdef extern from "Base/GCStringVector.h" namespace "GenICam":
    cdef cppclass gcstring_vector:
        gcstring_vector() except +
        gcstring_vector(size_t uiSize, gcstring &str) except +
        gcstring_vector(gcstring_vector &obj) except +
        cppclass iterator:
            CDeviceInfo operator*() except +
            iterator operator++() except +
            bint operator==(iterator) except +
            bint operator!=(iterator) except +
        iterator begin() except +
        iterator end() except +
        size_t size() except +
        