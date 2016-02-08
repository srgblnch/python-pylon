/*---- licence header
###############################################################################
## file :               Camera.h
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

#ifndef CAMERA_H
#define CAMERA_H

#include <pylon/PylonIncludes.h>
#include "Logger.h"
#include "DevInfo.h"
#include <iostream>
#include <vector>

class CppCamera : public Logger
{
public:
  CppCamera( Pylon::CInstantCamera::DeviceInfo_t,
             Pylon::IPylonDevice*, Pylon::CInstantCamera* );
  ~CppCamera();
  bool IsOpen();
  bool Open();
  bool Close();
  bool IsGrabbing();
  bool Start();
  bool Stop();
  bool getImage(Pylon::CPylonImage *image);
  Pylon::String_t GetSerialNumber();
  Pylon::String_t GetModelName();
  uint32_t GetNumStreamGrabberChannels();
private:
  Pylon::CInstantCamera::DeviceInfo_t devInfo;
  Pylon::IPylonDevice *pDevice;
  Pylon::CInstantCamera *bCamera;
  GenApi::INodeMap *control;
  Pylon::IStreamGrabber* streamGrabber;
  void PrepareStreamGrabber();
};

#endif /* CAMERA_H */
