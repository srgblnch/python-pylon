#!/usr/bin/env cython

#---- licence header
###############################################################################
## file :               TlFactory.pyx
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


cdef extern from "pylon/TlFactory.h" namespace "Pylon":
    cdef cppclass CTlFactory:
        int EnumerateTls( TlInfoList_t& ) except +
        ITransportLayer* CreateTl( CTlInfo& ) except +
        ITransportLayer* CreateTl( String_t& DeviceClass ) except +
        void ReleaseTl( ITransportLayer* ) except +
        int EnumerateDevices( DeviceInfoList&, bool ) except +
        #int EnumerateDevices( DeviceInfoList&, DeviceInfoList&, bool) except +
        IPylonDevice* CreateDevice( CDeviceInfo& ) except +
        #IPylonDevice* CreateFirstDevice( CDeviceInfo& ) except +
        #IPylonDevice* CreateDevice( CDeviceInfo&, StringList_t& ) except +
        #IPylonDevice* CreateFirstDevice( CDeviceInfo&, StringList_t& ) except +
        #IPylonDevice* CreateDevice( String_t& ) except +
        void DestroyDevice( IPylonDevice* ) except +
    cdef CTlFactory& CTlFactory_GetInstance \
    "Pylon::CTlFactory::GetInstance"()

cdef class __CTlFactory(__IDeviceFactory):
    cdef:
        CTlFactory* _TlFactory
        int _nCameras
        __ITransportLayer _tl
    _camerasList = []
    def __cinit__(self):
        super(__CTlFactory,self).__init__()
        self._TlFactory = &CTlFactory_GetInstance()
        self._CreateTl()
        self._deviceDiscovery()
    def _deviceDiscovery(self):
        cdef:
            DeviceInfoList deviceInfoList
            DeviceInfoList.iterator it
        self._nCameras = self._TlFactory.EnumerateDevices(deviceInfoList,False)
        while len(self._camerasList) > 0:
            self._camerasList.pop()
        if not deviceInfoList.empty():
            it = deviceInfoList.begin()
            while it != deviceInfoList.end():
                #FIXME: By now only build GigE cameras but shall support others
                devInfo = BuildBaslerGigEDevInfo(<CBaslerGigEDeviceInfo>deref(it),self._TlFactory)
                self._camerasList.append(devInfo)
                inc(it)
    def __dealloc__(self):
        #FIXME:review the transport layer usage
        self._ReleaseTl()
    def _CreateTl(self):
        cdef ITransportLayer* _tlptr
        if self._tl == None:
            _tlptr = self._TlFactory.CreateTl(GetDeviceClass())
            self._tl = BuildITransportLayer(_tlptr)
        return self._tl
    def _ReleaseTl(self):
        if not self._tl == None:
            self._TlFactory.ReleaseTl(self._tl.GetITransportLayer())
    def _getTl(self):
        return self._tl
    cdef IPylonDevice* _CreateDevice(self,CDeviceInfo devInfo):
        return self._TlFactory.CreateDevice(devInfo)
    cdef IPylonGigEDevice* _CreateGigEDevice(self,CDeviceInfo devInfo):
        return <IPylonGigEDevice*>self._TlFactory.CreateDevice(devInfo)
    def CreateDevice(self,__CDeviceInfo devInfo):
        wrapper = __IPylonGigEDevice()
        #wrapper.SetIPylonDevice(self._CreateDevice(devInfo.GetDevInfo()))
        wrapper.SetIPylonGigEDevice(self._CreateGigEDevice(devInfo.GetDevInfo()))
        return wrapper
        #FIXME: By now only building GigE cameras but shall support the others
    def nCameras(self):
        return self._nCameras
    def cameraList(self):
        return self._camerasList

