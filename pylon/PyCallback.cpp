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
  std::string str(methodName);

  _name = "PyCallback(" + parentName + "." + str + ")";
  Py_Initialize();
  Py_XINCREF(self);
  _self = self;
  _method = PyObject_GetAttrString(self, methodName);
  if ( ! PyCallable_Check(_method) )
  {
    _error("The callback attribute is not callable");
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
    // option 0:
    //_method(_self);
    // compilation error: "expression cannot be used as a function"

    // option 1:
    //_self->_method();
    // compilation error: "’PyObject’ has no member named ‘_method’"

    //// options based in the python c-api:

    // option 2:
    //PyObject *args = Py_BuildValue("(O)", _self);
    //PyObject *kwargs = Py_BuildValue("{}", "", NULL);
    //PyObject_Call(_method, args, kwargs);
    // segfault in PyObject_Call

    // option 3:
    if ( PyCallable_Check(_method) )
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

    //_info("build arguments");
    //PyObject *args = Py_BuildValue("o", _self);
    //PyObject *args = PyTuple_Pack(1,_self);
    //PyObject *args = PyTuple_Pack(0, NULL);
    //PyObject *kwargs = PyTuple_Pack(0, NULL);
    //_debug("callObject");
    //PyObject_Call(_method, args, kwargs);
    //PyObject_CallObject(_method, args);
    //PyObject_CallObject(_method, NULL);
    //PyObject_CallFunctionObjArgs(_method, NULL);
    //PyObject_CallFunctionObjArgs(_method, _self, NULL);
    //PyObject_CallFunctionObjArgs(_method, args, NULL);
    //_debug("callback execution done!");
  }
  catch(...)
  {
    // TODO: collect and show more information about the exception
    _error("Exception calling python");
  }
  PyGILState_Release(gstate);
}
