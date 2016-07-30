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

PyCallback::PyCallback(PyObject* self, const char* methodName)
{
  Py_XINCREF(self);
  _self = self;
  _method = PyObject_GetAttrString(self, methodName);
}

PyCallback::~PyCallback()
{
  Py_XDECREF(_self);
}

void PyCallback::execute()
{
  _debug("Executing callback");
  try
  {
    //_info("build arguments");
    //PyObject *args = Py_BuildValue("(self)", _self);
    //PyObject *args = PyTuple_Pack(1,_self);
    //PyObject *args = PyTuple_Pack(0, NULL);
    //PyObject *kwargs = PyTuple_Pack(0, NULL);
    _debug("callObject");
    //PyObject_Call(_method, args, kwargs);
    //PyObject_CallObject(_method, args);
    //PyObject_CallObject(_method, NULL);
    //PyObject_CallFunctionObjArgs(_method, args);
    PyObject_CallFunctionObjArgs(_method, _self, NULL);
    _debug("callback execution done!");
  }
  catch(...)
  {
    // TODO: collect and show more information about the exception
    _error("Exception calling python");
  }
}
