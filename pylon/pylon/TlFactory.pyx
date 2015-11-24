#!/usr/bin/env cython
from Cython.Shadow import NULL

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

cdef extern from "CBuilders.h":
    cdef void _cppBuildTransportLayer(CTlFactory *factory,
                                      ITransportLayer *_tlptr)
    cdef int _cppEnumerateDevices(CTlFactory *factory,
                                  DeviceInfoList devicesList)
    cdef void _cppBuildPylonDeviceAndBaslerCamera(CTlFactory *factory,
                                                 CBaslerGigEDeviceInfo devInfo,
                                                 IPylonGigEDevice *pGigECamera,
                                                 CBaslerGigECamera *mCamera)

cdef class __CTlFactory(__IDeviceFactory):
    cdef:
        CTlFactory* _TlFactory
        int _nCameras
        __ITransportLayer _tl
        bool __useCpp
    _camerasList = []

    def __cinit__(self,useCpp=False):
        super(__CTlFactory,self).__init__()
        self.__useCpp = useCpp
        self._TlFactory = &CTlFactory_GetInstance()
        self._CreateTl()
        self._deviceDiscovery()

    def __dealloc__(self):
        #FIXME:review the transport layer usage
        self._ReleaseTl()

    cdef CTlFactory* GetTlFactory(self):
        return self._TlFactory

    def _CreateTl(self):
        cdef ITransportLayer* _tlptr
        _tlptr = NULL
        if self._tl == None:
            if self.__useCpp:
                _cppBuildTransportLayer(self._TlFactory,_tlptr)
            else:
                _tlptr = self._TlFactory.CreateTl(GetDeviceClass())
            self._tl = BuildITransportLayer(_tlptr)
        return self._tl

    def _ReleaseTl(self):
        if not self._tl == None:
            self._TlFactory.ReleaseTl(self._tl.GetITransportLayer())

    def _getTl(self):
        return self._tl

    def _deviceDiscovery(self):
        cdef:
            DeviceInfoList devicesList
            DeviceInfoList.iterator it
        #FIXME: enumerate device doen't work as expected in direct C code
#         if self.__useCpp:
#             self._nCameras = _cppEnumerateDevices(self._TlFactory,devicesList)
#         else:
        self._nCameras = self._TlFactory.EnumerateDevices(devicesList,False)
        while len(self._camerasList) > 0:
            self._camerasList.pop()
        if not devicesList.empty():
            it = devicesList.begin()
            while it != devicesList.end():
                #FIXME: By now only build GigE cameras but shall support others
                devInfo = BuildBaslerGigEDevInfo(\
                    <CBaslerGigEDeviceInfo>deref(it),self._TlFactory)
                self._camerasList.append(devInfo)
                inc(it)
        if len(self._camerasList) != self._nCameras:
            raise AssertionError("The number of cameras listed (%d), doesn't "\
                                 "correspond with the number enumerated (%d)"
                                 %(len(self._camerasList),self._nCameras))

    cdef IPylonDevice* _CreateDevice(self,CDeviceInfo devInfo):
        return self._TlFactory.CreateDevice(devInfo)

    cdef IPylonGigEDevice* _CreateGigEDevice(self,CDeviceInfo devInfo):
        return <IPylonGigEDevice*>self._TlFactory.CreateDevice(devInfo)

    def CreateDevice(self,__CDeviceInfo devInfo):
        #FIXME: By now only building GigE cameras but shall support the others
        wrapper = __IPylonGigEDevice()
        #wrapper.SetIPylonDevice(self._CreateDevice(devInfo.GetDevInfo()))
        wrapper.SetIPylonGigEDevice(self._CreateGigEDevice(devInfo.GetDevInfo()))
        return wrapper

    def CreateDevice_UsingCbuilder(self,__CBaslerGigEDeviceInfo devInfo):
        cdef:
            CTlFactory *factory
            CBaslerGigEDeviceInfo gigeDevInfo 
            IPylonGigEDevice *pylonGigEDevice
            CBaslerGigECamera *baslerGigECamera
        factory = self._TlFactory
        gigeDevInfo = devInfo.GetDevGigEInfo()
        pylonGigEDevice = NULL
        baslerGigECamera = NULL
        _cppBuildPylonDeviceAndBaslerCamera(factory,gigeDevInfo,
                                            pylonGigEDevice,baslerGigECamera)
        if pylonGigEDevice == NULL:
            raise ReferenceError("Failed to build the IPylonGigEDevice object")
        if baslerGigECamera == NULL:
            raise ReferenceError("Failed to build the CBaslerGigECamera object")
        pylonWrapper = __IPylonGigEDevice()
        pylonWrapper.SetIPylonGigEDevice(pylonGigEDevice)
        baslerWrapper = __CBaslerGigECamera()
        baslerWrapper.SetBaslerCamera(baslerGigECamera)
        return pylonWrapper,baslerWrapper

    def nCameras(self):
        return self._nCameras

    def cameraList(self):
        return self._camerasList

