#!/usr/bin/env cython

#---- licence header
###############################################################################
## file :               Info.pyx
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


cdef extern from "pylon/Info.h" namespace "Pylon":
    cdef cppclass IProperties:
        int GetPropertyNames( StringList_t & ) except +
        bool GetPropertyAvailable( String_t& ) except +
        bool GetPropertyValue( String_t&, String_t& ) except +
        IProperties& SetPropertyValue( String_t&, String_t& ) except +
        bool IsSubset( IProperties& Subset ) except +
    cdef cppclass CInfoBase

cdef class __IProperties:
    pass
 
cdef class __CInfoBase(__IProperties):
    def __cinit__(self):
        super(__CInfoBase,self).__init__()