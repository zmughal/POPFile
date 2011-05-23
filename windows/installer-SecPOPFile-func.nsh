#--------------------------------------------------------------------------
#
# installer-SecPOPFile-func.nsh --- This 'include' file contains the non-library functions
#                                   used by the 'installer-SecPOPFile-body.nsh' file.
#
# Copyright (c) 2005-2011 John Graham-Cumming
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
#         Section "POPFile" SecPOPFile
#           !include "installer-SecPOPFile-body.nsh"
#         SectionEnd
#
#         ; Functions used only by "installer-SecPOPFile-body.nsh"
#
#         !include "installer-SecPOPFile-func.nsh"
#--------------------------------------------------------------------------

#--------------------------------------------------------------------------
# The following functions are only used by the 'installer-SecPOPFile-body.nsh' file:
#
#     CheckHostsFile
#     MinPerlCleanup
#     SkinsRestructure
#--------------------------------------------------------------------------

#--------------------------------------------------------------------------
# The following functions are used by the 'installer-SecPOPFile-body.nsh' file
# and the 'getssl.nsh' file:
#
#     MakeRootDirSafe
#     un.MakeRootDirSafe
#
# (this is a macro-based function, to ensure that the installer and uninstaller
# use identical functions)
#--------------------------------------------------------------------------

#--------------------------------------------------------------------------
# Installer Function: CheckHostsFile
#
# Starting with the 0.22.0 release the system tray icon uses 'http://localhost:port' to open
# the User Interface (earlier versions used 'http://127.0.0.1:port' instead). The installer has
# been updated to follow suit. Some Windows 9x systems may not have a HOSTS file which defines
# 'localhost' so we ensure a suitable one exists
#--------------------------------------------------------------------------

Function CheckHostsFile

  !define L_CFG         $R9
  !define L_LINE        $R8
  !define L_LOCALHOST   $R7
  !define L_TEMP        $R6

  Push ${L_CFG}
  Push ${L_LINE}
  Push ${L_LOCALHOST}
  Push ${L_TEMP}

  IfFileExists "$WINDIR\HOSTS" look_for_localhost
  FileOpen ${L_CFG} "$WINDIR\HOSTS" w
  FileWrite ${L_CFG} "# Created by the installer for ${C_PFI_PRODUCT} ${C_PFI_VERSION}${MB_NL}"
  FileWrite ${L_CFG} "${MB_NL}"
  FileWrite ${L_CFG} "127.0.0.1       localhost${MB_NL}"
  FileClose ${L_CFG}
  Goto exit

look_for_localhost:
  StrCpy ${L_LOCALHOST} ""
  FileOpen ${L_CFG} "$WINDIR\HOSTS" r

loop:
  FileRead ${L_CFG} ${L_LINE}
  StrCmp ${L_LINE} "" done
  StrCpy ${L_TEMP} ${L_LINE} 10
  StrCmp ${L_TEMP} "127.0.0.1 " 0 loop
  Push ${L_LINE}
  Call NSIS_TrimNewlines
  Push " localhost"
  Call PFI_StrStr
  Pop ${L_TEMP}
  StrCmp ${L_TEMP} "" loop
  StrCmp ${L_TEMP} " localhost" found
  StrCpy ${L_TEMP} ${L_TEMP} 11
  StrCmp ${L_TEMP} " localhost " found
  Goto loop

found:
  StrCpy ${L_LOCALHOST} "1"

done:
  FileClose ${L_CFG}
  StrCmp ${L_LOCALHOST} "1" exit
  FileOpen ${L_CFG} "$WINDIR\HOSTS" a
  FileSeek ${L_CFG} 0 END
  FileWrite ${L_CFG} "${MB_NL}"
  FileWrite ${L_CFG} "# Inserted by the installer for ${C_PFI_PRODUCT} ${C_PFI_VERSION}${MB_NL}"
  FileWrite ${L_CFG} "${MB_NL}"
  FileWrite ${L_CFG} "127.0.0.1       localhost${MB_NL}"
  FileClose ${L_CFG}

exit:
  Pop ${L_TEMP}
  Pop ${L_LOCALHOST}
  Pop ${L_LINE}
  Pop ${L_CFG}

  !undef L_CFG
  !undef L_LINE
  !undef L_LOCALHOST
  !undef L_TEMP

FunctionEnd

#--------------------------------------------------------------------------
# Installer Function: MinPerlCleanup
#
# Before POPFile 0.21.0 was released in March 2004, the data files were stored in the
# same folder as the POPFile program files and the minimal Perl files were intermingled
# with the POPFile program files.
#
# POPFile 0.21.0 introduced some multi-user support which means that the location of the
# configuration file is now supplied via an environment variable to allow POPFile to be
# run from any folder. Some rearrangement of the minimal Perl files is required in order
# to avoid Perl runtime errors when POPFile is started from a folder other than the one
# where POPFile is installed.
#
# Newer versions of the minimal Perl may not be binary-compatible with the minimal Perl
# used by previous versions of POPFile so some cleanup work has to be performed.
#
# This function is based upon an analysis of the following POPFile releases:
#   0.17.3, 0.17.4, 0.17.5, 0.17.6, 0.17.7, 0.17.8, 0.17.9a,
#   0.18.0, 0.18.1, 0.18.2, 0.18.3,
#   0.19.0, 0.19.1,
#   0.20.0b and 0.20.1a.
#--------------------------------------------------------------------------

Function MinPerlCleanup

  !define L_RESULT    $R9

  Push ${L_RESULT}

  DetailPrint ""
  DetailPrint "Remove 'intermingled' minimal Perl files used by 0.17.3 to 0.20.1a releases"

  Delete "$G_ROOTDIR\perl56.dll"          ; used by POPFile 0.17.3 to 0.17.9a

  Delete "$G_ROOTDIR\AutoLoader.pm"
  Delete "$G_ROOTDIR\base.pm"
  Delete "$G_ROOTDIR\BerkeleyDB.pm"
  Delete "$G_ROOTDIR\Carp.pm"
  Delete "$G_ROOTDIR\Config.pm"
  Delete "$G_ROOTDIR\DynaLoader.pm"
  Delete "$G_ROOTDIR\Encode.pm"
  Delete "$G_ROOTDIR\Errno.pm"
  Delete "$G_ROOTDIR\Exporter.pm"
  Delete "$G_ROOTDIR\integer.pm"
  Delete "$G_ROOTDIR\IO.pm"
  Delete "$G_ROOTDIR\locale.pm"
  Delete "$G_ROOTDIR\POSIX.pm"
  Delete "$G_ROOTDIR\SelectSaver.pm"
  Delete "$G_ROOTDIR\Socket.pm"
  Delete "$G_ROOTDIR\strict.pm"
  Delete "$G_ROOTDIR\Symbol.pm"
  Delete "$G_ROOTDIR\UNIVERSAL.pm"
  Delete "$G_ROOTDIR\vars.pm"
  Delete "$G_ROOTDIR\warnings.pm"
  Delete "$G_ROOTDIR\XSLoader.pm"

  RMDir /r "$G_ROOTDIR\auto"

  Delete "$G_ROOTDIR\Carp\Heavy.pm"
  RMDir "$G_ROOTDIR\Carp"

  RMDir /r "$G_ROOTDIR\Encode"

  Delete "$G_ROOTDIR\Exporter\Heavy.pm"
  RMDir "$G_ROOTDIR\Exporter"

  Delete "$G_ROOTDIR\File\Glob.pm"
  RMDir "$G_ROOTDIR\File"

  RMDir /r "$G_ROOTDIR\IO"

  RMDir /r "$G_ROOTDIR\kakasi"

  Delete "$G_ROOTDIR\MIME\Base64.pm"
  Delete "$G_ROOTDIR\MIME\QuotedPrint.pm"
  RMDir "$G_ROOTDIR\MIME"

  Delete "$G_ROOTDIR\Sys\Hostname.pm"
  RMDir "$G_ROOTDIR\Sys"

  Delete "$G_ROOTDIR\Text\Kakasi.pm"
  Delete "$G_ROOTDIR\Text\ParseWords.pm"
  RMDir "$G_ROOTDIR\Text"

  Delete "$G_ROOTDIR\warnings\register.pm"
  RMDir "$G_ROOTDIR\warnings"

  Delete "$G_ROOTDIR\Win32\API\Callback.pm"
  Delete "$G_ROOTDIR\Win32\API\Struct.pm"
  Delete "$G_ROOTDIR\Win32\API\Type.pm"
  RMDir "$G_ROOTDIR\Win32\API"

  Delete "$G_ROOTDIR\Win32\API.pm"
  RMDir "$G_ROOTDIR\Win32"

  ; The following paths were included in the original "MinPerlRestructure" function code
  ; which was committed to CVS on 11 February 2004 but after a fresh analysis of the
  ; 0.17.3, 0.17.4, 0.17.5, 0.17.6, 0.17.7, 0.17.8, 0.17.9a, 0.18.0, 0.18.1, 0.18.2,
  ; 0.18.3, 0.19.0, 0.19.1, 0.20.0b and 0.20.1a releases no justification has been found.
  ; Were these paths were added to handle upgrades of installations created by release
  ; candidates or other 'unofficial' installers?

  RMDir /r "$G_ROOTDIR\DBD"
  RMDir /r "$G_ROOTDIR\Digest"
  RMDir /r "$G_ROOTDIR\Getopt"
  RMDir /r "$G_ROOTDIR\String"

  DetailPrint "(completed)"

  ; POPFile 1.1.2 uses a new 'slimline' minimal Perl, unlike previous versions,
  ; so to avoid possible problems the existing minimal Perl 'lib' folder is deleted.

  IfFileExists "$G_ROOTDIR\lib\*.*" 0 exit
  DetailPrint ""
  DetailPrint "Sending old minimal Perl folder ($G_ROOTDIR\lib) to the Recycle Bin..."
  Push "$G_ROOTDIR\lib"
  Call PFI_SendToRecycleBin
  Pop ${L_RESULT}
  StrCmp ${L_RESULT} "0" recycle_ok
  DetailPrint "Failed to send old minimal Perl 'lib' folder to the Recycle Bin (error: ${L_RESULT})"
  Goto exit

recycle_ok:
  DetailPrint "Old minimal Perl folder sent to the Recycle Bin OK"

exit:
  DetailPrint ""
  Pop ${L_RESULT}

  !undef L_RESULT

FunctionEnd

#--------------------------------------------------------------------------
# Installer Function: SkinsRestructure
#
# Now that the HTML for the UI is no longer embedded in the Perl code, some changes need to be
# made to the skins. There is now a new default skin which includes a set of HTML template files
# in addition to a CSS file. Additional skins consist of separate folders containing 'style.css'
# and any image files used by the skin (instead of each skin using a uniquely named CSS file in
# the 'skins' folder, with any necessary image files being stored either in the 'skins' folder
# or in a separate sub-folder).
#
# We attempt to rearrange any existing skins to suit this new structure (the current build only
# moves files, it does not edit the CSS files to update any image references within them).
#
# The new default skin and its associated HTML template files are always installed by the
# mandatory 'POPFile' component (even if the 'skins' component is not installed).
#--------------------------------------------------------------------------

Function SkinsRestructure

  RMDir "$G_ROOTDIR\skins\lavishImages"
  RMDir "$G_ROOTDIR\skins\sleetImages"

  IfFileExists "$G_ROOTDIR\skins\default\*.thtml" exit

  !insertmacro PFI_SkinMove "blue"           "blue"
  !insertmacro PFI_SkinMove "CoolBlue"       "coolblue"
  !insertmacro PFI_SkinMove "CoolBrown"      "coolbrown"
  !insertmacro PFI_SkinMove "CoolGreen"      "coolgreen"
  !insertmacro PFI_SkinMove "CoolOrange"     "coolorange"
  !insertmacro PFI_SkinMove "CoolYellow"     "coolyellow"
  !insertmacro PFI_SkinMove "default"        "default"
  !insertmacro PFI_SkinMove "glassblue"      "glassblue"
  !insertmacro PFI_SkinMove "green"          "green"

  IfFileExists "$G_ROOTDIR\skins\lavishImages\*.*" 0 lavish
  Rename  "$G_ROOTDIR\skins\lavishImages" "$G_ROOTDIR\skins\lavish"

lavish:
  !insertmacro PFI_SkinMove "Lavish"         "lavish"
  !insertmacro PFI_SkinMove "LRCLaptop"      "lrclaptop"
  !insertmacro PFI_SkinMove "orange"         "orange"
  !insertmacro PFI_SkinMove "orangeCream"    "orangecream"
  !insertmacro PFI_SkinMove "outlook"        "outlook"
  !insertmacro PFI_SkinMove "PRJBlueGrey"    "prjbluegrey"
  !insertmacro PFI_SkinMove "PRJSteelBeach"  "prjsteelbeach"
  !insertmacro PFI_SkinMove "SimplyBlue"     "simplyblue"

  IfFileExists "$G_ROOTDIR\skins\sleetImages\*.*" 0 sleet
  Rename  "$G_ROOTDIR\skins\sleetImages" "$G_ROOTDIR\skins\sleet"

sleet:
  !insertmacro PFI_SkinMove "Sleet"          "sleet"
  !insertmacro PFI_SkinMove "Sleet-RTL"      "sleet-rtl"
  !insertmacro PFI_SkinMove "smalldefault"   "smalldefault"
  !insertmacro PFI_SkinMove "smallgrey"      "smallgrey"
  !insertmacro PFI_SkinMove "StrawberryRose" "strawberryrose"
  !insertmacro PFI_SkinMove "tinydefault"    "tinydefault"
  !insertmacro PFI_SkinMove "tinygrey"       "tinygrey"
  !insertmacro PFI_SkinMove "white"          "white"
  !insertmacro PFI_SkinMove "windows"        "windows"

  IfFileExists "$G_ROOTDIR\skins\chipped_obsidian.gif" 0 metalback
  CreateDirectory "$G_ROOTDIR\skins\prjsteelbeach"
  Rename "$G_ROOTDIR\skins\chipped_obsidian.gif" "$G_ROOTDIR\skins\prjsteelbeach\chipped_obsidian.gif"

metalback:
  IfFileExists "$G_ROOTDIR\skins\metalback.gif" 0 check_for_extra_skins
  CreateDirectory "$G_ROOTDIR\skins\prjsteelbeach"
  Rename "$G_ROOTDIR\skins\metalback.gif" "$G_ROOTDIR\skins\prjsteelbeach\metalback.gif"

check_for_extra_skins:

  ; Move any remaining CSS files to an appropriate folder (to make them available for selection)
  ; Only the CSS files are moved, the user will have to adjust any skins which use images

  !define L_CSS_HANDLE    $R9   ; used when searching for non-standard skins
  !define L_SKIN_NAME     $R8   ; name of a non-standard skin (i.e. not supplied with POPFile)

  Push ${L_CSS_HANDLE}
  Push ${L_SKIN_NAME}

  FindFirst ${L_CSS_HANDLE} ${L_SKIN_NAME} "$G_ROOTDIR\skins\*.css"
  StrCmp ${L_CSS_HANDLE} "" all_done_now

process_skin:
  StrCmp ${L_SKIN_NAME} "." look_again
  StrCmp ${L_SKIN_NAME} ".." look_again
  IfFileExists "$G_ROOTDIR\skins\${L_SKIN_NAME}\*.*" look_again
  StrCpy ${L_SKIN_NAME} ${L_SKIN_NAME} -4
  CreateDirectory "$G_ROOTDIR\skins\${L_SKIN_NAME}"
  Rename "$G_ROOTDIR\skins\${L_SKIN_NAME}.css" "$G_ROOTDIR\skins\${L_SKIN_NAME}\style.css"

look_again:
  FindNext ${L_CSS_HANDLE} ${L_SKIN_NAME}
  StrCmp ${L_SKIN_NAME} "" all_done_now process_skin

all_done_now:
  FindClose ${L_CSS_HANDLE}

  Pop ${L_SKIN_NAME}
  Pop ${L_CSS_HANDLE}

  !undef L_CSS_HANDLE
  !undef L_SKIN_NAME

exit:
FunctionEnd

#--------------------------------------------------------------------------
# Macro: Make_RootDir_Safe
#
# If we are installing on top of a previous installation or modifying an existing
# installation, we try to shut it down (to allow the files to be overwritten without
# requiring a reboot)
#
# We also need to check if any of the PFI utilities shipped with POPFile are running
# (to avoid Abort/Retry/Ignore messages or the need to reboot in order to update them)
#
# This macro makes maintenance easier by ensuring that both processes use identical
# functions, with the only difference being their names.
#--------------------------------------------------------------------------

!macro MAKE_ROOTDIR_SAFE UN
  Function ${UN}MakeRootDirSafe

    ; Use HKLM as a simple workaround for the case where installer is started by a non-admin user

    Push $G_ROOTDIR

    ReadRegStr $G_ROOTDIR HKLM "Software\POPFile Project\${C_PFI_PRODUCT}\MRI" "UAC_RootDir"
    StrCmp $G_ROOTDIR "" 0 check_folder_exists
    MessageBox MB_OK|MB_ICONEXCLAMATION "Internal Error: UAC_RootDir not defined\
        ${MB_NL}${MB_NL}\
        Click OK to continue"
    ReadRegStr $G_ROOTDIR HKLM "Software\POPFile Project\${C_PFI_PRODUCT}\MRI" "UAC_RootDir"
    StrCmp $G_ROOTDIR "" try_other_entries
    MessageBox MB_OK|MB_ICONINFORMATION "Good News: UAC_RootDir now defined ($G_ROOTDIR)"
    Goto check_folder_exists

  try_other_entries:    ; ???
    ReadRegStr $G_ROOTDIR HKCU "Software\POPFile Project\${C_PFI_PRODUCT}\MRI" "RootDir_LFN"
    StrCmp $G_ROOTDIR "" 0 check_folder_exists
    ReadRegStr $G_ROOTDIR HKLM "Software\POPFile Project\${C_PFI_PRODUCT}\MRI" "InstallPath"

  check_folder_exists:
    DeleteRegValue HKLM "Software\POPFile Project\${C_PFI_PRODUCT}\MRI" "UAC_RootDir"

    ; If we are upgrading an existing installation we need to ensure it is not running

    IfFileExists "$G_ROOTDIR\*.exe" 0 nothing_to_check

    !define L_CFG      $R9    ; folder where the configuration file (popfile.cfg) may be found
    !define L_EXE      $R8    ; name of EXE file to be monitored
    !define L_GUI      $R7    ; port number used for the UI
    !define L_RESULT   $R6

    Push ${L_CFG}
    Push ${L_EXE}
    Push ${L_GUI}
    Push ${L_RESULT}

    ; Starting with POPFile 0.21.0 an experimental version of 'popfile-service.exe' was included
    ; to allow POPFile to be run as a Windows service.

    Push "POPFile"
    Call ${UN}PFI_ServiceActive
    Pop ${L_RESULT}
    StrCmp ${L_RESULT} "true" manual_shutdown

    ; If we are about to overwrite an existing version which is still running,
    ; then one of the EXE files will be 'locked' which means we have to shutdown POPFile.
    ;
    ; POPFile v0.20.0 and later may be using 'popfileb.exe', 'popfilef.exe', 'popfileib.exe',
    ; 'popfileif.exe', 'perl.exe' or 'wperl.exe'.
    ;
    ; Earlier versions of POPFile use only 'perl.exe' or 'wperl.exe'.

    Push $G_ROOTDIR
    Call ${UN}PFI_FindLockedPFE
    Pop ${L_EXE}
    StrCmp ${L_EXE} "" check_pfi_utils

    ; The program files we are about to update are in use so we need to shut POPFile down

    DetailPrint "'${L_EXE}' appears to be locked."

    ; Attempt to discover which POPFile UI port is used by the current user, so we can issue
    ; a shutdown request. The following cases are considered:
    ;
    ; (a) upgrading a 0.21.0 or later installation and runpopfile.exe was used to start POPFile,
    ;     so POPFile is using environment variables which match the HKCU RootDir_SFN and
    ;     UserDir_SFN registry data (or HKCU RootDir_LFN and UserDir_LFN if short file names are
    ;     not supported)
    ;
    ; (b) upgrading a pre-0.21.0 installation, so popfile.cfg is in the $G_ROOTDIR folder. Need to
    ;     look for old-style and new-style UI port specifications just like the old installer did.

    ReadRegStr ${L_CFG} HKCU "Software\POPFile Project\${C_PFI_PRODUCT}\MRI" "UserDir_LFN"
    StrCmp ${L_CFG} "" try_root_dir
    IfFileExists "${L_CFG}\popfile.cfg" check_cfg_file

  try_root_dir:
    IfFileExists "$G_ROOTDIR\popfile.cfg" 0 manual_shutdown
    StrCpy ${L_CFG} "$G_ROOTDIR"

  check_cfg_file:
    Push "${L_CFG}\popfile.cfg"
    Push "html_port"
    Call ${UN}PFI_CfgSettingRead
    Pop ${L_GUI}

    StrCmp ${L_GUI} "" try_old_style
    DetailPrint "$(PFI_LANG_INST_LOG_SHUTDOWN) ${L_GUI} [new style port]"
    DetailPrint "$(PFI_LANG_TAKE_A_FEW_SECONDS)"
    Push ${L_GUI}
    Call ${UN}PFI_ShutdownViaUI
    Pop ${L_RESULT}
    DetailPrint "PFI_ShutdownViaUI result: ${L_RESULT}"
    StrCmp ${L_RESULT} "success" check_exe
    StrCmp ${L_RESULT} "password?" manual_shutdown

  try_old_style:
    Push "${L_CFG}\popfile.cfg"
    Push "ui_port"
    Call ${UN}PFI_CfgSettingRead
    Pop ${L_GUI}

    StrCmp ${L_GUI} "" manual_shutdown
    DetailPrint "$(PFI_LANG_INST_LOG_SHUTDOWN) ${L_GUI} [old style port]"
    DetailPrint "$(PFI_LANG_TAKE_A_FEW_SECONDS)"
    Push ${L_GUI}
    Call ${UN}PFI_ShutdownViaUI
    Pop ${L_RESULT}
    DetailPrint "PFI_ShutdownViaUI result: ${L_RESULT}"
    StrCmp ${L_RESULT} "success" check_exe
    Goto manual_shutdown

  check_exe:
    DetailPrint "Waiting for '${L_EXE}' to unlock after the shutdown request..."
    DetailPrint "Please be patient, this may take more than 30 seconds"
    Push ${L_EXE}
    Call ${UN}PFI_WaitUntilUnlocked
    DetailPrint "Checking if '${L_EXE}' is still locked after the shutdown request..."
    Push "${C_EXE_END_MARKER}"
    Push ${L_EXE}
    Call ${UN}PFI_CheckIfLocked
    Pop ${L_EXE}
    StrCmp ${L_EXE} "" unlocked_now

  manual_shutdown:
    StrCpy $G_PLS_FIELD_1 "POPFile"
    DetailPrint "Unable to shutdown $G_PLS_FIELD_1 automatically - manual intervention requested"
    MessageBox MB_OK|MB_ICONEXCLAMATION|MB_TOPMOST "$(PFI_LANG_MBMANSHUT_1)\
        ${MB_NL}${MB_NL}\
        $(PFI_LANG_MBMANSHUT_2)\
        ${MB_NL}${MB_NL}\
        $(PFI_LANG_MBMANSHUT_3)"
    Goto check_pfi_utils

  unlocked_now:
    DetailPrint "File is now unlocked"

  check_pfi_utils:
    Push $G_ROOTDIR
    Call ${UN}PFI_RequestPFIUtilsShutdown

    Pop ${L_RESULT}
    Pop ${L_GUI}
    Pop ${L_EXE}
    Pop ${L_CFG}

    !undef L_CFG
    !undef L_EXE
    !undef L_GUI
    !undef L_RESULT

  nothing_to_check:
    Pop $G_ROOTDIR
  FunctionEnd
!macroend

  !insertmacro MAKE_ROOTDIR_SAFE ""

;;;  !insertmacro MAKE_ROOTDIR_SAFE "un."

#--------------------------------------------------------------------------
# End of 'installer-SecPOPFile-func.nsh'
#--------------------------------------------------------------------------
