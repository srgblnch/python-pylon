#!/usr/bin/env cython

#---- licence header
###############################################################################
## file :               BaslerGigECamera.pyx
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


cdef extern from "pylon/gige/BaslerGigECamera.h" namespace "Pylon":
    cdef cppclass CBaslerGigECamera:
        void Attach(IPylonGigEDevice*, bool takeOwnership = true) except +
        bool IsAttached() except +
        bool HasOwnership() except +
        IInteger& PayloadSize
#         IInteger& Width
#         IInteger& Height
#         IInteger& SensorWidth
#         IInteger& SensorHeight
#         IInteger& WidthMax
#         IInteger& HeightMax
#         IInteger& OffsetX
#         IInteger& OffsetY
#         IInteger& BinningVertical
#         IInteger& BinningHorizontal
        #IEnumerationT<Basler_GigECameraParams::AcquisitionModeEnums>&\
        #    AcquisitionMode
#         ICommand& AcquisitionStart
#         ICommand& AcquisitionStop
#         ICommand& AcquisitionAbort
        
    cdef CTlInfo& GetDeviceClass "Pylon::CBaslerGigECamera::DeviceClass"()
    cdef CBaslerGigECamera* BuildAndAttachCBaslerGigECamera \
    "new Pylon::CBaslerGigECamera"( IPylonGigEDevice* ) except+
    cdef CBaslerGigECamera* BuildCBaslerGigECamera \
    "new Pylon::CBaslerGigECamera"() except+
    

# cdef CBaslerGigECamera* CBaslerGigECamera_Init(IPylonDevice* pylonDevice):
#     cdef CBaslerGigECamera res = CBaslerGigECamera(pylonDevice,True)
#     return &res

cdef class __CBaslerGigECamera:#(__CPylonGigECameraT):
    cdef:
        CBaslerGigECamera* _baslerCamera
        #FIXME: Perhaps this should be in the superclass?
    def __cinit__(self):
        super(__CBaslerGigECamera,self).__init__()
    def __str__(self):
        return "CBaslerGigECamera"
    def __repr__(self):
        return "%s"%self
    cdef SetBaslerCamera(self,CBaslerGigECamera* baslerCamera):
        self._baslerCamera = baslerCamera
    cdef Attach(self,IPylonDevice* pylonDevice):
        self._baslerCamera.Attach(<IPylonGigEDevice*>pylonDevice)
    def IsAttached(self):
        if self._baslerCamera is not NULL:
            return <bool>self._baslerCamera.IsAttached()
        return False
    def HasOwnership(self):
        if self._baslerCamera is not NULL:
            return <bool>self._baslerCamera.HasOwnership()
        return False
    def GetPayloadSize(self):
        if self._baslerCamera is not NULL:
            return self._baslerCamera.PayloadSize.GetValue()
        return -1

cdef BuildBaslerGigECamera(__IPylonDevice pylonDevice,doWithAttach=True):
    cdef IPylonDevice* pylonPtr
    wrapper = __CBaslerGigECamera()
    pylonPtr = pylonDevice.GetIPylonDevice()
    try:
        if doWithAttach:
            wrapper.SetBaslerCamera(BuildCBaslerGigECamera())
            wrapper.Attach(pylonPtr)
        else:
            wrapper.SetBaslerCamera(\
                BuildAndAttachCBaslerGigECamera(<IPylonGigEDevice*>pylonPtr))
    except Exception as ex:
        print_exc()
    return wrapper

