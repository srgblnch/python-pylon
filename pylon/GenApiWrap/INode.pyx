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
        string GetName() except+
        bool IsDeprecated() except+
        EAccessMode GetAccessMode() except+
        void ImposeAccessMode(EAccessMode ImposedAccessMode) except+
        bool IsCachable() except+
        bool IsFeature() except+
        EVisibility GetVisibility() except+
        string GetDescription() except+
        string GetToolTip() except+
        string GetDisplayName() except+
        EInterfaceType GetPrincipalInterfaceType() except+
    bool IsImplemented "IsImplemented" (EAccessMode AccessMode) except+
    bool IsAvailable "IsAvailable" (EAccessMode AccessMode) except+
    bool IsReadable "IsReadable" (EAccessMode AccessMode) except+
    bool IsWritable "IsWritable" (EAccessMode AccessMode) except+


cdef class Node(Logger):
    cdef:
        INode* _node
        InterfaceType _type
        Enumeration _enumeration

    def __init__(self,*args,**kwargs):
        super(Node,self).__init__(*args,**kwargs)
        self.name = "Node"
        self._type = InterfaceType()
        self._enumeration = Enumeration()

    cdef setINode(self,INode* node):
        self._node = node
        self.name = "Node(%s)" % self._node.GetName()
        self._type.setParent(self._node)
        if self.type == 'IEnumeration':
            self._enumeration.setNode(self._node)

    def __str__(self):
        return "%s"%self.name
    def __repr__(self):
        return "Node(%s)"%(self.displayname)

    property isImplemented:
        def __get__(self):
            return IsImplemented(self._node.GetAccessMode())

    property isAvailable:
        def __get__(self):
            return IsAvailable(self._node.GetAccessMode())

    property isReadable:
        def __get__(self):
            return IsReadable(self._node.GetAccessMode())

    property isWritable:
        def __get__(self):
            return IsWritable(self._node.GetAccessMode())

    property cacheable:
        def __get__(self):
            if self._node != NULL:
                return <bool>self._node.IsCachable()
            return None

    property feature:
        def __get__(self):
            if self._node != NULL:
                return <bool>self._node.IsFeature()
            return None

    property description:
        def __get__(self):
            if self._node != NULL:
                return <string>self._node.GetDescription()
            return None

    property tooptip:
        def __get__(self):
            if self._node != NULL:
                return <string>self._node.GetToolTip()
            return None

    property displayname:
        def __get__(self):
            if self._node != NULL:
                return <string>self._node.GetDisplayName()
            return None

    property type:
        def __get__(self):
            if self._node != NULL:
                return self._type.value
            return None
        
    property value:
        def __get__(self):
            if self._node != NULL and self.isReadable:
                if self.type == 'IFloat':
                    return dynamic_cast_IFloat(self._node).GetValue()
                if self.type == 'IInteger':
                    return dynamic_cast_IInteger(self._node).GetValue()
                if self.type == 'IBoolean':
                    return dynamic_cast_IBoolean(self._node).GetValue()
                if self.type == 'IString':
                    return dynamic_cast_IString(self._node).GetValue()
                if self.type == 'IEnumeration':
                    self._debug(self._enumeration.symbolics)
                    return self._enumeration.value
                else:
                    self._error("Unsupported INode type %s" % self.type)
            return None
        def __set__(self,value):
            if self._node != NULL and self.isWritable:
                if self.type == 'IFloat':
                    dynamic_cast_IFloat(self._node).SetValue(value)
                if self.type == 'IInteger':
                    dynamic_cast_IInteger(self._node).SetValue(value)
                if self.type == 'IBoolean':
                    dynamic_cast_IBoolean(self._node).SetValue(value)
#                 if self.type == 'IString':
#                     dynamic_cast_IString(self._node).SetValue(value)
                else:
                    self._error("Unsupported INode type %s" % self.type)

    def keys(self):
        if self._node != NULL:
            if self.type == 'IEnumeration':
                self._debug(self._enumeration.symbolics)
                return self._enumeration.symbolics
            else:
                self._debug("It's not an enumeration")
