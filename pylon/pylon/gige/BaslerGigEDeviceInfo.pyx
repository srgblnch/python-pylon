#!/usr/bin/env cython

#---- licence header
###############################################################################
## file :               BaslerGigEDeviceInfo.pyx
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


cdef extern from "pylon/gige/BaslerGigEDeviceInfo.h" namespace "Pylon":
    cdef cppclass CBaslerGigEDeviceInfo:
        String_t GetSerialNumber() except +
        String_t GetUserDefinedName() except +
        String_t GetModelName() except +
        String_t GetDeviceVersion() except +
        String_t GetDeviceFactory() except +
        String_t GetAddress() except +
        String_t GetIpAddress() except +
        String_t GetDefaultGateway() except +
        String_t GetSubnetMask() except +
        String_t GetPortNr() except +
        String_t GetMacAddress() except +
        String_t GetInterface() except +
        String_t GetIpConfigOptions() except +
        String_t GetIpConfigCurrent() except +
        bool IsPersistentIpActive() except +
        bool IsDhcpActive() except +
        bool IsAutoIpActive() except +
        bool IsPersistentIpSupported() except +
        bool IsDhcpSupported() except +
        bool IsAutoIpSupported() except +
        bool IsSubset( IProperties& Subset) except +

cdef class __CBaslerGigEDeviceInfo(__CDeviceInfo):
    cdef:
        CBaslerGigEDeviceInfo _baslerGigEDeviceInfo
    def __cinit__(self):
        super(__CBaslerGigEDeviceInfo,self).__init__()
    def __str__(self):
        return "CBaslerGigEDeviceInfo (of %s)"%self.GetSerialNumber()
    def __repr__(self):
        return "%s"%self
    cdef SetDevGigEInfo(self,CBaslerGigEDeviceInfo devGigEInfo):
        self._baslerGigEDeviceInfo = devGigEInfo
    cdef CBaslerGigEDeviceInfo GetDevGigEInfo(self):
        return self._baslerGigEDeviceInfo
    def GetAddress(self):
        return <string>self.GetDevGigEInfo().GetAddress()
    def GetIpAddress(self):
        return <string>self.GetDevGigEInfo().GetIpAddress()
    def GetDefaultGateway(self):
        return <string>self.GetDevGigEInfo().GetDefaultGateway()
    def GetSubnetMask(self):
        return <string>self.GetDevGigEInfo().GetSubnetMask()
    def GetPortNr(self):
        return <string>self.GetDevGigEInfo().GetPortNr()
    def GetMacAddress(self):
        return <string>self.GetDevGigEInfo().GetMacAddress()
    def GetInterface(self):
        return <string>self.GetDevGigEInfo().GetInterface()
    def GetIpConfigOptions(self):
        return <string>self.GetDevGigEInfo().GetIpConfigOptions()
    def GetIpConfigCurrent(self):
        return <string>self.GetDevGigEInfo().GetIpConfigCurrent()
    def IsPersistentIpActive(self):
        return <bool>self.GetDevGigEInfo().IsPersistentIpActive()
    def IsDhcpActive(self):
        return <bool>self.GetDevGigEInfo().IsDhcpActive()
    def IsAutoIpActive(self):
        return <bool>self.GetDevGigEInfo().IsAutoIpActive()
    def IsPersistentIpSupported(self):
        return <bool>self.GetDevGigEInfo().IsPersistentIpSupported()
    def IsDhcpSupported(self):
        return <bool>self.GetDevGigEInfo().IsDhcpSupported()
    def IsAutoIpSupported(self):
        return <bool>self.GetDevGigEInfo().IsAutoIpSupported()

cdef BuildBaslerGigEDevInfo(CBaslerGigEDeviceInfo devInfo,CTlFactory* factory):
    wrapper = __CBaslerGigEDeviceInfo()
    wrapper.SetDevInfo(<CDeviceInfo>devInfo)
    wrapper.SetDevGigEInfo(devInfo)
    wrapper.SetTlFactory(factory)
    return wrapper
