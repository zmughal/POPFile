#--------------------------------------------------------------------------
#
# addssl.nsi --- This is the NSIS script used to create a utility which installs
#                SSL support for an existing POPFile 0.22.0 (or later) installation.
#
#                The Windows installer for POPFile 0.22.3 (or later) is able to download
#                and install SSL support. If any patches need to be applied to make the
#                SSL files work with POPFile these will be downloaded from the POPFile
#                website and applied by the 0.22.5 or later installers.
#
#                Normally SSL support is downloaded at the same time that POPFile is
#                installed, but SSL support can be added or updated after installation
#                by using the "Add/Remove Programs" entry for POPFile 1.0.0 or later.
#                For POPFile 0.22.3, 0.22.4 or 0.22.5 SSL support can be added or updated
#                later by using the command "setup.exe /SSL" to run the installer.
#
#                Normally the SSL support files are downloaded from the University of
#                Winnipeg repository. However these files are no longer compatible with
#                the minimal Perl shipped with POPFile 0.22.0, 0.22.1 or 0.22.2 so this
#                utility includes a set of compatible SSL files which will be installed
#                instead. The minimal Perl's version number (obtained from the 'perl58.dll'
#                file) is used to determine the action to be taken.
#
#                As a temporary workaround to cope with future "SSL compatibility" issues
#                the command-line option /BUILTIN forces the wizard to install the old SSL
#                files which are normally only used with POPFile 0.22.0, 0.22.1 and 0.22.3.
#
#                The version of Module.pm distributed with POPFile 0.22.0 results in extremely
#                slow message downloads (e.g. 6 minutes for a 2,713 byte msg) so this utility
#                will apply a patch to update Module.pm v1.40 to v1.41 (the original file will
#                be backed up as Module.pm.bk1). The patch is only applied if v1.40 is found.
#
#                An 'include' file (getssl.nsh) is used to ensure this utility and the main
#                POPFile installer download and install the same SSL support files and any
#                necessary SSL patches.
#
# Copyright (c) 2004-2009 John Graham-Cumming
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

  ;------------------------------------------------
  ; This script requires the 'DumpLog' NSIS plugin
  ;------------------------------------------------

  ; This script uses a special NSIS plugin (DumpLog) to save the installation log to a file.
  ; This plugin is much faster than the 'Dump Content of Log Window to File' function shown
  ; in the NSIS Users Manual (see section D.4 in Appendix D of the manual for NSIS 2.22).
  ;
  ; The 'NSIS Wiki' page for the 'DumpLog' plugin (description, example and download links):
  ; http://nsis.sourceforge.net/DumpLog_plug-in
  ;
  ; To compile this script, copy the 'DumpLog.dll' file to the standard NSIS plugins folder
  ; (${NSISDIR}\Plugins\). The 'DumpLog' source and example files can be unzipped to the
  ; appropriate ${NSISDIR} sub-folders if you wish, but this step is entirely optional.
  ;
  ; Tested with version 1.0 of the DumpLog.dll plugin.

  ;------------------------------------------------
  ; This script requires the 'Inetc' NSIS plugin
  ;------------------------------------------------

  ; This script uses a special NSIS plugin (inetc) to download the SSL files. This plugin
  ; has much better proxy support than the standard NSISdl plugin shipped with NSIS.
  ;
  ; The 'NSIS Wiki' page for the 'Inetc' plugin (description, example and download links):
  ; http://nsis.sourceforge.net/Inetc_plug-in
  ;
  ; To compile this script, copy the 'inetc.dll' file to the standard NSIS plugins folder
  ; (${NSISDIR}\Plugins\). The 'Inetc' source and example files can be unzipped to the
  ; appropriate ${NSISDIR} sub-folders if you wish, but this step is entirely optional.
  ;
  ; Tested with the inetc.dll plugin timestamped 15 July 2008 16:04:42

  ;------------------------------------------------
  ; This script requires the 'md5dll' NSIS plugin
  ;------------------------------------------------

  ; This script uses a special NSIS plugin (md5dll) to calculate the MD5 sum for a file.
  ;
  ; The 'NSIS Wiki' page for the 'md5dll' plugin (description, example and download links):
  ; http://nsis.sourceforge.net/MD5_plugin
  ;
  ; Alternative download links can be found at the 'md5dll' author's site:
  ; http://www.darklogic.org/win32/nsis/plugins/md5dll/
  ;
  ; To compile this script, copy the 'md5dll.dll' file to the standard NSIS plugins folder
  ; (${NSISDIR}\Plugins\). The 'md5dll' source and example files can be unzipped to the
  ; appropriate ${NSISDIR} sub-folders if you wish, but this step is entirely optional.
  ;
  ; Tested with version 0.4 of the 'md5dll' plugin.

  ;------------------------------------------------
  ; This script requires the 'untgz' NSIS plugin
  ;------------------------------------------------

  ; This script uses a special NSIS plugin (untgz) to extract files from the *.tar.gz archives.
  ;
  ; The 'NSIS Wiki' page for the 'untgz' plugin (description, example and download links):
  ; http://nsis.sourceforge.net/UnTGZ_plug-in
  ;
  ; Alternative download links can be found at the 'untgz' author's site:
  ; http://www.darklogic.org/win32/nsis/plugins/
  ;
  ; To compile this script, copy the 'untgz.dll' file to the standard NSIS plugins folder
  ; (${NSISDIR}\Plugins\). The 'untgz' source and example files can be unzipped to the
  ; appropriate ${NSISDIR} sub-folders if you wish, but this step is entirely optional.
  ;
  ; Tested with versions 1.0.5, 1.0.6, 1.0.7 and 1.0.8 of the 'untgz' plugin.

  ;------------------------------------------------
  ; POPFile 0.22.x Compatibility Problem
  ;------------------------------------------------

  ; With effect from 22 June 2005 the SSL components in the University of Winnipeg repository
  ; are no longer compatible with POPFile 0.22.0, 0.22.1 or 0.22.2 because the files have been
  ; updated to work with ActivePerl 5.8.7 Build 813. POPFile 0.22.0 and 0.22.1 use a minimal
  ; Perl based upon ActivePerl 5.8.3 Build 809 and 0.22.2 uses a minimal Perl based upon 5.8.4
  ; Build 810. These minimal Perl systems will crash when attempting to use the University of
  ; Winnipeg SSL files.
  ;
  ; In order to support POPFile 0.22.0, 0.22.1 and 0.22.2 the wizard includes an older set of
  ; SSL files which were downloaded from the University of Winnipeg repository in January 2005.
  ; In order to simplify the code, the normal Internet download operation is replaced by "File"
  ; commands which store the old SSL files in the folder used to hold the downloaded files;
  ; these old files can then be handled as if they had been downloaded from the University of
  ; Winnipeg.
  ;
  ; The following local SSL files are compatible with POPFile 0.22.0, 0.22.1 and 0.22.2:
  ;
  ;   (1) ssl-0.22.x\IO-Socket-SSL.tar.gz             (dated 01-Aug-2003)
  ;   (2) ssl-0.22.x\Net_SSLeay.pm.tar.gz             (dated 23-Dec-2004)
  ;   (3) ssl-0.22.x\libeay32.dll                     (dated 23-Dec-2004)
  ;   (4) ssl-0.22.x\ssleay32.dll                     (dated 23-Dec-2004)
  ;
  ; POPFile 0.22.3 and 0.22.4 are based upon ActivePerl 5.8.7 (Builds 813 & 815 respectively).
  ; Up until 18 July 2006 it was safe for POPFile 0.22.3 and 0.22.4 to use the latest versions
  ; of the SSL files.
  ;
  ; At present (14 February 2008) the University of Winnipeg repository supplies a version of
  ; 'IO::Socket::SSL' which is not compatible with POPFile 0.22.4 or earlier so a patch is
  ; applied to downgrade the file to make it POPFile-compatible. See the ..\getssl.nsh INCLUDE
  ; file for details.

  ;------------------------------------------------
  ; How the Module.pm patch was created
  ;------------------------------------------------

  ; The patch used to update Module.pm v1.40 to v1.41 was created using the VPATCH package
  ; which is supplied with NSIS. The command used to create the patch was:
  ;
  ;   GenPat.exe Module.pm Module_ssl.pm Module_ssl.pat
  ;
  ; where Module.pm was CVS version 1.40 and Module_ssl.pm was CVS version 1.41.

#--------------------------------------------------------------------------
# Optional run-time command-line switch (used by 'addssl.exe')
#--------------------------------------------------------------------------
#
# /BUILTIN
#
# For POPFile 0.22.3 (and later) releases this wizard will download and, if necessary, patch
# the SSL support files from the University of Winnipeg repository. However there will always
# be some delay between the repository being updated with SSL files which are not compatible
# with POPFile and the generation of an updated version of the SSL patches (or this wizard).
#
# The /BUILTIN switch provides an easy way to force the installation of the old SSL support
# files normally used only for the POPFile 0.22.0, 0.22.1 and 0.22.2 releases as a workaround
# until the SSL patches (or this wizard) can be updated to handle the new SSL support files.
#
# To force the installation of the old SSL support files use the following command:
#
#   addssl.exe /BUILTIN
#
# (the option is not case-sensitive so the command 'addssl.exe /builtin' can be used instead)
#--------------------------------------------------------------------------

#--------------------------------------------------------------------------
# Language Support NSIS Compiler Warnings
#--------------------------------------------------------------------------
#
# Normally no NSIS compiler warnings are expected. However there may be some warnings
# which mention "PFI_LANG_NSISDL_PLURAL" is not set in one or more language tables.
#
# These "PFI_LANG_NSISDL_PLURAL" warnings can be safely ignored (at present only the
# 'Japanese-pfi.nsh' file generates this warning).
#
#--------------------------------------------------------------------------

#--------------------------------------------------------------------------
# Compile-time command-line switches (used by 'makensis.exe')
#--------------------------------------------------------------------------
#
# /DENGLISH_MODE
#
# To build an 'SSL Setup' wizard that only displays English messages (so there is no need to
# ensure all of the non-English *-pfi.nsh files are up-to-date), supply the command-line
# switch /DENGLISH_MODE when compiling this script.
#
#--------------------------------------------------------------------------

  ;------------------------------------------------
  ; Define PFI_VERBOSE to get more compiler output
  ;------------------------------------------------

## !define PFI_VERBOSE

  ;--------------------------------------------------------------------------
  ; Select "Solid" LZMA compression (to generate smallest EXE file)
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

  ; This build is for use with the POPFile installer-created installations

  !define C_PFI_PRODUCT  "POPFile"

  Name                   "POPFile SSL Setup"

  !define C_PFI_VERSION  "0.3.9"

  ; Mention the wizard's version number in the window title

  Caption                "POPFile SSL Setup v${C_PFI_VERSION}"

  ; Name to be used for the program file (also used for the 'Version Information')

  !define C_OUTFILE      "addssl.exe"

  ;--------------------------------------------------------------------------
  ; Windows Vista expects to find a manifest specifying the execution level
  ;--------------------------------------------------------------------------

  RequestExecutionLevel   admin

#--------------------------------------------------------------------------
# User Registers (Global)
#--------------------------------------------------------------------------

  ; This script uses 'User Variables' (with names starting with 'G_') to hold GLOBAL data.

  Var G_ROOTDIR            ; full path to the folder used for the POPFile program files
  Var G_MPLIBDIR           ; full path to the folder used for most of the minimal Perl files

  Var G_PLS_FIELD_1        ; used to customize some language strings

  ; NSIS provides 20 general purpose user registers:
  ; (a) $R0 to $R9   are used as local registers
  ; (b) $0 to $9     are used as additional local registers

  ; Local registers referred to by 'defines' use names starting with 'L_' (eg L_LNE, L_OLDUI)
  ; and the scope of these 'defines' is limited to the "routine" where they are used.

  ; In earlier versions of the NSIS compiler, 'User Variables' did not exist, and the convention
  ; was to use $R0 to $R9 as 'local' registers and $0 to $9 as 'global' ones. This is why this
  ; script uses registers $R0 to $R9 in preference to registers $0 to $9.

  ; POPFile constants have been given names beginning with 'C_' (eg C_README)
  ; except for 'IO_NL' and 'MB_NL' which are used when assembling multi-line strings


#--------------------------------------------------------------------------
# Use the "Modern User Interface"
#--------------------------------------------------------------------------

  !include "MUI.nsh"


#--------------------------------------------------------------------------
# Include private library functions and macro definitions
#--------------------------------------------------------------------------

  ; Avoid compiler warnings by disabling the functions and definitions we do not use

  !define ADDSSL

  !include "..\pfi-library.nsh"
  !include "..\WriteEnvStr.nsh"


#--------------------------------------------------------------------------
# Version Information settings (for the wizard's EXE file)
#--------------------------------------------------------------------------

  ; 'VIProductVersion' format is X.X.X.X where X is a number in range 0 to 65535
  ; representing the following values: Major.Minor.Release.Build

  VIProductVersion                          "${C_PFI_VERSION}.0"

  !define /date C_BUILD_YEAR                "%Y"

  VIAddVersionKey "ProductName"             "POPFile SSL Setup wizard"
  VIAddVersionKey "Comments"                "POPFile Homepage: http://getpopfile.org/"
  VIAddVersionKey "CompanyName"             "The POPFile Project"
  VIAddVersionKey "LegalTrademarks"         "POPFile is a registered trademark of John Graham-Cumming"
  VIAddVersionKey "LegalCopyright"          "Copyright (c) ${C_BUILD_YEAR}  John Graham-Cumming"
  VIAddVersionKey "FileDescription"         "Installs SSL support for POPFile 0.22 or later"
  VIAddVersionKey "FileVersion"             "${C_PFI_VERSION}"
  VIAddVersionKey "OriginalFilename"        "${C_OUTFILE}"

  !ifndef ENGLISH_MODE
    VIAddVersionKey "Build"                 "Multi-Language"
  !else
    VIAddVersionKey "Build"                 "English-Mode"
  !endif

  VIAddVersionKey "Build Compiler"          "NSIS ${NSIS_VERSION}"
  VIAddVersionKey "Build Date/Time"         "${__DATE__} @ ${__TIME__}"
  !ifdef C_PFI_LIBRARY_VERSION
    VIAddVersionKey "Build Library Version" "${C_PFI_LIBRARY_VERSION}"
  !endif
  VIAddVersionKey "Build Script"            "${__FILE__}${MB_NL}(${__TIMESTAMP__})"


#--------------------------------------------------------------------------
# Configure the MUI pages
#--------------------------------------------------------------------------

  ;----------------------------------------------------------------
  ; Interface Settings - General Interface Settings
  ;----------------------------------------------------------------

  !define MUI_ICON                            "..\POPFileIcon\popfile.ico"

  ; The "Header" bitmap appears on all pages of the wizard (except Welcome & Finish pages)

  !define MUI_HEADERIMAGE
  !define MUI_HEADERIMAGE_BITMAP              "hdr-update.bmp"
  !define MUI_HEADERIMAGE_RIGHT

  ;----------------------------------------------------------------
  ;  Interface Settings - Interface Resource Settings
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
  ;  Interface Settings - Welcome/Finish Page Interface Settings
  ;----------------------------------------------------------------

  ; The "Special" bitmap appears on the "Welcome" and "Finish" pages

  !define MUI_WELCOMEFINISHPAGE_BITMAP        "special-update.bmp"

  ;----------------------------------------------------------------
  ;  Interface Settings - Installer Finish Page Interface Settings
  ;----------------------------------------------------------------

  ; Debug aid: The log window shows progress messages

#  ShowInstDetails show
  !define MUI_FINISHPAGE_NOAUTOCLOSE

  ;----------------------------------------------------------------
  ;  Interface Settings - Abort Warning Settings
  ;----------------------------------------------------------------

  ; Show a message box with a warning when the user closes the wizard before it has finished

  !define MUI_ABORTWARNING
  !define MUI_ABORTWARNING_TEXT               "$(PSS_LANG_ABORT_WARNING)"

  ;----------------------------------------------------------------
  ; Customize MUI - General Custom Function
  ;----------------------------------------------------------------

  ; Use a custom '.onGUIInit' function to permit language-specific error messages
  ; (the user-selected language is not available for use in the .onInit function)

  !define MUI_CUSTOMFUNCTION_GUIINIT          PFIGUIInit

  ;----------------------------------------------------------------
  ; Language Settings for MUI pages
  ;----------------------------------------------------------------

  ; Override the standard "Installer Language" title to avoid confusion.

  !define MUI_LANGDLL_WINDOWTITLE             "SSL Setup"

  ; Use the language selected when POPFile was last installed or updated
  ; (if the language setting is not found, the user will be asked to select a language)

  !define MUI_LANGDLL_REGISTRY_ROOT           "HKCU"
  !define MUI_LANGDLL_REGISTRY_KEY            "SOFTWARE\POPFile Project\${C_PFI_PRODUCT}\MRI"
  !define MUI_LANGDLL_REGISTRY_VALUENAME      "Installer Language"


#--------------------------------------------------------------------------
# Define the Page order for the wizard
#--------------------------------------------------------------------------

  ;---------------------------------------------------
  ; Installer Page - Welcome
  ;---------------------------------------------------

  !define MUI_WELCOMEPAGE_TITLE                   "$(PSS_LANG_WELCOME_TITLE)"
  !define MUI_WELCOMEPAGE_TEXT                    "$(PSS_LANG_WELCOME_TEXT)"

  !insertmacro MUI_PAGE_WELCOME

  ;---------------------------------------------------
  ; Installer Page - License Page (uses English GPL)
  ;---------------------------------------------------

  !define MUI_LICENSEPAGE_CHECKBOX
  !define MUI_PAGE_HEADER_SUBTEXT                 "$(PSS_LANG_LICENSE_SUBHDR)"
  !define MUI_LICENSEPAGE_TEXT_BOTTOM             "$(PSS_LANG_LICENSE_BOTTOM)"

  !insertmacro MUI_PAGE_LICENSE                   "license.gpl"

  ;---------------------------------------------------
  ; Installer Page - Select installation Directory
  ;---------------------------------------------------

  ; Use a "pre" function to look for a registry entry for the 0.22.x version of POPFile
  ; (this build is intended for use with POPFile 0.22.x)

  !define MUI_PAGE_CUSTOMFUNCTION_PRE             "CheckForExistingInstallation"

  ; Use a "leave" function to check that the user has selected an appropriate folder

  !define MUI_PAGE_CUSTOMFUNCTION_LEAVE           "CheckInstallDir"

  ; This page is used to select the folder where the POPFile PROGRAM files can be found
  ; (we use this to generate the installation path for the POPFile SSL support files)

  !define MUI_PAGE_HEADER_TEXT                    "$(PSS_LANG_DESTNDIR_TITLE)"
  !define MUI_PAGE_HEADER_SUBTEXT                 "$(PSS_LANG_DESTNDIR_SUBTITLE)"
  !define MUI_DIRECTORYPAGE_TEXT_TOP              "$(PSS_LANG_DESTNDIR_TEXT_TOP)"
  !define MUI_DIRECTORYPAGE_TEXT_DESTINATION      "$(PSS_LANG_DESTNDIR_TEXT_DESTN)"

  !insertmacro MUI_PAGE_DIRECTORY

  ;---------------------------------------------------
  ; Installer Page - Install files
  ;---------------------------------------------------

  ; Override the standard "Installing..." page header

  !define MUI_PAGE_HEADER_TEXT                    "$(PSS_LANG_STD_HDR)"
  !define MUI_PAGE_HEADER_SUBTEXT                 "$(PSS_LANG_STD_SUBHDR)"

  ; Override the standard "Installation complete..." page header

  !define MUI_INSTFILESPAGE_FINISHHEADER_TEXT     "$(PSS_LANG_END_HDR)"
  !define MUI_INSTFILESPAGE_FINISHHEADER_SUBTEXT  "$(PSS_LANG_END_SUBHDR)"

  ; Override the standard "Installation Aborted..." page header

  !define MUI_INSTFILESPAGE_ABORTHEADER_TEXT      "$(PSS_LANG_ABORT_HDR)"
  !define MUI_INSTFILESPAGE_ABORTHEADER_SUBTEXT   "$(PSS_LANG_ABORT_SUBHDR)"

  !insertmacro MUI_PAGE_INSTFILES

  ;---------------------------------------------------
  ; Installer Page - Finish
  ;---------------------------------------------------

  !define MUI_FINISHPAGE_TITLE                    "$(PSS_LANG_FINISH_TITLE)"
  !define MUI_FINISHPAGE_TEXT                     "$(PSS_LANG_FINISH_TEXT)"

  !define MUI_FINISHPAGE_SHOWREADME               "$G_ROOTDIR\addssl.txt"
  !define MUI_FINISHPAGE_SHOWREADME_TEXT          "$(PSS_LANG_FINISH_README)"

  !insertmacro MUI_PAGE_FINISH


#--------------------------------------------------------------------------
# Language Support for the utility
#--------------------------------------------------------------------------

  ;-----------------------------------------
  ; Select the languages to be supported by the wizard
  ;-----------------------------------------

  ; At least one language must be specified for the wizard (the default is "English")

  !insertmacro PFI_LANG_LOAD "English" "-"

  ; Conditional compilation: if ENGLISH_MODE is defined, support only 'English'

  !ifndef ENGLISH_MODE
      !include "..\pfi-languages.nsh"
  !endif


#--------------------------------------------------------------------------
# General settings
#--------------------------------------------------------------------------

  ; Specify NSIS output filename

  OutFile "${C_OUTFILE}"

  ; Ensure CRC checking cannot be turned off using the /NCRC command-line switch

  CRCcheck Force

#--------------------------------------------------------------------------
# Default Destination Folder
#--------------------------------------------------------------------------

  InstallDir "$PROGRAMFILES\${C_PFI_PRODUCT}\"

#--------------------------------------------------------------------------
# Reserve the files required by the wizard (to improve performance)
#--------------------------------------------------------------------------

  ; Things that need to be extracted on startup (keep these lines before any File command!)
  ; Only useful when solid compression is used (by default, solid compression is enabled
  ; for BZIP2 and LZMA compression)

  !insertmacro MUI_RESERVEFILE_LANGDLL
  !insertmacro MUI_RESERVEFILE_INSTALLOPTIONS
  ReserveFile "${NSISDIR}\Plugins\DumpLog.dll"
  ReserveFile "${NSISDIR}\Plugins\inetc.dll"
  ReserveFile "${NSISDIR}\Plugins\LockedList.dll"
  ReserveFile "${NSISDIR}\Plugins\md5dll.dll"
  ReserveFile "${NSISDIR}\Plugins\NSISdl.dll"
  ReserveFile "${NSISDIR}\Plugins\SimpleSC.dll"
  ReserveFile "${NSISDIR}\Plugins\System.dll"
  ReserveFile "${NSISDIR}\Plugins\untgz.dll"
  ReserveFile "${NSISDIR}\Plugins\vpatch.dll"


#--------------------------------------------------------------------------
# Installer Function: .onInit - the wizard starts by offering a choice of languages
#--------------------------------------------------------------------------

Function .onInit

  ; Conditional compilation: if ENGLISH_MODE is defined, support only 'English'

  !ifndef ENGLISH_MODE
        !insertmacro MUI_LANGDLL_DISPLAY
  !endif

FunctionEnd


#--------------------------------------------------------------------------
# Installer Function: PFIGUIInit
# (custom .onGUIInit function)
#
# Used to complete the initialization of the wizard.
# This code was moved from '.onInit' in order to permit the use of language-specific strings
# (the selected language is not available inside the '.onInit' function)
#--------------------------------------------------------------------------

Function PFIGUIInit

  !define L_RESERVED         $1    ; used in the system.dll call

  Push ${L_RESERVED}

  ; Ensure only one copy of this wizard (or any other POPFile installer) is running

  System::Call 'kernel32::CreateMutexA(i 0, i 0, t "OnlyOnePFI_mutex") i .r1 ?e'
  Pop ${L_RESERVED}
  StrCmp ${L_RESERVED} 0 mutex_ok
  MessageBox MB_OK|MB_ICONEXCLAMATION "$(PSS_LANG_MUTEX)"
  Abort

mutex_ok:
  Pop ${L_RESERVED}

  !undef L_RESERVED

FunctionEnd


#--------------------------------------------------------------------------
# Installer Section: Prepare to download and install the SSL Support files
#--------------------------------------------------------------------------

Section "-prepare"

  SetDetailsPrint textonly
  DetailPrint "$(PFI_LANG_INST_PROG_UPGRADE) $(PFI_LANG_TAKE_A_FEW_SECONDS)"
  SetDetailsPrint listonly

  DetailPrint "----------------------------------------------------"
  DetailPrint "POPFile SSL Setup v${C_PFI_VERSION}"
  DetailPrint "----------------------------------------------------"

  ; Make sure we do not try to add SSL support to an installation which is in use

  Call MakeRootDirSafe

  ; Important information about SSL support

  DetailPrint ""
  SetOutPath $G_ROOTDIR
  File "addssl.txt"
  DetailPrint ""

SectionEnd


#--------------------------------------------------------------------------
# Installer Section: Download and install POPFile SSL Support files
# (the 'include' file contains more than just the 'Section' code)
#--------------------------------------------------------------------------

  !include "..\getssl.nsh"


#--------------------------------------------------------------------------
# Installer Section: Apply the SSL speed-up patch if necessary then tidy up
#--------------------------------------------------------------------------

Section "-tidyup"

  ; Now patch Module.pm (if it needs to be patched)

  DetailPrint ""
  DetailPrint "$(PSS_LANG_PREPAREPATCH)"

  SetDetailsPrint none
  File "/oname=$PLUGINSDIR\patch.pat" "Module_ssl.pat"
  SetDetailsPrint listonly

  DetailPrint ""
  vpatch::vpatchfile "$PLUGINSDIR\patch.pat" "$G_ROOTDIR\POPFile\Module.pm" "$PLUGINSDIR\Module.ssl"
  Pop $G_PLS_FIELD_1

  SetDetailsPrint both
  DetailPrint "$(PSS_LANG_PATCHSTATUS)"
  SetDetailsPrint listonly
  DetailPrint ""

  StrCmp $G_PLS_FIELD_1 "No suitable patches were found" close_log
  StrCmp $G_PLS_FIELD_1 "OK" 0 show_speedup_status
  !insertmacro PFI_BACKUP_123_DP "$G_ROOTDIR\POPFile" "Module.pm"
  SetDetailsPrint none
  Rename "$PLUGINSDIR\Module.ssl" "$G_ROOTDIR\POPFile\Module.pm"
  IfFileExists "$G_ROOTDIR\POPFile\Module.pm" speedup_success
  Rename "$G_ROOTDIR\POPFile\Module.pm.bk1" "$G_ROOTDIR\POPFile\Module.pm"
  SetDetailsPrint listonly
  DetailPrint ""
  SetDetailsPrint both
  DetailPrint "$(PSS_LANG_PATCHFAILED)"
  SetDetailsPrint listonly
  DetailPrint ""
  Call PFI_GetDateTimeStamp
  Pop $G_PLS_FIELD_1
  DetailPrint "----------------------------------------------------"
  DetailPrint "POPFile SSL Setup failed ($G_PLS_FIELD_1)"
  DetailPrint "----------------------------------------------------"
  Abort

speedup_success:
  SetDetailsPrint listonly
  DetailPrint "$(PSS_LANG_PATCHCOMPLETED)"
  DetailPrint ""

show_speedup_status:
  MessageBox MB_OK|MB_ICONEXCLAMATION "$(PSS_LANG_PATCHSTATUS)"

close_log:
  SetDetailsPrint both
  DetailPrint "$(PSS_LANG_PROG_SUCCESS)"
  SetDetailsPrint listonly
  DetailPrint ""
  Call PFI_GetDateTimeStamp
  Pop $G_PLS_FIELD_1
  DetailPrint "----------------------------------------------------"
  DetailPrint "POPFile SSL Setup completed $G_PLS_FIELD_1"
  DetailPrint "----------------------------------------------------"
  DetailPrint ""

  ; Save a log showing what was installed

  SetDetailsPrint textonly
  DetailPrint "$(PFI_LANG_PROG_SAVELOG)"
  SetDetailsPrint none
  !insertmacro PFI_BACKUP_123 "$G_ROOTDIR" "addssl.log"
  Push "$G_ROOTDIR\addssl.log"
  Call PFI_DumpLog

  SetDetailsPrint both
  DetailPrint "Log report saved in '$G_ROOTDIR\addssl.log'"
  SetDetailsPrint none

SectionEnd


#--------------------------------------------------------------------------
# Installer Function: CheckForExistingInstallation
# (the "pre" function for the DIRECTORY selection page)
#
# Set the initial value used by the DIRECTORY page to the location used by the most recent
# installation of POPFile v0.22.x
#--------------------------------------------------------------------------

Function CheckForExistingInstallation

  ReadRegStr $INSTDIR HKCU "Software\POPFile Project\${C_PFI_PRODUCT}\MRI" "InstallPath"
  StrCmp $INSTDIR "" try_HKLM
  IfFileExists "$INSTDIR\*.*" exit

try_HKLM:
  ReadRegStr $INSTDIR HKLM "Software\POPFile Project\${C_PFI_PRODUCT}\MRI" "InstallPath"
  StrCmp $INSTDIR "" use_default
  IfFileExists "$INSTDIR\*.*" exit

use_default:
  MessageBox MB_OK|MB_ICONEXCLAMATION "$(PSS_LANG_COMPAT_NOTFOUND)"
  StrCpy $INSTDIR "$PROGRAMFILES\${C_PFI_PRODUCT}"

exit:
FunctionEnd


#--------------------------------------------------------------------------
# Installer Function: CheckInstallDir
# (the "leave" function for the DIRECTORY selection page)
#
# This function is used to check if a previous POPFile installation exists in the directory
# chosen for this installation's POPFile program files (popfile.pl, etc)
#--------------------------------------------------------------------------

Function CheckInstallDir

  ; Initialise the global user variable used for the main POPFIle program folder location

  StrCpy $G_ROOTDIR "$INSTDIR"

  ; Warn the user if the selected directory does not appear to contain POPFile 0.22.x files
  ; and allow user to select a different directory if they wish

  IfFileExists "$G_ROOTDIR\skins\default\style.css" continue

  StrCpy $G_PLS_FIELD_1 "$INSTDIR"
  MessageBox MB_YESNO|MB_ICONQUESTION "$(PSS_LANG_DESTNDIR_MB_WARN_1)\
      ${MB_NL}${MB_NL}${MB_NL}\
      $(PSS_LANG_DESTNDIR_MB_WARN_2)" IDYES continue

  ; Return to the DIRECTORY selection page

  Abort

continue:

  ; Move to the INSTFILES page (to install the files)

FunctionEnd


#--------------------------------------------------------------------------
# Installer Function: MakeRootDirSafe
#
# We are adding files to a previous installation, so we try to shut it down first
#--------------------------------------------------------------------------

Function MakeRootDirSafe

  IfFileExists "$G_ROOTDIR\*.exe" 0 nothing_to_check

  !define L_CFG      $R9    ; file handle
  !define L_EXE      $R8    ; name of EXE file to be monitored
  !define L_LINE     $R7
  !define L_NEW_GUI  $R6
  !define L_PARAM    $R5
  !define L_RESULT   $R4
  !define L_TEXTEND  $R3    ; used to ensure correct handling of lines longer than 1023 chars

  Push ${L_CFG}
  Push ${L_EXE}
  Push ${L_LINE}
  Push ${L_NEW_GUI}
  Push ${L_PARAM}
  Push ${L_RESULT}
  Push ${L_TEXTEND}

  DetailPrint ""
  SetDetailsPrint both
  DetailPrint "$(PFI_LANG_PROG_CHECKIFRUNNING)"
  SetDetailsPrint listonly

  ; Starting with POPfile 0.21.0 an experimental version of 'popfile-service.exe' was included
  ; to allow POPFile to be run as a Windows service.

  Push "POPFile"
  Call PFI_ServiceActive
  Pop ${L_RESULT}
  StrCmp ${L_RESULT} "true" manual_shutdown

  ; If we are about to add SSL support to a POPFile installation which is still running,
  ; then one of the EXE files will be 'locked' which means we have to shutdown POPFile.
  ;
  ; POPFile v0.20.0 and later may be using 'popfileb.exe', 'popfilef.exe', 'popfileib.exe',
  ; 'popfileif.exe', 'perl.exe' or 'wperl.exe'.
  ;
  ; Earlier versions of POPFile use only 'perl.exe' or 'wperl.exe'.

  Push $G_ROOTDIR
  Call PFI_FindLockedPFE
  Pop ${L_EXE}
  StrCmp ${L_EXE} "" exit

  ; The program folders we are about to update are in use so we need to shut POPFile down

  DetailPrint "... it is locked."

  ; Attempt to discover which POPFile UI port is used by the current user, so we can issue
  ; a shutdown request.

  ReadRegStr ${L_CFG} HKCU "Software\POPFile Project\${C_PFI_PRODUCT}\MRI" "UserDir_LFN"
  StrCmp ${L_CFG} "" try_root_dir
  IfFileExists "${L_CFG}\popfile.cfg" check_cfg_file

try_root_dir:
  IfFileExists "$G_ROOTDIR\popfile.cfg" 0 manual_shutdown
  StrCpy ${L_CFG} "$G_ROOTDIR"

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
  Call PFI_TrimNewlines
  Pop ${L_NEW_GUI}

  StrCmp ${L_NEW_GUI} "" manual_shutdown
  DetailPrint "$(PFI_LANG_INST_LOG_SHUTDOWN) ${L_NEW_GUI}"
  DetailPrint "$(PFI_LANG_TAKE_A_FEW_SECONDS)"
  Push ${L_NEW_GUI}
  Call PFI_ShutdownViaUI
  Pop ${L_RESULT}
  StrCmp ${L_RESULT} "success" check_exe
  StrCmp ${L_RESULT} "password?" manual_shutdown

check_exe:
  DetailPrint "Waiting for '${L_EXE}' to unlock after NSISdl request..."
  DetailPrint "Please be patient, this may take more than 30 seconds"
  Push ${L_EXE}
  Call PFI_WaitUntilUnlocked
  DetailPrint "Checking if '${L_EXE}' is still locked after NSISdl request..."
  Push "${C_EXE_END_MARKER}"
  Push ${L_EXE}
  Call PFI_CheckIfLocked
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
  Goto exit

unlocked_now:
  DetailPrint "File is now unlocked"

exit:
  Pop ${L_TEXTEND}
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
  !undef L_TEXTEND

nothing_to_check:
FunctionEnd

#--------------------------------------------------------------------------
# End of 'addssl.nsi'
#--------------------------------------------------------------------------
