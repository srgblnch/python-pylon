/*---- licence header
###############################################################################
## file :               DevInfo.h
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

#ifndef DEVINFO_H
#define DEVINFO_H

#include <pylon/PylonIncludes.h>
#include <pylon/gige/BaslerGigECamera.h>
#include "logger.h"

class CppDevInfo : public Logger
{
public:
  CppDevInfo(const Pylon::CBaslerGigECamera::DeviceInfo_t&);
  ~CppDevInfo();
  Pylon::String_t GetSerialNumber();
  Pylon::String_t GetModelName();
  Pylon::String_t GetUserDefinedName();
  Pylon::String_t GetDeviceVersion();
  Pylon::String_t GetDeviceFactory();
  Pylon::String_t GetAddress();
  Pylon::String_t GetIpAddress();
  Pylon::String_t GetDefaultGateway();
  Pylon::String_t GetSubnetMask();
  Pylon::String_t GetPortNr();
  Pylon::String_t GetMacAddress();
  Pylon::String_t GetInterface();
  Pylon::String_t GetIpConfigOptions();
  Pylon::String_t GetIpConfigCurrent();
  bool IsPersistentIpActive();
  bool IsDhcpActive();
  bool IsAutoIpActive();
  bool IsPersistentIpSupported();
  bool IsDhcpSupported();
  bool IsAutoIpSupported();
//  bool IsSubset(IProperties& Subset);
  Pylon::CBaslerGigECamera::DeviceInfo_t _GetDevInfo();
private:
  Pylon::CBaslerGigECamera::DeviceInfo_t devInfo;
};

#endif /* DEVINFO_H */
