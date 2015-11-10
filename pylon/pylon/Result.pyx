#!/usr/bin/env cython

#---- licence header
###############################################################################
## file :               Result.pyx
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


cdef extern from "pylon/Result.h" namespace "Pylon":
    cdef enum GrabStatus: Idle, Queued, Grabbed, Canceled, Failed
    cdef enum PayloadType: PayloadType_Undefined = -1, PayloadType_Image,\
                           PayloadType_RawData, PayloadType_File,\
                           PayloadType_ChunkData, PayloadType_DeviceSpecific
    cdef cppclass GrabResult:
        GrabResult() except +
        bool Succeeded() except +
        void* Buffer() except +
        GrabStatus Status() except +
        void* Context() except +
        uint32_t FrameNr() except +
        PayloadType GetPayloadType() except +
        PixelType GetPixelType() except +
        uint64_t GetTimeStamp() except +
        int32_t GetSizeX() except +
        int32_t GetSizeY() except +
        int32_t GetOffsetX() except +
        int32_t GetOffsetY() except +
        int32_t GetPaddingX() except +
        int32_t GetPaddingY() except +
        int64_t GetPayloadSize() except +
        size_t GetPayloadSize_t() except +
        uint32_t GetErrorCode() except +
    cdef cppclass EventResult:
        EventResult() except +
        bool Succeeded() except +
        String_t ErrorDescription() except +
        unsigned long ErrorCode() except +
        unsigned char Buffer[576]

