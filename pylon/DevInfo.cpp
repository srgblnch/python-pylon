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
//Superclass constructor
CppDevInfo::CppDevInfo(const Pylon::CInstantCamera::DeviceInfo_t& devInfo)
  :_devInfo(devInfo)
{
  _name = "CppDevInfo(" + GetSerialNumber() + ")";
}

//Subclass constructor for GigE cameras
CppGigEDevInfo::CppGigEDevInfo(const Pylon::CInstantCamera::DeviceInfo_t& \
                               devInfo)
  :CppDevInfo(devInfo),_gige(devInfo)
{
  //call to the superclass constructor without parameters because the _devInfo
  // is different for each superclass and subclass as they are private.
  //_devInfo = devInfo;
  _name = "CppGigEDevInfo(" + GetSerialNumber() + ")";
}

//TODO: subclass constructor for usb cameras and any other type.

/****
 * Destructor
 */
CppDevInfo::~CppDevInfo() { }
CppGigEDevInfo::~CppGigEDevInfo() { }

/****
 *
 */
CppGigEDevInfo* dynamic_cast_CppGigEDevInfo_ptr(CppDevInfo* devInfo)
{
  return dynamic_cast<CppGigEDevInfo*>(devInfo);
}

/****
 * General attributes area
 */
Pylon::String_t CppDevInfo::GetSerialNumber()
{
  Pylon::String_t sn;
  std::stringstream msg;

  sn = _devInfo.GetSerialNumber();
  msg << "GetSerialNumber " << sn;
  _debug(msg.str()); msg.str("");

  return sn;

  //return _devInfo.GetSerialNumber();
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
Pylon::String_t CppGigEDevInfo::GetAddress()
{
  return _gige.GetAddress();
}

Pylon::String_t CppGigEDevInfo::GetIpAddress()
{
  return _gige.GetIpAddress();
}

Pylon::String_t CppGigEDevInfo::GetDefaultGateway()
{
  return _gige.GetDefaultGateway();
}

Pylon::String_t CppGigEDevInfo::GetSubnetMask()
{
  return _gige.GetSubnetMask();
}

Pylon::String_t CppGigEDevInfo::GetPortNr()
{
  return _gige.GetPortNr();
}

Pylon::String_t CppGigEDevInfo::GetMacAddress()
{
  return _gige.GetMacAddress();
}

Pylon::String_t CppGigEDevInfo::GetInterface()
{
  return _gige.GetInterface();
}

Pylon::String_t CppGigEDevInfo::GetIpConfigOptions()
{
  return _gige.GetIpConfigOptions();
}

Pylon::String_t CppGigEDevInfo::GetIpConfigCurrent()
{
  return _gige.GetIpConfigCurrent();
}

bool CppGigEDevInfo::IsPersistentIpActive()
{
  return _gige.IsPersistentIpActive();
}

bool CppGigEDevInfo::IsDhcpActive()
{
  return _gige.IsDhcpActive();
}

bool CppGigEDevInfo::IsAutoIpActive()
{
  return _gige.IsAutoIpActive();
}

bool CppGigEDevInfo::IsPersistentIpSupported()
{
  return _gige.IsPersistentIpSupported();
}

bool CppGigEDevInfo::IsDhcpSupported()
{
  return _gige.IsDhcpSupported();
}

bool CppGigEDevInfo::IsAutoIpSupported()
{
  return _gige.IsAutoIpSupported();
}

//bool CppGigEDevInfo::IsSubset(IProperties& Subset)
//{
//  return _gige.IsSubset(IProperties& Subset)();
//}

