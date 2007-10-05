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
  ; Tested with version v0.3 RC2 (15:36, 13 July 2007) of the 'LockedList' plugin.

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

  !define C_VERSION   "0.0.8"

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

  ;--------------------------------------------------------------------------
  ; Used in the 'CheckIfExeLocked' function to simply stack handling
  ;--------------------------------------------------------------------------

  Var G_EXETOCHECK     ; fullpath to an executable file to be checked by the LockedList plugin
  Var G_FILE_HANDLE    ; used when target system is not Windows NT4 or later

  ;--------------------------------------------------------------------------
  ; Marker used by the 'CheckIfExeLocked' function to detect the end of the input data
  ;--------------------------------------------------------------------------

  !define C_EXE_END_MARKER  "/EndOfExeList"

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
  Call StrCheckDecimal
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

  !define L_CFG      $R9    ; file handle
  !define L_EXE      $R8    ; name of EXE file to be monitored
  !define L_LINE     $R7    ; data read from popfile.cfg
  !define L_NEW_GUI  $R6    ; POPFile UI port number (extracted from popfile.cfg)
  !define L_PARAM    $R5    ; current popfile.cfg parameter
  !define L_RESULT   $R4
  !define L_STOP_PF  $R3    ; StopPOPFile setting extracted from the utility's INI file
  !define L_TEXTEND  $R2    ; used to ensure correct handling of lines longer than 1023 chars
                            ; (the standard NSIS compiler has a limit of 1023 characters;
                            ; if a higher limit is required there is a special build available)

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
  Push "${C_EXE_END_MARKER}"
  Push "$INSTDIR\popfileb.exe"
  Push "$INSTDIR\popfilef.exe"
  Push "$INSTDIR\popfileib.exe"
  Push "$INSTDIR\popfileif.exe"
  Push "$INSTDIR\perl.exe"
  Push "$INSTDIR\wperl.exe"
  Call CheckIfExeLocked
  Pop ${L_EXE}
  StrCmp ${L_EXE} "" exit
  StrCpy ${L_PARAM} 0
  StrCpy ${L_RESULT} ""
  StrLen ${L_TEXTEND} ${L_EXE}

nameloop:
  IntOp ${L_PARAM} ${L_PARAM} + 1
  IntCmp ${L_PARAM} ${L_TEXTEND} 0 0 gotname
  StrCpy ${L_RESULT} ${L_EXE} 1 -${L_PARAM}
  StrCmp ${L_RESULT} "\" 0 nameloop
  IntOp ${L_PARAM} ${L_PARAM} - 1
  StrCpy ${L_EXE} ${L_EXE} "" -${L_PARAM}

gotname:
  Push "$INSTDIR\${L_EXE}"
  Call WaitUntilExeUnlocked
  Push "${C_EXE_END_MARKER}"
  Push "$INSTDIR\${L_EXE}"
  Call CheckIfExeLocked
  Pop ${L_RESULT}
  StrCmp ${L_RESULT} "" exit

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
# There are several different ways to run POPFile so this function accepts a list
# of full pathnames to the executable files which are to be checked. The list is
# passed via the stack with a marker string being used to mark the end of the list.
#
# The LockedList plugin returns the results on the stack, sandwiched between "/start"
# and "/end" markers ("/start" appears at the top of the stack). If no files are locked,
# the plugin simply returns both markers on the stack:
#         (top of stack)       /start
#         (top of stack - 1)   /end
#
# Note that if an executable was started using an SFN path then the plugin must also
# be given the SFN path (if the plugin is supplied with the equivalent LFN path then
# it will fail to detect if the executable is locked). As a further complication, if
# a locked file is found the plugin returns the LFN format even if the input list of
# executable files used the SFN format.
#
# Unfortunately the 'LockedList' plugin relies upon OS features only found in
# Windows NT4 or later so older systems such as Win9x must be treated as special
# cases.
#
# If none of the specified files is locked then an empty string is returned,
# otherwise the function returns the first locked file it detects.
#
# Inputs:
#         (top of stack)           - full path of EXE file to be checked
#         (top of stack - 1)       - full path of EXE file to be checked
#          ...
#         (top of stack - n)       - full path of EXE file to be checked
#         (top of stack - (n + 1)) - end-of-data marker (see C_EXE_END_MARKER definition)
#
# Outputs:
#         (top of stack)           - if none of the files is in use, an empty string ("")
#                                    is returned, otherwise the path to the first locked
#                                    file found is returned
#
#  Usage:
#
#         Push "/EndOfExeList"
#         Push "$INSTDIR\wperl.exe"
#         Call CheckIfExeLocked
#         Pop $R0
#
#        (if the file is no longer in use, $R0 will be "")
#--------------------------------------------------------------------------

Function CheckIfExeLocked

  Call AtLeastWinNT4
  Pop $G_TEMP
  StrCmp $G_TEMP "0" specialcase

  ; The target system provides the features required by the LockedList plugin

  StrCpy $G_TEMP "emptylist"

get_exe_path:
  Pop $G_EXETOCHECK
  StrCmp $G_EXETOCHECK "${C_EXE_END_MARKER}" start_search
  IfFileExists "$G_EXETOCHECK" 0 get_exe_path
  StrCpy $G_TEMP "gotlist"
  LockedList::AddModule /NOUNLOAD "$G_EXETOCHECK"
  Goto get_exe_path

start_search:
  StrCmp $G_TEMP "emptylist" nothing_to_report
  LockedList::SilentSearch

  StrCpy $G_EXETOCHECK ""
  Pop $G_TEMP
  StrCmp $G_TEMP "/start" get_search_result
  MessageBox MB_OK|MB_ICONEXCLAMATION "Unexpected result from LockedList plugin\
      ${MB_NL}${MB_NL}\
      ($G_TEMP)"
  Abort

get_search_result:
  Pop $G_TEMP           ; get "process ID" (or "/end" marker, if no more data)
  StrCmp $G_TEMP "/end" end_of_locked_list
  StrCmp $G_EXETOCHECK "" 0 skip_result
  Pop $G_EXETOCHECK           ; get the "path to executable" result
  Goto skip_window_caption

skip_result:
  Pop $G_TEMP           ; ignore the "path to executable" result

skip_window_caption:
  Pop $G_TEMP           ; ignore the "window caption" result
  goto get_search_result

nothing_to_report:
  StrCpy $G_EXETOCHECK ""

end_of_locked_list:
  Push $G_EXETOCHECK
  Goto exit

  ; Windows 95, 98, ME and NT3.x are treated as special cases
  ; (because they do not support the LockedList plugin)

specialcase:
  StrCpy $G_TEMP ""

loop:
  Pop $G_EXETOCHECK
  StrCmp $G_EXETOCHECK "${C_EXE_END_MARKER}" allread
  StrCmp $G_TEMP "" 0 loop
  IfFileExists "$G_EXETOCHECK" 0 loop
  SetFileAttributes "$G_EXETOCHECK" NORMAL
  ClearErrors
  FileOpen $G_FILE_HANDLE "$G_EXETOCHECK" a
  FileClose $G_FILE_HANDLE
  IfErrors 0 loop
  StrCpy $G_TEMP "$G_EXETOCHECK"
  Goto loop

allread:
  StrCpy $G_EXETOCHECK $G_TEMP
  Push $G_EXETOCHECK

exit:
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
# Note: If the CheckIfExeLocked function is run on NT4 or higher it will use the LockedList
# plugin which means the function's return value may not match any of the input data supplied
# to the function (e.g. if a SFN path is supplied the return value will use LFN format).
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
  !define L_RESULT        $R8
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
  Push ${L_RESULT}
  Push ${L_TIMEOUT}

  IfFileExists "${L_EXE}" 0 exit_now
  StrCpy ${L_TIMEOUT} ${C_SHUTDOWN_LIMIT}

check_if_unlocked:
  Sleep ${C_SHUTDOWN_DELAY}
  Push "${C_EXE_END_MARKER}"
  Push ${L_EXE}
  Call CheckIfExeLocked
  Pop ${L_RESULT}
  StrCmp ${L_RESULT} "" exit_now
  IntOp ${L_TIMEOUT} ${L_TIMEOUT} - 1
  IntCmp ${L_TIMEOUT} 0 exit_now exit_now check_if_unlocked

 exit_now:
  Pop ${L_TIMEOUT}
  Pop ${L_RESULT}
  Pop ${L_EXE}

  !undef L_EXE
  !undef L_RESULT
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
# The layout and content of the HTML page depends upon the UI language and UI skin selection.
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
#                                "success"    (i.e. UI shutdown request appeared to work)
#
#                                "failure"    (i.e. UI shutdown request failed)
#
#                                "password?"  (i.e. failure - UI may be password protected)
#
#                                "badport"    (i.e. failure - invalid UI port supplied)
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

  !define DECIMAL_DIGIT   "0123456789"   ; accept only these digits
  !define BAD_OFFSET      10             ; length of DECIMAL_DIGIT string

  !define L_STRING        $0   ; The input string
  !define L_RESULT        $1   ; Holds the result: either "" (if input is invalid) or the input string (if valid)
  !define L_CURRENT       $2   ; A character from the input string
  !define L_OFFSET        $3   ; The offset to a character in the "validity check" string
  !define L_VALIDCHAR     $4   ; A character from the "validity check" string
  !define L_VALIDLIST     $5   ; Holds the current "validity check" string
  !define L_CHARSLEFT     $6   ; To cater for MBCS input strings, terminate when end of string reached, not when a null byte reached

  Exch ${L_STRING}
  Push ${L_RESULT}
  Push ${L_CURRENT}
  Push ${L_OFFSET}
  Push ${L_VALIDCHAR}
  Push ${L_VALIDLIST}
  Push ${L_CHARSLEFT}

  StrCpy ${L_RESULT} ""

next_input_char:
  StrLen ${L_CHARSLEFT} ${L_STRING}
  StrCmp ${L_CHARSLEFT} 0 done
  StrCpy ${L_CURRENT} ${L_STRING} 1                   ; Get the next character from the input string
  StrCpy ${L_VALIDLIST} ${DECIMAL_DIGIT}${L_CURRENT}  ; Add it to end of "validity check" to guarantee a match
  StrCpy ${L_STRING} ${L_STRING} "" 1
  StrCpy ${L_OFFSET} -1

next_valid_char:
  IntOp ${L_OFFSET} ${L_OFFSET} + 1
  StrCpy ${L_VALIDCHAR} ${L_VALIDLIST} 1 ${L_OFFSET}    ; Extract next "valid" char (from "validity check" string)
  StrCmp ${L_CURRENT} ${L_VALIDCHAR} 0 next_valid_char
  IntCmp ${L_OFFSET} ${BAD_OFFSET} invalid 0 invalid    ; If match is with the char we added, input is bad
  StrCpy ${L_RESULT} ${L_RESULT}${L_VALIDCHAR}          ; Add "valid" character to the result
  goto next_input_char

invalid:
  StrCpy ${L_RESULT} ""

done:
  StrCpy ${L_STRING} ${L_RESULT}  ; Result is either a string of decimal digits or ""
  Pop ${L_CHARSLEFT}
  Pop ${L_VALIDLIST}
  Pop ${L_VALIDCHAR}
  Pop ${L_OFFSET}
  Pop ${L_CURRENT}
  Pop ${L_RESULT}
  Exch ${L_STRING}                ; Place result on top of the stack

  !undef DECIMAL_DIGIT
  !undef BAD_OFFSET

  !undef L_STRING
  !undef L_RESULT
  !undef L_CURRENT
  !undef L_OFFSET
  !undef L_VALIDCHAR
  !undef L_VALIDLIST
  !undef L_CHARSLEFT

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
# General Purpose Function: AtLeastWinNT4
#--------------------------------------------------------------------------
#
# This function is used to detect if we are running on Windows NT4 or later
#
# Inputs:
#         (none)
#
# Outputs:
#         (top of stack)   - 0 if Win9x or WinME, 1 if Win NT4 or higher
#
# Usage:
#
#         Call AtLeastWinNT4
#         Pop $R0
#
#         ($R0 at this point is "0" if running on Win95, Win98, WinME or NT3.x)
#
#--------------------------------------------------------------------------

Function AtLeastWinNT4

  !define L_RESULT  $R9
  !define L_TEMP    $R8

  Push ${L_RESULT}
  Push ${L_TEMP}

  ClearErrors
  ReadRegStr ${L_RESULT} HKLM "SOFTWARE\Microsoft\Windows NT\CurrentVersion" CurrentVersion
  IfErrors preNT4system
  StrCpy ${L_TEMP} ${L_RESULT} 1
  StrCmp ${L_TEMP} '3' preNT4system
  StrCpy ${L_RESULT} "1"
  Goto exit

preNT4system:
  StrCpy ${L_RESULT} "0"

exit:
  Pop ${L_TEMP}
  Exch ${L_RESULT}

  !undef L_RESULT
  !undef L_TEMP

FunctionEnd

#--------------------------------------------------------------------------
# End of OnDemand.nsi
#--------------------------------------------------------------------------
