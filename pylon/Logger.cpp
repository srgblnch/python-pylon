/*---- licence header
###############################################################################
## file :               Logger.cpp
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

#include "Logger.h"

//FIXME: subclasses shall set value to _name variable

Logger::Logger()
  :_logLevel(_logger_DEBUG) { }

Logger::Logger(LogLevel level)
  :_logLevel(level) { }

Logger::~Logger() { }

void Logger::_error(std::string msg)
{
  if (_logLevel >= _logger_ERROR)
  {
    _print(msg,"ERROR");
  }
}

void Logger::_warning(std::string msg)
{
  if (_logLevel >= _logger_WARNING)
  {
    _print(msg,"WARNING");
  }
}

void Logger::_info(std::string msg)
{
  if (_logLevel >= _logger_INFO)
  {
    _print(msg,"INFO");
  }
}

void Logger::_debug(std::string msg)
{
  if (_logLevel >= _logger_DEBUG)
  {
    _print(msg,"DEBUG");
  }
}

void Logger::_print(std::string msg,std::string levelTag)
{
#if __cplusplus > 199711L
  std::thread::id threadId = std::this_thread::get_id();
  std::chrono::time_point<std::chrono::system_clock> when = \
      std::chrono::system_clock::now();
  //print("%s\t%s\t%s\t%s\t%s"%(self._threadId,type,when,self._name,msg))
  std::cout \
      << threadId << "\t" \
      << levelTag << "\t" \
      << when << "\t" \
      << _name << "\t" \
      << msg << "\t" \
      << std::endl;
#else
  time_t     now = time(0);
  struct tm  tstruct;
  char       buf[80];
  tstruct = *localtime(&now);
  strftime(buf, sizeof(buf), "%Y-%m-%d %X", &tstruct);

  std::cout \
      << pthread_self() << "\t" \
      << levelTag << "\t" \
      << buf << "\t" \
      << _name << "\t" \
      << msg << "\t" \
      << std::endl;
#endif
}
