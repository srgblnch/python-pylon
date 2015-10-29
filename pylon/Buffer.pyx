#!/usr/bin/env cython

#---- licence header
###############################################################################
## file :               Buffer.pyx
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

include "pylon/stdinclude.pyx"

cdef class RegisteredBuffer(object):
    cdef:
        IStreamGrabber* _streamGrabber
    def __init__(self,size):
        super(RegisteredBuffer,self).__init__()
        self._size = size
#     def __buildBuffer(self):
#         cdef int* buff
#         
#         

cdef RegisteredBuffer_Init(IStreamGrabber* streamGrabber,size):
    res = RegisteredBuffer(size)
    res._streamGrabber = streamGrabber
    return res

cdef class RegisteredBufferList(object):
    cdef:
        IPylonDevice* _pylonDevice
        IStreamGrabber* _streamGrabber
        int _nAcqBuffers
    _bufferList = []
    def __init__(self,nAcqBuffers):
        super(RegisteredBufferList,self).__init__()
        self._nAcqBuffers = <int>nAcqBuffers
#     def __buildBuffers(self):
#         if self._pylonDevice != NULL and self._streamGrabber != NULL:
#             size = self._pylonDevice.PayloadSize.GetValue()
#             for i in range(self._nAcqBuffers):
#                 newBuffer = RegisteredBuffer_Init(self._streamGrabber,size)
#                 self._bufferList.append(newBuffer)
    @property
    def nAcqBuffers(self):
        return self._nAcqBuffers
        
cdef RegisteredBufferList_Init(IPylonDevice* pylonDevice,
                              IStreamGrabber* streamGrabber,
                              nAcqBuffers):
    res = RegisteredBufferList(nAcqBuffers)
    res._pylonDevice = pylonDevice
    res._streamGrabber = streamGrabber
    res.__buildBuffers()
    return res

cdef class QueuedBufferList(object):
    def __init__(self):
        super(QueuedBufferList,self).__init__()
        
cdef QueuedBufferList_Init():
    res = QueuedBufferList()
    return res
