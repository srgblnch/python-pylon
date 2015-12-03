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
        EVisibility GetVisibility()
        gcstring GetDescription()
        gcstring GetDisplayName()
        gcstring GetDeviceName()
        INodeMap* GetNodeMap()
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
        gcstring GetToolTip()
        void GetPropertyNames(gcstring_vector&)
        bool GetProperty(gcstring& Name, gcstring& ValueStr, 
                         gcstring& AttributeStr)
        EInterfaceType GetPrincipalInterfaceType()
    ctypedef node_vector NodeList_t

cdef class __INode:
    cdef:
        INode* _node
    _properties = []
    def __cinit__(self):
        super(__INode,self).__init__()
    def __cleanProperties(self):
        while len(self._properties) > 0:
            self._properties.pop()
    def __populateProperties(self):
        cdef:
            gcstring_vector properties
            gcstring_vector.iterator it
        self._node.GetPropertyNames(properties)
        it = properties.begin()
        while it != properties.end():
            self._properties.append(<string>deref(it))
            inc(it)
    cdef SetINode(self,INode* node):
        cdef INodeMap* nodeMap
        nodeMap = node.GetNodeMap()
        self._node = nodeMap.GetNode(node.GetName())
        self.__cleanProperties()
        self.__populateProperties()
    cdef INode* GetINode(self):
        return self._node
    def __str__(self):
        return <string>self.GetName()
    def __repr__(self):
        return "%s (%s)"%(self,VisibilityToStr(self.GetVisibility()))
    def __richcmp__(self,other,int op):
        if op == 0:#<
            raise KeyError("No meaning comparizon for nodes")
        elif op == 1:#<=
            raise KeyError("No meaning comparizon for nodes")
        elif op == 2:#==
            return self.__eq(other)
        elif op == 3:#!=
            return not self._eq(other)
        elif op == 4:#>
            raise KeyError("No meaning comparizon for nodes")
        elif op == 5:#>=
            raise KeyError("No meaning comparizon for nodes")
        else:
            raise IndexError("Compare operation not undertood (%d)"%(op))
    def __eq(self,other):
        if type(other) == str:
            return other == self.GetName()
        if type(other) == type(self):
            return other.GetName() == self.GetName()
        else:
            return False
    def GetName(self):
        return <string>self._node.GetName()
    def GetVisibility(self):
        return <int>self._node.GetVisibility()
    def GetVisibilityStr(self):
        return VisibilityToStr(<int>self._node.GetVisibility())
    def GetDescription(self):
        return <string>self._node.GetDescription()
    def GetDisplayName(self):
        return <string>self._node.GetDisplayName()
    def GetDeviceName(self):
        return <string>self._node.GetDeviceName()
    def GetToolTip(self):
        return <string>self._node.GetToolTip()
#     def IsReadable(self):
#         cdef EAccessMode aMode
#         return <bool>self._node.IsReadable(aMode)
#     def IsWritable(self):
#         cdef EAccessMode aMode
#         return <bool>self._node.IsWritable(aMode)
#     def IsImplemented(self):
#         cdef EAccessMode aMode
#         return <bool>self._node.IsImplemented(aMode)
#     def IsAvailable(self):
#         cdef EAccessMode aMode
#         return <bool>self._node.IsAvailable(aMode)
    def GetPropertyNames(self):
        return self._properties
    def GetProperty(self,propName):
        cdef:
            bytes pyName
            char* cName
            gcstring name
            gcstring value
            gcstring attribute
        pyName = propName.encode()
        cName = pyName
        name = gcstring(len(propName),cName[0])
        self._node.GetProperty(name,value,attribute)
        return (<string>value,<string>attribute)
    def GetType(self):
        return self._node.GetPrincipalInterfaceType()
    def GetTypeStr(self):
        return InterfaceTypeToStr(self.GetType())
    def GetIValue(self):
        type = self.GetType()
        if type == intfIInteger:
            return _IInteger(self._node)
        raise NotImplementedError("Not ready for %s nodes"
                                  %(InterfaceTypeToStr(type)))
    def GetValue(self):
        return self.GetIValue().GetValue()

cdef BuildNode(INode* node):
    wrapper = __INode()
    wrapper.SetINode(node)
    return wrapper
