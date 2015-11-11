#!/usr/bin/env cython

#---- licence header
###############################################################################
## file :               Device.pyx
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


cdef extern from "pylon/Device.h" namespace "Pylon":
    ctypedef enum AccessMode: Stream, Control, Event, Exclusive
    cdef cppclass AccessModeSet:
        AccessModeSet() except +
        AccessModeSet(AccessMode) except +
    cdef cppclass IDevice
    cdef cppclass IPylonDevice:
        void Open(AccessModeSet) except +
        void Close() except +
        bool IsOpen() except +
        AccessModeSet AccessMode() except +
        uint32_t GetNumStreamGrabberChannels() except +
        IStreamGrabber* GetStreamGrabber(uint32_t index) except +
        IEventGrabber* GetEventGrabber() except +
        INodeMap* GetNodeMap() except +
        INodeMap* GetTLNodeMap() except +
        IChunkParser* CreateChunkParser() except +
        void DestroyChunkParser( IChunkParser* ) except +
        #IEventAdapter* CreateEventAdapter() except +
        #void DestroyEventAdapter( IEventAdapter* ) except +
        #DeviceCallbackHandle RegisterRemovalCallback( DeviceCallback& ) except +
        #bool DeregisterRemovalCallback( DeviceCallbackHandle ) except +

# cdef class __AccessModeSet:
#     cdef:
#         AccessModeSet _accessMode
#     def __cinit__(self):
#         self._accessMode = AccessModeSet(Exclusive)
#     cdef AccessModeSet GetAccessModeSet(self):
#         return self._accessMode
# 
cdef class __IDevice:
    def __cinit__(self):
        pass#super(__IDevice,self).__init__()
    def __str__(self):
        return "IDevice"

cdef class __IPylonDevice(__IDevice):
    cdef:
        IPylonDevice* _pylonDevice
    _accessMode = None
    def __cinit__(self):
        super(__IPylonDevice,self).__init__()
#         self._accessMode = __AccessModeSet()
    def __dealloc__(self):
        if self._pylonDevice is not NULL:
            pass#TODO: avoid memory leak
    def __str__(self):
        return "IPylonDevice"
    def __repr__(self):
        return "%s"%self
    cdef SetIPylonDevice(self,IPylonDevice* pylonDevice):
        self._pylonDevice = pylonDevice
    cdef IPylonDevice* GetIPylonDevice(self):
        return self._pylonDevice
    def IsOpen(self):
        if self._pylonDevice != NULL:
            return self._pylonDevice.IsOpen()
        return False
    def Open(self):
        if not self.IsOpen():
            try:
                self._pylonDevice.Open(AccessModeSet(Exclusive))
                return True
            except Exception,e:
                raise RuntimeError(e)
        return False
    def Close(self):
        if self.IsOpen():
            self._pylonDevice.Close()
            return True
        return False
    def GetNumStreamGrabberChannels(self):
        return self._pylonDevice.GetNumStreamGrabberChannels()
    def GetStreamGrabber(self):
        return StreamGrabber_Init(self._pylonDevice)
    def GetNodeMap(self):
        nodeMap = BuildINodeMap(self._pylonDevice.GetNodeMap())
        return nodeMap.GetINodeList()
