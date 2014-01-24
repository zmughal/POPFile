#--------------------------------------------------------------------------
#
# installer-SecPOPFile-body.nsh --- This 'include' file contains the body of the "POPFile"
#                                   Section of the main 'installer.nsi' NSIS script used to
#                                   create the Windows installer for POPFile.
#
#                                   The non-library functions used in this file are contained
#                                   in a separate file (see 'installer-SecPOPFile-func.nsh')
#
# Copyright (c) 2005-2009 John Graham-Cumming
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
# Processing performed:
#
# (a) If upgrading, shutdown existing version and rearrange minimal Perl files
# (b) Create registry entries (HKLM and/or HKCU) for POPFile program files
# (c) Install POPFile core program files and release notes
# (d) Write the uninstaller program and create/update the Start Menu shortcuts
# (e) Create 'Add/Remove Program' entry
#--------------------------------------------------------------------------

; Section "POPFile" SecPOPFile

  !insertmacro SECTIONLOG_ENTER "POPFile"

  ; Make this section mandatory (i.e. it is always installed)

  SectionIn RO

  !define L_RESULT        $R9
  !define L_TEMP          $R8

  Push ${L_RESULT}
  Push ${L_TEMP}

  SetDetailsPrint textonly
  DetailPrint "$(PFI_LANG_INST_PROG_UPGRADE) $(PFI_LANG_TAKE_A_FEW_SECONDS)"
  SetDetailsPrint listonly

  ; Before POPFile 0.21.0, POPFile and the minimal Perl shared the same folder structure
  ; and there was only one set of user data (stored in the same folder as POPFile).

  ; Phase 1 of the multi-user support introduced in 0.21.0 required some slight changes
  ; to the folder structure (to permit POPFile to be run from any folder after setting the
  ; POPFILE_ROOT and POPFILE_USER environment variables to appropriate values).

  ; The folder arrangement used for this build:
  ;
  ; (a) $INSTDIR         -  main POPFile installation folder, holds popfile.pl and several
  ;                         other *.pl scripts, runpopfile.exe, popfile*.exe plus three of the
  ;                         minimal Perl files (perl.exe, wperl.exe and perl58.dll)
  ;
  ; (b) $INSTDIR\kakasi  -  holds the Kakasi package used to process Japanese email
  ;                         (only installed when Japanese support is required and the Kakasi
  ;                         parser has been selected)
  ;
  ; (c) $INSTDIR\mecab   -  holds the MeCab package used to process Japanese email
  ;                         (only installed when Japanese support is required and the MeCab
  ;                         parser has been selected)
  ;
  ; (d) $INSTDIR\lib     -  minimal Perl installation (except for the three files stored
  ;                         in the $INSTDIR folder to avoid runtime problems)
  ;
  ; (e) $INSTDIR\*       -  the remaining POPFile folders (Classifier, languages, skins, etc)
  ;
  ; For this build, each user is expected to have separate user data folders. By default each
  ; user data folder will contain popfile.cfg, stopwords, stopwords.default, popfile.db,
  ; the messages folder, etc. The 'Add POPFile User' wizard (adduser.exe) is responsible for
  ; creating/updating these user data folders and for handling conversion of existing flat file
  ; or BerkeleyDB corpus files to the new SQL database format.
  ;
  ; For increased flexibility, some global user variables are used in addition to $INSTDIR
  ; (this makes it easier to change the folder structure used by the installer).

  ; $G_ROOTDIR is initialised by 'CheckExistingProgDir' (the DIRECTORY page's "leave" function)

  StrCpy $G_MPLIBDIR  "$G_ROOTDIR\lib"

  IfFileExists "$G_ROOTDIR\*.*" rootdir_exists
  ClearErrors
  CreateDirectory "$G_ROOTDIR"
  IfErrors 0 rootdir_exists
  SetDetailsPrint both
  DetailPrint "Fatal error: unable to create folder for the POPFile program files"
  SetDetailsPrint listonly
  MessageBox MB_OK|MB_ICONSTOP|MB_TOPMOST "Error: Unable to create folder for the POPFile program files\
      ${MB_NL}${MB_NL}\
      ($G_ROOTDIR)"
  Abort

rootdir_exists:

  ; Starting with POPFile 0.22.0 the system tray icon uses 'localhost' instead of '127.0.0.1'
  ; to display the User Interface (and the installer has been updated to follow suit), so we
  ; need to ensure Win9x systems have a suitable 'hosts' file

  Call PFI_IsNT
  Pop ${L_RESULT}
  StrCmp ${L_RESULT} "1" continue
  Call CheckHostsFile

continue:

  ; Use HKLM as a simple workaround for the case where installer is started by a non-admin user
  ; (the MakeRootDirSafe function will use this HKLM data to re-initialise $G_ROOTDIR)

  WriteRegStr HKLM "Software\POPFile Project\${C_PFI_PRODUCT}\MRI" "UAC_RootDir" "$G_ROOTDIR"

  ; If we are installing over a previous version, ensure that version is not running

  DetailPrint "Use UAC plugin to call 'MakeRootDirSafe' function"

  GetFunctionAddress ${L_TEMP} MakeRootDirSafe
  UAC::ExecCodeSegment ${L_TEMP}

  ; Starting with 0.21.0, a new structure is used for the minimal Perl (to enable POPFile to
  ; be started from any folder, once POPFILE_ROOT and POPFILE_USER have been initialized)

  Call MinPerlRestructure

  ; Now that the HTML for the UI is no longer embedded in the Perl code, a new skin system is
  ; used so we attempt to convert the existing skins to work with the new system

  Call SkinsRestructure

  WriteRegStr HKLM "Software\POPFile Project\${C_PFI_PRODUCT}\MRI" "Installer Language" "$LANGUAGE"
  WriteRegStr HKLM "Software\POPFile Project\${C_PFI_PRODUCT}\MRI" "POPFile Major Version" "${C_POPFILE_MAJOR_VERSION}"
  WriteRegStr HKLM "Software\POPFile Project\${C_PFI_PRODUCT}\MRI" "POPFile Minor Version" "${C_POPFILE_MINOR_VERSION}"
  WriteRegStr HKLM "Software\POPFile Project\${C_PFI_PRODUCT}\MRI" "POPFile Revision" "${C_POPFILE_REVISION}"
  WriteRegStr HKLM "Software\POPFile Project\${C_PFI_PRODUCT}\MRI" "POPFile RevStatus" "${C_POPFILE_RC}"
  WriteRegStr HKLM "Software\POPFile Project\${C_PFI_PRODUCT}\MRI" "InstallPath" "$G_ROOTDIR"
  WriteRegStr HKLM "Software\POPFile Project\${C_PFI_PRODUCT}\MRI" "Author" "setup.exe"
  WriteRegStr HKLM "Software\POPFile Project\${C_PFI_PRODUCT}\MRI" "RootDir_LFN" "$G_ROOTDIR"
  StrCmp $G_SFN_DISABLED "0" find_HKLM_root_sfn
  StrCpy ${L_TEMP} "Not supported"
  Goto save_HKLM_root_sfn

find_HKLM_root_sfn:
  GetFullPathName /SHORT ${L_TEMP} "$G_ROOTDIR"

save_HKLM_root_sfn:
  WriteRegStr HKLM "Software\POPFile Project\${C_PFI_PRODUCT}\MRI" "RootDir_SFN" "${L_TEMP}"

  ; Install the POPFile Core files

  SetDetailsPrint textonly
  DetailPrint "$(PFI_LANG_INST_PROG_CORE)"
  SetDetailsPrint listonly

  SetOutPath "$G_ROOTDIR"

  ; Remove redundant files (from earlier test versions of the installer)

  Delete "$G_ROOTDIR\wrapper.exe"
  Delete "$G_ROOTDIR\wrapperf.exe"
  Delete "$G_ROOTDIR\wrapperb.exe"

  ; Install POPFile 'core' files

  File "..\engine\license"

  ; Some releases may have a Japanese translation of the release notes.

  File "${C_RELEASE_NOTES}"
  StrCmp $LANGUAGE ${LANG_JAPANESE} 0 copy_txt_version
  File /nonfatal "/oname=$G_ROOTDIR\${C_README}" "${C_JAPANESE_RELEASE_NOTES}"

copy_txt_version:
  SetFileAttributes "$G_ROOTDIR\${C_README}" READONLY
  CopyFiles /SILENT /FILESONLY "$PLUGINSDIR\${C_README}.txt" "$G_ROOTDIR\${C_README}.txt"

  ; The experimental 'setup-repack587.exe' installer installed some NSIS-based replacements
  ; for the non-service EXE files plus renamed versions of the old 0.22.2 EXE files. These
  ; old ActivePerl 5.8.4 files can now be deleted as this installer contains versions based
  ; upon a more recent version of ActivePerl (e.g. 0.22.5 is based upon 5.8.8 Build 820).

  Delete "$G_ROOTDIR\popfile-584.exe"
  Delete "$G_ROOTDIR\popfilef-584.exe"
  Delete "$G_ROOTDIR\popfileb-584.exe"
  Delete "$G_ROOTDIR\popfileif-584.exe"
  Delete "$G_ROOTDIR\popfileib-584.exe"
  Delete "$G_ROOTDIR\popfile-service-584.exe"

  ; The experimental 'setup-repack587.exe' installer had to use 'perlmsgcap.exe' since the
  ; NSIS-based replacements were not compatible with the standard "Message Capture" utility

  Delete "$G_ROOTDIR\perlmsgcap.exe"

  ; Install the POPFile EXE files

  File "..\engine\popfile.exe"
  File "..\engine\popfilef.exe"
  File "..\engine\popfileb.exe"
  File "..\engine\popfileif.exe"
  File "..\engine\popfileib.exe"
  File "..\engine\popfile-service.exe"

  File /nonfatal "/oname=pfi-stopwords.default" "..\engine\stopwords"

  File "runpopfile.exe"
  File "stop_pf.exe"
  File "sqlite.exe"
  File "sqlite3.exe"
  File "runsqlite.exe"
  File "adduser.exe"
  File /nonfatal "test\pfidbstatus.exe"
  File /nonfatal "test\pfidiag.exe"
  File "msgcapture.exe"

  IfFileExists "$G_ROOTDIR\pfimsgcapture.exe" 0 app_paths
  Delete "$G_ROOTDIR\pfimsgcapture.exe"
  File "/oname=pfimsgcapture.exe" "msgcapture.exe"

app_paths:

  ; Add 'stop_pf.exe' to 'App Paths' to allow it to be run using Start -> Run -> stop_pf params

  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\App Paths\stop_pf.exe" \
      "" "$G_ROOTDIR\stop_pf.exe"

  SetOutPath "$G_ROOTDIR"

  File "..\engine\popfile.pl"
  File "..\engine\popfile.pck"
  File "..\engine\insert.pl"
  File "..\engine\bayes.pl"
  File "..\engine\pipe.pl"

  File "..\engine\favicon.ico"
  File "..\engine\trayicon.ico"
  File "..\engine\trayicon_up.ico"

  File "..\engine\pix.gif"
  File "..\engine\otto.png"

  SetOutPath "$G_ROOTDIR\Classifier"
  File "..\engine\Classifier\Bayes.pm"
  File "..\engine\Classifier\WordMangle.pm"
  File "..\engine\Classifier\MailParse.pm"
  IfFileExists "$G_ROOTDIR\Classifier\popfile.sql" update_the_schema

no_previous_version:
  WriteINIStr "$G_ROOTDIR\pfi-data.ini" "Settings" "Owner" "$G_WINUSERNAME"
  DeleteINIStr "$G_ROOTDIR\pfi-data.ini" "Settings" "OldSchema"
  Goto install_schema

update_the_schema:
  Push "$G_ROOTDIR\Classifier\popfile.sql"
  Call PFI_GetPOPFileSchemaVersion
  Pop ${L_RESULT}
  StrCmp ${L_RESULT} "()" assume_early_schema
  StrCpy ${L_TEMP} ${L_RESULT} 1
  StrCmp ${L_TEMP} "(" no_previous_version remember_version

assume_early_schema:
  StrCpy ${L_RESULT} "0"

remember_version:
  WriteINIStr "$G_ROOTDIR\pfi-data.ini" "Settings" "Owner" "$G_WINUSERNAME"
  WriteINIStr "$G_ROOTDIR\pfi-data.ini" "Settings" "OldSchema" "${L_RESULT}"

install_schema:
  File "..\engine\Classifier\popfile.sql"

  SetOutPath "$G_ROOTDIR\Platform"
  File "..\engine\Platform\MSWin32.pm"
  Delete "$G_ROOTDIR\Platform\POPFileIcon.dll"

  SetOutPath "$G_ROOTDIR\POPFile"
  File "..\engine\POPFile\MQ.pm"
  File "..\engine\POPFile\History.pm"
  File "..\engine\POPFile\Loader.pm"
  File "..\engine\POPFile\Logger.pm"
  File "..\engine\POPFile\Module.pm"
  File "..\engine\POPFile\Mutex.pm"
  File "..\engine\POPFile\Configuration.pm"
  File "..\engine\POPFile\popfile_version"

  SetOutPath "$G_ROOTDIR\Proxy"
  File "..\engine\Proxy\Proxy.pm"
  File "..\engine\Proxy\POP3.pm"

  SetOutPath "$G_ROOTDIR\UI"
  File "..\engine\UI\HTML.pm"
  File "..\engine\UI\HTTP.pm"

  ;-----------------------------------------------------------------------

  ; Default UI language

  SetOutPath "$G_ROOTDIR\languages"
  File "..\engine\languages\English.msg"

  ;-----------------------------------------------------------------------

  ; Default UI skin (the POPFile UI looks better if a skin is used)
  ; Note: Although there is a skin called "default" POPFile 1.0.0 defaults to "simplyblue"

  SetOutPath "$G_ROOTDIR\skins\default"
  File "..\engine\skins\default\*.*"
  SetOutPath "$G_ROOTDIR\skins\simplyblue"
  File "..\engine\skins\simplyblue\*.*"

  ;-----------------------------------------------------------------------

  ; Create the uninstall program BEFORE creating the shortcut to it
  ; (this ensures that the correct "uninstall" icon appears in the START MENU shortcut)

  SetOutPath "$G_ROOTDIR"
  Delete "$G_ROOTDIR\uninstall.exe"
  WriteUninstaller "$G_ROOTDIR\uninstall.exe"

  ; Attempt to remove some StartUp and Start Menu shortcuts created by previous installations

  !macro OBSOLETE_START_MENU_ENTRIES

      Delete "$SMSTARTUP\Run POPFile.lnk"
      Delete "$SMSTARTUP\Run POPFile in background.lnk"

      Delete "$SMPROGRAMS\${C_PFI_PRODUCT}\Manual.url"
      Delete "$SMPROGRAMS\${C_PFI_PRODUCT}\POPFile User Interface.url"
      Delete "$SMPROGRAMS\${C_PFI_PRODUCT}\QuickStart Guide.url"
      Delete "$SMPROGRAMS\${C_PFI_PRODUCT}\Run POPFile in background.lnk"
      Delete "$SMPROGRAMS\${C_PFI_PRODUCT}\Shutdown POPFile.url"
      Delete "$SMPROGRAMS\${C_PFI_PRODUCT}\Shutdown POPFile silently.lnk"
      Delete "$SMPROGRAMS\${C_PFI_PRODUCT}\Uninstall POPFile.lnk"

      Delete "$SMPROGRAMS\${C_PFI_PRODUCT}\Support\POPFile Manual.url"

  !macroend

  SetShellVarContext all
  !insertmacro OBSOLETE_START_MENU_ENTRIES

  SetShellVarContext current
  !insertmacro OBSOLETE_START_MENU_ENTRIES

  ; Create the START MENU entries

  SetDetailsPrint textonly
  DetailPrint "$(PFI_LANG_INST_PROG_SHORT)"
  SetDetailsPrint listonly

  ; 'CreateShortCut' uses '$OUTDIR' as the working directory for the shortcut
  ; ('SetOutPath' is one way to change the value of $OUTDIR)

  ; 'CreateShortCut' fails to update existing shortcuts if they are read-only, so try to clear
  ; the read-only attribute first. Similar handling is required for the Internet shortcuts.

  ; Create a 'POPFile' folder with a set of shortcuts in the 'All Users' Start Menu.
  ; If the 'All Users' folder is not found, NSIS will return the 'Current User' folder.

  SetShellVarContext all
  SetOutPath "$SMPROGRAMS\${C_PFI_PRODUCT}"
  SetOutPath "$G_ROOTDIR"

  SetFileAttributes "$SMPROGRAMS\${C_PFI_PRODUCT}\Run POPFile.lnk" NORMAL
  CreateShortCut "$SMPROGRAMS\${C_PFI_PRODUCT}\Run POPFile.lnk" \
                 "$G_ROOTDIR\runpopfile.exe"

  SetFileAttributes "$SMPROGRAMS\${C_PFI_PRODUCT}\Modify POPFile.lnk" NORMAL
  CreateShortCut "$SMPROGRAMS\${C_PFI_PRODUCT}\Modify POPFile.lnk" \
                 "$G_ROOTDIR\uninstall.exe"

  SetOutPath "$G_ROOTDIR"
  SetFileAttributes "$SMPROGRAMS\${C_PFI_PRODUCT}\Release Notes.lnk" NORMAL
  CreateShortCut "$SMPROGRAMS\${C_PFI_PRODUCT}\Release Notes.lnk" \
                 "$G_ROOTDIR\${C_README}.txt"

  SetOutPath "$SMPROGRAMS\${C_PFI_PRODUCT}"

  SetFileAttributes "$SMPROGRAMS\${C_PFI_PRODUCT}\FAQ.url" NORMAL

  !ifndef ENGLISH_MODE
      StrCmp $LANGUAGE ${LANG_JAPANESE} japanese_faq
  !endif

  WriteINIStr "$SMPROGRAMS\${C_PFI_PRODUCT}\FAQ.url" \
              "InternetShortcut" "URL" \
              "http://getpopfile.org/docs/FAQ"

  !ifndef ENGLISH_MODE
      Goto support

    japanese_faq:
      WriteINIStr "$SMPROGRAMS\${C_PFI_PRODUCT}\FAQ.url" \
                  "InternetShortcut" "URL" \
                  "http://getpopfile.org/docs/JP:FAQ"

    support:
  !endif

  SetOutPath "$SMPROGRAMS\${C_PFI_PRODUCT}\Support"

  SetFileAttributes "$SMPROGRAMS\${C_PFI_PRODUCT}\Support\POPFile Home Page.url" NORMAL
  WriteINIStr "$SMPROGRAMS\${C_PFI_PRODUCT}\Support\POPFile Home Page.url" \
              "InternetShortcut" "URL" "http://getpopfile.org/"

  SetFileAttributes "$SMPROGRAMS\${C_PFI_PRODUCT}\Support\POPFile Support (Wiki).url" NORMAL

  !ifndef ENGLISH_MODE
      StrCmp $LANGUAGE ${LANG_JAPANESE} japanese_wiki
  !endif

  WriteINIStr "$SMPROGRAMS\${C_PFI_PRODUCT}\Support\POPFile Support (Wiki).url" \
              "InternetShortcut" "URL" \
              "http://getpopfile.org/docs"

  !ifndef ENGLISH_MODE
      Goto pfidiagnostic

    japanese_wiki:
  WriteINIStr "$SMPROGRAMS\${C_PFI_PRODUCT}\Support\POPFile Support (Wiki).url" \
                  "InternetShortcut" "URL" \
                  "http://getpopfile.org/docs/jp"

    pfidiagnostic:
  !endif

  IfFileExists "$G_ROOTDIR\pfidiag.exe" 0 add_remove_programs
  Delete "$SMPROGRAMS\${C_PFI_PRODUCT}\PFI Diagnostic utility.lnk"
  SetFileAttributes "$SMPROGRAMS\${C_PFI_PRODUCT}\Support\PFI Diagnostic utility (simple).lnk" NORMAL
  CreateShortCut "$SMPROGRAMS\${C_PFI_PRODUCT}\Support\PFI Diagnostic utility (simple).lnk" \
                 "$G_ROOTDIR\pfidiag.exe"
  SetFileAttributes "$SMPROGRAMS\${C_PFI_PRODUCT}\Support\PFI Diagnostic utility (full).lnk" NORMAL
  CreateShortCut "$SMPROGRAMS\${C_PFI_PRODUCT}\Support\PFI Diagnostic utility (full).lnk" \
                 "$G_ROOTDIR\pfidiag.exe" "/full"

add_remove_programs:
  SetOutPath "$G_ROOTDIR"
  SetShellVarContext current

  ; Create an entry in the Control Panel's "Add/Remove Programs" list. The installer runs with
  ; admin rights so normally HKLM is used but on Vista HKCU is used in order to avoid problems
  ; with UAC (if HKLM is used then Vista elevates the uninstaller _before_ the UAC plugin gets
  ; a chance!)

  ClearErrors
  ReadRegStr ${L_RESULT} HKLM "SOFTWARE\Microsoft\Windows NT\CurrentVersion" CurrentVersion
  IfErrors use_HKLM
  StrCpy ${L_TEMP} ${L_RESULT} 1
  IntCmp ${L_TEMP} 5 use_HKLM use_HKLM
  ReadRegStr ${L_RESULT} HKLM \
      "Software\Microsoft\Windows\CurrentVersion\Uninstall\${C_PFI_PRODUCT}" "UninstallString"
  StrCmp ${L_RESULT} "$G_ROOTDIR\uninstall.exe" delete_HKLM_entry
  StrCmp ${L_RESULT} '"$G_ROOTDIR\uninstall.exe" /UNINSTALL' 0 create_arp_entry

delete_HKLM_entry:
  DeleteRegKey HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${C_PFI_PRODUCT}"
  Goto create_arp_entry

use_HKLM:
  SetShellVarContext all

create_arp_entry:
  WriteRegStr SHCTX "Software\Microsoft\Windows\CurrentVersion\Uninstall\${C_PFI_PRODUCT}" \
              "DisplayName" "${C_PFI_PRODUCT} ${C_PFI_VERSION}"
  WriteRegStr SHCTX "Software\Microsoft\Windows\CurrentVersion\Uninstall\${C_PFI_PRODUCT}" \
              "UninstallString" '"$G_ROOTDIR\uninstall.exe" /UNINSTALL'
  WriteRegStr SHCTX "Software\Microsoft\Windows\CurrentVersion\Uninstall\${C_PFI_PRODUCT}" \
              "InstallLocation" "$G_ROOTDIR"
  WriteRegDWORD SHCTX "Software\Microsoft\Windows\CurrentVersion\Uninstall\${C_PFI_PRODUCT}" \
              "NoModify" "0"
  WriteRegStr SHCTX "Software\Microsoft\Windows\CurrentVersion\Uninstall\${C_PFI_PRODUCT}" \
              "ModifyPath" '"$G_ROOTDIR\uninstall.exe" /MODIFY'
  WriteRegDWORD SHCTX "Software\Microsoft\Windows\CurrentVersion\Uninstall\${C_PFI_PRODUCT}" \
              "NoElevateOnModify" "1"
  WriteRegDWORD SHCTX "Software\Microsoft\Windows\CurrentVersion\Uninstall\${C_PFI_PRODUCT}" \
              "NoRepair" "1"

  SetShellVarContext current

  SetDetailsPrint textonly
  DetailPrint "$(PFI_LANG_INST_PROG_ENDSEC)"
  SetDetailsPrint listonly

  !insertmacro SECTIONLOG_EXIT "POPFile"

  Pop ${L_TEMP}
  Pop ${L_RESULT}

  !undef L_RESULT
  !undef L_TEMP

; SectionEnd

#--------------------------------------------------------------------------
# End of 'installer-SecPOPFile-body.nsh'
#--------------------------------------------------------------------------