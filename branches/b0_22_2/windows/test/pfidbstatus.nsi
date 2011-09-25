#-------------------------------------------------------------------------------------------
#
# pfidbstatus.nsi --- A simple utility to check the status and integrity of POPFile's SQLite
#                     database using the SQLite command-line utility.
#
#                     SQLite 2.x and 3.x database files are not compatible therefore separate
#                     command-line utilities have to be used: sqlite.exe for 2.x format files
#                     and sqlite3.exe for 3.x format files.
#
#                     NOTE: sqlite.exe v2.8.12 causes GPFs when called by the 'nsExec' plug-in
#                           to execute SQL from the command-line so this utility checks the
#                           sqlite.exe version number before trying to execute any SQL.
#
# Copyright (c) 2005-2011  John Graham-Cumming
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
          $\r$\n***   This script has only been tested using the NSIS ${C_EXPECTED_VERSION} compiler\
          $\r$\n***   and may not work properly with this NSIS ${NSIS_VERSION} compiler\
          $\r$\n***\
          $\r$\n***   The resulting 'installer' program should be tested carefully!\
          $\r$\n$\r$\n"
  !endif

  !undef  ${NSIS_VERSION}_found
  !undef  C_EXPECTED_VERSION

  ;--------------------------------------------------------------------------
  ; Optional check on status of the extra NSIS plugins required by POPFile
  ; (The plugin status is _always_ checked when installer.nsi is compiled)
  ;--------------------------------------------------------------------------

  !include /NONFATAL "..\plugin-status.nsh"

#--------------------------------------------------------------------------
# Compile-time command-line switches (used by 'makensis.exe')
#--------------------------------------------------------------------------
#
# /DCTS_INTEGRATED
#
# This script can build either an 'integrated' version of the utility which will be included
# in the main POPFile installer or a 'stand-alone' version of the utility which can be used
# with POPFile 0.21.0 or a later version.
#
# Since the 'integrated' version will be installed at the same time as a compatible version
# of the SQLite utility there is no need to include a compatible SQLite utility. When the
# '/DCTS_INTEGRATED' compile-time switch is supplied, the SQLite utility will not be included
# so the resulting executable file will be smaller (typically 79 KB instead of 208 KB).
#
# By default the SQLite utility is included when this utility is built.
#
#--------------------------------------------------------------------------

#-------------------------------------------------------------------------------------------
# Usage (one optional parameter):
#
#        pfidbstatus
#  or    pfidbstatus database_filename
#
# Normally 'database_filename' will simply be the default SQLite database filename, popfile.db.
#
# If this utility is used via a Start Menu shortcut created by the 'POPFile User Data' wizard
# (setupuser.exe) then the parameter will be '/REGISTRY' which forces the utility to use the
# registry data to find the database file (if the registry data does not exist, it exits).
#
# If no parameter is given the utility makes several attempts to find the database file:
#
# (1) If the default SQLite database file (popfile.db) is found in the current folder then
#     it is assumed that this is the database to be checked.
#
# (2) If the default SQLite database file (popfile.db) is found in the same folder as the
#     utility then it is assumed that this is the database to be checked.
#
# (3) If the POPFILE_USER environment variable has been defined and the POPFile configuration
#     file (popfile.cfg) is found in the specified folder then the name and location of the
#     SQLite database file is extracted.
#
# (4) If the POPFILE_USER environment variable has been defined and the specified folder exists
#     but the name and location of the SQLite database file cannot be determined, the utility
#     looks for the default SQLite database file (popfile.db) in that folder.
#
# (5) If the 'User Data' folder location is specified in the Registry, the folder exists and
#     the POPFile configuration file (popfile.cfg) is found there then the name and location
#     of the SQLite database file is extracted.
#
# (6) If the 'User Data' folder location is specified in the Registry and the folder exists
#     but the name and location of the SQLite database file cannot be determined, the utility
#     looks for the default SQLite database file (popfile.db) in that folder.
#
# (7) The search is abandoned if the above steps fail to find the database (the utility exits).
#
# NOTE: Priority is given to the current folder and the folder containing the utility to make
#       it easy to use the utility (e.g. just put it in the same folder as the popfile.db file)
#
#-------------------------------------------------------------------------------------------

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

  !define C_VERSION   "0.3.0"     ; see 'VIProductVersion' comment below for format details
  !define C_OUTFILE   "pfidbstatus.exe"

  ; The default NSIS caption is "Name Setup" so we override it here

  !ifdef CTS_INTEGRATED
      Name    "POPFile SQLite Database Status Check (integrated)"
      Caption "POPFile SQLite Database Status Check ${C_VERSION} (integrated)"
  !else
      Name    "POPFile SQLite Database Status Check (stand-alone)"
      Caption "POPFile SQLite Database Status Check ${C_VERSION} (stand-alone)"
  !endif

  ; Specify EXE filename and icon for the 'installer'

  OutFile "${C_OUTFILE}"

  Icon "..\POPFileIcon\popfile.ico"

  ; The 2.x and 3.x versions of the SQLite command-line utility make the nsExec
  ; plugin return different result codes so we place a marker on the stack to
  ; help detect problems with the execution of the SQLite command-line utility

  !define C_BOOKMARK    "__${C_OUTFILE}__"

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

  !define DBSTATUS

  !include "..\pfi-library.nsh"
  !include "..\pfi-nsis-library.nsh"

#--------------------------------------------------------------------------

  ; 'VIProductVersion' format is X.X.X.X where X is a number in range 0 to 65535
  ; representing the following values: Major.Minor.Release.Build

  VIProductVersion                          "${C_VERSION}.0"

  !define /date C_BUILD_YEAR                "%Y"

  !ifdef CTS_INTEGRATED
      VIAddVersionKey "ProductName"         "POPFile SQLite Database Status Check (integrated version)"
  !else
      VIAddVersionKey "ProductName"         "POPFile SQLite Database Status Check (stand-alone version)"
  !endif
  VIAddVersionKey "Comments"                "POPFile Homepage: http://getpopfile.org/"
  VIAddVersionKey "CompanyName"             "The POPFile Project"
  VIAddVersionKey "LegalTrademarks"         "POPFile is a registered trademark of John Graham-Cumming"
  VIAddVersionKey "LegalCopyright"          "Copyright (c) ${C_BUILD_YEAR}  John Graham-Cumming"
  VIAddVersionKey "FileDescription"         "Check the status of POPFile's SQLite database"
  VIAddVersionKey "FileVersion"             "${C_VERSION}"
  VIAddVersionKey "OriginalFilename"        "${C_OUTFILE}"

  VIAddVersionKey "Build Compiler"          "NSIS ${NSIS_VERSION}"
  VIAddVersionKey "Build Date/Time"         "${__DATE__} @ ${__TIME__}"
  !ifdef C_PFI_LIBRARY_VERSION
    VIAddVersionKey "Build Library Version" "${C_PFI_LIBRARY_VERSION}"
  !endif
  !ifdef C_NSIS_LIBRARY_VERSION
    VIAddVersionKey "NSIS Library Version"  "${C_NSIS_LIBRARY_VERSION}"
  !endif
  VIAddVersionKey "Build Script"            "${__FILE__}${MB_NL}(${__TIMESTAMP__})"

#----------------------------------------------------------------------------------------

#--------------------------------------------------------------------------
# User Variables (Global)
#--------------------------------------------------------------------------

  ; This script uses 'User Variables' (with names starting with 'G_') to hold GLOBAL data.

  Var G_WINUSERNAME    ; current Windows user login name

  Var G_DATADIR        ; folder path where we expect to find the SQLite database file
  Var G_DATABASE       ; holds name (and possibly path) to the SQLite database

  Var G_SQLITEUTIL     ; name of the appropriate SQLite command-line utility

  Var G_DBFORMAT       ; SQLite database format ('2.x', '3.x' or an error string)
  Var G_DBSCHEMA       ; SQLite database schema ( a number like '12' or an error string)
  Var G_DBSIZE         ; SQLite database file size (in KB)

  Var G_PLS_FIELD_1    ; used to customize language strings
  Var G_PLS_FIELD_2    ; used to customize language strings

#--------------------------------------------------------------------------
# Configure the MUI pages
#--------------------------------------------------------------------------

  ;----------------------------------------------------------------
  ; Interface Settings - General Interface Settings
  ;----------------------------------------------------------------

  ; The icon file for the utility

  !define MUI_ICON                            "..\POPFileIcon\popfile.ico"

  !define MUI_HEADERIMAGE
  !define MUI_HEADERIMAGE_BITMAP              "..\hdr-common.bmp"
  !define MUI_HEADERIMAGE_RIGHT

  ;----------------------------------------------------------------
  ; Interface Settings - Interface Resource Settings
  ;----------------------------------------------------------------

  ; The banner provided by the default 'modern.exe' UI does not provide much room for the
  ; two lines of text, e.g. the German version is truncated, so we use a custom UI which
  ; provides slightly wider text areas. Each area is still limited to a single line of text.

  !define MUI_UI                              "..\UI\pfi_modern.exe"

  ; The 'hdr-common.bmp' logo is only 90 x 57 pixels, much smaller than the 150 x 57 pixel
  ; space provided by the default 'modern_headerbmpr.exe' UI, so we use a custom UI which
  ; leaves more room for the TITLE and SUBTITLE text.

  !define MUI_UI_HEADERIMAGE_RIGHT            "..\UI\pfi_headerbmpr.exe"

  ;----------------------------------------------------------------
  ; Interface Settings - Installer Finish Page Interface Settings
  ;----------------------------------------------------------------

  ; Show the installation log and leave the window open when utility has completed its work

  ShowInstDetails show
  !define MUI_FINISHPAGE_NOAUTOCLOSE

#--------------------------------------------------------------------------
# Define the Page order for the utility
#--------------------------------------------------------------------------

  ;---------------------------------------------------
  ; Installer Page - Install files
  ;---------------------------------------------------

  ; Override standard "Installing..." page header

  !define MUI_PAGE_HEADER_TEXT                    "$(DBS_LANG_STD_HDR)"
  !define MUI_PAGE_HEADER_SUBTEXT                 "$(DBS_LANG_STD_SUBHDR)"

  ; Override the standard "Installation complete..." page header

  !define MUI_INSTFILESPAGE_FINISHHEADER_TEXT     "$(DBS_LANG_END_HDR)"
  !define MUI_INSTFILESPAGE_FINISHHEADER_SUBTEXT  "$(DBS_LANG_END_SUBHDR)"

  ; Override the standard "Installation Aborted..." page header

  !define MUI_INSTFILESPAGE_ABORTHEADER_TEXT      "$(DBS_LANG_ABORT_HDR)"
  !define MUI_INSTFILESPAGE_ABORTHEADER_SUBTEXT   "$(DBS_LANG_ABORT_SUBHDR)"

  !insertmacro MUI_PAGE_INSTFILES

#--------------------------------------------------------------------------
# Language Support for the utility
#--------------------------------------------------------------------------

  !insertmacro MUI_LANGUAGE "English"

  ;--------------------------------------------------------------------------
  ; Current build only supports English and uses local strings
  ; instead of language strings from languages\*-pfi.nsh files
  ;--------------------------------------------------------------------------

  !macro DBS_TEXT NAME VALUE
      LangString ${NAME} ${LANG_ENGLISH} "${VALUE}"
  !macroend

  !insertmacro DBS_TEXT DBS_LANG_STD_HDR        "POPFile SQLite Database Status Check"
  !insertmacro DBS_TEXT DBS_LANG_STD_SUBHDR     "Please wait while the database status is checked"

  !insertmacro DBS_TEXT DBS_LANG_END_HDR        "POPFile SQLite Database Status Check"
  !insertmacro DBS_TEXT DBS_LANG_END_SUBHDR     "To save the report, use right-click in the message window,${MB_NL}copy to the clipboard then paste the report into a text file"

  !insertmacro DBS_TEXT DBS_LANG_ABORT_HDR      "POPFile SQLite Database Status Check Failed"
  !insertmacro DBS_TEXT DBS_LANG_ABORT_SUBHDR   "Problem detected - see error report in window below"

  !insertmacro DBS_TEXT DBS_LANG_RIGHTCLICK     "Right-click in the window below to copy the report to the clipboard"

  !insertmacro DBS_TEXT DBS_LANG_NOCONFIGDATA   "POPFile is not configured for the '$G_WINUSERNAME' user"

  !insertmacro DBS_TEXT DBS_LANG_DBNOTFOUND_1   "Unable to find the '$G_DATABASE' file (the SQLite database)"
  !insertmacro DBS_TEXT DBS_LANG_DBNOTFOUND_2   "(looked in '$G_PLS_FIELD_1' folder)"
  !insertmacro DBS_TEXT DBS_LANG_DBNOTFOUND     "$(DBS_LANG_DBNOTFOUND_1)${MB_NL}${MB_NL}$(DBS_LANG_DBNOTFOUND_2)"

  !insertmacro DBS_TEXT DBS_LANG_NODBPARAM_1    "No SQLite database filename specified."
  !insertmacro DBS_TEXT DBS_LANG_NODBPARAM_2    "Usage: $G_PLS_FIELD_1 <database>"
  !insertmacro DBS_TEXT DBS_LANG_NODBPARAM_3    " e.g.  $G_PLS_FIELD_1 popfile.db"
  !insertmacro DBS_TEXT DBS_LANG_NODBPARAM_4    " e.g.  $G_PLS_FIELD_1 C:\Program Files\POPFile\popfile.db"
  !insertmacro DBS_TEXT DBS_LANG_NODBPARAM_5    " e.g.  $G_PLS_FIELD_1 /REGISTRY"
  !insertmacro DBS_TEXT DBS_LANG_NODBPARAM      "$(DBS_LANG_NODBPARAM_1)${MB_NL}${MB_NL}$(DBS_LANG_NODBPARAM_2)${MB_NL}$(DBS_LANG_NODBPARAM_3)${MB_NL}$(DBS_LANG_NODBPARAM_4)${MB_NL}$(DBS_LANG_NODBPARAM_5)"

  !insertmacro DBS_TEXT DBS_LANG_OPENERR        "unable to open file"

  !insertmacro DBS_TEXT DBS_LANG_DBIDENTIFIED   "The '$G_DATABASE' file is a SQLite $G_DBFORMAT database"

  !insertmacro DBS_TEXT DBS_LANG_UTILNOTFOUND_1 "Unable to find the '$G_SQLITEUTIL' file (the SQLite $G_DBFORMAT utility)"
  !insertmacro DBS_TEXT DBS_LANG_UTILNOTFOUND_2 "(looked in '$G_PLS_FIELD_1' folder, 'POPFILE_ROOT' and Registry)"
  !insertmacro DBS_TEXT DBS_LANG_UTILNOTFOUND   "$(DBS_LANG_UTILNOTFOUND_1)${MB_NL}${MB_NL}$(DBS_LANG_UTILNOTFOUND_2)"

  !insertmacro DBS_TEXT DBS_LANG_STARTERROR     "Unable to start the '$G_SQLITEUTIL' utility"
  !insertmacro DBS_TEXT DBS_LANG_VERSIONERROR   "Error: Unable to determine the '$G_SQLITEUTIL' utility's version number"

  !insertmacro DBS_TEXT DBS_LANG_UNKNOWNFMT_1   "Unable to tell if '$G_DATABASE' is a SQLite database file"
  !insertmacro DBS_TEXT DBS_LANG_UNKNOWNFMT_2   "File format not known $G_DBFORMAT"
  !insertmacro DBS_TEXT DBS_LANG_UNKNOWNFMT_3   "Please shutdown POPFile before using this utility"
  !insertmacro DBS_TEXT DBS_LANG_UNKNOWNFORMAT  "$(DBS_LANG_UNKNOWNFMT_1)${MB_NL}${MB_NL}$(DBS_LANG_UNKNOWNFMT_2)${MB_NL}${MB_NL}$(DBS_LANG_UNKNOWNFMT_3)"

  !insertmacro DBS_TEXT DBS_LANG_NOSQLITE_1     "Error: POPFile not configured to use SQLite"
  !insertmacro DBS_TEXT DBS_LANG_NOSQLITE_2     "(see the configuration data in '$G_DATADIR')"
  !insertmacro DBS_TEXT DBS_LANG_NOSQLITE       "$(DBS_LANG_NOSQLITE_1)${MB_NL}${MB_NL}$(DBS_LANG_NOSQLITE_2))"

  !insertmacro DBS_TEXT DBS_LANG_CURRENT_USER   "Current user  : $G_WINUSERNAME"
  !insertmacro DBS_TEXT DBS_LANG_CURRENT_DIR    "Current folder: $INSTDIR"
  !insertmacro DBS_TEXT DBS_LANG_UTILITY_DIR    "Utility folder: $EXEDIR"

  !insertmacro DBS_TEXT DBS_LANG_COMMANDLINE    "Command line  : $G_DATABASE"
  !insertmacro DBS_TEXT DBS_LANG_NOCOMMANDLINE  "Searching for database because no command-line parameter supplied"

  !insertmacro DBS_TEXT DBS_LANG_TRY_ENV_VAR    "Trying to find database using POPFILE_USER environment variable"
  !insertmacro DBS_TEXT DBS_LANG_ENV_VAR_VAL    "'User Data' folder (from POPFILE_USER) = $G_DATADIR"
  !insertmacro DBS_TEXT DBS_LANG_NOT_ENV_VAR    "Unable to find database using POPFILE_USER environment variable"

  !insertmacro DBS_TEXT DBS_LANG_TRY_HKCU_REG   "Trying to find database using registry data (HKCU)"
  !insertmacro DBS_TEXT DBS_LANG_HKCU_REG_VAL   "'User Data' folder (from HKCU entry) = $G_DATADIR"
  !insertmacro DBS_TEXT DBS_LANG_NOT_HKCU_REG   "Unable to find database using registry data (HKCU)"
  !insertmacro DBS_TEXT DBS_LANG_HKCU_INVALID   "Error: No POPFile registry data found for '$G_WINUSERNAME' user"

  !insertmacro DBS_TEXT DBS_LANG_TRY_CURRENT    "Trying to find database (popfile.db) in current folder"
  !insertmacro DBS_TEXT DBS_LANG_NOT_CURRENT    "Unable to find database (popfile.db) in current folder"

  !insertmacro DBS_TEXT DBS_LANG_TRY_EXEDIR     "Trying to find database (popfile.db) in same folder as utility"
  !insertmacro DBS_TEXT DBS_LANG_NOT_EXEDIR     "Unable to find database (popfile.db) in same folder as utility"

  !insertmacro DBS_TEXT DBS_LANG_SEARCHING      "..."
  !insertmacro DBS_TEXT DBS_LANG_FOUNDIT        "... found it!"

  !insertmacro DBS_TEXT DBS_LANG_DIRNOTFILE     "Error: '$G_DATABASE' is a folder, not a database file"
  !insertmacro DBS_TEXT DBS_LANG_CHECKTHISONE   "POPFile database found ($G_DATABASE)"

  !insertmacro DBS_TEXT DBS_LANG_DBFORMAT       "Database is in SQLite $G_DBFORMAT format"
  !insertmacro DBS_TEXT DBS_LANG_DBSCHEMA       ", uses schema version $G_DBSCHEMA"
  !insertmacro DBS_TEXT DBS_LANG_DBSIZE         " and its size is $G_DBSIZE KB"
  !insertmacro DBS_TEXT DBS_LANG_DBSCHEMAERROR  "SQLite error detected when extracting POPFile schema version:"

  !insertmacro DBS_TEXT DBS_LANG_SQLITEUTIL     "SQLite $G_PLS_FIELD_2 utility found in $G_PLS_FIELD_1"
  !ifdef CTS_INTEGRATED
      !insertmacro DBS_TEXT DBS_LANG_BUILTINUTIL    "not compatible with this 'integrated' version (use 'stand-alone' version or newer sqlite.exe)"
  !else
      !insertmacro DBS_TEXT DBS_LANG_BUILTINUTIL    "not compatible with this utility (using 'built-in' SQLite $G_PLS_FIELD_2 instead)"
  !endif
  !insertmacro DBS_TEXT DBS_LANG_SQLITECOMMAND  "Result of running the 'pragma integrity_check;' command:"
  !insertmacro DBS_TEXT DBS_LANG_SQLITEDBISOK   "The POPFile database has passed the SQLite integrity check!"

  !insertmacro DBS_TEXT DBS_LANG_SQLITEFAIL     "Error: The SQLite utility returned error code $G_PLS_FIELD_1"

  ;------------------------------------------------------------------------
  ; Macro to make it easy to delete the last row in the details window
  ;------------------------------------------------------------------------

  !macro DELETE_LAST_ENTRY
      Push $0
      Call GetDetailViewItemCount
      Pop $0
      IntOp $0 $0 - 1                       ; decrement to get the right index of last entry
      Push $0
      Call DeleteDetailViewItem
      Pop $0
  !macroend

  ;--------------------------------------------------------------------------

;------------------------------
; Section: CheckSQLiteDatabase
;------------------------------

Section CheckSQLiteDatabase

  !define L_PATH    $R9
  !define L_TEMP    $R8

  Push ${L_PATH}
  Push ${L_TEMP}

  SetDetailsPrint textonly
  DetailPrint "$(DBS_LANG_RIGHTCLICK)"
  SetDetailsPrint listonly

  DetailPrint "------------------------------------------------------------"
  DetailPrint "$(^Name) v${C_VERSION}"
  DetailPrint "------------------------------------------------------------"
  DetailPrint ""

  ClearErrors
  UserInfo::GetName
  IfErrors default_name
  Pop $G_WINUSERNAME
  StrCmp $G_WINUSERNAME "" 0 check_input

default_name:
  StrCpy $G_WINUSERNAME "UnknownUser"

check_input:

  ; Set OutPath to the working directory (to cope with cases where no database path is supplied)

  GetFullPathName $INSTDIR ".\"

  SetDetailsPrint none
  SetOutPath "$INSTDIR"
  SetDetailsPrint listonly

  DetailPrint "$(DBS_LANG_CURRENT_USER)"
  DetailPrint "$(DBS_LANG_CURRENT_DIR)"
  StrCmp "$INSTDIR" "$EXEDIR" check_command_line
  DetailPrint "$(DBS_LANG_UTILITY_DIR)"

check_command_line:

  ; The command-line can be used to supply the name of a database file in the current folder
  ; (e.g. mydata.db), a relative filename for the database file (e.g. ..\data\mydata.db) or
  ; the full pathname for the database file (D:\Application Data\POPFile\popfile.db).

  Call NSIS_GetParameters
  Pop $G_DATABASE
  StrCmp $G_DATABASE "" check_currentdir
  DetailPrint "$(DBS_LANG_COMMANDLINE)"
  StrCmp $G_DATABASE "/REGISTRY" 0 lookforfile
  DetailPrint ""
  Goto use_registry

check_currentdir:
  DetailPrint ""
  DetailPrint "$(DBS_LANG_NOCOMMANDLINE)"
  DetailPrint ""

  DetailPrint "$(DBS_LANG_TRY_CURRENT)$(DBS_LANG_SEARCHING)"
  StrCpy $G_DATABASE "popfile.db"
  IfFileExists "$INSTDIR\$G_DATABASE" found_in_current
  !insertmacro DELETE_LAST_ENTRY
  DetailPrint "$(DBS_LANG_NOT_CURRENT)"

  StrCmp "$INSTDIR" "$EXEDIR" try_env_var
  DetailPrint "$(DBS_LANG_TRY_EXEDIR)$(DBS_LANG_SEARCHING)"
  IfFileExists "$EXEDIR\$G_DATABASE" found_in_exedir
  !insertmacro DELETE_LAST_ENTRY
  DetailPrint "$(DBS_LANG_NOT_EXEDIR)"

try_env_var:
  DetailPrint "$(DBS_LANG_TRY_ENV_VAR)$(DBS_LANG_SEARCHING)"
  ReadEnvStr $G_DATADIR "POPFILE_USER"
  StrCmp $G_DATADIR "" try_registry
  Push $G_DATADIR
  Call PFI_GetCompleteFPN
  Pop $G_DATADIR
  !insertmacro DELETE_LAST_ENTRY
  DetailPrint "$(DBS_LANG_ENV_VAR_VAL)"
  IfFileExists "$G_DATADIR\*.*" 0 try_registry
  Push $G_DATADIR
  Call PFI_GetSQLdbPathName
  Pop $G_DATABASE
  StrCmp $G_DATABASE "Not SQLite" sqlite_not_used
  StrCmp $G_DATABASE "" 0 check_env_file_exists
  StrCpy $G_DATABASE "$G_DATADIR\popfile.db"

check_env_file_exists:
  IfFileExists "$G_DATABASE" 0 try_registry
  !insertmacro DELETE_LAST_ENTRY
  DetailPrint "$(DBS_LANG_TRY_ENV_VAR)$(DBS_LANG_FOUNDIT)"
  Goto split_path

try_registry:
  !insertmacro DELETE_LAST_ENTRY
  DetailPrint "$(DBS_LANG_NOT_ENV_VAR)"

use_registry:
  DetailPrint "$(DBS_LANG_TRY_HKCU_REG)$(DBS_LANG_SEARCHING)"
  ReadRegStr $G_DATADIR HKCU "Software\POPFile Project\POPFile\MRI" "Owner"
  StrCmp $G_DATADIR $G_WINUSERNAME same_owner
  !insertmacro DELETE_LAST_ENTRY
  StrCmp $G_DATABASE "/REGISTRY" no_reg_data
  DetailPrint ""

no_reg_data:
  DetailPrint "$(DBS_LANG_HKCU_INVALID)"
  Goto usage_msg

same_owner:
  ReadRegStr $G_DATADIR HKCU "Software\POPFile Project\POPFile\MRI" "UserDir_LFN"
  StrCmp $G_DATADIR "" abandon_search
  !insertmacro DELETE_LAST_ENTRY
  DetailPrint "$(DBS_LANG_HKCU_REG_VAL)"
  IfFileExists "$G_DATADIR\*.*" 0 abandon_search
  Push $G_DATADIR
  Call PFI_GetSQLdbPathName
  Pop $G_DATABASE
  StrCmp $G_DATABASE "Not SQLite" sqlite_not_used
  StrCmp $G_DATABASE "" 0 check_reg_file_exists
  StrCpy $G_DATABASE "$G_DATADIR\popfile.db"

check_reg_file_exists:
  IfFileExists "$G_DATABASE" 0 abandon_search
  !insertmacro DELETE_LAST_ENTRY
  DetailPrint "$(DBS_LANG_TRY_HKCU_REG)$(DBS_LANG_FOUNDIT)"
  Goto split_path

sqlite_not_used:
  DetailPrint ""
  DetailPrint "$(DBS_LANG_NOSQLITE_1)"
  DetailPrint "$(DBS_LANG_NOSQLITE_2)"
  MessageBox MB_OK|MB_ICONEXCLAMATION "$(DBS_LANG_NOSQLITE)"
  Goto error_exit

abandon_search:
  !insertmacro DELETE_LAST_ENTRY
  DetailPrint "$(DBS_LANG_NOT_HKCU_REG)"
  StrCpy $G_PLS_FIELD_1 "$INSTDIR"
  Goto give_up

found_in_current:
  !insertmacro DELETE_LAST_ENTRY
  DetailPrint "$(DBS_LANG_TRY_CURRENT)$(DBS_LANG_FOUNDIT)"
  Goto lookforfile

found_in_exedir:
  !insertmacro DELETE_LAST_ENTRY
  DetailPrint "$(DBS_LANG_TRY_EXEDIR)$(DBS_LANG_FOUNDIT)"
  StrCpy $INSTDIR $EXEDIR

lookforfile:
  Push $INSTDIR
  Push $G_DATABASE
  Call PFI_GetDataPath
  Pop $G_DATABASE

split_path:
  Push $G_DATABASE
  Call NSIS_GetParent
  Pop $G_PLS_FIELD_1
  StrLen ${L_TEMP} $G_PLS_FIELD_1
  IntOp ${L_TEMP} ${L_TEMP} + 1
  StrCpy $G_DATABASE $G_DATABASE "" ${L_TEMP}
  IfFileExists "$G_PLS_FIELD_1\$G_DATABASE" continue

give_up:
  DetailPrint ""
  DetailPrint "$(DBS_LANG_DBNOTFOUND_1)"
  DetailPrint "$(DBS_LANG_DBNOTFOUND_2)"
  MessageBox MB_OK|MB_ICONEXCLAMATION "$(DBS_LANG_DBNOTFOUND)"

usage_msg:

  ; Ensure the correct program name appears in the 'usage' message added to the log.

  StrCpy $G_PLS_FIELD_1 $EXEFILE

  DetailPrint ""
  DetailPrint "$(DBS_LANG_NODBPARAM_2)"
  DetailPrint ""
  DetailPrint "$(DBS_LANG_NODBPARAM_3)"
  DetailPrint "$(DBS_LANG_NODBPARAM_4)"
  DetailPrint "$(DBS_LANG_NODBPARAM_5)"
  Goto error_exit

continue:
  StrCpy $G_PLS_FIELD_2 $G_DATABASE
  StrCpy $G_DATABASE "$G_PLS_FIELD_1\$G_DATABASE"
  IfFileExists "$G_DATABASE\*.*" dir_not_file
  Push $0
  Push $1
  Push $2
  getsize::GetSize "$G_PLS_FIELD_1" "/M=$G_PLS_FIELD_2 /G=0 /S=Kb" .r0 .r1 .r2
  Push $0
  Call InsertThousandSeparators
  Pop $G_DBSIZE
  Pop $2
  Pop $1
  Pop $0
  DetailPrint ""
  DetailPrint "$(DBS_LANG_CHECKTHISONE)"
  Push $G_DATABASE
  Call PFI_GetSQLiteFormat
  Pop $G_DBFORMAT
  StrCpy $G_SQLITEUTIL "sqlite.exe"
  StrCmp $G_DBFORMAT "2.x" look_for_util
  StrCpy $G_SQLITEUTIL "sqlite3.exe"
  StrCmp $G_DBFORMAT "3.x" look_for_util
  Push $G_DATABASE
  Call NSIS_GetParent
  Pop $G_PLS_FIELD_1
  StrLen ${L_TEMP} $G_PLS_FIELD_1
  IntOp ${L_TEMP} ${L_TEMP} + 1
  StrCpy $G_DATABASE $G_DATABASE "" ${L_TEMP}
  DetailPrint ""
  DetailPrint "$(DBS_LANG_UNKNOWNFMT_1)"
  DetailPrint ""
  DetailPrint "$(DBS_LANG_UNKNOWNFMT_2)"
  DetailPrint ""
  DetailPrint "$(DBS_LANG_UNKNOWNFMT_3)"
  MessageBox MB_OK|MB_ICONEXCLAMATION "$(DBS_LANG_UNKNOWNFORMAT)"
  Goto error_exit

look_for_util:
  StrCpy ${L_TEMP} "$EXEDIR"
  StrCpy $G_PLS_FIELD_1 "$EXEDIR"
  IfFileExists "${L_TEMP}\$G_SQLITEUTIL" run_it

  ; It is not in "our" folder so try looking in the usual places

  ReadEnvStr ${L_TEMP} "POPFILE_ROOT"
  StrCmp ${L_TEMP} "" try_HKCU
  Push ${L_TEMP}
  Call PFI_GetCompleteFPN
  Pop ${L_TEMP}
  StrCmp ${L_TEMP} "" try_HKCU
  IfFileExists "${L_TEMP}\$G_SQLITEUTIL" run_it

try_HKCU:
  ReadRegStr ${L_TEMP} HKCU "Software\POPFile Project\POPFile\MRI" "RootDir_LFN"
  StrCmp ${L_TEMP} "" try_HKLM
  IfFileExists "${L_TEMP}\$G_SQLITEUTIL" run_it

try_HKLM:
  ReadRegStr ${L_TEMP} HKLM "Software\POPFile Project\POPFile\MRI" "RootDir_LFN"
  StrCmp ${L_TEMP} "" no_util
  IfFileExists "${L_TEMP}\$G_SQLITEUTIL" run_it

no_util:
  DetailPrint ""
  DetailPrint "$(DBS_LANG_DBIDENTIFIED)"
  DetailPrint ""
  DetailPrint "$(DBS_LANG_UTILNOTFOUND_1)"
  DetailPrint "$(DBS_LANG_UTILNOTFOUND_2)"
  MessageBox MB_OK|MB_ICONEXCLAMATION \
      "$(DBS_LANG_DBIDENTIFIED)\
      ${MB_NL}${MB_NL}${MB_NL}\
      $(DBS_LANG_UTILNOTFOUND)"
  Goto error_exit

run_it:
  StrCpy $G_PLS_FIELD_1 ${L_TEMP}
  Push "${C_BOOKMARK}"
  nsExec::ExecToStack '"$G_PLS_FIELD_1\$G_SQLITEUTIL" -version'
  Pop ${L_TEMP}
  StrCmp ${L_TEMP} "error" start_error
  StrCmp ${L_TEMP} "timeout" start_error

  ; As of 15 June 2009:
  ;
  ; v2.8.17 is the most recent version of the SQLite 2.x command-line utility
  ; The current DBD::SQLite module (v1.25) is based upon the SQLite 3.6.13 library
  ;
  ; sqlite.exe  v2.8.17 returns "1" in ${L_TEMP} after a successful version check
  ; sqlite3.exe v3.6.13 returns "0" in ${L_TEMP} after a successful version check

  IntCmp ${L_TEMP} 2 version_error 0 version_error
  IntCmp ${L_TEMP} 0 0 version_error
  Exch
  Pop ${L_TEMP}
  StrCmp ${L_TEMP} "${C_BOOKMARK}" 0 unexpected_version_error
  Call NSIS_TrimNewlines
  Pop $G_PLS_FIELD_2
  StrCpy $G_PLS_FIELD_2 "v$G_PLS_FIELD_2"
  DetailPrint ""
  DetailPrint "$(DBS_LANG_SQLITEUTIL)"
  StrCmp $G_PLS_FIELD_2 "v2.8.12" 0 use_it

  !ifdef CTS_INTEGRATED
      DetailPrint "$(DBS_LANG_BUILTINUTIL)"
      Goto error_exit
  !else
      ; sqlite.exe 2.8.12 causes a GPF when the 'nsExec' plugin uses it to execute a SQL command
      ; from the command-line so we have to use a more recent sqlite.exe utility if we detect the
      ; target system uses sqlite.exe 2.8.12 (sqlite.exe 2.8.13, 2.8.15 & 2.8.16 (the most recent
      ; version available as of 12 July 2005) are all safe to use here)

      SetDetailsPrint none
      File "/oname=$PLUGINSDIR\sqlite.exe" "sqlite_clu\sqlite.exe"
      StrCpy $G_PLS_FIELD_1 "$PLUGINSDIR"
      SetDetailsPrint listonly
      nsExec::ExecToStack '"$G_PLS_FIELD_1\sqlite.exe" -version'
      Pop ${L_TEMP}
      StrCmp ${L_TEMP} "error" start_error
      StrCmp ${L_TEMP} "timeout" start_error
      IntCmp ${L_TEMP} 1 0 version_error version_error
      Call NSIS_TrimNewlines
      Pop $G_PLS_FIELD_2
      StrCpy $G_PLS_FIELD_2 "v$G_PLS_FIELD_2"
      DetailPrint "$(DBS_LANG_BUILTINUTIL)"
  !endif

use_it:
  Push $G_DATABASE
  Call NSIS_GetParent
  Pop ${L_PATH}
  StrCmp ${L_PATH} "" run_it_now

  ; The SQLite command-line utility does not handle paths containing non-ASCII characters
  ; properly. An example where this will cause a problem is when the POPFile 'User Data'
  ; has been installed in the default location for a user with a Japanese login name.
  ; As a workaround we change the current working directory to the folder containing the
  ; database and supply only the database's filename when calling the command-line utility.

  StrLen ${L_TEMP} ${L_PATH}
  IntOp ${L_TEMP} ${L_TEMP} + 1
  StrCpy $G_DATABASE $G_DATABASE "" ${L_TEMP}
  SetDetailsPrint none
  SetOutPath "${L_PATH}"
  SetDetailsPrint listonly

run_it_now:
  nsExec::ExecToStack '"$G_PLS_FIELD_1\$G_SQLITEUTIL" "$G_DATABASE" "select version from popfile;"'
  Pop ${L_TEMP}
  Call NSIS_TrimNewlines
  Pop $G_DBSCHEMA
  StrCmp ${L_TEMP} "0" schema_ok
  StrCpy $G_DBSCHEMA "($G_DBSCHEMA)"
  DetailPrint ""
  DetailPrint "$(DBS_LANG_DBFORMAT)$(DBS_LANG_DBSIZE)"
  DetailPrint ""
  DetailPrint "$(DBS_LANG_DBSCHEMAERROR)"
  DetailPrint "$G_DBSCHEMA"
  Goto check_integrity

schema_ok:
  DetailPrint ""
  DetailPrint "$(DBS_LANG_DBFORMAT)$(DBS_LANG_DBSCHEMA)$(DBS_LANG_DBSIZE)"

check_integrity:
  DetailPrint ""
  DetailPrint "$(DBS_LANG_SQLITECOMMAND)"
  nsExec::ExecToLog '"$G_PLS_FIELD_1\$G_SQLITEUTIL" "$G_DATABASE" "pragma integrity_check;"'
  Pop ${L_TEMP}
  StrCmp ${L_TEMP} "error" start_error
  StrCmp ${L_TEMP} "timeout" start_error
  IntCmp ${L_TEMP} 0 exit
  StrCpy $G_PLS_FIELD_1 ${L_TEMP}
  DetailPrint ""
  DetailPrint "$(DBS_LANG_SQLITEFAIL)"
  Goto error_exit

dir_not_file:
  DetailPrint ""
  DetailPrint "$(DBS_LANG_DIRNOTFILE)"
  MessageBox MB_OK|MB_ICONEXCLAMATION "$(DBS_LANG_DIRNOTFILE)"
  Goto error_exit

unexpected_version_error:
  StrCpy ${L_TEMP} "${MB_NL}${MB_NL}(stack corruption detected)"
  Goto error_msg

version_error:
  StrCpy ${L_TEMP} "${MB_NL}${MB_NL}(return code: ${L_TEMP})"

error_msg:
  StrCpy $G_PLS_FIELD_2 ""
  DetailPrint ""
  DetailPrint "$(DBS_LANG_SQLITEUTIL)"
  DetailPrint ""
  DetailPrint "$(DBS_LANG_VERSIONERROR)"
  MessageBox MB_OK|MB_ICONEXCLAMATION "$(DBS_LANG_VERSIONERROR)${L_TEMP}"
  Goto error_exit

start_error:
  DetailPrint ""
  DetailPrint "$(DBS_LANG_STARTERROR)"
  MessageBox MB_OK|MB_ICONEXCLAMATION "$(DBS_LANG_STARTERROR)"

error_exit:
  Call PFI_GetDateTimeStamp
  Pop ${L_TEMP}
  DetailPrint ""
  DetailPrint "------------------------------------------------------------"
  DetailPrint "(status check failed ${L_TEMP})"
  DetailPrint "------------------------------------------------------------"
  SetDetailsPrint none
  Abort

exit:
  DetailPrint ""
  DetailPrint "$(DBS_LANG_SQLITEDBISOK)"
  Call PFI_GetDateTimeStamp
  Pop ${L_TEMP}
  DetailPrint ""
  DetailPrint "------------------------------------------------------------"
  DetailPrint "(report finished ${L_TEMP})"
  DetailPrint "------------------------------------------------------------"
  SetDetailsPrint none

  ; Provide an instant snapshot summary by scrolling up to display the name and location
  ; of the POPFile SQLite database file we have just checked (the "report finished" block
  ; makes the database information scroll off the top of the list).

  Call HideFinalTimestamp

  Pop ${L_TEMP}
  Pop ${L_PATH}

  !undef L_PATH
  !undef L_TEMP

SectionEnd

#--------------------------------------------------------------------------
# Installer Function: InsertThousandSeparators
#
# When large integers are displayed they can be hard to read (eg 1234567). This function
# inserts one or more "thousand" separators to make large integers easier to read
# (eg 1,234,567).
#
# If the input value isn't an unsigned decimal integer then the output string equals the input.
#
# This function uses the target system's OS setting for the "thousand" separator. This is the
# character (or characters) used to separate groups of digits to the left of the decimal point.
#
# Input:
#       (top of stack)          - input
#
# Output:
#       (top of stack)          - input value with separators inserted if appropriate
#
# Usage:
#       Push "1234567"
#       Call InsertThousandSeparators
#       Pop $R0                 ; $R0 will be "1,234,567"
#                               ; (assuming the 'English' setting for the "thousand" separator)
#
#       Push "1234.567"
#       Call InsertThousandSeparators
#       Pop $R0                 ; $R0 will be "1234.567"
#                               ; (no changes made because input contains a decimal point)
#--------------------------------------------------------------------------

Function InsertThousandSeparators

  !define L_INPUT   $R9   ; the input string
  !define L_RESULT  $R8   ; the output string

  !define L_TEMP    $1    ; temp variable (also used as .r1 in 'system' call)
  !define L_COMMA   $0    ; target system's "thousand" separator (used as .r0 in 'system' call)

  Exch ${L_INPUT}
  Push ${L_RESULT}
  Push ${L_TEMP}
  Push ${L_COMMA}

  Push ${L_INPUT}
  Call PFI_StrCheckDecimal
  Pop ${L_TEMP}
  StrCmp ${L_TEMP} "" no_commas

  ; Use the target system's "thousand" separator (this is ',' when 'English' locale selected)

  !define LOCALE_SYSTEM_DEFAULT   0x400
  !define LOCALE_STHOUSAND        0xF
  !define MAX_PATH                260       ; upper limit for the length of the separator

  StrCpy ${L_COMMA} ""

  System::Call "kernel32::GetLocaleInfoA(i ${LOCALE_SYSTEM_DEFAULT}, i ${LOCALE_STHOUSAND}, t .r0, i ${MAX_PATH}) i r1"

  ; If the 'system' call returns an empty string use the default English separator
  ; (or should we just use the empty string in case that is what is really required here?)

  StrCmp ${L_COMMA} "" 0 got_separator
  StrCpy ${L_COMMA} ","

got_separator:

  ; Input is an unsigned decimal integer (i.e. it contains only the characters 0 to 9)

  StrCpy ${L_RESULT} ""

loop:
  StrLen ${L_TEMP} ${L_INPUT}
  IntCmp ${L_TEMP} 3 done done
  StrCpy ${L_TEMP} ${L_INPUT} 3 -3
  StrCmp ${L_RESULT} "" first_group
  StrCpy ${L_RESULT} ${L_TEMP}${L_COMMA}${L_RESULT}

next_group:
  StrCpy ${L_INPUT} ${L_INPUT} -3
  Goto loop

first_group:
  StrCpy ${L_RESULT} ${L_TEMP}
  Goto next_group

done:
  StrCmp ${L_RESULT} "" no_commas
  StrCpy ${L_INPUT} ${L_INPUT}${L_COMMA}${L_RESULT}

no_commas:
  Pop ${L_COMMA}
  Pop ${L_TEMP}
  Pop ${L_RESULT}
  Exch ${L_INPUT}

  !undef L_INPUT
  !undef L_RESULT

  !undef L_TEMP
  !undef L_COMMA

FunctionEnd

#--------------------------------------------------------------------------
# Functions used to manipulate the contents of the details view
#--------------------------------------------------------------------------

  ;------------------------------------------------------------------------
  ; Constants used when accessing the details view
  ;------------------------------------------------------------------------

  !define C_LVM_GETITEMCOUNT        0x1004
  !define C_LVM_DELETEITEM          0x1008

  !define C_LVM_ENSUREVISIBLE       0x1013
  !define C_LVM_GETTOPINDEX         0x1027

  !define C_LVM_COUNTPERPAGE        0x1028

#--------------------------------------------------------------------------
# Installer Function: GetDetailViewItemCount
#
# Returns the number of rows in the details view (on the INSTFILES page)
#
# Inputs:
#         none
#
# Outputs:
#         (top of stack)     - number of rows in the details view window
#
# Usage:
#
#         Call GetDetailViewItemCount
#         Pop $R9
#
#--------------------------------------------------------------------------

Function GetDetailViewItemCount
  Push $1
  FindWindow $1 "#32770" "" $HWNDPARENT
  GetDlgItem $1 $1 0x3F8                  ; This is the Control ID of the details view
  SendMessage $1 ${C_LVM_GETITEMCOUNT} 0 0 $1
  Exch $1
FunctionEnd

#--------------------------------------------------------------------------
# Installer Function: DeleteDetailViewItem
#
# Deletes one row from the details view (on the INSTFILES page)
#
# Inputs:
#         (top of stack)     - index number of the row to be deleted
#
# Outputs:
#         none
#
# Usage:
#
#         Push $R9
#         Call DeleteDetailViewItem
#
#--------------------------------------------------------------------------

Function DeleteDetailViewItem
  Exch $0
  Push $1
  FindWindow $1 "#32770" "" $HWNDPARENT
  GetDlgItem $1 $1 0x3F8                  ; This is the Control ID of the details view
  SendMessage $1 ${C_LVM_DELETEITEM} $0 0
  Pop $1
  Pop $0
FunctionEnd

#--------------------------------------------------------------------------
# Installer Function: HideFinalTimestamp
#
# Scrolls the details view up a little to provide an 'instant' summary.
#
# After a successful integrity check, the "report finished" timestamp causes the
# location of the POPFile database file to scroll off the top of the details list
# so we in effect scroll up a few lines to bring it back into view.
#
# The "report finished" timestamp can still be seen by scrolling down or saving
# the entire report to a file via the clipboard.
#
# Inputs:
#         none
#
# Outputs:
#         none
#
# Usage:
#         Call HideFinalTimestamp
#
#--------------------------------------------------------------------------

Function HideFinalTimestamp

  !define L_DLG_ITEM    $R9   ; the dialog item we are going to manipulate
  !define L_SCROLLUP    $R8   ; number of lines to scroll up
  !define L_TEMP        $R7
  !define L_TOPROW      $R6   ; index of the row to appear at the top

  Push ${L_DLG_ITEM}
  Push ${L_SCROLLUP}
  Push ${L_TEMP}
  Push ${L_TOPROW}

  ; The final timestamp block uses several lines so we scroll up a few lines to bring
  ; more important lines back into view at the top of the list. The LVM_SCROLL message
  ; uses a pixel-based vertical scroll value instead of an item-based value so we take
  ; an easier approach: find the item index of the currently visible top row and then
  ; make visible the item which is a few rows before that.

  FindWindow ${L_DLG_ITEM} "#32770" "" $HWNDPARENT
  GetDlgItem ${L_DLG_ITEM} ${L_DLG_ITEM} 0x3F8      ; This is the Control ID of the details view

  ; Check how many lines can be shown in the details view

  SendMessage ${L_DLG_ITEM} ${C_LVM_COUNTPERPAGE} 0 0 ${L_TEMP}

  StrCpy ${L_SCROLLUP} 4   ; hide the three-line timestamp plus the blank line before it
  IntCmp ${L_TEMP} 10 findtop findtop
  StrCpy ${L_SCROLLUP} 3   ; hide the timestamp, leaving a blank line before & after the important lines

findtop:

  ; Get the index of the row currently shown at the top of the details view

  SendMessage ${L_DLG_ITEM} ${C_LVM_GETTOPINDEX} 0 0 ${L_TOPROW}

  IntOp ${L_TOPROW} ${L_TOPROW} - ${L_SCROLLUP}

   ; The item index is zero based so we must ensure we never supply a negative item index

  IntCmp ${L_TOPROW} 0 scrollup 0 scrollup
  StrCpy ${L_TOPROW} 0

scrollup:
  SendMessage ${L_DLG_ITEM} ${C_LVM_ENSUREVISIBLE} ${L_TOPROW} 0

  Pop ${L_TOPROW}
  Pop ${L_TEMP}
  Pop ${L_SCROLLUP}
  Pop ${L_DLG_ITEM}

  !undef L_DLG_ITEM
  !undef L_SCROLLUP
  !undef L_TEMP
  !undef L_TOPROW

FunctionEnd

;--------------------------
; End of 'pfidbstatus.nsi'
;--------------------------
