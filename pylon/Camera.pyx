#!/usr/bin/env cython

#---- licence header
###############################################################################
## file :               Camera.pyx
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

include "pylon/DeviceFactory.pyx"
include "pylon/DeviceInfo.pyx"
include "pylon/gige/BaslerGigEDeviceInfo.pyx"
include "pylon/gige/PylonGigEDevice.pyx"
include "pylon/TransportLayer.pyx"

cdef class __CppCamera:
    cdef:
        CDeviceInfo _devInfo
        CTlFactory* _TlFactory
        IPylonGigEDevice* _pylonDevice
        ITransportLayer* _tl#Each camera has each transport layer to it.
        CGigETLParams_Params* _tlParams
    def __cinit__(self):
        pass
    def CreateDevice(self):
        self.__CreateTl__()
        self.__CreatePylonDevice__()
    def __del__(self):
        self.__Release__()
    def __dealloc__(self):
        self.__Release__()
    def __CreateTl__(self):
        if self._TlFactory is NULL:
            self._TlFactory = &CTlFactory_GetInstance()
        if self._tl is NULL:
            self._tl = self._TlFactory.CreateTl(GetDeviceClass())
    def __CreatePylonDevice__(self):
        cdef:
            IPylonDevice* pylonDevice
            INodeMap* tlParams
        if self._pylonDevice is NULL:
            pylonDevice = self._TlFactory.CreateDevice(self._devInfo)
            self._pylonDevice = <IPylonGigEDevice*>&pylonDevice
#             tlParams = self._pylonDevice.GetTLNodeMap()
#             self._tlParams = <CGigETLParams_Params*>&tlParams
    def __Release__(self):
        self.__ReleasePylonDevice__()
        self.__ReleaseTl()
    def __ReleaseTl__(self):
        if self._TlFactory is not NULL and self._tl is not NULL:
            self._TlFactory.ReleaseTl(self._tl)
    def __ReleasePylonDevice__(self):
        if self._pylonDevice is not NULL:
            self._TlFactory.DestroyDevice(<IPylonDevice*>&self._pylonDevice)
    def GetSerialNumber(self):
        try:
            return int(<string>self._devInfo.GetSerialNumber())
        except:
            return 0
    def GetModelName(self):
        try:
            return <string>self._devInfo.GetModelName()
        except:
            return ''
    def GetDeviceVersion(self):
        try:
            return <string>self._devInfo.GetDeviceVersion()
        except:
            return ''
    def GetDeviceFactory(self):
        try:
            return <string>self._devInfo.GetDeviceFactory()
        except:
            return ''
    def GetIpAddress(self):
        cdef CBaslerGigEDeviceInfo devInfo
        try:
            devInfo = <CBaslerGigEDeviceInfo>self._devInfo
            return <string>devInfo.GetIpAddress()
        except:
            return ''
    def GetPortNr(self):
        cdef CBaslerGigEDeviceInfo devInfo
        try:
            devInfo = <CBaslerGigEDeviceInfo>self._devInfo
            return <string>devInfo.GetPortNr()
        except:
            return ''
    def GetMacAddress(self):
        cdef CBaslerGigEDeviceInfo devInfo
        try:
            devInfo = <CBaslerGigEDeviceInfo>self._devInfo
            return <string>devInfo.GetMacAddress()
        except:
            return ''
    def GetDefaultGateway(self):
        cdef CBaslerGigEDeviceInfo devInfo
        try:
            devInfo = <CBaslerGigEDeviceInfo>self._devInfo
            return <string>devInfo.GetDefaultGateway()
        except:
            return ''
    def GetSubnetMask(self):
        cdef CBaslerGigEDeviceInfo devInfo
        try:
            devInfo = <CBaslerGigEDeviceInfo>self._devInfo
            return <string>devInfo.GetSubnetMask()
        except:
            return ''
    def GetInterface(self):
        cdef CBaslerGigEDeviceInfo devInfo
        try:
            devInfo = <CBaslerGigEDeviceInfo>self._devInfo
            return <string>devInfo.GetInterface()
        except:
            return ''
#     def GetReadTimeout(self):
#         try:
#             return self._tlParams.ReadTimeout.GetValue()
#         except:
#             raise ValueError("ReadTimeout not accessible")

cdef BuildCppCamera(CDeviceInfo devInfo,CTlFactory* tlFactory):
    res = __CppCamera()
    res._devInfo = devInfo
    res._TlFactory = tlFactory#<IDeviceFactory*>tlFactory
    return res

class Camera(object):
    def __init__(self,cppCamera):
        super(Camera,self).__init__()
        self.__cppCamera = cppCamera
    def __str__(self):
        return "%s"%(self.serialNumber)
    def __repr__(self):
        return "%s (%s)"%(self.serialNumber,self.modelName)
    def CreateDevice(self):
        self.__cppCamera.CreateDevice()
    @property
    def serialNumber(self):
        return self.__cppCamera.GetSerialNumber()
    @property
    def modelName(self):
        return self.__cppCamera.GetModelName()
    @property
    def deviceVersion(self):
        return self.__cppCamera.GetDeviceVersion()
    @property
    def deviceFactory(self):
        return self.__cppCamera.GetDeviceFactory()
    @property
    def ipAddress(self):
        return self.__cppCamera.GetIpAddress()
    @property
    def ipAddress(self):
        return self.__cppCamera.GetIpAddress()
    @property
    def port(self):
        return self.__cppCamera.GetPortNr()
    @property
    def macAddress(self):
        return self.__cppCamera.GetMacAddress()
    @property
    def gateway(self):
        return self.__cppCamera.GetDefaultGateway()
    @property
    def netmask(self):
        return self.__cppCamera.GetSubnetMask()
    @property
    def interface(self):
        return self.__cppCamera.GetInterface()
#     @property
#     def readTimeout(self):
#         return self.__cppCamera.GetReadTimeout()
