#!/usr/bin/env cython

#---- licence header
###############################################################################
## file :               IInteger.pyx
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


cdef extern from "GenApi/IInteger.h" namespace "GenApi":
    cdef cppclass IInteger:
        void SetValue(int64_t Value, bool Verify = true) except +
        #IInteger& operator=(int64_t Value)
        int64_t GetValue(bool Verify = true, bool IgnoreCache = false ) except +
        int64_t GetMin() except +
        int64_t GetMax() except +
        int64_t GetInc() except +
        gcstring GetUnit()

# cdef extern from "INode2IValue.h":
#     IInteger __cppGetIIntegerFromINodeMap( INodeMap*, gcstring ) except+

cdef class __IInteger(__IValue):
    cdef:
        IInteger* _ptr
    def __cinit__(self):
        super(__IInteger,self).__init__()
    cdef SetIInteger(self,IInteger* iinteger):
        self._ptr = iinteger
    def GetValue(self):
#         if not self._ptr == NULL:
            return self._ptr.GetValue()
    def SetValue(self,int64_t value):
#         if not self._ptr == NULL:
            self._ptr.SetValue(value)
    def GetMin(self):
#         if not self._ptr == NULL:
            return self._ptr.GetMin()
    def GetMax(self):
#         if not self._ptr == NULL:
            return self._ptr.GetMax()
    def GetInc(self):
#         if not self._ptr == NULL:
            return self._ptr.GetInc()
    def GetUnit(self):
#         if not self._ptr == NULL:
            return <string>self._ptr.GetUnit()

cdef _IInteger(INode* inode):
    cdef:
        gcstring name
        INodeMap* nodeMap
        #CIntegerPtr ptr
    name = inode.GetName()
    nodeMap = inode.GetNodeMap()
    #ptr = <CIntegerPtr>inode#nodeMap.GetNode(name)
    wrapper = __IInteger()
    #wrapper.SetIInteger(<IInteger*>inode)#ptr)
#     wrapper.SetIInteger(__cppGetIIntegerFromINodeMap(nodeMap,name))
    return wrapper
