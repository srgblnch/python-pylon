#!/usr/bin/env cython

#---- licence header
###############################################################################
## file :               PylonGigEDevice.pyx
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


cdef extern from "pylon/gige/PylonGigEDevice.h" namespace "Pylon":
    cdef cppclass IPylonGigEDevice:
        #void Open(AccessModeSet) except +
        #void Close() except +
        #bool IsOpen() except +
        AccessModeSet AccessMode() except +
        uint32_t GetNumStreamGrabberChannels() except +
        IStreamGrabber* GetStreamGrabber(uint32_t index) except +Exception
        IEventGrabber* GetEventGrabber() except +
        INodeMap* GetNodeMap() except +
        INodeMap* GetTLNodeMap() except +
        IChunkParser* CreateChunkParser() except +
        void DestroyChunkParser( IChunkParser* ) except +
        void ChangeIpConfiguration( bool EnablePersistentIp, 
                                    bool EnableDhcp ) except +
        void GetPersistentIpAddress(String_t& IpAddress, 
                                    String_t& SubnetMask, 
                                    String_t& DefaultGateway) except +
        void SetPersistentIpAddress(String_t& IpAddress,
                                    String_t& SubnetMask,
                                    String_t& DefaultGateway) except +

cdef class __IPylonGigEDevice(__IPylonDevice):
    def __cinit__(self):
        super(__IPylonGigEDevice,self).__init__()
    def __str__(self):
        return "IPylonGigEDevice"
    def __repr__(self):
        return "%s"%self

# cdef BuildIPylonGigEDevice(devInfo):
#     wrapper = __IPylonGigEDevice()
#     #wrapper.SetIPylonDevice(<IPylonDevice*>devInfo.BuildIPylonDevice())
#     wrapper.SetIPylonDevice(<IPylonDevice*>((devInfo._TlFactory).CreateDevice(<CDeviceInfo>devInfo.GetDevInfo())))
#     return wrapper
