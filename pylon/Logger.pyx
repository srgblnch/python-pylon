###############################################################################
## file :               logger.py
##
## description :        Python module to provide scpi functionality to an 
##                      instrument.
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

from datetime import datetime as _datetime
import logging
import sys
from threading import currentThread as _currentThread
from weakref import ref as _weakref

cdef object _logger,_handler,_formatter
global logger
logger = logging.getLogger()
_formatter = logging.Formatter('%(threadId)s\t%(asctime)s\t%(levelname)s\t'\
                               '%(objname)s\t%(message)s')
_handler = logging.StreamHandler(sys.stdout)
_handler.setFormatter(_formatter)
logger.addHandler(_handler)


def trace(func):
    def decorated(self,*args):
        try:
            logger.debug("TRACE: enter %s"%(func.__name__),
                         extra={'objname':self._name,
                                'threadId':self._threadId})
            ret = func(self,*args)
            logger.debug("TRACE: %s done %s"%(func.__name__,ret),
                         extra={'objname':self._name,
                                'threadId':self._threadId})
            return ret
        except Exception as e:
            logger.warning("TRACE: %s exception %s"%(func.__name__,e),
                           extra={'objname':self._name,
                                  'threadId':self._threadId})
            raise e
    return decorated


cdef class Logger(object):
    '''This class is a very basic debugging flag mode used as a super class
       for the other classes in this library.
    '''

    cdef public:
        string _name
#         bool _debugFlag

    def __init__(self,debug=True):
        super(Logger,self).__init__()
        self._setName("Logger")
#         self._debugFlag = debug
        if debug:
            logger.setLevel(logging.DEBUG)
        else:
            logger.setLevel(logging.INFO)

    @property
    def name(self):
        return self._name
    #@name.setter
    #def name(self,name):
    def _setName(self,name):
        self._name = name

    @property
    def _threadId(self):
        try:
            return _currentThread().getName()
        except Exception as e:
            logger.debug("Couldn't get the thread id: %s"%(e))
        return ""

    def _critical(self,msg):
        threadId = self._threadId
        logger.critical(msg,extra={'objname':self._name,'threadId':threadId})

    def _error(self,msg):
        threadId = self._threadId
        logger.error(msg,extra={'objname':self._name,'threadId':threadId})

    def _warning(self,msg):
        threadId = self._threadId
        logger.warning(msg,extra={'objname':self._name,'threadId':threadId})

    def _info(self,msg):
        threadId = self._threadId
        logger.info(msg,extra={'objname':self._name,'threadId':threadId})

    def _debug(self,msg):
        threadId = self._threadId
        logger.debug(msg,extra={'objname':self._name,'threadId':threadId})

