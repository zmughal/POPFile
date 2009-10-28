#-------------------------------------------------------------------------------------------
#
# OnDemand.nsi ---  An 'invisible' utility which starts POPFile, starts an email client,
#                   waits for the email client to shutdown and then shuts down POPFile.
#                   Provided as an alternative to having POPFile running all the time.
#
#                   If POPFile's database is very large it can take POPFile several seconds
#                   to start up so an optional delay can be inserted between starting POPFile
#                   and starting the email client (to avoid problems if the email client looks
#                   for new mail before POPFile is ready to accept commands).
#
# Copyright (c) 2005-2009 John Graham-Cumming
#
#   This file creates a utility for use with POPFile.
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
          $\r$\n***   This script has only been tested using the NSIS ${C_EXPECTED_VERSION} compiler\
          $\r$\n***   and may not work properly with this NSIS ${NSIS_VERSION} compiler\
          $\r$\n***\
          $\r$\n***   The resulting 'installer' program should be tested carefully!\
          $\r$\n$\r$\n"
  !endif

  !undef  ${NSIS_VERSION}_found
  !undef  C_EXPECTED_VERSION

  ;--------------------------------------------------
  ; This script requires the 'LockedList' NSIS plugin
  ;--------------------------------------------------

  ; In order to allow this utility to check if a particular executable file is in use
  ; a special NSIS plugin (LockedList) is used. This plugin replaces the previous
  ; detection method because the old method always reported that a file was locked if
  ; the utility was run by a user without administrator rights (even if the file in
  ; question was not in use).
  ;
  ; The 'NSIS Wiki' page for the 'LockedList' plugin (description and download links):
  ; http://nsis.sourceforge.net/LockedList_plug-in
  ;
  ; To compile this script, copy the 'LockedList.dll' file to the standard NSIS plugins folder
  ; (${NSISDIR}\Plugins\). The 'LockedList' source and example files can be unzipped to the
  ; appropriate ${NSISDIR} sub-folders if you wish, but this step is entirely optional.
  ;
  ; Tested using LockedList plugin v0.7 (RC2) timestamped 26 February 2008 17:49:24

#-------------------------------------------------------------------------------------------
# Parameters are supplied via an INI file stored in the same folder as this utility:
#
#     [Mail Client]
#     Executable=C:\Program Files\Outlook Express\msimn.exe
#     Parameters=
#
#     [Settings]
#     StartupDelay=15
#     StopPOPFile=yes
#
# Notes:
#
#   (1) 'Executable' is the full pathname of the email client program
#
#   (2) 'Parameters' specifies any optional parameters to be passed to the email
#       client (e.g. Eudora can be told where to find its configuration data)
#
#   (3) 'StartupDelay' specifies the delay (in seconds) between starting POPFile
#       and starting the email client. If this parameter is not supplied a delay
#       of zero is assumed. The delay value should only contain the digits 0 to 9.
#
#   (4) StopPOPFile' can be either "yes" or "no". If this parameter is missing
#       then "no" is assumed so POPFile will be shut down when the email client exits.
#
# The INI file must specify the 'Executable' parameter. If any of the other parameters
# are missing then default values will be used.
#
#-------------------------------------------------------------------------------------------

  ;--------------------------------------------------------------------------
  ; Select "one block" LZMA compression (to generate smallest EXE file)
  ;--------------------------------------------------------------------------

  SetCompressor /SOLID lzma

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

  ; This build is for use with installer-created installations of POPFile 0.21.0 or later

  !define C_PFI_PRODUCT  "POPFile"

  ;--------------------------------------------------------------------------
  ; Specify filename for the EXE and INI files
  ;--------------------------------------------------------------------------

  !define C_OUTFILE "OnDemand.exe"
  !define C_INIFILE "OnDemand.ini"

  ;--------------------------------------------------------------------------

  Name    "Run POPFile & email client on demand"
  Caption "$(^Name)"        ; used in the title bar of any message boxes the utility displays

  OutFile ${C_OUTFILE}

  !define C_VERSION   "0.1.6"

  ; Specify the icon file for the utility

  Icon "OnDemand.ico"

  ; Selecting 'silent' install makes 'installer' behave like a command-line utility

  SilentInstall silent

  ;--------------------------------------------------------------------------
  ; Windows Vista expects to find a manifest specifying the execution level
  ;--------------------------------------------------------------------------

  RequestExecutionLevel   user

#--------------------------------------------------------------------------
# User Registers (Global)
#--------------------------------------------------------------------------

  ; This script uses 'User Variables' (with names starting with 'G_') to hold GLOBAL data.

  ;--------------------------------------------------------------------------
  ; General purpose
  ;--------------------------------------------------------------------------

  Var G_TEMP           ; general purpose global variable

#--------------------------------------------------------------------------
# Include private library functions and macro definitions
#--------------------------------------------------------------------------

  ; Avoid compiler warnings by disabling the functions and definitions we do not use

  !define ONDEMAND

  !include "..\pfi-library.nsh"
  !include "..\pfi-nsis-library.nsh"

#--------------------------------------------------------------------------

  ; 'VIProductVersion' format is X.X.X.X where X is a number in range 0 to 65535
  ; representing the following values: Major.Minor.Release.Build

  VIProductVersion                          "${C_VERSION}.0"

  !define /date C_BUILD_YEAR                "%Y"

  VIAddVersionKey "Comments"                "POPFile Homepage: http://getpopfile.org/"
  VIAddVersionKey "CompanyName"             "The POPFile Project"
  VIAddVersionKey "LegalTrademarks"         "POPFile is a registered trademark of \
                                             John Graham-Cumming"
  VIAddVersionKey "LegalCopyright"          "Copyright (c) ${C_BUILD_YEAR} John Graham-Cumming"
  VIAddVersionKey "FileDescription"         "Run POPFile and Mail Client together"
  VIAddVersionKey "FileVersion"             "${C_VERSION}"
  VIAddVersionKey "OriginalFilename"        "${C_OUTFILE}"
  VIAddVersionKey "Product Description"     "A simple utility which starts POPFile, \
                                             runs the Mail Client, waits for it to exit and \
                                             then silently shuts POPFile down."

  VIAddVersionKey "Build"                   "Compatible with POPFile 0.21.0 (or later)"
  VIAddVersionKey "Build Date/Time"         "${__DATE__} @ ${__TIME__}"
  !ifdef C_PFI_LIBRARY_VERSION
    VIAddVersionKey "Build Library Version" "${C_PFI_LIBRARY_VERSION}"
  !endif
  !ifdef C_NSIS_LIBRARY_VERSION
    VIAddVersionKey "NSIS Library Version"  "${C_NSIS_LIBRARY_VERSION}"
  !endif
  VIAddVersionKey "Build Script"            "${__FILE__}${MB_NL}(${__TIMESTAMP__})"

#----------------------------------------------------------------------------------------


;--------------------------------------
; Section: default
;--------------------------------------

Section default
  Call INI_File_Check
  Call Start_POPFILE
  Call Start_MailClient
  Call Shutdown_POPFile
SectionEnd


;--------------------------------------
; Function: INI_File_Check
;--------------------------------------

Function INI_File_Check

  IfFileExists "$EXEDIR\${C_INIFILE}" exit
  MessageBox MB_YESNO|MB_ICONEXCLAMATION "The INI file for this utility is missing!\
      ${MB_NL}${MB_NL}\
      Create the INI file now ?\
      ${MB_NL}${MB_NL}\
      ($EXEDIR\${C_INIFILE})" IDYES create_INI_file
  Abort

create_INI_file:
  SetOutPath $EXEDIR
  File "/oname=${C_INIFILE}" "OnDemand-default.ini"
  Call Edit_INI_File

exit:
FunctionEnd


;--------------------------------------
; Function: Start_POPFile
;--------------------------------------

Function Start_POPFile

  !define L_CLIENT_EXEPATH      $R9   ; fullpathname of the email client program
  !define L_RESULT              $R8

  Push ${L_CLIENT_EXEPATH}
  Push ${L_RESULT}

read_client_path:
  ReadINIStr ${L_CLIENT_EXEPATH} "$EXEDIR\${C_INIFILE}" "MailClient" "Executable"
  StrCmp ${L_CLIENT_EXEPATH} "" 0 check_client_exists
  MessageBox MB_YESNO|MB_ICONQUESTION "No mail client defined in the INI file\
      ${MB_NL}${MB_NL}\
      Edit the INI file now ?\
      ${MB_NL}${MB_NL}\
      ($EXEDIR\${C_INIFILE})" IDNO error_exit IDYES edit_client

check_client_exists:
  IfFileExists ${L_CLIENT_EXEPATH} start_popfile
  MessageBox MB_YESNO|MB_ICONEXCLAMATION "Mail client not found! (${L_CLIENT_EXEPATH})\
      ${MB_NL}${MB_NL}\
      Edit the INI file now ?\
      ${MB_NL}${MB_NL}\
      ($EXEDIR\${C_INIFILE})" IDNO error_exit

edit_client:
  Call Edit_INI_File
  Goto read_client_path

start_popfile:
  ReadRegStr $INSTDIR HKCU "Software\POPFile Project\${C_PFI_PRODUCT}\MRI" "RootDir_SFN"
  StrCmp $INSTDIR "" try_HKLM
  StrCmp $INSTDIR "Not supported" 0 got_path
  ReadRegStr $INSTDIR HKCU "Software\POPFile Project\${C_PFI_PRODUCT}\MRI" "RootDir_LFN"
  StrCmp $INSTDIR "" 0 got_path

try_HKLM:
  ReadRegStr $INSTDIR HKLM "Software\POPFile Project\${C_PFI_PRODUCT}\MRI" "RootDir_SFN"
  StrCmp $INSTDIR "" popfile_not_found
  StrCmp $INSTDIR "Not supported" 0 got_path
  ReadRegStr $INSTDIR HKLM "Software\POPFile Project\${C_PFI_PRODUCT}\MRI" "RootDir_LFN"
  StrCmp $INSTDIR "" 0 got_path

popfile_not_found:
  MessageBox MB_OK|MB_ICONEXCLAMATION "Error: Unable to find compatible version of POPFile"
  Goto error_exit

got_path:
  IfFileExists "$INSTDIR\runpopfile.exe" check_if_POPFile_running
  MessageBox MB_OK|MB_ICONEXCLAMATION "Error: Unable to find the 'runpopfile' utility"
  Goto error_exit

check_if_POPFile_running:
  Push "${C_EXE_END_MARKER}"
  Push "$INSTDIR\popfileb.exe"
  Push "$INSTDIR\popfilef.exe"
  Push "$INSTDIR\popfileib.exe"
  Push "$INSTDIR\popfileif.exe"
  Push "$INSTDIR\perl.exe"
  Push "$INSTDIR\wperl.exe"
  Call PFI_CheckIfLocked
  Pop ${L_RESULT}
  StrCmp ${L_RESULT} "" 0 exit

  ; Assume POPFile is not running, so start it up now

  ClearErrors
  SetOutPath "$INSTDIR"               ; added this to get the dummy EXE files to work
  Exec '"$INSTDIR\runpopfile.exe"'
  IfErrors 0 exit
  MessageBox MB_OK|MB_ICONSTOP "Error trying to start POPFile"

error_exit:
  Abort

exit:
  Pop ${L_RESULT}
  Pop ${L_CLIENT_EXEPATH}

  !undef L_CLIENT_EXEPATH
  !undef L_RESULT

FunctionEnd


;--------------------------------------
; Function: Start_MailClient
;--------------------------------------

Function Start_MailClient

  !define C_MAX_DELAY           300   ; delay is in seconds so '300' represents 5 minutes

  !define L_CLIENT_EXEPATH      $R9   ; fullpathname of the email client program
  !define L_CLIENT_PARAMS       $R8   ; parameters (if any) to be supplied to email client
  !define L_RESULT              $R7
  !define L_STARTUP_DELAY       $R6   ; delay (in seconds) before we start the email client
                                      ; (valid values are 0 to ${C_MAX_DELAY} inclusive)

  Push ${L_CLIENT_EXEPATH}
  Push ${L_CLIENT_PARAMS}
  Push ${L_RESULT}
  Push ${L_STARTUP_DELAY}

  ReadINIStr ${L_STARTUP_DELAY} "$EXEDIR\${C_INIFILE}" "Settings" "StartupDelay"
  StrCmp ${L_STARTUP_DELAY} "" start_client
  Push ${L_STARTUP_DELAY}
  Call PFI_StrCheckDecimal
  Pop ${L_RESULT}
  StrCmp ${L_RESULT} "" invalid_delay_supplied
  IntCmp ${L_STARTUP_DELAY} 0 start_client invalid_delay_supplied
  IntCmp ${L_STARTUP_DELAY} ${C_MAX_DELAY} use_delay use_delay
  StrCpy $G_TEMP "Maximum StartupDelay is ${C_MAX_DELAY} seconds"
  Goto display_delay_msg

invalid_delay_supplied:
  StrCpy $G_TEMP "StartupDelay range is 0 to ${C_MAX_DELAY} (in seconds)"

display_delay_msg:
  MessageBox MB_OK|MB_ICONINFORMATION "$G_TEMP\
      ${MB_NL}${MB_NL}\
      The INI file has 'StartupDelay=${L_STARTUP_DELAY}'\
      ${MB_NL}${MB_NL}\
      (see $EXEDIR\${C_INIFILE})"
  Goto start_client

use_delay:
  Sleep "${L_STARTUP_DELAY}000"

start_client:
  ReadINIStr ${L_CLIENT_EXEPATH} "$EXEDIR\${C_INIFILE}" "MailClient" "Executable"
  ReadINIStr ${L_CLIENT_PARAMS}  "$EXEDIR\${C_INIFILE}" "MailClient" "Parameters"

  StrCmp ${L_CLIENT_EXEPATH} "" 0 check_client
  MessageBox MB_OK|MB_ICONEXCLAMATION "No mail client defined in $EXEDIR\${C_INIFILE}"
  Goto done

check_client:
  IfFileExists ${L_CLIENT_EXEPATH} run_client
  MessageBox MB_OK|MB_ICONEXCLAMATION "Mail client not found! (${L_CLIENT_EXEPATH})\
      ${MB_NL}${MB_NL}\
      (Check the settings in $EXEDIR\${C_INIFILE})"
  Goto done

run_client:
  ExecWait '"${L_CLIENT_EXEPATH}" "${L_CLIENT_PARAMS}"'

done:
  Pop ${L_STARTUP_DELAY}
  Pop ${L_RESULT}
  Pop ${L_CLIENT_PARAMS}
  Pop ${L_CLIENT_EXEPATH}

  !undef L_CLIENT_EXEPATH
  !undef L_CLIENT_PARAMS
  !undef L_RESULT
  !undef L_STARTUP_DELAY

FunctionEnd


;--------------------------------------
; Function: Shutdown_POPFile
;--------------------------------------

Function Shutdown_POPFile

  !define L_CFG      $R9    ; path to the configuration file (popfile.cfg)
  !define L_CHARPOS  $R8    ; used when extracting filename from the full path
  !define L_EXE      $R7    ; name of EXE file to be monitored
  !define L_LIMIT    $R6    ; length of full path to the locked file
  !define L_NEW_GUI  $R5    ; POPFile UI port number (extracted from popfile.cfg)
  !define L_RESULT   $R4
  !define L_STOP_PF  $R3    ; StopPOPFile setting extracted from the utility's INI file

  Push ${L_CFG}
  Push ${L_CHARPOS}
  Push ${L_EXE}
  Push ${L_LIMIT}
  Push ${L_NEW_GUI}
  Push ${L_RESULT}
  Push ${L_STOP_PF}

  ReadINIStr ${L_STOP_PF} "$EXEDIR\${C_INIFILE}" "Settings" "StopPOPFile"
  StrCmp ${L_STOP_PF} "" stop_popfile
  StrCmp ${L_STOP_PF} "yes" stop_popfile
  StrCmp ${L_STOP_PF} "no" exit
  MessageBox MB_OK|MB_ICONINFORMATION "The 'StopPOPfile' setting is invalid\
      ${MB_NL}${MB_NL}\
      The INI file has 'StopPOPFile=${L_STOP_PF}'\
      ${MB_NL}${MB_NL}\
      (see $EXEDIR\${C_INIFILE})\
      ${MB_NL}${MB_NL}\
      Default setting (yes) will be assumed"

stop_popfile:

  ; Attempt to discover which POPFile UI port is used by the current user,
  ; so we can shutdown POPFile silently without opening a browser window.

  ReadRegStr ${L_CFG} HKCU "Software\POPFile Project\${C_PFI_PRODUCT}\MRI" "UserDir_LFN"
  StrCmp ${L_CFG} "" try_root_dir
  IfFileExists "${L_CFG}\popfile.cfg" check_cfg_file

try_root_dir:
  IfFileExists "$INSTDIR\popfile.cfg" 0 manual_shutdown
  StrCpy ${L_CFG} "$INSTDIR"

check_cfg_file:
  Push "${L_CFG}\popfile.cfg"
  Push "html_port"
  Call PFI_CfgSettingRead
  Pop ${L_NEW_GUI}
  StrCmp ${L_NEW_GUI} "" manual_shutdown
  Push ${L_NEW_GUI}
  Call PFI_ShutdownViaUI
  Pop ${L_RESULT}
  StrCmp ${L_RESULT} "success" check_exe
  StrCmp ${L_RESULT} "password?" manual_shutdown

check_exe:
  Push "${C_EXE_END_MARKER}"
  Push "$INSTDIR\popfileb.exe"
  Push "$INSTDIR\popfilef.exe"
  Push "$INSTDIR\popfileib.exe"
  Push "$INSTDIR\popfileif.exe"
  Push "$INSTDIR\perl.exe"
  Push "$INSTDIR\wperl.exe"
  Call PFI_CheckIfLocked
  Pop ${L_EXE}
  StrCmp ${L_EXE} "" exit
  StrCpy ${L_CHARPOS} 0
  StrCpy ${L_RESULT} ""
  StrLen ${L_LIMIT} ${L_EXE}

nameloop:
  IntOp ${L_CHARPOS} ${L_CHARPOS} + 1
  IntCmp ${L_CHARPOS} ${L_LIMIT} 0 0 gotname
  StrCpy ${L_RESULT} ${L_EXE} 1 -${L_CHARPOS}
  StrCmp ${L_RESULT} "\" 0 nameloop
  IntOp ${L_CHARPOS} ${L_CHARPOS} - 1
  StrCpy ${L_EXE} ${L_EXE} "" -${L_CHARPOS}

gotname:
  Push "$INSTDIR\${L_EXE}"
  Call PFI_WaitUntilUnlocked
  Push "${C_EXE_END_MARKER}"
  Push "$INSTDIR\${L_EXE}"
  Call PFI_CheckIfLocked
  Pop ${L_RESULT}
  StrCmp ${L_RESULT} "" exit

manual_shutdown:
  MessageBox MB_OK|MB_ICONEXCLAMATION "Unable to shutdown POPFile automatically"

exit:
  Pop ${L_STOP_PF}
  Pop ${L_RESULT}
  Pop ${L_NEW_GUI}
  Pop ${L_LIMIT}
  Pop ${L_EXE}
  Pop ${L_CHARPOS}
  Pop ${L_CFG}

  !undef L_CFG
  !undef L_CHARPOS
  !undef L_EXE
  !undef L_LIMIT
  !undef L_NEW_GUI
  !undef L_RESULT
  !undef L_STOP_PF

FunctionEnd


;--------------------------------------
; Function: Edit_INI_File
;--------------------------------------

Function Edit_INI_File

  !define L_NOTEPAD   $R9

  Push ${L_NOTEPAD}

  SearchPath ${L_NOTEPAD} notepad.exe
  StrCmp ${L_NOTEPAD} "" use_file_association
  ExecWait 'notepad.exe "$EXEDIR\${C_INIFILE}"'
  GoTo exit

use_file_association:
  ExecShell "open" "$EXEDIR\${C_INIFILE}"

exit:
  Pop ${L_NOTEPAD}

  !undef L_NOTEPAD

FunctionEnd


#--------------------------------------------------------------------------
# End of OnDemand.nsi
#--------------------------------------------------------------------------
