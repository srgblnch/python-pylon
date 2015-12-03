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
    cdef cppclass CppFactory:
        CppFactory() except+
        void CreateTl() except+
        void ReleaseTl() except+
        int DeviceDiscovery() except+
        CppDevInfo* getNextDeviceInfo() except+

#TODO: make it python singleton
cdef class Factory(Logger):
    cdef:
        CppFactory *_cppFactory
        int _nCameras
    _camerasLst = []
    _cameraModels = {}
    _serialDct = {}
    _ipDct = {}
    _macDct = {}

    def __init__(self,*args,**kwargs):
        super(Factory,self).__init__(*args,**kwargs)
        self._name = "Factory"
        self._cppFactory = new CppFactory()
        self._cppFactory.CreateTl()
        self._refreshTlInfo()

    def __del__(self):
        try:
            self.__cleanLists__()
            self._debug("Releasing the Transport Layer")
            self._cppFactory.ReleaseTl()
            self._debug("Remove the factory")
            del self._cppFactory
            self._debug("Factory deletion complete")
        except Exception as e:
            self._debug("Factory deletion suffers an exception: %s"(e))

    def __dealloc__(self):
        self.__del__()

    def _refreshTlInfo(self):
        self.__cleanLists__()
        self._nCameras = self._cppFactory.DeviceDiscovery()
        self.__populateLists__()

    def __cleanLists__(self):
        i = 0
        try:
            while len(self._camerasLst) > 0 or \
            len(self._cameraModels.keys()) > 0 or \
            len(self._serialDct.keys()) > 0 or \
            len(self._ipDct.keys()) > 0 or \
            len(self._macDct.keys()) > 0:
                self._debug("Clean lists: loop %d (%d,%d,%d,%d,%d)"
                            %(i,len(self._camerasLst),
                              len(self._cameraModels.keys()),
                              len(self._serialDct.keys()),
                              len(self._ipDct.keys()),
                              len(self._macDct.keys())))
                if len(self._camerasLst) > 0:
                    bar = self._camerasLst.pop()
                    self._debug("Removing camera %s"%(bar))
                    del bar
                if len(self._cameraModels.keys()) > 0:
                    model = self._cameraModels.keys()[0]
                    lst = self._cameraModels.pop(model)
                    self._debug("Removing list for model %s (%d)"%(model,len(lst)))
                    while len(lst) > 0:
                        bar = lst.pop()
                        self._debug("For model %s Removing %s"%(model,bar))
                        del bar
                if len(self._serialDct.keys()) > 0:
                    serial = self._serialDct.keys()[0]
                    bar = self._serialDct.pop(serial)
                    self._debug("Removing serial %s"%(serial))
                    del bar
                if len(self._ipDct.keys()) > 0:
                    ip = self._ipDct.keys()[0]
                    bar = self._ipDct.pop(ip)
                    self._debug("Removing ip %s"%(ip))
                    del bar
                if len(self._macDct.keys()) > 0:
                    mac = self._macDct.keys()[0]
                    bar = self._macDct.pop(mac)
                    self._debug("Removing mac %s"%(mac))
                    del bar
                i += 1
            self._debug("Clean structures finish ok")
        except Exception as e:
            self._warning("Clean the structures had an exception: %s"%(e))

    def __populateLists__(self):
        cdef:
            CppDevInfo* deviceInfo
        deviceInfo = self._cppFactory.getNextDeviceInfo()
        while deviceInfo != NULL:
            pythonDeviceInfo = __DeviceInformation()
            pythonDeviceInfo.SetCppDevInfo(deviceInfo)
#             self._debug("--- %s"%pythonDeviceInfo.GetIpAddress())
#             #next:
            deviceInfo = self._cppFactory.getNextDeviceInfo()
            self._camerasLst.append(pythonDeviceInfo)
            if not pythonDeviceInfo.ModelName in self._cameraModels.keys():
                self._cameraModels[pythonDeviceInfo.ModelName] = []
            self._cameraModels[pythonDeviceInfo.ModelName].append(pythonDeviceInfo)
            self._serialDct[int(pythonDeviceInfo.SerialNumber)] = pythonDeviceInfo
            self._ipDct[pythonDeviceInfo.IpAddress] = pythonDeviceInfo
            self._macDct[pythonDeviceInfo.MacAddress] = pythonDeviceInfo

    @property
    def nCameras(self):
        return self._nCameras

    @property
    def camerasList(self):
        return self._camerasLst[:]

    @property
    def ipList(self):
        return self._ipDct.keys()

    @property
    def macList(self):
        return self._macDct.keys()

    @property
    def cameraModels(self):
        return self._cameraModels.keys()

    def cameraListByModel(self,model):
        if model in self._cameraModels.keys():
            return self._cameraModels[model][:]
        return []

    cdef __prepareCameraObj(self,__DeviceInformation devInfo):
        camera = Camera()
        camera.SetDevInfo(devInfo.GetCppDevInfo())
        return camera

    def getCameraBySerialNumber(self,number):
        number = int(number)
        if number in self._serialDct.keys():
            self._debug("Preparing the camera with the serial number %d"%number)
            return self.__prepareCameraObj(self._serialDct[number])
#         for i,devInfo in enumerate(self._camerasLst):
#             if devInfo.SerialNumber == int(number):
#                 camera = self.__prepareCameraObj(devInfo)
#                 return camera
        raise KeyError("serial number %s not found"%(number))

    def getCameraByIpAddress(self,ipAddress):
        if ipAddress in self._ipDct.keys():
            self._debug("Preparing the camera with the ip address %s"%ipAddress)
            return self.__prepareCameraObj(self._ipDct[ipAddress])
#         for devInfo in self._camerasLst:
#             if devInfo.IpAddress == str(ipAddress):
#                 camera = self.__prepareCameraObj(devInfo)
#                 return camera
        raise KeyError("ip address %s not found"%(ipAddress))

    def getCameraByMacAddress(self,macAddress):
        macAddress = macAddress.replace(':','')
        if macAddress in self._macDct.keys():
            self._debug("Preparing the camera with the mac address %s"%macAddress)
            return self.__prepareCameraObj(self._macDct[macAddress])
#         for devInfo in self._camerasLst:
#             if devInfo.MacAddress == macAddress:
#                 camera = self.__prepareCameraObj(devInfo)
#                 return camera
        raise KeyError("mac address %s not found"%(macAddress))
