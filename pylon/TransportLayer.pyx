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

from libcpp cimport bool

cdef extern from "pylon/DeviceInfo.h" namespace "Pylon":
    cdef cppclass CDeviceInfo:
        CDeviceInfo() except +

cdef extern from "pylon/Container.h" namespace "Pylon":
    cdef cppclass TlInfoList
    ctypedef TlInfoList TlInfoList_t
    cdef cppclass DeviceInfoList:
        DeviceInfoList() except +
    ctypedef DeviceInfoList DeviceInfoList_t
    #cdef DeviceInfoList_t* GetDeviceInfoList "new Pylon::DeviceInfoList"()
    

cdef extern from "pylon/TransportLayer.h" namespace "Pylon":
    cdef cppclass ITransportLayer

cdef extern from "pylon/TlInfo.h" namespace "Pylon":
    cdef cppclass CTlInfo

cdef extern from "pylon/TlFactory.h" namespace "Pylon":
    cdef cppclass CTlFactory:
        CTlFactory() except +
        int EnumerateTls( TlInfoList_t& )
        ITransportLayer* CreateTl( const CTlInfo& )
        void ReleaseTl( const ITransportLayer* )
        int EnumerateDevices( DeviceInfoList_t&, bool)
    #the way to declare static members is outside the class 
    cdef CTlFactory& CTlFactory_GetInstance "Pylon::CTlFactory::GetInstance"()

cdef extern from "pylon/gige/BaslerGigECamera.h" namespace "Pylon":
    cdef CTlInfo& GetDeviceClass "Pylon::CBaslerGigECamera::DeviceClass"()

#---- NOT available from python space
cdef class TransportLayer:
    cdef CTlFactory* _tlFactory
    cdef TlInfoList_t* _tlInfoList
    cdef ITransportLayer* _tl
    cdef DeviceInfoList_t* _deviceInfoList
    cdef int _nCameras
    def __init__(self):
        self._tlFactory = &CTlFactory_GetInstance()
        self.__CreateTl()
        cdef DeviceInfoList_t deviceInfoList
        self._nCameras = self._tlFactory.EnumerateDevices(deviceInfoList,False)
        self._deviceInfoList = &deviceInfoList
    def __del__(self):
        self.__ReleaseTl()
    def __CreateTl(self):
        self._tl = self._tlFactory.CreateTl(GetDeviceClass())
    def __ReleaseTl(self):
        self._tlFactory.ReleaseTl(self._tl)
    def nCameras(self):
        return self._nCameras
#     property nCameras:
#         def __get__(self):
#             return self._nCameras

#---- Available from python space
class TransportLayerFactory(object):
    def __init__(self):
        super(TransportLayerFactory,self).__init__()
        self._tlFactory = TransportLayer()
    @property
    def nCameras(self):
        return self._tlFactory.nCameras()
