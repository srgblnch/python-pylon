#!/usr/bin/env cython

#---- licence header
###############################################################################
## file :               factory.pyx
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

#include "TransportLayer.pyx"

# class Factory(object):
#     _TransportLayer = None
#     def __cinit__(self):
#         super(Factory,self).__init__()
#         #self._TransportLayer = #_TlFactory()
#     @property
#     def TransportLayer(self):
#         return TransportLayerFactory()

from cython.operator cimport preincrement as inc,dereference as deref

include "Camera.pyx"
include "pylon/Container.pyx"
include "pylon/TlFactory.pyx"
include "pylon/gige/BaslerGigECamera.pyx"

cdef class __CppTlFactory:
    cdef:
        CTlFactory* _TlFactory
        int _nCameras
    _camerasList = []
    def __cinit__(self):
        cdef:
            DeviceInfoList deviceInfoList
            DeviceInfoList.iterator it
        self._TlFactory = &CTlFactory_GetInstance()
        self._nCameras = self._TlFactory.EnumerateDevices(deviceInfoList,False)
        if not deviceInfoList.empty():
            it = deviceInfoList.begin()
            while it != deviceInfoList.end():
                self._camerasList.append(BuildCppCamera(deref(it),
                                                        self._TlFactory))
                inc(it)
    def nCameras(self):
        return self._nCameras
    def cameraList(self):
        return self._camerasList

class TlFactory(object):
    __cppTlFactory = None
    def __init__(self):
        super(TlFactory,self).__init__()
        self.__cppTlFactory = __CppTlFactory()
        self._cameraList = []
        for camera in self.__cppTlFactory.cameraList():
            self._cameraList.append(Camera(camera))
    @property
    def nCameras(self):
        return self.__cppTlFactory.nCameras()
    @property
    def cameraList(self):
        return self._cameraList[:]
    @property
    def ipList(self):
        ipLst = []
        for camera in self._cameraList:
            if len(camera.ipAddress) > 0:
                ipLst.append(camera.ipAddress)
        return ipLst
    @property
    def macList(self):
        macLst = []
        for camera in self._cameraList:
            if len(camera.macAddress) > 0:
                macLst.append(camera.macAddress)
        return macLst
    def getCameraBySerialNumber(self,number):
        for camera in self._cameraList:
            if camera.serialNumber == int(number):
                camera.CreateDevice()
                return camera
        raise KeyError("serial number %s not found"%(number))
    def getCameraByIpAddress(self,ipAddress):
        for camera in self._cameraList:
            if camera.ipAddress == ipAddress:
                camera.CreateDevice()
                return camera
        raise KeyError("ip address %s not found"%(ipAddress))
    def getCameraByMacAddress(self,macAddress):
        for camera in self._cameraList:
            if camera.macAddress == macAddress:
                camera.CreateDevice()
                return camera
        raise KeyError("mac address %s not found"%(macAddress))

