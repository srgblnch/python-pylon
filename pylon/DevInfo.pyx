#!/usr/bin/env cython

#---- licence header
###############################################################################
## file :               DevInfo.pyx
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

cdef extern from "DevInfo.h":
    cdef cppclass CppDevInfo:
        String_t GetSerialNumber() except+
        String_t GetModelName() except+
        String_t GetUserDefinedName() except+
        String_t GetDeviceVersion() except+
        String_t GetDeviceFactory() except+
        String_t GetAddress() except+
        String_t GetIpAddress() except+
        String_t GetDefaultGateway() except+
        String_t GetSubnetMask() except+
        String_t GetPortNr() except+
        String_t GetMacAddress() except+
        String_t GetInterface() except+
        String_t GetIpConfigOptions() except+
        String_t GetIpConfigCurrent() except+
        bool IsPersistentIpActive() except+
        bool IsDhcpActive() except+
        bool IsAutoIpActive() except+
        bool IsPersistentIpSupported() except+
        bool IsDhcpSupported() except+
        bool IsAutoIpSupported() except+


cdef class __DeviceInformation(Logger):
    cdef:
        CppDevInfo *_devInfo

    def __init__(self,*args,**kwargs):
        super(__DeviceInformation,self).__init__(*args,**kwargs)
        self._name = "DeviceInformation"
    
    def __del__(self):
        pass

    def __str__(self):
        return "%s"%(<string>self._devInfo.GetSerialNumber())
    def __repr__(self):
        return "%s (%s)"%(self.SerialNumber,self.ModelName)

    cdef SetCppDevInfo(self,CppDevInfo *devInfo):
        self._devInfo = devInfo
        self._name = "DeviceInformation (%s)"%(self.SerialNumber)
    
    cdef CppDevInfo* GetCppDevInfo(self):
        return self._devInfo
    
    @property
    def SerialNumber(self):
        return int(<string>self._devInfo.GetSerialNumber())
    
    @property
    def ModelName(self):
        return <string>self._devInfo.GetModelName()
    
    @property
    def UserDefinedName(self):
        return <string>self._devInfo.GetUserDefinedName()
    
    @property
    def DeviceVersion(self):
        return <string>self._devInfo.GetDeviceVersion()
    
    @property
    def DeviceVersion(self):
        return <string>self._devInfo.GetDeviceVersion()
    
    @property
    def Address(self):
        return <string>self._devInfo.GetAddress()
    
    @property
    def IpAddress(self):
        return <string>self._devInfo.GetIpAddress()
    
    @property
    def DefaultGateway(self):
        return <string>self._devInfo.GetDefaultGateway()
    
    @property
    def SubnetMask(self):
        return <string>self._devInfo.GetSubnetMask()
    
    @property
    def PortNr(self):
        return int(<string>self._devInfo.GetPortNr())
    
    @property
    def MacAddress(self):
        return <string>self._devInfo.GetMacAddress()
    
    @property
    def Interface(self):
        return <string>self._devInfo.GetInterface()
    
    @property
    def IpConfigOptions(self):
        return <string>self._devInfo.GetIpConfigOptions()
    
    @property
    def IpConfigCurrent(self):
        return <string>self._devInfo.GetIpConfigCurrent()
    
    @property
    def IsPersistentIpActive(self):
        return <bool>self._devInfo.IsPersistentIpActive()
    
    @property
    def IsDhcpActive(self):
        return <bool>self._devInfo.IsDhcpActive()
    
    @property
    def IsAutoIpActive(self):
        return <bool>self._devInfo.IsAutoIpActive()
    
    @property
    def IsPersistentIpSupported(self):
        return <bool>self._devInfo.IsPersistentIpSupported()
    
    @property
    def IsDhcpSupported(self):
        return <bool>self._devInfo.IsDhcpSupported()
    
    @property
    def IsAutoIpSupported(self):
        return <bool>self._devInfo.IsAutoIpSupported()
    