#!/usr/bin/env cython

#---- licence header
###############################################################################
## file :               DevInfo.pyx
##
## description :        This file has been made to provide a python access to
##                      the Pylon SDK from python.
##
## project :            python-pylon
##
## author(s) :          S.Blanch-Torn\'e
##
## Copyright (C) :      2015
##                      CELLS / ALBA Synchrotron,
##                      08290 Bellaterra,
##                      Spain
##
## This file is part of python-pylon.
##
## python-pylon is free software: you can redistribute it and/or modify
## it under the terms of the GNU Lesser General Public License as published by
## the Free Software Foundation, either version 3 of the License, or
## (at your option) any later version.
##
## python-pylon is distributed in the hope that it will be useful,
## but WITHOUT ANY WARRANTY; without even the implied warranty of
## MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
## GNU Lesser General Public License for more details.
##
## You should have received a copy of the GNU Lesser General Public License
## along with python-pylon.  If not, see <http://www.gnu.org/licenses/>.
##
###############################################################################

cdef extern from "DevInfo.h":
    cdef cppclass CppDevInfo:
        String_t GetSerialNumber() except+
        String_t GetModelName() except+
        String_t GetUserDefinedName() except+
        String_t GetDeviceVersion() except+
        String_t GetDeviceFactory() except+
    cdef cppclass CppGigEDevInfo:
        String_t GetSerialNumber() except+
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
    CppGigEDevInfo* dynamic_cast_CppGigEDevInfo_ptr(CppDevInfo*) except +


cdef class __DevInfo(Logger):
    '''
        Object with a representation of the available information about an
        specific camera. It provides information, but it is not the object
        to take control over the camera.
    '''
    cdef:
        CppDevInfo *_devInfo #CppDevInfo or subclasses

    def __init__(self,*args,**kwargs):
        super(__DevInfo,self).__init__(*args,**kwargs)
        self.name = "DevInfo()"
    
    def __del__(self):
        pass

    def __str__(self):
        return "%s"%(<string>(<CppDevInfo*>self._devInfo).GetSerialNumber())
    def __repr__(self):
        return "%s (%s)"%(self.SerialNumber,self.ModelName)

    cdef SetCppDevInfo(self,CppDevInfo *devInfo):
        self._devInfo = devInfo
        self.name = "DevInfo(%s)" % (self.SerialNumber)
    
    cdef CppDevInfo* GetCppDevInfo(self):
        return self._devInfo
    
    @property
    def SerialNumber(self):
        cdef:
            string sn
        sn = <string>(<CppDevInfo*>self._devInfo).GetSerialNumber()
        #self._debug("Found s/n %s"%(sn))
        return int(sn)
        #return int(<string>(<CppDevInfo*>self._devInfo).GetSerialNumber())
    
    @property
    def ModelName(self):
        return <string>(<CppDevInfo*>self._devInfo).GetModelName()
    
    @property
    def UserDefinedName(self):
        return <string>(<CppDevInfo*>self._devInfo).GetUserDefinedName()
    
    @property
    def DeviceVersion(self):
        return <string>(<CppDevInfo*>self._devInfo).GetDeviceVersion()


cdef class __GigEDevInfo(__DevInfo):
    cdef:
        CppGigEDevInfo *_gige
    def __init__(self,*args,**kwargs):
        super(__GigEDevInfo,self).__init__(*args,**kwargs)
        self.name = "GigEDevInfo()"

    cdef SetCppDevInfo(self,CppDevInfo *devInfo):
        __DevInfo.SetCppDevInfo(self,devInfo)
        self._gige = dynamic_cast_CppGigEDevInfo_ptr(devInfo)
        self.name = "GigEDevInfo(%s)" % (self.SerialNumber)

    @property
    def Address(self):
        return <string>self._gige.GetAddress()
     
    @property
    def IpAddress(self):
        return <string>self._gige.GetIpAddress()
     
    @property
    def DefaultGateway(self):
        return <string>self._gige.GetDefaultGateway()
     
    @property
    def SubnetMask(self):
        return <string>self._gige.GetSubnetMask()
     
    @property
    def PortNr(self):
        return int(<string>self._gige.GetPortNr())
     
    @property
    def MacAddress(self):
        return <string>self._gige.GetMacAddress()
     
    @property
    def Interface(self):
        return <string>self._gige.GetInterface()
     
    @property
    def IpConfigOptions(self):
        return <string>self._gige.GetIpConfigOptions()
     
    @property
    def IpConfigCurrent(self):
        return <string>self._gige.GetIpConfigCurrent()
     
    @property
    def IsPersistentIpActive(self):
        return <bool>self._gige.IsPersistentIpActive()
     
    @property
    def IsDhcpActive(self):
        return <bool>self._gige.IsDhcpActive()
     
    @property
    def IsAutoIpActive(self):
        return <bool>self._gige.IsAutoIpActive()
     
    @property
    def IsPersistentIpSupported(self):
        return <bool>self._gige.IsPersistentIpSupported()
     
    @property
    def IsDhcpSupported(self):
        return <bool>self._gige.IsDhcpSupported()
     
    @property
    def IsAutoIpSupported(self):
        return <bool>self._gige.IsAutoIpSupported()
    