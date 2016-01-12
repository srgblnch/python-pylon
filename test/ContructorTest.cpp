/*---- licence header
###############################################################################
## file :               ConstructorTest.cpp
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

#include <iostream>
#include <exception>
#include <boost/smart_ptr.hpp>
#include <pylon/PylonIncludes.h>
#include <pylon/gige/BaslerGigECamera.h>

/****************
 * This is a test made to understand the issue creating the Camera_t
 * object that gives us the exception:
 * > The attached Pylon Device is not of type IPylonGigEDevice!
 * > (/opt/pylon/include/pylon/gige/PylonGigEDeviceProxy.h:169)
 */

using namespace std;
using namespace Pylon;

typedef Pylon::CBaslerGigECamera Camera_t;
using namespace Basler_GigECameraParams;

using boost::scoped_ptr;

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
  Camera_t::DeviceInfo_t devInfo;
  IPylonDevice *pDevice = NULL;
  Camera_t *bCamera;
  scoped_ptr<Camera_t> scoped_bCamera;

  //FIXME: this arguments haven't been checked
  Pylon::String_t pylon_camera_ip(argv[1]);
  Pylon::String_t devInfoSource(argv[2]);
  Pylon::String_t devInfoIterator("it");
  int devInfoOptions = 0;
  if (devInfoSource == "")
  {
    cout << "Second argument not specified, using default" << endl;
    devInfoSource = devInfoIterator;
  }
  if (devInfoSource == "it")
  {
    cout << "To build the objects, the iterator reference will be used" << endl;
    devInfoOptions = 1;
  }
  else if (devInfoSource == "devInfo")
  {
    cout << "To build the objects, the devInfo object will be used" << endl;
    devInfoOptions = 2;
  }
  else
  {
    cout << "invalid device information source" << endl;
    goto exit;
  }

goto continueNormal;

exit://Moved from the bottom to avoid declarations with
     //initialisations in the middle.
  cout << "exit(" << exitCode << ")" << endl;
  try
  {
    _TlFactory->ReleaseTl(tl_);
  }
  catch(exception& e)
  {
    cout << "couldn't release the transport layer" << endl;
  }
  try
  {
    scoped_bCamera.reset();
  }
  catch(exception& e)
  {
    cout << "couldn't reset the scoped_ptr" << endl;
  }
  cout << endl;
  return exitCode;

continueNormal:
  VersionInfo pylonVersionInfo;
  cout << endl << "Working with Pylon version " \
       << pylonVersionInfo.getMajor() << " (" \
       << pylonVersionInfo.getVersionString() << ")" << endl;

  cout << endl << "Get factory instance" << endl;
  _TlFactory = &CTlFactory::GetInstance();
  nTransportLayers = _TlFactory->EnumerateTls(transportLayers);
  cout << "Available "<< nTransportLayers <<" transport layers" << endl;
  for (tl_it = transportLayers.begin(); tl_it != transportLayers.end();tl_it++)
  {
    const Pylon::CTlInfo& tl_info = \
              static_cast<const Pylon::CTlInfo&>(*tl_it);
    cout << "\t- " << tl_info.GetFullName() << endl;
  }

  cout << endl << "Create a transport layer to access " \
      << Camera_t::DeviceClass() << " cameras" << endl;
  tl_ = _TlFactory->CreateTl( Camera_t::DeviceClass() );

  nCameras = tl_->EnumerateDevices( devices );
  cout << "Found " << nCameras << " cameras" << endl;
  if (nCameras == 0)
  {
    exitCode = -1;
    goto exit;
  }
  cout << "\tIterate searching " << pylon_camera_ip << " camera"
      << endl;
  for (it = devices.begin(); it != devices.end(); it++)
  {
    const Camera_t::DeviceInfo_t& gige_device_info = \
        static_cast<const Camera_t::DeviceInfo_t&>(*it);
    Pylon::String_t current_ip = gige_device_info.GetIpAddress();
    cout << "\t\t- Found a " << gige_device_info.GetModelName() << " (" \
        << gige_device_info.GetSerialNumber() << ")" \
        << " with ip " << current_ip << endl;
    if (current_ip == pylon_camera_ip)
    {
      cout << "\t\t\t** This is the camera wanted (" << current_ip << ") **"
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
  cout << endl << "Wanted camera information:" << endl;
  cout << "\t- FullName: \"" << devInfo.GetFullName() \
      << "\""<< endl;
  cout << "\t- SerialNumber: \"" << devInfo.GetSerialNumber() \
        << "\""<< endl;
  cout << "\t- ModelName: \"" << devInfo.GetModelName() \
      << "\""<< endl;
  cout << "\t- DeviceClass: \"" << devInfo.GetDeviceClass() \
      << "\""<< endl;
  cout << "\t- DeviceVersion: \"" << devInfo.GetDeviceVersion() \
      << "\""<< endl;
  cout << "\t- DeviceFactory: \"" << devInfo.GetDeviceFactory() \
      << "\""<< endl;
  cout << "\t- Interface: \"" << devInfo.GetInterface() \
      << "\""<< endl;

  cout << endl << "Connect to the Camera for further control" << endl;

  try
  {
    cout << "Build and attach in one step" << endl;

    if (devInfoOptions == 1)
    {
      bCamera = new Camera_t(_TlFactory->CreateDevice(*it));
    }
    else
    {
      bCamera = new Camera_t(_TlFactory->CreateDevice(devInfo));
    }
    scoped_bCamera.reset(bCamera);
  }
  catch(exception& e)
  {
    cout << "\tIt doesn't work!\n\t" << e.what() << endl \
         << "Try an alternative" << endl;
    try
    {
      cout << "\tFirst build..." << endl;
      bCamera = new Camera_t();
      scoped_ptr<Camera_t> camera(new Camera_t());
      scoped_bCamera.reset(bCamera);
      cout << "\tThen attach..." << endl;
      if (devInfoOptions == 1)
      {
        bCamera->Attach(_TlFactory->CreateDevice(*it));
      }
      else
      {
        bCamera->Attach(_TlFactory->CreateDevice(devInfo));
      }
    }
    catch(exception& e)
    {
      cout << "\t\tFailed!\n\t" << e.what() << endl;
      exitCode = -3;
      goto exit;
    }
  }

  if (scoped_bCamera.get() == NULL)
  {
    cout << "\t* Camera object points to NULL" << endl;
    exitCode = -4;
    goto exit;
  }
  else if (not scoped_bCamera.get()->IsAttached())
  {
    cout << "\t* Camera object build but not attached to a Device object" \
         << endl;
    exitCode = -5;
    goto exit;
  }

  pDevice = scoped_bCamera.get()->GetDevice();
  if (!pDevice)
  {
    cout << "\tPylon Device points to NULL" << endl;
    exitCode = -6;
    goto exit;
  }

  cout << endl << "Play with the build objects" << endl;
  cout << "\t- Pylon device has " << pDevice->GetNumStreamGrabberChannels() \
       << " stream grabber channels" << endl;
  Camera_t::TlParams_t TlParams(scoped_bCamera->GetTLNodeMap());
  cout << "\t- TL read timeout:" << dec << TlParams.ReadTimeout.GetValue() \
       << endl;
  cout << "\t- TL write timeout:" << dec << TlParams.WriteTimeout.GetValue() \
       << endl;
  cout << "\t- TL heartbeat timeout:" << dec \
       << TlParams.HeartbeatTimeout.GetValue() << endl;

  cout << "\t- Open Pylon Device" << endl;
  pDevice->Open();
  if (not scoped_bCamera.get()->IsOpen())
  {
    cout << "\t* Open the Device object didn't show the Camera Object open" \
         << endl;
    exitCode = -7;
    goto exit;
  }

  cout << endl << "Information requested directly to the camera:" << endl;
  cout << "\t\t- Firmware version: " \
          << scoped_bCamera.get()->DeviceFirmwareVersion.GetValue() << endl;

//close: //TODO: label to be used in the checks after the communication is open.
  cout << "\tClose Pylon Device" << endl;
  pDevice->Close();
  cout << "\tDetele Pylon Device object" << endl;
  _TlFactory->DestroyDevice(pDevice);
  goto exit;//with exitCode = 0, that means "everything went well"!
}
