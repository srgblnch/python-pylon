#!/usr/bin/env cython

#---- licence header
###############################################################################
## file :               TransportLayer.pyx
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

from cython.operator cimport preincrement as inc,dereference as deref

include "Camera.pyx"
include "pylon/Container.pyx"
include "pylon/stdint.pyx"
include "pylon/TransportLayer.pyx"
include "pylon/TlInfo.pyx"
include "pylon/TlFactory.pyx"


#---- NOT available from python space
cdef class TransportLayer:
    cdef CTlFactory* _tlFactory
    cdef TlInfoList_t* _tlInfoList
    cdef ITransportLayer* _tl
    cdef int _nCameras
    cdef DeviceInfoList* _deviceInfoList
    _camerasList = []
    def __init__(self):
        self._tlFactory = &CTlFactory_GetInstance()
        self.__CreateTl()
        cdef DeviceInfoList deviceInfoList# = DeviceInfoList()
        self._nCameras = self._tlFactory.EnumerateDevices(deviceInfoList,False)
        #self._camerasList = []
        cdef DeviceInfoList.iterator it = deviceInfoList.begin()
        while it != deviceInfoList.end():
            self._camerasList.append(Camera_Init(deref(it),self._tlFactory))
            inc(it)
    def __del__(self):
        self.__ReleaseTl()
    def __dealloc__(self):
        self.__ReleaseTl()
    def __CreateTl(self):
        self._tl = self._tlFactory.CreateTl(GetDeviceClass())
    def __ReleaseTl(self):
        self._tlFactory.ReleaseTl(self._tl)
    def nCameras(self):
        return self._nCameras
    def deviceInfoList(self):
        return self._camerasList
    def getCameraBySerialNumber(self,number):
        for cameraInfo in self._camerasList:
            #FIXME: this is maybe a too big loop, think how to make it shorter
            if cameraInfo.serialNumber == int(number):
                return cameraInfo.pylonDevice()
        raise KeyError("serial number %s not found"%(number))
    #TODO: shall be other getters, like from ipaddress


#---- Available from python space
class TransportLayerFactory(object):
    def __init__(self):
        super(TransportLayerFactory,self).__init__()
        self._tlFactory = TransportLayer()
    @property
    def nCameras(self):
        return self._tlFactory.nCameras()
    @property
    def CamerasList(self):
        #return ["%s"%i for i in self._tlFactory.deviceInfoList()]
        return self._tlFactory.deviceInfoList()
    def getCameraBySerialNumber(self,number):
        return self._tlFactory.getCameraBySerialNumber(number)

