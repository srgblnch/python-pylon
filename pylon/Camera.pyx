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

cdef extern from "Camera.h":
    cdef cppclass CppCamera:
        CppCamera( CppDevInfo *devInfo ) except+


cdef class Camera(Logger):
    cdef:
        CppDevInfo *_devInfo
        CppCamera *_camera

    def __cinit__(self,*args,**kwargs):
        super(Camera,self).__init__(*args,**kwargs)
        self._name = "Camera"

    def __del__(self):
        del self._camera

    cdef SetDevInfo(self,CppDevInfo *devInfo):
        self._devInfo = devInfo

    cdef BuildCppCamera(self):
        self._camera = new CppCamera(self._devInfo)
