#!/usr/bin/env cython

#---- licence header
###############################################################################
## file :               INodeMap.pyx
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


cdef extern from "GenApi/INodeMap.h" namespace "GenApi":
    cdef cppclass INodeMap:
        void GetNodes(NodeList_t)
        INode* GetNode( gcstring& )

cdef class __INodeMap:
    cdef:
        INodeMap* _pNodeMap
    _nodes = []
    def __cinit__(self):
        super(__INodeMap,self).__init__()
    cdef SetINodeMap(self,INodeMap* pNodeMap):
        self._pNodeMap = pNodeMap
        self.__cleanNodeList()
        self.__populateNodeMap()
    def __cleanNodeList(self):
        while len(self._nodes) > 0:
            self._nodes.pop()
    def __populateNodeMap(self):
        #TODO: classify based on visibility of each node
        cdef:
            node_vector nodeLst
            node_vector.iterator it
        if self._pNodeMap is not NULL:
            self._pNodeMap.GetNodes(nodeLst)
            it = nodeLst.begin()
            print(nodeLst.size())
            while it != nodeLst.end():
                node = BuildNode(<INode*>deref(it))
                self._nodes.append(node)
                inc(it)
    def GetINodeList(self):
        return self._nodes
    
#         if self._pNodeMap is not NULL:
#             pass#self._pNodeMap.GetNodes(nodeLst)
#            self._nodeVector = CopyNodeVector(nodeLst)
#     def GetINodeList(self):
#         cdef node_vector.iterator it
#         if len(self._nodes) == 0:
#             pass
#             self._nodeMap.GetNodes(self._nodeLst)
#             it = self._nodeLst.begin()
#             while it != self._nodeLst.end():
#                 #node = BuildNode(<INode*>deref(it))
#                 #self._nodes.append(node)
#                 pass
#         return self._nodes

cdef BuildINodeMap(INodeMap* nodeMap):
    wrapper = __INodeMap()
    wrapper.SetINodeMap(nodeMap)
    return wrapper
