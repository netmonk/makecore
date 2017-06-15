#!/bin/bash
# #############################################################################
# @(#) NetMonK Std Lib
# @(#) v1.1, 24/01/2013
# @(#} Author NetMonk, netmonk at netmonk dot org (please use gpg) 
#      http://www.netmonk.org
# #############################################################################
# #####################  licensing stuff : nBSDL ##############################
# Copyright (c) 2012, netmonk.org 
# All rights reserved.
# Redistribution and use in source and binary forms, with or without 
# modification, are permitted provided that the following conditions are met:
#
# Redistributions of source code must retain the above copyright notice, this 
# list of conditions and the following disclaimer.
# Redistributions in binary form must reproduce the above copyright notice, 
# this list of conditions and the following disclaimer in the documentation 
# and/or other materials provided with the distribution.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" 
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE 
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE 
# ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE 
# LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR 
# CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF 
# SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS 
# INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN 
# CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) 
# ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF 
# THE POSSIBILITY OF SUCH DAMAGE.
# #############################################################################
# No dependencies
# #############################################################################
# v1.2, 09/04/2013, NetMonk:
# - Adding the ${0##*/} into the output to identify the running process
# #############################################################################
# v1.1, 24/01/2013, NetMonk:
# - Fixing USECOLOR and TYPO 
# - Added MSG header for better parsing of log file (not dependant of msg type)
# #############################################################################
# v1.0, 10/10/2012, NetMonK: 
# First release
# #############################################################################
# How to use : 
# Just insert this line in the early begining of your script: 
# ". /path_to_the/lib.sh "
# and init the lib by calling : "InitLib" function  
# #############################################################################
# We have several level of message : 
# - INFO  : standard informative message 
# - LOG   : standard LOG message 
# - WARN  : message with warn tag 
# - ERR   : message with error tag
# - DEBUG : message with DEBUG tag
# All messages level are settable 
# If DEBUG is on, all other levels will be displayed by default. 
# You can set the talkative level of your script by setting the following 
# env variables : 
# ${USECOLOR}	: 0 to disable, 1 to enable
# ${DEBUG}      : 0 to disable, 1 to enable
# ${WRITEINFO}  : 0 to disable, 1 to enable
# ${WRITEWARN}  : 0 to disable, 1 to enable
# ${WRITEERR}   : 0 to disable, 1 to enable
# By Default all is enabled 
# If DEBUG mode is set, all other modes are active !! 
# #############################################################################
# Hint: if you log into a file the colored output, use 'less -r' to view it 
# #############################################################################
# list of Functions: 
# WriteInfo() 	: post message with INFO tag
# WriteLog()	: post message with LOG tag
# WriteErr()	: post message with ERROR tag
# WriteDebug()	: post message with DEBUG tag
# ExitScript()  : Exit the status and message given as argument
# CustRead()	: Print a custom message and prompt for input
# Pause()	: Standard pause (press anykey to continue)
# InitLib()	: which init functions depending of $COLOR value

# Defining colors
# For more infos on ANSI code : http://wiki.bash-hackers.org/scripting/terminalcodes
red=$(tput setaf 1)
gre=$(tput setaf 2)
yel=$(tput setaf 3)
blu=$(tput setaf 4)
cya=$(tput setaf 6)
reset=$(tput sgr0)



# Checking if ${DEBUG} is already set and setting it to 0 if not
[[ -z "${DEBUG}" ]] && DEBUG=0

# setup defaults

if [ ${DEBUG} -ne 0 ]; then
  WRITELOG=1
  WRITEINFO=1
  WRITEWARN=1
  WRITEERR=1
fi

[ -z "${WRITELOG}" ] && export WRITELOG=1
[ -z "${WRITEINFO}" ] && export WRITEINFO=1
[ -z "${WRITEWARN}" ] && export WRITEWARN=1
[ -z "${WRITEERR}" ] && export WRITEERR=1


# Colored Functions : 

WriteLogCol()
{
  [ ${WRITELOG} -eq 0 ] && return 0
  echo -e "$gre$(date +%d/%m/%Y\ %H:%M:%S:%N) ${0##*/} MSG LOG: ${1}$reset"
  return 0
}

WriteInfoCol()
{
  [ ${WRITEINFO} -eq 0 ] && return 0
  echo -e "$gre$(date +%d/%m/%Y\ %H:%M:%S:%N) ${0##*/} MSG INFO: ${1}$reset"
  return 0
}
WriteWarnCol()
{
  [ ${WRITEWARN} -eq 0 ] && return 0
  echo -e "$yel$(date +%d/%m/%Y\ %H:%M:%S:%N) ${0##*/} MSG WARNING: ${1}$reset"
  return 0
}

WriteErrCol()
{
  [ ${WRITEERR} -eq 0 ] && return 0
  echo -e "$red$(date +%d/%m/%Y\ %H:%M:%S:%N) ${0##*/} MSG ERROR: ${1}$reset"
  return 0
}

WriteDebugCol()
{
  [ ${DEBUG} -eq 0 ] && return 0
  echo -e "$cya$(date +%d/%m/%Y\ %H:%M:%S:%N) ${0##*/} MSG DEBUG: ${1}$reset"
  return 0
}

CustReadCol()
{
read -p "$(tput setaf 4)$(date +%d/%m/%Y\ %H:%M:%S:%N) ${0##*/} MSG INPUT: $1$(tput sgr0)" "${@:2}"
}



# No Color Functions : 

WriteLogNoCol()
{
  [ ${WRITELOG} -eq 0 ] && return 0
  echo "$(date +%d/%m/%Y\ %H:%M:%S:%N) ${0##*/} MSG LOG: ${1}"
  return 0
}

WriteInfoNoCol()
{
  [ ${WRITEINFO} -eq 0 ] && return 0
  echo "$(date +%d/%m/%Y\ %H:%M:%S:%N) ${0##*/} MSG INFO: ${1}"
  return 0
}

WriteWarnNoCol()
{
  [ ${WRITEWARN} -eq 0 ] && return 0
  echo "$(date +%d/%m/%Y\ %H:%M:%S:%N) ${0##*/} MSG WARNING: ${1}"
  return 0
}

WriteErrNoCol()
{
  [ ${WRITEERR} -eq 0 ] && return 0
  echo "$(date +%d/%m/%Y\ %H:%M:%S:%N) ${0##*/} MSG ERROR: ${1}"
  return 0
}

WriteDebugNoCol()
{
  [ ${DEBUG} -eq 0 ] && return 0
  echo "$(date +%d/%m/%Y\ %H:%M:%S:%N) ${0##*/} MSG DEBUG: ${1}"
  return 0
}

CustReadNoCol()
{
read -p "$(date +%d/%m/%Y\ %H:%M:%S:%N) ${0##*/} MSG INPUT: $1" "${@:2}"
}

Pause() 
{
CustRead "Press Any Key to continue" foo
}


ExitScript ()
{
  if [ -z "${1}" ]; then
    ExitStatus=0
  else
    ExitStatus="${1}"
  fi
  if [ "${ExitStatus}" -eq 0 ]; then
    if [ ! -z "${2}" ]; then
      WriteInfo "${2}"
    fi
    WriteInfo "Exiting with status '${ExitStatus}'."
  else
    if [ ! -z "${2}" ]; then
      WriteErr "${2}"
    fi
    WriteErr "Exiting with status '${ExitStatus}'."
  fi
  exit ${ExitStatus}
}



InitLib()
{
[ -z "${USECOLOR}" ] && USECOLOR=0

if [ ${USECOLOR} -eq 0 ]; then 
	WriteLog () { WriteLogNoCol "$@" ; }
	WriteWarn () { WriteWarnNoCol "$@" ; }
	WriteInfo () { WriteInfoNoCol "$@" ; }
	WriteErr () { WriteErrNoCol "$@" ; }
	WriteDebug () { WriteDebugNoCol "$@" ; }
	CustRead () { CustReadNoCol "$@" ; }
else 
	WriteLog () { WriteLogCol "$@" ; }
	WriteWarn () { WriteWarnCol "$@" ; }
	WriteInfo () { WriteInfoCol "$@" ; }
	WriteErr () { WriteErrCol "$@" ; }
	WriteDebug () { WriteDebugCol "$@" ; }
	CustRead () { CustReadCol "$@" ; }
fi 
WriteInfo "Init Lib Done"
}

