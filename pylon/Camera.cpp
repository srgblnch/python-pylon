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

#define kNUM_EVENTBUFFERS 20;

CppCamera::CppCamera(Pylon::CInstantCamera::DeviceInfo_t _devInfo,
                     Pylon::IPylonDevice *_pylonDevice,
                     Pylon::CInstantCamera* _instantCamera)
  :devInfo(_devInfo),pylonDevice(_pylonDevice),instantCamera(_instantCamera),
   cameraPresent(false)
{
  _name = "CppCamera(" + devInfo.GetSerialNumber() + ")";
  _debug("Build control object (INodeMap)");
  control = &instantCamera->GetNodeMap();
  prepareNodeIteration();
  _debug("Build TL control object (INodeMap)");
  control_tl = &instantCamera->GetTLNodeMap();
  prepareTLNodeIteration();

}

CppCamera::~CppCamera()
{
  //TODO: move it to the factory cleaner
  //instantCamera.DestroyDevice();
  //if ( instantCamera.IsPylonDeviceAttached() )
  //{
  //  instantCamera.DetachDevice();
  //}
  //tlFactory->DestroyDevice(pylonDevice);
  //TODO: DeregisterRemovalCallback
  pylonDevice->DeregisterRemovalCallback(cbHandle);
}

bool CppCamera::IsCameraPresent()
{
  return cameraPresent;
}

bool CppCamera::IsOpen()
{
  return IsCameraPresent() && pylonDevice->IsOpen();
}
bool CppCamera::Open()
{
  if (!pylonDevice->IsOpen())
  {
    //TODO: AccessModeSet
    pylonDevice->Open();
  }
  _debug("Prepare camera removal callback");
  prepareRemovalCallback();
  cameraPresent = true;
  return pylonDevice->IsOpen();
}
bool CppCamera::Close()
{
  if (pylonDevice->IsOpen())
  {
    pylonDevice->DeregisterRemovalCallback(cbHandle);
    pylonDevice->Close();
  }
  return !pylonDevice->IsOpen();
}

bool CppCamera::IsGrabbing()
{
  return IsOpen() && streamGrabber && streamGrabber->IsOpen();
      //instantCamera->IsGrabbing();
}

bool CppCamera::Snap(void *buffer,size_t &payloadSize,
                     uint32_t &width,uint32_t &height)
{
  std::stringstream msg;
  Pylon::CGrabResultPtr grabResult;
  instantCamera->GrabOne(1000,grabResult);
  _debug("instantCamera->GrabOne(...)");
  if ( grabResult->GrabSucceeded() )
  {
    _debug("Succeeded");
    width = grabResult->GetWidth();
    height = grabResult->GetHeight();
    payloadSize = grabResult->GetPayloadSize();
    msg << "Image(" << payloadSize << "): [" << width << "," << height << "]";
    _debug(msg.str()); msg.str("");
    buffer = grabResult->GetBuffer();
    _debug("GetBuffer()");
  }
  else
  {
    _warning("No succeeded!!");
    msg << "Error in getImage(): " << grabResult->GetErrorCode() << ":" \
      << grabResult->GetErrorDescription();
    _error(msg.str());
    throw std::runtime_error(msg.str());
  }
}

bool CppCamera::Start()
{
  if (pylonDevice->IsOpen() && !instantCamera->IsGrabbing())
  {
    //instantCamera->StartGrabbing();
    if ( GetNumStreamGrabberChannels() > 0)
    {
      //FIXME:  I'm seen always only 1 stream grabber available and once it's
      //get no one else can access the camera. But this must be reviewed.
      prepareStreamGrabber();
      streamGrabber->Open();
    }
    prepareEventGrabber();
    eventGrabber->Open();
  }
  return IsGrabbing();
}

bool CppCamera::Stop()
{
  if (IsGrabbing())
  {
    //instantCamera->StopGrabbing();
    if ( streamGrabber )
    {
      streamGrabber->Close();
    }
    if ( eventGrabber )
    {
      eventGrabber->Close();
      if ( eventAdapter )
      {
        pylonDevice->DestroyEventAdapter(eventAdapter);
      }
    }
  }
  return !IsGrabbing();
}

bool CppCamera::getImage(Pylon::CPylonImage *image)
{
  std::stringstream msg;
  Pylon::GrabResult resultPtr;
  //void *buffer;

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

uint32_t CppCamera::GetNumStreamGrabberChannels()
{
  return pylonDevice->GetNumStreamGrabberChannels();
}

void CppCamera::prepareStreamGrabber()
{
  streamGrabber = pylonDevice->GetStreamGrabber(0);
  waitObjects.Add(streamGrabber->GetWaitObject());
}

void CppCamera::prepareEventGrabber()
{
  eventGrabber = pylonDevice->GetEventGrabber();
  eventAdapter = pylonDevice->CreateEventAdapter();
  waitObjects.Add(eventGrabber->GetWaitObject());
}


void CppCamera::prepareNodeIteration()
{
  std::stringstream msg;

  _debug("Get INode objects from INodeMap");
  control->GetNodes(nodesList);
  _debug("Prepare the iterator to the first element");
  controlIt = nodesList.begin();
  msg << "prepared for the INodes iteration (" << nodesList.size() << ")";
  _debug(msg.str());
}

void CppCamera::prepareTLNodeIteration()
{
  std::stringstream msg;

  _debug("Get INode objects from INodeMap");
  control_tl->GetNodes(nodesList_tl);
  _debug("Prepare the iterator to the first element");
  controlIt_tl = nodesList_tl.begin();
  msg << "prepared for the TL INodes iteration (" << nodesList_tl.size() << ")";
  _debug(msg.str());
}

GenApi::INode *CppCamera::getNextNode()
{
  GenApi::INode *node;

  if ( controlIt == nodesList.end() )
  {
    //_debug("Reached the end of the list");
    prepareNodeIteration();
    return NULL;
  }
  node = (*controlIt);
  controlIt++;
  return node;
}

GenApi::INode *CppCamera::getTLNextNode()
{
  GenApi::INode *node;

  if ( controlIt_tl == nodesList_tl.end() )
  {
    //_debug("Reached the end of the list");
    prepareTLNodeIteration();
    return NULL;
  }
  node = (*controlIt_tl);
  controlIt_tl++;
  return node;
}

GenApi::INode *CppCamera::getNode(std::string name)
{
  //const size_t nameSize = name.length();
  const char *nameChar = name.c_str();
  GenICam::gcstring *nameAsGenICam = new GenICam::gcstring(nameChar);

  return control->GetNode(*nameAsGenICam);
}

GenApi::INode *CppCamera::getTLNode(std::string name)
{
  //const size_t nameSize = name.length();
  const char *nameChar = name.c_str();
  GenICam::gcstring *nameAsGenICam = new GenICam::gcstring(nameChar);

  return control_tl->GetNode(*nameAsGenICam);
}

void CppCamera::prepareRemovalCallback()
{
  cbHandle = Pylon::RegisterRemovalCallback(pylonDevice,*this,&CppCamera::removalCallback);
}

std::vector<void*>::iterator CppCamera::registerRemovalCallback(void *cbFunction)
{
  std::stringstream msg;

  aboveCallbacks.push_back(cbFunction);
  msg << "registered a new removal callback (" << aboveCallbacks.size() << ")";
  _debug(msg.str());
  return aboveCallbacks.end()--;
}

void CppCamera::deregisterRemovalCallback(std::vector<void*>::iterator pos)
{
  std::stringstream msg;

  _debug("Deregistering a removal callback");
  aboveCallbacks.erase(pos);
  msg << aboveCallbacks.size() << "removal callback left";
  _debug(msg.str());
}

void CppCamera::removalCallback(Pylon::IPylonDevice* pDevice)
{
  std::stringstream msg;
  std::vector<void*>::iterator it;

  _warning("Camera has been removed!");
  msg << "iterating the " << aboveCallbacks.size() << " callback registered";
  _debug(msg.str());
  for ( it = aboveCallbacks.begin(); it != aboveCallbacks.end(); it++)
  {
    void (*it)();
  }
  _debug("Deregister removal callback");
  pylonDevice->DeregisterRemovalCallback(cbHandle);
  cameraPresent = false;
}

