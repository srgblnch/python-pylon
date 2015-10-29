#!/usr/bin/env cython

#---- licence header
###############################################################################
## file :               PixelType.pyx
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

cdef extern from "pylon/PixelType.h" namespace "Pylon":
    cdef enum PixelType:
        PixelType_Undefined = -1,
        PixelType_Mono8,
        PixelType_Mono8signed,
        PixelType_Mono10,
        PixelType_Mono10packed,
        PixelType_Mono12,
        PixelType_Mono12packed,
        PixelType_Mono16,
        PixelType_BayerGR8,
        PixelType_BayerRG8,
        PixelType_BayerGB8,
        PixelType_BayerBG8,
        PixelType_BayerGR10,
        PixelType_BayerRG10,
        PixelType_BayerGB10,
        PixelType_BayerBG10,
        PixelType_BayerGR12,
        PixelType_BayerRG12,
        PixelType_BayerGB12,
        PixelType_BayerBG12,
        PixelType_RGB8packed,
        PixelType_BGR8packed,
        PixelType_RGBA8packed,
        PixelType_BGRA8packed,
        PixelType_RGB10packed,
        PixelType_BGR10packed,
        PixelType_RGB12packed,
        PixelType_BGR12packed,
        PixelType_BGR10V1packed,
        PixelType_BGR10V2packed,
        PixelType_YUV411packed,
        PixelType_YUV422packed,
        PixelType_YUV444packed,
        PixelType_RGB8planar,
        PixelType_RGB10planar,
        PixelType_RGB12planar,
        PixelType_RGB16planar,
        PixelType_YUV422_YUYV_Packed,
        PixelType_BayerGR12Packed,
        PixelType_BayerRG12Packed,
        PixelType_BayerGB12Packed,
        PixelType_BayerBG12Packed,
        PixelType_BayerGR16,
        PixelType_BayerRG16,
        PixelType_BayerGB16,
        PixelType_BayerBG16,
        PixelType_RGB12V1packed,
    int PixelSize(PixelType pixelType)
    bool IsMonoPacked(PixelType pixelType)
    bool IsBayerPacked(PixelType pixelType)
    bool IsYUV( PixelType pixelType)
    bool IsRGBPacked(PixelType pixelType)
    bool IsValidRGB(PixelType pixelType)
    bool IsValidBGR(PixelType pixelType)
    bool IsPacked(PixelType pixelType)
    int BitPerPixel(PixelType pixelType)
    int PixelSize( PixelType pixelType)
    bool IsMono( PixelType pixelType)
    int BitDepth(  PixelType pixelType )
    
