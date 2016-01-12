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

CppDevInfo::CppDevInfo(const Pylon::CBaslerGigECamera::DeviceInfo_t& CppDevInfo)
  :devInfo(CppDevInfo)
{
  //devInfo = CppDevInfo;
  //devInfo.SetDeviceClass(Pylon::CBaslerGigECamera::DeviceClass());
  _name = "CppDevInfo(" + GetSerialNumber() + ")";
}

CppDevInfo::~CppDevInfo() { }

Pylon::String_t CppDevInfo::GetSerialNumber()
{
  return devInfo.GetSerialNumber();
}

Pylon::String_t CppDevInfo::GetModelName()
{
  return devInfo.GetModelName();
}

Pylon::String_t CppDevInfo::GetUserDefinedName()
{
  return devInfo.GetUserDefinedName();
}

Pylon::String_t CppDevInfo::GetDeviceVersion()
{
  return devInfo.GetDeviceVersion();
}

Pylon::String_t CppDevInfo::GetDeviceFactory()
{
  return devInfo.GetDeviceFactory();
}

Pylon::String_t CppDevInfo::GetAddress()
{
  return devInfo.GetAddress();
}

Pylon::String_t CppDevInfo::GetIpAddress()
{
  return devInfo.GetIpAddress();
}

Pylon::String_t CppDevInfo::GetDefaultGateway()
{
  return devInfo.GetDefaultGateway();
}

Pylon::String_t CppDevInfo::GetSubnetMask()
{
  return devInfo.GetSubnetMask();
}

Pylon::String_t CppDevInfo::GetPortNr()
{
  return devInfo.GetPortNr();
}

Pylon::String_t CppDevInfo::GetMacAddress()
{
  return devInfo.GetMacAddress();
}

Pylon::String_t CppDevInfo::GetInterface()
{
  return devInfo.GetInterface();
}

Pylon::String_t CppDevInfo::GetIpConfigOptions()
{
  return devInfo.GetIpConfigOptions();
}

Pylon::String_t CppDevInfo::GetIpConfigCurrent()
{
  return devInfo.GetIpConfigCurrent();
}

bool CppDevInfo::IsPersistentIpActive()
{
  return devInfo.IsPersistentIpActive();
}

bool CppDevInfo::IsDhcpActive()
{
  return devInfo.IsDhcpActive();
}

bool CppDevInfo::IsAutoIpActive()
{
  return devInfo.IsAutoIpActive();
}

bool CppDevInfo::IsPersistentIpSupported()
{
  return devInfo.IsPersistentIpSupported();
}

bool CppDevInfo::IsDhcpSupported()
{
  return devInfo.IsDhcpSupported();
}

bool CppDevInfo::IsAutoIpSupported()
{
  return devInfo.IsAutoIpSupported();
}

//bool CppDevInfo::IsSubset(IProperties& Subset)
//{
//  return devInfo.IsSubset(IProperties& Subset)();
//}

Pylon::CBaslerGigECamera::DeviceInfo_t CppDevInfo::GetDeviceInfo()
{
  return devInfo;
}
