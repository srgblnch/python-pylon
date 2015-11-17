#!/usr/bin/env cython

#---- licence header
###############################################################################
## file :               Pointer.pyx
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


cdef extern from "GenApi/Pointer.h" namespace "GenApi":
    #cdef cppclass CPointer#[T,B]
#     cdef cppclass CIntegerPtr "CPointer<IInteger>":
#         int64_t GetValue() except +
    ctypedef CIntegerPtr "CPointer<IInteger>"

#     cdef CBasePtr "CPointer<IBase>"()
#     cdef CNodePtr "CPointer<INode>"()
#     cdef CValuePtr "CPointer<IValue>"()
#     cdef CCategoryPtr "CPointer<ICategory>"()
#     cdef CBooleanPtr "CPointer<IBoolean>"()
# #     cdef CIntegerPtr "CPointer<IInteger>"(INode*)
    #cdef CPointer[IInteger] CIntegerPtr
#     typedef CPointer<IString> CStringPtr;
#     typedef CPointer<IRegister> CRegisterPtr;
#     typedef CPointer<IEnumeration> CEnumerationPtr;
#     typedef CPointer<IEnumEntry> CEnumEntryPtr;
#     typedef CPointer<IPort> CPortPtr;
#     typedef CPointer<IPortReplay> CPortReplayPtr;
#     typedef CPointer<IPortRecorder> CPortRecorderPtr;
#     typedef CPointer<IPortWriteList, IPortWriteList> CPortWriteListPtr;
#     typedef CPointer<IChunkPort> CChunkPortPtr;
#     typedef CPointer<INodeMap, INodeMap> CNodeMapPtr;
#     typedef CPointer<INodeMapDyn, INodeMap> CNodeMapDynPtr;
#     typedef CPointer<IDeviceInfo, INodeMap> CDeviceInfoPtr;
#     typedef CPointer<ISelector> CSelectorPtr;
#      typedef CPointer<ICommand> CCommandPtr;
#     class CFloatPtr : public CPointer<IFloat, IBase>
