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

cdef extern from "Camera.h":
    cdef cppclass CppCamera:
        CppCamera( CppFactory *factory, CppDevInfo *devInfo ) except+
        String_t GetSerialNumber() except+
        String_t GetModelName() except+


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
    def SerialNumber(self):
        return int(<string>self._camera.GetSerialNumber())
    
    @property
    def ModelName(self):
        return <string>self._camera.GetModelName()
