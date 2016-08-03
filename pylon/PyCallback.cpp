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
  _self = self;
  Py_XINCREF(_self);

  if ( PyObject_HasAttrString(self, methodName) )
  {
      _method = PyObject_GetAttrString(self, methodName);
    if ( _method && PyCallable_Check(_method) )
    {
      _name = "PyCallback(" + parentName + "." + methodName + ")";
      _debug("Build the callback object successful");
    }
    else
    {
      _error("The callback attribute is not callable");
    }
  }
  else
  {
    _method = NULL;
    _error("method not present");
  }
}

PyCallback::~PyCallback()
{
  Py_XDECREF(_self);
  if ( _method )
  {
    Py_XDECREF(_method);
  }
}

void PyCallback::execute()
{
  PyObject *answer;

  if ( _method )
  {
    PyObject *args = Py_BuildValue("O", _self);
    PyObject *kwargs = (PyObject *)NULL;
    //answer = PyObject_Call(_method, args, kwargs);
    Py_XDECREF(args);
    Py_XDECREF(kwargs);
    if ( answer )
    {
      _debug("Succeed with PyObject_CallObject()");
      Py_XDECREF(answer);
    }
    else
    {
      _warning("PyObject_CallObject() failed");
    }
  }

}
