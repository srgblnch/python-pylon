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

CppCamera::CppCamera(CppDevInfo *devInfo)
{
  /*FIXME: some work on this constructor because the device information maybe
   * incomplete or the IPylonDevice, because the dynamic_cast returns NULL
   */
  pDevice = Pylon::CTlFactory::GetInstance().CreateDevice(devInfo->_GetDevInfo());
  if ( ! pDevice )
  {
    throw LOGICAL_ERROR_EXCEPTION("NULL pointer on CreateDevice IPylonDevice!");
  }
//  Pylon::IPylonGigEDevice* pGigEDevice = dynamic_cast<Pylon::IPylonGigEDevice*>(pDevice);
//  if ( ! pGigEDevice )
//  {
//    throw LOGICAL_ERROR_EXCEPTION("NULL pointer on dynamic_cast to IPylonGigEDevice!");
//  }
  mCamera = new Pylon::CBaslerGigECamera(pDevice,true);
//  mCamera->Attach(pDevice,true);
}

CppCamera::~CppCamera()
{
  Pylon::CTlFactory::GetInstance().DestroyDevice(pDevice);
}

