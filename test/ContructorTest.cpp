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

using namespace std;
using namespace Pylon;

inline bool _cppBuildUsingTwicePointer(CTlFactory* _TlFactory,
                 CDeviceInfo devInfo, IPylonDevice **pDevice,
                 CBaslerGigECamera **bCamera)
{
  try
  {
    cout << "\tCreate IPylonDevice object for " << devInfo.GetSerialNumber() \
        << endl;
    *pDevice = _TlFactory->CreateDevice(devInfo);
  }
  catch(exception& e)
  {
    cout << "\t\tFailed!\n\t\t" << e.what() << endl;
    return false;
  }
  try
  {
    cout << "\tWith the IPylonDevice object build the CBaslerGigECamera"<<endl;
    *bCamera = new CBaslerGigECamera(*pDevice);
    return true;
  }
  catch(exception& e)
  {
    cout << "\t\tFailed!\n\t\t" << e.what() << endl;
    cout << "\tTry in the opposite way" << endl << endl;
    try
    {
      cout << "\tCreate CBaslerGigECamera object for " \
          << devInfo.GetSerialNumber() << " from the factory" << endl;
      *bCamera = new CBaslerGigECamera(_TlFactory->CreateDevice(devInfo));
      cout << "\tGet the IPylonDevice by requesting it "\
          "to the CBaslerGigECamera" << endl;
      *pDevice = (*bCamera)->GetDevice();
      return true;
    }
    catch(exception& e)
    {
      cout << "\t\tFailed!\n\t\t" << e.what() << endl;
    }
  }
  return false;
}

int main(int argc, char* argv[])
{
  // The exit code of the sample application
  int exitCode = 0;

  // Automagically call PylonInitialize and PylonTerminate to ensure the
  // pylon runtime system is initialized during the lifetime of this object.
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
  IPylonDevice *pDevice = NULL;
  CBaslerGigECamera *bCamera = NULL;
  Pylon::String_t pylon_camera_ip(argv[1]);

  cout << endl << "Get factory instance" << endl;
  _TlFactory = &CTlFactory::GetInstance();
  nTransportLayers = _TlFactory->EnumerateTls(transportLayers);
  cout << "Available "<< nTransportLayers <<" transport layers" << endl;
  for (tl_it = transportLayers.begin(); tl_it != transportLayers.end();tl_it++)
  {
    const Pylon::CTlInfo& tl_info = \
              static_cast<const Pylon::CTlInfo&>(*tl_it);
    cout << "\t" << tl_info.GetFullName() << endl;
  }

  cout << endl << "Create a transport layer to access " \
      << CBaslerGigECamera::DeviceClass() << " cameras" << endl;
  tl_ = _TlFactory->CreateTl( CBaslerGigECamera::DeviceClass() );

  nCameras = tl_->EnumerateDevices( devices );
  cout << "Found " << nCameras << " cameras" << endl;
  if (nCameras == 0)
  {
    exitCode = -1;
    goto exit;
  }
  cout << "\titerate searching " << pylon_camera_ip << " camera"
      << endl;
  for (it = devices.begin(); it != devices.end(); it++)
  {
    const CBaslerGigECamera::DeviceInfo_t& gige_device_info = \
        static_cast<const CBaslerGigECamera::DeviceInfo_t&>(*it);
    Pylon::String_t current_ip = gige_device_info.GetIpAddress();
    cout << "\t\tFound a " << gige_device_info.GetModelName()
        << " with ip " << current_ip << " (" \
        << gige_device_info.GetSerialNumber() << ")" << endl;
    if (current_ip == pylon_camera_ip)
    {
      cout << "\t\t\tThis is the camera wanted (" << current_ip << ")"
          << endl;
      devInfo = gige_device_info;
      break;
    }
  }
  if (it == devices.end())
  {
    cout << "\t\tCamera not found" << endl;
    exitCode = -2;
    goto exit;
  }
  cout << endl << "Given camera information:" << endl;
  cout << "\tdevInfo.GetFullName(): \"" << devInfo.GetFullName() \
      << "\""<< endl;
  cout << "\tdevInfo.GetSerialNumber(): \"" << devInfo.GetSerialNumber() \
        << "\""<< endl;
  cout << "\tdevInfo.GetModelName(): \"" << devInfo.GetModelName() \
      << "\""<< endl;
  cout << "\tdevInfo.GetDeviceClass(): \"" << devInfo.GetDeviceClass() \
      << "\""<< endl;
  cout << "\tdevInfo.GetDeviceVersion(): \"" << devInfo.GetDeviceVersion() \
      << "\""<< endl;
  cout << "\tdevInfo.GetDeviceFactory(): \"" << devInfo.GetDeviceFactory() \
      << "\""<< endl;
  cout << "\tdevInfo.GetInterface(): \"" << devInfo.GetInterface() \
      << "\""<< endl;

  cout << endl << "Connect to the Camera for further control" << endl;
  if (not _cppBuildUsingTwicePointer(_TlFactory, devInfo, &pDevice, &bCamera))
  {
    cout << "Pointer twice indirection didn't work!" << endl;
  }
  if (pDevice == NULL)
  {
    exitCode = -3;
    goto exit;
  }
  cout << endl << "Play with IPylon[GigE]Device" << endl;
  cout << "Pylon device has " << pDevice->GetNumStreamGrabberChannels() \
      << " stream grabber channels" << endl;

// Open PylonDevice
  cout << "\tOpen Pylon Device" << endl;
  pDevice->Open();
  if (bCamera == NULL)
  {
    cout << "\t\tNo BaslerGigECamera to check" << endl;
    exitCode = -4;
    goto close;
  }
  if (not bCamera->IsAttached())
  {
    cout << "\t\tNot attached BaslerGigECamera to check" << endl;
    try
    {
      cout << "\t\tTry again with the constructor" << endl;
      bCamera = new CBaslerGigECamera(_TlFactory->CreateDevice(devInfo));
      goto cont;
    }
    catch(exception& e)
    {
      cout << "\t\t** Exception:\n\t\t" << e.what() << endl;
    }
    exitCode = -5;
    goto close;
  }
cont:
  //CBaslerGigECamera should be opened now...
  if (bCamera->IsOpen())
  {
    cout << "\t\tFirmware version: " \
        << bCamera->DeviceFirmwareVersion.GetValue() << endl;
    cout << "\t\tClose BaslerGigECamera" << endl;
    bCamera->Close();
    cout << "\t\tDelete BaslerGigECamera" << endl;
    delete(bCamera);
  }
close:
  cout << "\tClose Pylon Device" << endl;
  pDevice->Close();
  cout << "\tDetele Pylon Device object" << endl;
  _TlFactory->DestroyDevice(pDevice);
exit:
  cout << "exit(" << exitCode << ")" << endl;
  _TlFactory->ReleaseTl(tl_);
  cout << endl;
  return exitCode;
}
