#!/usr/bin/env cython

#---- licence header
###############################################################################
## file :               Factory.pyx
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

cdef extern from "Factory.h":
    cdef cppclass CppFactory:
        CppFactory() except+
        void CreateTl() except+
        void ReleaseTl() except+
        int DeviceDiscovery() except+
        CppDevInfo* getNextDeviceInfo() except+
        CppCamera* CreateCamera(CppDevInfo* wrapperDevInfo) except+

#TODO: make it python singleton
#FIXME: build again the factory produces a segmentation fault!
cdef class Factory(Logger):
    cdef:
        CppFactory *_cppFactory
        int _nCameras
    _camerasLst = []
    _cameraModels = {}
    _serialDct = {}
    _ipDct = {}
    _macDct = {}
    _buildCameras = {}

    def __init__(self,*args,**kwargs):
        super(Factory,self).__init__(*args,**kwargs)
        self._setName("Factory()")
        self._debug("Called __init__()")
        if not self.__structuresHaveInfo__():
            if self._cppFactory == NULL:
                self._cppFactory = new CppFactory()
                self._cppFactory.CreateTl()
            self._refreshTlInfo()
        self._debug("__init__() done")

    def __del__(self):
        self._debug("Called __del__()")
        try:
            self.__cleanStructures__()
            if self._cppFactory != NULL:
                self._debug("Releasing the Transport Layer")
                self._cppFactory.ReleaseTl()
                self._debug("Remove the factory")
                del self._cppFactory
            self._debug("Factory deletion complete")
        except Exception as e:
            self._debug("Factory deletion suffers an exception: %s"(e))
        self._debug("__del__() done")

    def __dealloc__(self):
        self._debug("Called __dealloc__()")
        self.__del__()
        self._debug("__dealloc__() done")

    def __repr__(self):
        self._debug("repr of %s"%self._name)
        return "%s"%self._name

    def _refreshTlInfo(self):
        if self.__structuresHaveInfo__():
            self.__cleanStructures__()
        self._nCameras = self._cppFactory.DeviceDiscovery()
        self.__populateLists__()

    def __structuresHaveInfo__(self):
        return len(self._camerasLst) > 0 or \
                len(self._cameraModels.keys()) > 0 or \
                len(self._serialDct.keys()) > 0 or \
                len(self._ipDct.keys()) > 0 or \
                len(self._macDct.keys()) > 0 or \
                len(self._buildCameras.keys()) > 0

    def __cleanStructures__(self):
        i = 0
        try:
            while self.__structuresHaveInfo__():
                self._debug("Clean lists: loop %d (%d,%d,%d,%d,%d,%d)"
                            %(i,len(self._camerasLst),
                              len(self._cameraModels.keys()),
                              len(self._serialDct.keys()),
                              len(self._ipDct.keys()),
                              len(self._macDct.keys()),
                              len(self._buildCameras.keys())))
                self.__cleanLst__(self._camerasLst,"cameraLst")
                self.__cleanDict1key__(self._cameraModels,"cameraModels")
                self.__cleanDict1key__(self._serialDct,"serialDct")
                self.__cleanDict1key__(self._ipDct,"ipDct")
                self.__cleanDict1key__(self._macDct,"macDct")
                self.__cleanDict1key__(self._buildCameras,"instance")
                i += 1
            self._debug("Clean structures finish ok")
        except Exception as e:
            self._warning("Clean the structures had an exception: %s"%(e))

    def __cleanLst__(self,lst,name):
        if len(lst) > 0:
            obj = lst.pop()
            self._debug("Removing %s object %s"%(name,obj))
            del obj

    def __cleanDict1key__(self,dct,name):
        if len(dct) > 0:
            key = dct.keys()[0]
            obj = dct.pop(key)
            self._debug("Removing %s key %s: object %s"%(name,key,obj))
            if type(obj) == list:
                while len(obj) > 0:
                    self.__cleanLst__(obj,key)
            del obj

    def __populateLists__(self):
        cdef:
            CppDevInfo* deviceInfo
        deviceInfo = self._cppFactory.getNextDeviceInfo()
        while deviceInfo != NULL:
            #build wrapper object
            pythonDeviceInfo = __DeviceInformation()
            pythonDeviceInfo.SetCppDevInfo(deviceInfo)
            #populate structures
            self._camerasLst.append(pythonDeviceInfo)
            if not pythonDeviceInfo.ModelName in self._cameraModels.keys():
                self._cameraModels[pythonDeviceInfo.ModelName] = []
            self._cameraModels[pythonDeviceInfo.ModelName].append(pythonDeviceInfo)
            self._serialDct[int(pythonDeviceInfo.SerialNumber)] = pythonDeviceInfo
            self._ipDct[pythonDeviceInfo.IpAddress] = pythonDeviceInfo
            self._macDct[pythonDeviceInfo.MacAddress] = pythonDeviceInfo
            #next:
            deviceInfo = self._cppFactory.getNextDeviceInfo()

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

    cdef __BuildCameraObj(self,__DeviceInformation devInfo):
        cdef:
            CppCamera* cppCamera
        camera = Camera()
        cppCamera = self._cppFactory.CreateCamera(devInfo.GetCppDevInfo())
        if cppCamera != NULL:
            camera.SetCppCamera(cppCamera)
        return camera
    
    def __prepareCameraObj(self,__DeviceInformation devInfo):
        if not devInfo.SerialNumber in self._buildCameras.keys():
            self._debug("Building instance for the camera with the "\
                        "serial number %d"%(devInfo.SerialNumber))
            camera = self.__BuildCameraObj(devInfo)
            self._buildCameras[devInfo.SerialNumber] = camera
            return camera
        else:
            self._debug("Camera with the serial number %d already instanciated"
                        %(devInfo.SerialNumber))
            camera = self._buildCameras[devInfo.SerialNumber]
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
