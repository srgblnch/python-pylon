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
CppDevInfo::CppDevInfo(const Pylon::CInstantCamera::DeviceInfo_t& CppDevInfo)
  :devInfo(CppDevInfo)
{
  //devInfo = CppDevInfo;
  //devInfo.SetDeviceClass(Pylon::CInstantCamera::DeviceClass());
  _name = "CppDevInfo(" + GetSerialNumber() + ")";
}

//CppGigEInfo::CppGigEInfo(const Pylon::CInstantCamera::DeviceInfo_t& CppDevInfo)
//{
//  _name = "CppGigEInfo(" + GetSerialNumber() + ")";
//}

/****
 * Destructor
 */
CppDevInfo::~CppDevInfo() { }


/****
 * General attributes area
 */
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

Pylon::CInstantCamera::DeviceInfo_t CppDevInfo::GetDeviceInfo()
{
  return devInfo;
}


/****
 * GigE attributes area
 */
//Pylon::String_t CppGigEInfo::GetAddress()
//{
//  return devInfo.GetAddress();
//}
//
//Pylon::String_t CppGigEInfo::GetIpAddress()
//{
//  return devInfo.GetIpAddress();
//}
//
//Pylon::String_t CppGigEInfo::GetDefaultGateway()
//{
//  return devInfo.GetDefaultGateway();
//}
//
//Pylon::String_t CppGigEInfo::GetSubnetMask()
//{
//  return devInfo.GetSubnetMask();
//}
//
//Pylon::String_t CppGigEInfo::GetPortNr()
//{
//  return devInfo.GetPortNr();
//}
//
//Pylon::String_t CppGigEInfo::GetMacAddress()
//{
//  return devInfo.GetMacAddress();
//}
//
//Pylon::String_t CppGigEInfo::GetInterface()
//{
//  return devInfo.GetInterface();
//}
//
//Pylon::String_t CppGigEInfo::GetIpConfigOptions()
//{
//  return devInfo.GetIpConfigOptions();
//}
//
//Pylon::String_t CppGigEInfo::GetIpConfigCurrent()
//{
//  return devInfo.GetIpConfigCurrent();
//}
//
//bool CppGigEInfo::IsPersistentIpActive()
//{
//  return devInfo.IsPersistentIpActive();
//}
//
//bool CppGigEInfo::IsDhcpActive()
//{
//  return devInfo.IsDhcpActive();
//}
//
//bool CppGigEInfo::IsAutoIpActive()
//{
//  return devInfo.IsAutoIpActive();
//}
//
//bool CppGigEInfo::IsPersistentIpSupported()
//{
//  return devInfo.IsPersistentIpSupported();
//}
//
//bool CppGigEInfo::IsDhcpSupported()
//{
//  return devInfo.IsDhcpSupported();
//}
//
//bool CppGigEInfo::IsAutoIpSupported()
//{
//  return devInfo.IsAutoIpSupported();
//}

//bool CppGigEInfo::IsSubset(IProperties& Subset)
//{
//  return devInfo.IsSubset(IProperties& Subset)();
//}

