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
  std::string strMethodName(methodName);

  _name = "PyCallback(" + parentName + ")";
  Py_Initialize();
  Py_XINCREF(self);
  _self = self;

  if ( PyObject_HasAttrString(self, methodName) == 1)
  {
    _method = PyObject_GetAttrString(self, methodName);
    if ( _method && PyCallable_Check(_method) )
    {
      _name = "PyCallback(" + parentName + "." + strMethodName + ")";
    }
    else
    {
      _error("The callback attribute is not callable");
    }
  }
  else
  {
    _method = NULL;
    _error("method " + strMethodName + " not present");
  }
}

PyCallback::~PyCallback()
{
  Py_XDECREF(_self);
  Py_Finalize();
}

void PyCallback::execute()
{
  PyGILState_STATE gstate;

  gstate = PyGILState_Ensure();
  try
  {
    if ( _method && PyCallable_Check(_method) )
    {
      _debug("Build arguments for the call");
      PyObject *args = Py_BuildValue("(O)", _self);
      PyObject *kwargs = Py_BuildValue("{}", "", NULL);
      _debug("Executing the callback");
      PyObject_Call(_method, args, kwargs);
    }
    else
    {
      _warning("The given method is not callable!");
    }
  }
  catch(...)
  {
    // TODO: collect and show more information about the exception
    _error("Exception calling python");
  }
  PyGILState_Release(gstate);
}
