/*---- licence header
###############################################################################
## file :               INode.cpp
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

#include "INode.h"

CppINode::CppINode(GenApi::INode* node)
:_node(node)
{

}

CppICategory::CppICategory(GenApi::INode* node)
:CppINode(node)
{

}

CppIEnumeration::CppIEnumeration(GenApi::INode* node)
:CppINode(node)
{

}


std::string CppINode::getDescription()
{
  return _node->GetDescription().c_str();
}

std::string CppINode::getToolTip()
{
  return _node->GetToolTip().c_str();
}

std::string CppINode::getDisplayName()
{
  return _node->GetDisplayName().c_str();
}

int CppINode::getAccessMode()
{
  GenApi::EAccessMode mode = _node->GetAccessMode();
  return static_cast<int>(mode);
}

void CppINode::setAccessMode(int mode)
{
  std::stringstream msg;
  GenApi::EAccessMode accessMode = static_cast<GenApi::EAccessMode>(mode);
  msg << "imposing access mode " << accessMode;
  _debug(msg.str()); msg.str("");
  _node->ImposeAccessMode(accessMode);
}

bool CppINode::isImplemented()
{
  return IsImplemented(_node->GetAccessMode());
}

bool CppINode::isAvailable()
{
  return IsAvailable(_node->GetAccessMode());
}

bool CppINode::isReadable()
{
  return IsReadable(_node->GetAccessMode());
}

bool CppINode::isWritable()
{
  return IsWritable(_node->GetAccessMode());
}

bool CppINode::isCachable()
{
  return _node->IsCachable();
}

bool CppINode::isFeature()
{
  return _node->IsFeature();
}

bool CppINode::isDeprecated()
{
  return _node->IsDeprecated();
}

GenApi::INode* CppINode::getINode()
{
  return _node;
}

std::vector<std::string> CppINode::getChildren()
{
  std::vector<std::string> answer;
  return answer;
}

std::vector<std::string> CppICategory::getChildren()
{
  std::stringstream msg;

  GenApi::FeatureList_t features;
  GenApi::FeatureList_t::iterator it;
  std::vector<std::string> answer;
  std::string featureName;

  dynamic_cast<GenApi::ICategory*>(_node)->GetFeatures(features);
  msg << "finding " << this->getDisplayName() << " children";
  _debug(msg.str()); msg.str("");
  for( it = features.begin(); it != features.end(); it++)
  {
    featureName = (*it)->GetNode()->GetName().c_str();
    msg << featureName;
    _debug(msg.str()); msg.str("");
    answer.push_back(featureName);
  }
  return answer;
}

std::vector<std::string> CppINode::getEntries()
{
  std::vector<std::string> answer;
  return answer;
}

std::vector<std::string> CppIEnumeration::getEntries()
{
  std::stringstream msg;

  GenApi::NodeList_t entries;
  GenApi::NodeList_t::iterator it;
  std::vector<std::string> answer;
  std::string entryName;

  dynamic_cast<GenApi::IEnumeration*>(_node)->GetEntries(entries);
  msg << "finding " << this->getDisplayName() << " entries";
  _debug(msg.str()); msg.str("");
  for( it = entries.begin(); it != entries.end(); it++)
  {
    entryName = (*it)->GetName().c_str();
    msg << entryName;
    _debug(msg.str()); msg.str("");
    answer.push_back(entryName);
  }
  return answer;
}

std::string CppIEnumeration::getValue()
{
  return dynamic_cast<GenApi::IEnumeration*>(_node)->ToString().c_str();
}

