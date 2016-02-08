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
_formatter = logging.Formatter('%(threadId)s\t%(levelname)s\t%(asctime)s\t'\
                               '%(objname)s\t%(message)s')
_handler = logging.StreamHandler(sys.stdout)
_handler.setFormatter(_formatter)
logger.addHandler(_handler)


def trace(func):
    try:
        def decorated(self,*args,**kwargs):
            try:
                if self._trace:
                    logger.debug("TRACE: enter %s"%(func.__name__),
                                 extra={'objname':self._name,
                                        'threadId':self._threadId})
                ret = func(self,*args,**kwargs)
                if self._trace:
                    logger.debug("TRACE: %s done %s"%(func.__name__,ret),
                                 extra={'objname':self._name,
                                        'threadId':self._threadId})
                return ret
            except Exception as e:
                if self._trace:
                    logger.warning("TRACE: %s exception %s"%(func.__name__,e),
                                   extra={'objname':self._name,
                                          'threadId':self._threadId})
                raise e
        return decorated
    except Exception as e:
        logger.error("TRACE: Decorator for %s exception: %s"%(func.__name__,e),
                     extra={'objname':None,
                            'threadId':_currentThread().getName()})
        return func


cdef class Logger(object):
    '''This class is a very basic debugging flag mode used as a super class
       for the other classes in this library.
    '''

    cdef public:
        string _name
        bool _trace

    #FIXME: default log level should not be debug in production
    def __init__(self,debug=True,trace=False):
        super(Logger,self).__init__()
        self.name = "Logger"
        self._trace = trace
        if debug or trace:
            logger.setLevel(logging.DEBUG)
#             if self._trace:
#                 self._info("set logging level to TRACE")
#             else:
#                 self._info("set logging level to DEBUG")
            if not debug and trace:
                self._warning("Trace forces to have debug level")
        else:
            logger.setLevel(logging.INFO)

    #Instead of property decorator, because the setter didn't work.
    def _getName(self):
        return self._name
    def _setName(self,name):
        self._name = name
    name = property(_getName,_setName)

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

