/*---- licence header
###############################################################################
## file :               ICategory.cpp
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

#include "ICategory.h"

CppICategory::CppICategory(GenApi::INode* node)
  :CppINode(node) { }

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

