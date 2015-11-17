#!/usr/bin/env cython

#---- licence header
###############################################################################
## file :               DeviceInfo.pyx
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


cdef extern from "pylon/DeviceInfo.h" namespace "Pylon":
    cdef cppclass CDeviceInfo:
        CDeviceInfo() except +
        CDeviceInfo(CDeviceInfo&) except +
        String_t GetSerialNumber() except +
        String_t GetUserDefinedName() except +
        String_t GetModelName() except +
        String_t GetDeviceVersion() except +
        String_t GetDeviceFactory() except +


cdef class __CDeviceInfo(__CInfoBase):
    cdef:
        CDeviceInfo _DeviceInfo
        CTlFactory* _TlFactory
    def __cinit__(self):
        super(__CDeviceInfo,self).__init__()
    def __str__(self):
        return "CDeviceInfo (of %s)"%self.GetSerialNumber()
    def __repr__(self):
        return "%s"%self
    cdef SetDevInfo(self,CDeviceInfo devInfo):
         self._DeviceInfo = devInfo
    cdef CDeviceInfo GetDevInfo(self):
        return <CDeviceInfo>self._DeviceInfo
    cdef SetTlFactory(self,CTlFactory* factory):
        self._TlFactory = factory
    cdef IPylonDevice* BuildIPylonDevice(self):
        return self._TlFactory.CreateDevice(self.GetDevInfo())
    def GetSerialNumber(self):
        return int(<string>self.GetDevInfo().GetSerialNumber())
    def GetUserDefinedName(self):
        return <string>self.GetDevInfo().GetUserDefinedName()
    def GetModelName(self):
        return <string>self.GetDevInfo().GetModelName()
    def GetDeviceVersion(self):
        return <string>self.GetDevInfo().GetDeviceVersion()
    def GetDeviceFactory(self):
        return <string>self.GetDevInfo().GetDeviceFactory()

