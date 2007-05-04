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
# Copyright (c) 2005-2007 John Graham-Cumming
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

  ; This version of the script has been tested with the "NSIS v2.22" compiler,
  ; released 27 November 2006. This particular compiler can be downloaded from
  ; http://prdownloads.sourceforge.net/nsis/nsis-2.22-setup.exe?download

  !define ${NSIS_VERSION}_found

  !ifndef v2.22_found
      !warning \
          "$\r$\n\
          $\r$\n***   NSIS COMPILER WARNING:\
          $\r$\n***\
          $\r$\n***   This script has only been tested using the NSIS v2.22 compiler\
          $\r$\n***   and may not work properly with this NSIS ${NSIS_VERSION} compiler\
          $\r$\n***\
          $\r$\n***   The resulting 'installer' program should be tested carefully!\
          $\r$\n$\r$\n"
  !endif

  !undef  ${NSIS_VERSION}_found

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
#       (optional) identifies settings which can be left out of the INI file
#
#   (1) 'Executable' is the full pathname of the email client program
#
#   (2) (optional) 'Parameters' specifies any optional parameters to be passed
#       to the email client (e.g. Eudora can be told where to find its configuration data)
#
#   (3) (optional) 'StartupDelay' specifies the delay (in seconds) between starting
#       POPFile and starting the email client. If this parameter is not supplied a
#       delay of zero is assumed. This value should only contain the digits 0 to 9.
#
#   (4) (optional) 'StopPOPFile' can be either "yes" or "no". If this parameter is
#       missing POPFile will be shutdown when the email client exits.
#-------------------------------------------------------------------------------------------

  ;--------------------------------------------------------------------------
  ; Select standard LZMA compression (to generate smallest EXE file)
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

  ; This build is for use with POPFile 0.21.0 (or later) installer-created installations

  !define C_PFI_PRODUCT  "POPFile"

  ;--------------------------------------------------------------------------
  ; The URL used to access the POPFile User Interface (UI)
  ;--------------------------------------------------------------------------

  !define C_UI_URL    "127.0.0.1"

  ;--------------------------------------------------------------------------
  ; Specify filename for the EXE and INI files
  ;--------------------------------------------------------------------------

  !define C_OUTFILE "OnDemand.exe"
  !define C_INIFILE "OnDemand.ini"

  ;--------------------------------------------------------------------------

  Name    "Run POPFile & email client on demand"
  Caption "$(^Name)"        ; used in the title bar of any message boxes the utility displays

  OutFile ${C_OUTFILE}

  !define C_VERSION   "0.0.5"

  ; Specify the icon file for the utility

  Icon "OnDemand.ico"

  ; Selecting 'silent' install makes 'installer' behave like a command-line utility

  SilentInstall silent

  ;--------------------------------------------------------------------------
  ; Windows Vista expects to find a manifest specifying the execution level
  ;--------------------------------------------------------------------------

  RequestExecutionLevel   user

#--------------------------------------------------------------------------

  ; 'VIProductVersion' format is X.X.X.X where X is a number in range 0 to 65535
  ; representing the following values: Major.Minor.Release.Build

  VIProductVersion                          "${C_VERSION}.0"

  !define /date C_BUILD_YEAR                "%Y"

  VIAddVersionKey "Comments"                "POPFile Homepage: http://getpopfile.org/"
  VIAddVersionKey "CompanyName"             "The POPFile Project"
  VIAddVersionKey "LegalTrademarks"         "POPFile is a registered trademark of John Graham-Cumming"
  VIAddVersionKey "LegalCopyright"          "Copyright (c) ${C_BUILD_YEAR}  John Graham-Cumming"
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
  ReadRegStr $INSTDIR HKCU "Software\POPFile Project\${C_PFI_PRODUCT}\MRI" "RootDir_LFN"
  StrCmp  $INSTDIR "" 0 got_path
  ReadRegStr $INSTDIR HKLM "Software\POPFile Project\${C_PFI_PRODUCT}\MRI" "RootDir_LFN"
  StrCmp  $INSTDIR "" 0 got_path
  MessageBox MB_OK|MB_ICONEXCLAMATION "Error: Unable to find compatible version of POPFile"
  Goto error_exit

got_path:
  IfFileExists "$INSTDIR\runpopfile.exe" check_if_POPFile_running
  MessageBox MB_OK|MB_ICONEXCLAMATION "Error: Unable to find the 'runpopfile' utility"
  Goto error_exit

check_if_POPFile_running:
  Push "$INSTDIR\popfileb.exe"
  Call CheckIfExeLocked
  Pop ${L_RESULT}
  StrCmp ${L_RESULT} "" 0 exit

  Push "$INSTDIR\popfilef.exe"
  Call CheckIfExeLocked
  Pop ${L_RESULT}
  StrCmp ${L_RESULT} "" 0 exit

  Push "$INSTDIR\popfileib.exe"
  Call CheckIfExeLocked
  Pop ${L_RESULT}
  StrCmp ${L_RESULT} "" 0 exit

  Push "$INSTDIR\popfileif.exe"
  Call CheckIfExeLocked
  Pop ${L_RESULT}
  StrCmp ${L_RESULT} "" 0 exit

  Push "$INSTDIR\perl.exe"
  Call CheckIfExeLocked
  Pop ${L_RESULT}
  StrCmp ${L_RESULT} "" 0 exit

  Push "$INSTDIR\wperl.exe"
  Call CheckIfExeLocked
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

  !define C_MAX_DELAY          300    ; delay is in seconds so '300' represents 5 minutes

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
  Call StrCheckDecimal
  Pop ${L_RESULT}
  StrCmp ${L_RESULT} "" invalid_delay_supplied
  IntCmp ${L_STARTUP_DELAY} 0 start_client invalid_delay_supplied
  IntCmp ${L_STARTUP_DELAY} ${C_MAX_DELAY} use_delay use_delay
  MessageBox MB_OK|MB_ICONINFORMATION "Maximum StartupDelay is ${C_MAX_DELAY} seconds\
      ${MB_NL}${MB_NL}\
      The INI file has 'StartupDelay=${L_STARTUP_DELAY}'\
      ${MB_NL}${MB_NL}\
      (see $EXEDIR\${C_INIFILE})"
  Goto start_client

invalid_delay_supplied:
  MessageBox MB_OK|MB_ICONINFORMATION "StartupDelay range is 0 to ${C_MAX_DELAY} (in seconds)\
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

  !define L_CFG      $R9    ; file handle
  !define L_EXE      $R8    ; name of EXE file to be monitored
  !define L_LINE     $R7    ; data read from popfile.cfg
  !define L_NEW_GUI  $R6    ; POPFile UI port number (extracted from popfile.cfg)
  !define L_PARAM    $R5    ; current popfile.cfg parameter
  !define L_RESULT   $R4
  !define L_STOP_PF  $R3    ; StopPOPFile setting extracted from the utility's INI file
  !define L_TEXTEND  $R2    ; used to ensure correct handling of lines longer than 1023 chars

  Push ${L_CFG}
  Push ${L_EXE}
  Push ${L_LINE}
  Push ${L_NEW_GUI}
  Push ${L_PARAM}
  Push ${L_RESULT}
  Push ${L_STOP_PF}
  Push ${L_TEXTEND}

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
  StrCpy ${L_NEW_GUI} ""

  ; See if we can get the current gui port from an existing configuration.
  ; There may be more than one entry for this port in the file - use the last one found

  FileOpen  ${L_CFG} "${L_CFG}\popfile.cfg" r

found_eol:
  StrCpy ${L_TEXTEND} "<eol>"

loop:
  FileRead ${L_CFG} ${L_LINE}
  StrCmp ${L_LINE} "" done
  StrCmp ${L_TEXTEND} "<eol>" 0 check_eol
  StrCmp ${L_LINE} "$\n" loop

  StrCpy ${L_PARAM} ${L_LINE} 10
  StrCmp ${L_PARAM} "html_port " 0 check_eol
  StrCpy ${L_NEW_GUI} ${L_LINE} 5 10

  ; Now read file until we get to end of the current line
  ; (i.e. until we find text ending in <CR><LF>, <CR> or <LF>)

check_eol:
  StrCpy ${L_TEXTEND} ${L_LINE} 1 -1
  StrCmp ${L_TEXTEND} "$\n" found_eol
  StrCmp ${L_TEXTEND} "$\r" found_eol loop

done:
  FileClose ${L_CFG}

  Push ${L_NEW_GUI}
  Call TrimNewlines
  Pop ${L_NEW_GUI}

  StrCmp ${L_NEW_GUI} "" manual_shutdown
  Push ${L_NEW_GUI}
  Call ShutdownSilently
  Pop ${L_RESULT}
  StrCmp ${L_RESULT} "success" check_exe
  StrCmp ${L_RESULT} "password?" manual_shutdown

check_exe:
  Push ${L_EXE}
  Call WaitUntilExeUnlocked
  Push ${L_EXE}
  Call CheckIfExeLocked
  Pop ${L_EXE}
  StrCmp ${L_EXE} "" exit

manual_shutdown:
  MessageBox MB_OK|MB_ICONEXCLAMATION "Unable to shutdown POPFile automatically"

exit:
  Pop ${L_TEXTEND}
  Pop ${L_STOP_PF}
  Pop ${L_RESULT}
  Pop ${L_PARAM}
  Pop ${L_NEW_GUI}
  Pop ${L_LINE}
  Pop ${L_EXE}
  Pop ${L_CFG}

  !undef L_CFG
  !undef L_EXE
  !undef L_LINE
  !undef L_NEW_GUI
  !undef L_PARAM
  !undef L_RESULT
  !undef L_STOP_PF
  !undef L_TEXTEND

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
# General Purpose Function: CheckIfExeLocked
#--------------------------------------------------------------------------
#
# This function checks if a particular executable file (an EXE file) is being used.
# If the specified EXE file is no longer in use, this function returns an empty string
# (otherwise it returns the input parameter unchanged).
#
# Inputs:
#         (top of stack)     - the full path of the EXE file to be checked
#
# Outputs:
#         (top of stack)     - if file is no longer in use, an empty string ("") is returned
#                              otherwise the input string is returned
#
#  Usage:
#
#         Push "$INSTDIR\wperl.exe"
#         Call CheckIfExeLocked
#         Pop $R0
#
#        (if the file is no longer in use, $R0 will be "")
#        (if the file is still being used, $R0 will be "$INSTDIR\wperl.exe")
#--------------------------------------------------------------------------

Function CheckIfExeLocked
  !define L_EXE           $R9   ; full path to the EXE file which is to be monitored
  !define L_FILE_HANDLE   $R8

  Exch ${L_EXE}
  Push ${L_FILE_HANDLE}

  IfFileExists "${L_EXE}" 0 unlocked_exit
  SetFileAttributes "${L_EXE}" NORMAL

  ClearErrors
  FileOpen ${L_FILE_HANDLE} "${L_EXE}" a
  FileClose ${L_FILE_HANDLE}
  IfErrors exit

unlocked_exit:
  StrCpy ${L_EXE} ""

 exit:
  Pop ${L_FILE_HANDLE}
  Exch ${L_EXE}

  !undef L_EXE
  !undef L_FILE_HANDLE
FunctionEnd


#--------------------------------------------------------------------------
# General Purpose Function: WaitUntilExeUnlocked
#--------------------------------------------------------------------------
#
# This function waits until a particular executable file (an EXE file) is no longer in use.
#
# It may take a little while for POPFile to shutdown so this function waits in a loop until
# the specified EXE file is no longer in use. A timeout is used to avoid an infinite loop.
#
# Inputs:
#         (top of stack)     - the full path of the EXE file to be checked
#
# Outputs:
#         (none)
#
# Usage:
#
#         Push "$INSTDIR\wperl.exe"
#         Call WaitUntilExeUnlocked
#
#--------------------------------------------------------------------------

Function WaitUntilExeUnlocked

  !define L_EXE           $R9   ; full path to the EXE file which is to be monitored
  !define L_FILE_HANDLE   $R8
  !define L_TIMEOUT       $R7   ; used to avoid an infinite loop

  ;-----------------------------------------------------------
  ; Timeout loop counter start value (counts down to 0)

  !ifndef C_SHUTDOWN_LIMIT
    !define C_SHUTDOWN_LIMIT    20
  !endif

  ; Delay (in milliseconds) used inside the timeout loop

  !ifndef C_SHUTDOWN_DELAY
    !define C_SHUTDOWN_DELAY    1000
  !endif
  ;-----------------------------------------------------------

  Exch ${L_EXE}
  Push ${L_FILE_HANDLE}
  Push ${L_TIMEOUT}

  IfFileExists "${L_EXE}" 0 exit_now
  SetFileAttributes "${L_EXE}" NORMAL
  StrCpy ${L_TIMEOUT} ${C_SHUTDOWN_LIMIT}

check_if_unlocked:
  Sleep ${C_SHUTDOWN_DELAY}
  ClearErrors
  FileOpen ${L_FILE_HANDLE} "${L_EXE}" a
  FileClose ${L_FILE_HANDLE}
  IfErrors 0 exit_now
  IntOp ${L_TIMEOUT} ${L_TIMEOUT} - 1
  IntCmp ${L_TIMEOUT} 0 exit_now exit_now check_if_unlocked

 exit_now:
  Pop ${L_TIMEOUT}
  Pop ${L_FILE_HANDLE}
  Pop ${L_EXE}

  !undef L_EXE
  !undef L_FILE_HANDLE
  !undef L_TIMEOUT

FunctionEnd


#--------------------------------------------------------------------------
# General Purpose Function: ShutdownSilently
#--------------------------------------------------------------------------
#
# This function attempts to shutdown POPFile using the User Interface (UI) invisibly
# (i.e. no browser window is used).
#
# We use NSISdl to shutdown POPFile by "downloading" the POPFile Shutdown page. Normally one
# successful download attempt is enough to shutdown POPFile and the page which NSISdl receives
# will be the "POPFile has shut down" one. However if the UI is password protected then NSISdl
# will receive a page requesting the UI password instead of the "POPFile has shut down" page.
#
# To avoid the need to parse the HTML page downloaded by NSISdl, we make a second attempt to
# download the POPFile Shutdown page. If POPFile has shutdown then this second call will fail
# or it will download an empty page (i.e. one which is 0 bytes long). If the second NSISdl call
# downloads a page which is not empty then we assume it is a page requesting the UI password.
#
# To help debug problems, the first HTML file is _not_ overwritten with the second HTML file.
#
# Inputs:
#         (top of stack)       - UI port to be used when issuing the shutdown request
#
# Outputs:
#         (top of stack)       - string containing one of the following result codes:
#
#                                "success"    (meaning UI shutdown request appeared to work)
#
#                                "failure"    (meaning UI shutdown request failed)
#
#                                "password?"  (meaning failure: UI may be password protected)
#
#                                "badport"    (meaning failure: invalid UI port supplied)
#
# Usage:
#
#         Push "8080"
#         Call ShutdownSilently
#         Pop $R0
#
#         (if $R0 at this point is "password?" then POPFile is still running)
#
#--------------------------------------------------------------------------

Function ShutdownSilently

  ;--------------------------------------------------------------------------
  ; Override the default timeout for NSISdl requests (specifies timeout in milliseconds)

  !define C_SVU_DLTIMEOUT       /TIMEOUT=10000

  ; Delay between the two shutdown requests (in milliseconds)

  !define C_SVU_DLGAP           2000
  ;--------------------------------------------------------------------------

  !define L_RESULT    $R9
  !define L_UIPORT    $R8

  Exch ${L_UIPORT}
  Push ${L_RESULT}
  Exch

  StrCmp ${L_UIPORT} "" badport
  Push ${L_UIPORT}
  Call StrCheckDecimal
  Pop ${L_UIPORT}
  StrCmp ${L_UIPORT} "" badport
  IntCmp ${L_UIPORT} 1 port_ok badport
  IntCmp ${L_UIPORT} 65535 port_ok port_ok

badport:
  StrCpy ${L_RESULT} "badport"
  Goto exit

port_ok:
  NSISdl::download_quiet \
      ${C_SVU_DLTIMEOUT} http://${C_UI_URL}:${L_UIPORT}/shutdown "$PLUGINSDIR\shutdown_1.htm"
  Pop ${L_RESULT}
  StrCmp ${L_RESULT} "success" try_again
  StrCpy ${L_RESULT} "failure"
  Goto exit

try_again:
  Sleep ${C_SVU_DLGAP}
  NSISdl::download_quiet \
      ${C_SVU_DLTIMEOUT} http://${C_UI_URL}:${L_UIPORT}/shutdown "$PLUGINSDIR\shutdown_2.htm"
  Pop ${L_RESULT}
  StrCmp ${L_RESULT} "success" 0 shutdown_ok
  Push "$PLUGINSDIR\shutdown_2.htm"
  Call GetFileSize
  Pop ${L_RESULT}
  StrCmp ${L_RESULT} 0 shutdown_ok
  StrCpy ${L_RESULT} "password?"
  Goto exit

shutdown_ok:
  StrCpy ${L_RESULT} "success"

exit:
  Pop ${L_UIPORT}
  Exch ${L_RESULT}

  !undef C_SVU_DLTIMEOUT
  !undef C_SVU_DLGAP

  !undef L_RESULT
  !undef L_UIPORT

FunctionEnd


#--------------------------------------------------------------------------
# General Purpose Function: StrCheckDecimal
#--------------------------------------------------------------------------
#
# This function checks if a given string contains only the digits 0 to 9
# (if the string contains any invalid characters, "" is returned)
#
# Inputs:
#         (top of stack)   - string which may contain a decimal number
#
# Outputs:
#         (top of stack)   - the input string (if valid) or "" (if invalid)
#
# Usage:
#
#         Push "12345"
#         Call StrCheckDecimal
#         Pop $R0
#         ($R0 at this point is "12345")
#
#--------------------------------------------------------------------------

Function StrCheckDecimal

  !define DECIMAL_DIGIT    "0123456789"   ; accept only these digits
  !define BAD_OFFSET       10             ; length of DECIMAL_DIGIT string

  Exch $0   ; The input string
  Push $1   ; Holds the result: either "" (if input is invalid) or the input string (if valid)
  Push $2   ; A character from the input string
  Push $3   ; The offset to a character in the "validity check" string
  Push $4   ; A character from the "validity check" string
  Push $5   ; Holds the current "validity check" string

  StrCpy $1 ""

next_input_char:
  StrCpy $2 $0 1                ; Get the next character from the input string
  StrCmp $2 "" done
  StrCpy $5 ${DECIMAL_DIGIT}$2  ; Add it to end of "validity check" to guarantee a match
  StrCpy $0 $0 "" 1
  StrCpy $3 -1

next_valid_char:
  IntOp $3 $3 + 1
  StrCpy $4 $5 1 $3               ; Extract next "valid" char (from "validity check" string)
  StrCmp $2 $4 0 next_valid_char
  IntCmp $3 ${BAD_OFFSET} invalid 0 invalid  ; If match is with the char we added, input is bad
  StrCpy $1 $1$4                  ; Add "valid" character to the result
  goto next_input_char

invalid:
  StrCpy $1 ""

done:
  StrCpy $0 $1      ; Result is either a string of decimal digits or ""
  Pop $5
  Pop $4
  Pop $3
  Pop $2
  Pop $1
  Exch $0           ; place result on top of the stack

  !undef DECIMAL_DIGIT
  !undef BAD_OFFSET

FunctionEnd


#--------------------------------------------------------------------------
# General Purpose Function: GetFileSize
#--------------------------------------------------------------------------
#
# This function gets the size (in bytes) of a particular file.
#
# If the specified file is not found, the function returns -1
#
# Inputs:
#         (top of stack)     - filename of file to be checked
# Outputs:
#         (top of stack)     - length of the file (in bytes)
#                              or '-1' if file not found
#                              or '-2' if error occurred
#
# Usage:
#
#         Push "corpus\spam\table"
#         Call GetFileSize
#         Pop $R0
#
#         ($R0 now holds the size (in bytes) of the 'spam' bucket's 'table' file)
#
#--------------------------------------------------------------------------

Function GetFileSize

  !define L_FILENAME  $R9
  !define L_RESULT    $R8

  Exch ${L_FILENAME}
  Push ${L_RESULT}
  Exch

  IfFileExists ${L_FILENAME} find_size
  StrCpy ${L_RESULT} "-1"
  Goto exit

find_size:
  ClearErrors
  FileOpen ${L_RESULT} ${L_FILENAME} r
  FileSeek ${L_RESULT} 0 END ${L_FILENAME}
  FileClose ${L_RESULT}
  IfErrors 0 return_size
  StrCpy ${L_RESULT} "-2"
  Goto exit

return_size:
  StrCpy ${L_RESULT} ${L_FILENAME}

exit:
  Pop ${L_FILENAME}
  Exch ${L_RESULT}

  !undef L_FILENAME
  !undef L_RESULT

FunctionEnd

#--------------------------------------------------------------------------
# General Purpose Function: TrimNewlines
#--------------------------------------------------------------------------
#
# This function trims newlines from lines of text.
#
# Inputs:
#         (top of stack)   - string which may end with one or more newlines
#
# Outputs:
#         (top of stack)   - the input string with the trailing newlines (if any) removed
#
# Usage:
#
#         Push "whatever$\r$\n"
#         Call TrimNewlines
#         Pop $R0
#         ($R0 at this point is "whatever")
#
#--------------------------------------------------------------------------

Function TrimNewlines
  Exch $R0
  Push $R1
  Push $R2
  StrCpy $R1 0

loop:
  IntOp $R1 $R1 - 1
  StrCpy $R2 $R0 1 $R1
  StrCmp $R2 "$\r" loop
  StrCmp $R2 "$\n" loop
  IntOp $R1 $R1 + 1
  IntCmp $R1 0 no_trim_needed
  StrCpy $R0 $R0 $R1

no_trim_needed:
  Pop $R2
  Pop $R1
  Exch $R0
FunctionEnd

#--------------------------------------------------------------------------
# End of OnDemand.nsi
#--------------------------------------------------------------------------
