#--------------------------------------------------------------------------
#
# installer.nsi --- This is the NSIS script used to create the
#                   Windows installer for POPFile. This script uses
#                   three custom pages whose layouts are defined
#                   in the files "ioA.ini", "ioB.ini" and "ioC.ini".
#
# Copyright (c) 2001-2003 John Graham-Cumming
#
#--------------------------------------------------------------------------

; Modified to work with NSIS 2.0b4 (CVS) or later

; WARNING:
;    This script requires "NSIS Modern User Interface" version 1.65 (17 June 2003 or later)
;    because it uses the new (simplified) page configuration system.

#--------------------------------------------------------------------------

  !define MUI_PRODUCT   "POPFile"
  !define MUI_VERSION   "0.20.0 (CVS)"
  !define README        "v0.19.0.change"
  !define RELEASE_NOTES "..\engine\${README}"

  !include "MUI.nsh"

#--------------------------------------------------------------------------
# Version Information settings (for the installer EXE and uninstaller EXE)
#--------------------------------------------------------------------------

  ; 'VIProductVersion' format is X.X.X.X where X is a number in range 0 to 65535
  ; representing the following values: Major.Minor.Release.Build

  VIProductVersion "0.19.0.0"
  
  VIAddVersionKey "ProductName" "POPFile"
  VIAddVersionKey "Comments" "POPFile Homepage: http:// popfile.sourceforge.net"
  VIAddVersionKey "CompanyName" "POPFile Team"
#  VIAddVersionKey "LegalTrademarks" "POPFile"
  VIAddVersionKey "LegalCopyright" "� 2001-2003  John Graham-Cumming"
  VIAddVersionKey "FileDescription" "POPFile Automatic email classification"
  VIAddVersionKey "FileVersion" "${MUI_VERSION}"
  
  VIAddVersionKey "Build Type" "CVS Build (Experimental)"
  VIAddVersionKey "Build Date" "${__DATE__} @ ${__TIME__}"

#----------------------------------------------------------------------------------------
# CBP Configuration Data (to override defaults, un-comment the lines below and modify them)
#----------------------------------------------------------------------------------------
#   ; Maximum number of buckets handled (in range 2 to 8)
#
#   !define CBP_MAX_BUCKETS 8
#
#   ; Default bucket selection (use "" if no buckets are to be pre-selected)
#
#   !define CBP_DEFAULT_LIST "inbox|spam|personal|work"
#
#   ; List of suggestions for bucket names (use "" if no suggestions are required)
#
#   !define CBP_SUGGESTION_LIST \
#   "admin|business|computers|family|financial|general|hobby|inbox|junk|list-admin|\
#   miscellaneous|not_spam|other|personal|recreation|school|security|shopping|spam|\
#   travel|work"
#----------------------------------------------------------------------------------------
# Make the CBP package available
#----------------------------------------------------------------------------------------

  !include CBP.nsh

#--------------------------------------------------------------------------
# Define the Page order for the installer (and the uninstaller)
#--------------------------------------------------------------------------

  ; Installer Pages

  !insertmacro MUI_PAGE_WELCOME
  !insertmacro MUI_PAGE_LICENSE
  !insertmacro MUI_PAGE_COMPONENTS
  !insertmacro MUI_PAGE_DIRECTORY
  Page custom SetOptionsPage "CheckPortOptions"
  !insertmacro MUI_PAGE_INSTFILES
  !insertmacro CBP_PAGE_SELECTBUCKETS
  Page custom SetOutlookOrOutlookExpressPage
  Page custom StartPOPFilePage "CheckLaunchOptions"
  !insertmacro MUI_PAGE_FINISH

  ; Uninstaller Pages

  !insertmacro MUI_UNPAGE_CONFIRM
  !insertmacro MUI_UNPAGE_INSTFILES

#--------------------------------------------------------------------------
# Configure the MUI pages
#--------------------------------------------------------------------------
  ;-----------------------------------------
  ; General Settings - License Page Settings
  ;-----------------------------------------

  ; Select either "accept/do not accept" radio buttons or "accept" checkbox for the license page

#  !define MUI_LICENSEPAGE_RADIOBUTTONS
  !define MUI_LICENSEPAGE_CHECKBOX

  ;-----------------------------------------
  ; General Settings - Finish Page Settings
  ;-----------------------------------------

  ; Offer to display the POPFile User Interface (The 'CheckRunStatus' function ensures this
  ; option is only offered if the installer has started POPFile running)

  !define MUI_FINISHPAGE_RUN
  !define MUI_FINISHPAGE_RUN_FUNCTION "RunUI"

  ; Display the Release Notes for this version of POPFile
  
  !define MUI_FINISHPAGE_SHOWREADME
  !define MUI_FINISHPAGE_SHOWREADME_NOTCHECKED
  !define MUI_FINISHPAGE_SHOWREADME_FUNCTION "ShowReadMe"

  ; Allow user to check the log file (by clicking "Show Details" button on the "Install" page)

#  !define MUI_FINISHPAGE_NOAUTOCLOSE

  ;-----------------------------------------
  ; General Settings - Other Settings
  ;-----------------------------------------

  ; Show a message box with a warning when the user closes the installation

  !define MUI_ABORTWARNING

  ;-----------------------------------------
  ; Interface Settings
  ;-----------------------------------------

  ; The "Special" bitmap appears on the "Welcome" and "Finish" pages,
  ; the "Header" bitmap appears on the other pages of the installer.

  !define MUI_SPECIALBITMAP "special.bmp"
  !define MUI_HEADERBITMAP "hdr-right.bmp"
  !define MUI_HEADERBITMAP_RIGHT

  ; The icon files for the installer and uninstaller must have the same structure. For example,
  ; if one icon file contains a 32x32 16-colour image and a 16x16 16-colour image then the other
  ; file cannot just contain a 32x32 16-colour image, it must also have a 16x16 16-colour image.

  !define MUI_ICON    "POPFileIcon\popfile.ico"
  !define MUI_UNICON  "remove.ico"

  ;-----------------------------------------
  ; Custom Functions added to MUI pages
  ;-----------------------------------------

  ; Use a "leave" function to look for 'popfile.cfg' in the directory selected for this install

  !define MUI_CUSTOMFUNCTION_DIRECTORY_LEAVE CheckExistingConfig

  ; Use a "pre" function for the 'Finish' page to ensure installer only offers to display
  ; POPFile User Interface if user has chosen to start POPFile from the installer.

  !define MUI_CUSTOMFUNCTION_FINISH_PRE CheckRunStatus

#--------------------------------------------------------------------------
# User Registers (Global)
#--------------------------------------------------------------------------

  ; NSIS provides 20 general purpose user registers:
  ; (a) $0 to $9 are used as global registers
  ; (b) $R0 to $R9 are used as local registers

  ; Local registers referred to by 'defines' use names starting with 'L_' (eg L_LNE, L_OLDUI)
  ; and the scope of these 'defines' is limited to the "routine" where they are used.

  !define POP3     $0   ; POP3 port (1-65535)
  !define GUI      $1   ; GUI port (1-65535)
  !define STARTUP  $2   ; automatic startup flag (1 = yes, 0 = no)
  !define CFG      $3   ; general purpose file handle
  !define NOTEPAD  $4   ; path to notepad.exe ("" = not found in search path)

#--------------------------------------------------------------------------
# Language
#--------------------------------------------------------------------------

  !insertmacro MUI_LANGUAGEFILE_STRING MUI_TEXT_WELCOME_INFO_TEXT \
      "This wizard will guide you through the installation of ${MUI_PRODUCT}.\r\n\r\n\
      It is recommended that you close all other applications before starting Setup.\r\n\r\n"

  !insertmacro MUI_LANGUAGEFILE_STRING MUI_TEXT_FINISH_RUN "Display POPFile &User Interface"

  !insertmacro MUI_LANGUAGE "English"

#--------------------------------------------------------------------------
# General settings
#--------------------------------------------------------------------------

  ; Specify NSIS output filename

  OutFile "setup.exe"

  ; Ensure CRC checking cannot be turned off using the /NCRC command-line switch

  CRCcheck Force

  ; Data file for license page

  LicenseData "..\engine\license"

#--------------------------------------------------------------------------
# Install Options page header text
#--------------------------------------------------------------------------

  LangString TEXT_IO_TITLE ${LANG_ENGLISH} "Install Options Page"
  LangString TEXT_IO_SUBTITLE ${LANG_ENGLISH} "Options"

#--------------------------------------------------------------------------
# Component-selection page description text
#--------------------------------------------------------------------------

  LangString DESC_SecPOPFile ${LANG_ENGLISH} "Installs the core files needed by POPFile, \
                                              including a minimal version of Perl."
  LangString DESC_SecSkins   ${LANG_ENGLISH} "Installs POPFile skins that allow you to change \
                                              the look and feel of the POPFile user interface."
  LangString DESC_SecLangs   ${LANG_ENGLISH} "Installs non-English language versions of the \
                                              POPFile UI."

#--------------------------------------------------------------------------
# Default Destination Folder
#--------------------------------------------------------------------------

  InstallDir "$PROGRAMFILES\${MUI_PRODUCT}"
  InstallDirRegKey HKLM SOFTWARE\POPFile InstallLocation

#--------------------------------------------------------------------------
# Reserve the files required by the installer (to improve performance)
#--------------------------------------------------------------------------

  ;Things that need to be extracted on startup (keep these lines before any File command!)
  ;Only useful for BZIP2 compression
  ;Use ReserveFile for your own Install Options ini files too!

  !insertmacro MUI_RESERVEFILE_INSTALLOPTIONS
  !insertmacro MUI_RESERVEFILE_WELCOMEFINISHPAGE
  ReserveFile "ioA.ini"
  ReserveFile "ioB.ini"
  ReserveFile "ioC.ini"
  ReserveFile "${RELEASE_NOTES}"

#--------------------------------------------------------------------------
# Initialise the installer
#--------------------------------------------------------------------------

Function .onInit

  !insertmacro MUI_INSTALLOPTIONS_EXTRACT "ioA.ini"
  !insertmacro MUI_INSTALLOPTIONS_EXTRACT "ioB.ini"
  !insertmacro MUI_INSTALLOPTIONS_EXTRACT "ioC.ini"
  
  !insertmacro MUI_INSTALLOPTIONS_EXTRACT_AS "${RELEASE_NOTES}" "release.txt"
  
  MessageBox MB_YESNO "Display POPFile Release Notes ?$\r$\n$\r$\n\
      'Yes' recommended if you are upgrading." IDNO exit
  SearchPath ${NOTEPAD} notepad.exe
  StrCmp ${NOTEPAD} "" use_file_association
  ExecWait 'notepad.exe "$PLUGINSDIR\release.txt"'
  GoTo exit

use_file_association:
  ExecShell "open" "$PLUGINSDIR\release.txt"

exit:
FunctionEnd

#--------------------------------------------------------------------------
# Installer Section: POPFile component
#--------------------------------------------------------------------------

Section "POPFile" SecPOPFile

  ; Make this section mandatory (i.e. it is always installed)

  SectionIn RO

  ; If we are installing over a previous version, (try to) ensure that version is not running

  Call MakeItSafe

  ; Retrieve the POP3 and GUI ports from the ini and get whether we install the
  ; POPFile run in the Startup group

  !insertmacro MUI_INSTALLOPTIONS_READ ${POP3}    "ioA.ini" "Field 2" "State"
  !insertmacro MUI_INSTALLOPTIONS_READ ${GUI}     "ioA.ini" "Field 4" "State"
  !insertmacro MUI_INSTALLOPTIONS_READ ${STARTUP} "ioA.ini" "Field 5" "State"

  WriteRegStr HKLM SOFTWARE\POPFile InstallLocation $INSTDIR

  ; Install the POPFile Core files

  SetOutPath $INSTDIR

  File "..\engine\license"
  File "${RELEASE_NOTES}"
  StrCmp ${NOTEPAD} "" 0 readme_ok
  File /oname=${README}.txt "${RELEASE_NOTES}"

readme_ok:
  File "..\engine\popfile.pl"
  File "..\engine\insert.pl"
  File "..\engine\pix.gif"
  File "..\engine\black.gif"
  File "..\engine\otto.gif"

  IfFileExists "$INSTDIR\stopwords" stopwords_found
  File "..\engine\stopwords"
  Goto stopwords_done

stopwords_found:
  IfFileExists "$INSTDIR\stopwords.default" 0 use_other_name
  MessageBox MB_YESNO "Copy of default 'stopwords' already exists ('stopwords.default').$\r$\n\
      $\r$\nOK to overwrite this file?$\r$\n$\r$\n\
      Click 'Yes' to overwrite, click 'No' to skip updating this file" IDNO stopwords_done
  SetFileAttributes "$INSTDIR\stopwords.default" NORMAL

use_other_name:
  File /oname=stopwords.default "..\engine\stopwords"

stopwords_done:
  FileOpen  ${CFG} $PLUGINSDIR\popfile.cfg a
  FileSeek  ${CFG} 0 END
  FileWrite ${CFG} "pop3_port ${POP3}$\r$\n"
  FileWrite ${CFG} "html_port ${GUI}$\r$\n"
  FileClose ${CFG}
  IfFileExists "$INSTDIR\popfile.cfg" 0 update_config
  SetFileAttributes "$INSTDIR\popfile.cfg" NORMAL
  IfFileExists "$INSTDIR\popfile.cfg.bak" 0 make_cfg_backup
  MessageBox MB_YESNO "Backup copy of 'popfile.cfg' already exists ('popfile.cfg.bak').$\r$\n\
      $\r$\nOK to overwrite this file?$\r$\n$\r$\n\
      Click 'Yes' to overwrite, click 'No' to skip making a backup copy" IDNO update_config
  SetFileAttributes "$INSTDIR\popfile.cfg.bak" NORMAL

make_cfg_backup:
  CopyFiles $INSTDIR\popfile.cfg $INSTDIR\popfile.cfg.bak

update_config:
  CopyFiles $PLUGINSDIR\popfile.cfg $INSTDIR\

  SetOutPath $INSTDIR\Classifier
  File "..\engine\Classifier\Bayes.pm"
  File "..\engine\Classifier\WordMangle.pm"
  File "..\engine\Classifier\MailParse.pm"
  SetOutPath $INSTDIR\POPFile
  File "..\engine\POPFile\MQ.pm"
  File "..\engine\POPFile\Logger.pm"
  File "..\engine\POPFile\Module.pm"
  File "..\engine\POPFile\Configuration.pm"
  SetOutPath $INSTDIR\Proxy
  File "..\engine\Proxy\Proxy.pm"
  File "..\engine\Proxy\POP3.pm"
  SetOutPath $INSTDIR\Platform
  File "..\engine\Platform\MSWin32.pm"
  File "..\engine\Platform\POPFileIcon.dll"
  SetOutPath $INSTDIR\UI
  File "..\engine\UI\HTML.pm"
  File "..\engine\UI\HTTP.pm"

  SetOutPath $INSTDIR\manual
  File "..\engine\manual\*.gif"
  SetOutPath $INSTDIR\manual\en
  File "..\engine\manual\en\*.html"

  SetOutPath $INSTDIR\languages
  File "..\engine\languages\English.msg"

  ; Install the Minimal Perl files

  SetOutPath $INSTDIR
  File "C:\Perl\bin\perl.exe"
  File "C:\Perl\bin\wperl.exe"
  File "C:\Perl\bin\perl58.dll"
  File "C:\Perl\lib\AutoLoader.pm"
  File "C:\Perl\lib\Carp.pm"
  File "C:\Perl\lib\Config.pm"
  File "C:\Perl\lib\DynaLoader.pm"
  File "C:\Perl\lib\Errno.pm"
  File "C:\Perl\lib\Exporter.pm"
  File "C:\Perl\lib\IO.pm"
  File "C:\Perl\lib\integer.pm"
  File "C:\Perl\lib\locale.pm"
  File "C:\Perl\lib\POSIX.pm"
  File "C:\Perl\lib\SelectSaver.pm"
  File "C:\Perl\lib\Socket.pm"
  File "C:\Perl\lib\strict.pm"
  File "C:\Perl\lib\Symbol.pm"
  File "C:\Perl\lib\vars.pm"
  File "C:\Perl\lib\warnings.pm"
  File "C:\Perl\lib\XSLoader.pm"

  SetOutPath $INSTDIR\Carp
  File "C:\Perl\lib\Carp\*"

  SetOutPath $INSTDIR\Exporter
  File "C:\Perl\lib\Exporter\*"

  SetOutPath $INSTDIR\MIME
  File "C:\Perl\lib\MIME\*"

  SetOutPath $INSTDIR\Win32
  File "C:\Perl\site\lib\Win32\API.pm"

  SetOutPath $INSTDIR\Win32\API
  File "C:\Perl\site\lib\Win32\API\*.pm"

  SetOutPath $INSTDIR\auto\Win32\API
  File "C:\Perl\site\lib\auto\Win32\API\*"

  SetOutPath $INSTDIR\IO
  File "C:\Perl\lib\IO\*"

  SetOutPath $INSTDIR\Sys
  File "C:\Perl\lib\Sys\*"

  SetOutPath $INSTDIR\Text
  File "C:\Perl\lib\Text\ParseWords.pm"

  SetOutPath $INSTDIR\IO\Socket
  File "C:\Perl\lib\IO\Socket\*"

  SetOutPath $INSTDIR\auto\DynaLoader
  File "C:\Perl\lib\auto\DynaLoader\*"

  SetOutPath $INSTDIR\auto\File\Glob
  File "C:\Perl\lib\auto\File\Glob\*"

  SetOutPath $INSTDIR\auto\MIME\Base64
  File "C:\Perl\lib\auto\MIME\Base64\*"

  SetOutPath $INSTDIR\auto\IO
  File "C:\Perl\lib\auto\IO\*"

  SetOutPath $INSTDIR\auto\Socket
  File "C:\Perl\lib\auto\Socket\*"

  SetOutPath $INSTDIR\auto\Sys\Hostname
  File "C:\Perl\lib\auto\Sys\Hostname\*"

  SetOutPath $INSTDIR\auto\POSIX
  File "C:\Perl\lib\auto\POSIX\POSIX.dll"
  File "C:\Perl\lib\auto\POSIX\autosplit.ix"
  File "C:\Perl\lib\auto\POSIX\load_imports.al"

  SetOutPath $INSTDIR\File
  File "C:\Perl\lib\File\Glob.pm"

  SetOutPath $INSTDIR\warnings
  File "C:\Perl\lib\warnings\register.pm"

  ; Create the uninstall program BEFORE creating the shortcut to it
  ; (this ensures that the correct "uninstall" icon appears in the START MENU shortcut)

  SetOutPath $INSTDIR
  Delete $INSTDIR\uninstall.exe
  WriteUninstaller $INSTDIR\uninstall.exe

  ; Create the START MENU entries

  SetOutPath $SMPROGRAMS\POPFile
  SetOutPath $INSTDIR
  CreateShortCut "$SMPROGRAMS\POPFile\Run POPFile.lnk" \
                 "$INSTDIR\perl.exe" popfile.pl \
                 "$INSTDIR\Platform\POPFileIcon.dll"
  CreateShortCut "$SMPROGRAMS\POPFile\Run POPFile in background.lnk" \
                 "$INSTDIR\wperl.exe" popfile.pl \
                 "$INSTDIR\Platform\POPFileIcon.dll"
  CreateShortCut "$SMPROGRAMS\POPFile\Uninstall POPFile.lnk" \
                 "$INSTDIR\uninstall.exe"
  SetOutPath $SMPROGRAMS\POPFile
  WriteINIStr "$SMPROGRAMS\POPFile\POPFile User Interface.url" \
              "InternetShortcut" "URL" "http://127.0.0.1:${GUI}/"
  WriteINIStr "$SMPROGRAMS\POPFile\Shutdown POPFile.url" \
              "InternetShortcut" "URL" "http://127.0.0.1:${GUI}/shutdown"
  WriteINIStr "$SMPROGRAMS\POPFile\Manual.url" \
              "InternetShortcut" "URL" "file://$INSTDIR/manual/en/manual.html"
  WriteINIStr "$SMPROGRAMS\POPFile\FAQ.url" \
              "InternetShortcut" "URL" \
              "http://sourceforge.net/docman/display_doc.php?docid=14421&group_id=63137"
  SetOutPath $SMPROGRAMS\POPFile\Support
  WriteINIStr "$SMPROGRAMS\POPFile\Support\POPFile Home Page.url" \
              "InternetShortcut" "URL" "http://popfile.sourceforge.net/"

  StrCmp ${STARTUP} "1" 0 skip_autostart_set
      SetOutPath $SMSTARTUP
      SetOutPath $INSTDIR
      CreateShortCut "$SMSTARTUP\Run POPFile in background.lnk" \
                     "$INSTDIR\wperl.exe" popfile.pl \
                     "$INSTDIR\Platform\POPFileIcon.dll"
skip_autostart_set:

  ; Create entry in the Control Panel's "Add/Remove Programs" list

  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${MUI_PRODUCT}" \
              "DisplayName" "${MUI_PRODUCT} ${MUI_VERSION}"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${MUI_PRODUCT}" \
              "UninstallString" "$INSTDIR\uninstall.exe"
  WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${MUI_PRODUCT}" \
              "NoModify" "1"
  WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${MUI_PRODUCT}" \
              "NoRepair" "1"

SectionEnd

#--------------------------------------------------------------------------
# Installer Section: (optional) Skins component
#--------------------------------------------------------------------------

Section "Skins" SecSkins

  SetOutPath $INSTDIR\skins
  File "..\engine\skins\*.css"
  File "..\engine\skins\*.gif"
  SetOutPath $INSTDIR\skins\lavishImages
  File "..\engine\skins\lavishImages\*.gif"
  SetOutPath $INSTDIR\skins\sleetImages
  File "..\engine\skins\sleetImages\*.gif"

SectionEnd

#--------------------------------------------------------------------------
# Installer Section: (optional) UI Languages component
#--------------------------------------------------------------------------

Section "Languages" SecLangs

  SetOutPath $INSTDIR\languages
  File "..\engine\languages\*.msg"

SectionEnd

#--------------------------------------------------------------------------
# Component-selection page descriptions
#--------------------------------------------------------------------------

  !insertmacro MUI_FUNCTIONS_DESCRIPTION_BEGIN
    !insertmacro MUI_DESCRIPTION_TEXT ${SecPOPFile} $(DESC_SecPOPFile)
    !insertmacro MUI_DESCRIPTION_TEXT ${SecSkins} $(DESC_SecSkins)
    !insertmacro MUI_DESCRIPTION_TEXT ${SecLangs} $(DESC_SecLangs)
  !insertmacro MUI_FUNCTIONS_DESCRIPTION_END

#--------------------------------------------------------------------------
# Installer Function: MakeItSafe
#
# If we are installing on top of a previous installation, we try to shut it down
# (to allow the files to be overwritten without requiring a reboot)
#--------------------------------------------------------------------------

Function MakeItSafe

  !define L_NEW_GUI  $R9
  !define L_OLD_GUI  $R8
  !define L_RESULT   $R7

  Push ${L_NEW_GUI}
  Push ${L_OLD_GUI}
  Push ${L_RESULT}
  
  Push ${CFG}         ; a Global variable
  
  ; If we are about to overwrite an existing version which is still running,
  ; then one of the EXE files will be 'locked' which means we have to shutdown POPFile

  IfFileExists "$INSTDIR\wperl.exe" 0 other_perl
  SetFileAttributes "$INSTDIR\wperl.exe" NORMAL
  ClearErrors
  FileOpen ${CFG} "$INSTDIR\wperl.exe" a
  FileClose ${CFG}
  IfErrors attempt_shutdown
  
other_perl:
  IfFileExists "$INSTDIR\perl.exe" 0 exit_now
  SetFileAttributes "$INSTDIR\perl.exe" NORMAL
  ClearErrors
  FileOpen ${CFG} "$INSTDIR\perl.exe" a
  FileClose ${CFG}
  IfErrors 0 exit_now

attempt_shutdown:
  !insertmacro MUI_INSTALLOPTIONS_READ "${L_NEW_GUI}" "ioA.ini" "UI Port" "NewStyle"
  !insertmacro MUI_INSTALLOPTIONS_READ "${L_OLD_GUI}" "ioA.ini" "UI Port" "OldStyle"

  Push ${L_OLD_GUI}
  Call StrCheckDecimal
  Pop ${L_OLD_GUI}
  StrCmp ${L_OLD_GUI} "" try_other_port

  DetailPrint "Shutting down previous version of POPFile using port ${L_OLD_GUI}"
  NSISdl::download_quiet http://127.0.0.1:${L_OLD_GUI}/shutdown "$PLUGINSDIR\shutdown.htm"
  Pop ${L_RESULT}
  StrCmp ${L_RESULT} "success" exit_now

try_other_port:
  Push ${L_NEW_GUI}
  Call StrCheckDecimal
  Pop ${L_NEW_GUI}
  StrCmp ${L_NEW_GUI} "" exit_now

  DetailPrint "Shutting down previous version of POPFile using port ${L_NEW_GUI}"
  NSISdl::download_quiet http://127.0.0.1:${L_NEW_GUI}/shutdown "$PLUGINSDIR\shutdown.htm"
  Pop ${L_RESULT} ; Ignore the result

exit_now:
  Pop ${CFG}          ; a Global variable
  
  Pop ${L_RESULT}
  Pop ${L_OLD_GUI}
  Pop ${L_NEW_GUI}

  !undef L_NEW_GUI
  !undef L_OLD_GUI
  !undef L_RESULT
FunctionEnd

#--------------------------------------------------------------------------
# Installer Function: CheckExistingConfig
# (the "leave" function for the DIRECTORY selection page)
#
# This function is used to extract the POP3 and UI ports from the 'popfile.cfg'
# configuration file (if any) in the directory used for this installation.
#
# As it is possible that there are multiple entries for these parameters in the file,
# this function removes them all as it makes a new copy of the file. New port data
# entries will be added to this copy and the original updated (and backed up) when
# the "POPFile" section of the installer is executed.
#--------------------------------------------------------------------------

Function CheckExistingConfig

  !define L_CLEANCFG  $R9     ; handle for "clean" copy
  !define L_CMPRE     $R8     ; config param name
  !define L_LNE       $R7     ; a line from popfile.cfg
  !define L_OLDUI     $R6     ; used to hold old-style of GUI port

  Push ${L_CLEANCFG}
  Push ${L_CMPRE}
  Push ${L_LNE}
  Push ${L_OLDUI}

  StrCpy ${POP3} ""
  StrCpy ${GUI} ""
  StrCpy ${L_OLDUI} ""

  ; See if we can get the current pop3 and gui port from an existing configuration.
  ; There may be more than one entry for these ports in the file - use the last one found
  ; (but give priority to any "html_port" entry).

  ClearErrors

  FileOpen  ${CFG} $INSTDIR\popfile.cfg r
  FileOpen  ${L_CLEANCFG} $PLUGINSDIR\popfile.cfg w

loop:
  FileRead   ${CFG} ${L_LNE}
  IfErrors done

  StrCpy ${L_CMPRE} ${L_LNE} 5
  StrCmp ${L_CMPRE} "port " got_port

  StrCpy ${L_CMPRE} ${L_LNE} 10
  StrCmp ${L_CMPRE} "pop3_port " got_pop3_port
  StrCmp ${L_CMPRE} "html_port " got_html_port

  StrCpy ${L_CMPRE} ${L_LNE} 8
  StrCmp ${L_CMPRE} "ui_port " got_ui_port

  FileWrite  ${L_CLEANCFG} ${L_LNE}
  Goto loop

got_port:
  StrCpy ${POP3} ${L_LNE} 5 5
  Goto loop

got_pop3_port:
  StrCpy ${POP3} ${L_LNE} 5 10
  Goto loop

got_ui_port:
  StrCpy ${L_OLDUI} ${L_LNE} 5 8
  Goto loop

got_html_port:
  StrCpy ${GUI} ${L_LNE} 5 10
  Goto loop

done:
  FileClose ${CFG}
  FileClose ${L_CLEANCFG}

  Push ${POP3}
  Call TrimNewlines
  Pop ${POP3}

  Push ${GUI}
  Call TrimNewlines
  Pop ${GUI}

  Push ${L_OLDUI}
  Call TrimNewlines
  Pop ${L_OLDUI}

  ; Save the UI port settings (from popfile.cfg) for later use by the 'MakeItSafe' function

  !insertmacro MUI_INSTALLOPTIONS_WRITE "ioA.ini" "UI Port" "NewStyle" "${GUI}"
  !insertmacro MUI_INSTALLOPTIONS_WRITE "ioA.ini" "UI Port" "OldStyle" "${L_OLDUI}"

  ; The 'port' and 'pop3_port' settings are treated as equals so we use the last entry found.
  ; If 'ui_port' and 'html_port' settings were found, we use the last 'html_port' we found.

  StrCmp ${GUI} "" 0 validity_checks
  StrCpy ${GUI} ${L_OLDUI}

validity_checks:

  ; check port values (config file may have no port data or invalid port data)

  StrCmp ${POP3} ${GUI} 0 ports_differ

  ; Config file has no port data or same port used for POP3 and GUI
  ; (i.e. the data is not valid), so use POPFile defaults

  StrCpy ${POP3} "110"
  StrCpy ${GUI} "8080"
  Goto ports_ok

ports_differ:
  StrCmp ${POP3} "" default_pop3
  Push ${POP3}
  Call StrCheckDecimal
  Pop ${POP3}
  StrCmp ${POP3} "" default_pop3
  IntCmp ${POP3} 1 pop3_ok default_pop3
  IntCmp ${POP3} 65535 pop3_ok pop3_ok

default_pop3:
  StrCpy ${POP3} "110"
  StrCmp ${POP3} ${GUI} 0 pop3_ok
  StrCpy ${POP3} "111"

pop3_ok:
  StrCmp ${GUI} "" default_gui
  Push ${GUI}
  Call StrCheckDecimal
  Pop ${GUI}
  StrCmp ${GUI} "" default_gui
  IntCmp ${GUI} 1 ports_ok default_gui
  IntCmp ${GUI} 65535 ports_ok ports_ok

default_gui:
  StrCpy ${GUI} "8080"
  StrCmp ${POP3} ${GUI} 0 ports_ok
  StrCpy ${GUI} "8081"

ports_ok:

  Pop ${L_OLDUI}
  Pop ${L_LNE}
  Pop ${L_CMPRE}
  Pop ${L_CLEANCFG}

  !undef L_CLEANCFG
  !undef L_CMPRE
  !undef L_LNE
  !undef L_OLDUI

FunctionEnd

#--------------------------------------------------------------------------
# Installer Function: SetOptionsPage (generates a custom page)
#
# This function is used to configure the POP3 and UI ports, and
# whether or not POPFile should be started automatically.
#
# A "leave" function (CheckPortOptions) is used to validate the port
# selections made by the user.
#--------------------------------------------------------------------------

Function SetOptionsPage

  !define L_PORTLIST  $R9   ; combo box ports list
  !define L_RESULT    $R8

  Push ${L_PORTLIST}
  Push ${L_RESULT}

  ; The function "CheckExistingConfig" loads ${POP3} and ${GUI} with the settings found in
  ; a previously installed "popfile.cfg" file or if no such file is found, it loads the
  ; POPFile default values. Now we display these settings and allow the user to change them.

  ; The POP3 and GUI port numbers must be in the range 1 to 65535 inclusive, and they
  ; must be different. This function assumes that the values "CheckExistingConfig" has loaded
  ; into ${POP3} and ${GUI} are valid.

  !insertmacro MUI_HEADER_TEXT "POPFile Installation Options" \
                               "Leave these options unchanged unless you need to change them"

  ; If the POP3 (or GUI) port determined by "CheckExistingConfig" is not present in the list of
  ; possible values for the POP3 (or GUI) combobox, add it to the end of the list.

  !insertmacro MUI_INSTALLOPTIONS_READ ${L_PORTLIST} "ioA.ini" "Field 2" "ListItems"
  Push |${L_PORTLIST}|
  Push |${POP3}|
  Call StrStr
  Pop ${L_RESULT}
  StrCmp ${L_RESULT} "" 0 POP3_is_in_list
  StrCpy ${L_PORTLIST} ${L_PORTLIST}|${POP3}
  !insertmacro MUI_INSTALLOPTIONS_WRITE "ioA.ini" "Field 2" "ListItems" ${L_PORTLIST}

POP3_is_in_list:
  !insertmacro MUI_INSTALLOPTIONS_READ ${L_PORTLIST} "ioA.ini" "Field 4" "ListItems"
  Push |${L_PORTLIST}|
  Push |${GUI}|
  Call StrStr
  Pop ${L_RESULT}
  StrCmp ${L_RESULT} "" 0 GUI_is_in_list
  StrCpy ${L_PORTLIST} ${L_PORTLIST}|${GUI}
  !insertmacro MUI_INSTALLOPTIONS_WRITE "ioA.ini" "Field 4" "ListItems" ${L_PORTLIST}

GUI_is_in_list:

  ; If the StartUp folder contains a link to start POPFile automatically
  ; then offer to keep this facility in place.

  IfFileExists "$SMSTARTUP\Run POPFile in background.lnk" 0 show_defaults
    !insertmacro MUI_INSTALLOPTIONS_WRITE "ioA.ini" "Field 5" "State" 1

show_defaults:
  !insertmacro MUI_INSTALLOPTIONS_WRITE "ioA.ini" "Field 2" "State" ${POP3}
  !insertmacro MUI_INSTALLOPTIONS_WRITE "ioA.ini" "Field 4" "State" ${GUI}

  ; Now display the custom page and wait for the user to make their selections.
  ; The function "CheckPortOptions" will check the validity of the selections
  ; and refuse to proceed until suitable ports have been chosen.

  !insertmacro MUI_INSTALLOPTIONS_DISPLAY "ioA.ini"

  Pop ${L_RESULT}
  Pop ${L_PORTLIST}

  !undef L_PORTLIST
  !undef L_RESULT

FunctionEnd

#--------------------------------------------------------------------------
# Installer Function: CheckPortOptions
# (the "leave" function for the custom page created by "SetOptionsPage")
#
# This function is used to validate the POP3 and UI ports selected by the user.
# If the selections are not valid, user is asked to select alternative values.
#--------------------------------------------------------------------------

Function CheckPortOptions

  !define L_RESULT    $R9

  Push ${L_RESULT}

  !insertmacro MUI_INSTALLOPTIONS_READ ${POP3} "ioA.ini" "Field 2" "State"
  !insertmacro MUI_INSTALLOPTIONS_READ ${GUI} "ioA.ini" "Field 4" "State"

  StrCmp ${POP3} ${GUI} ports_must_differ
  Push ${POP3}
  Call StrCheckDecimal
  Pop ${L_RESULT}
  StrCmp ${L_RESULT} "" bad_pop3
  IntCmp ${POP3} 1 pop3_ok bad_pop3
  IntCmp ${POP3} 65535 pop3_ok pop3_ok

bad_pop3:
  MessageBox MB_OK "The POP3 port cannot be set to $\"${POP3}$\".$\n$\n\
      The port must be a number in the range 1 to 65535.$\n$\n\
      Please change your POP3 port selection."
  Goto bad_exit

pop3_ok:
  Push ${GUI}
  Call StrCheckDecimal
  Pop ${L_RESULT}
  StrCmp ${L_RESULT} "" bad_gui
  IntCmp ${GUI} 1 good_exit bad_gui
  IntCmp ${GUI} 65535 good_exit good_exit

bad_gui:
  MessageBox MB_OK "The 'User Interface' port cannot be set to $\"${GUI}$\".$\n$\n\
      The port must be a number in the range 1 to 65535.$\n$\n\
      Please change your 'User Interface' port selection."
  Goto bad_exit

ports_must_differ:
  MessageBox MB_OK "The POP3 port must be different from the 'User Interface' port.$\n$\n\
      Please change your port selections."

bad_exit:

  ; Stay with the custom page created by "SetOptionsPage"

  Pop ${L_RESULT}
  Abort

good_exit:

  ; Allow next page in the installation sequence to be shown

  Pop ${L_RESULT}

  !undef L_RESULT

FunctionEnd

#--------------------------------------------------------------------------
# Installer Function: SetOutlookOrOutlookExpressPage (generates a custom page)
#
# This function is used to reconfigure Outlook Express accounts
#--------------------------------------------------------------------------

Function SetOutlookOrOutlookExpressPage

  ; More than one "identity" can be created in OE. Each of these identities is
  ; given a GUID and these GUIDs are stored in HKEY_CURRENT_USER\Identities.

  ; Each identity can have several email accounts and the details for these
  ; accounts are grouped according to the GUID which "owns" the accounts.

  ; We step through every identity defined in HKEY_CURRENT_USER\Identities and
  ; for each one found check its OE email account data.

  ; When OE is installed, it (usually) creates an initial identity which stores its
  ; email account data in a fixed registry location. If an identity with an "Identity Ordinal"
  ; value of 1 is found, we need to look for its OE email account data in
  ;
  ;     HKEY_CURRENT_USER\Software\Microsoft\Internet Account Manager\Accounts
  ;
  ; otherwise we look in the GUID's entry in HKEY_CURRENT_USER\Identities, using the path
  ;
  ;     HKEY_CURRENT_USER\Identities\{GUID}\Software\Microsoft\Internet Account Manager\Accounts

  ; All of the OE account data for an identity appears "under" the path defined
  ; above, e.g. if an identity has several accounts, the account data is stored like this:
  ;    HKEY_CURRENT_USER\...\Internet Account Manager\Accounts\00000001
  ;    HKEY_CURRENT_USER\...\Internet Account Manager\Accounts\00000002
  ;    etc

  !define L_ACCOUNT     $R9   ; path to the data for the current OE account (less the HKCU part)
  !define L_ACCT_INDEX  $R8   ; used to loop through OE accounts for the current OE Identity
  !define L_GUID        $R7   ; GUID of the current entry in HKCU\Identities list
  !define L_GUID_INDEX  $R6   ; used to loop through the list of OE Identities
  !define L_IDENTITY    $R5   ; plain text form of OE Identity name
  !define L_OEDATA      $R4   ; some data (it varies) for current OE account
  !define L_OEPATH      $R3   ; holds part of the path used to access OE account data
  !define L_ORDINALS    $R2   ; "Identity Ordinals" flag (1 = found, 0 = not found)
  !define L_SEPARATOR   $R1   ; char used to separate the pop3 server from the username
  !define L_TEMP        $R0

  Push ${L_ACCOUNT}
  Push ${L_ACCT_INDEX}
  Push ${L_GUID}
  Push ${L_GUID_INDEX}
  Push ${L_IDENTITY}
  Push ${L_OEDATA}
  Push ${L_OEPATH}
  Push ${L_ORDINALS}
  Push ${L_SEPARATOR}
  Push ${L_TEMP}

  ; Determine the separator character to be used when configuring an email account for POPFile

  Call GetSeparator
  Pop ${L_SEPARATOR}

  StrCpy ${L_GUID_INDEX} 0

  ; Get the next identity from the registry

get_guid:
  EnumRegKey ${L_GUID} HKCU "Identities" ${L_GUID_INDEX}
  StrCmp ${L_GUID} "" finished_oe_config

  ; Check if this is the GUID for the first "Main Identity" created by OE as the account data
  ; for that identity is stored separately from the account data for the other OE identities.
  ; If no "Identity Ordinal" value found, use the first "Main Identity" created by OE.

  StrCpy ${L_ORDINALS} "1"

  ReadRegDWORD ${L_TEMP} HKCU "Identities\${L_GUID}" "Identity Ordinal"
  IntCmp ${L_TEMP} 1 firstOrdinal noOrdinals otherOrdinal

firstOrdinal:
  StrCpy ${L_OEPATH} ""
  goto check_accounts

noOrdinals:
  StrCpy ${L_ORDINALS} "0"
  StrCpy ${L_OEPATH} ""
  goto check_accounts

otherOrdinal:
  StrCpy ${L_OEPATH} "Identities\${L_GUID}\"

check_accounts:

  ; Now check all of the accounts for the current OE Identity

  StrCpy ${L_ACCT_INDEX} 0

next_acct:
  EnumRegKey ${L_ACCOUNT} \
             HKCU "${L_OEPATH}Software\Microsoft\Internet Account Manager\Accounts" \
             ${L_ACCT_INDEX}
  StrCmp ${L_ACCOUNT} "" finished_this_guid
  StrCpy ${L_ACCOUNT} \
        "${L_OEPATH}Software\Microsoft\Internet Account Manager\Accounts\${L_ACCOUNT}"

  ; Now extract the POP3 Server data, if this does not exist then this account is
  ; not configured for mail so move on. If the data is "127.0.0.1" assume the account has
  ; already been configured for use with POPFile.

  ReadRegStr ${L_OEDATA} HKCU ${L_ACCOUNT} "POP3 Server"
  StrCmp ${L_OEDATA} "" try_next_account
  StrCmp ${L_OEDATA} "127.0.0.1" try_next_account

  ; If 'POP3 Server' data contains the separator character, we cannot configure this account

  Push ${L_OEDATA}
  Push ${L_SEPARATOR}
  Call StrStr
  Pop ${L_TEMP}
  StrCmp ${L_TEMP} "" 0 try_next_account

  !insertmacro MUI_HEADER_TEXT "Reconfigure Outlook Express" \
      "POPFile can reconfigure Outlook Express for you"

  ; Ensure the 'configure this account' check box is NOT ticked

  !insertmacro MUI_INSTALLOPTIONS_WRITE    "ioB.ini" "Field 2" "State" "0"

  ; Prepare to display the 'POP3 Server' data

  !insertmacro MUI_INSTALLOPTIONS_WRITE    "ioB.ini" "Field 8" "Text" ${L_OEDATA}

  ReadRegStr ${L_OEDATA} HKCU ${L_ACCOUNT} "SMTP Email Address"
  !insertmacro MUI_INSTALLOPTIONS_WRITE    "ioB.ini" "Field 7" "Text" ${L_OEDATA}

  ReadRegStr ${L_OEDATA} HKCU ${L_ACCOUNT} "POP3 User Name"

  ; If 'POP3 User Name' data contains the separator character, we cannot configure this account

  Push ${L_OEDATA}
  Push ${L_SEPARATOR}
  Call StrStr
  Pop ${L_TEMP}
  StrCmp ${L_TEMP} "" 0 try_next_account

  !insertmacro MUI_INSTALLOPTIONS_WRITE    "ioB.ini" "Field 9" "Text" ${L_OEDATA}

  ; Find the Username used by OE for this identity and the OE Account Name
  ; (so we can unambiguously report which email account we are offering to reconfigure).

  ReadRegStr ${L_IDENTITY} HKCU "Identities\${L_GUID}\" "Username"
  StrCpy ${L_IDENTITY} $\"${L_IDENTITY}$\"
  ReadRegStr ${L_OEDATA} HKCU ${L_ACCOUNT} "Account Name"
  StrCpy ${L_OEDATA} $\"${L_OEDATA}$\"
  !insertmacro MUI_INSTALLOPTIONS_WRITE    "ioB.ini" "Field 10" "Text" \
      "${L_OEDATA} account for the ${L_IDENTITY} identity"

  ; Display the OE account data and offer to configure this account to work with POPFile

  !insertmacro MUI_INSTALLOPTIONS_DISPLAY_RETURN "ioB.ini"
  Pop ${L_TEMP}

  StrCmp ${L_TEMP} "cancel" finished_this_guid
  StrCmp ${L_TEMP} "back" finished_this_guid

  ; Has the user ticked the 'configure this account' check box ?

  !insertmacro MUI_INSTALLOPTIONS_READ ${L_TEMP} "ioB.ini" "Field 2" "State"
  StrCmp ${L_TEMP} "1" change_oe try_next_account

change_oe:
  ReadRegStr ${L_OEDATA} HKCU ${L_ACCOUNT} "POP3 User Name"
  ReadRegStr ${L_TEMP} HKCU ${L_ACCOUNT} "POP3 Server"

  ; To be able to restore the registry to previous settings when we uninstall we
  ; write a special file called popfile.reg containing the registry settings
  ; prior to modification in the form of lines consisting of
  ;
  ; the\key
  ; thesubkey
  ; the\value

  FileOpen  ${CFG} $INSTDIR\popfile.reg a
  FileSeek  ${CFG} 0 END
  FileWrite ${CFG} "${L_ACCOUNT}$\n"
  FileWrite ${CFG} "POP3 User Name$\n"
  FileWrite ${CFG} "${L_OEDATA}$\n"
  FileWrite ${CFG} "${L_ACCOUNT}$\n"
  FileWrite ${CFG} "POP3 Server$\n"
  FileWrite ${CFG} "${L_TEMP}$\n"
  FileClose ${CFG}

  WriteRegStr HKCU ${L_ACCOUNT} "POP3 User Name" "${L_TEMP}${L_SEPARATOR}${L_OEDATA}"
  WriteRegStr HKCU ${L_ACCOUNT} "POP3 Server" "127.0.0.1"

try_next_account:
  IntOp ${L_ACCT_INDEX} ${L_ACCT_INDEX} + 1
  goto next_acct

finished_this_guid:

  ; If no "Identity Ordinal" values were found then exit otherwise move on to the next identity

  StrCmp ${L_ORDINALS} "0" finished_oe_config

  IntOp ${L_GUID_INDEX} ${L_GUID_INDEX} + 1
  goto get_guid

finished_oe_config:

  Pop ${L_TEMP}
  Pop ${L_SEPARATOR}
  Pop ${L_ORDINALS}
  Pop ${L_OEPATH}
  Pop ${L_OEDATA}
  Pop ${L_IDENTITY}
  Pop ${L_GUID_INDEX}
  Pop ${L_GUID}
  Pop ${L_ACCT_INDEX}
  Pop ${L_ACCOUNT}

  !undef L_ACCOUNT
  !undef L_ACCT_INDEX
  !undef L_GUID
  !undef L_GUID_INDEX
  !undef L_IDENTITY
  !undef L_OEDATA
  !undef L_OEPATH
  !undef L_ORDINALS
  !undef L_SEPARATOR
  !undef L_TEMP

FunctionEnd

#--------------------------------------------------------------------------
# Installer Function: StartPOPFilePage (generates a custom page)
#
# This function offers to start the newly installed POPFile.
#
# A "leave" function (CheckLaunchOptions) is used to act upon the selections made by the user.
#--------------------------------------------------------------------------

Function StartPOPFilePage

  !insertmacro MUI_HEADER_TEXT "POPFile can now be started" \
               "The POPFile User Interface only works if POPFile has been started"

  !insertmacro MUI_INSTALLOPTIONS_DISPLAY "ioC.ini"

FunctionEnd

#--------------------------------------------------------------------------
# Installer Function: CheckLaunchOptions
# (the "leave" function for the custom page created by "StartPOPFilePage")
#
# This function is used to action the "start POPFile" options selected by the user.
# The user is allowed to return to this page and change their selections, so the
# previous state is stored in the INI file used for this custom page.
#--------------------------------------------------------------------------

Function CheckLaunchOptions

  !define L_RESULT      $R9
  !define L_TEMP        $R8

  Push ${L_RESULT}
  Push ${L_TEMP}

  ; Field 2 = 'Do not run POPFile' radio button

  !insertmacro MUI_INSTALLOPTIONS_READ ${L_TEMP} "ioC.ini" "Field 2" "State"
  StrCmp ${L_TEMP} "0" run_popfile

  !insertmacro MUI_INSTALLOPTIONS_READ ${L_TEMP} "ioC.ini" "Run Status" "LastAction"
  StrCmp ${L_TEMP} "" exit_without_banner
  StrCmp ${L_TEMP} "no" exit_without_banner
  !insertmacro MUI_INSTALLOPTIONS_WRITE "ioC.ini" "Run Status" "LastAction" "no"

  ; User has changed their mind: Shutdown the newly installed version of POPFile

  NSISdl::download_quiet http://127.0.0.1:${GUI}/shutdown "$PLUGINSDIR\shutdown.htm"
  Pop ${L_RESULT}    ; Get the return value (and ignore it)
  goto exit_without_banner

run_popfile:

  ; Field 4 = 'Run POPFile in background' radio button

  !insertmacro MUI_INSTALLOPTIONS_READ ${L_TEMP} "ioC.ini" "Field 4" "State"
  StrCmp ${L_TEMP} "1" run_in_background

  ; Run POPFile in a DOS box

  !insertmacro MUI_INSTALLOPTIONS_READ ${L_TEMP} "ioC.ini" "Run Status" "LastAction"
  StrCmp ${L_TEMP} "DOS-box" exit_without_banner
  !insertmacro MUI_INSTALLOPTIONS_WRITE "ioC.ini" "Run Status" "LastAction" "DOS-box"

  Banner::show /NOUNLOAD /set 76 "Preparing to start POPFile." "This may take a few seconds..."

  ; Before starting the newly installed POPFile, ensure that no other version of POPFile
  ; is running on the same UI port as the newly installed version.

  NSISdl::download_quiet http://127.0.0.1:${GUI}/shutdown "$PLUGINSDIR\shutdown.htm"
  Pop ${L_RESULT}    ; Get the return value (and ignore it)

  ExecShell "open" "$SMPROGRAMS\POPFile\Run POPFile.lnk"
  goto wait_for_popfile

run_in_background:

  ; Run POPFile without a DOS box

  !insertmacro MUI_INSTALLOPTIONS_READ ${L_TEMP} "ioC.ini" "Run Status" "LastAction"
  StrCmp ${L_TEMP} "background" exit_without_banner
  !insertmacro MUI_INSTALLOPTIONS_WRITE "ioC.ini" "Run Status" "LastAction" "background"

  Banner::show /NOUNLOAD /set 76 "Preparing to start POPFile." "This may take a few seconds..."

  ; Before starting the newly installed POPFile, ensure that no other version of POPFile
  ; is running on the same UI port as the newly installed version.

  NSISdl::download_quiet http://127.0.0.1:${GUI}/shutdown "$PLUGINSDIR\shutdown.htm"
  Pop ${L_RESULT}    ; Get the return value (and ignore it)

  ExecShell "open" "$SMPROGRAMS\POPFile\Run POPFile in background.lnk"

wait_for_popfile:

  ; Wait until POPFile is ready to display the UI (may take a second or so)

  StrCpy ${L_TEMP} 10   ; Timeout limit to avoid an infinite loop

check_if_ready:
  NSISdl::download_quiet http://127.0.0.1:${GUI} "$PLUGINSDIR\ui.htm"
  Pop ${L_RESULT}                        ; Did POPFile return an HTML page?
  StrCmp ${L_RESULT} "success" remove_banner
  Sleep 250   ; milliseconds
  IntOp ${L_TEMP} ${L_TEMP} - 1
  IntCmp ${L_TEMP} 0 remove_banner remove_banner check_if_ready

remove_banner:
  Banner::destroy

exit_without_banner:

  Pop ${L_TEMP}
  Pop ${L_RESULT}

  !undef L_RESULT
  !undef L_TEMP

FunctionEnd

#--------------------------------------------------------------------------
# Installer Function: CheckRunStatus
# (the "pre" function for the 'Finish' page)
#
# The 'Finish' page contains two CheckBoxes: one to control whether or not the installer
# starts the POPFile User Interface and one to control whether or not the 'ReadMe' file is
# displayed. The User Interface only works when POPFile is running, so we must ensure its
# CheckBox can only be ticked if the installer has started POPFile.
#--------------------------------------------------------------------------

Function CheckRunStatus

  !define L_TEMP        $R9

  Push ${L_TEMP}

  ; Field 4 is the 'Run' CheckBox on the 'Finish' page

  !insertmacro MUI_INSTALLOPTIONS_WRITE "ioSpecial.ini" "Field 4" "Flags" ""

  ; Get the status of the 'Do not run POPFile' radio button on the previous page of installer

  !insertmacro MUI_INSTALLOPTIONS_READ ${L_TEMP} "ioC.ini" "Field 2" "State"
  StrCmp ${L_TEMP} "0" selection_ok

  ; User has not started POPFile so we cannot offer to display the POPFile User Interface

  !insertmacro MUI_INSTALLOPTIONS_WRITE "ioSpecial.ini" "Field 4" "State" "0"
  !insertmacro MUI_INSTALLOPTIONS_WRITE "ioSpecial.ini" "Field 4" "Flags" "DISABLED"

selection_ok:
  Pop ${L_TEMP}

  !undef L_TEMP

FunctionEnd

#--------------------------------------------------------------------------
# Installer Function: RunUI
# (the "Run" function for the 'Finish' page)
#--------------------------------------------------------------------------

Function RunUI
  ExecShell "open" "http://127.0.0.1:${GUI}"
FunctionEnd

#--------------------------------------------------------------------------
# Installer Function: ShowReadMe
# (the "ReadMe" function for the 'Finish' page)
#--------------------------------------------------------------------------

Function ShowReadMe
  StrCmp ${NOTEPAD} "" use_file_association
  Exec 'notepad.exe "$INSTDIR\${README}"'
  goto exit
  
use_file_association:
  ExecShell "open" "$INSTDIR\${README}.txt"
  
exit:
FunctionEnd

#--------------------------------------------------------------------------
# Installer Function: GetSeparator
#
# Returns the character to be used as the separator when configuring an e-mail account.
# If the character is not defined in popfile.cfg, the default separator (':') is returned
#
# Inputs:
#         none
# Outputs:
#         (top of stack)     - character to be used as the separator
#
#  Usage:
#    Call GetSeparator
#    Pop $R0
#
#   ($R0 at this point is ":" unless popfile.cfg has altered the default setting)
#
#--------------------------------------------------------------------------

Function GetSeparator

  !define L_LNE         $R9   ; a line from the popfile.cfg file
  !define L_PARAM       $R8
  !define L_SEPARATOR   $R7   ; character used to separate the pop3 server from the username

  Push ${L_SEPARATOR}
  Push ${L_LNE}
  Push ${L_PARAM}

  StrCpy ${L_SEPARATOR} ""

  ClearErrors

  FileOpen  ${CFG} $INSTDIR\popfile.cfg r

loop:
  FileRead   ${CFG} ${L_LNE}
  IfErrors separator_done

  StrCpy ${L_PARAM} ${L_LNE} 10
  StrCmp ${L_PARAM} "separator " old_separator
  StrCpy ${L_PARAM} ${L_LNE} 15
  StrCmp ${L_PARAM} "pop3_separator " new_separator
  Goto loop

old_separator:
  StrCpy ${L_SEPARATOR} ${L_LNE} 1 10
  Goto loop

new_separator:
  StrCpy ${L_SEPARATOR} ${L_LNE} 1 15
  Goto loop

separator_done:
  Push ${L_SEPARATOR}
  Call TrimNewlines
  Pop ${L_SEPARATOR}

  ; Use separator character from popfile.cfg (if present) otherwise use a semicolon

  StrCmp ${L_SEPARATOR} "" 0 exit
  StrCpy ${L_SEPARATOR} ":"

exit:
  Pop ${L_PARAM}
  Pop ${L_LNE}
  Exch ${L_SEPARATOR}

  !undef L_LNE
  !undef L_PARAM
  !undef L_SEPARATOR

FunctionEnd

#--------------------------------------------------------------------------
# Installer Function: StrStr
#
# Search for matching string
#
# Inputs:
#         (top of stack)     - the string to be found (needle)
#         (top of stack - 1) - the string to be searched (haystack)
# Outputs:
#         (top of stack)     - string starting with the match, if any
#
#  Usage:
#    Push "this is a long string"
#    Push "long"
#    Call StrStr
#    Pop $R0
#   ($R0 at this point is "long string")
#
#--------------------------------------------------------------------------

Function StrStr
  Exch $R1    ; Make $R1 the "needle", Top of stack = old$R1, haystack
  Exch        ; Top of stack = haystack, old$R1
  Exch $R2    ; Make $R2 the "haystack", Top of stack = old$R2, old$R1

  Push $R3    ; Length of the needle
  Push $R4    ; Counter
  Push $R5    ; Temp

  StrLen $R3 $R1
  StrCpy $R4 0

loop:
  StrCpy $R5 $R2 $R3 $R4
  StrCmp $R5 $R1 done
  StrCmp $R5 "" done
  IntOp $R4 $R4 + 1
  Goto loop

done:
  StrCpy $R1 $R2 "" $R4

  Pop $R5
  Pop $R4
  Pop $R3

  Pop $R2
  Exch $R1
FunctionEnd

#--------------------------------------------------------------------------
# Macro: StrCheckDecimal
#
# The installation process and the uninstall process both use a function which checks if
# a given string contains a decimal number. This macro makes maintenance easier by ensuring
# that both processes use identical functions, with the only difference being their names.
#
# The 'StrCheckDecimal' and 'un.StrCheckDecimal' functions check that a given string contains
# only the digits 0 to 9. (if the string contains any invalid characters, "" is returned)
#
# Inputs:
#         (top of stack)   - string which may contain a decimal number
#
# Outputs:
#         (top of stack)   - the input string (if valid) or "" (if invalid)
#
# Usage:
#         Push "12345"
#         Call StrCheckDecimal
#         Pop $R0
#         ($R0 at this point is "12345")
#
#--------------------------------------------------------------------------
!macro StrCheckDecimal UN
  Function ${UN}StrCheckDecimal

    !define DECIMAL_DIGIT    "0123456789"

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
    StrCpy $4 $5 1 $3             ; Extract next "valid" character (from "validity check" string)
    StrCmp $2 $4 0 next_valid_char
    IntCmp $3 10 invalid 0 invalid  ; If match is with the char we added, input string is bad
    StrCpy $1 $1$4                ; Add "valid" character to the result
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

  FunctionEnd
!macroend

#--------------------------------------------------------------------------
# Installer Function: StrCheckDecimal
#
# This function is used during the installation process
#--------------------------------------------------------------------------

!insertmacro StrCheckDecimal ""

#--------------------------------------------------------------------------
# Uninstaller Function: un.StrCheckDecimal
#
# This function is used during the uninstall process
#--------------------------------------------------------------------------

!insertmacro StrCheckDecimal "un."

#--------------------------------------------------------------------------
# Macro: TrimNewlines
#
# The installation process and the uninstall process both
# use a function which trims newlines from lines of text.
# This macro makes maintenance easier by ensuring that
# both processes use identical functions, with the only
# difference being their names.
#--------------------------------------------------------------------------

  ; input, top of stack  (e.g. whatever$\r$\n)
  ; output, top of stack (replaces, with e.g. whatever)
  ; modifies no other variables.

!macro TrimNewlines UN
  Function ${UN}TrimNewlines
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
!macroend

#--------------------------------------------------------------------------
# Installer Function: TrimNewlines
#
# This function is used during the installation process
#--------------------------------------------------------------------------

!insertmacro TrimNewlines ""

#--------------------------------------------------------------------------
# Uninstaller Function: un.TrimNewlines
#
# This function is used during the uninstall process
#--------------------------------------------------------------------------

!insertmacro TrimNewlines "un."

#--------------------------------------------------------------------------
# Uninstaller Section
#--------------------------------------------------------------------------

Section "Uninstall"

  !define L_LNE         $R4
  !define L_REG_KEY     $R5
  !define L_REG_SUBKEY  $R6
  !define L_REG_VALUE   $R7
  !define L_TEMP        $R8

  IfFileExists $INSTDIR\popfile.pl skip_confirmation
    MessageBox MB_YESNO "It does not appear that POPFile is installed in the \
        directory '$INSTDIR'.$\r$\nContinue anyway (not recommended)" IDYES skip_confirmation
    Abort "Uninstall aborted by user"

skip_confirmation:

  ; If the POPFile we are about to uninstall is still running,
  ; then one of the EXE files will be 'locked'

  IfFileExists "$INSTDIR\wperl.exe" 0 other_perl
  SetFileAttributes "$INSTDIR\wperl.exe" NORMAL
  ClearErrors
  FileOpen ${CFG} "$INSTDIR\wperl.exe" a
  FileClose ${CFG}
  IfErrors attempt_shutdown
  
other_perl:
  IfFileExists "$INSTDIR\perl.exe" 0 skip_shutdown
  SetFileAttributes "$INSTDIR\perl.exe" NORMAL
  ClearErrors
  FileOpen ${CFG} "$INSTDIR\perl.exe" a
  FileClose ${CFG}
  IfErrors 0 skip_shutdown

attempt_shutdown:
  ClearErrors
  FileOpen ${CFG} $INSTDIR\popfile.cfg r

loop:
  FileRead ${CFG} ${L_LNE}
  IfErrors done

  StrCpy ${L_TEMP} ${L_LNE} 10
  StrCmp ${L_TEMP} "html_port " got_html_port
  Goto loop

got_html_port:
  StrCpy ${GUI} ${L_LNE} 5 10
  Goto loop

done:
  FileClose ${CFG}

  Push ${GUI}
  Call un.TrimNewlines
  Call un.StrCheckDecimal
  Pop ${GUI}
  StrCmp ${GUI} "" skip_shutdown
  DetailPrint "Shutting down POPFile using port ${GUI}"
  NSISdl::download_quiet http://127.0.0.1:${GUI}/shutdown "$PLUGINSDIR\shutdown.htm"
  Pop ${L_TEMP}

skip_shutdown:
  Delete $SMPROGRAMS\POPFile\Support\*.url
  RMDir $SMPROGRAMS\POPFile\Support

  Delete $SMPROGRAMS\POPFile\*.lnk
  Delete $SMPROGRAMS\POPFile\*.url
  Delete "$SMSTARTUP\Run POPFile in background.lnk"
  RMDir $SMPROGRAMS\POPFile

  Delete $INSTDIR\*.log
  Delete $INSTDIR\*.pl
  Delete $INSTDIR\*.gif
  Delete $INSTDIR\*.pm
  Delete $INSTDIR\*.exe
  Delete $INSTDIR\*.dll
  Delete $INSTDIR\*.change
  Delete $INSTDIR\*.change.txt
  Delete $INSTDIR\license
  Delete $INSTDIR\popfile.cfg

  IfFileExists "$INSTDIR\popfile.reg" 0 no_reg_file
  
  ; Read the registry settings found in popfile.reg and restore them
  ; it there are any.   All are assumed to be in HKCU
  
  ClearErrors
  FileOpen ${CFG} $INSTDIR\popfile.reg r
  IfErrors skip_registry_restore
  DetailPrint "Opened: popfile.reg"
  
restore_loop:
  FileRead ${CFG} ${L_REG_KEY}
  Push ${L_REG_KEY}
  Call un.TrimNewlines
  Pop ${L_REG_KEY}
  IfErrors skip_registry_restore
  FileRead ${CFG} ${L_REG_SUBKEY}
  Push ${L_REG_SUBKEY}
  Call un.TrimNewlines
  Pop ${L_REG_SUBKEY}
  IfErrors skip_registry_restore
  FileRead ${CFG} ${L_REG_VALUE}
  Push ${L_REG_VALUE}
  Call un.TrimNewlines
  Pop ${L_REG_VALUE}
  IfErrors skip_registry_restore
  WriteRegStr HKCU ${L_REG_KEY} ${L_REG_SUBKEY} ${L_REG_VALUE}
  DetailPrint "Restored ${L_REG_SUBKEY}: ${L_REG_VALUE}"
  goto restore_loop

skip_registry_restore:
  FileClose ${CFG}
  DetailPrint "Closed: popfile.reg"
  Delete $INSTDIR\popfile.reg

no_reg_file:
  Delete $INSTDIR\Platform\*.pm
  Delete $INSTDIR\Platform\*.dll
  RMDir $INSTDIR\Platform
  Delete $INSTDIR\Proxy\*.pm
  RMDir $INSTDIR\Proxy
  Delete $INSTDIR\UI\*.pm
  RMDir $INSTDIR\UI
  Delete $INSTDIR\POPFile\*.pm
  RMDir $INSTDIR\POPFile
  Delete $INSTDIR\Classifier\*.pm
  RMDir $INSTDIR\Classifier
  Delete $INSTDIR\Exporter\*.*
  RMDir $INSTDIR\Exporter
  Delete $INSTDIR\skins\*.css
  Delete $INSTDIR\skins\*.gif
  Delete $INSTDIR\skins\lavishImages\*.gif
  Delete $INSTDIR\skins\sleetImages\*.gif
  RMDir $INSTDIR\skins\sleetImages
  RMDir $INSTDIR\skins\lavishImages
  RMDir $INSTDIR\skins
  Delete $INSTDIR\manual\en\*.html
  RMDir $INSTDIR\manual\en
  Delete $INSTDIR\manual\*.gif
  RMDir $INSTDIR\manual
  Delete $INSTDIR\languages\*.msg
  RMDir $INSTDIR\languages
  RMDir /r $INSTDIR\corpus
  Delete $INSTDIR\stopwords
  RMDir /r $INSTDIR\messages

  Delete $INSTDIR\Win32\API\*
  RmDir /r $INSTDIR\Win32\API
  Delete $INSTDIR\Win32\*
  RmDir /r $INSTDIR\Win32
  Delete $INSTDIR\auto\Win32\API\*
  RmDir /r $INSTDIR\auto\Win32\API
  Delete $INSTDIR\MIME\*.*
  RMDir  $INSTDIR\MIME
  Delete $INSTDIR\IO\*.*
  Delete $INSTDIR\IO\Socket\*.*
  RMDir /r $INSTDIR\IO
  Delete $INSTDIR\Carp\*.*
  RMDir /r $INSTDIR\Carp
  Delete $INSTDIR\Sys\Hostname\*.*
  RMDir /r $INSTDIR\Sys\Hostname
  RMDir /r $INSTDIR\Sys
  Delete $INSTDIR\Text\*.pm
  RMDir /r $INSTDIR\Text
  Delete $INSTDIR\auto\POSIX\*.*
  Delete $INSTDIR\auto\DynaLoader\*.*
  Delete $INSTDIR\auto\File\Glob\*.*
  Delete $INSTDIR\auto\MIME\Base64\*.*
  Delete $INSTDIR\auto\IO\*.*
  Delete $INSTDIR\auto\Socket\*.*
  Delete $INSTDIR\auto\Sys\*.*
  RMDir /r $INSTDIR\auto
  Delete $INSTDIR\File\*.*
  RMDir $INSTDIR\File
  Delete $INSTDIR\warnings\*.*
  RMDir $INSTDIR\warnings

  Delete "$INSTDIR\Uninstall.exe"

  RMDir $INSTDIR

  DeleteRegKey HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${MUI_PRODUCT}"
  DeleteRegKey HKLM SOFTWARE\POPFile

  ; if $INSTDIR was removed, skip these next ones
  
  IfFileExists $INSTDIR 0 Removed
    MessageBox MB_YESNO|MB_ICONQUESTION \
      "Do you want to remove all files in your POPFile directory? (If you have anything \
      you created that you want to keep, click No)" IDNO Removed
    DetailPrint "Removing all files from POPFile directory"
    Delete $INSTDIR\*.* ; this would be skipped if the user hits no
    RMDir /r $INSTDIR
    IfFileExists $INSTDIR 0 Removed
      DetailPrint "Note: unable to remove all files from POPFile directory"
      MessageBox MB_OK|MB_ICONEXCLAMATION \
                 "Note: $INSTDIR could not be removed."
Removed:

  !undef L_LNE
  !undef L_REG_KEY
  !undef L_REG_SUBKEY
  !undef L_REG_VALUE
  !undef L_TEMP
SectionEnd

#--------------------------------------------------------------------------
# End of 'installer.nsi'
#--------------------------------------------------------------------------
