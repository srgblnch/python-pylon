/*---- licence header
###############################################################################
## file :               Camera.cpp
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

#include "Camera.h"

CppCamera::CppCamera(Pylon::CInstantCamera::DeviceInfo_t _devInfo,
                     Pylon::IPylonDevice *_pDevice,
                     Pylon::CInstantCamera* _bCamera)
  :devInfo(_devInfo),pDevice(_pDevice),bCamera(_bCamera)
{
  _name = "CppCamera(" + _devInfo.GetSerialNumber() + ")";
  control = &_bCamera->GetNodeMap();
//  streamGrabber = pDevice.GetStreamGrabber(0);//FIXME: if there are more than 1?
  //TODO: RegisterRemovalCallback
}

CppCamera::~CppCamera()
{
  //TODO: move it to the factory cleaner
  //bCamera.DestroyDevice();
  //if ( bCamera.IsPylonDeviceAttached() )
  //{
  //  bCamera.DetachDevice();
  //}
  //tlFactory->DestroyDevice(pDevice);
  //TODO: DeregisterRemovalCallback
}

bool CppCamera::IsOpen()
{
  return pDevice->IsOpen();
}
bool CppCamera::Open()
{
  if (!pDevice->IsOpen())
  {
    //TODO: AccessModeSet
    pDevice->Open();
  }
  return pDevice->IsOpen();
}
bool CppCamera::Close()
{
  if (pDevice->IsOpen())
  {
    pDevice->Close();
  }
  return !pDevice->IsOpen();
}

bool CppCamera::IsGrabbing()
{
  return pDevice->IsOpen() && streamGrabber && streamGrabber->IsOpen();
      //bCamera->IsGrabbing();
}

bool CppCamera::Start()
{
  if (pDevice->IsOpen() && !bCamera->IsGrabbing())
  {
    //bCamera->StartGrabbing();
    if ( GetNumStreamGrabberChannels() > 0)
    {
      //FIXME:  I'm seen always only 1 stream grabber available and once it's
      //get no one else can access the camera. But this must be reviewed.
      streamGrabber = pDevice->GetStreamGrabber(0);
      PrepareStreamGrabber();
      streamGrabber->Open();
    }
  }
  return IsGrabbing();
}

bool CppCamera::Stop()
{
  if (IsGrabbing())
  {
    //bCamera->StopGrabbing();
    if ( streamGrabber )
    {
      streamGrabber->Close();
    }
  }
  return !IsGrabbing();
}

bool CppCamera::getImage(Pylon::CPylonImage *image)
{
  std::stringstream msg;
  Pylon::GrabResult resultPtr;
  void *buffer;

  _debug("CppCamera::getImage()");

  if ( IsGrabbing() )
  {
    _debug("IsGrabbing()");
    if (streamGrabber->RetrieveResult(resultPtr) )
    {
      _debug("streamGrabber->RetrieveResult() true");
      if ( resultPtr.Succeeded() )
      {
        _debug("resultPtr->GrabSucceeded() true");
        image = new Pylon::CPylonImage();
        _debug("Pylon::CPylonImage()");
        image->CopyImage(resultPtr.GetImage());
        _debug("AttachGrabResultBuffer()");
        return true;
      }
      else
      {
        _debug("resultPtr->GrabSucceeded() false");
        std::stringstream e;
        e << "Error in getImage(): " << resultPtr.GetErrorCode() << ":" \
          << resultPtr.GetErrorDescription();
        throw std::runtime_error(e.str());
        //TODO: review what to do if Grab did not succeed
      }
    }
    else
    {
      _debug("streamGrabber->RetrieveResult() false");
    }
  }
  else
  {
    _debug("!IsGrabbing()");
  }
  return false;
}

Pylon::String_t CppCamera::GetSerialNumber()
{
  try
  {
    return devInfo.GetSerialNumber();
  }
  catch(std::exception& e)
  {
    std::stringstream msg;
    msg << "CppCamera GetSerialNumber exception: " << e.what();
    _error(msg.str()); msg.str("");
    return "";
  }
}

Pylon::String_t CppCamera::GetModelName()
{
  try
  {
    return devInfo.GetModelName();
  }
  catch(std::exception& e)
  {
    std::stringstream msg;
    msg << "CppCamera GetModelName exception: " << e.what();
    _error(msg.str()); msg.str("");
    return "";
  }
}

uint32_t CppCamera::GetNumStreamGrabberChannels()
{
  return pDevice->GetNumStreamGrabberChannels();
}

void CppCamera::PrepareStreamGrabber()
{

}
