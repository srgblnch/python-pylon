###############################################################################
## file :               logger.py
##
## description :        Python module to provide scpi functionality to an 
##                      instrument.
##
## project :            scpi
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
## You should have received a copy of the GNU General Public License
## along with Tango.  If not, see <http:##www.gnu.org/licenses/>.
##
###############################################################################

from datetime import datetime as _datetime
from threading import currentThread as _currentThread
from threading import Lock as _Lock
from weakref import ref as _weakref

global lock
lock  = _Lock()

_logger_ERROR   = 1
_logger_WARNING = 2
_logger_INFO    = 3
_logger_DEBUG   = 4

cdef class Logger(object):
    '''This class is a very basic debugging flag mode used as a super class
       for the other classes in this library.
    '''

    _type = {_logger_ERROR:  'ERROR',
             _logger_WARNING:'WARNING',
             _logger_INFO:   'INFO',
             _logger_DEBUG:  'DEBUG'}
    cdef string _name
    cdef bool _debugFlag

    def __init__(self,debug=True):
        super(Logger,self).__init__()
        self._name = "Logger"
        self._debugFlag = debug

    @property
    def _threadId(self):
        return _currentThread().getName()

    def _print(self,msg,type):
        with lock:
            when = _datetime.now().strftime("%Y-%m-%d %H:%M:%S.%f")
            print("%s\t%s\t%s\t%s\t%s"%(self._threadId,type,when,self._name,msg))

    def _error(self,msg):
        self._print(msg,self._type[_logger_ERROR])

    def _warning(self,msg):
        self._print(msg,self._type[_logger_WARNING])

    def _info(self,msg):
        self._print(msg,self._type[_logger_INFO])

    def _debug(self,msg):
        if self._debugFlag:
            self._print(msg,self._type[_logger_DEBUG])

