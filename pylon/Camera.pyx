#!/usr/bin/env cython

#---- licence header
###############################################################################
## file :               Camera.pyx
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

import numpy as np
from Cython.Shadow import NULL
#cimport numpy as np

cdef extern from "Camera.h":
    cdef cppclass CppCamera:
        CppCamera( CppFactory *factory, CppDevInfo *devInfo ) except+
        bool IsOpen() except+
        bool Open() except+
        bool Close() except+
        bool IsGrabbing() except+
        bool Snap(void* buffer,size_t &payload,uint32_t &w,uint32_t &h) except+
        bool Start() except+
        bool Stop() except+
        bool getImage(CPylonImage *image) except+
        String_t GetSerialNumber() except+
        String_t GetModelName() except+
        uint32_t GetNumStreamGrabberChannels() except+


cdef class Camera(Logger):
    cdef:
        CppCamera *_camera
        int _serial

    def __init__(self,*args,**kwargs):
        super(Camera,self).__init__(*args,**kwargs)
        self.name = "Camera()"
        self._debug("Void Camera Object build, "\
                    "but it doesn't link with an specific camera")

    def __del__(self):
        if self.isopen:
            self.Close()
        del self._camera

    def __str__(self):
        return "%d"%self.SerialNumber
    def __repr__(self):
        return "%s (%s)"%(self.SerialNumber,self.ModelName)

    cdef SetCppCamera(self,CppCamera* cppCamera):
        self._camera = cppCamera
        name = "Camera(%d)"%(self.SerialNumber)
        self._debug("New name: %s"%name)
        self._setName(name)

    @property
    def isopen(self):
        return <bool>(self._camera.IsOpen())
    def Open(self):
        return <bool>(self._camera.Open())
    def Close(self):
        return <bool>(self._camera.Close())

    @property
    def isgrabbing(self):
        return <bool>(self._camera.IsGrabbing())
    def Start(self):
        if not self.isopen:
            self.Open()
        return <bool>(self._camera.Start())
    def Stop(self):
        return <bool>(self._camera.Stop())

    def getImage(self):
        cdef:
            CPylonImage *img = NULL
        self._debug("getImage()")
        if self._camera.getImage(img):
            self._debug("done getImage")
            return self.__fromBuffer(<char*>img.GetBuffer(),img.GetImageSize(),
                                     img.GetWidth(),img.GetHeight())
        return np.array([[],[]],dtype=np.uint8)

    def Snap(self):
        self._debug("Snap()")
        if not self.isgrabbing:
            self._debug("It's not grabbing")
            return self.CSnap()
        return self.getImage()

    cdef CSnap(self):
        cdef:
            char *buffer = NULL
            size_t payloadSize
            uint32_t width,height
        self._camera.Snap(buffer,payloadSize,width,height)
        self._debug("Get Snap(): (payload %d, width %d, heigth %d)"
                    %(payloadSize,width,height))
        return self.__fromBuffer(buffer,payloadSize,width,height)

    cdef __fromBuffer(self,char *buffer,size_t payloadSize,
                     uint32_t width,uint32_t height):
        if width*height == payloadSize:
            pixelType = np.uint8
            self._debug("pixelType: 8 bits")
        elif (width*height)*2 == payloadSize:
            pixelType = np.uint16
            self._debug("pixelType: 16 bits")
        else:
            self._debug("pixelType: unknown")
            raise BufferError("Not supported pixel type "\
                              "(payload %d, width %d, heigth %d)"
                              %(payloadSize,width,height))
        self._debug("> np.frombuffer(...)")
        img_np = np.frombuffer(buffer[:payloadSize], dtype=pixelType)
        self._debug("< np.frombuffer(...)")
        img_np = img_np.reshape((height, -1))
        self._debug("np.reshape")
        img_np = img_np[:height,:width]
        self._debug("img_np 2D")
        return img_np

    @property
    def SerialNumber(self):
        return int(<string>self._camera.GetSerialNumber())
    
    @property
    def ModelName(self):
        return <string>self._camera.GetModelName()

    @property
    def nStreamGrabbers(self):
        return int(self._camera.GetNumStreamGrabberChannels())
