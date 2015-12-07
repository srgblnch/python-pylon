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

//CppCamera::CppCamera(CppDevInfo *devInfo)
//{
//  /*FIXME: some work on this constructor because the device information maybe
//   * incomplete or the IPylonDevice, because the dynamic_cast returns NULL
//   */
//  pDevice = Pylon::CTlFactory::GetInstance().CreateDevice(devInfo->_GetDevInfo());
//  if ( ! pDevice )
//  {
//    throw LOGICAL_ERROR_EXCEPTION("NULL pointer on CreateDevice IPylonDevice!");
//  }
////  Pylon::IPylonGigEDevice* pGigEDevice = dynamic_cast<Pylon::IPylonGigEDevice*>(pDevice);
////  if ( ! pGigEDevice )
////  {
////    throw LOGICAL_ERROR_EXCEPTION("NULL pointer on dynamic_cast to IPylonGigEDevice!");
////  }
//  mCamera = new Pylon::CBaslerGigECamera(pDevice,true);
////  mCamera->Attach(pDevice,true);
//}
/***
 *  Alternative constructor to do the search from scratch to know if there was
 *  some structure in the middle that breaks the subclass objects.
 ***/
CppCamera::CppCamera(CppDevInfo *devInfo)
{
  Pylon::DeviceInfoList_t deviceList;
  Pylon::DeviceInfoList_t::const_iterator it;
  Pylon::ITransportLayer *_tl;
#if __cplusplus > 199711L
  std::string msg(nullptr);
#else
  std::string msg("");
#endif

  //get some information to be use to repeat the search
  Pylon::String_t ipaddress = devInfo->GetIpAddress();
  msg = "requested ipaddress " + ipaddress;
  _debug(msg);

  //build a newer transport layer object to enumerate devices
  _tl = Pylon::CTlFactory::GetInstance().CreateTl( \
       Pylon::CBaslerGigECamera::DeviceClass() );
  _tl->EnumerateDevices( deviceList );

  for (it = deviceList.begin(); it != deviceList.end(); it++)
  {
    const Pylon::CBaslerGigECamera::DeviceInfo_t& gige_device_info = \
      static_cast<const Pylon::CBaslerGigECamera::DeviceInfo_t&>(*it);
    Pylon::String_t current_ip = gige_device_info.GetIpAddress();
    msg = "check if " + current_ip + " is the wanted one";
    _debug(msg);
    if (current_ip == ipaddress)
    {
      msg = "found " + ipaddress + " == " + current_ip;
      _debug(msg);
      break;
    }
  }
  if (it == deviceList.end())
  {
    throw LOGICAL_ERROR_EXCEPTION("Camera not found!");
  }
  pDevice = _tl->CreateDevice(*it);
  _debug("build the IPylonDevice");
  mCamera = new Pylon::CBaslerGigECamera(pDevice,true);
  _debug("build the CBaslerGigECamera");

  //clean the temporal transport layer
  Pylon::CTlFactory::GetInstance().ReleaseTl(_tl);
}

CppCamera::~CppCamera()
{
  Pylon::CTlFactory::GetInstance().DestroyDevice(pDevice);
}
