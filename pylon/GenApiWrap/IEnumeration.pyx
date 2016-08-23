#!/usr/bin/env cython

#---- licence header
###############################################################################
## file :               IEnumeration.pyx
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


cdef extern from "GenApiWrap/IEnumeration.h":
    cdef cppclass CppIEnumeration:
        vector[string] getEntries() except+
        string getValue() except+
        bool setValue(string) except+
    CppIEnumeration* newCppIEnumeration "new CppIEnumeration" (INode* node) except+
    CppINode* castIEnumeration "dynamic_cast<CppINode*>" (CppIEnumeration* obj) except+

    cdef cppclass CppIEnumEntry:
        string getValue() except+


# cdef class Enumeration(Logger):
#     cdef:
#         CppEnumeration* _enumeration
#         list _lst
#  
#     def __init__(self,*args,**kwargs):
#         super(Enumeration,self).__init__(*args,**kwargs)
#         self.name = "Enumeration"
#         self._lst = []
#  
#     cdef setNode(self, INode* node):
#         self._enumeration = new CppEnumeration(node)
#         self._debug("Collecting symbols")
# #         for symbol in self._enumeration.getSymbolics():
# #             self._debug(symbol)
# #             self._lst.append(symbol)
#  
#     property value:
#         def __get__(self):
#             return self._enumeration.getEntry()
#  
#     property symbolics:
#         def __get__(self):
#             return self._lst


