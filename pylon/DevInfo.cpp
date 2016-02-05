/*---- licence header
###############################################################################
## file :               Factory.cpp
##
## description :        This file has been made to provide a python access to
##                      the Pylon SDK from python.
##
## project :            python-pylon
##
## author(s) :          S.Blanch-Torn\'e
##
## Copyright (C) :      2015
##                      CELLS / ALBA Synchrotron,
##                      08290 Bellaterra,
##                      Spain
##
## This file is part of python-pylon.
##
## python-pylon is free software: you can redistribute it and/or modify
## it under the terms of the GNU Lesser General Public License as published by
## the Free Software Foundation, either version 3 of the License, or
## (at your option) any later version.
##
## python-pylon is distributed in the hope that it will be useful,
## but WITHOUT ANY WARRANTY; without even the implied warranty of
## MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
## GNU Lesser General Public License for more details.
##
## You should have received a copy of the GNU Lesser General Public License
## along with python-pylon.  If not, see <http://www.gnu.org/licenses/>.
##
###############################################################################
*/

#include "DevInfo.h"

/****
 * Constructors
 */
CppDevInfo::CppDevInfo(const Pylon::CInstantCamera::DeviceInfo_t& devInfo)
  :_devInfo(devInfo)
{
  //devInfo = CppDevInfo;
  //devInfo.SetDeviceClass(Pylon::CInstantCamera::DeviceClass());
  _name = "CppDevInfo(" + GetSerialNumber() + ")";
}

CppGigEInfo::CppGigEInfo(const Pylon::CInstantCamera::DeviceInfo_t& devInfo)
  :CppDevInfo(devInfo)
{
  _name = "CppGigEInfo(" + GetSerialNumber() + ")";
}

/****
 * Destructor
 */
CppDevInfo::~CppDevInfo() { }


/****
 * General attributes area
 */
Pylon::String_t CppDevInfo::GetSerialNumber()
{
  return _devInfo.GetSerialNumber();
}

Pylon::String_t CppDevInfo::GetModelName()
{
  return _devInfo.GetModelName();
}

Pylon::String_t CppDevInfo::GetUserDefinedName()
{
  return _devInfo.GetUserDefinedName();
}

Pylon::String_t CppDevInfo::GetDeviceVersion()
{
  return _devInfo.GetDeviceVersion();
}

Pylon::String_t CppDevInfo::GetDeviceFactory()
{
  return _devInfo.GetDeviceFactory();
}

Pylon::CInstantCamera::DeviceInfo_t CppDevInfo::GetDeviceInfo()
{
  return _devInfo;
}


/****
 * GigE attributes area
 */
Pylon::String_t CppGigEInfo::GetAddress()
{
  return _devInfo.GetAddress();
}

Pylon::String_t CppGigEInfo::GetIpAddress()
{
  return _devInfo.GetIpAddress();
}

Pylon::String_t CppGigEInfo::GetDefaultGateway()
{
  return _devInfo.GetDefaultGateway();
}

Pylon::String_t CppGigEInfo::GetSubnetMask()
{
  return _devInfo.GetSubnetMask();
}

Pylon::String_t CppGigEInfo::GetPortNr()
{
  return _devInfo.GetPortNr();
}

Pylon::String_t CppGigEInfo::GetMacAddress()
{
  return _devInfo.GetMacAddress();
}

Pylon::String_t CppGigEInfo::GetInterface()
{
  return _devInfo.GetInterface();
}

Pylon::String_t CppGigEInfo::GetIpConfigOptions()
{
  return _devInfo.GetIpConfigOptions();
}

Pylon::String_t CppGigEInfo::GetIpConfigCurrent()
{
  return _devInfo.GetIpConfigCurrent();
}

bool CppGigEInfo::IsPersistentIpActive()
{
  return _devInfo.IsPersistentIpActive();
}

bool CppGigEInfo::IsDhcpActive()
{
  return _devInfo.IsDhcpActive();
}

bool CppGigEInfo::IsAutoIpActive()
{
  return _devInfo.IsAutoIpActive();
}

bool CppGigEInfo::IsPersistentIpSupported()
{
  return _devInfo.IsPersistentIpSupported();
}

bool CppGigEInfo::IsDhcpSupported()
{
  return _devInfo.IsDhcpSupported();
}

bool CppGigEInfo::IsAutoIpSupported()
{
  return _devInfo.IsAutoIpSupported();
}

//bool CppGigEInfo::IsSubset(IProperties& Subset)
//{
//  return devInfo.IsSubset(IProperties& Subset)();
//}

