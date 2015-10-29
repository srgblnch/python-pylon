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


include "pylon/Device.pyx"
include "pylon/DeviceInfo.pyx"
include "pylon/DeviceFactory.pyx"
include "pylon/gige/BaslerGigECamera.pyx"
include "pylon/gige/PylonGigECamera.pyx"
include "pylon/gige/BaslerGigEDeviceInfo.pyx"
include "pylon/gige/PylonGigEDevice.pyx"
include "StreamGrabber.pyx"
include "ChunkParser.pyx"
include "genicam/IInteger.pyx"


cdef class Camera(object):
    cdef:
        CDeviceInfo _devInfo
        IDeviceFactory* _tlFactory
        IPylonGigEDevice* _pylonDevice
        #CBaslerGigECamera* _baslerCamera
        StreamGrabber _streamGrabber
    def __cinit__(self):
        super(Camera,self).__init__()
    def __dealloc__(self):
        self.Close()
        if self._pylonDevice != NULL:
            self._tlFactory.DestroyDevice(<IPylonDevice*>self._pylonDevice)
    def pylonDevice(self):
        return self.__buildPylonDevice()
    def __buildPylonDevice(self):
        if self._pylonDevice == NULL:
            #FIXME: this call seems to take a long time,
            # check if we can do it faster
            self._pylonDevice = \
            <IPylonGigEDevice*>self._tlFactory.CreateDevice(self._devInfo)
#             self._baslerCamera = \
#             BuildCBaslerGigECamera(<IPylonDevice*>self._pylonDevice,True)
        return self
    @property
    def isOpen(self):
        if self._pylonDevice != NULL:
            return self._pylonDevice.IsOpen()
        return False
    def Open(self):
        if not self.isOpen:
            self._pylonDevice.Open(AccessModeSet(Exclusive))
            try:
                self.streamGrabber.Open()
            except:
                pass
            return True
        return False
    def Close(self):
        if self.isOpen:
            try:
                self.streamGrabber.Close()
            except:
                pass
            self._pylonDevice.Close()
            return True
        return False
    def __str__(self):
        return "%s"%(self.serialNumber)
    def __repr__(self):
        return "%s (%s)"%(self.serialNumber,self.modelName)
    @property
    def serialNumber(self):
        return int(<string>self._devInfo.GetSerialNumber())
    @property
    def userName(self):
        return <string>self._devInfo.GetUserDefinedName()
    @property
    def modelName(self):
        return <string>self._devInfo.GetModelName()
    @property
    def deviceVersion(self):
        return <string>self._devInfo.GetDeviceVersion()
    @property
    def deviceFactory(self):
        return <string>self._devInfo.GetDeviceFactory()
    @property
    def ipAddress(self):
        return <string>(<CBaslerGigEDeviceInfo>self._devInfo).GetIpAddress()
    @property
    def port(self):
        return <string>(<CBaslerGigEDeviceInfo>self._devInfo).GetPortNr()
    @property
    def macAddress(self):
        return <string>(<CBaslerGigEDeviceInfo>self._devInfo).GetMacAddress()
    @property
    def gateway(self):
        return <string>(<CBaslerGigEDeviceInfo>self._devInfo).GetDefaultGateway()
    @property
    def netmask(self):
        return <string>(<CBaslerGigEDeviceInfo>self._devInfo).GetSubnetMask()
    @property
    def interface(self):
        return <string>(<CBaslerGigEDeviceInfo>self._devInfo).GetInterface()
    @property
    def streamGrabber(self):
        if self._pylonDevice != NULL and self._streamGrabber == None:
            try:
                self._streamGrabber = StreamGrabber_Init(<IPylonDevice*>self._pylonDevice)
            except Exception,e:
                print("Camera.streamGrabber Exception: %s"%(e))
        return self._streamGrabber


cdef Camera_Init(CDeviceInfo devInfo,CTlFactory* tlFactory):
    res = Camera()
    res._devInfo = devInfo
    res._tlFactory = <IDeviceFactory*>tlFactory
    return res
