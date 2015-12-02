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

cdef class Factory(object):
    cdef:
        Transport _transport
        int _nCameras
    _camerasList = []
    _cameraModels = {}
    _ipLst = []
    _macLst = []
    def __init__(self):
        super(Factory,self).__init__()
        self._transport = Transport()
        self._transport.CreateTl()
        self._refreshTlInfo()

    def _refreshTlInfo(self):
        self.__cleanLists__()
        self._nCameras = self._transport.DeviceDiscovery()
        self.__populateLists()

    def __cleanLists__(self):
        while len(self._camerasList) > 0 or len(self._ipLst) > 0 or \
        len(self._macList) > 0:
            if len(self._camerasList) > 0:
                self._camerasList.pop()
            if len(self._ipLst) > 0:
                self._ipList.pop()
            if len(self._macList) > 0:
                self._macList.pop()
        while len(self._cameraModels.keys()) > 0:
            self._cameraModels.pop(self._cameraModels.keys()[0])
            
    def __populateLists(self):
        pass

    @property
    def nCameras(self):
        return self._nCameras
    
    @property
    def camerasList(self):
        return self._camerasList[:]
    
#     @property
#     def cameraModels(self):
#         return self._cameraModels.keys()
#     def cameraListByModel(self,model):
#         if model in self._cameraModels.keys():
#             return self._cameraModels[model][:]
#         return []
#     @property
#     def ipList(self):
#         return self._ipLst[:]
#     @property
#     def macList(self):
#         return self._macLst[:]

    def __prepareCameraObj(self,camera):
        pass
    
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
        pass
