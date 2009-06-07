#--------------------------------------------------------------------------
#
# dbicapture.nsi --- This NSIS script is used to create a modified version of the
#                    Message Capture utility. This modified version enables the
#                    DBI trace feature which generates extra console messages that
#                    may assist in debugging database problems.
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
#
#--------------------------------------------------------------------------

  ; This version of the script has been tested with the "NSIS v2.44" compiler,
  ; released 21 February 2009. This particular compiler can be downloaded from
  ; http://prdownloads.sourceforge.net/nsis/nsis-2.44-setup.exe?download
  ;
  ; Programs compiled by NSIS 2.44 will trigger Program Compatibility Assistant warnings
  ; when run on Windows 7 systems. In order to avoid these warnings the 'makensis.exe'
  ; compiler from NSIS 2.44 should be replaced by the patched one from PortableApps.com.
  ;
  ; This patched compiler can be downloaded from http://portableapps.com/node/19013
  ; (the patch makes the compiler generate a "Windows 7" compatible manifest).
  ; See this NSIS bug report for further details:
  ; https://sourceforge.net/tracker/?func=detail&atid=373085&aid=2725883&group_id=22049

  !define C_EXPECTED_VERSION  "v2.44-Win7-Patch-1-By-PortableApps.com"

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

  ; Although this utility was originally created for use with the 1.0.0 release it is
  ; compatible with many earlier installations created by the installer, though in some cases a
  ; small batch file may be required in order to define POPFILE_ROOT and POPFILE_USER before
  ; running it (this utility assumes these two environment variables have been defined).

#--------------------------------------------------------------------------
# Optional run-time command-line switch (used by 'dbicapture.exe')
#--------------------------------------------------------------------------
#
# /TRACE_LEVEL=x
#
# By default the utility uses DBI_TRACE level 1 and displays a page allowing the user to
# select another level in the range 0 (disabled) to 4. If a higher level is required or
# if the utility is to be run from a batch file then the required trace level (in the range
# 0 to 15) can be specified on the command-line instead of via the trace level selection page.
#
# If a trace level outside the range 0 to 15 is supplied an error message will be displayed.
#
# Uppercase or lowercase can be used for the command-line switch.
#
#--------------------------------------------------------------------------

  SetCompressor /solid lzma

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
  ; (two commonly used exceptions to this rule are 'IO_NL' and 'MB_NL')
  ;--------------------------------------------------------------------------

  !define C_VERSION             "0.0.10"

  !define C_OUTFILE             "dbicapture.exe"

  ;--------------------------------------------------------------------------
  ; The default NSIS caption is "$(^Name) Setup" so we override it here
  ;--------------------------------------------------------------------------

  Name    "POPFile DBI Trace Capture Utility"
  Caption "$(^Name) v${C_VERSION}"

  ;--------------------------------------------------------------------------
  ; Windows Vista expects to find a manifest specifying the execution level
  ;--------------------------------------------------------------------------

  RequestExecutionLevel   user

#--------------------------------------------------------------------------
# Use the "Modern User Interface"
#--------------------------------------------------------------------------

  !include "MUI.nsh"

#--------------------------------------------------------------------------
# Include private library functions and macro definitions
#--------------------------------------------------------------------------

  ; Avoid compiler warnings by disabling the functions and definitions we do not use
  ; (this is a modified version of the Message Capture utility so we re-use MSGCAPTURE here)

  !define MSGCAPTURE

  !include "pfi-library.nsh"

#--------------------------------------------------------------------------
# Version Information settings (for the utility's EXE file)
#--------------------------------------------------------------------------

  ; 'VIProductVersion' format is X.X.X.X where X is a number in range 0 to 65535
  ; representing the following values: Major.Minor.Release.Build

  VIProductVersion                          "${C_VERSION}.0"

  !define /date C_BUILD_YEAR                "%Y"

  VIAddVersionKey "ProductName"             "PFI DBI Trace Capture Utility"
  VIAddVersionKey "Comments"                "POPFile Homepage: http://getpopfile.org/"
  VIAddVersionKey "CompanyName"             "The POPFile Project"
  VIAddVersionKey "LegalTrademarks"         "POPFile is a registered trademark of John Graham-Cumming"
  VIAddVersionKey "LegalCopyright"          "Copyright (c) ${C_BUILD_YEAR}  John Graham-Cumming"
  VIAddVersionKey "FileDescription"         "PFI DBI Trace Capture Utility (levels 0 to 15)"
  VIAddVersionKey "FileVersion"             "${C_VERSION}"
  VIAddVersionKey "OriginalFilename"        "${C_OUTFILE}"

  VIAddVersionKey "Build Compiler"          "NSIS ${NSIS_VERSION}"
  VIAddVersionKey "Build Date/Time"         "${__DATE__} @ ${__TIME__}"
  !ifdef C_PFI_LIBRARY_VERSION
    VIAddVersionKey "Build Library Version" "${C_PFI_LIBRARY_VERSION}"
  !endif
  VIAddVersionKey "Build Script"            "${__FILE__}${MB_NL}(${__TIMESTAMP__})"

#--------------------------------------------------------------------------
# User Registers (Global)
#--------------------------------------------------------------------------

  ; This script uses 'User Variables' (with names starting with 'G_') to hold GLOBAL data.

  Var G_MODE_FLAG        ; Controls whether or not the trace level selection page appears
  Var G_TRACELEVEL       ; The trace level: 0 (disabled) to 15 (very detailed and obscure)

#--------------------------------------------------------------------------
# Configure the MUI pages
#--------------------------------------------------------------------------

  ;----------------------------------------------------------------
  ; Interface Settings - General Interface Settings
  ;----------------------------------------------------------------

  ; The icon file for the utility

  !define MUI_ICON                            "POPFileIcon\popfile.ico"

  !define MUI_HEADERIMAGE
  !define MUI_HEADERIMAGE_BITMAP              "hdr-common.bmp"
  !define MUI_HEADERIMAGE_RIGHT

  ;----------------------------------------------------------------
  ;  Interface Settings - Interface Resource Settings
  ;----------------------------------------------------------------

  ; The banner provided by the default 'modern.exe' UI does not provide much room for the
  ; two lines of text, e.g. the German version is truncated, so we use a custom UI which
  ; provides slightly wider text areas. Each area is still limited to a single line of text.

  !define MUI_UI                              "UI\pfi_modern.exe"

  ; The 'hdr-common.bmp' logo is only 90 x 57 pixels, much smaller than the 150 x 57 pixel
  ; space provided by the default 'modern_headerbmpr.exe' UI, so we use a custom UI which
  ; leaves more room for the TITLE and SUBTITLE text.

  !define MUI_UI_HEADERIMAGE_RIGHT            "UI\pfi_headerbmpr.exe"

  ;----------------------------------------------------------------
  ;  Interface Settings - Installer Finish Page Interface Settings
  ;----------------------------------------------------------------

  ; Show the installation log and leave the window open when utility has completed its work

  ShowInstDetails show
  !define MUI_FINISHPAGE_NOAUTOCLOSE

  ;----------------------------------------------------------------
  ; Customize MUI - General Custom Function
  ;----------------------------------------------------------------

  ; Use a custom '.onGUIInit' function to add language-specific texts to custom page INI file

  !define MUI_CUSTOMFUNCTION_GUIINIT          "PFIGUIInit"

#--------------------------------------------------------------------------
# Define the Page order for the utility
#--------------------------------------------------------------------------

  ;---------------------------------------------------
  ; Installer Page - Choose the DBI_TRACE setting
  ;---------------------------------------------------

  Page custom SelectTraceLevelPage

  ;---------------------------------------------------
  ; Installer Page - Install files
  ;---------------------------------------------------

  ; Override the standard "Installation complete..." page header

  !define MUI_INSTFILESPAGE_FINISHHEADER_TEXT     $(PFI_LANG_DBICAP_END_HDR)
  !define MUI_INSTFILESPAGE_FINISHHEADER_SUBTEXT  $(PFI_LANG_DBICAP_END_SUBHDR)

  ; Override the standard "Installation Aborted..." page header

  !define MUI_INSTFILESPAGE_ABORTHEADER_TEXT      $(PFI_LANG_DBICAP_ABORT_HDR)
  !define MUI_INSTFILESPAGE_ABORTHEADER_SUBTEXT   $(PFI_LANG_DBICAP_ABORT_SUBHDR)

  ; Use a custom "show" function to ensure the page header reflects the current
  ; trace level setting while the utility is capturing the POPFile console messages

  !define MUI_PAGE_CUSTOMFUNCTION_SHOW             UpdateHeader

  !insertmacro MUI_PAGE_INSTFILES

#--------------------------------------------------------------------------
# Language Support for the utility
#--------------------------------------------------------------------------

  !insertmacro MUI_LANGUAGE "English"

  ;--------------------------------------------------------------------------
  ; Current build only supports English and uses local strings
  ; instead of language strings from languages\*-pfi.nsh files
  ;--------------------------------------------------------------------------

  !macro PFI_DBICAP_TEXT NAME VALUE
    LangString ${NAME} ${LANG_ENGLISH} `${VALUE}`
  !macroend

  ; Strings used in the custom page used to select the trace level (this page may be suppressed)

  !insertmacro PFI_DBICAP_TEXT "PFI_LANG_SELECT_IO_BOX_HDR"     "DBI Trace Level Selection"

  !insertmacro PFI_DBICAP_TEXT "PFI_LANG_SELECT_IO_LEVEL_0"     "Trace Level 0 (trace disabled)"
  !insertmacro PFI_DBICAP_TEXT "PFI_LANG_SELECT_IO_LEVEL_1"     "Trace Level 1 (default, Trace DBI method calls returning with results or errors)"
  !insertmacro PFI_DBICAP_TEXT "PFI_LANG_SELECT_IO_LEVEL_2"     "Trace Level 2 (Trace method entry with parameters and returning with results)"
  !insertmacro PFI_DBICAP_TEXT "PFI_LANG_SELECT_IO_LEVEL_3"     "Trace Level 3 (As level 2, adding some high-level information from the driver and some internal information from the DBI)"
  !insertmacro PFI_DBICAP_TEXT "PFI_LANG_SELECT_IO_LEVEL_4"     "Trace Level 4 (As level 3, adding more detailed information from the driver)"

  !insertmacro PFI_DBICAP_TEXT "PFI_LANG_SELECT_IO_EXPLAIN"     "Trace level 1 is best for a simple overview of what's happening. Trace level 2 is a good choice for general purpose tracing. Levels 3 and above are best reserved for investigating a specific problem, when you need to see $\"inside$\" the driver and DBI."

  ; Strings used for the main window, shown whilst the utility is running and when the report is complete

  !insertmacro PFI_DBICAP_TEXT "PFI_LANG_DBICAP_SELECT_HDR"     "Select the DBI_TRACE level"
  !insertmacro PFI_DBICAP_TEXT "PFI_LANG_DBICAP_SELECT_SUBHDR"  "Enable or disable tracing of POPFile's database activity"

  !insertmacro PFI_DBICAP_TEXT "PFI_LANG_DBICAP_STD_HDR"        "Capturing 'level $G_TRACELEVEL' DBI trace messages from POPFile..."
  !insertmacro PFI_DBICAP_TEXT "PFI_LANG_DBICAP_STD_SUBHDR"     "Message capture will stop when POPFile shuts down"

  !insertmacro PFI_DBICAP_TEXT "PFI_LANG_DBICAP_NOTRACE_HDR"    "Capturing standard console messages from POPFile..."
  !insertmacro PFI_DBICAP_TEXT "PFI_LANG_DBICAP_NOTRACE_SUBHDR" "Message capture will stop when POPFile shuts down"

  !insertmacro PFI_DBICAP_TEXT "PFI_LANG_DBICAP_END_HDR"        "POPFile DBI Trace Capture Completed"
  !insertmacro PFI_DBICAP_TEXT "PFI_LANG_DBICAP_END_SUBHDR"     "To save the messages, use right-click in the message window,${MB_NL}copy to the clipboard then paste the messages into a text file"

  !insertmacro PFI_DBICAP_TEXT "PFI_LANG_DBICAP_ABORT_HDR"      "POPFile DBI Trace Capture Failed"
  !insertmacro PFI_DBICAP_TEXT "PFI_LANG_DBICAP_ABORT_SUBHDR"   "Problem detected - see error report in window below"

  !insertmacro PFI_DBICAP_TEXT "PFI_LANG_DBICAP_RIGHTCLICK"     "Right-click in the window below to copy the report to the clipboard"

  ; This utility's executable file might have been renamed so we need to ensure we use the correct name in the 'usage' message.

  !insertmacro PFI_DBICAP_TEXT "PFI_LANG_DBICAP_MBOPTIONERROR"  "'$G_TRACELEVEL' is not a valid option for this utility${MB_NL}${MB_NL}Usage: $EXEFILE /TRACE_LEVEL=x${MB_NL}where x is in the range 0 to 15${MB_NL}${MB_NL}(use 0 to disable database tracing)"

  !insertmacro PFI_DBICAP_TEXT "PFI_LANG_DBICAP_STARTBUTTON"    "Start"


#--------------------------------------------------------------------------
# General settings
#--------------------------------------------------------------------------

  ; Specify EXE filename and icon for the utility

  OutFile "${C_OUTFILE}"

  ; Ensure details are shown

  ShowInstDetails show

  ; This utility doesn't install anything so rename the "Install" button

  InstallButtonText "$(PFI_LANG_DBICAP_STARTBUTTON)"

#--------------------------------------------------------------------------
# Installer Function: .onInit
#
# Checks if the user has specified a trace level value to override the default setting
# using the /TRACE_LEVEL=x command-line option (valid values are in range 0 to 15 inclusive)
#
# If an invalid option is supplied, an error message is displayed.
#--------------------------------------------------------------------------

Function .onInit

  !define L_TEMP    $R9

  Push ${L_TEMP}

  !insertmacro MUI_INSTALLOPTIONS_EXTRACT "ioDTL.ini"

  StrCpy $G_MODE_FLAG "command-line"

  Call PFI_GetParameters
  Pop $G_TRACELEVEL
  StrCmp $G_TRACELEVEL "" default
  StrCmp $G_TRACELEVEL "/TIMEOUT=0" default
  StrCpy ${L_TEMP} $G_TRACELEVEL 13
  StrCmp ${L_TEMP} "/TRACE_LEVEL=" 0 usage_error
  StrCpy ${L_TEMP} $G_TRACELEVEL "" 13
  Push ${L_TEMP}
  Call PFI_StrCheckDecimal
  Pop ${L_TEMP}
  StrCmp ${L_TEMP} "" usage_error
  StrCmp ${L_TEMP} "0" exit
  IntCmp ${L_TEMP} 15 exit exit usage_error

usage_error:
  MessageBox MB_OK|MB_ICONSTOP "$(PFI_LANG_DBICAP_MBOPTIONERROR)"
  Abort

default:
  StrCpy $G_MODE_FLAG "radiobuttons"
  StrCpy ${L_TEMP} "0"

exit:
  StrCpy $G_TRACELEVEL ${L_TEMP}
  Pop ${L_TEMP}

  !undef L_TEMP

FunctionEnd

#--------------------------------------------------------------------------
# Installer Function: PFIGUIInit
# (custom .onGUIInit function)
#
# Used to complete the initialization of the utility.
#
# Language strings are used to populate the fields in the INI file, therefore
# this code cannot be included in '.onInit' (because the selected language
# is not available for use inside the '.onInit' function)
#--------------------------------------------------------------------------

Function PFIGUIInit

  ; This function adds language texts to the INI file used to define the
  ; custom page used to select the value to be assigned to the DBI_TRACE
  ; environment variable

  !insertmacro PFI_IO_TEXT "ioDTL.ini" "1" "$(PFI_LANG_SELECT_IO_BOX_HDR)"

  !insertmacro PFI_IO_TEXT "ioDTL.ini" "2" "$(PFI_LANG_SELECT_IO_LEVEL_0)"
  !insertmacro PFI_IO_TEXT "ioDTL.ini" "3" "$(PFI_LANG_SELECT_IO_LEVEL_1)"
  !insertmacro PFI_IO_TEXT "ioDTL.ini" "4" "$(PFI_LANG_SELECT_IO_LEVEL_2)"
  !insertmacro PFI_IO_TEXT "ioDTL.ini" "5" "$(PFI_LANG_SELECT_IO_LEVEL_3)"
  !insertmacro PFI_IO_TEXT "ioDTL.ini" "6" "$(PFI_LANG_SELECT_IO_LEVEL_4)"

  !insertmacro PFI_IO_TEXT "ioDTL.ini" "7" "$(PFI_LANG_SELECT_IO_EXPLAIN)"

FunctionEnd

#--------------------------------------------------------------------------
# Installer Function: SelectTraceLevelPage (generates a custom page)
#--------------------------------------------------------------------------

Function SelectTraceLevelPage

  StrCmp $G_MODE_FLAG "command-line" skip_page

  !define L_BUTTON    $R9

  Push ${L_BUTTON}

  !insertmacro MUI_HEADER_TEXT "$(PFI_LANG_DBICAP_SELECT_HDR)" "$(PFI_LANG_DBICAP_SELECT_SUBHDR)"

  !insertmacro MUI_INSTALLOPTIONS_INITDIALOG "ioDTL.ini"
  Pop ${L_BUTTON}                                                               ; Ignore HWND of the dialog
  !insertmacro MUI_INSTALLOPTIONS_READ ${L_BUTTON} "ioDTL.ini" "Field 3" "HWND" ; Field 3 selects 'Trace Level 1'
  SendMessage $HWNDPARENT ${WM_NEXTDLGCTL} ${L_BUTTON} 1                        ; Set focus to default radiobutton
  !insertmacro MUI_INSTALLOPTIONS_SHOW

  !insertmacro MUI_INSTALLOPTIONS_READ ${L_BUTTON} "ioDTL.ini" "Field 2" "State"
  StrCmp ${L_BUTTON} "0" check_level_4
  StrCpy $G_TRACELEVEL "0"
  Goto exit

check_level_4:
  !insertmacro MUI_INSTALLOPTIONS_READ ${L_BUTTON} "ioDTL.ini" "Field 6" "State"
  StrCmp ${L_BUTTON} "0" check_level_3
  StrCpy $G_TRACELEVEL "4"
  Goto exit

check_level_3:
  !insertmacro MUI_INSTALLOPTIONS_READ ${L_BUTTON} "ioDTL.ini" "Field 5" "State"
  StrCmp ${L_BUTTON} "0" check_level_2
  StrCpy $G_TRACELEVEL "3"
  Goto exit

check_level_2:
  !insertmacro MUI_INSTALLOPTIONS_READ ${L_BUTTON} "ioDTL.ini" "Field 4" "State"
  StrCmp ${L_BUTTON} "0" assume_level_1
  StrCpy $G_TRACELEVEL "2"
  Goto exit

assume_level_1:
  StrCpy $G_TRACELEVEL "1"

exit:
  Pop ${L_BUTTON}

skip_page:

  !undef L_BUTTON

FunctionEnd

#--------------------------------------------------------------------------
# Installer Function: UpdateHeader
# (the "show" function for the INSTFILES page)
#--------------------------------------------------------------------------

Function UpdateHeader

  ; Override the standard "Installing..." header with text appropriate to the /TRACE_LEVEL value

  StrCmp $G_TRACELEVEL "0" no_timeout

  !insertmacro MUI_HEADER_TEXT $(PFI_LANG_DBICAP_STD_HDR) $(PFI_LANG_DBICAP_STD_SUBHDR)
  Goto exit

no_timeout:
  !insertmacro MUI_HEADER_TEXT $(PFI_LANG_DBICAP_NOTRACE_HDR) $(PFI_LANG_DBICAP_NOTRACE_SUBHDR)

exit:
FunctionEnd

;--------------------------------------------------------------------------
; Section: default
;--------------------------------------------------------------------------

Section default

  !define L_DBITRACE      $R9   ; value of the DBI_TRACE environment variable
  !define L_PFI_ROOT      $R8   ; path to the POPFile program (popfile.pl, and other files)
  !define L_PFI_USER      $R7   ; path to user's 'popfile.cfg' file
  !define L_RESULT        $R6
  !define L_TEMP          $R5
  !define L_TRAYICON      $R4   ; system tray icon enabled ("i" ) or disabled ("") flag
  !define L_OPTIONS       $R3   ; POPFile 0.23.0 no longer displays startup messages by default
                                ; so we use the --verbose option to turn them back on

  !define L_RESERVED      $0    ; used in system.dll calls

  SetDetailsPrint textonly
  DetailPrint "$(PFI_LANG_DBICAP_RIGHTCLICK)"
  SetDetailsPrint listonly

  DetailPrint "------------------------------------------------------------"
  DetailPrint "$(^Name) v${C_VERSION}"
  DetailPrint "------------------------------------------------------------"

  System::Call 'Kernel32::SetEnvironmentVariableA(t, t) i("DBI_TRACE", "$G_TRACELEVEL").r0'
  StrCmp ${L_RESERVED} 0 0 read_environment_vars
  MessageBox MB_OK|MB_ICONSTOP "Fatal error: Unable to set the DBI_TRACE environment variable"
  Goto fatal_error

read_environment_vars:
  ReadEnvStr ${L_PFI_ROOT} "POPFILE_ROOT"
  ReadEnvStr ${L_PFI_USER} "POPFILE_USER"
  ReadEnvStr ${L_DBITRACE} "DBI_TRACE"

  StrCmp ${L_PFI_ROOT} "" no_root
  StrCmp ${L_PFI_USER} "" no_user

  IfFileExists "${L_PFI_USER}\popfile.cfg" found_cfg
  DetailPrint ""
  DetailPrint "Fatal error: cannot find POPFile configuration data"
  DetailPrint ""
  DetailPrint "(${L_PFI_USER}\popfile.cfg does not exist)"
  Goto fatal_error

no_root:
  DetailPrint ""
  DetailPrint "Fatal error: Environment variable POPFILE_ROOT is not defined"
  Goto fatal_error

no_user:
  DetailPrint ""
  DetailPrint "Fatal error: Environment variable POPFILE_USER is not defined"
  Goto fatal_error

start_failed:
  DetailPrint ""
  DetailPrint "Fatal error: unable to start '${L_PFI_ROOT}\popfile${L_TRAYICON}f.exe' program"

fatal_error:
  Abort

found_cfg:
  Push ${L_PFI_USER}        ; 'User Data' folder location
  Push "1"                  ; assume system tray icon is enabled (the current default setting)
  Call GetTrayIconSetting
  Pop ${L_TRAYICON}         ; "i" if system tray icon enabled, "" if it is disabled
  DetailPrint "EnvVar: POPFILE_ROOT = ${L_PFI_ROOT}"
  DetailPrint "EnvVar: POPFILE_USER = ${L_PFI_USER}"

  ; Starting with the 0.23.0 release, POPFile no longer displays startup messages
  ; so we use the 'verbose' option to turn them on. Earlier POPFile releases do not
  ; recognize this option and will not run if it is used, so we use the Database.pm
  ; file as a simple POPFile version test (this file was first used in 0.23.0)

  StrCpy ${L_OPTIONS} ""
  IfFileExists "${L_PFI_ROOT}\POPFile\Database.pm" 0 look_for_exe
  StrCpy ${L_OPTIONS} "--verbose"

look_for_exe:
  IfFileExists "${L_PFI_ROOT}\popfile${L_TRAYICON}f.exe" found_exe
  DetailPrint ""
  DetailPrint "Fatal error: cannot find POPFile program"
  DetailPrint ""
  DetailPrint "(${L_PFI_ROOT}\popfile${L_TRAYICON}f.exe does not exist)"
  Goto fatal_error

found_exe:
  DetailPrint "EnvVar:    DBI_TRACE = $G_TRACELEVEL"
  DetailPrint "Using 'popfile${L_TRAYICON}f.exe' to run POPFile"
  DetailPrint "------------------------------------------------------------"

  Call PFI_GetDateTimeStamp
  Pop ${L_TEMP}
  DetailPrint "(report started ${L_TEMP})"
  DetailPrint "------------------------------------------------------------"

  nsExec::ExecToLog '"${L_PFI_ROOT}\popfile${L_TRAYICON}f.exe" ${L_OPTIONS}'
  Pop ${L_RESULT}
  StrCmp ${L_RESULT} "error" start_failed

  DetailPrint ""
  DetailPrint "------------------------------------------------------------"
  DetailPrint "Status code: ${L_RESULT}"

  Call PFI_GetDateTimeStamp
  Pop ${L_TEMP}
  DetailPrint "------------------------------------------------------------"
  DetailPrint "(report finished ${L_TEMP})"
  DetailPrint "------------------------------------------------------------"
  SetDetailsPrint none

  !undef L_DBITRACE
  !undef L_PFI_ROOT
  !undef L_PFI_USER
  !undef L_RESULT
  !undef L_TEMP
  !undef L_TRAYICON

  !undef L_RESERVED

SectionEnd

#--------------------------------------------------------------------------
# Installer Function: GetTrayIconSetting
#
# Returns "i" if the system tray icon is enabled in popfile.cfg or "" if it is disabled.
# If the setting is not found in popfile.cfg, use the input parameter to determine the result.
#
# This function avoids the progress bar flicker seen when similar code was in the "Section" body
#--------------------------------------------------------------------------

Function GetTrayIconSetting

  !define L_CFG           $R9   ; file handle used to access 'popfile.cfg'
  !define L_ICONSETTING   $R8   ; 1 (or "i") = system tray icon enabled, 0 (or "") = disabled
  !define L_LINE          $R7   ; line (or part of line) read from 'popfile.cfg'
  !define L_TEMP          $R6
  !define L_TEXTEND       $R5   ; helps ensure correct handling of lines over 1023 chars long
  !define L_USERDATA      $R4   ; location of 'User Data'

  Exch ${L_ICONSETTING}         ; get the setting to be used if value not found in 'popfile.cfg'
  Exch
  Exch ${L_USERDATA}            ; get location where 'popfile.cfg' should be found
  Push ${L_CFG}
  Push ${L_LINE}
  Push ${L_TEMP}
  Push ${L_TEXTEND}

  FileOpen ${L_CFG} "${L_USERDATA}\popfile.cfg" r

found_eol:
  StrCpy ${L_TEXTEND} "<eol>"

loop:
  FileRead ${L_CFG} ${L_LINE}
  StrCmp ${L_LINE} "" options_done
  StrCmp ${L_TEXTEND} "<eol>" 0 check_eol
  StrCmp ${L_LINE} "$\n" loop

  StrCpy ${L_TEMP} ${L_LINE} 17
  StrCmp ${L_TEMP} "windows_trayicon " got_icon_option
  Goto check_eol

got_icon_option:
  StrCpy ${L_ICONSETTING} ${L_LINE} 1 17

check_eol:
  StrCpy ${L_TEXTEND} ${L_LINE} 1 -1
  StrCmp ${L_TEXTEND} "$\n" found_eol
  StrCmp ${L_TEXTEND} "$\r" found_eol loop

options_done:
  FileClose ${L_CFG}

  StrCmp ${L_ICONSETTING} "1" enabled
  StrCpy ${L_ICONSETTING} ""
  Goto exit

enabled:
  StrCpy ${L_ICONSETTING} "i"

exit:
  Pop ${L_TEXTEND}
  Pop ${L_TEMP}
  Pop ${L_LINE}
  Pop ${L_CFG}
  Pop ${L_USERDATA}
  Exch ${L_ICONSETTING}

  !undef L_CFG
  !undef L_ICONSETTING
  !undef L_LINE
  !undef L_TEMP
  !undef L_TEXTEND
  !undef L_USERDATA

FunctionEnd

#--------------------------------------------------------------------------
# End of 'dbicapture.nsi'
#--------------------------------------------------------------------------
