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
  _name = "CppINode()";
}

CppICategory::CppICategory(GenApi::INode* node)
  :CppINode(node) { }

CppIEnumeration::CppIEnumeration(GenApi::INode* node)
  :CppINode(node) { }

CppIEnumEntry::CppIEnumEntry(GenApi::INode* node)
  :CppINode(node) { }

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

std::vector<std::string> CppINode::getProperties()
{
  std::stringstream msg;
  GenICam::gcstring_vector properties;
  GenICam::gcstring_vector::iterator it;
  std::vector<std::string> answer;
  std::string propertyName;

//  _node->GetPropertyNames(properties);
//  msg << "finding " << this->getDisplayName() << " properties";
  for( it = properties.begin(); it != properties.end(); it++)
  {
    propertyName = (*it).c_str();
//    msg << propertyName;
//    _debug(msg.str()); msg.str("");
    answer.push_back(propertyName);
  }
  return answer;
}

std::string CppINode::getProperty(const std::string name)
{
//  std::stringstream msg;

  GenICam::gcstring nameStr,valueStr,attrStr;

  nameStr = name.c_str();
  _node->GetProperty(nameStr,valueStr,attrStr);
//  msg << "Property " << name
//      << " value: " << valueStr.c_str()
//      << " (attrStr " << attrStr.c_str() << ")";
//  _debug(msg.str()); msg.str("");
  return valueStr.c_str();
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
//  std::stringstream msg;

  GenApi::FeatureList_t features;
  GenApi::FeatureList_t::iterator it;
  std::vector<std::string> answer;
  std::string featureName;

  dynamic_cast<GenApi::ICategory*>(_node)->GetFeatures(features);
//  msg << "finding " << this->getDisplayName() << " children";
//  _debug(msg.str()); msg.str("");
  for( it = features.begin(); it != features.end(); it++)
  {
    featureName = (*it)->GetNode()->GetName().c_str();
//    msg << featureName;
//    _debug(msg.str()); msg.str("");
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

  GenApi::IEnumeration* enumeration;
  GenApi::NodeList_t entriesLst;
  GenApi::NodeList_t::iterator it;
  std::string entryStr;
//  GenApi::IEnumEntry* currentEntry;
//  int64_t enumValue;
  std::vector<std::string> answer;

  enumeration = dynamic_cast<GenApi::IEnumeration*>(_node);
  enumeration->GetEntries(entriesLst);
  for( it = entriesLst.begin(); it != entriesLst.end(); it++)
  {
    entryStr = (*it)->GetName().c_str();

    // FIXME: It looks this is not the way for write access to those IValues
    //        The class GenApi::IEnumEntry is abstract and it seem its
    //        subclasses would be internal to the library.
    //        For example, for the PixelType it seems there are specific
    //        objects in the Pylon namespace.
//    currentEntry = enumeration->GetEntryByName((*it)->GetName());
//    enumValue = currentEntry->GetValue();
//    enumValue = (*it)->GetValue();
//    _entries[entryStr] = enumValue;
//    // or:
//    //_entries.insert(std::pair<std::string, int64_t>(entryStr,0));
    answer.push_back(entryStr);
  }
  msg << "found " << answer.size() << " entries";
  _debug(msg.str());
  return answer;
}

std::string CppIEnumeration::getValue()
{
  return dynamic_cast<GenApi::IEnumeration*>(_node)->ToString().c_str();
}

//bool CppIEnumeration::setValue(std::string value)
//{
//  std::stringstream msg;
//  std::map<std::string, int64_t>::iterator it;
//
//  msg << "CppIEnumeration::setValue(" << value << ")";
//  _info(msg.str()); msg.str("");
//  it = _entries.find(value);
//  _debug("find ends");
//  if ( it != _entries.end() )
//  {
//    msg << "value " << value << " found, calling FromString";
//    _debug(msg.str());
//    dynamic_cast<GenApi::IEnumeration*>(_node)->SetIntValue(it->second);
//    return true;
//  }
//  msg << "value " << value << " not found";
//  _warning(msg.str());
//  return false;
//}

std::string CppIEnumEntry::getValue()
{
  //return dynamic_cast<GenApi::IEnumEntry*>(_node)->ToString().c_str();
  // There is no such method 'ToString()'
  //return dynamic_cast<GenApi::IEnumEntry*>(_node)->GetValue();
  // It is an abstract class

  throw std::runtime_error("CppIEnumEntry::getValue() Not implemented");
}
