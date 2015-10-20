#!/usr/bin/env cython

#---- licence header
###############################################################################
## file :               strings.pyx
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

from libcpp.string cimport string

cdef extern from "pylon/stdinclude.h" namespace "Pylon":
    cdef cppclass String_t

#This code has been get from:
#http://docs.cython.org/src/tutorial/strings.html
#and it to simplify compatibility with python 2 and 3

# from cpython.version cimport PY_MAJOR_VERSION
#  
# cdef unicode _ustring(s):
#     if type(s) is unicode:
#         # fast path for most common case(s)
#         return <unicode>s
#     elif PY_MAJOR_VERSION < 3 and isinstance(s, bytes):
#         # only accept byte strings in Python 2.x, not in Py3
#         return (<bytes>s).decode('ascii')
#     elif isinstance(s, unicode):
#         # an evil cast to <unicode> might work here in some(!) cases,
#         # depending on what the further processing does.  to be safe,
#         # we can always create a copy instead
#         return unicode(s)
#     else:
#         raise TypeError("Cannot convert %s to python string"%(type(s)))

# cdef str2py(String_t pylonstr):
#     cdef string s = <string>pylonstr
#     return _ustring(s)
