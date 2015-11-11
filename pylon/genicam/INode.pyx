#!/usr/bin/env cython

#---- licence header
###############################################################################
## file :               INode.pyx
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
    cdef cppclass INode:
        gcstring GetName()
        #ENameSpace GetNameSpace()
        #EVisibility GetVisibility()
        gcstring GetDescription()
        gcstring GetDisplayName()
        gcstring GetDeviceName()
#         bool IsReadable( EAccessMode AccessMode )
#         bool IsReadable( const IBase* p)
#         bool IsReadable( const IBase& r)
#         bool IsWritable( EAccessMode AccessMode )
#         bool IsWritable( const IBase* p)
#         bool IsWritable( const IBase& r)
#         bool IsImplemented( EAccessMode AccessMode )
#         bool IsImplemented( const IBase* p)
#         bool IsImplemented( const IBase& r)
#         bool IsAvailable( EAccessMode AccessMode )
#         bool IsAvailable( const IBase* p)
#         bool IsAvailable( const IBase& r)
    ctypedef node_vector NodeList_t
    
cdef class __INode:
    cdef INode* _node
    def __cinit__(self):
        super(__INode,self).__init__()
    cdef SetINode(self,INode* node):
        self._node = node
    def __str__(self):
        return <string>self._node.GetName()
    def __repr__(self):
        return "%s"%(self)

cdef BuildNode(INode* node):
    wrapper = __INode()
    wrapper.SetINode(node)
    return wrapper
