/*---- licence header
###############################################################################
## file :               Factory.h
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
*/

#include "pylon/PylonIncludes.h"
#include <pylon/gige/BaslerGigECamera.h>

typedef Pylon::CBaslerGigECamera Camera_t;

//using namespace Pylon;

class Transport
{
public:
  Transport();
  ~Transport();
  void CreateTl();
  void ReleaseTl();
  int DeviceDiscovery();
  Pylon::CBaslerGigECamera::DeviceInfo_t* getNextDeviceInfo();
private:
  Pylon::ITransportLayer *_tl;
  Pylon::DeviceInfoList_t deviceList;
  Pylon::DeviceInfoList_t::const_iterator deviceIterator;
};
