#!/usr/bin/env cython

#---- licence header
###############################################################################
## file :               StreamGrabber.pyx
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

include "pylon/StreamGrabber.pyx"
include "Buffer.pyx"

cdef class StreamGrabber(object):
    cdef:
        IPylonDevice* _pylonDevice
        IStreamGrabber* _streamGrabber
        #StreamBufferHandle* _streamBufferHandle
    def __init__(self):
        super(StreamGrabber,self).__init__()
    def __dealloc__(self):
        self.Close()
        #if self._streamGrabber != NULL and self._streamBufferHandle != NULL:
            #self._streamGrabber.DeregisterBuffer(self._streamBufferHandle)
    @property
    def isOpen(self):
        if self._streamGrabber != NULL:
            return self._streamGrabber.IsOpen()
        return False
    def Open(self):
        if not self.isOpen:
            self._streamGrabber.Open()
            return True
        return False
    def Close(self):
        if self.isOpen:
            self._streamGrabber.Close()
            return True
        return False
    @property
    def channels(self):
        if self._pylonDevice != NULL:
            return self._pylonDevice.GetNumStreamGrabberChannels()

cdef StreamGrabber_Init(IPylonDevice* pylonDevice):
    res = StreamGrabber()
    res._pylonDevice = pylonDevice
    res._streamGrabber = pylonDevice.GetStreamGrabber(0)
    return res
