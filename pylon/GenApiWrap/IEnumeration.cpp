/*---- licence header
###############################################################################
## file :               IEnumeration.cpp
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

#include "IEnumeration.h"

CppEnumeration::CppEnumeration(GenApi::INode* node)
{
  _enumeration = dynamic_cast<GenApi::IEnumeration*>(node);
}

CppEnumeration::CppEnumeration(GenApi::IEnumeration* enumeration)
{
  _enumeration = enumeration;
}

std::vector<std::string> CppEnumeration::getSymbolics()
{
  Pylon::StringList_t strLst;
  Pylon::StringList_t::iterator it;
  std::vector<std::string> strVct;

  _enumeration->GetSymbolics(strLst);
  _debug("GetSymbolics()");

  for( it = strLst.begin(); it != strLst.end(); it++)
  {
    std::string symbol = dynamic_cast<std::string&>(*it);
    _debug(symbol);
    strVct.push_back(symbol);
  }
  return strVct;
}

std::string CppEnumeration::getEntry()
{
  return _enumeration->GetCurrentEntry()->ToString().c_str();
}

