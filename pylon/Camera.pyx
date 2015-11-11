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

__TLREAD_TIMEOUT = 250#ms
__TLWRITE_TIMEOUT = 250#ms
__TLHEARTBEAT_TIMEOUT = 5000#ms


# cdef class __CppCamera:
#     cdef:
#         CDeviceInfo _devInfo
#         CTlFactory* _TlFactory
#         IPylonGigEDevice* _pylonDevice
#         CBaslerGigECamera* _baslerCamera
#         ITransportLayer* _tl#Each camera has each transport layer to it.
#         __StreamGrabber _streamGrabber
#     def __cinit__(self):
#         pass
#     def __del__(self):
#         self.ReleaseDevice()
#     def __dealloc__(self):
#         self.ReleaseDevice()
#     #---- Build area
#     def CreateDevice(self):
#         try:
#             self.__CreateTransportLayer__()
#             self.__CreatePylonDevice__()
#         except Exception,e:
#             print e
#             raise Exception(e)
#     def ReleaseDevice(self):
#         try:
#             self.__ReleasePylonDevice__()
#             self.__ReleaseTransportLayer()
#         except Exception,e:
#             print e
#             raise Exception(e)
#     def __CreateTransportLayer__(self):
#         if self._TlFactory is NULL:
#             self._TlFactory = &CTlFactory_GetInstance()
#             if not self._TlFactory:
#                 raise ReferenceError("Fatal building Transport Layer Factory")
#         if self._tl is NULL:
#             self._tl = self._TlFactory.CreateTl(GetDeviceClass())
#             if not self._tl:
#                 raise ReferenceError("Fatal building Transport Layer")
#     def __ReleaseTransportLayer__(self):
#         if self._TlFactory is not NULL and self._tl is not NULL:
#             self._TlFactory.ReleaseTl(self._tl)
#     def __CreatePylonDevice__(self):
#         cdef:
#             IPylonDevice* pylonDevice
#         if self._pylonDevice is NULL:
#             pylonDevice = self._TlFactory.CreateDevice(self._devInfo)
#             if not pylonDevice:
#                 raise ReferenceError("Fatal building Pylon Device")
#             self._pylonDevice = <IPylonGigEDevice*>&pylonDevice
#             #self._pylonDevice.Open()
#     def __ReleasePylonDevice__(self):
#         if self._pylonDevice is not NULL:
#             self._TlFactory.DestroyDevice(<IPylonDevice*>&self._pylonDevice)
#     def __CreateBaslerCamera__(self):
#         if self._baslerCamera is NULL and  self._pylonDevice is not NULL:
#             self._baslerCamera = BuildAndAttachCBaslerGigECamera(\
#                 <IPylonDevice*>&self._pylonDevice)
# #             self._baslerCamera = BuildCBaslerGigECamera()
#             if not self._baslerCamera:
#                 raise ReferenceError("Fatal building Basler Camera")
# #             if not self._baslerCamera.IsAttached():
# #                 self._baslerCamera.Attach(<IPylonDevice*>&self._pylonDevice)
#     def __ReleaseBaslerCamera(self):
#         if self._baslerCamera is not NULL:
#             pass
#     def __CreateStreamGrabber__(self):
#         if self._pylonDevice is NULL:
#             raise IOError("Not connected to the camera")
#         if self._streamGrabber is None:
#             self._streamGrabber = StreamGrabber_Init(\
#                 <IPylonDevice*>&self._pylonDevice)
#             if not self._streamGrabber:
#                 raise ReferenceError("Fatal building Stream Grabber")
#             self._streamGrabber.Open()
#     def __ReleaseStreamGrabber__(self):
#         if self._streamGrabber is not None:
#             self._streamGrabber.Close()
#     #---- actions area
#     def isOpen(self):
#         if self._pylonDevice is not NULL:
#             return self._pylonDevice.IsOpen()
#         return False
#     def Open(self):
#         if not self.isOpen():
#             #self.__CreateBaslerCamera__()
#             #self.__CreateStreamGrabber__()
#             self._pylonDevice.Open(AccessModeSet(Exclusive))
#             return True
#         return False
#     def Close(self):
#         if self.isOpen():
#             #self.__ReleaseStreamGrabber__()
#             #self.__ReleaseBaslerCamera()
#             self._pylonDevice.Close()
#             return True
#         return False
#     #---- basic information
#     def GetSerialNumber(self):
#         try:
#             return int(<string>self._devInfo.GetSerialNumber())
#         except:
#             return 0
#     def GetModelName(self):
#         try:
#             return <string>self._devInfo.GetModelName()
#         except:
#             return ''
#     def GetDeviceVersion(self):
#         try:
#             return <string>self._devInfo.GetDeviceVersion()
#         except:
#             return ''
#     def GetDeviceFactory(self):
#         try:
#             return <string>self._devInfo.GetDeviceFactory()
#         except:
#             return ''
#     def GetIpAddress(self):
#         cdef CBaslerGigEDeviceInfo devInfo
#         try:
#             devInfo = <CBaslerGigEDeviceInfo>self._devInfo
#             return <string>devInfo.GetIpAddress()
#         except:
#             return ''
#     def GetPortNr(self):
#         cdef CBaslerGigEDeviceInfo devInfo
#         try:
#             devInfo = <CBaslerGigEDeviceInfo>self._devInfo
#             return <string>devInfo.GetPortNr()
#         except:
#             return ''
#     def GetMacAddress(self):
#         cdef CBaslerGigEDeviceInfo devInfo
#         try:
#             devInfo = <CBaslerGigEDeviceInfo>self._devInfo
#             return <string>devInfo.GetMacAddress()
#         except:
#             return ''
#     def GetDefaultGateway(self):
#         cdef CBaslerGigEDeviceInfo devInfo
#         try:
#             devInfo = <CBaslerGigEDeviceInfo>self._devInfo
#             return <string>devInfo.GetDefaultGateway()
#         except:
#             return ''
#     def GetSubnetMask(self):
#         cdef CBaslerGigEDeviceInfo devInfo
#         try:
#             devInfo = <CBaslerGigEDeviceInfo>self._devInfo
#             return <string>devInfo.GetSubnetMask()
#         except:
#             return ''
#     def GetInterface(self):
#         cdef CBaslerGigEDeviceInfo devInfo
#         try:
#             devInfo = <CBaslerGigEDeviceInfo>self._devInfo
#             return <string>devInfo.GetInterface()
#         except:
#             return ''
#     def GetNumStreamGrabberChannels(self):
#         cdef uint32_t nChannels
#         if self._pylonDevice is not NULL and self._pylonDevice.IsOpen():
#             try:
#                 nChannels = self._pylonDevice.GetNumStreamGrabberChannels()
#                 print nChannels
#                 return int(nChannels)
#             except:
#                 pass
#         return -1
#     def GetPayloadSize(self):
#         if self._baslerCamera is not NULL and self._baslerCamera.IsAttached():
#             try:
#                 return self._baslerCamera.PayloadSize.GetValue()
#             except:
#                 pass
#         return -1
# 
# cdef BuildCppCamera(CDeviceInfo devInfo,CTlFactory* tlFactory):
#     res = __CppCamera()
#     res._devInfo = devInfo
#     res._TlFactory = tlFactory
#     return res

class Camera(object):
    def __init__(self,devInfo):
        super(Camera,self).__init__()
        self._devInfo = devInfo
        self._pylonDevice = None
        self._streamGrabber = None
    def __str__(self):
        return "%s"%(self.serialNumber)
    def __repr__(self):
        return "%s (%s)"%(self.serialNumber,self.modelName)
    @property
    def devInfo(self):
        return self._devInfo
    @property
    def pylonDevice(self):
        return self._pylonDevice
    @pylonDevice.setter
    def pylonDevice(self,value):
        self._pylonDevice = value
    @property
    def streamGrabber(self):
        return self._streamGrabber
    @streamGrabber.setter
    def streamGrabber(self,value):
        self._streamGrabber = value
#     @property
#     def baslerCamera(self):
#         return self._baslerCamera
#     @baslerCamera.setter
#     def baslerCamera(self,value):
#         self._baslerCamera = value
    @property
    def isOpen(self):
        return self.pylonDevice.IsOpen() and self.streamGrabber.IsOpen()
    def Open(self):
        if not self.pylonDevice.IsOpen():
            self.pylonDevice.Open()
        if not self.streamGrabber.IsOpen():
            return self.streamGrabber.Open()
        return False
    def Close(self):
        if self.streamGrabber.IsOpen():
            self.streamGrabber.Close()
        if self.pylonDevice.IsOpen():
            return self.pylonDevice.Close()
        return False
    @property
    def serialNumber(self):
        return int(self._devInfo.GetSerialNumber())
    @property
    def modelName(self):
        return self._devInfo.GetModelName()
    @property
    def deviceVersion(self):
        return self._devInfo.GetDeviceVersion()
    @property
    def deviceFactory(self):
        return self._devInfo.GetDeviceFactory()
    @property
    def ipAddress(self):
        return self._devInfo.GetIpAddress()
    @property
    def ipAddress(self):
        return self._devInfo.GetIpAddress()
    @property
    def port(self):
        return self._devInfo.GetPortNr()
    @property
    def macAddress(self):
        return self._devInfo.GetMacAddress()
    @property
    def gateway(self):
        return self._devInfo.GetDefaultGateway()
    @property
    def netmask(self):
        return self._devInfo.GetSubnetMask()
    @property
    def interface(self):
        return self._devInfo.GetInterface()
#     @property
#     def payloadSize(self):
#         return self._baslerCamera.GetPayloadSize()

