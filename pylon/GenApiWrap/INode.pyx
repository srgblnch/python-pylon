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
        EVisibility GetVisibility() except+
        EInterfaceType GetPrincipalInterfaceType() except+

cdef extern from "GenApiWrap/INode.h":
    cdef cppclass CppINode:
        string getDescription() except+
        string getToolTip() except+
        string getDisplayName() except+
        vector[string] getProperties() except+
        string getProperty(string name) except+
        int getAccessMode() except+
        void setAccessMode(int mode)
        bool isImplemented() except+
        bool isAvailable() except+
        bool isReadable() except+
        bool isWritable() except+
        bool isCachable() except+
        bool isFeature() except+
        bool isDeprecated() except+
        INode* getINode() except+
    CppINode* newCppINode "new CppINode" (INode* node) except+

    cdef cppclass CppICategory:
        vector[string] getChildren() except+
    CppICategory*  newCppICategory  "new CppICategory" (INode* node) except+
    CppINode* castICategory "dynamic_cast<CppINode*>" (CppICategory* obj) except+

    cdef cppclass CppIEnumeration:
        vector[string] getEntries() except+
        string getValue() except+
    CppIEnumeration* newCppIEnumeration "new CppIEnumeration" (INode* node) except+
    CppINode* castIEnumeration "dynamic_cast<CppINode*>" (CppIEnumeration* obj) except+


cdef class Node(Logger):
    cdef:
        CppINode* _node
        InterfaceType _type

    def __init__(self,*args,**kwargs):
        super(Node,self).__init__(*args,**kwargs)
        self.name = "Node"
        self._type = InterfaceType()

    def __str__(self):
        return "<Node>(%s)"%self.name
    def __repr__(self):
        return "<%s>(%s)" % (self.type, self.displayname)

    cdef setINode(self, INode* node):
        self._type.setParent(node)
        if self.type == 'ICategory':
            self._node = castICategory(newCppICategory(node))
        elif self.type == 'IEnumerate':
            self._node = castIEnumeration(newCppIEnumeration(node))
        else:
            self._node = newCppINode(node)

    property type:
        def __get__(self):
            if self._node != NULL:
                return self._type.value
            return None

    property description:
        def __get__(self):
            if not self._node == NULL:
                return self._node.getDescription()
            return None

    property tooptip:
        def __get__(self):
            if self._node != NULL:
                return self._node.getToolTip()
            return None

    property displayname:
        def __get__(self):
            if self._node != NULL:
                return self._node.getDisplayName()
            return None

    property properties:
        def __get__(self):
            if self._node != NULL:
                return self._node.getProperties()
            return None
    def property(self,name):
        if self._node != NULL:
            return self._node.getProperty(name).split('\t')
        return None

    property _accessMode:
        def __get__(self):
            if self._node != NULL:
                return self._node.getAccessMode()
            return None
        def __set__(self,value):
            if self._node != NULL:
                self._node.setAccessMode(value)

    property isImplemented:
        def __get__(self):
            if self._node != NULL:
                return self._node.isImplemented()
            return None

    property isAvailable:
        def __get__(self):
            if self._node != NULL:
                return self._node.isAvailable()
            return None

    property isReadable:
        def __get__(self):
            if self._node != NULL:
                return self._node.isReadable()
            return None

    property isWritable:
        def __get__(self):
            if self._node != NULL:
                return self._node.isWritable()
            return None
 
    property cacheable:
        def __get__(self):
            if self._node != NULL:
                return self._node.isCachable()
            return None
 
    property feature:
        def __get__(self):
            if self._node != NULL:
                return self._node.isFeature()
            return None

    property deprecated:
        def __get__(self):
            if self._node != NULL:
                return self._node.isDeprecated()
            return None

    property value:
        def __get__(self):
            if self._node != NULL:
                if self.type == 'ICategory':
                    # ICategory should return a list of subnode names
                    return (<CppICategory*>self._node).getChildren()
                elif self.type == 'IBoolean':
                    return dynamic_cast_IBoolean(self._node.getINode()).GetValue()
                elif self.type == 'IInteger':
                    return dynamic_cast_IInteger(self._node.getINode()).GetValue()
                elif self.type == 'IFloat':
                    return dynamic_cast_IFloat(self._node.getINode()).GetValue()
                elif self.type == 'IEnumeration':
                    return (<CppIEnumeration*>self._node).getValue()
                # TODO: IString, ICommand, IRegister, IPort
                else:
                    self._error("Unsupported INode type %s" % self.type)
            return None
        # TODO: writable nodes should accept this property for write operation
        # def __set__(self,value):
        # ...

    property values:
        def __get__(self):
            if self._node != NULL:
                if self.type == 'ICategory':
                    # the same than value property
                    return (<CppICategory*>self._node).getChildren()
                elif self.type == 'IEnumeration':
                    return (<CppIEnumeration*>self._node).getEntries()
                # TODO: there are nodes that may have min,max and inc
                else:
                    self._error("Unsupported INode type %s" % self.type)
            return None

