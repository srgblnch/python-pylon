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
    cdef enum EVisibility:
        Beginner = 0
        Expert = 1
        Guru = 2
        Invisible = 3
        _UndefinedVisibility  = 99
    cdef enum EAccessMode:
        NI,        #!< Not implemented
        NA,        #!< Not available
        WO,        #!< Write Only
        RO,        #!< Read Only
        RW,        #!< Read and Write
        _UndefinedAccesMode,    #!< Object is not yetinitialized
        _CycleDetectAccesMode   #!< used internally for AccessMode cycle detection
    cdef enum EInterfaceType:
        intfIValue, #//!> IBase interface
        intfIBase, #//!> IBase interface
        intfIInteger, #//!> IInteger interface
        intfIBoolean, #//!> IBoolean interface
        intfICommand, #//!> IBoolean interface
        intfIFloat, #//!> IFloat interface
        intfIString, #//!> IString interface
        intfIRegister, #//!> IRegister interface
        intfICategory, #//!> ICategory interface
        intfIEnumeration, #//!> IEnumeration interface
        intfIEnumEntry, #//!> IEnumEntry interface
        intfIPort, #//!> IPort interface

def VisibilityEnum():
    visibilityEnum = [Beginner,Expert,Guru,Invisible,_UndefinedVisibility]
    for element in visibilityEnum:
        yield element

def VisibilityToStr(value):
    return {Beginner:'Beginner',
            Expert:'Expert',
            Guru:'Guru',
            Invisible:'Invisible',
            _UndefinedVisibility:'Undefined'}[value]

def VisibilityFromStr(value):
    return {'Beginner':Beginner,
            'Expert':Expert,
            'Guru':Guru,
            'Invisible':Invisible}[value] or _UndefinedVisibility

# def AccessModeToStr(value):
#     if value == _UndefinedAccesMode:
#         raise ReferenceError("Object is not yetinitialized")
#     elif value == _CycleDetectAccesMode:
#         raise LookupError("used internally for AccessMode cycle detection")
#     return {NI:'Not implemented',
#             NA:'Not available',
#             WO:'Write Only',
#             RO:'Read Only',
#             RW:'Read and Write'}[value]
# 
# def AccessModeFromStr(value):
#     return {'Not implemented':NI,
#             'Not available':NA,
#             'Write Only':WO,
#             'Read Only':RO,
#             'Read and Write':RW}[value]

def InterfaceTypeToStr(value):
    return {intfIValue:'IValue',
            intfIBase:'IBase',
            intfIInteger:'IInteger',
            intfIBoolean:'IBoolean',
            intfICommand:'IBoolean',
            intfIFloat:'IFloat',
            intfIString:'IString',
            intfIRegister:'IRegister',
            intfICategory:'ICategory',
            intfIEnumeration:'IEnumeration',
            intfIEnumEntry:'IEnumEntry',
            intfIPort:'IPort'}[value]

def InterfaceTypeFromStr(value):
    return {'IValue':intfIValue,
            'IBase':intfIBase,
            'IInteger':intfIInteger,
            'IBoolean':intfIBoolean,
            'IBoolean':intfICommand,
            'IFloat':intfIFloat,
            'IString':intfIString,
            'IRegister':intfIRegister,
            'ICategory':intfICategory,
            'IEnumeration':intfIEnumeration,
            'IEnumEntry':intfIEnumEntry,
            'IPort':intfIPort}[value]
            