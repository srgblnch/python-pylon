/*---- licence header
###############################################################################
## file :               Camera.cpp
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

#include "Camera.h"

CppCamera::CppCamera(Pylon::CBaslerGigECamera::DeviceInfo_t _gigeDevInfo,
                     Pylon::IPylonDevice *_pDevice,
                     Pylon::CBaslerGigECamera* _bCamera)
  :gigeDevInfo(_gigeDevInfo),pDevice(_pDevice),bCamera(_bCamera)
{
  _name = "CppCamera(" + _gigeDevInfo.GetSerialNumber() + ")";
}

CppCamera::~CppCamera()
{
  //TODO: move it to the factory cleaner
  //tlFactory->DestroyDevice(pDevice);
}

Pylon::String_t CppCamera::GetSerialNumber()
{
  try
  {
    return gigeDevInfo.GetSerialNumber();
  }
  catch(std::exception& e)
  {
    std::stringstream msg;
    msg << "CppCamera GetSerialNumber exception: " << e.what();
    _error(msg.str()); msg.str("");
    return "";
  }
}
