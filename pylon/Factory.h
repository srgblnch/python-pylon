/*---- licence header
###############################################################################
## file :               Factory.h
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

#ifndef FACTORY_H
#define FACTORY_H

#include <pylon/PylonIncludes.h>
#include <pylon/gige/BaslerGigECamera.h>
#include "Logger.h"
#include "DevInfo.h"
#include "Camera.h"


class CppFactory : public Logger
{
public:
  CppFactory();
  ~CppFactory();
  void CreateTl();
  void ReleaseTl();
  int DeviceDiscovery();
  CppDevInfo* getNextDeviceInfo();
  Pylon::CTlFactory* getTlFactory();
  CppCamera* CreateCamera(CppDevInfo* wrapperDevInfo);
private:
  Pylon::CTlFactory *_tlFactory;
  Pylon::ITransportLayer *_tl;
  Pylon::DeviceInfoList_t deviceList;
  Pylon::DeviceInfoList_t::const_iterator deviceListIterator;
};

#endif /* FACTORY_H */
