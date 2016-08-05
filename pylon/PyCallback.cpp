/*---- licence header
###############################################################################
## file :               PyCallback.cpp
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

#include "PyCallback.h"

PyCallback::PyCallback(PyObject* self, const char* methodName,
                       std::string parentName)
{
  _name = "PyCallback(" + parentName + ")";

  if ( self == NULL )
  {
    throw std::runtime_error("self object is NULL");
  }

  if ( PyObject_HasAttrString(self, methodName) )
  {
    _callbackMethod = PyObject_GetAttrString(self, methodName);
    if ( _callbackMethod && PyCallable_Check(_callbackMethod) )
    {
      _name = "PyCallback(" + parentName + "." + methodName + ")";
      _debug("Build the callback object successful");
    }
    else
    {
      throw std::runtime_error("The callback attribute is not callable");
    }
  }
  else
  {
    throw std::runtime_error("The callback attribute does not exist");
  }
}

PyCallback::~PyCallback()
{
  Py_XDECREF(_callbackMethod);
}

void PyCallback::execute()
{
  PyObject *answer;
  PyGILState_STATE gstate;

  gstate = PyGILState_Ensure();
  answer = PyObject_CallFunctionObjArgs(_callbackMethod, NULL);
  if ( answer )
  {
    _debug("Succeed with PyObject_CallObject()");
    Py_XDECREF(answer);
  }
  else
  {
    _warning("PyObject_CallObject() failed");
  }
  Py_XDECREF(answer); // allowed to be null
  PyGILState_Release(gstate);
}
