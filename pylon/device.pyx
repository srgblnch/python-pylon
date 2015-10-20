#!/usr/bin/env cython

#---- licence header
###############################################################################
## file :               strings.pyx
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

include "strings.pyx"

from libcpp cimport bool
#from numpy cimport uint32_t

cdef extern from "pylon/DeviceInfo.h" namespace "Pylon":
    cdef cppclass CDeviceInfo:
        CDeviceInfo() except +
        CDeviceInfo(CDeviceInfo&) except +
        String_t GetSerialNumber()
        #String_t GetUserDefinedName()
        String_t GetModelName()
        #String_t GetDeviceVersion()
        #String_t GetDeviceFactory()

cdef extern from "pylon/Device.h" namespace "Pylon":
    ctypedef enum AccessMode: Stream, Control, Event, Exclusive
    cdef cppclass AccessModeSet:
        AccessModeSet()
        AccessModeSet(AccessMode)
    cdef cppclass IPylonDevice:
        void Open(AccessModeSet)
        void Close()
        bool IsOpen()
        AccessModeSet AccessMode()
        #uint32_t GetNumStreamGrabberChannels()

cdef extern from "pylon/DeviceFactory.h" namespace "Pylon":
    cdef cppclass IDeviceFactory:
        IPylonDevice* CreateDevice( CDeviceInfo& )
        void DestroyDevice( IPylonDevice* )


cdef class DeviceInfo(object):
    cdef CDeviceInfo _devInfo
    cdef IDeviceFactory* _tlFactory
    #cdef CTlFactory* _tlFactory
    def __init__(self):
        super(DeviceInfo,self).__init__()
    def __str__(self):
        return "%s"%(self.serialNumber)
    def __repr__(self):
        return "%s (%s)"%(self.serialNumber,self.modelName)
    @property
    def serialNumber(self):
        return int(<string>self._devInfo.GetSerialNumber())
#     @property
#     def userName(self):
#         return <string>self._devInfo.GetUserDefinedName()
    @property
    def modelName(self):
        return <string>self._devInfo.GetModelName()
#     @property
#     def deviceVersion(self):
#         return <string>self._devInfo.GetDeviceVersion()
#     @property
#     def deviceFactory(self):
#         return <string>self._devInfo.GetDeviceFactory()
    def getPylonDevice(self):
        return PylonDevice_Init(self._tlFactory.CreateDevice(self._devInfo))

cdef DeviceInfo_Init(CDeviceInfo devInfo,CTlFactory* tlFactory):
    res = DeviceInfo()
    res._devInfo = devInfo
    res._tlFactory = <IDeviceFactory*>tlFactory
    #res._tlFactory = tlFactory
    return res

cdef class PylonDevice(object):
    cdef IPylonDevice* _pylonDevice
    def __init__(self):
        super(PylonDevice,self).__init__()
#     @property
#     def serialNumber(self):
#         return self._devInfo.serialNumber
#     @property
#     def model(self):
#         return self._devInfo.modelName

cdef PylonDevice_Init(IPylonDevice* pylonDevice):
    res = PylonDevice()
    res._pylonDevice = pylonDevice
    return res
