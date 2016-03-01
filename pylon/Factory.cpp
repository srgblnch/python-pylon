/*---- licence header
###############################################################################
## file :               Factory.cpp
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

#include "Factory.h"

/****
 * Class constructor
 */
CppFactory::CppFactory()
{
  Pylon::PylonAutoInitTerm autoInitTerm;
  Pylon::PylonInitialize();
  _name = "CppFactory()";
}

/****
 * Class destructor
 */
CppFactory::~CppFactory()
{
  ReleaseTl();
  Pylon::PylonTerminate();
}

/****
 * Find the available transport layers and build our wrapper for them
 */
void CppFactory::CreateTl()
{
  std::stringstream msg;
  int nTransportLayers = 0;
  Pylon::TlInfoList_t availableTLs;
  Pylon::TlInfoList::const_iterator iterator_tlInfoLst;

  CppTransportLayer *transportLayer;

  _tlFactory = &Pylon::CTlFactory::GetInstance();
  nTransportLayers = _tlFactory->EnumerateTls(availableTLs);

  msg << "Found " << nTransportLayers << " transport layers: ";
  _debug(msg.str()); msg.str("");

  _tlList.reserve(nTransportLayers*sizeof(CppTransportLayer));
  _tlLstIt = _tlList.begin();

  for (iterator_tlInfoLst = availableTLs.begin();\
       iterator_tlInfoLst != availableTLs.end();iterator_tlInfoLst++)
  {
    const Pylon::CTlInfo &info = \
        static_cast<const Pylon::CTlInfo&>(*iterator_tlInfoLst);
    msg << "Build the CppTransportLayer(" << info.GetDeviceClass() << ")";
    _debug(msg.str()); msg.str("");
    transportLayer = new CppTransportLayer(info);
    msg << "Created the transport layer to access " << info.GetFullName() \
        << " cameras (" << info.GetDeviceClass() << ")";
    _debug(msg.str()); msg.str("");

    _tlList.insert(_tlLstIt,transportLayer);
    _tlLstIt++;
  }
}

/****
 * For all the builded transport layers, deacoblate them and clean the memory
 */
void CppFactory::ReleaseTl()
{
  for (_tlLstIt = _tlList.begin(); _tlLstIt != _tlList.end(); _tlLstIt++)
  {
    delete (*_tlLstIt);
    _tlList.erase(_tlLstIt);
  }
}

/****
 * Iterate the transport layers builded to know how many cameras can be access
 * for each of them. It returns the total.
 */
int CppFactory::DeviceDiscovery()
{
  //TODO: This method are not making different lists for each transport layer
  std::stringstream msg;
  int currentTlCameras = 0,nCameras = 0;
  std::vector<CppTransportLayer*>::iterator it;

  if ( _tlFactory == NULL )
  {
    _error("No transport factory created");
    return 0;
  }

  _debug("Iterate the transport layer vector");
  for (_tlLstIt = _tlList.begin();_tlLstIt != _tlList.end(); _tlLstIt++)
  {
    currentTlCameras = (*_tlLstIt)->EnumerateDevices();
    nCameras += currentTlCameras;
  }

  msg << "Found a total of " << nCameras << " cameras";
  _debug(msg.str()); msg.str("");

  prepareDeviceIteration();

  return nCameras;
}

/****
 * internal method to prepare the device iteration after the device discovery
 */
void CppFactory::prepareDeviceIteration()
{
  _tlLstIt = _tlList.begin();
  _devLstIt = (*_tlLstIt)->getFirst();
}

/****
 * Used like a yield because each time this method is called, one element from
 * the device list on each of the transport layers is returned.
 * This merges all the device lists that each of the transport layers have,
 * like if only one list is present.
 * When all has been iterated, it returns NULL to tag it. And next call will
 * return again the first. But if a new camera has been plugged it will not
 * be discovered until DeviceDiscovery() is called.
 */
CppDevInfo* CppFactory::getNextDeviceInfo()
{
  std::stringstream msg;

  while ( _devLstIt == (*_tlLstIt)->getLast() )
  {
    msg << "Reached last of the deviceInfos of the "
        << (*_tlLstIt)->getTlClass() << " transport layer";
    _debug(msg.str()); msg.str("");
    _tlLstIt++;
    if ( _tlLstIt == _tlList.end() )
    {
      _debug("Reached the end of all the deviceInfos in all the TLs");
      prepareDeviceIteration();//return to the first for further iterations
      return NULL;
    }
    _devLstIt = (*_tlLstIt)->getFirst();
    msg << "Starting the first of the deviceInfos of the "
        << (*_tlLstIt)->getTlClass() << " transport layer";
    _debug(msg.str()); msg.str("");
  }
  const Pylon::CDeviceInfo& pylonDeviceInfo = \
      static_cast<const Pylon::CDeviceInfo&>(*_devLstIt);
  CppDevInfo* wrapperDevInfo = (*_tlLstIt)->buildDeviceInfo(pylonDeviceInfo);
  msg << "Found a " << pylonDeviceInfo.GetModelName()
      << " Camera, with serial number " << pylonDeviceInfo.GetSerialNumber();
  _debug(msg.str());
  _devLstIt++;
  return wrapperDevInfo;
}

CppCamera* CppFactory::CreateCamera(CppDevInfo* wrapperDevInfo)
{
  std::stringstream msg;
  Pylon::CDeviceInfo devInfo;
  Pylon::IPylonDevice *pDevice = NULL;
  Pylon::CInstantCamera *iCamera = NULL;
  CppCamera *cppCamera = NULL;

  devInfo = wrapperDevInfo->GetDeviceInfo();
  msg << "Creating a Camera object from the information of the camera with "\
      "the serial number " << devInfo.GetSerialNumber();
  _debug(msg.str()); msg.str("");
  try
  {
    _debug("Creating IPylonDevice object");
    pDevice = _tlFactory->CreateDevice(devInfo);
    _debug("Creating CInstantCamera object");
    iCamera = new Pylon::CInstantCamera(pDevice);
  }
  catch(std::exception& e)
  {
    msg << "CreateCamera Constructor exception: " << e.what();
    _error(msg.str()); msg.str("");
    return NULL;
  }
  _debug("CreateCamera construction");
  cppCamera = new CppCamera(devInfo,pDevice,iCamera);
  _debug("CreateCamera construction done");
  return cppCamera;
}
