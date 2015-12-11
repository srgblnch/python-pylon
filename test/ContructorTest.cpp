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
    try
    {
      std::cout << "Create camera" << std::endl;
      mCamera = new CBaslerGigECamera(_TlFactory->CreateDevice(devInfo));
    }
    catch(std::exception& e)
    {
      std::cout << "\tConstructor attachment didn't work:\n\t\t"<< e.what() <<  std::endl;
      mCamera = new CBaslerGigECamera();
      std::cout << "\tAttach device to camera" << std::endl;
      mCamera->Attach(_TlFactory->CreateDevice(devInfo),true);
    }
    return true;
  }
  catch(std::exception& e)
  {
    std::cout << "\t\t** Exception:\n\t\t" << e.what() << std::endl;
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
    try
    {
      std::cout << "Create camera" << std::endl;
      *mCamera = new CBaslerGigECamera(_TlFactory->CreateDevice(devInfo));
    }
    catch(std::exception& e)
    {
      std::cout << "\tConstructor attachment didn't work:\n\t\t" << e.what() << std::endl;
      *mCamera = new CBaslerGigECamera();
      std::cout << "\tAttach device to camera" << std::endl;
      (*mCamera)->Attach(_TlFactory->CreateDevice(devInfo),true);
    }
    return true;
  }
  catch(std::exception& e)
  {
    std::cout << "\t\t** Exception:\n\t\t" << e.what() << std::endl;
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
  int nTransportLayers;
  TlInfoList_t transportLayers;
  TlInfoList::const_iterator tl_it;
  ITransportLayer* tl_;
  Pylon::DeviceInfoList_t devices;
  int nCameras = 0;
  Pylon::DeviceInfoList_t::const_iterator it;
  //CDeviceInfo devInfo;
  CBaslerGigECamera::DeviceInfo_t devInfo;
  IPylonDevice *pCamera = NULL;
  CBaslerGigECamera *mCamera = NULL;
  Pylon::String_t pylon_camera_ip(argv[1]);

  std::cout << std::endl << "Get factory instance" << std::endl;
  _TlFactory = &CTlFactory::GetInstance();
  nTransportLayers = _TlFactory->EnumerateTls(transportLayers);
  std::cout << "Available "<< nTransportLayers <<" transport layers" << std::endl;
  for (tl_it = transportLayers.begin(); tl_it != transportLayers.end(); tl_it++)
  {
    const Pylon::CTlInfo& tl_info = \
              static_cast<const Pylon::CTlInfo&>(*tl_it);
    std::cout << "\t" << tl_info.GetFullName() << std::endl;
  }

  std::cout << std::endl << "Create a transport layer to access " << CBaslerGigECamera::DeviceClass() << " cameras" << std::endl;
  tl_ = _TlFactory->CreateTl( CBaslerGigECamera::DeviceClass() );

  nCameras = tl_->EnumerateDevices( devices );
  std::cout << "Found " << nCameras << " cameras" << std::endl;
  if (nCameras == 0)
  {
    exitCode = -1;
    goto exit;
  }
  std::cout << "\titerate searching " << pylon_camera_ip << " camera"
      << std::endl;
  for (it = devices.begin(); it != devices.end(); it++)
  {
    const CBaslerGigECamera::DeviceInfo_t& gige_device_info = \
        static_cast<const CBaslerGigECamera::DeviceInfo_t&>(*it);
    Pylon::String_t current_ip = gige_device_info.GetIpAddress();
    std::cout << "\t\tFound a " << gige_device_info.GetModelName()
        << " with ip " << current_ip << std::endl;
    if (current_ip == pylon_camera_ip)
    {
      std::cout << "\t\t\tThis is the camera wanted (" << current_ip << ")"
          << std::endl;
      devInfo = gige_device_info;
      break;
    }
  }
  if (it == devices.end())
  {
    std::cout << "\t\tCamera not found" << std::endl;
    exitCode = -2;
    goto exit;
  }
  std::cout << std::endl << "Given camera information:" << std::endl;
  std::cout << "\tdevInfo.GetFullName(): \"" << devInfo.GetFullName() << "\""<< std::endl;
  std::cout << "\tdevInfo.GetModelName(): \"" << devInfo.GetModelName() << "\""<< std::endl;
  std::cout << "\tdevInfo.GetDeviceClass(): \"" << devInfo.GetDeviceClass() << "\""<< std::endl;
  std::cout << "\tdevInfo.GetDeviceVersion(): \"" << devInfo.GetDeviceVersion() << "\""<< std::endl;
  std::cout << "\tdevInfo.GetDeviceFactory(): \"" << devInfo.GetDeviceFactory() << "\""<< std::endl;
  std::cout << "\tdevInfo.GetInterface(): \"" << devInfo.GetInterface() << "\""<< std::endl;

//  std::cout << "\tSet device class: " << CBaslerGigECamera::DeviceClass()
//  << std::endl;
//  devInfo.SetDeviceClass(CBaslerGigECamera::DeviceClass());

  std::cout << std::endl << "Connect to the Camera for further control" << std::endl;
  if (not _cppBuildUsingSimplePointer(_TlFactory, devInfo, pCamera, mCamera))
  {
    std::cout << "Simple pointer didn't work, try with twice indirection!"
        << std::endl;
  }
  if (pCamera != NULL)
  {
    std::cout << "Clean the IPylonDevice to contrinue with the test." << std::endl;
    _TlFactory->DestroyDevice(pCamera);
  }
  std::cout << std::endl;
  std::cout << "Continue with twice indirection!" << std::endl;
  if (not _cppBuildUsingTwicePointer(_TlFactory, devInfo, &pCamera, &mCamera))
  {
    std::cout << "Pointer twice indirection didn't work!" << std::endl;
  }
  if (pCamera == NULL)
  {
    exitCode = -3;
    goto exit;
  }
  std::cout << std::endl << "Play with IPylon[GigE]Device" << std::endl;
  std::cout << "Pylon device has " << pCamera->GetNumStreamGrabberChannels() << " stream grabber channels" << std::endl;

// Open PylonDevice
  std::cout << "\tOpen Pylon Device" << std::endl;
  pCamera->Open();
  if (mCamera == NULL)
  {
    std::cout << "\t\tNo BaslerGigECamera to check" << std::endl;
    exitCode = -4;
    goto close;
  }
  if (not mCamera->IsAttached())
  {
    std::cout << "\t\tNot attached BaslerGigECamera to check" << std::endl;
    try
    {
      std::cout << "\t\tTry again with the constructor" << std::endl;
      mCamera = new CBaslerGigECamera(_TlFactory->CreateDevice(devInfo));
      goto cont;
    }
    catch(std::exception& e)
    {
      std::cout << "\t\t** Exception:\n\t\t" << e.what() << std::endl;
    }
    exitCode = -5;
    goto close;
  }
cont:
  //CBaslerGigECamera should be opened now...
  if (mCamera->IsOpen())
  {
    std::cout << "\t\tFirmware version: " << mCamera->DeviceFirmwareVersion.GetValue() << std::endl;
    std::cout << "\t\tClose BaslerGigECamera" << std::endl;
    mCamera->Close();
    std::cout << "\t\tDelete BaslerGigECamera" << std::endl;
    delete(mCamera);
  }
close:
  std::cout << "\tClose Pylon Device" << std::endl;
  pCamera->Close();
  std::cout << "\tDetele Pylon Device object" << std::endl;
  _TlFactory->DestroyDevice(pCamera);
exit:
  std::cout << "exit(" << exitCode << ")" << std::endl;
  _TlFactory->ReleaseTl(tl_);
  std::cout << std::endl;
  return exitCode;
}
