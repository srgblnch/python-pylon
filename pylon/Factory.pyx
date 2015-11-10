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
    def __init__(self):
        super(Factory,self).__init__()
        self.__TlFactory = __CTlFactory()
        self._cameraList = []
        for camera in self.__TlFactory.cameraList():
            self._cameraList.append(Camera(camera))
    @property
    def nCameras(self):
        return self.__TlFactory.nCameras()
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
        for i,camera in enumerate(self._cameraList):
            if camera.serialNumber == int(number):
                camera.pylonDevice = self.__TlFactory.CreateDevice(camera._devInfo)
                return camera
        raise KeyError("serial number %s not found"%(number))
    def getCameraByIpAddress(self,ipAddress):
        for camera in self._cameraList:
            if camera.ipAddress == ipAddress:
                camera.pylonDevice = self.__TlFactory.CreateDevice(camera._devInfo)
                return camera
        raise KeyError("ip address %s not found"%(ipAddress))
    def getCameraByMacAddress(self,macAddress):
        for camera in self._cameraList:
            if camera.macAddress == macAddress:
                camera.pylonDevice = self.__TlFactory.CreateDevice(camera._devInfo)
                return camera
        raise KeyError("mac address %s not found"%(macAddress))

