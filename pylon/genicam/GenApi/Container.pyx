#!/usr/bin/env cython

#---- licence header
###############################################################################
## file :               Container.pyx
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

cdef extern from "GenApi/INode.h" namespace "GenApi":
    cdef cppclass node_vector:
        node_vector() except +
        node_vector(node_vector&) except +
        bool empty() except +
        cppclass iterator:
            node_vector operator*() except +
            iterator operator++() except +
            bint operator==(iterator) except +
            bint operator!=(iterator) except +
        iterator begin() except +
        iterator end() except +
        size_t size() except +
#     cdef node_vector& BuildNodeVector "new GenApi::node_vector"()
#     cdef node_vector& CopyNodeVector "new GenApi::node_vector"(node_vector&)