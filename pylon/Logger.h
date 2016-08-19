/*---- licence header
###############################################################################
## file :               Logger.h
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

#ifndef LOGGER_H
#define LOGGER_H

#include <iostream>
#if __cplusplus > 199711L
#include <thread>       /* std::thread::id */
#include <chrono>       /* std::chrono::system_clock::now */
#else
#include <pthread.h>
#include <ctime>
#endif

typedef enum {
  _logger_ERROR = 1,
  _logger_WARNING = 2,
  _logger_INFO    = 3,
  _logger_DEBUG   = 4,
} LogLevel;

class Logger
{
public:
  Logger();
  Logger(LogLevel);
  virtual ~Logger();
  void _error(std::string);
  void _warning(std::string);
  void _info(std::string);
  void _debug(std::string);
protected:
  void _print(std::string,std::string);
  std::string _name;
private:
  LogLevel _logLevel;
};

#endif /* LOGGER_H */
