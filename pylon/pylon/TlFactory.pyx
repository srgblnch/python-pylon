#!/usr/bin/env cython

#---- licence header
###############################################################################
## file :               TlFactory.pyx
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

include "Container.pyx"

cdef extern from "pylon/TlFactory.h" namespace "Pylon":
    cdef cppclass CTlFactory:
        int EnumerateTls( TlInfoList_t& )
        ITransportLayer* CreateTl( CTlInfo& )
        ITransportLayer* CreateTl( String_t& DeviceClass )
        void ReleaseTl( ITransportLayer* )
        int EnumerateDevices( DeviceInfoList&, bool )
        int EnumerateDevices( DeviceInfoList&, DeviceInfoList&, bool)
        IPylonDevice* CreateDevice( CDeviceInfo& )
        IPylonDevice* CreateFirstDevice( CDeviceInfo& )
        IPylonDevice* CreateDevice( CDeviceInfo&, StringList_t& )
        IPylonDevice* CreateFirstDevice( CDeviceInfo&, StringList_t& )
        IPylonDevice* CreateDevice( String_t& )
        void DestroyDevice( IPylonDevice* )
    cdef CTlFactory& CTlFactory_GetInstance "Pylon::CTlFactory::GetInstance"()