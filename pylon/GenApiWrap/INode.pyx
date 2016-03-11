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
#         bool IsDeprecated() except+
#         EAccessMode GetAccessMode() except+
#         void ImposeAccessMode(EAccessMode ImposedAccessMode) except+
#         bool IsCachable() except+
#         bool IsFeature() except+
        EVisibility GetVisibility() except+
#         string GetDescription() except+
#         string GetToolTip() except+
#         string GetDisplayName() except+
        EInterfaceType GetPrincipalInterfaceType() except+
#         void GetChildren(NodeList_t &Children,
#                          ELinkType LinkType=ctReadingChildren) except+
#     bool IsImplemented "IsImplemented" (EAccessMode AccessMode) except+
#     bool IsAvailable "IsAvailable" (EAccessMode AccessMode) except+
#     bool IsReadable "IsReadable" (EAccessMode AccessMode) except+
#     bool IsWritable "IsWritable" (EAccessMode AccessMode) except+

cdef extern from "GenApiWrap/INode.h":
    cdef cppclass CppINode:
        string getDescription() except+
        string getToolTip() except+
        string getDisplayName() except+
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

    cdef cppclass CppIEnumerate
    CppIEnumerate* newCppIEnumerate "new CppIEnumerate" (INode* node) except+
    CppINode* castIEnumerate "dynamic_cast<CppINode*>" (CppIEnumerate* obj) except+


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
            self._node = castIEnumerate(newCppIEnumerate(node))
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
                # TODO: IEnumeration
                # TODO: IString, ICommand, IRegister, IPort
                else:
                    self._error("Unsupported INode type %s" % self.type)
            return None





#     cdef:
#         INode* _node
#         InterfaceType _type
#         vector[INode*] _childs  # for ICategory nodes
#         Enumeration _enumeration  # for IEnumerate nodes

#     def __init__(self,*args,**kwargs):
#         super(Node,self).__init__(*args,**kwargs)
#         self.name = "Node"
#         self._type = InterfaceType()
#         self._enumeration = Enumeration()

#     cdef setINode(self,INode* node):
#         self._node = node
#         self.name = "Node(%s)" % self._node.GetName()
#         self._type.setParent(self._node)
#         if self.type == 'ICategory':
#             
#             pass  # TODO: child nodes tree
#         if self.type == 'IEnumeration':
#             self._enumeration.setNode(self._node)

#     cdef _getNodeChildren(self):
#         cdef:
#             NodeList_t children
#         self._node.GetChildren(children)




# 
# 
#         
#     property value:
#         def __get__(self):
#             if self._node != NULL:
#                 if self.type == 'ICategory':
#                     raise SyntaxError("This node is a category, "\
#                                       "access like a dictionary")
#                 elif self.isReadable:
#                     if self.type == 'IBoolean':
#                         return dynamic_cast_IBoolean(self._node).GetValue()
#                     elif self.type == 'IInteger':
#                         return dynamic_cast_IInteger(self._node).GetValue()
#                     elif self.type == 'IFloat':
#                         return dynamic_cast_IFloat(self._node).GetValue()
#                     elif self.type == 'IString':
#                         return dynamic_cast_IString(self._node).GetValue()
#                     elif self.type == 'IEnumeration':
#                         self._debug(self._enumeration.symbolics)
#                         return self._enumeration.value
#                     # TODO: ICommand, IRegister, IPort
#                     else:
#                         self._error("Unsupported INode type %s" % self.type)
#             return None
#         def __set__(self,value):
#             if self._node != NULL:
#                 if self.type == 'ICategory':
#                     raise SyntaxError("This node is a category, "\
#                                       "access like a dictionary")
#                 elif self.isWritable:
#                     if self.type == 'IFloat':
#                         dynamic_cast_IFloat(self._node).SetValue(value)
#                     elif self.type == 'IInteger':
#                         dynamic_cast_IInteger(self._node).SetValue(value)
#                     elif self.type == 'IBoolean':
#                         dynamic_cast_IBoolean(self._node).SetValue(value)
#                     # TODO: IString, ICommand, IRegister, IPort
#                     else:
#                         self._error("Unsupported INode type %s" % self.type)
# 
#     def keys(self):
#         if self._node != NULL:
#             if self.type == 'ICategory':
#                 pass  # TODO: list the child nodes
#             elif self.type == 'IEnumeration':
#                 self._debug(self._enumeration.symbolics)
#                 return self._enumeration.symbolics
#             else:
#                 self._debug("This type of node (%s) is not iterable"
#                             % (self.type))
