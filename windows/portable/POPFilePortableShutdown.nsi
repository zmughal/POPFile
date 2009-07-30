#-------------------------------------------------------------------------------------------
#
# POPFilePortableShutdown.nsi --- A simple front-end to the silent shutdown utility
#                                 for POPFilePortable. Provided as an alternative to
#                                 the system tray icon's "Quit POPFile" option.
#
# Copyright (c) 2009  John Graham-Cumming
#
#   This file is part of POPFile
#
#   POPFile is free software; you can redistribute it and/or modify it
#   under the terms of version 2 of the GNU General Public License as
#   published by the Free Software Foundation.
#
#   POPFile is distributed in the hope that it will be useful,
#   but WITHOUT ANY WARRANTY; without even the implied warranty of
#   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#   GNU General Public License for more details.
#
#   You should have received a copy of the GNU General Public License
#   along with POPFile; if not, write to the Free Software
#   Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
#-------------------------------------------------------------------------------------------

  ; This version of the script has been tested with the "NSIS v2.45" compiler,
  ; released 6 June 2009. This particular compiler can be downloaded from
  ; http://prdownloads.sourceforge.net/nsis/nsis-2.45-setup.exe?download

  !define C_EXPECTED_VERSION  "v2.45"

  !define ${NSIS_VERSION}_found

  !ifndef ${C_EXPECTED_VERSION}_found
      !warning \
          "$\r$\n\
          $\r$\n***   NSIS COMPILER WARNING:\
          $\r$\n***\
          $\r$\n***   This script has only been tested using the \
                      NSIS ${C_EXPECTED_VERSION} compiler\
          $\r$\n***   and may not work properly with this NSIS ${NSIS_VERSION} compiler\
          $\r$\n***\
          $\r$\n***   The resulting 'installer' program should be tested carefully!\
          $\r$\n$\r$\n"
  !endif

  !undef  ${NSIS_VERSION}_found
  !undef  C_EXPECTED_VERSION

  ;--------------------------------------------------------------------------
  ; Select LZMA compression to reduce output file size
  ;--------------------------------------------------------------------------

  SetCompressor lzma

  ;--------------------------------------------------------------------------
  ; Symbols used to avoid confusion over where the line breaks occur.
  ;
  ; ${IO_NL} is used for InstallOptions-style 'new line' sequences.
  ; ${MB_NL} is used for MessageBox-style 'new line' sequences.
  ;
  ; (these two constants do not follow the 'C_' naming convention described below)
  ;--------------------------------------------------------------------------

  !define IO_NL   "\r\n"
  !define MB_NL   "$\r$\n"

  ;--------------------------------------------------------------------------
  ; POPFile constants have been given names beginning with 'C_' (eg C_README)
  ;--------------------------------------------------------------------------

  !define C_VERSION   "0.0.1"     ; see 'VIProductVersion' comment below for format details

  !define C_OUTFILE   "POPFilePortableShutdown.exe"

  Name "POPFile Portable Shutdown utility"

  ; Specify EXE filename and icon for the 'installer'

  OutFile "${C_OUTFILE}"

  ; Ensure user cannot use the /NCRC command-line switch to disable CRC checking

  CRCcheck Force

  Icon "..\shutdown.ico"

  ; Selecting 'silent' mode makes the installer behave like a command-line utility

  SilentInstall silent

  ;--------------------------------------------------------------------------
  ; Windows Vista expects to find a manifest specifying the execution level
  ;--------------------------------------------------------------------------

  RequestExecutionLevel   user

  ;--------------------------------------------------------------------------
  ; Include private library functions and macro definitions
  ;--------------------------------------------------------------------------

  ; Avoid compiler warnings by disabling the functions and definitions we do not use

  !define SHUTDOWN

  !include "ppl-library.nsh"

  ;--------------------------------------------------------------------------
  ; Add VersionInfo to the executable file
  ;--------------------------------------------------------------------------

  ; 'VIProductVersion' format is X.X.X.X where X is a number in range 0 to 65535
  ; representing the following values: Major.Minor.Release.Build

  VIProductVersion                          "${C_VERSION}.0"

  !define /date C_BUILD_YEAR                "%Y"

  VIAddVersionKey "ProductName"             "POPFilePortable Shutdown utility"
  VIAddVersionKey "Comments"                "POPFile Homepage: http://getpopfile.org/"
  VIAddVersionKey "CompanyName"             "The POPFile Project"
  VIAddVersionKey "LegalTrademarks"         "POPFile is a registered trademark of \
                                             John Graham-Cumming"
  VIAddVersionKey "LegalCopyright"          "Copyright (c) ${C_BUILD_YEAR} John Graham-Cumming"
  VIAddVersionKey "FileDescription"         "Simple front-end to stop_pf.exe"
  VIAddVersionKey "FileVersion"             "${C_VERSION}"
  VIAddVersionKey "OriginalFilename"        "${C_OUTFILE}"

  VIAddVersionKey "Build Compiler"          "NSIS ${NSIS_VERSION}"
  VIAddVersionKey "Build Date/Time"         "${__DATE__} @ ${__TIME__}"
  !ifdef C_PPL_LIBRARY_VERSION
    VIAddVersionKey "PPL Library Version"   "${C_PPL_LIBRARY_VERSION}"
  !endif
  VIAddVersionKey "Build Script"            "${__FILE__}${MB_NL}(${__TIMESTAMP__})"

#----------------------------------------------------------------------------------------

Section default

  !define L_GUI   $R9

  IfFileExists "$EXEDIR\App\POPFile\stop_pf.exe" get_ui_port
  MessageBox MB_OK|MB_ICONSTOP "Cannot find the silent shutdown utility in expected location:\
      ${MB_NL}${MB_NL}\
      '$EXEDIR\App\POPFile\stop_pf.exe'"
  Goto exit

get_ui_port:
  Push "$EXEDIR\Data\popfile.cfg"
  Push "html_port"
  Call PPL_CfgSettingRead
  Pop ${L_GUI}
  IfErrors 0 silent_shutdown
  MessageBox MB_OK|MB_ICONSTOP "Cannot find the UI port setting in configuration file:\
      ${MB_NL}${MB_NL}\
      '$EXEDIR\Data\popfile.cfg'"
  Goto exit

silent_shutdown:
  Exec '"$EXEDIR\App\POPFile\stop_pf.exe" /showerrors ${L_GUI}'

exit:

  !undef L_GUI

SectionEnd

;--------------------------------------
; End of 'POPFilePortableShutdown.nsi'
;--------------------------------------
