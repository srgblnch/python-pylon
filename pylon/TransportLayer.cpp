/*---- licence header
###############################################################################
## file :               TransportLayer.cpp
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

#include "TransportLayer.h"

/****
 * Constructor
 */
CppTransportLayer::CppTransportLayer(Pylon::CTlInfo info):
                                     info(info)
{
  std::stringstream msg;
  Pylon::CTlFactory *_tlFactory;

  _name = "CppTransportLayer("+ info.GetDeviceClass() + ")";
  _tlFactory = &Pylon::CTlFactory::GetInstance();
  msg << "Create TL " << info.GetDeviceClass();
  _debug(msg.str()); msg.str("");
  tl = _tlFactory->CreateTl(info);
  _debug("Constructor done");
}

/****
 * Destructor
 */
CppTransportLayer::~CppTransportLayer()
{
  std::stringstream msg;
  Pylon::CTlFactory *_tlFactory;

  _tlFactory = &Pylon::CTlFactory::GetInstance();
  _tlFactory->ReleaseTl(tl);
}

/****
 * Propagate transport layer class information
 */
Pylon::String_t CppTransportLayer::getTlClass()
{
  return info.GetDeviceClass();
}

/****
 * get of refresh the device info list for the transport layer this object has
 */
int CppTransportLayer::EnumerateDevices()
{
  std::stringstream msg;
  int nCameras = 0;
  _debug("In CppTransportLayer::EnumerateDevices()");
  nCameras = tl->EnumerateDevices(_deviceList,false);
  msg << "TL " << info.GetDeviceClass() << " has " << nCameras;
  _debug(msg.str()); msg.str("");
  _deviceIterator = _deviceList.begin();
  return nCameras;
}

/****
 * Interface to start iterating the device info list
 */
Pylon::DeviceInfoList_t::iterator CppTransportLayer::getFirst()
{
  return _deviceList.begin();
}

/****
 * Used to know when a loop has reached the end of the device info list.
 */
Pylon::DeviceInfoList_t::iterator CppTransportLayer::getLast()
{
  return _deviceList.end();
}


