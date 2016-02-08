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
#cimport numpy as np

cdef extern from "Camera.h":
    cdef cppclass CppCamera:
        CppCamera( CppFactory *factory, CppDevInfo *devInfo ) except+
        bool IsOpen() except+
        bool Open() except+
        bool Close() except+
        bool IsGrabbing() except+
        bool Start() except+
        bool Stop() except+
        bool getImage(int timeout,CPylonImage *image) except+
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
            char *buf = NULL
            int imgSize
        self._debug("getImage()")
        if self._camera.getImage(5000,img):
            self._debug("done getImage")
            buf = <char*>img.GetBuffer()
            self._debug("GetBuffer()")
            imgSize = img.GetImageSize()
            self._debug("GetImageSize()")
            img_np = np.frombuffer(buf[:imgSize], dtype=np.uint8)
            self._debug("np.frombuffer")
            # TODO: How to handle multi-byte data here?
            img_np = img_np.reshape((img.GetHeight(), -1))
            self._debug("np.reshape")
            img_np = img_np[:img.GetHeight(), :img.GetWidth()]
            self._debug("img_np 2D")
            return img_np
        return None#TODO: Return a image np-like without data

    @property
    def SerialNumber(self):
        return int(<string>self._camera.GetSerialNumber())
    
    @property
    def ModelName(self):
        return <string>self._camera.GetModelName()

    @property
    def nStreamGrabbers(self):
        return int(self._camera.GetNumStreamGrabberChannels())
