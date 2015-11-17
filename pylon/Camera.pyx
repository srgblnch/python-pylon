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


class Camera(object):
    def __init__(self,devInfo):
        super(Camera,self).__init__()
        self._devInfo = devInfo
        self._pylonDevice = None
        self._baslerCamera = None
        self._streamGrabber = None
#         self._nodes = []
    def __dealloc__(self):
        if self.streamGrabber != None and self.streamGrabber.IsOpen():
            self.streamGrabber.Close()
        if self.baslerCamera != None and self.baslerCamera.IsOpen():
            self.baslerCamera.Close()
        if self.pylonDevice != None and self.pylonDevice.IsOpen():
            self.pylonDevice.Close()
    def __str__(self):
        return "%s"%(self.serialNumber)
    def __repr__(self):
        return "%s (%s)"%(self.serialNumber,self.modelName)
    def __richcmp__(self,other,int op):
        if op == 0:#<
            return self.serialNumber < other.serialNumber
        elif op == 1:#<=
            return self.serialNumber <= other.serialNumber
        elif op == 2:#==
            return self.serialNumber == other.serialNumber
        elif op == 3:#!=
            return self.serialNumber != other.serialNumber
        elif op == 4:#>
            return self.serialNumber > other.serialNumber
        elif op == 5:#>=
            return self.serialNumber >= other.serialNumber
        else:
            raise IndexError("Compare operation not undertood (%d)"%(op))
    @property
    def devInfo(self):
        return self._devInfo
    @property
    def pylonDevice(self):
        return self._pylonDevice
    @pylonDevice.setter
    def pylonDevice(self,value):
        self._pylonDevice = value
#         self._updateNodes()
    @property
    def baslerCamera(self):
        return self._baslerCamera
    @baslerCamera.setter
    def baslerCamera(self,value):
        self._baslerCamera = value
    @property
    def streamGrabber(self):
        return self._streamGrabber
    @streamGrabber.setter
    def streamGrabber(self,value):
        self._streamGrabber = value
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
#         return self.pylonDevice["PayloadSize"]
#         #return self._baslerCamera.GetPayloadSize()
    #---- Dict area
#     def _updateNodes(self):
#         self._nodes = self._pylonDevice.GetNodeMap(self._visibility)
#     @property
#     def visibility(self):
#         return VisibilityToStr(self._visibility)
#     @visibility.setter
#     def visibility(self,value):
#         self.pylonDevice.SetVisibility(value)
#         self._visibility = VisibilityFromStr(value)
#         self._updateNodes()
#     def keys(self):
#         keys = []
#         for node in self._nodes:
#             keys.append(str(node))
#         return keys
#     def items(self):
#         return self._nodes
#     def __getitem__(self,key):
#         try:
#             pos = self._nodes.index(key)
#             node = self._nodes[pos]
#             return node
#         except:
#             raise KeyError("Unknown key (check visibility)")
#     def __len__(self):
#         return len(self._nodes)
#     def has_key(self,key):
#         return <bool>self._nodes.count(key)
