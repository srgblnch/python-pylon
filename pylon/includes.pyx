#!/usr/bin/env cython

#---- licence header
###############################################################################
## file :               includes.pyx
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

from cython.operator cimport preincrement as inc,dereference as deref
from libcpp cimport bool
from libcpp.string cimport string
#from libcpp.vector cimport vector

#---- First level of needs
include "pylon/stdint.pyx"
include "pylon/stdinclude.pyx"
include "genicam/Base/GCString.pyx"
include "genicam/GenApi/Types.pyx"

#---- Second level (genicam)
include "genicam/GenApi/Container.pyx"
include "genicam/GenApi/ChunkAdapter.pyx"
include "genicam/Base/GCException.pyx"
include "genicam/GenApi/IInteger.pyx"
include "genicam/GenApi/INode.pyx"
include "genicam/GenApi/INodeMap.pyx"

#---- Third level (pylon): no alphabetical order due to its own dependencies
include "pylon/Container.pyx"
include "pylon/ChunkParser.pyx"
include "pylon/DeviceFactory.pyx"
include "pylon/TlInfo.pyx"
include "pylon/TlFactory.pyx"

#---- Fourth level (pylon cont.)
include "pylon/Device.pyx"
include "pylon/DeviceInfo.pyx"
include "pylon/EventGrabber.pyx"
include "pylon/Info.pyx"
include "pylon/PixelType.pyx"
include "pylon/PylonDeviceProxy.pyx"
include "pylon/Result.pyx"
include "pylon/TransportLayer.pyx"
include "pylon/StreamGrabber.pyx"
include "pylon/WaitObject.pyx"
include "pylon/gige/BaslerGigECamera.pyx"
include "pylon/gige/BaslerGigEDeviceInfo.pyx"
include "pylon/gige/PylonGigECamera.pyx"
include "pylon/gige/PylonGigEDevice.pyx"
include "pylon/gige/PylonGigEDeviceProxy.pyx"
include "pylon/gige/_GigETLParams.pyx"

#---- Last level (python-pylon)
include "guard.pyx"
include "Factory.pyx"
include "Camera.pyx"

