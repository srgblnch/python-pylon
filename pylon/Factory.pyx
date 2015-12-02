#!/usr/bin/env cython

#---- licence header
###############################################################################
## file :               Factory.pyx
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

cdef extern from "Factory.h":
    cdef cppclass Transport:
        Transport() except+
        void CreateTl() except+
        void ReleaseTl() except+
        int DeviceDiscovery() except+
        DeviceInformation* getNextDeviceInfo() except+


cdef class Factory(Logger):
    cdef:
        Transport _transport
        int _nCameras
    _camerasLst = []
    _cameraModels = {}
    _ipLst = []
    _macLst = []

    def __init__(self,*args,**kwargs):
        super(Factory,self).__init__(*args,**kwargs)
        self._name = "Factory"
        self._transport = Transport()
        self._transport.CreateTl()
        self._refreshTlInfo()

    def __del__(self):
        self._transport.ReleaseTl()

    def _refreshTlInfo(self):
        self._debug("__cleanLists__()")
        self.__cleanLists__()
        self._debug("DeviceDiscovery()")
        self._nCameras = self._transport.DeviceDiscovery()
        self._debug("__populateLists__()")
        self.__populateLists__()

    def __cleanLists__(self):
        while len(self._camerasLst) > 0 or len(self._ipLst) > 0 or \
        len(self._macLst) > 0:
            if len(self._camerasLst) > 0:
                self._camerasLst.pop()
            if len(self._ipLst) > 0:
                self._ipLst.pop()
            if len(self._macLst) > 0:
                self._macLst.pop()
        while len(self._cameraModels.keys()) > 0:
            self._cameraModels.pop(self._cameraModels.keys()[0])

    def __populateLists__(self):
        cdef:
            DeviceInformation* deviceInfo
        self._debug("take first element")
        deviceInfo = self._transport.getNextDeviceInfo()
        while deviceInfo != NULL:
            pythonDeviceInfo = __DeviceInformation()
            pythonDeviceInfo.SetDevInfo(deviceInfo)
#             self._debug("--- %s"%pythonDeviceInfo.GetIpAddress())
#             #next:
            self._debug("take next element")
            deviceInfo = self._transport.getNextDeviceInfo()
            self._camerasLst.append(pythonDeviceInfo)
            self._ipLst.append(pythonDeviceInfo.IpAddress)
            self._macLst.append(pythonDeviceInfo.MacAddress)
            if not pythonDeviceInfo.ModelName in self._cameraModels.keys():
                self._cameraModels[pythonDeviceInfo.ModelName] = []
            self._cameraModels[pythonDeviceInfo.ModelName].append(pythonDeviceInfo)
        self._debug("all elements iterated")

    @property
    def nCameras(self):
        return self._nCameras
    
    @property
    def camerasList(self):
        return self._camerasLst[:]
    
    @property
    def ipList(self):
        return self._ipLst[:]
    
    @property
    def macList(self):
        return self._macLst[:]
    
    @property
    def cameraModels(self):
        return self._cameraModels.keys()
    def cameraListByModel(self,model):
        if model in self._cameraModels.keys():
            return self._cameraModels[model][:]
        return []

#     def __prepareCameraObj(self,camera):
#         pass
#     
#     def getCameraBySerialNumber(self,number):
#         for i,camera in enumerate(self._cameraList):
#             if camera.serialNumber == int(number):
#                 self.__prepareCameraObj(camera)
#                 return camera
#         raise KeyError("serial number %s not found"%(number))
#     def getCameraByIpAddress(self,ipAddress):
#         for camera in self._cameraList:
#             if camera.ipAddress == ipAddress:
#                 self.__prepareCameraObj(camera)
#                 return camera
#         raise KeyError("ip address %s not found"%(ipAddress))
#     def getCameraByMacAddress(self,macAddress):
#         pass
