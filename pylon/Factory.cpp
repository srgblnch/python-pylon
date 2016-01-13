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

#include "Factory.h"

CppFactory::CppFactory()
{
  Pylon::PylonAutoInitTerm autoInitTerm;
  Pylon::PylonInitialize();
  _name = "CppFactory()";
}

CppFactory::~CppFactory()
{
  //ReleaseTl();
  Pylon::PylonTerminate();
}

void CppFactory::CreateTl()
{
  _tlFactory = &Pylon::CTlFactory::GetInstance();
}

void CppFactory::ReleaseTl()
{
}

int CppFactory::DeviceDiscovery()
{
  std::stringstream msg;
  int nCameras = 0;

  if ( _tlFactory != NULL )
  {
    nCameras = _tlFactory->EnumerateDevices( deviceList );
    deviceListIterator = deviceList.begin();
    msg << "Found " << nCameras << " cameras";
    _debug(msg.str());
    return nCameras;
  }
  else
  {
    _error("No transport factory created");
    return nCameras;
  }
}

CppDevInfo* CppFactory::getNextDeviceInfo()
{
  std::stringstream msg;

  if ( deviceListIterator != deviceList.end() )
  {
    const Pylon::CInstantCamera::DeviceInfo_t& pylonDeviceInfo = \
      static_cast<const Pylon::CInstantCamera::DeviceInfo_t&>\
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

CppCamera* CppFactory::CreateCamera(CppDevInfo* wrapperDevInfo)
{
  std::stringstream msg;
  Pylon::CInstantCamera::DeviceInfo_t devInfo;
  Pylon::IPylonDevice *pDevice = NULL;
  Pylon::CInstantCamera *bCamera = NULL;

  devInfo = wrapperDevInfo->GetDeviceInfo();
  msg << "Creating a Camera object from the information of the camera with "\
      "the serial number " << devInfo.GetSerialNumber();
  _debug(msg.str()); msg.str("");
  try
  {
    _debug("Creating IPylonDevice object");
    pDevice = _tlFactory->CreateDevice(devInfo);
    _debug("Creating CInstantCamera object");
    bCamera = new Pylon::CInstantCamera(pDevice);
  }
  catch(std::exception& e)
  {
    msg << "CppCamera Constructor exception: " << e.what();
    _error(msg.str()); msg.str("");
    return NULL;
  }
  return new CppCamera(devInfo,pDevice,bCamera);
}
