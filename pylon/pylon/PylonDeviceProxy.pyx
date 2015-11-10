#!/usr/bin/env cython

#---- licence header
###############################################################################
## file :               PylonDeviceProxy.pyx
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


cdef extern from "pylon/PylonDeviceProxy.h" namespace "Pylon":
    cdef cppclass CPylonDeviceProxyT:
        CPylonDeviceProxyT() except +
        CPylonDeviceProxyT(IPylonDevice*, bool takeOwnership = true) except +
        void Attach(IPylonDevice*, bool takeOwnership = true) except +
        virtual bool IsAttached() except +
        virtual bool HasOwnership() except +
        virtual IPylonDevice* GetDevice() except +
        void Open(AccessModeSet mode) except +
        void Close() except +
        bool IsOpen() except +
        AccessModeSet AccessMode() except +
        CDeviceInfo& GetDeviceInfo() except +
        uint32_t GetNumStreamGrabberChannels() except +
        IStreamGrabber* GetStreamGrabber(uint32_t index) except +
        IEventGrabber* GetEventGrabber() except +
        GenApi::INodeMap* GetNodeMap() except +
        GenApi::INodeMap* GetTLNodeMap() except +
        Pylon::IChunkParser* CreateChunkParser() except +
        void DestroyChunkParser(Pylon::IChunkParser* pChunkParser) except +
        IEventAdapter* CreateEventAdapter() except +
        void DestroyEventAdapter(IEventAdapter* pAdapter) except +
        DeviceCallbackHandle RegisterRemovalCallback(DeviceCallback& d) except +
        bool DeregisterRemovalCallback(DeviceCallbackHandle h) except +

