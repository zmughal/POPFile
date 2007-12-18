#--------------------------------------------------------------------------
#
# installer-Uninstall.nsh --- This 'include' file contains the 'Uninstall' part of the main
#                             NSIS 'installer.nsi' script used to create the POPFile installer.
#
# Copyright (c) 2005-2007 John Graham-Cumming
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
#  The 'installer.nsi' script file contains the following code:
#
#     #==========================================================================
#     #==========================================================================
#     # The 'Uninstall' part of the script is in a separate file
#     #==========================================================================
#     #==========================================================================
#
#       !include "installer-Uninstall.nsh"
#
#     #==========================================================================
#     #==========================================================================
#
#--------------------------------------------------------------------------


#####################################################################################
#                                                                                   #
#   ##    ##  ##    ##   ##   ##    ##   #####  ########  #####    ##      ##       #
#   ##    ##  ###   ##   ##   ###   ##  ##   ##    ##    ##   ##   ##      ##       #
#   ##    ##  ####  ##   ##   ####  ##  ##         ##    ##   ##   ##      ##       #
#   ##    ##  ## ## ##   ##   ## ## ##   #####     ##    #######   ##      ##       #
#   ##    ##  ##  ####   ##   ##  ####       ##    ##    ##   ##   ##      ##       #
#   ##    ##  ##   ###   ##   ##   ###  ##   ##    ##    ##   ##   ##      ##       #
#    ######   ##    ##   ##   ##    ##   #####     ##    ##   ##   ######  ######   #
#                                                                                   #
#####################################################################################

#--------------------------------------------------------------------------
# User Registers (Global)
#--------------------------------------------------------------------------

  ; This script uses 'User Variables' (with names starting with 'G_') to hold GLOBAL data.

  Var G_UNINST_MODE        ; Uninstaller mode ("change" or "uninstall")

#--------------------------------------------------------------------------
# Initialise the uninstaller
#--------------------------------------------------------------------------

Function un.onInit

  ; WARNING: The UAC plugin uses $0, $1, $2 and $3 registers

  !define L_UAC_0   $0
  !define L_UAC_1   $1
  !define L_UAC_2   $2
  !define L_UAC_3   $3

  ; The reason why 'un.onInit' preserves the registers it uses is that it makes debugging easier!

  Push ${L_UAC_0}
  Push ${L_UAC_1}
  Push ${L_UAC_2}
  Push ${L_UAC_3}

  ; Use the UAC plugin to ensure that this uninstaller runs with 'administrator' privileges
  ; (UAC = Vista's new "User Account Control" feature).

UAC_Elevate:
  UAC::RunElevated
  StrCmp 1223 ${L_UAC_0} UAC_ElevationAborted   ; Jump if UAC dialog was aborted by user
  StrCmp 0 ${L_UAC_0} 0 UAC_Err                 ; If ${L_UAC_0} is not 0 then an error was detected
  StrCmp 1 ${L_UAC_1} 0 UAC_Success             ; Are we the real deal or just the wrapper ?
  Quit                                          ; UAC not supported (probably pre-NT6), run as normal

UAC_Err:
  MessageBox MB_OK|MB_ICONSTOP "Unable to elevate , error $0"
  Abort

UAC_ElevationAborted:
  MessageBox MB_OK|MB_ICONSTOP "This uninstaller requires admin access, aborting!"
  Abort

UAC_Success:
  StrCmp 1 ${L_UAC_3} continue                ; Jump if we are a member of the admin group (any OS)
  StrCmp 3 ${L_UAC_1} 0 UAC_ElevationAborted  ; Can we try to elevate again ?
  MessageBox MB_OK|MB_ICONSTOP "This uninstaller requires admin access, try again"
  goto UAC_Elevate                            ; ... try again

continue:

  ; Retrieve the language used when POPFile was installed, and use it for the uninstaller
  ; (if the language entry is not found in the registry, a 'language selection' dialog is shown)

  ; Use a different "Language selection" dialog title for the uninstaller

  !undef  MUI_LANGDLL_WINDOWTITLE
  !define MUI_LANGDLL_WINDOWTITLE             "POPFile Uninstaller Language Selection"

  !insertmacro MUI_UNGETLANGUAGE

  Call un.SetGlobalUserVariables

  !insertmacro MUI_INSTALLOPTIONS_EXTRACT "ioP.ini"
  !insertmacro MUI_INSTALLOPTIONS_EXTRACT "ioUM.ini"

  Pop ${L_UAC_3}
  Pop ${L_UAC_2}
  Pop ${L_UAC_1}
  Pop ${L_UAC_0}

  !undef L_UAC_0
  !undef L_UAC_1
  !undef L_UAC_2
  !undef L_UAC_3

FunctionEnd

#--------------------------------------------------------------------------
# Uninstaller Function: 'un.SetGlobalUserVariables'
#
# Used to initialise (or re-initialise) the following global variables:
#
# (1) $G_ROOTDIR      - full path to the folder containing the POPFile program files
# (2) $G_MPLIBDIR     - full path to the folder containing the minimal Perl
# (3) $G_USERDIR      - full path to the folder containing the 'popfile.cfg' file
# (4) $G_WINUSERNAME  - current Windows user login name
# (5) $G_WINUSERTYPE  - user group ('Admin', 'Power', 'User', 'Guest' or 'Unknown')
#
# (this helps avoid problems when the uninstaller is started by a non-admin user)
#--------------------------------------------------------------------------

Function un.SetGlobalUserVariables

  StrCpy $G_ROOTDIR   "$INSTDIR"
  StrCpy $G_MPLIBDIR  "$INSTDIR\lib"

  ; Starting with 0.21.0 the registry is used to store the location of the 'User Data'
  ; (if setup.exe or adduser.exe was used to create/update the 'User Data' for this user)

  ReadRegStr $G_USERDIR HKCU "Software\POPFile Project\${C_PFI_PRODUCT}\MRI" "UserDir_LFN"
  StrCmp $G_USERDIR "" 0 got_user_path

  ; Pre-release versions of the 0.21.0 installer used a sub-folder for the default user data

  StrCpy $G_USERDIR "$INSTDIR\user"

  ; If we are uninstalling an upgraded installation, the default user data may be in $INSTDIR
  ; instead of $INSTDIR\user

  IfFileExists "$G_USERDIR\popfile.cfg" got_user_path
  StrCpy $G_USERDIR   "$INSTDIR"

got_user_path:

  ; Email settings are stored on a 'per user' basis therefore we need to know which user is
  ; running the uninstaller (e.g. so we can check ownership of any local 'User Data' we find)

  ClearErrors
  UserInfo::GetName
  IfErrors 0 got_name

  ; Assume Win9x system, so user has 'Admin' rights
  ; (UserInfo works on Win98SE so perhaps it is only Win95 that fails ?)

  StrCpy $G_WINUSERNAME "UnknownUser"
  StrCpy $G_WINUSERTYPE "Admin"
  Goto function_exit

got_name:
  Pop $G_WINUSERNAME
  StrCmp $G_WINUSERNAME "" 0 get_usertype
  StrCpy $G_WINUSERNAME "UnknownUser"

get_usertype:
  UserInfo::GetAccountType
  Pop $G_WINUSERTYPE
  StrCmp $G_WINUSERTYPE "Admin" function_exit
  StrCmp $G_WINUSERTYPE "Power" function_exit
  StrCmp $G_WINUSERTYPE "User"  function_exit
  StrCmp $G_WINUSERTYPE "Guest" function_exit
  StrCpy $G_WINUSERTYPE "Unknown"

function_exit:
FunctionEnd

#--------------------------------------------------------------------------
# Uninstaller Function: un.OnUninstFailed               (required by UAC plugin)
#--------------------------------------------------------------------------

Function un.OnUninstFailed

  UAC::Unload     ; Must call unload!

FunctionEnd

#--------------------------------------------------------------------------
# Uninstaller Function: un.OnUninstSuccess              (required by UAC plugin)
#--------------------------------------------------------------------------

Function un.OnUninstSuccess

  UAC::Unload     ; Must call unload!

FunctionEnd

#--------------------------------------------------------------------------
# Uninstaller Function: un.PFIGUIInit
# (custom un.onGUIInit function)
#
# Used to complete the initialization of the installer.
# This code was moved from '.onInit' in order to permit the use of language-specific strings
# (the selected language is not available inside the '.onInit' function)
#--------------------------------------------------------------------------

Function un.PFIGUIInit

  !define L_RESERVED      $1    ; used in the system.dll call

  !define L_OPTIONLIST    $R9
  !define L_PARAMETER     $R8

  Push ${L_RESERVED}
  Push ${L_OPTIONLIST}
  Push ${L_PARAMETER}

  ; Ensure only one copy of this installer is running

  System::Call 'kernel32::CreateMutexA(i 0, i 0, t "OnlyOnePFI_mutex") i .r1 ?e'
  Pop ${L_RESERVED}
  StrCmp ${L_RESERVED} 0 mutex_ok
  MessageBox MB_OK|MB_ICONEXCLAMATION "$(PFI_LANG_INSTALLER_MUTEX)"
  Abort

mutex_ok:

  ; If 'Nihongo' (Japanese) language has been selected for the installer, ensure the
  ; 'Nihongo Parser' entry is shown on the COMPONENTS page to confirm that a parser will
  ; be installed. The "Nihongo Parser Selection" page appears immediately before the
  ; COMPONENTS page.

  Call un.ShowOrHideNihongoParser

  ; If the mode option has been supplied on the command-line
  ; preset the appropriate radiobutton, otherwise deselect both.
  ;
  ; The UAC plugin may modify the command-line so we need to
  ; check for the option anywhere on the command-line (instead
  ; of assuming the command-line is empty or only contains
  ; the /MODIFY or /UNINSTALL option)

  Call un.PFI_GetParameters
  Pop ${L_OPTIONLIST}

  Push ${L_OPTIONLIST}
  Push "/UNINSTALL"
  Call un.PFI_StrStr
  Pop ${L_PARAMETER}
  StrCmp ${L_PARAMETER} "" try_modify
  StrCpy ${L_PARAMETER} ${L_PARAMETER} 11
  StrCmp ${L_PARAMETER} "/UNINSTALL" uninstall_mode
  StrCmp ${L_PARAMETER} "/UNINSTALL " uninstall_mode

try_modify:
  Push ${L_OPTIONLIST}
  Push "/MODIFY"
  Call un.PFI_StrStr
  Pop ${L_PARAMETER}
  StrCmp ${L_PARAMETER} "" undefined_mode
  StrCpy ${L_PARAMETER} ${L_PARAMETER} 8
  StrCmp ${L_PARAMETER} "/MODIFY" modify_mode
  StrCmp ${L_PARAMETER} "/MODIFY " modify_mode

undefined_mode:
  !insertmacro MUI_INSTALLOPTIONS_WRITE "ioUM.ini" "Field 1" "State" 0
  !insertmacro MUI_INSTALLOPTIONS_WRITE "ioUM.ini" "Field 2" "State" 0
  Goto insert_lang_strings

modify_mode:
  !insertmacro MUI_INSTALLOPTIONS_WRITE "ioUM.ini" "Field 1" "State" 1
  !insertmacro MUI_INSTALLOPTIONS_WRITE "ioUM.ini" "Field 2" "State" 0
  Goto insert_lang_strings

uninstall_mode:
  !insertmacro MUI_INSTALLOPTIONS_WRITE "ioUM.ini" "Field 1" "State" 0
  !insertmacro MUI_INSTALLOPTIONS_WRITE "ioUM.ini" "Field 2" "State" 1

insert_lang_strings:

  ; Insert appropriate language strings into the custom page's INI file

  Call un.SelectMode_Init

  Pop ${L_PARAMETER}
  Pop ${L_OPTIONLIST}

  Pop ${L_RESERVED}

  !undef L_OPTIONLIST
  !undef L_PARAMETER

  !undef L_RESERVED

FunctionEnd

#--------------------------------------------------------------------------
# Uninstaller Function: un.SelectMode_Init
#
# This function adds language texts to the INI file for the custom page used
# to select the uninstaller mode (to make the custom page use the language
# selected by the user for the installer)
#--------------------------------------------------------------------------

Function un.SelectMode_Init

  ; Ensure custom page matches the selected language (left-to-right or right-to-left order)

  !insertmacro MUI_INSTALLOPTIONS_WRITE "ioUM.ini" "Settings" "RTL" "$(^RTL)"

  ; Identify and describe the two radio buttons used to select the uninstaller mode

  !insertmacro PFI_IO_TEXT "ioUM.ini" "1" "$(PFI_LANG_UN_IO_MODE_RADIO)"
  !insertmacro PFI_IO_TEXT "ioUM.ini" "3" "$(PFI_LANG_UN_IO_MODE_LABEL)"

  !insertmacro PFI_IO_TEXT "ioUM.ini" "2" "$(PFI_LANG_UN_IO_UNINST_RADIO)"
  !insertmacro PFI_IO_TEXT "ioUM.ini" "4" "$(PFI_LANG_UN_IO_UNINST_LABEL)"

FunctionEnd


#--------------------------------------------------------------------------
# Uninstaller Function: un.SelectMode
#
# Starting with the 1.0.0 release the POPFile uninstaller offers two modes:
# (1) Change the existing installation (add SSL Support, change the Nihongo parser)
# (2) Uninstall the POPFile program
#--------------------------------------------------------------------------

Function un.SelectMode

  !define L_RESULT  $R9

  Push ${L_RESULT}

  ; Ensure custom page matches the selected language (left-to-right or right-to-left order)

  !insertmacro MUI_INSTALLOPTIONS_WRITE "ioUM.ini" "Settings" "RTL" "$(^RTL)"

  !insertmacro MUI_HEADER_TEXT "$(PFI_LANG_UN_MODE_TITLE)" "$(PFI_LANG_UN_MODE_SUBTITLE)"

loop:
  !insertmacro MUI_INSTALLOPTIONS_DISPLAY_RETURN "ioUM.ini"
  Pop ${L_RESULT}
  StrCmp ${L_RESULT} "success" check_selection
  Abort

check_selection:
  !insertmacro MUI_INSTALLOPTIONS_READ "$G_UNINST_MODE " "ioUM.ini" "Field 1" "State"
  StrCmp $G_UNINST_MODE 0 try_other_button
  StrCpy $G_UNINST_MODE "change"
  Goto exit

try_other_button:
  !insertmacro MUI_INSTALLOPTIONS_READ "$G_UNINST_MODE " "ioUM.ini" "Field 2" "State"
  StrCmp $G_UNINST_MODE 0 loop
  StrCpy $G_UNINST_MODE "uninstall"

exit:
  Pop ${L_RESULT}

  !undef L_RESULT

FunctionEnd

#--------------------------------------------------------------------------
# Uninstaller Function: un.ComponentsCheckModeFlag
#
# The "pre" function for the uninstaller's COMPONENTS page
# which is only shown when modifying the existing installation
#--------------------------------------------------------------------------

Function un.ComponentsCheckModeFlag

  StrCmp $G_UNINST_MODE "change" exit
  StrCmp $G_UNINST_MODE "uninstall" skip_page
  MessageBox MB_OK "Internal Error: unexpected mode ($G_UNINST_MODE)"

skip_page:
  Abort

exit:
FunctionEnd

#--------------------------------------------------------------------------
# Uninstaller Function: un.DirectoryCheckModeFlag
#
# The "pre" function for the uninstaller's DIRECTORY page
# which is only shown when modifying the existing installation
#--------------------------------------------------------------------------

Function un.DirectoryCheckModeFlag

  StrCmp $G_UNINST_MODE "change" exit
  Abort

exit:
FunctionEnd

#--------------------------------------------------------------------------
# Uninstaller Function: un.UninstallCheckModeFlag
#
# The "pre" function for the uninstaller's confirmation page
# which is only shown when uninstalling the POPFile program
#--------------------------------------------------------------------------

Function un.UninstallCheckModeFlag

  StrCmp $G_UNINST_MODE "uninstall" exit
  StrCmp $G_UNINST_MODE "change" skip_page
  MessageBox MB_OK "Internal Error: unexpected mode ($G_UNINST_MODE)"

skip_page:
  Abort

exit:
FunctionEnd

#--------------------------------------------------------------------------
# Sections used to modify an existing installation (executed in the order shown)
#
#  (0) Custom Page (SelectMode) offering "Modify" or "Uninstall" options
#
#  (1) un.Uninstall Begin    - requests confirmation if appropriate
#  (2) un.StartLog           - generates a log showing the actions performed
#  (3) un.Shutdown POPFile   - shutdown POPFile if necessary (to avoid the need to reboot)
#  (4) un.AddSSLSupport      - downloads and installs the SSL support files
#  (5) un.Nihongo Parser     - offers a choice of 3 parsers (Kakasi, MeCab and internal)
#  (6) un.Kakasi             - installs Kakasi package and creates its environment variables
#  (7) un.MeCab              - downloads and installs MeCab package and its environment variables
#  (8) un.Internal           - installs support for the internal parser
#  (9) un.StopLog            - saves the log file (up to 3 previous versions retained)
#
# Note: Only one of the three Nihongo parsers can be added at a time (re-run to add more)
#--------------------------------------------------------------------------
# Sections used to uninstall POPFile (executed in the order shown)
#
#  (0) Custom Page (SelectMode) offering "Modify" or "Uninstall" options
#
#  (1) un.Uninstall Begin    - requests confirmation if appropriate
#  (2) un.StartLog           - generates a log showing the actions performed
#  (3) un.Local User Data    - looks for and removes 'User Data' from the PROGRAM folder
#  (4) un.Shutdown POPFile   - shutdown POPFile if necessary (to avoid the need to reboot)
#  (5) un.Start Menu Entries - remove StartUp shortcuts and Start Menu entries
#  (6) un.POPFile Core       - uninstall POPFile PROGRAM files
#  (7) un.Skins              - uninstall POPFile skins
#  (8) un.Languages          - uninstall POPFile UI languages
#  (9) un.QuickStart Guide   - uninstall POPFile English QuickStart Guide
# (10) un.Remove Kakasi      - uninstall Kakasi package and remove its environment variables
# (11) un.Remove MeCab       - uninstall MeCab package and remove its environment variables
# (12) un.Minimal Perl       - uninstall minimal Perl, including all of the optional modules
# (13) un.Registry Entries   - remove 'Add/Remove Program' data and other registry entries
# (14) un.Uninstall End      - remove remaining files/folders (if it is safe to do so)
#
#--------------------------------------------------------------------------

#--------------------------------------------------------------------------
# Uninstaller Section: 'un.Uninstall Begin' (the first section in the uninstaller)
#--------------------------------------------------------------------------

Section "-un.Uninstall Begin" UnSecBegin

  !define L_TEMP        $R9

  Push ${L_TEMP}

  ; Access the POPFile User Data for the user who started the uninstaller
  ; (use the UAC plugin in case this was a non-admin user)

  DetailPrint "Use UAC plugin to get the 'real' user data"

  GetFunctionAddress ${L_TEMP} un.Uninstall_Begin
  UAC::ExecCodeSegment ${L_TEMP}

  Pop ${L_TEMP}

  !undef L_TEMP

SectionEnd

#--------------------------------------------------------------------------
# Uninstaller Section: 'un.StartLog' (this must be the second section)
#
# Creates the log header with information about this run of the uninstaller
#--------------------------------------------------------------------------

Section "-un.StartLog"

  SetDetailsPrint listonly

  DetailPrint "------------------------------------------------------------"
  DetailPrint "$(^Name) v${C_PFI_VERSION} Uninstaller Log"
  DetailPrint "------------------------------------------------------------"
  DetailPrint "Command-line: $CMDLINE"
  DetailPrint "$$INSTDIR    : $INSTDIR"
  DetailPrint "User Details: $G_WINUSERNAME ($G_WINUSERTYPE)"
  DetailPrint "PFI Language: $LANGUAGE"
  DetailPrint "------------------------------------------------------------"
  Call un.PFI_GetDateTimeStamp
  Pop $G_PLS_FIELD_1
  DetailPrint "Uninstaller started $G_PLS_FIELD_1"
  DetailPrint "------------------------------------------------------------"
  DetailPrint ""

SectionEnd

#--------------------------------------------------------------------------
# Uninstaller Section: 'un.Local User Data'
#
# There may be 'User Data' in the same folder as the PROGRAM files (especially if this is
# an upgraded installation) so we must run the 'User Data' uninstaller before we uninstall
# POPFile (to restore any email settings changed by the installer).
#--------------------------------------------------------------------------

Section "-un.Local User Data" UnSecUserData

  StrCmp $G_UNINST_MODE "change" skip_section

  !define L_RESULT    $R9

  Push ${L_RESULT}

  IfFileExists "$G_ROOTDIR\popfile.pl" look_for_uninstalluser
  IfFileExists "$G_ROOTDIR\popfile.exe" look_for_uninstalluser
    MessageBox MB_YESNO|MB_ICONSTOP|MB_DEFBUTTON2 \
        "$(PFI_LANG_UN_MBNOTFOUND_1) '$G_ROOTDIR'.\
        ${MB_NL}${MB_NL}\
        $(PFI_LANG_UN_MBNOTFOUND_2)" IDYES look_for_uninstalluser
    Abort "$(PFI_LANG_UN_ABORT_1)"

look_for_uninstalluser:
  IfFileExists "$G_ROOTDIR\uninstalluser.exe" 0 section_exit

  SetDetailsPrint textonly
  DetailPrint " "
  SetDetailsPrint listonly

  ; Uninstall the 'User Data' in the PROGRAM folder before uninstalling the PROGRAM files
  ; (note that running 'uninstalluser.exe' with the '_?=dir' option means it will be unable
  ; to delete itself because the program is NOT automatically relocated to the TEMP folder)

  HideWindow
  ExecWait '"$G_ROOTDIR\uninstalluser.exe" _?=$G_ROOTDIR' ${L_RESULT}
  BringToFront

  ; If the 'User Data' uninstaller did not return the normal "success" code (e.g. because user
  ; cancelled the 'User Data' uninstall) then we must retain the user data and uninstalluser.exe

  StrCmp ${L_RESULT} "0" 0 section_exit

  ; If any email settings have NOT been restored and the user wishes to try again later,
  ; the relevant INI file will still exist and we should not remove it or uninstalluser.exe

  IfFileExists "$G_ROOTDIR\pfi-outexpress.ini" section_exit
  IfFileExists "$G_ROOTDIR\pfi-outlook.ini" section_exit
  IfFileExists "$G_ROOTDIR\pfi-eudora.ini" section_exit
  Delete "$G_ROOTDIR\uninstalluser.exe"

section_exit:
  SetDetailsPrint textonly
  DetailPrint " "
  SetDetailsPrint listonly

  Pop ${L_RESULT}

  !undef L_RESULT

skip_section:
SectionEnd

#--------------------------------------------------------------------------
# Uninstaller Section: 'un.Shutdown POPFile'
#--------------------------------------------------------------------------

Section "-un.Shutdown POPFile" UnSecShutdown

  !define L_TEMP        $R9

  Push ${L_TEMP}

  SetDetailsPrint textonly
  DetailPrint "$(PFI_LANG_UN_PROG_SHUTDOWN)"
  SetDetailsPrint listonly

  ; Starting with POPfile 0.21.0 an experimental version of 'popfile-service.exe' was included
  ; to allow POPFile to be run as a Windows service.

  Push "POPFile"
  Call un.PFI_ServiceRunning
  Pop ${L_TEMP}
  StrCmp ${L_TEMP} "true" manual_shutdown

  ; If the POPFile we are to uninstall is still running, one of the EXE files will be 'locked'

  Push $G_ROOTDIR
  Call un.PFI_FindLockedPFE
  Pop ${L_TEMP}
  StrCmp ${L_TEMP} "" check_pfi_utils

  ; The program files we are about to remove are in use so we need to shut POPFile down

  DetailPrint "Use UAC plugin to call 'un.Shutdown_POPFile' function (${L_TEMP})"

  GetFunctionAddress ${L_TEMP} un.Shutdown_POPFile
  UAC::ExecCodeSegment ${L_TEMP}
  Goto check_pfi_utils

manual_shutdown:
  Call un.RequestManualShutdown

  ; Assume user has managed to shutdown POPFile

check_pfi_utils:
  Push $G_ROOTDIR
  Call un.PFI_RequestPFIUtilsShutdown

  SetDetailsPrint textonly
  DetailPrint " "
  SetDetailsPrint listonly
  DetailPrint ""

  Pop ${L_TEMP}

  !undef L_TEMP

SectionEnd

#--------------------------------------------------------------------------
# Uninstaller Section: 'un.SecSSL'
#--------------------------------------------------------------------------

  !insertmacro HANDLE_ADDING_SSL_SUPPORT

#--------------------------------------------------------------------------
# Uninstaller Section: 'un.Nihongo Parser'
#--------------------------------------------------------------------------

  !insertmacro SECTION_NIHONGO_PARSER "un."

#--------------------------------------------------------------------------
# Uninstaller Section: 'un.Kakasi'
#--------------------------------------------------------------------------

  !insertmacro SECTION_KAKASI "un."

#--------------------------------------------------------------------------
# Uninstaller Section: 'un.MeCab'
#--------------------------------------------------------------------------

  !insertmacro SECTION_MECAB "un."

#--------------------------------------------------------------------------
# Uninstaller Function: un.VerifyMeCabInstall
#
# Inputs:
#         (top of stack)     - full path to the top-level MeCab folder
# Outputs:
#         (top of stack)     - result ("OK" or "fail")
#--------------------------------------------------------------------------

  !insertmacro FUNCTION_VERIFY_MECAB_INSTALL "un."

#--------------------------------------------------------------------------
# Uninstaller Function: un.GetMeCabFile
#
# Inputs:
#         (top of stack)     - full URL used to download the MeCab file
# Outputs:
#         (top of stack)     - status returned by the download plugin
#--------------------------------------------------------------------------

  !insertmacro FUNCTION_GETMECABFILE "un."

#--------------------------------------------------------------------------
# Uninstaller Section: 'un.Internal'
#--------------------------------------------------------------------------

  !insertmacro SECTION_INTERNALPARSER "un."

#--------------------------------------------------------------------------
# Uninstaller Section: 'un.Start Menu Entries'
#--------------------------------------------------------------------------

  !macro CHECK_SHORTCUT_TARGET SHORTCUT_FILE EXPECTED_TARGET

      !insertmacro PFI_UNIQUE_ID

      IfFileExists "${SHORTCUT_FILE}" 0 try_next_${PFI_UNIQUE_ID}
      ShellLink::GetShortCutTarget "${SHORTCUT_FILE}"
      Pop ${L_TARGET}
      StrCmp ${L_TARGET} "${EXPECTED_TARGET}" delete_menu_entries

    try_next_${PFI_UNIQUE_ID}:
  !macroend

Section "-un.Start Menu Entries" UnSecStartMenu

  StrCmp $G_UNINST_MODE "change" skip_section

  !define L_TARGET      $R9

  Push ${L_TARGET}

  SetDetailsPrint textonly
  DetailPrint "$(PFI_LANG_UN_PROG_SHORT)"
  SetDetailsPrint listonly

  ; The UAC plugin ensures we have admin rights

  SetShellVarContext all

  ; Check if the Start Menu shortcuts refer to the installation we are removing
  ; (if they don't then leave them alone)

  !insertmacro CHECK_SHORTCUT_TARGET \
      "$SMPROGRAMS\${C_PFI_PRODUCT}\Run POPFile.lnk" \
      "$G_ROOTDIR\runpopfile.exe"

  !insertmacro CHECK_SHORTCUT_TARGET \
      "$SMPROGRAMS\${C_PFI_PRODUCT}\Uninstall POPFile.lnk" \
      "$G_ROOTDIR\uninstall.exe"

  !insertmacro CHECK_SHORTCUT_TARGET \
      "$SMPROGRAMS\${C_PFI_PRODUCT}\Support\PFI Diagnostic utility (simple).lnk" \
      "$G_ROOTDIR\pfidiag.exe"

  !insertmacro CHECK_SHORTCUT_TARGET \
      "$SMPROGRAMS\${C_PFI_PRODUCT}\Support\PFI Diagnostic utility (full).lnk" \
      "$G_ROOTDIR\pfidiag.exe"

  Goto exit

delete_menu_entries:
  SetShellVarContext current
  StrCpy ${L_TARGET} "$SMPROGRAMS\${C_PFI_PRODUCT}\Support\"
  SetShellVarContext all
  StrCmp ${L_TARGET} "$SMPROGRAMS\${C_PFI_PRODUCT}\Support\" 0 remove_all
  IfFileExists "$SMPROGRAMS\${C_PFI_PRODUCT}\Support\Create 'User Data' shortcut.lnk" skip_site_entries

remove_all:
  Delete "$SMPROGRAMS\${C_PFI_PRODUCT}\FAQ.url"
  Delete "$SMPROGRAMS\${C_PFI_PRODUCT}\Support\POPFile Home Page.url"
  Delete "$SMPROGRAMS\${C_PFI_PRODUCT}\Support\POPFile Support (Wiki).url"

skip_site_entries:
  Delete "$SMPROGRAMS\${C_PFI_PRODUCT}\Support\PFI Diagnostic utility (simple).lnk"
  Delete "$SMPROGRAMS\${C_PFI_PRODUCT}\Support\PFI Diagnostic utility (full).lnk"
  RMDir "$SMPROGRAMS\${C_PFI_PRODUCT}\Support"

  Delete "$SMPROGRAMS\${C_PFI_PRODUCT}\Release Notes.lnk"
  Delete "$SMPROGRAMS\${C_PFI_PRODUCT}\Run POPFile.lnk"

  Delete "$SMPROGRAMS\${C_PFI_PRODUCT}\Uninstall POPFile.lnk"
  RMDir "$SMPROGRAMS\${C_PFI_PRODUCT}"

exit:

  ; Restore the default NSIS context

  SetShellVarContext current

  SetDetailsPrint textonly
  DetailPrint " "
  SetDetailsPrint listonly

  Pop ${L_TARGET}

  !undef L_TARGET

skip_section:
SectionEnd

#--------------------------------------------------------------------------
# Uninstaller Section: 'un.POPFile Core'
#
# Files are explicitly deleted (instead of just using wildcards or 'RMDir /r' commands)
# in an attempt to avoid unexpectedly deleting any files created by the user after installation.
# Current commands only cover most recent versions of POPFile - need to add commands to cover
# more of the early versions of POPFile.
#--------------------------------------------------------------------------

Section "-un.POPFile Core" UnSecCore

  StrCmp $G_UNINST_MODE "change" skip_section

  SetDetailsPrint textonly
  DetailPrint "$(PFI_LANG_UN_PROG_CORE)"
  SetDetailsPrint listonly

  Delete "$G_ROOTDIR\wrapper.exe"
  Delete "$G_ROOTDIR\wrapperf.exe"
  Delete "$G_ROOTDIR\wrapperb.exe"
  Delete "$G_ROOTDIR\wrapper.ini"

  Delete "$G_ROOTDIR\runpopfile.exe"
  Delete "$G_ROOTDIR\adduser.exe"
  Delete "$G_ROOTDIR\runsqlite.exe"
  Delete "$G_ROOTDIR\sqlite.exe"

  Delete "$G_ROOTDIR\msgcapture.exe"
  Delete "$G_ROOTDIR\pfidbstatus.exe"
  Delete "$G_ROOTDIR\pfidiag.exe"
  Delete "$G_ROOTDIR\pfimsgcapture.exe"

  IfFileExists "$G_ROOTDIR\msgcapture.exe" try_again
  IfFileExists "$G_ROOTDIR\pfidbstatus.exe" try_again
  IfFileExists "$G_ROOTDIR\pfidiag.exe" try_again
  IfFileExists "$G_ROOTDIR\pfimsgcapture.exe" 0 continue

try_again:
  Sleep 1000
  Delete "$G_ROOTDIR\msgcapture.exe"
  Delete "$G_ROOTDIR\pfidbstatus.exe"
  Delete "$G_ROOTDIR\pfidiag.exe"
  Delete "$G_ROOTDIR\pfimsgcapture.exe"

continue:
  Delete "$G_ROOTDIR\otto.png"
  Delete "$G_ROOTDIR\*.gif"
  Delete "$G_ROOTDIR\*.change"
  Delete "$G_ROOTDIR\*.change.txt"

  Delete "$G_ROOTDIR\pfi-data.ini"

  Delete "$G_ROOTDIR\popfile.pl"
  Delete "$G_ROOTDIR\popfile-check-setup.pl"
  Delete "$G_ROOTDIR\popfile.pck"
  Delete "$G_ROOTDIR\*.pm"

  Delete "$G_ROOTDIR\bayes.pl"
  Delete "$G_ROOTDIR\insert.pl"
  Delete "$G_ROOTDIR\pipe.pl"
  Delete "$G_ROOTDIR\favicon.ico"
  Delete "$G_ROOTDIR\popfile.exe"
  Delete "$G_ROOTDIR\popfilef.exe"
  Delete "$G_ROOTDIR\popfileb.exe"
  Delete "$G_ROOTDIR\popfileif.exe"
  Delete "$G_ROOTDIR\popfileib.exe"
  Delete "$G_ROOTDIR\popfile-service.exe"
  Delete "$G_ROOTDIR\stop_pf.exe"
  Delete "$G_ROOTDIR\license"
  Delete "$G_ROOTDIR\pfi-stopwords.default"

  Delete "$G_ROOTDIR\Classifier\*.pm"
  Delete "$G_ROOTDIR\Classifier\popfile.sql"
  RMDir "$G_ROOTDIR\Classifier"

  Delete "$G_ROOTDIR\Platform\*.pm"
  Delete "$G_ROOTDIR\Platform\*.dll"
  RMDir "$G_ROOTDIR\Platform"

  Delete "$G_ROOTDIR\POPFile\*.pm"
  Delete "$G_ROOTDIR\POPFile\popfile_version"
  RMDir "$G_ROOTDIR\POPFile"

  Delete "$G_ROOTDIR\Proxy\*.pm"
  RMDir "$G_ROOTDIR\Proxy"

  Delete "$G_ROOTDIR\Server\*.pm"
  RMDir "$G_ROOTDIR\Server"

  Delete "$G_ROOTDIR\Services\IMAP\*.pm"
  RMDir "$G_ROOTDIR\Services\IMAP"
  Delete "$G_ROOTDIR\Services\*.pm"
  RMDir "$G_ROOTDIR\Services"

  Delete "$G_ROOTDIR\UI\*.pm"
  RMDir "$G_ROOTDIR\UI"

  SetDetailsPrint textonly
  DetailPrint " "
  SetDetailsPrint listonly

skip_section:
SectionEnd

#--------------------------------------------------------------------------
# Uninstaller Section: 'un.Skins'
#--------------------------------------------------------------------------

Section "-un.Skins" UnSecSkins

  StrCmp $G_UNINST_MODE "change" skip_section

  SetDetailsPrint textonly
  DetailPrint "$(PFI_LANG_UN_PROG_SKINS)"
  SetDetailsPrint listonly

  !insertmacro PFI_DeleteSkin "$G_ROOTDIR\skins\blue"
  !insertmacro PFI_DeleteSkin "$G_ROOTDIR\skins\coolblue"
  !insertmacro PFI_DeleteSkin "$G_ROOTDIR\skins\coolbrown"
  !insertmacro PFI_DeleteSkin "$G_ROOTDIR\skins\coolgreen"
  !insertmacro PFI_DeleteSkin "$G_ROOTDIR\skins\coolmint"
  !insertmacro PFI_DeleteSkin "$G_ROOTDIR\skins\coolorange"
  !insertmacro PFI_DeleteSkin "$G_ROOTDIR\skins\coolyellow"
  !insertmacro PFI_DeleteSkin "$G_ROOTDIR\skins\default"
  !insertmacro PFI_DeleteSkin "$G_ROOTDIR\skins\glassblue"
  !insertmacro PFI_DeleteSkin "$G_ROOTDIR\skins\green"
  !insertmacro PFI_DeleteSkin "$G_ROOTDIR\skins\klingon"
  !insertmacro PFI_DeleteSkin "$G_ROOTDIR\skins\lavish"
  !insertmacro PFI_DeleteSkin "$G_ROOTDIR\skins\lrclaptop"
  !insertmacro PFI_DeleteSkin "$G_ROOTDIR\skins\ocean"
  !insertmacro PFI_DeleteSkin "$G_ROOTDIR\skins\oceanblue"
  !insertmacro PFI_DeleteSkin "$G_ROOTDIR\skins\orange"
  !insertmacro PFI_DeleteSkin "$G_ROOTDIR\skins\orangecream"
  !insertmacro PFI_DeleteSkin "$G_ROOTDIR\skins\osx"
  !insertmacro PFI_DeleteSkin "$G_ROOTDIR\skins\outlook"
  !insertmacro PFI_DeleteSkin "$G_ROOTDIR\skins\prjbluegrey"
  !insertmacro PFI_DeleteSkin "$G_ROOTDIR\skins\prjsteelbeach"
  !insertmacro PFI_DeleteSkin "$G_ROOTDIR\skins\simplyblue"
  !insertmacro PFI_DeleteSkin "$G_ROOTDIR\skins\sleet"
  !insertmacro PFI_DeleteSkin "$G_ROOTDIR\skins\sleet-rtl"
  !insertmacro PFI_DeleteSkin "$G_ROOTDIR\skins\smalldefault"
  !insertmacro PFI_DeleteSkin "$G_ROOTDIR\skins\smallgrey"
  !insertmacro PFI_DeleteSkin "$G_ROOTDIR\skins\strawberryrose"
  !insertmacro PFI_DeleteSkin "$G_ROOTDIR\skins\tinydefault"
  !insertmacro PFI_DeleteSkin "$G_ROOTDIR\skins\tinygrey"
  !insertmacro PFI_DeleteSkin "$G_ROOTDIR\skins\white"
  !insertmacro PFI_DeleteSkin "$G_ROOTDIR\skins\windows"

  RMDir "$G_ROOTDIR\skins"

  SetDetailsPrint textonly
  DetailPrint " "
  SetDetailsPrint listonly

skip_section:
SectionEnd

#--------------------------------------------------------------------------
# Uninstaller Section: 'un.Languages'
#--------------------------------------------------------------------------

Section "-un.Languages" UnSecLangs

  StrCmp $G_UNINST_MODE "change" skip_section

  SetDetailsPrint textonly
  DetailPrint " "
  SetDetailsPrint listonly

  Delete "$G_ROOTDIR\languages\*.msg"
  RMDir "$G_ROOTDIR\languages"

  SetDetailsPrint textonly
  DetailPrint " "
  SetDetailsPrint listonly

skip_section:
SectionEnd

#--------------------------------------------------------------------------
# Uninstaller Section: 'un.QuickStart Guide'
#--------------------------------------------------------------------------

Section "-un.QuickStart Guide" UnSecQuickGuide

  StrCmp $G_UNINST_MODE "change" skip_section

  SetDetailsPrint textonly
  DetailPrint " "
  SetDetailsPrint listonly

  Delete "$G_ROOTDIR\manual\en\*.html"
  RMDir "$G_ROOTDIR\manual\en"
  Delete "$G_ROOTDIR\manual\*.gif"
  RMDir "$G_ROOTDIR\manual"

  SetDetailsPrint textonly
  DetailPrint " "
  SetDetailsPrint listonly

skip_section:
SectionEnd

#--------------------------------------------------------------------------
# Uninstaller Section: 'un.Kakasi'
#--------------------------------------------------------------------------

Section "-un.Remove Kakasi" UnSecRemoveKakasi

  StrCmp $G_UNINST_MODE "change" skip_section

  !define L_TEMP        $R9

  Push ${L_TEMP}

  IfFileExists "$INSTDIR\kakasi\*.*" 0 section_exit

  SetDetailsPrint textonly
  DetailPrint " "
  SetDetailsPrint listonly

  RMDir /r "$INSTDIR\kakasi"

  ;Delete Environment Variables

  Push "KANWADICTPATH"
  Call un.PFI_DeleteEnvStr
  Push "ITAIJIDICTPATH"
  Call un.PFI_DeleteEnvStr

  ; If the 'all users' environment variables refer to this installation, remove them too

  ReadEnvStr ${L_TEMP} "KANWADICTPATH"
  Push ${L_TEMP}
  Push $INSTDIR
  Call un.PFI_StrStr
  Pop ${L_TEMP}
  StrCmp ${L_TEMP} "" section_exit
  Push "KANWADICTPATH"
  Call un.PFI_DeleteEnvStrNTAU
  Push "ITAIJIDICTPATH"
  Call un.PFI_DeleteEnvStrNTAU

section_exit:
  SetDetailsPrint textonly
  DetailPrint " "
  SetDetailsPrint listonly

  Pop ${L_TEMP}

  !undef L_TEMP

skip_section:
SectionEnd

#--------------------------------------------------------------------------
# Uninstaller Section: 'un.RemoveMeCab'
#--------------------------------------------------------------------------

Section "-un.Remove MeCab" UnSecRemoveMeCab

  StrCmp $G_UNINST_MODE "change" skip_section

  !define L_TEMP        $R9

  Push ${L_TEMP}

  IfFileExists "$INSTDIR\mecab\*.*" 0 section_exit

  SetDetailsPrint textonly
  DetailPrint " "
  SetDetailsPrint listonly

  RMDir /r "$INSTDIR\mecab"

  ; Delete Environment Variables

  Push "MECABRC"
  Call un.PFI_DeleteEnvStr

  ; If the 'all users' environment variables refer to this installation, remove them too

  ReadEnvStr ${L_TEMP} "MECABRC"
  Push ${L_TEMP}
  Push $INSTDIR
  Call un.PFI_StrStr
  Pop ${L_TEMP}
  StrCmp ${L_TEMP} "" section_exit
  Push "MECABRC"
  Call un.PFI_DeleteEnvStrNTAU

section_exit:
  SetDetailsPrint textonly
  DetailPrint " "
  SetDetailsPrint listonly

  Pop ${L_TEMP}

  !undef L_TEMP

skip_section:
SectionEnd

#--------------------------------------------------------------------------
# Uninstaller Section: 'un.Minimal Perl'
#--------------------------------------------------------------------------

Section "-un.Minimal Perl" UnSecMinPerl

  StrCmp $G_UNINST_MODE "change" skip_section

  SetDetailsPrint textonly
  DetailPrint "$(PFI_LANG_UN_PROG_PERL)"
  SetDetailsPrint listonly

  Delete "$G_ROOTDIR\perl*.dll"
  Delete "$G_ROOTDIR\perl.exe"
  Delete "$G_ROOTDIR\wperl.exe"

  ; Win95 displays an error message if an attempt is made to delete non-existent folders
  ; (so we check before removing optional Perl components which may not have been installed)

  IfFileExists "$G_MPLIBDIR\HTTP\*.*" 0 skip_XMLRPC_support
  RMDir /r "$G_MPLIBDIR\HTTP"
  RMDir /r "$G_MPLIBDIR\LWP"
  RMDir /r "$G_MPLIBDIR\Net"
  RMDir /r "$G_MPLIBDIR\SOAP"
  RMDir /r "$G_MPLIBDIR\URI"
  RMDir /r "$G_MPLIBDIR\XML"
  RMDir /r "$G_MPLIBDIR\XMLRPC"

skip_XMLRPC_support:
  IfFileExists "$G_MPLIBDIR\Net\SSLeay\*.*" 0 skip_SSL_support
  RMDir /r "$G_MPLIBDIR\Net"

skip_SSL_support:
  RMDir /r "$G_MPLIBDIR\auto"
  RMDir /r "$G_MPLIBDIR\Carp"
  RMDir /r "$G_MPLIBDIR\Class"
  RMDir /r "$G_MPLIBDIR\Crypt"
  RMDir /r "$G_MPLIBDIR\Data"
  RMDir /r "$G_MPLIBDIR\Date"
  RMDir /r "$G_MPLIBDIR\DBD"
  RMDir /r "$G_MPLIBDIR\Digest"
  IfFileExists "$G_MPLIBDIR\Encode\*.*" 0 skip_Encode
  RMDir /r "$G_MPLIBDIR\Encode"

skip_Encode:
  RMDir /r "$G_MPLIBDIR\Exporter"
  RMDir /r "$G_MPLIBDIR\File"
  RMDir /r "$G_MPLIBDIR\Getopt"
  RMDir /r "$G_MPLIBDIR\HTML"
  RMDir /r "$G_MPLIBDIR\IO"
  RMDir /r "$G_MPLIBDIR\List"
  RMDir /r "$G_MPLIBDIR\Math"
  RMDir /r "$G_MPLIBDIR\MIME"
  RMDir /r "$G_MPLIBDIR\Scalar"
  RMDir /r "$G_MPLIBDIR\String"
  RMDir /r "$G_MPLIBDIR\Sys"
  RMDir /r "$G_MPLIBDIR\Text"
  RMDir /r "$G_MPLIBDIR\Tie"
  RMDir /r "$G_MPLIBDIR\Time"
  RMDir /r "$G_MPLIBDIR\warnings"
  RMDir /r "$G_MPLIBDIR\Win32"
  Delete "$G_MPLIBDIR\*.pm"
  Delete "$G_MPLIBDIR\*.pl"
  RMDIR "$G_MPLIBDIR"

  SetDetailsPrint textonly
  DetailPrint " "
  SetDetailsPrint listonly

skip_Section:
SectionEnd

#--------------------------------------------------------------------------
# Uninstaller Section: 'un.Registry Entries'
#--------------------------------------------------------------------------

Section "-un.Registry Entries" UnSecRegistry

  StrCmp $G_UNINST_MODE "change" skip_section

  !define L_REGDATA $R9

  Push ${L_REGDATA}

  SetDetailsPrint textonly
  DetailPrint " "
  SetDetailsPrint listonly

  ; Only remove registry data if it matches what we are uninstalling

  ClearErrors
  ReadRegStr ${L_REGDATA} HKLM "SOFTWARE\Microsoft\Windows NT\CurrentVersion" CurrentVersion
  IfErrors check_HKLM_data
  StrCpy ${L_REGDATA} ${L_REGDATA} 1
  StrCmp ${L_REGDATA} '6' 0 check_HKLM_data

  ; Uninstalluser.exe deletes all HKCU registry data except for the 'Add/Remove Programs' entry

  ReadRegStr ${L_REGDATA} HKCU \
      "Software\Microsoft\Windows\CurrentVersion\Uninstall\${C_PFI_PRODUCT}" "UninstallString"
  StrCmp ${L_REGDATA} '"$G_ROOTDIR\uninstall.exe" /UNINSTALL' 0 real_user
  DeleteRegKey HKCU "Software\Microsoft\Windows\CurrentVersion\Uninstall\${C_PFI_PRODUCT}"

real_user:
  GetFunctionAddress ${L_REGDATA} un.DeleteDataFromHKCU
  UAC::ExecCodeSegment ${L_REGDATA}

check_HKLM_data:
  ReadRegStr ${L_REGDATA} HKLM \
      "Software\Microsoft\Windows\CurrentVersion\Uninstall\${C_PFI_PRODUCT}" "UninstallString"
  StrCmp ${L_REGDATA} '"$G_ROOTDIR\uninstall.exe" /UNINSTALL' 0 other_reg_data
  DeleteRegKey HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${C_PFI_PRODUCT}"

other_reg_data:
  ReadRegStr ${L_REGDATA} HKLM "Software\POPFile Project\${C_PFI_PRODUCT}\MRI" "RootDir_LFN"
  StrCmp ${L_REGDATA} $G_ROOTDIR 0 section_exit
  DeleteRegKey HKLM "Software\POPFile Project\${C_PFI_PRODUCT}\MRI"
  DeleteRegKey /ifempty HKLM "Software\POPFile Project\${C_PFI_PRODUCT}"
  DeleteRegKey /ifempty HKLM "Software\POPFile Project"
  DeleteRegKey HKLM "Software\Microsoft\Windows\CurrentVersion\App Paths\stop_pf.exe"

section_exit:
  SetDetailsPrint textonly
  DetailPrint " "
  SetDetailsPrint listonly

  Pop ${L_REGDATA}

  !undef L_REGDATA

skip_section:
SectionEnd

#--------------------------------------------------------------------------
# Uninstaller Function: 'un.DeleteDataFromHKCU'
#--------------------------------------------------------------------------

Function un.DeleteDataFromHKCU

  !define L_REGDATA $R9

  Push ${L_REGDATA}

  ReadRegStr ${L_REGDATA} HKCU \
      "Software\Microsoft\Windows\CurrentVersion\Uninstall\${C_PFI_PRODUCT}" "UninstallString"
  StrCmp ${L_REGDATA} '"$G_ROOTDIR\uninstall.exe" /UNINSTALL' 0 exit
  DeleteRegKey HKCU "Software\Microsoft\Windows\CurrentVersion\Uninstall\${C_PFI_PRODUCT}"

exit:
  Pop ${L_REGDATA}

  !undef L_REGDATA

FunctionEnd

#--------------------------------------------------------------------------
# Uninstaller Section: 'un.Uninstall End' (this is the penultimate section in the uninstaller)
#
# Used to terminate the uninstaller - offers to remove any files/folders left behind.
# If any 'User Data' is left in the PROGRAM folder then we preserve it to allow the
# user to make another attempt at restoring the email settings.
#--------------------------------------------------------------------------

Section "-un.Uninstall End" UnSecEnd

  StrCmp $G_UNINST_MODE "change" skip_section

  Delete "$G_ROOTDIR\modify.log.*"
  Delete "$G_ROOTDIR\modify.log"
  Delete "$G_ROOTDIR\install.log.*"
  Delete "$G_ROOTDIR\install.log"
  Delete "$G_ROOTDIR\Uninstall.exe"
  RMDir "$G_ROOTDIR"

  ; if the installation folder ($G_ROOTDIR) was removed, skip these next ones

  IfFileExists "$G_ROOTDIR\*.*" 0 exit

  ; If 'User Data' uninstaller still exists, we cannot offer to remove the remaining files
  ; (some email settings have not been restored and the user wants to try again later or
  ; the user decided not to uninstall the 'User Data' at the moment)

  IfFileExists "$G_ROOTDIR\uninstalluser.exe" exit

  MessageBox MB_YESNO|MB_ICONQUESTION "$(PFI_LANG_UN_MBREMDIR_1)" IDNO exit
  DetailPrint "$(PFI_LANG_UN_LOG_DELROOTDIR)"
  Delete "$G_ROOTDIR\*.*"
  RMDir /r $G_ROOTDIR
  IfFileExists "$G_ROOTDIR\*.*" 0 exit
  DetailPrint "$(PFI_LANG_UN_LOG_DELROOTERR)"
  StrCpy $G_PLS_FIELD_1 $G_ROOTDIR
  MessageBox MB_OK|MB_ICONEXCLAMATION "$(PFI_LANG_UN_MBREMERR_A)"

exit:
  SetDetailsPrint both

skip_Section:
SectionEnd

#--------------------------------------------------------------------------
# Uninstaller Section: StopLog (this must be the very last section)
#
# Finishes the log file and saves it (making backups of up to 3 previous logs)
#--------------------------------------------------------------------------

Section "-un.StopLog"

  StrCmp $G_UNINST_MODE "uninstall" skip_section

  SetDetailsPrint textonly
  DetailPrint "$(PFI_LANG_PROG_SAVELOG)"
  SetDetailsPrint listonly
  Call un.PFI_GetDateTimeStamp
  Pop $G_PLS_FIELD_1
  DetailPrint "------------------------------------------------------------"
  DetailPrint "Uninstaller (/MODIFY mode) finished $G_PLS_FIELD_1"
  DetailPrint "------------------------------------------------------------"

  ; Save a log showing what was installed

  !insertmacro PFI_BACKUP_123_DP "$G_ROOTDIR" "modify.log"
  Push "$G_ROOTDIR\modify.log"
  Call un.PFI_DumpLog
  DetailPrint "Log report saved in '$G_ROOTDIR\modify.log'"
  SetDetailsPrint textonly
  DetailPrint "$(PFI_LANG_INST_PROG_ENDSEC)"
  SetDetailsPrint listonly

skip_Section:
SectionEnd

#--------------------------------------------------------------------------
# Component-selection page descriptions
#--------------------------------------------------------------------------

  !insertmacro MUI_UNFUNCTION_DESCRIPTION_BEGIN
    !insertmacro MUI_DESCRIPTION_TEXT ${un.SecSSL}         $(DESC_SecSSL)
    !insertmacro MUI_DESCRIPTION_TEXT ${un.SecParser}      "${C_NPLS_DESC_SecParser}"
  !insertmacro MUI_UNFUNCTION_DESCRIPTION_END

#--------------------------------------------------------------------------
# Uninstaller Function: un.ShowOrHideNihongoParser
#
# (called by 'un.PFIGUIInit', our custom 'un.onGUIInit' function)
#
# This function ensures that when 'Nihongo' (Japanese) has been selected as the
# language for the installer, 'Nihongo Parser' appears in the list of components.
#
# If any other language is selected, this component is hidden from view and the
# three parser sections are disabled (i.e. unselected so nothing gets installed).
#
# The default parser is 'Kakasi', as used by POPFile 0.22.5 and earlier releases,
# and this default is set up here, including the initial state of the three
# radio buttons used on the "Choose Parser" custom page.
#
# Note that the 'Nihongo Parser' section is _always_ executed, even if the user
# does not select the 'Nihongo' language.
#--------------------------------------------------------------------------

  !insertmacro FUNCTION_SHOW_OR_HIDE_NIHONGO_PARSER "un."

#--------------------------------------------------------------------------
# Uninstaller Function: 'un.MakeDirectoryPageReadOnly'
#
# (the "pre" function for the uninstaller's DIRECTORY page)
#--------------------------------------------------------------------------

Function un.MakeDirectoryPageReadOnly

  ; Make the DIRECTORY path read-only

  FindWindow $G_DLGITEM "#32770" "" $HWNDPARENT
  GetDlgItem $G_DLGITEM $G_DLGITEM "1019"
  EnableWindow $G_DLGITEM 0

  ; Disable the BROWSE button

  FindWindow $G_DLGITEM "#32770" "" $HWNDPARENT
  GetDlgItem $G_DLGITEM $G_DLGITEM "1001"
  EnableWindow $G_DLGITEM 0

FunctionEnd

#--------------------------------------------------------------------------
# Uninstaller Function: 'un.AdjustUninstHeaderText'
#
# (the "show" function for the uninstaller's INSTFILES page)
#--------------------------------------------------------------------------

Function un.AdjustUninstHeaderText

  StrCmp $G_UNINST_MODE "uninstall" exit

  ; Override the standard "Installing..." page header when we are MODIFYING the installation

  GetDlgItem $G_DLGITEM $HWNDPARENT 1037  ; Header Title Text
  SendMessage $G_DLGITEM ${WM_SETTEXT} 0 "STR:$(MUI_TEXT_INSTALLING_TITLE)"

  GetDlgItem $G_DLGITEM $HWNDPARENT 1038  ; Header SubTitle Text
  SendMessage $G_DLGITEM ${WM_SETTEXT} 0 "STR:$(PFI_LANG_UN_INST_SUBTITLE)"

exit:
FunctionEnd

#--------------------------------------------------------------------------
# Uninstaller Function: 'un.Uninstall_Begin' (called by 'un.Uninstall Begin' section)
#
# Used to check ownership before starting the uninstall process
#--------------------------------------------------------------------------

Function un.Uninstall_Begin

  !define L_TEMP        $R9

  Push ${L_TEMP}

  ; Ensure we access the data belonging to the user who started the uninstaller

  Call un.SetGlobalUserVariables

  ReadINIStr ${L_TEMP} "$G_USERDIR\install.ini" "Settings" "Owner"
  StrCmp ${L_TEMP} "" function_exit
  StrCmp ${L_TEMP} $G_WINUSERNAME function_exit

  MessageBox MB_YESNO|MB_ICONSTOP|MB_DEFBUTTON2 \
      "$(PFI_LANG_UN_MBDIFFUSER_1) ('${L_TEMP}') !\
      ${MB_NL}${MB_NL}\
      $(PFI_LANG_UN_MBNOTFOUND_2)" IDYES function_exit
  Abort "$(PFI_LANG_UN_ABORT_1)"

function_exit:
  Pop ${L_TEMP}

  !undef L_TEMP

FunctionEnd

#--------------------------------------------------------------------------
# Uninstaller Function: 'un.Shutdown_POPFile' (called by 'un.Shutdown POPFile' section)
#--------------------------------------------------------------------------

Function un.Shutdown_POPFile

  !define L_CFG         $R9   ; used as file handle
  !define L_LNE         $R8   ; a line from popfile.cfg
  !define L_TEMP        $R7
  !define L_TEXTEND     $R6   ; used to ensure correct handling of lines longer than 1023 chars

  Push ${L_CFG}
  Push ${L_LNE}
  Push ${L_TEMP}
  Push ${L_TEXTEND}

  ; Ensure we access the data belonging to the user who started the uninstaller

  Call un.SetGlobalUserVariables

  ; The program files we are about to remove are in use so we need to shut POPFile down

  IfFileExists "$G_USERDIR\popfile.cfg" 0 manual_shutdown

  ; Use the UI port setting in the configuration file to shutdown POPFile

  StrCpy $G_GUI ""

  FileOpen ${L_CFG} "$G_USERDIR\popfile.cfg" r

found_eol:
  StrCpy ${L_TEXTEND} "<eol>"

loop:
  FileRead ${L_CFG} ${L_LNE}
  StrCmp ${L_LNE} "" ui_port_done
  StrCmp ${L_TEXTEND} "<eol>" 0 check_eol
  StrCmp ${L_LNE} "$\n" loop

  StrCpy ${L_TEMP} ${L_LNE} 10
  StrCmp ${L_TEMP} "html_port " 0 check_eol
  StrCpy $G_GUI ${L_LNE} 5 10

  ; Now read file until we get to end of the current line
  ; (i.e. until we find text ending in <CR><LF>, <CR> or <LF>)

check_eol:
  StrCpy ${L_TEXTEND} ${L_LNE} 1 -1
  StrCmp ${L_TEXTEND} "$\n" found_eol
  StrCmp ${L_TEXTEND} "$\r" found_eol loop

ui_port_done:
  FileClose ${L_CFG}

  StrCmp $G_GUI "" manual_shutdown
  Push $G_GUI
  Call un.PFI_TrimNewlines
  Call un.PFI_StrCheckDecimal
  Pop $G_GUI
  StrCmp $G_GUI "" manual_shutdown
  DetailPrint "$(PFI_LANG_UN_LOG_SHUTDOWN) $G_GUI"
  DetailPrint "$(PFI_LANG_TAKE_A_FEW_SECONDS)"
  Push $G_GUI
  Call un.PFI_ShutdownViaUI
  Pop ${L_TEMP}
  StrCmp ${L_TEMP} "success" function_exit

manual_shutdown:
  Call un.RequestManualShutdown

  ; Assume user has managed to shutdown POPFile

function_exit:
  Pop ${L_TEXTEND}
  Pop ${L_TEMP}
  Pop ${L_LNE}
  Pop ${L_CFG}

  !undef L_CFG
  !undef L_LNE
  !undef L_TEMP
  !undef L_TEXTEND

FunctionEnd

#--------------------------------------------------------------------------
# Uninstaller Function: 'un.RequestManualShutdown'
#--------------------------------------------------------------------------

Function un.RequestManualShutdown

  StrCpy $G_PLS_FIELD_1 "POPFile"
  DetailPrint "Unable to shutdown $G_PLS_FIELD_1 automatically - manual intervention requested"
  MessageBox MB_OK|MB_ICONEXCLAMATION|MB_TOPMOST "$(PFI_LANG_MBMANSHUT_1)\
      ${MB_NL}${MB_NL}\
      $(PFI_LANG_MBMANSHUT_2)\
      ${MB_NL}${MB_NL}\
      $(PFI_LANG_MBMANSHUT_3)"

FunctionEnd

#--------------------------------------------------------------------------
# Uninstaller Function: un.ChooseParser
#
# Unlike English and many other languages, Japanese text does not use spaces to separate
# the words so POPFile has to use a parser in order to analyse the words in a Japanese
# message. The 1.0.0 release of POPFile is the first to offer a choice of parser (previous
# releases of POPFile always used the "Kakasi" parser).
#
# Three parsers are currently supported: Internal, Kakasi and MeCab. The installer contains
# all of the files needed for the first two but the MeCab parser uses a large dictionary
# (a 12 MB download) which will be downloaded during installation if MeCab is selected.
#--------------------------------------------------------------------------

  !insertmacro FUNCTION_CHOOSEPARSER "un."

#--------------------------------------------------------------------------
# Uninstaller Function: un.HandleParserSelection
# (the "leave" function for the Nihongo Parser selection page)
#
# Used to handle user input on the Nihongo Parser selection page.
#--------------------------------------------------------------------------

  !insertmacro FUNCTION_HANDLE_PARSER_SELECTION "un."

#--------------------------------------------------------------------------
# End of 'installer-Uninstall.nsh'
#--------------------------------------------------------------------------
