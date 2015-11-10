#!/usr/bin/env cython

#---- licence header
###############################################################################
## file :               StreamGrabberProxy.pyx
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


cdef extern from "pylon/StreamGrabberProxy.h" namespace "Pylon":
    cdef cppclass CStreamGrabberProxyT:
        CStreamGrabberProxyT() except +
        CStreamGrabberProxyT(Pylon::IStreamGrabber*) except +
        void Attach(IStreamGrabber*) except +
        virtual bool IsAttached() except +
        virtual IStreamGrabber* GetStreamGrabber() except +
        void Open() except +
        void Close() except +
        bool IsOpen() except +
        StreamBufferHandle RegisterBuffer( void* Buffer, 
                                           size_t BufferSize ) except +
        void* DeregisterBuffer( StreamBufferHandle handle ) except +
        void PrepareGrab() except +
        void FinishGrab() except +
        void QueueBuffer( StreamBufferHandle Handle , 
                          void* Context=NULL ) except +
        void CancelGrab() except +
        bool RetrieveResult( GrabResult& Result ) except +
        WaitObject& GetWaitObject() except +
        GenApi::INodeMap* GetNodeMap() except +
