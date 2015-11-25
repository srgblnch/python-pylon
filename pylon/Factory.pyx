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


class Factory(object):
    __TlFactory = None
    def __init__(self,useCpp=True,alternative=False):
        super(Factory,self).__init__()
        self._alternative = alternative
        self.__TlFactory = __CTlFactory(useCpp)
        self._refreshTlInfo()
    def _refreshTlInfo(self):
        self._cameraList = []
        self._cameraModels = {}
        self._ipLst = []
        self._macLst = []
        self.__TlFactory._deviceDiscovery()
        for camera in self.__TlFactory.cameraList():
            cameraObj = Camera(camera)
            self._cameraList.append(cameraObj)
            if not cameraObj.modelName in self._cameraModels.keys():
                self._cameraModels[cameraObj.modelName] = []
            self._cameraModels[cameraObj.modelName].append(cameraObj)
            self._ipLst.append(cameraObj.ipAddress)
            self._macLst.append(cameraObj.macAddress)
        self._cameraList.sort()
        for model in self._cameraModels.keys():
            self._cameraModels[model].sort()
        self._ipLst.sort()
        self._macLst.sort()
    @property
    def nCameras(self):
        return self.__TlFactory.nCameras()
    @property
    def cameraList(self):
        return self._cameraList[:]
    @property
    def cameraModels(self):
        return self._cameraModels.keys()
    def cameraListByModel(self,model):
        if model in self._cameraModels.keys():
            return self._cameraModels[model][:]
        return []
    @property
    def ipList(self):
        return self._ipLst[:]
    @property
    def macList(self):
        return self._macLst[:]

    def __prepareCameraObj(self,camera):
        camera.pylonDevice = self.__TlFactory.CreateDeviceObj(camera.devInfo)
        #FIXME: the attach fails, exception says:
        #       "The attached Pylon Device is not of type IPylonGigEDevice"
        if self._alternative:
            camera.baslerCamera = self.__TlFactory._CameraObjAlternativeBuild(camera.devInfo)
        else:
            camera.baslerCamera = self.__TlFactory.CreateCameraObj(\
                                    camera.pylonDevice)
        camera.streamGrabber = camera.pylonDevice.GetStreamGrabber()

    def getCameraBySerialNumber(self,number):
        for i,camera in enumerate(self._cameraList):
            if camera.serialNumber == int(number):
                self.__prepareCameraObj(camera)
                return camera
        raise KeyError("serial number %s not found"%(number))
    def getCameraByIpAddress(self,ipAddress):
        for camera in self._cameraList:
            if camera.ipAddress == ipAddress:
                self.__prepareCameraObj(camera)
                return camera
        raise KeyError("ip address %s not found"%(ipAddress))
    def getCameraByMacAddress(self,macAddress):
        for camera in self._cameraList:
            if camera.macAddress == macAddress:
                self.__prepareCameraObj(camera)
                return camera
        raise KeyError("mac address %s not found"%(macAddress))
