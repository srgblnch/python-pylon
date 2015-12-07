/*---- licence header
###############################################################################
## file :               ConstructorTest.cpp
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

#include <iostream>
#include <exception>
#include <pylon/PylonIncludes.h>
#include <pylon/gige/BaslerGigECamera.h>

/****************
 * This is a test made to understand the issue creating the CBaslerGigECamera
 * object that gives us the exception:
 * > The attached Pylon Device is not of type IPylonGigEDevice!
 * > (/opt/pylon/include/pylon/gige/PylonGigEDeviceProxy.h:169)
 */

using namespace Pylon;

inline bool _cppBuildUsingSimplePointer(CTlFactory* _TlFactory,
                 CDeviceInfo devInfo, IPylonDevice *pCamera,
                 CBaslerGigECamera *mCamera)
{
  try
  {
    std::cout << "Create device for " << devInfo.GetSerialNumber()
        << std::endl;
    pCamera = _TlFactory->CreateDevice(devInfo);
    std::cout << "Create camera" << std::endl;
    mCamera = new CBaslerGigECamera();
    std::cout << "Attach device to camera" << std::endl;
    mCamera->Attach(pCamera,true);
    return true;
  }
  catch(std::exception& e)
  {
    std::cout << "Exception: " << e.what() << std::endl;
    return false;
  }
}

inline bool _cppBuildUsingTwicePointer(CTlFactory* _TlFactory,
                 CDeviceInfo devInfo, IPylonDevice **pCamera,
                 CBaslerGigECamera **mCamera)
{
  try
  {
    std::cout << "Create device for " << devInfo.GetSerialNumber()
        << std::endl;
    *pCamera = _TlFactory->CreateDevice(devInfo);
    std::cout << "Create camera" << std::endl;
    *mCamera = new CBaslerGigECamera();
    std::cout << "Attach device to camera" << std::endl;
    (*mCamera)->Attach(*pCamera,true);
    return true;
  }
  catch(std::exception& e)
  {
    std::cout << "Exception: " << e.what() << std::endl;
    return false;
  }
}

int main(int argc, char* argv[])
{
  // The exit code of the sample application
  int exitCode = 0;

  // Automagically call PylonInitialize and PylonTerminate to ensure the pylon runtime system
  // is initialized during the lifetime of this object.
  Pylon::PylonAutoInitTerm autoInitTerm;

  CTlFactory *_TlFactory = NULL;
  ITransportLayer* tl_;
  Pylon::DeviceInfoList_t devices;
  int nCameras = 0;
  Pylon::DeviceInfoList_t::const_iterator it;
  CDeviceInfo devInfo;
  IPylonDevice *pCamera = NULL;
  CBaslerGigECamera *mCamera = NULL;
  Pylon::String_t pylon_camera_ip(argv[1]);

  std::cout << "Get factory instance" << std::endl;
  _TlFactory = &CTlFactory::GetInstance();
  tl_ = _TlFactory->CreateTl( CBaslerGigECamera::DeviceClass() );

  nCameras = tl_->EnumerateDevices( devices );
  std::cout << "Found " << nCameras << " cameras" << std::endl;
  if (nCameras == 0)
  {
    exitCode = -1;
    goto exit;
  }
  std::cout << "iterate searching " << pylon_camera_ip << " camera"
      << std::endl;
  for (it = devices.begin(); it != devices.end(); it++)
  {
    const CBaslerGigECamera::DeviceInfo_t& gige_device_info = \
        static_cast<const CBaslerGigECamera::DeviceInfo_t&>(*it);
    Pylon::String_t current_ip = gige_device_info.GetIpAddress();
    std::cout << "\tFound a " << gige_device_info.GetModelName()
        << " with ip " << current_ip << std::endl;
    if (current_ip == pylon_camera_ip)
    {
      std::cout << "\t\tThis is the camera wanted (" << current_ip << ")"
          << std::endl;
      devInfo = gige_device_info;
      break;
    }
  }
  if (it == devices.end())
  {
    std::cout << "\tCamera not found" << std::endl;
    exitCode = -2;
    goto exit;
  }
  std::cout << "Set device class: " << CBaslerGigECamera::DeviceClass()
  << std::endl;
  devInfo.SetDeviceClass(CBaslerGigECamera::DeviceClass());

  if (not _cppBuildUsingSimplePointer(_TlFactory, devInfo, pCamera, mCamera))
  {
    std::cout << "Simple pointer didn't work, try with twice indirection!"
        << std::endl;
    if (not _cppBuildUsingTwicePointer(_TlFactory, devInfo, &pCamera, &mCamera))
    {
      std::cout << "Pointer twice indirection did work" << std::endl;
      exitCode = -3;
      goto exit;
    }
    std::cout << "Continue with twice indirection!" << std::endl;
  }
  // Open PylonDevice
  std::cout << "Open device" << std::endl;
  pCamera->Open();

  //CBaslerGigECamera should be opened now...
  if (mCamera->IsOpen())
  {
    std::cout << "Close camera" << std::endl;
    mCamera->Close();
    delete(mCamera);
  }
exit:
  std::cout << "exit(" << exitCode << ")" << std::endl;
  _TlFactory->ReleaseTl(tl_);
  return exitCode;
}
