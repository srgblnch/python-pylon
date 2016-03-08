#!/usr/bin/env cython

#---- licence header
###############################################################################
## file :               Types.pyx
##
## description :        This file has been made to provide a python access to
##                      the Pylon SDK from python.
##
## project :            TANGO
##
## author(s) :          S.Blanch-Torn\'e
##
## Copyright (C) :      2015
##                      CELLS / ALBA Synchrotron,
##                      08290 Bellaterra,
##                      Spain
##
## This file is part of Tango.
##
## Tango is free software: you can redistribute it and/or modify
## it under the terms of the GNU Lesser General Public License as published by
## the Free Software Foundation, either version 3 of the License, or
## (at your option) any later version.
##
## Tango is distributed in the hope that it will be useful,
## but WITHOUT ANY WARRANTY; without even the implied warranty of
## MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
## GNU Lesser General Public License for more details.
##
## You should have received a copy of the GNU Lesser General Public License
## along with Tango.  If not, see <http:##www.gnu.org/licenses/>.
##
###############################################################################

cdef extern from "GenApi/Types.h" namespace "GenApi":
    ctypedef enum EVisibility:
        Beginner = 0,              # Always visible
        Expert = 1,                # Visible for experts or Gurus
        Guru = 2,                  # Visible for Gurus
        Invisible = 3,             # Not Visible
        _UndefinedVisibility  = 99 # Object is not yetinitialized
    ctypedef enum EInterfaceType:
        intfIValue,       # IBase interface
        intfIBase,        # IBase interface
        intfIInteger,     # IInteger interface
        intfIBoolean,     # IBoolean interface
        intfICommand,     # IBoolean interface
        intfIFloat,       # IFloat interface
        intfIString,      # IString interface
        intfIRegister,    # IRegister interface
        intfICategory,    # ICategory interface
        intfIEnumeration, # IEnumeration interface
        intfIEnumEntry,   # IEnumEntry interface
        intfIPort,        # IPort interface
    ctypedef enum EAccessMode:
        AccessMode_NI,        # Not implemented
        AccessMode_NA,        # Not available
        AccessMode_WO,        # Write Only
        AccessMode_RO,        # Read Only
        AccessMode_RW,        # Read and Write
        _UndefinedAccesMode,    # Object is not yetinitialized
        _CycleDetectAccesMode   # used internally for AccessMode cycle detection


cdef class Visibility(Logger):
    cdef:
        EVisibility _value
        object _parent
    visibilityIntegers = {Beginner:'Beginner',Expert:'Expert',Guru:'Guru'}
    visibilityStrings = {'Beginner':Beginner,'Expert':Expert,'Guru':Guru}

    def __init__(self,*args,**kwargs):
        super(Visibility,self).__init__(*args,**kwargs)
        self.name = "None:Visibility"
        self.value = Beginner

    def __str__(self):
        return self.name

    property parent:
        def __get__(self):
            return self._parent
        def __set__(self,parent):
            self._parent = parent
            if not parent == None:
                self.name = "%s:Visibility" % (self._parent.name)
            else:
                self.name = "None:Visibility"

    property numValue:
        def __get__(self):
            return self._value

    property validValues:
        def __get__(self):
            return self.visibilityStrings.keys()

    property value:
        def __get__(self):
            return self.visibilityIntegers[self._value]
        def __set__(self,value):
            if type(value) == int:
                if value in self.visibilityIntegers.keys():
                    if not self._value == value:
                        self._debug("Changing visibility from %s to %s"
                                    %(self.visibilityIntegers[self._value],
                                      self.visibilityIntegers[value]))
                        self._value = value
                    return
            elif type(value) == str:
                if value.capitalize() in self.visibilityStrings.keys():
                    if not self._value == \
                    self.visibilityStrings[value.capitalize()]:
                        self._debug("Changing visibility from %s to %s"
                                    %(self.visibilityIntegers[self._value],
                                      value))
                        self._value = \
                        self.visibilityStrings[value.capitalize()]
                    return
            raise TypeError("Invalid visibility %d (%s)"
                            % (value,self.validValues))


cdef class InterfaceType(Logger):
    cdef:
        EInterfaceType _value
        INode* _parent
    interfaceTypeIntegers = {intfIValue:'IValue',
                             intfIBase:'IBase',
                             intfIInteger:'IInteger',
                             intfIBoolean:'IBoolean',
                             intfICommand:'ICommand',
                             intfIFloat:'IFloat',
                             intfIString:'IString',
                             intfIRegister:'IRegister',
                             intfICategory:'ICategory',
                             intfIEnumeration:'IEnumeration',
                             intfIEnumEntry:'IEnumEntry',
                             intfIPort:'IPort'}
    interfaceTypeStrings = {'IValue':intfIValue,
                            'IBase':intfIBase,
                            'IInteger':intfIInteger,
                            'IBoolean':intfIBoolean,
                            'ICommand':intfICommand,
                            'IFloat':intfIFloat,
                            'IString':intfIString,
                            'IRegister':intfIRegister,
                            'ICategory':intfICategory,
                            'IEnumeration':intfIEnumeration,
                            'IEnumEntry':intfIEnumEntry,
                            'IPort':intfIPort}

    def __init__(self,*args,**kwargs):
        super(InterfaceType,self).__init__(*args,**kwargs)
        self.name = "None:InterfaceType"

    def __str__(self):
        return self.name

    cdef setParent(self,INode* parent):
        self._parent = parent
        if not parent == NULL:
            self.name = "%s:InterfaceType" % (self._parent.GetName())
        else:
            self.name = "None:InterfaceType"

    property numValue:
        def __get__(self):
            return self._parent.GetPrincipalInterfaceType()

    property value:
        def __get__(self):
            return self.interfaceTypeIntegers[self.numValue]

