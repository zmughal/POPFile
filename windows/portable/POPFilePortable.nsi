#----------------------------------------------------------------------------------------
#
# POPFilePortable.nsi --- Launcher for the PortableApps format version of POPFile used
#                         to run POPFile from a UFD (USB Flash Drive) or similar device.
#
# Copyright (c) 2009 John Graham-Cumming
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
#----------------------------------------------------------------------------------------

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
          $\r$\n***   This script has only been tested using the NSIS \
          ${C_EXPECTED_VERSION} compiler\
          $\r$\n***   and may not work properly with this NSIS ${NSIS_VERSION} \
          compiler\
          $\r$\n***\
          $\r$\n***   The resulting 'installer' program should be tested \
          carefully!\
          $\r$\n$\r$\n"
  !endif

  !undef  ${NSIS_VERSION}_found
  !undef  C_EXPECTED_VERSION

#--------------------------------------------------------------------------
# Notes
#--------------------------------------------------------------------------
#
# Use this utility ('X:\PortableApps\POPFilePortable\POPFilePortable.exe') to start
# POPFile - DO NOT use any of the standard popfile*.exe programs in the 'App' folder!
#
# If no command-line options are supplied this utility makes the necessary preparations
# and starts up the portable version of POPFile. The portable version does not make any
# changes to the Windows Start Menu or the registry.
#
# This utility sets up the information required by the standard popfile*.exe programs
# in the 'X:\PortableApps\POPFilePortable\App\POPFile' folder to ensure they behave
# properly.
#
# This utility uses 'ExecWait" instead of 'Exec' to start POPFile in order to keep this
# utility running while POPFile is in use. This will make it easier for the installer to
# detect that POPFile is in use as it only needs to check one program instead of about
# half a dozen programs!
#
#--------------------------------------------------------------------------
#
# Extract from the PortableApps.com Format 0.91 (2009-06-11) specification
# (http://portableapps.com/development/portableapps.com_format):
#
#   The basic directory layout of each portable app consists of a main directory,
#   AppNamePortable, which contains three directories: App, Data and Other.
#
#     +--- AppNamePortable
#        |
#        +--- App
#        |  |
#        |  +--- AppInfo
#        |  |
#        |  +--- AppName
#        |  |
#        |  +--- DefaultData
#        |
#        +--- Data
#        |
#        +--- Other
#           |
#           +--- Help
#           |  |
#           |  +--- Images
#           |
#           +--- Source
#
#   AppNamePortable:
#     contains the main application launcher, typically named AppNamePortable.exe
#     and the main help file help.html. No other files are present in this directory
#     by default.
#
#   App:
#     contains all the binary and other files that make up the application itself,
#     usually within a directory called AppName. The other directory called AppInfo
#     contains the configuration details for the PortableApps.com Platform as well
#     as the icons used within the menu. The third directory, DefaultData is usually
#     used as a container for the default files to be placed within the Data directory.
#     Generally, the launcher, when run, will check if there is a set of files within
#     Data and, if not, will copy them from DefaultData.
#
#   Data:
#     contains all the user data for the application including settings, configuration
#     and other data that would usually be stored within APPDATA for a locally installed
#     application. The applications released by PortableApps.com typically contain the
#     settings in a settings subdirectory, profiles for Mozilla apps in a profiles
#     subdirectory. No application components (binary files, etc) should be contained
#     within the Data directory. The launcher or application must be able to recreate
#     the Data directory and all required files within it if it is missing.
#
#   Other:
#     contains files that don't fit into the other categories. The additional images
#     and other files used by help.html included in the main AppNamePortable are included
#     in a Help subdirectory in the Other directory. Images for the help file would be
#     included in an Images subdirectory within the Help subdirectory.
#
#   Any source code or source code licensing as well as the source files for the
#   PortableApps.com Installer (if desired) are included within the Source subdirectory.
#   This may include the source for the AppNamePortable.exe launcher, a readme.txt
#   file detailing the usage of the launcher, license information and other files.
#
#--------------------------------------------------------------------------

#--------------------------------------------------------------------------
# Optional run-time command-line switches
#--------------------------------------------------------------------------
#
# /?
#
# Displays a simple help message listing the command-line options (same as '/help').
#
# /help
#
# Displays a simple help message listing the command-line options (same as '/?').
#
# /lfnfixer
#
# If a Win9x system is detected run the LFN Fixer utility (unless it has already been run
# on this installation).
#
# /menu
#
# Displays a simple maintenance menu to make it easy to run some of the standard POPFile
# utilities, such as the SQLite database integrity check and SQLite command-line utility.
#
# /msgcapture
#
# By default POPFile runs without showing the console window. This command-line switch
# forces the utility to use the Message Capture utility in order to make it easy to see
# (and save) POPFile's console messages which are normally hidden from view.
#
# /sqlitecheck
#
# Runs the SQLite database status check utility to check the database integrity and
# report its current size.
#
# /sqliteutility
#
# Runs the appropriate SQLite command-line utility (sqlite.exe for SQLite 2.x databases
# or sqlite3.exe for SQLite 3.x databases). This allows the user to defragment the
# database or run SQL queries from a DOS-box.
#
#--------------------------------------------------------------------------

  ;--------------------------------------------------------------------------
  ; Select LZMA compression (to generate smallest EXE file)
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

  !define C_PFI_VERSION   "0.0.44"

  !define C_OUTFILE       "POPFilePortable.exe"

  !define CBP_C_INIFILE   "CBP_PAGE.INI"

  ;--------------------------------------------------------------------------
  ; The default NSIS caption is "$(^Name) Setup" so we override it here
  ;--------------------------------------------------------------------------

  Name    "POPFilePortable Launcher"
  Caption "$(^Name)"

  OutFile "${C_OUTFILE}"

  ; Ensure user cannot use the /NCRC command-line switch to disable CRC checking

  CRCcheck Force

  ;--------------------------------------------------------------------------
  ; Windows Vista expects to find a manifest specifying the execution level
  ;--------------------------------------------------------------------------

  RequestExecutionLevel   user

#--------------------------------------------------------------------------
# Use the nsDialog version of the "Modern User Interface"
#--------------------------------------------------------------------------

  !include "MUI2.nsh"

#--------------------------------------------------------------------------
# Include private library functions and macro definitions
#--------------------------------------------------------------------------

  ; Avoid compiler warnings by disabling the functions and definitions we do not use

  !define PORTABLE

  !include "ppl-library.nsh"

#--------------------------------------------------------------------------
# Version Information settings
#--------------------------------------------------------------------------

  ; 'VIProductVersion' format is X.X.X.X where X is a number in range 0 to 65535
  ; representing the following values: Major.Minor.Release.Build

  VIProductVersion                          "${C_PFI_VERSION}.0"

  !define /date C_BUILD_YEAR                "%Y"

  VIAddVersionKey "ProductName"             "POPFilePortable Launcher"
  VIAddVersionKey "Comments"                "POPFile Homepage: \
                                             http://getpopfile.org/"
  VIAddVersionKey "CompanyName"             "The POPFile Project"
  VIAddVersionKey "LegalTrademarks"         "POPFile is a registered trademark \
                                             of John Graham-Cumming"
  VIAddVersionKey "LegalCopyright"          "Copyright (c) ${C_BUILD_YEAR} \
                                             John Graham-Cumming"
  VIAddVersionKey "FileDescription"         "PortableApp.com format launcher \
                                             for POPFile"
  VIAddVersionKey "FileVersion"             "${C_PFI_VERSION}"
  VIAddVersionKey "OriginalFilename"        "${C_OUTFILE}"

  VIAddVersionKey "Build Compiler"          "NSIS ${NSIS_VERSION}"
  VIAddVersionKey "Build Date/Time"         "${__DATE__} @ ${__TIME__}"
  !ifdef C_PPL_LIBRARY_VERSION
    VIAddVersionKey "PPL Library Version"   "${C_PPL_LIBRARY_VERSION}"
  !endif
  VIAddVersionKey "Build Script"            "${__FILE__}${MB_NL}\
  (${__TIMESTAMP__})"

#--------------------------------------------------------------------------
# User Registers (Global)
#--------------------------------------------------------------------------

  ; 'User Variables' (with names starting with 'G_') are used to hold GLOBAL data.

  Var G_MODE               ; set from the command-line or the maintenance menu

  Var G_DATABASE           ; used for absolute path to the SQLite database

  Var G_PLS_FIELD_1        ; used to customize LangString text strings
  Var G_PLS_FIELD_2        ; (to make it easier to translate them later)

#--------------------------------------------------------------------------
# Configure the MUI2 page
#--------------------------------------------------------------------------

  ;----------------------------------------------------------------
  ; Interface Settings - General Interface Settings
  ;----------------------------------------------------------------

  !define MUI_ICON                            "..\POPFileIcon\popfile.ico"

  !define MUI_HEADERIMAGE
  !define MUI_HEADERIMAGE_BITMAP              "..\hdr-common.bmp"
  !define MUI_HEADERIMAGE_RIGHT

  ;----------------------------------------------------------------
  ;  Interface Settings - Interface Resource Settings
  ;----------------------------------------------------------------

  ; The banner provided by the default 'modern.exe' UI does not provide much room for
  ; the two lines of text, e.g. the German version is truncated, so we use a custom UI
  ; which provides slightly wider text areas. Each area is still limited to a single
  ; line of text.

  !define MUI_UI                              "..\UI\pfi_modern.exe"

  ; The 'hdr-common.bmp' logo is only 90 x 57 pixels, much smaller than the 150 x 57
  ; pixel space provided by the default 'modern_headerbmpr.exe' UI, so we use a custom
  ; UI which leaves more room for the TITLE and SUBTITLE text.

  !define MUI_UI_HEADERIMAGE_RIGHT            "..\UI\pfi_headerbmpr.exe"

#--------------------------------------------------------------------------
# Define the Page order for the utility
#--------------------------------------------------------------------------

  ;---------------------------------------------------
  ; Installer Page - Custom menu page with buttons
  ; (only shown when '/menu' command-line option supplied)
  ;---------------------------------------------------

  AutoCloseWindow true

  InstallButtonText "Close"

  Page custom MaintenanceOptions

  ;---------------------------------------------------
  ; Installer Page - Install files (this page is always hidden!)
  ;---------------------------------------------------

  !insertmacro MUI_PAGE_INSTFILES

#--------------------------------------------------------------------------
# Language Support for the utility
#--------------------------------------------------------------------------

  !insertmacro MUI_LANGUAGE "English"

  ;--------------------------------------------------------------------------
  ; Current build only supports English and uses local strings
  ; instead of language strings from languages\*-pfi.nsh files
  ;--------------------------------------------------------------------------

  !macro PFPL_TEXT NAME VALUE
    LangString ${NAME} ${LANG_ENGLISH} "${VALUE}"
  !macroend
  !define PFPL_TEXT  "!insertmacro PFPL_TEXT"

  ; Language strings used to display the 'Help' message box

  ${PFPL_TEXT} "PFPL_MSG_HELP_INTRO"        "POPFilePortable.exe command-line options:\
                                                ${MB_NL}"
  ${PFPL_TEXT} "PFPL_MSG_HELP_?"            "${MB_NL}/? $\t$\t - display this help page\
                                                ${MB_NL}"
  ${PFPL_TEXT} "PFPL_MSG_HELP_HELP"         "${MB_NL}/help $\t$\t - display this help page\
                                                ${MB_NL}"
  ${PFPL_TEXT} "PFPL_MSG_HELP_LFNFIX"       "${MB_NL}/lfnfixer $\t$\t - fix LFN problem \
                                                on Win9x${MB_NL}"
  ${PFPL_TEXT} "PFPL_MSG_HELP_MENU"         "${MB_NL}/menu $\t$\t - display the maintenance \
                                                menu${MB_NL}"
  ${PFPL_TEXT} "PFPL_MSG_HELP_MSGCAP"       "${MB_NL}/msgcapture $\t - run Message Capture \
                                                utility${MB_NL}"
  ${PFPL_TEXT} "PFPL_MSG_HELP_SQLCHECK"     "${MB_NL}/sqlitecheck $\t - check SQLite \
                                                database status${MB_NL}"
  ${PFPL_TEXT} "PFPL_MSG_HELP_SQLUTIL"      "${MB_NL}/sqliteutility $\t - run SQLite command-\
                                              line utility${MB_NL}"

  ; Language strings used to create the Maintenance Menu page

  ${PFPL_TEXT} "PFPL_MENU_HDR"              "POPFile Portable Maintenance Options"
  ${PFPL_TEXT} "PFPL_MENU_SUBHDR"           "Choose an item to run. Use 'Close' or 'Cancel' \
                                                to close this menu."

  ${PFPL_TEXT} "PFPL_MENU_BTN_POPFILE"      "Run POPFile"
  ${PFPL_TEXT} "PFPL_MENU_LBL_POPFILE"      "Run POPFile as normal (same as \
                                                'POPFile Portable' menu item)"

  ${PFPL_TEXT} "PFPL_MENU_BTN_MSGCAPTURE"   "Message Capture"
  ${PFPL_TEXT} "PFPL_MENU_LBL_MSGCAPTURE"   "Run POPFile with the console messages displayed"

  ${PFPL_TEXT} "PFPL_MENU_BTN_CHECKDB"      "Check Database"
  ${PFPL_TEXT} "PFPL_MENU_LBL_CHECKDB"      "Check the integrity of the SQLite database"

  ${PFPL_TEXT} "PFPL_MENU_BTN_SQLUTIL"      "SQLite Utility"
  ${PFPL_TEXT} "PFPL_MENU_LBL_SQLUTIL"      "Run the SQLite command-line utility ( for \
                                                advanced users only! )"

  ${PFPL_TEXT} "PFPL_MENU_BTN_LFNFIXER"     "Win9x Adjust"
  ${PFPL_TEXT} "PFPL_MENU_LBL_LFNFIXER"     "Adjust LFN names (Windows 9x/Me systems only)"

  ; Language strings used in error message boxes

  ${PFPL_TEXT} "PFPL_MSG_NOCREATEDATA"      "Cannot find 'Create User Data' utility:\
                                                ${MB_NL}${MB_NL}'$G_PLS_FIELD_1'"
  ${PFPL_TEXT} "PFPL_MSG_NODBSTATUS"        "Cannot find Database Status Check utility:\
                                                ${MB_NL}${MB_NL}'$G_PLS_FIELD_1'"
  ${PFPL_TEXT} "PFPL_MSG_NOLAUNCHER"        "Cannot find POPFile Portable Launcher:\
                                                ${MB_NL}${MB_NL}'$G_PLS_FIELD_1'"
  ${PFPL_TEXT} "PFPL_MSG_NOLFNFIXER"        "Cannot find LFN Fixer utility:\
                                                ${MB_NL}${MB_NL}'$G_PLS_FIELD_1'"

  ${PFPL_TEXT} "PFPL_MSG_NODATABASE"        "Cannot find POPFile Portable's Database\
                                                ${MB_NL}${MB_NL}($G_DATABASE)"

  ${PFPL_TEXT} "PFPL_MSG_UNKNOWNFMT_1"      "Unable to tell if '$G_DATABASE' is a SQLite \
                                                database file"
  ${PFPL_TEXT} "PFPL_MSG_UNKNOWNFMT_2"      "File format not known: $G_PLS_FIELD_1"
  ${PFPL_TEXT} "PFPL_MSG_UNKNOWNFMT_3"      "Please shutdown POPFile before using this \
                                                utility"

  ${PFPL_TEXT} "PFPL_MSG_UTILMISSING_1"     "The '$G_DATABASE' file is a \
                                                SQLite $G_PLS_FIELD_1 database"
  ${PFPL_TEXT} "PFPL_MSG_UTILMISSING_2"     "Unable to find the \
                                                '$EXEDIR\App\POPFile\$G_PLS_FIELD_2' file"

  ${PFPL_TEXT} "PFPL_MSG_UTILNOTSTART"      "Unable to start the '$G_PLS_FIELD_2' utility"

  ${PFPL_TEXT} "PFPL_MSG_ENVSETERROR"       "Error: Unable to set '${NAME}' environment \
                                                variable"

  ${PFPL_TEXT} "PFPL_MSG_PFNOTSTART_1"      "Error: Unable to start POPFile !"
  ${PFPL_TEXT} "PFPL_MSG_PFNOTSTART_2"      "POPFile start program not found:"
  ${PFPL_TEXT} "PFPL_MSG_PFNOTSTART_3"      "$G_PLS_FIELD_1"

  ${PFPL_TEXT} "PFPL_MSG_MSGCAPMISSING"     "Unable to find Message Capture utility!"

#--------------------------------------------------------------------------
# Installer Function: .onInit
#
# Do not allow more than one copy of the POPFile Portable Launcher to run
#
# Run silently if the '/menu' option has not been supplied on command-line
#--------------------------------------------------------------------------

Function .onInit

  !define L_RESERVED            $1    ; used in the system.dll call

  Push ${L_RESERVED}

  ; Ensure only one copy of this launcher is running

  System::Call \
      'kernel32::CreateMutexA(i 0, i 0, t "Only_One_PFP_Launcher_mutex") i .r1 ?e'
  Pop ${L_RESERVED}
  StrCmp ${L_RESERVED} 0 mutex_ok
  MessageBox MB_OK|MB_ICONEXCLAMATION "$(^Name) is already running"
  Abort

mutex_ok:
  Call PPL_GetParameters
  Pop $G_MODE
  StrCmp $G_MODE ""                     run_silent
  StrCmp $G_MODE "/?"                   run_silent
  StrCmp $G_MODE "/help"                run_silent
  StrCmp $G_MODE "/lfnfixer"            run_silent
  StrCmp $G_MODE "/menu"                continue
  StrCmp $G_MODE "/msgcapture"          run_silent
  StrCmp $G_MODE "/sqlitecheck"         run_silent
  StrCmp $G_MODE "/sqliteutility"       run_silent
  MessageBox MB_OK|MB_ICONSTOP "Unknown option supplied: $G_MODE"
  Quit

run_silent:
  SetSilent silent

continue:
  Pop ${L_RESERVED}

  !undef L_RESERVED

FunctionEnd

###########################################################################
#
# Optional 'Maintenance Menu': custom page and callback functions (start)
#
###########################################################################

#--------------------------------------------------------------------------
# Optional Maintenance Menu (only shown when '/menu' option supplied)
#
# Two functions are used to provide this menu:
#
# (1) MaintenanceOptions - creates the custom page with the buttons
#
# (2) OnClick_Button     - responds when a menu button is clicked
#
# For convenience these two functions use the same set of local variables
# (instead of creating global variables used only in these two functions)
#--------------------------------------------------------------------------

!macro DEFINE_MAINTENANCE_MENU_VARIABLES

  !define L_BTN_CAPTURE     $R9     ; HWND for the 'Message Capture' button
  !define L_BTN_CHECKDB     $R8     ; HWND for the 'Check Database'  button
  !define L_BTN_CLICKED     $R7     ; HWND for the 'Message Capture' button
  !define L_BTN_LFNFIXER    $R6     ; HWND for the 'Win9x Adjust'    button
  !define L_BTN_POPFILE     $R5     ; HWND for the 'Run POPFile'     button
  !define L_BTN_SQLUTIL     $R4     ; HWND for the 'SQLite Utility'  button
  !define L_LABEL           $R3     ; HWND for the label next to current button
  !define L_DIALOG          $R2     ; HWND for 'our' dialog
  !define L_ONCLICK_FUNC    $R1     ; click notification callback function address
  !define L_RESULT          $R0

!macroend

!macro UNDEF_MAINTENANCE_MENU_VARIABLES

  !undef L_BTN_CAPTURE
  !undef L_BTN_CHECKDB
  !undef L_BTN_CLICKED
  !undef L_BTN_LFNFIXER
  !undef L_BTN_POPFILE
  !undef L_BTN_SQLUTIL
  !undef L_LABEL
  !undef L_DIALOG
  !undef L_ONCLICK_FUNC
  !undef L_RESULT

!macroend

Function MaintenanceOptions

  !insertmacro DEFINE_MAINTENANCE_MENU_VARIABLES

  Push ${L_BTN_CAPTURE}
  Push ${L_BTN_CHECKDB}
  Push ${L_BTN_CLICKED}
  Push ${L_BTN_LFNFIXER}
  Push ${L_BTN_POPFILE}
  Push ${L_BTN_SQLUTIL}
  Push ${L_LABEL}
  Push ${L_DIALOG}
  Push ${L_ONCLICK_FUNC}
  Push ${L_RESULT}

  ; Ensure the working directory is set to the correct value for POPFilePortable
  ; (i.e. the directory containing the POPFilePortable launcher, not the one
  ; containing the POPFile program files)

  SetOutPath $EXEDIR

	nsDialogs::Create /NOUNLOAD 1018
	Pop ${L_DIALOG}

	GetFunctionAddress ${L_ONCLICK_FUNC} OnClick_Button

	${NSD_CreateButton} 0 0 25% 18u "$(PFPL_MENU_BTN_POPFILE)"
	Pop ${L_BTN_POPFILE}
	nsDialogs::OnClick /NOUNLOAD ${L_BTN_POPFILE} ${L_ONCLICK_FUNC}
	${NSD_CreateLabel} 30% 5u 75% 15u "$(PFPL_MENU_LBL_POPFILE)"
	Pop ${L_LABEL}

	${NSD_CreateButton} 0 30u 25% 18u "$(PFPL_MENU_BTN_MSGCAPTURE)"
	Pop ${L_BTN_CAPTURE}
	nsDialogs::OnClick /NOUNLOAD ${L_BTN_CAPTURE} ${L_ONCLICK_FUNC}
	${NSD_CreateLabel} 30% 35u 75% 15u "$(PFPL_MENU_LBL_MSGCAPTURE)"
	Pop ${L_LABEL}

	${NSD_CreateButton} 0 60u 25% 18u "$(PFPL_MENU_BTN_CHECKDB)"
	Pop ${L_BTN_CHECKDB}
	nsDialogs::OnClick /NOUNLOAD ${L_BTN_CHECKDB} ${L_ONCLICK_FUNC}
	${NSD_CreateLabel} 30% 65u 75% 15u "$(PFPL_MENU_LBL_CHECKDB)"
	Pop ${L_LABEL}

	${NSD_CreateButton} 0 90u 25% 18u "$(PFPL_MENU_BTN_SQLUTIL)"
	Pop ${L_BTN_SQLUTIL}
	nsDialogs::OnClick /NOUNLOAD ${L_BTN_SQLUTIL} ${L_ONCLICK_FUNC}
	${NSD_CreateLabel} 30% 95u 75% 15u "$(PFPL_MENU_LBL_SQLUTIL)"
	Pop ${L_LABEL}

	${NSD_CreateButton} 0 120u 25% 18u "$(PFPL_MENU_BTN_LFNFIXER)"
	Pop ${L_BTN_LFNFIXER}
	nsDialogs::OnClick /NOUNLOAD ${L_BTN_LFNFIXER} ${L_ONCLICK_FUNC}
	${NSD_CreateLabel} 30% 125u 75% 15u "$(PFPL_MENU_LBL_LFNFIXER)"
	Pop ${L_LABEL}

  ; If POPFilePortable was originally installed on an NTFS-based system then
  ; the LFNFIXER utility may need to be run when we are connected to a Win9x
  ; system. LFNFIXER adjusts certain folder & file names to avoid runtime errors.

  ReadRegStr ${L_RESULT} HKLM \
      "SOFTWARE\Microsoft\Windows NT\CurrentVersion" CurrentVersion
  StrCmp ${L_RESULT} "" 0 disable_lfnfixer

  ; If LFNFIXER has already been run then there is no need to run it again

  IfFileExists "$EXEDIR\Data\pfpi.ini" 0 show_page

disable_lfnfixer:
  EnableWindow ${L_BTN_LFNFIXER} 0
  EnableWindow ${L_LABEL} 0

show_page:
  !insertmacro MUI_HEADER_TEXT "$(PFPL_MENU_HDR)" "$(PFPL_MENU_SUBHDR)"
	nsDialogs::Show

  Pop ${L_RESULT}
  Pop ${L_ONCLICK_FUNC}
  Pop ${L_DIALOG}
  Pop ${L_LABEL}
  Pop ${L_BTN_SQLUTIL}
  Pop ${L_BTN_POPFILE}
  Pop ${L_BTN_LFNFIXER}
  Pop ${L_BTN_CLICKED}
  Pop ${L_BTN_CHECKDB}
  Pop ${L_BTN_CAPTURE}

  !insertmacro UNDEF_MAINTENANCE_MENU_VARIABLES

FunctionEnd

#--------------------------------------------------------------------------
# Callback function used when a button is clicked on the Maintenance Menu
#--------------------------------------------------------------------------

Function OnClick_Button

  !insertmacro DEFINE_MAINTENANCE_MENU_VARIABLES

	Pop ${L_BTN_CLICKED} # HWND of the control that was clicked

  IfFileExists "$EXEDIR\POPFilePortable.exe" handle_click
  StrCpy $G_PLS_FIELD_1 "$EXEDIR\POPFilePortable.exe"
  MessageBox MB_OK "$(PFPL_MSG_NOLAUNCHER)"
  Goto close_window

handle_click:
  StrCmp ${L_BTN_CLICKED} ${L_BTN_POPFILE}   runpopfile
  StrCmp ${L_BTN_CLICKED} ${L_BTN_CAPTURE}   msgcapture
  StrCmp ${L_BTN_CLICKED} ${L_BTN_CHECKDB}   checkdatabase
  StrCmp ${L_BTN_CLICKED} ${L_BTN_SQLUTIL}   sqliteutil
  StrCmp ${L_BTN_CLICKED} ${L_BTN_LFNFIXER}  lfnfixer
  Goto exit

runpopfile:
  StrCpy $G_MODE ""
  Goto close_window

msgcapture:
  StrCpy $G_MODE "/msgcapture"
  Goto close_window

checkdatabase:
  StrCpy $G_MODE "/sqlitecheck"
  Goto close_window

sqliteutil:
  StrCpy $G_MODE "/sqliteutility"
  Goto close_window

lfnfixer:
  StrCpy $G_MODE "/lfnfixer"

close_window:
  SendMessage $HWNDPARENT "0x408" "1" ""

exit:
  !insertmacro UNDEF_MAINTENANCE_MENU_VARIABLES

FunctionEnd

###########################################################################
#
# Optional 'Maintenance Menu': custom page and callback functions (end)
#
###########################################################################

!macro SET_TEMP_ENVIRONMENT_VARIABLE NAME VALUE

      !insertmacro PPL_UNIQUE_ID

      System::Call \
      'Kernel32::SetEnvironmentVariableA(t, t) i("${NAME}", "${VALUE}").r0'
      StrCmp ${L_RESERVED} 0 0 continue_${PPL_UNIQUE_ID}
      MessageBox MB_OK|MB_ICONSTOP "$(PFPL_MSG_ENVSETERROR)"
      Goto exit

  continue_${PPL_UNIQUE_ID}:
!macroend

#--------------------------------------------------------------------------
# Section: default (always run silently)
#
# Perform the required POPFilePortable Launcher actions.
#
# If the Maintenance Menu was exited without selecting an option then
# $G_MODE will still be '/menu' so there is nothing for us to do!
#--------------------------------------------------------------------------

Section default

  ; Normally this launcher runs silently. However if the '/menu' option was
  ; supplied it will display a window containing several buttons making it
  ; easy to perform some standard POPFile Maintenance activities. If this
  ; menu has been displayed we hide it once the user has clicked a button.

  IfSilent continue
  HideWindow

continue:

  !define L_CONSOLE       $R9   ; 1 = console mode, 0 = background mode
  !define L_FILEHANDLE    $R8   ; used when searching the DATA folder
  !define L_FILENAME      $R7   ; entry found when searching the DATA folder
  !define L_ICONSETTING   $R6   ; 1 (or "i") = tray icon enabled, 0 (or "") = disabled
  !define L_PFI_ROOT      $R5   ; path to the POPFile program (popfile.pl, etc)
  !define L_PFI_USER      $R4   ; path to user's 'popfile.cfg' file
  !define L_RESULT        $R3
  !define L_SQLITEUTIL    $R2   ; SQLite utility (sqlite3.exe or sqlite.exe)
  !define L_TEMP          $R1
  !define L_WORKINGDIR    $R0   ; used to manipulate current working directory

  !define L_RESERVED      $0    ; used in system.dll calls

  Push ${L_CONSOLE}
  Push ${L_FILEHANDLE}
  Push ${L_FILENAME}
  Push ${L_ICONSETTING}
  Push ${L_PFI_ROOT}
  Push ${L_PFI_USER}
  Push ${L_RESULT}
  Push ${L_SQLITEUTIL}
  Push ${L_TEMP}
  Push ${L_WORKINGDIR}

  Push ${L_RESERVED}

  StrCpy $G_DATABASE "$EXEDIR\Data\popfile.db"

;----------------------------------------------------------
;      Has a Maintenance Menu option been selected ?
;----------------------------------------------------------

  StrCmp $G_MODE "/menu"                exit
  StrCmp $G_MODE ""                     run_popfile
  StrCmp $G_MODE "/?"                   display_help_page
  StrCmp $G_MODE "/help"                display_help_page
  StrCmp $G_MODE "/lfnfixer"            run_lfnfixer
  StrCmp $G_MODE "/msgcapture"          run_popfile
  StrCmp $G_MODE "/sqlitecheck"         run_db_check
  StrCmp $G_MODE "/sqliteutility"       run_sqlite_util

;----------------------------------------------------------
;                Display the help page
;----------------------------------------------------------

display_help_page:
  MessageBox MB_OK "$(PFPL_MSG_HELP_INTRO)\
    $(PFPL_MSG_HELP_?)\
    $(PFPL_MSG_HELP_HELP)\
    $(PFPL_MSG_HELP_LFNFIX)\
    $(PFPL_MSG_HELP_MENU)\
    $(PFPL_MSG_HELP_MSGCAP)\
    $(PFPL_MSG_HELP_SQLCHECK)\
    $(PFPL_MSG_HELP_SQLUTIL)"
  Goto exit

;----------------------------------------------------------
;           Run LFN Fixer (only needed on Win9x systems)
;----------------------------------------------------------

run_lfnfixer:
  IfFileExists "$EXEDIR\App\POPFile\lfnfixer.exe" execute_lfn_fixer
  StrCpy $G_PLS_FIELD_1 "$EXEDIR\App\POPFile\lfnfixer.exe"
  MessageBox MB_OK|MB_ICONSTOP "$(PFPL_MSG_NOLFNFIXER)"
  Goto exit

execute_lfn_fixer:
  WriteINIStr "$EXEDIR\Data\pfpi.ini" "LFN_fixer" "RunBy" "${C_OUTFILE} $G_MODE"
  ExecWait '"$EXEDIR\App\POPFile\lfnfixer.exe" /wait'
  Goto exit

;----------------------------------------------------------
;                Check SQLite database status
;----------------------------------------------------------

run_db_check:
  IfFileExists "$EXEDIR\App\POPFile\pfidbstatus.exe" execute_db_check
  StrCpy $G_PLS_FIELD_1 "$EXEDIR\App\POPFile\pfidbstatus.exe"
  MessageBox MB_OK|MB_ICONSTOP "$(PFPL_MSG_NODBSTATUS)"
  Goto exit

execute_db_check:
  ExecWait '"$EXEDIR\App\POPFile\pfidbstatus.exe" "$G_DATABASE"'
  Goto exit

;----------------------------------------------------------
;         Run SQLite 2.x/3.x command-line utility
;----------------------------------------------------------

run_sqlite_util:
  IfFileExists "$G_DATABASE" choose_sqlite_util
  MessageBox MB_OK|MB_ICONSTOP "$(PFPL_MSG_NODATABASE)"
  Goto exit

  ; The standard 'runsqlite.exe' utility exits when it starts the SQLite utility
  ; so we cannot use it here (because we need to use 'ExecWait' in order to keep
  ; the launcher running until the SQLite utility has been closed).

choose_sqlite_util:
  Push "$G_DATABASE"
  Call PPL_GetSQLiteFormat
  Pop $G_PLS_FIELD_1
  StrCpy ${L_SQLITEUTIL} "sqlite3.exe"
  StrCmp $G_PLS_FIELD_1 "3.x" check_util_exists
  StrCpy ${L_SQLITEUTIL} "sqlite.exe"
  StrCmp $G_PLS_FIELD_1 "2.x" check_util_exists
  MessageBox MB_OK|MB_ICONEXCLAMATION "$(PFPL_MSG_UNKNOWNFMT_1)\
      ${MB_NL}${MB_NL}\
      $(PFPL_MSG_UNKNOWNFMT_2)\
      ${MB_NL}${MB_NL}\
      $(PFPL_MSG_UNKNOWNFMT_3)"
  Goto exit

check_util_exists:
  IfFileExists "$EXEDIR\App\POPFile\${L_SQLITEUTIL}" prepare_cmdline
  StrCpy $G_PLS_FIELD_2 "${L_SQLITEUTIL}"
  MessageBox MB_OK|MB_ICONEXCLAMATION \
      "$(PFPL_MSG_UTILMISSING_1)\
      ${MB_NL}${MB_NL}${MB_NL}\
      $(PFPL_MSG_UTILMISSING_2)"
  Goto exit

prepare_cmdline:
  GetFullPathName ${L_WORKINGDIR} ".\"

  Push $G_DATABASE
  Call PPL_GetParent
  Pop ${L_RESULT}
  StrCmp ${L_RESULT} "" execute_sqlite

  ; The SQLite command-line utility does not handle paths containing non-ASCII
  ; characters properly. To avoid problems temporarily change the current working
  ; directory to the folder containing the database and supply only the database's
  ; filename when calling the command-line utility.

  StrLen ${L_TEMP} ${L_RESULT}
  IntOp ${L_TEMP} ${L_TEMP} + 1
  StrCpy $G_DATABASE $G_DATABASE "" ${L_TEMP}
  SetOutPath "${L_RESULT}"

execute_sqlite:
  ClearErrors
  ExecWait '"$EXEDIR\App\POPFile\${L_SQLITEUTIL}" "$G_DATABASE'
  SetOutPath ${L_WORKINGDIR}
  IfErrors start_error
  Goto exit

start_error:
  MessageBox MB_OK|MB_ICONEXCLAMATION "$(PFPL_MSG_UTILNOTSTART)"
  Goto exit

;----------------------------------------------------------
;      Run POPFile (in normal or 'Message Capture' mode)
;----------------------------------------------------------

run_popfile:
  ReadRegStr ${L_TEMP} HKLM \
      "SOFTWARE\Microsoft\Windows NT\CurrentVersion" CurrentVersion
  StrCmp ${L_TEMP} "" 0 look_for_userdata
  IfFileExists "$EXEDIR\Data\pfpi.ini" look_for_userdata
  IfFileExists "$EXEDIR\App\POPFile\lfnfixer.exe" fix_lfn_problems
  StrCpy $G_PLS_FIELD_1 "$EXEDIR\App\POPFile\lfnfixer.exe"
  MessageBox MB_OK|MB_ICONSTOP "$(PFPL_MSG_NOLFNFIXER)"
  Goto exit

fix_lfn_problems:
  ExecWait '"$EXEDIR\App\POPFile\lfnfixer.exe"'
  WriteINIStr "$EXEDIR\Data\pfpi.ini" "LFN_fixer" "RunBy" "${C_OUTFILE}"

look_for_userdata:
  StrCpy ${L_RESULT} "clean"
  IfFileExists "$EXEDIR\Data\*.*" search_for_files
  CreateDirectory "$EXEDIR\Data\"
  Goto default_stopwords

search_for_files:
  FindFirst ${L_FILEHANDLE} ${L_FILENAME} "$EXEDIR\Data\*.*"

continue_search:
  FindNext ${L_FILEHANDLE} ${L_FILENAME}
  StrCmp ${L_FILENAME} ".." continue_search
  StrCmp ${L_FILENAME} "pfpi.ini" continue_search
  StrCmp ${L_FILENAME} "" search_done
  StrCpy ${L_RESULT} "dirty"

search_done:
  FindClose ${L_FILEHANDLE}
  StrCmp ${L_RESULT} "dirty" check_existing_data

default_stopwords:
  IfFileExists "$EXEDIR\App\DefaultData\stopwords" 0 create_data
  CopyFiles "$EXEDIR\App\DefaultData\stopwords" "$EXEDIR\Data\"

check_existing_data:
  IfFileExists "$EXEDIR\Data\popfile.cfg" 0 create_data
  IfFileExists "$G_DATABASE" prepare_env_vars

create_data:
  IfFileExists "$EXEDIR\App\POPFile\CreateUserData.exe" create_data_now
  StrCpy $G_PLS_FIELD_1 "$EXEDIR\App\POPFile\CreateUserData.exe"
  MessageBox MB_OK|MB_ICONSTOP "$(PFPL_MSG_NOCREATEDATA)"
  Goto exit

create_data_now:
  ExecWait '"$EXEDIR\App\POPFile\CreateUserData.exe"'
  IfFileExists "$EXEDIR\Data\popfile.cfg" prepare_env_vars
  IfFileExists "$EXEDIR\App\DefaultData\popfile.cfg" 0 prepare_env_vars
  CopyFiles "$EXEDIR\App\DefaultData\popfile.cfg" "$EXEDIR\Data\"

prepare_env_vars:
  SetOutPath $EXEDIR
  StrCpy ${L_PFI_ROOT} ".\App\POPFile"
  StrCpy ${L_PFI_USER} ".\Data"

  !insertmacro SET_TEMP_ENVIRONMENT_VARIABLE "POPFILE_ROOT" "${L_PFI_ROOT}"
  !insertmacro SET_TEMP_ENVIRONMENT_VARIABLE "POPFILE_USER" "${L_PFI_USER}"

  StrCpy ${L_TEMP} "$EXEDIR\App\POPFile\kakasi\share\kakasi\itaijidict"
  IfFileExists "${L_TEMP}" set_temp_itaijidict
  StrCpy ${L_TEMP} ""

set_temp_itaijidict:
  !insertmacro SET_TEMP_ENVIRONMENT_VARIABLE "ITAIJIDICTPATH" "${L_TEMP}"

  StrCpy ${L_TEMP} "$EXEDIR\App\POPFile\kakasi\share\kakasi\kanwadict"
  IfFileExists "${L_TEMP}" set_temp_kanwadict
  StrCpy ${L_TEMP} ""

set_temp_kanwadict:
  !insertmacro SET_TEMP_ENVIRONMENT_VARIABLE "KANWADICTPATH" "${L_TEMP}"

  StrCpy ${L_TEMP} "$EXEDIR\App\POPFile\mecab\etc\mecabrc"
  IfFileExists "${L_TEMP}" set_temp_mecab
  StrCpy ${L_TEMP} ""

set_temp_mecab:
  !insertmacro SET_TEMP_ENVIRONMENT_VARIABLE "MECABRC" "${L_TEMP}"

  ; Now start POPFile (we avoid using 'popfile.exe' here because it exits immediately)

  Push "$TEMP"
  Call SetPortablePIDdir

  StrCmp $G_MODE "/msgcapture" use_debug_mode

  StrCpy ${L_CONSOLE} "0"             # default to running without the console window
  StrCpy ${L_ICONSETTING} "1"         # default to using the system tray icon
  IfFileExists "$EXEDIR\Data\popfile.cfg" 0 use_the_settings

  Push "$EXEDIR\Data\popfile.cfg"
  Push "windows_console"
  Call PPL_CfgSettingRead
  Pop ${L_TEMP}
  IfErrors get_trayicon_setting
  StrCpy ${L_CONSOLE} ${L_TEMP}

get_trayicon_setting:
  Push "$EXEDIR\Data\popfile.cfg"
  Push "windows_trayicon"
  Call PPL_CfgSettingRead
  Pop ${L_TEMP}
  IfErrors use_the_settings
  StrCpy ${L_ICONSETTING} ${L_TEMP}

use_the_settings:
  IfFileExists "$EXEDIR\App\POPFile\pfimsgcapture.exe" 0 use_normal_mode
  StrCmp ${L_CONSOLE} "1" use_debug_mode no_console

use_normal_mode:
  StrCmp ${L_CONSOLE} "0" no_console
  StrCpy ${L_CONSOLE} "f"
  Goto check_icon_setting

no_console:
  StrCpy ${L_CONSOLE} "b"

check_icon_setting:
  StrCmp ${L_ICONSETTING} "0" no_icon
  StrCpy ${L_ICONSETTING} "i"
  Goto run_standard_exe

no_icon:
  StrCpy ${L_ICONSETTING} ""

run_standard_exe:
  StrCpy $G_PLS_FIELD_1 "$EXEDIR\App\POPFile\popfile${L_ICONSETTING}${L_CONSOLE}.exe"
  IfFileExists "$G_PLS_FIELD_1" found_exe_file
  MessageBox MB_OK|MB_ICONSTOP "$(PFPL_MSG_PFNOTSTART_1)\
      ${MB_NL}${MB_NL}\
      $(PFPL_MSG_PFNOTSTART_2)\
      ${MB_NL}${MB_NL}\
      $(PFPL_MSG_PFNOTSTART_3)"
  Goto exit

found_exe_file:
  ExecWait '"$G_PLS_FIELD_1"'
  Goto exit

use_debug_mode:
  IfFileExists "$EXEDIR\App\POPFile\msgcapture.exe" std_debug_run
  IfFileExists "$EXEDIR\App\POPFile\pfimsgcapture.exe" alt_debug_run
  MessageBox MB_OK "$(PFPL_MSG_MSGCAPMISSING)\
      ${MB_NL}${MB_NL}\
      ('$EXEDIR\App\POPFile\msgcapture.exe')\
      ${MB_NL}${MB_NL}\
      '($EXEDIR\App\POPFile\pfimsgcapture.exe')"
  Goto exit

alt_debug_run:
  ExecWait '"$EXEDIR\App\POPFile\pfimsgcapture.exe" /TIMEOUT=0'
  Goto exit

std_debug_run:
  ExecWait '"$EXEDIR\App\POPFile\msgcapture.exe" /TIMEOUT=0'

exit:
  Call RemoveEmptyCBPCorpus

  Pop ${L_RESERVED}

  Pop ${L_WORKINGDIR}
  Pop ${L_TEMP}
  Pop ${L_SQLITEUTIL}
  Pop ${L_RESULT}
  Pop ${L_PFI_USER}
  Pop ${L_PFI_ROOT}
  Pop ${L_ICONSETTING}
  Pop ${L_FILENAME}
  Pop ${L_FILEHANDLE}
  Pop ${L_CONSOLE}

  !undef L_CONSOLE
  !undef L_FILEHANDLE
  !undef L_FILENAME
  !undef L_ICONSETTING
  !undef L_PFI_ROOT
  !undef L_PFI_USER
  !undef L_RESULT
  !undef L_SQLITEUTIL
  !undef L_TEMP
  !undef L_WORKINGDIR

  !undef L_RESERVED

SectionEnd

#--------------------------------------------------------------------------
# Installer Function: PPL_CfgSettingWrite_with_backup
#
# Inputs:
#         (top of stack)        - the value to be set (if "" setting will be deleted)
#         (top of stack - 1)    - the configuration setting's name
#         (top of stack - 2)    - full path to the configuration file
#
# Outputs:
#         (top of stack)        - operation result:
#                                    CHANGED - the setting has been changed,
#                                    DELETED - entry deleted from the file,
#                                    ADDED   - new entry added at end of file,
#                                    SAME    - file left unchanged,
#                                 or ERROR   - an error was detected
#
#         ErrorFlag             - clear if no errors detected,
#                                 set if file not found, or
#                                 set if setting not found
#
# Usage (after macro has been 'inserted'):
#
#         Push "C:\User\Data\POPFile\popfile.cfg"
#         Push "html_port"
#         Push "8080"
#         Call PPL_CfgSettingWrite_with_backup
#         Pop $R0
#
#         ($R0 at this point is "SAME" if the configuration file currently
#          uses the value 8080; in this case the file is not re-written so
#          a backup copy of the original file is _not_ made)
#
#--------------------------------------------------------------------------

  !insertmacro PPL_CfgSettingWrite_with_backup ""

#--------------------------------------------------------------------------
# Installer Function: SetPortablePIDdir
#
# Used to ensure the 'portable-popfile.pid' file gets stored in the host's TEMP folder
# (NB The PID file used by the normal version of POPFile is called 'popfile.pid')
#
# Inputs:
#         (top of stack)     - required directory for config_piddir setting
#
# Outputs:
#         none
#
# Usage:
#         Push "$TEMP"
#         Call SetPortablePIDdir
#
#--------------------------------------------------------------------------

Function SetPortablePIDdir

  !define L_PID_DIR     $R9   ; required config_piddir directory
  !define L_RESULT      $R8

  Exch ${L_PID_DIR}
  Push ${L_RESULT}

  ; Accept the normal default setting if it is supplied (this means we use the UFD!)

  StrCmp ${L_PID_DIR} "./" 0 validate_input
  StrCpy ${L_PID_DIR} "."
  Goto update_cfg_file

  ; Specified path must be an existing directory path. If the path contains
  ; spaces we try to use the SFN format for the setting in popfile.cfg.

validate_input:
  StrCpy ${L_RESULT} ${L_PID_DIR} 1 -1
  StrCmp ${L_RESULT} '\' strip_trailing_slash
  StrCmp ${L_RESULT} '/' 0 check_dir_exists

strip_trailing_slash:
  StrCpy ${L_PID_DIR} ${L_PID_DIR} -1

check_dir_exists:
  IfFileExists "${L_PID_DIR}\*.*" dir_exists
  MessageBox MB_OK|MB_ICONSTOP "*** Fatal internal error ***\
      ${MB_NL}\
      Requested PID location is not a directory\
      ${MB_NL}${MB_NL}\
      (${L_PID_DIR})"
  Abort

dir_exists:
  Push ${L_PID_DIR}
  Push ' '
  Call PPL_StrStr
  Pop ${L_RESULT}
  StrCmp ${L_RESULT} "" update_cfg_file
  Push ${L_PID_DIR}
  Call PPL_GetSFNStatus
  Pop ${L_RESULT}
  StrCmp ${L_RESULT} "1" useSFNformat
  StrCpy ${L_PID_DIR} "."
  GetFullPathName ${L_RESULT} "${L_PID_DIR}\Data"
  MessageBox MB_OK|MB_ICONEXCLAMATION "*** Warning ***\
      ${MB_NL}\
      Unable to use SFN format so PID file will be stored in\
      ${MB_NL}\
      '${L_RESULT}' folder"
  Goto update_cfg_file

useSFNformat:
  GetFullPathName /SHORT ${L_PID_DIR} "${L_PID_DIR}"

update_cfg_file:
  Push "$EXEDIR\Data\popfile.cfg"
  Push "config_piddir"
  Push "${L_PID_DIR}/portable-"
  Call PPL_CfgSettingWrite_with_backup
  Pop ${L_RESULT}
;;;  MessageBox MB_OK "PPL_CfgSettingWrite_with_backup status: ${L_RESULT}"
  StrCmp ${L_RESULT} ${C_CFG_WRITE_ERROR} 0 exit
  MessageBox MB_OK|MB_ICONSTOP "*** Internal error ***\
      ${MB_NL}\
      Unable to set PID location in 'popfile.cfg'\
      ${MB_NL}${MB_NL}\
      (${L_PID_DIR})"

exit:
  Pop ${L_RESULT}
  Pop ${L_PID_DIR}

  !undef L_PID_DIR
  !undef l_RESULT

FunctionEnd

#--------------------------------------------------------------------------
# Installer Function: RemoveEmptyCBPCorpus
#
# If the wizard used the CBP package to create some buckets, there may be
# some empty corpus folders left behind (after POPFile has converted the
# buckets to the new SQL format) so we remove these useless empty folders.
#--------------------------------------------------------------------------

Function RemoveEmptyCBPCorpus

  !define C_CORPUS_INI  "$EXEDIR\Data\corpus.ini"

  IfFileExists "${C_CORPUS_INI}" 0 nothing_to_do

  !define L_FOLDER_COUNT  $R9
  !define L_FOLDER_PATH   $R8

  Push ${L_FOLDER_COUNT}
  Push ${L_FOLDER_PATH}

  ; Now remove the empty corpus folders left behind after POPFile has converted
  ; the 'flat-file' buckets (if any) created by the 'Create User Data' wizard.

  ReadINIStr ${L_FOLDER_COUNT} "${C_CORPUS_INI}" "FolderList" "MaxNum"
  StrCmp  ${L_FOLDER_COUNT} "" exit

loop:
  ReadINIStr ${L_FOLDER_PATH} "${C_CORPUS_INI}" "FolderList" "Path-${L_FOLDER_COUNT}"
  StrCmp  ${L_FOLDER_PATH} "" try_next_one

  ; Remove this corpus bucket folder if it is completely empty

  RMDir ${L_FOLDER_PATH}

try_next_one:
  IntOp ${L_FOLDER_COUNT} ${L_FOLDER_COUNT} - 1
  IntCmp ${L_FOLDER_COUNT} 0 corpus_root corpus_root loop

corpus_root:

  ; Remove the corpus folder if it is completely empty

  ReadINIStr ${L_FOLDER_PATH} "${C_CORPUS_INI}" "CBP Data" "CorpusPath"
  RMDir ${L_FOLDER_PATH}
  Delete "${C_CORPUS_INI}"

exit:
  Pop ${L_FOLDER_PATH}
  Pop ${L_FOLDER_COUNT}

  !undef L_FOLDER_COUNT
  !undef L_FOLDER_PATH

  !undef C_CORPUS_INI

nothing_to_do:
FunctionEnd

#--------------------------------------------------------------------------
# End of 'POPFilePortable.nsi'
#--------------------------------------------------------------------------
