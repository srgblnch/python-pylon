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

#include "Factory.h"

CppFactory::CppFactory()
{
  Pylon::PylonAutoInitTerm autoInitTerm;
  //Pylon::PylonInitialize();
  _name = "CppFactory()";
}

CppFactory::~CppFactory()
{
  //ReleaseTl();
  //Pylon::PylonTerminate();
}

void CppFactory::CreateTl()
{
  _tlFactory = &Pylon::CTlFactory::GetInstance();
  _tl = _tlFactory->CreateTl( Pylon::CBaslerGigECamera::DeviceClass() );
}

void CppFactory::ReleaseTl()
{
  if (_tl != NULL)
  {
    _tlFactory->ReleaseTl(_tl);
  }
}

int CppFactory::DeviceDiscovery()
{
  std::stringstream msg;
  int nCameras = 0;

  if ( _tl != NULL )
  {
    nCameras = _tl->EnumerateDevices( deviceList );
    deviceListIterator = deviceList.begin();
    msg << "Found " << nCameras << " within the transport layer "
        << Pylon::CBaslerGigECamera::DeviceClass();
    _debug(msg.str());
    return nCameras;
  }
  else
  {
    _error("No transport layer created");
    return nCameras;
  }
}

CppDevInfo* CppFactory::getNextDeviceInfo()
{
  std::stringstream msg;

  if ( deviceListIterator != deviceList.end() )
  {
    const Pylon::CBaslerGigECamera::DeviceInfo_t& pylonDeviceInfo = \
      static_cast<const Pylon::CBaslerGigECamera::DeviceInfo_t&>\
        (*deviceListIterator);
    CppDevInfo* wrapperDevInfo = new CppDevInfo(pylonDeviceInfo);
    msg << "Found a " << pylonDeviceInfo.GetModelName()
        << " Camera, with serial number " << pylonDeviceInfo.GetSerialNumber();
    _debug(msg.str());
    deviceListIterator++;
    return wrapperDevInfo;
  }
  return NULL;
}

Pylon::CTlFactory* CppFactory::getTlFactory()
{
  return _tlFactory;
}

//CppCamera* CppFactory::CreateCamera(CppDevInfo* wrapperDevInfo)
//{
//  Pylon::DeviceInfoList_t::const_iterator it;
//  Pylon::CBaslerGigECamera::DeviceInfo_t gigeDevInfo;
//  Pylon::String_t wantedSerial;
//
//  gigeDevInfo = wrapperDevInfo->GetDeviceInfo();
//  wantedSerial = gigeDevInfo.GetSerialNumber();
//
//  for (it = deviceList.begin(); it != deviceList.end(); it++)
//  {
//    const Pylon::CBaslerGigECamera::DeviceInfo_t& IteratorInfo = static_cast<const Pylon::CBaslerGigECamera::DeviceInfo_t&>(*it);
//    Pylon::String_t iteratorSerial = IteratorInfo.GetSerialNumber();
//    if (iteratorSerial == wantedSerial)
//    {
//      gigeDevInfo = IteratorInfo;
//      break;
//    }
//  }
//  if (it != deviceList.end())
//  {
//    Pylon::IPylonDevice *pDevice = NULL;
//    Pylon::CBaslerGigECamera *bCamera = NULL;
//    try
//    {
//      _debug("Creating CBaslerGigECamera object");
//      bCamera = new Pylon::CBaslerGigECamera(_tlFactory->CreateDevice(gigeDevInfo));
//      _debug("Getting the IPylonDevice object");
//      pDevice = bCamera->GetDevice();
//    }
//    catch(std::exception& e)
//    {
//      std::stringstream msg;
//      msg << "CppCamera Constructor exception: " << e.what();
//      _error(msg.str()); msg.str("");
//    }
//    return new CppCamera(gigeDevInfo,pDevice,bCamera);
//  }
//  return NULL;
//}

CppCamera* CppFactory::CreateCamera(CppDevInfo* wrapperDevInfo)
{
  std::stringstream msg;
  Pylon::CBaslerGigECamera::DeviceInfo_t gigeDevInfo;
  Pylon::IPylonDevice **pDevice = NULL;
  Pylon::CBaslerGigECamera **bCamera = NULL;

  gigeDevInfo = wrapperDevInfo->GetDeviceInfo();
  msg << "Creating a Camera object from the information of the camera with "\
      "the serial number " << gigeDevInfo.GetSerialNumber();
  _debug(msg.str()); msg.str("");
  try
  {
    _debug("Creating CBaslerGigECamera object");
    *bCamera = new Pylon::CBaslerGigECamera(_tlFactory->CreateDevice(gigeDevInfo));
    _debug("Getting the IPylonDevice object");
    *pDevice = (*bCamera)->GetDevice();
  }
  catch(std::exception& e)
  {
    msg << "CppCamera Constructor exception: " << e.what();
    _error(msg.str()); msg.str("");
    return NULL;
  }
  return new CppCamera(gigeDevInfo,*pDevice,*bCamera);
}
