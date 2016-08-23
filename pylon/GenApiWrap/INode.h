/*---- licence header
###############################################################################
## file :               INode.h
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

#ifndef INODE_H
#define INODE_H

#include "Logger.h"
//#include <pylon/PylonIncludes.h>
#include "GenICam.h"
#include <iostream>
#include <stdexcept>
#include <vector>

class CppINode : public Logger
{
public:
  CppINode(GenApi::INode* node);
  virtual ~CppINode(){};

  std::string getDescription();
  std::string getToolTip();
  std::string getDisplayName();
  std::vector<std::string> getProperties();
  std::string getProperty(const std::string name);
  int getAccessMode();
  void setAccessMode(int mode);
  bool isImplemented();
  bool isAvailable();
  bool isReadable();
  bool isWritable();
  bool isCachable();
  bool isFeature();
  bool isDeprecated();
  GenApi::INode* getINode();
  std::vector<std::string> getChildren();
  std::vector<std::string> getEntries();
protected:
  GenApi::INode* _node;
};

//class CppICategory : public CppINode
//{
//public:
//  CppICategory(GenApi::INode* node);
//  std::vector<std::string> getChildren();
//};

#endif /* INODE_H */
