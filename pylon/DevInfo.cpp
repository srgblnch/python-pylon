/*---- licence header
###############################################################################
## file :               Factory.cpp
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

#include "DevInfo.h"

DeviceInformation::DeviceInformation(const Camera_t::DeviceInfo_t& deviceInformation)
  :devInfo(deviceInformation)
{
  //devInfo = deviceInformation;
}

DeviceInformation::~DeviceInformation() { }

Pylon::String_t DeviceInformation::GetSerialNumber()
{
  return devInfo.GetSerialNumber();
}

Pylon::String_t DeviceInformation::GetModelName()
{
  return devInfo.GetModelName();
}

Pylon::String_t DeviceInformation::GetUserDefinedName()
{
  return devInfo.GetUserDefinedName();
}

Pylon::String_t DeviceInformation::GetDeviceVersion()
{
  return devInfo.GetDeviceVersion();
}

Pylon::String_t DeviceInformation::GetDeviceFactory()
{
  return devInfo.GetDeviceFactory();
}

Pylon::String_t DeviceInformation::GetAddress()
{
  return devInfo.GetAddress();
}

Pylon::String_t DeviceInformation::GetIpAddress()
{
  return devInfo.GetIpAddress();
}

Pylon::String_t DeviceInformation::GetDefaultGateway()
{
  return devInfo.GetDefaultGateway();
}

Pylon::String_t DeviceInformation::GetSubnetMask()
{
  return devInfo.GetSubnetMask();
}

Pylon::String_t DeviceInformation::GetPortNr()
{
  return devInfo.GetPortNr();
}

Pylon::String_t DeviceInformation::GetMacAddress()
{
  return devInfo.GetMacAddress();
}

Pylon::String_t DeviceInformation::GetInterface()
{
  return devInfo.GetInterface();
}

Pylon::String_t DeviceInformation::GetIpConfigOptions()
{
  return devInfo.GetIpConfigOptions();
}

Pylon::String_t DeviceInformation::GetIpConfigCurrent()
{
  return devInfo.GetIpConfigCurrent();
}

bool DeviceInformation::IsPersistentIpActive()
{
  return devInfo.IsPersistentIpActive();
}

bool DeviceInformation::IsDhcpActive()
{
  return devInfo.IsDhcpActive();
}

bool DeviceInformation::IsAutoIpActive()
{
  return devInfo.IsAutoIpActive();
}

bool DeviceInformation::IsPersistentIpSupported()
{
  return devInfo.IsPersistentIpSupported();
}

bool DeviceInformation::IsDhcpSupported()
{
  return devInfo.IsDhcpSupported();
}

bool DeviceInformation::IsAutoIpSupported()
{
  return devInfo.IsAutoIpSupported();
}

//bool DeviceInformation::IsSubset(IProperties& Subset)
//{
//  return devInfo.IsSubset(IProperties& Subset)();
//}
