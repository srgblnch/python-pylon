/*---- licence header
###############################################################################
## file :               CBuilders.h
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

#include "pylon/PylonIncludes.h"
#include "pylon/gige/PylonGigEDevice.h"
#include "pylon/gige/BaslerGigECamera.h"

using namespace Pylon;

/****************************************************************
 * Transport layer
 ****************************************************************/

void _cppBuildTransportLayer(CTlFactory *factory,
		ITransportLayer *_tlptr)
{
	_tlptr = factory->CreateTl(CBaslerGigECamera::DeviceClass());
}

///****************************************************************
// * Device Info
// ****************************************************************/
//
// int _cppEnumerateDevices(CTlFactory *factory,
//		DeviceInfoList devicesList)
//{
//	int nb_camera_found = 0;
//	nb_camera_found = factory->EnumerateDevices(devicesList,false);
//	return nb_camera_found;
//}

/****************************************************************
 * PylonDevice and BaslerCamera build
 ****************************************************************/

void _cppBuildPylonDevice(CTlFactory *factory,
		CBaslerGigEDeviceInfo devInfo, IPylonGigEDevice *pGigECamera)
{
	IPylonDevice *pCamera = factory->CreateDevice(devInfo);
	pGigECamera = dynamic_cast<IPylonGigEDevice*>(pCamera);
}

void _cppBuildBaslerCamera(IPylonGigEDevice *pCamera,
		CBaslerGigECamera *mCamera)
{
	mCamera = new CBaslerGigECamera();
	mCamera->Attach(pCamera,true);
}

void _cppAlternativeBuildBaslerCamera(CTlFactory *factory,
		CBaslerGigEDeviceInfo devInfo, CBaslerGigECamera *mCamera)
{
	IPylonDevice *pCamera(factory->CreateDevice((devInfo)));
	mCamera = new CBaslerGigECamera();
	mCamera->Attach(pCamera,true);
}

