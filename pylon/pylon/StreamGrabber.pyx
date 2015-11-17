#!/usr/bin/env cython

#---- licence header
###############################################################################
## file :               streamGRabber.pyx
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


cdef extern from "pylon/StreamGrabber.h" namespace "Pylon":
    ctypedef void* StreamBufferHandle
    cdef cppclass IStreamGrabber:
        void Open() except +
        void Close() except +
        bool IsOpen() except +
        StreamBufferHandle RegisterBuffer( void* Buffer, 
                                           size_t BufferSize ) except +
        void* DeregisterBuffer( StreamBufferHandle ) except +
        void PrepareGrab() except +
        void FinishGrab() except +
        void QueueBuffer( StreamBufferHandle, 
                          const void* Context=NULL ) except +
        void CancelGrab() except +
        bool RetrieveResult( GrabResult& ) except +
        WaitObject& GetWaitObject() except +
        INodeMap* GetNodeMap() except +


cdef class __StreamGrabber:
    cdef:
        IPylonDevice* _pylonDevice
        IStreamGrabber* _streamGrabber
        #StreamBufferHandle* _streamBufferHandle
    def __init__(self):
        super(__StreamGrabber,self).__init__()
    def __dealloc__(self):
        self.Close()
        #if self._streamGrabber != NULL and self._streamBufferHandle != NULL:
            #self._streamGrabber.DeregisterBuffer(self._streamBufferHandle)
    cdef SetPylonDevice(self,IPylonDevice* pylonDevice):
        self._pylonDevice = pylonDevice
        self._streamGrabber = self._pylonDevice.GetStreamGrabber(0)
    def IsOpen(self):
        if self._streamGrabber != NULL:
            return self._streamGrabber.IsOpen()
        return False
    def Open(self):
        if not self.IsOpen():
            self._streamGrabber.Open()
            return True
        return False
    def Close(self):
        if self.IsOpen():
            self._streamGrabber.Close()
            return True
        return False
    def channels(self):
        if self._pylonDevice != NULL:
            return self._pylonDevice.GetNumStreamGrabberChannels()

cdef StreamGrabber_Init(IPylonDevice* pylonDevice):
    wrapper = __StreamGrabber()
    wrapper.SetPylonDevice(pylonDevice)
    return wrapper