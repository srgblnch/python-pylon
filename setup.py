#!/usr/bin/env python

#---- licence header
###############################################################################
## file :               setup.py
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

#import pyximport; pyximport.install()

from pylon.version import version_python_pylon_string

from Cython.Distutils import build_ext
from distutils.core import setup
from distutils.extension import Extension

pylonExtension = Extension('pylon',['pylon/__init__.pyx',
                                    'pylon/Logger.cpp',
                                    'pylon/Factory.cpp',
                                    'pylon/DevInfo.cpp',
                                    'pylon/Camera.cpp',
                                    'pylon/TransportLayer.cpp',
                                    'pylon/GenApiWrap/INode.cpp',
                                    'pylon/GenApiWrap/ICategory.cpp',
                                    'pylon/GenApiWrap/IEnumeration.cpp',
                                    'pylon/PyCallback.cpp'],
                           language="c++",
                           extra_compile_args=[#"-static",
                                               #"-fPIC",
                                               #"-std=c++11",
                                              ]
                           )

#FIXME: check how can be know if c++11 is available to be used

setup(name = 'pylon',
      license = "LGPLv3+",
      description = "Cython module to provide access to Pylon's SDK.",
      version = version_python_pylon_string(),
      author = "Sergi Blanch-Torn\'e",
      author_email = "sblanch@cells.es",
      classifiers = ['Development Status :: 1 - Planning',
                     'Intended Audience :: Science/Research',
                     'License :: OSI Approved :: '\
                     'GNU Lesser General Public License v3 or later (LGPLv3+)',
                     'Operating System :: POSIX',
                     'Programming Language :: Cython',
                     'Programming Language :: Python',
                     'Topic :: Scientific/Engineering :: '\
                        'Interface Engine/Protocol Translator',
                     'Topic :: Software Development :: Embedded Systems',
                     'Topic :: Software Development :: Libraries :: '\
                        'Python Modules',
                     'Topic :: Multimedia :: Graphics :: Capture',
                     'Topic :: Multimedia :: Video :: Capture',
                     ''],
      url="https://github.com/srgblnch/python-pylon",
      cmdclass = {'build_ext': build_ext},
      ext_modules=[pylonExtension],
      #install_requires=['cython>=0.20.1'],
)

#for the classifiers review see:
#https://pypi.python.org/pypi?%3Aaction=list_classifiers
#
#Development Status :: 1 - Planning
#Development Status :: 2 - Pre-Alpha
#Development Status :: 3 - Alpha
#Development Status :: 4 - Beta
#Development Status :: 5 - Production/Stable
