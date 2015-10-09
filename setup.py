#!/usr/bin/env python

#---- licence header
###############################################################################
## file :               setup.py
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

import pyximport; pyximport.install()

from pylon.version import pyversionstr

from Cython.Build import cythonize
from Cython.Distutils import build_ext
from Cython import Distutils
from distutils.core import setup
from distutils.extension import Extension
import numpy as np


setup(name = 'pylon',
      license = "GPLv3+",
      description = "Cython module to provide access to Pylon's SDK.",
      version = pyversionstr(),
      author = "Sergi Blanch-Torn\'e",
      author_email = "sblanch@cells.es",
      classifiers = ['Development Status :: 1 - Planning',
                     'Intended Audience :: Science/Research',
                     'License :: OSI Approved :: '\
                        'GNU General Public License v3 or later (GPLv3+)',
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
      ext_modules=[Extension('pylon',['pylon/__init__.pyx'],language='c++')],
      #install_requires=['cython>=0.21.1'],
)

#for the classifiers review see:
#https://pypi.python.org/pypi?%3Aaction=list_classifiers
#
#Development Status :: 1 - Planning
#Development Status :: 2 - Pre-Alpha
#Development Status :: 3 - Alpha
#Development Status :: 4 - Beta
#Development Status :: 5 - Production/Stable
