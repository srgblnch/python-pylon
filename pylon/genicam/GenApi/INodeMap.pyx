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
    _nodes = {}
    def __cinit__(self):
        super(__INodeMap,self).__init__()
        for visibility in VisibilityEnum():
            self._nodes[VisibilityToStr(visibility)] = []
        #print("nodes visibilities: %s"%(self._nodes.keys()))
    cdef SetINodeMap(self,INodeMap* pNodeMap):
        self._pNodeMap = pNodeMap
        self.__cleanNodeList()
        self.__populateNodeMap()
    def __cleanNodeList(self):
        for key in self._nodes.keys():
            while len(self._nodes[key]) > 0:
                self._nodes[key].pop()
    def __populateNodeMap(self):
        #TODO: classify based on visibility of each node
        cdef:
            node_vector nodeLst
            node_vector.iterator it
        if self._pNodeMap is not NULL:
            self._pNodeMap.GetNodes(nodeLst)
            it = nodeLst.begin()
            while it != nodeLst.end():
                node = BuildNode(<INode*>deref(it))
                nodeVisibility = VisibilityToStr(node.GetVisibility())
                if nodeVisibility in self._nodes.keys():
                    self._nodes[nodeVisibility].append(node)
                else:
                    print("Ouch! This should never happend!! "\
                          "node: %s, visibility: %s (%s)"
                          %(node.GetName(),nodeVisibility,self._nodes.keys()))
                inc(it)
    def GetINodeList(self,visibilityLimit=Beginner):
        if type(visibilityLimit) == str:
            visibilityLimit = VisibilityFromStr(visibilityLimit)
        nodes = []
        for visibility in VisibilityEnum():
            #print("Adding %d elements from %s visibility (we had %d)"
            #      %(len(self._nodes[VisibilityToStr(visibility)]),
            #        VisibilityToStr(visibility),
            #        len(nodes)))
            nodes += self._nodes[VisibilityToStr(visibility)]
            if visibility == visibilityLimit:
                #print("Visibility limit reached")
                break
        return nodes
    def GetInodeBeginnerList(self):
        return self._nodes[VisibilityToStr(Beginner)]
    def GetInodeExpertList(self):
        return self._nodes[VisibilityToStr(Expert)]
    def GetInodeGuruList(self):
        return self._nodes[VisibilityToStr(Guru)]
    def GetNode(self,nodeName,visibilityLimit=Beginner):
        nodes = self.GetINodeList(visibilityLimit)
        if nodeName in nodes:
            return nodes[nodes.index(nodeName)]

cdef BuildINodeMap(INodeMap* nodeMap):
    wrapper = __INodeMap()
    wrapper.SetINodeMap(nodeMap)
    return wrapper
