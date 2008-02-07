#--------------------------------------------------------------------------
#
# installer.nsi --- This is the NSIS script used to create the Windows installer
#                   for POPFile. This script installs the PROGRAM files and creates
#                   some registry entries, then calls the 'Add POPFile User' wizard
#                   (adduser.exe) to install and configure the user data (including
#                   the POPFILE_ROOT and POPFILE_USER environment variables) for the
#                   user running the installer.
#
#                   (A) Requires the following programs (built using NSIS):
#
#                       (1) adduser.exe     (NSIS script: adduser.nsi)
#                       (2) msgcapture.exe  (NSIS script: msgcapture.nsi)
#                       (3) runpopfile.exe  (NSIS script: runpopfile.nsi)
#                       (4) runsqlite.exe   (NSIS script: runsqlite.nsi)
#                       (5) stop_pf.exe     (NSIS script: stop_popfile.nsi)
#
#                   (B) The following programs (built using NSIS) are optional:
#
#                       (1) pfidbstatus.exe (NSIS script: test\pfidbstatus.nsi)
#                       (2) pfidiag.exe     (NSIS script: test\pfidiag.nsi)
#
# Copyright (c) 2002-2007 John Graham-Cumming
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
# The original 'installer.nsi' script has been divided into several files:
#
#  (1) installer.nsi                 - master script which uses the following 'include' files
#  (2) installer-SecPOPFile-body.nsh - body of section used to install the POPFile program
#  (3) installer-SecPOPFile-func.nsh - functions used by the above 'include' file
#  (4) installer-SecMinPerl-body.nsh - body of section used to install the basic minimal Perl
#  (5) installer-Uninstall.nsh       - source for the POPFile uninstaller (uninstall.exe)
#  (6) getssl.nsh                    - section & functions used to download the SSL support files
#  (7) getparser.nsh                 - macro-based sections and functions to install the Nihongo Parser
#--------------------------------------------------------------------------

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

; Normally no NSIS compiler warnings are expected. However there may be some warnings
; which mention "PFI_LANG_NSISDL_PLURAL" is not set in one or more language tables.
; These "PFI_LANG_NSISDL_PLURAL" warnings can be safely ignored (at present only the
; 'Japanese-pfi.nsh' file generates this warning).

; INSTALLER SIZE: The LZMA compression method is used to reduce the size of the 'setup.exe'
; file by around 25% compared to the default compression method but at the expense of greatly
; increased compilation times (LZMA compilation (with the default LZMA settings) takes almost
; two and a half times as long as it does when the default compression method is used).

#--------------------------------------------------------------------------
# POPFile Version Data:
#
# In order to simplify maintenance, the POPFile version number and 'Release Candidate' status
# are passed as command-line parameters to the NSIS compiler.
#
# The following 4 parameters must be supplied (where x is a value in range 0 to 65535):
#
# (a) the Major Version number      (supplied as /DC_POPFILE_MAJOR_VERSION=x)
# (b) the Minor Version number      (supplied as /DC_POPFILE_MINOR_VERSION=x)
# (c) the Revision number           (supplied as /DC_POPFILE_REVISION=x)
# (d) the Release Candidate number  (supplied as /DC_POPFILE_RC=RCx)
#
# Note that if a production build is required (i.e. not a Release Candidate), /DC_POPFILE_RC
# or /DC_POPFILE_RC= or /DC_POPFILE_RC="" can be used instead of /DC_POPFILE_RC=RCx
#
# For example, to build the installer for the final POPFile 0.21.1 release, the following
# command-line could be used:
#
# makensis.exe /DC_POPFILE_MAJOR_VERSION=0 /DC_POPFILE_MINOR_VERSION=21 /DC_POPFILE_REVISION=1 /DC_POPFILE_RC installer.nsi
#--------------------------------------------------------------------------

  ;------------------------------------------------
  ; This script requires the 'UAC' NSIS plugin
  ;------------------------------------------------

  ; The new 'User Account Control' (UAC) feature in Windows Vista makes it difficult to install
  ; POPFile from a 'standard' user account. This script uses a special NSIS plugin (UAC) which
  ; allows the 'POPFile program files' part of the installation to be run at the 'admin' level
  ; and the user-specific POPFile configuration part to be run at the 'user' level.
  ;
  ; The 'NSIS Wiki' page for the 'UAC' plugin (description, example and download links):
  ; http://nsis.sourceforge.net/UAC_plug-in
  ;
  ; To compile this script, copy the 'UAC.dll' file to the standard NSIS plugins folder
  ; (${NSISDIR}\Plugins\). The 'UAC' source and example files can be unzipped to the
  ; appropriate ${NSISDIR} sub-folders if you wish, but this step is entirely optional.
  ;
  ; Tested with version v0.0.6b of the 'UAC' plugin.

#--------------------------------------------------------------------------
# Compile-time command-line switches (used by 'makensis.exe')
#--------------------------------------------------------------------------
#
# /DENGLISH_MODE
#
# To build an installer that only displays English messages (so there is no need to ensure all
# of the non-English *-pfi.nsh files are up-to-date), supply the command-line switch
# /DENGLISH_MODE when compiling the installer. This switch only affects the language used by
# the installer, it does not affect which files get installed.
#
#--------------------------------------------------------------------------

#--------------------------------------------------------------------------
# Run-time command-line switch (used by 'setup.exe')
#--------------------------------------------------------------------------
#
# /SSL
#
# If there are problems downloading the optional SSL support files from the Internet, the
# installer will skip this part of the installation. If SSL support is required, the SSL
# files can be added by re-running the installer with the /SSL command-line switch to make
# it skip everything except the downloading and installation of the SSL support files.
#
# The /SSL switch can use uppercase or lowercase.
#
#--------------------------------------------------------------------------

#--------------------------------------------------------------------------
# LANGUAGE SUPPORT:
#
# The installer defaults to multi-language mode ('English' plus a number of other languages).
#
# If required, the command-line switch /DENGLISH_MODE can be used to build an English-only
# version. This switch can appear before or after the four POPFile version number parameters.
#--------------------------------------------------------------------------
# The POPFile installer uses several multi-language mode programs built using NSIS. To make
# maintenance easier, an 'include' file (pfi-languages.nsh) defines the supported languages.
#
# To remove support for a particular language, comment-out the relevant line in the list of
# languages in the 'pfi-languages.nsh' file.
#
# For instructions on how to add support for new languages, see the 'pfi-languages.nsh' file.
#--------------------------------------------------------------------------
# Support for Japanese text processing
#
# Japanese text does not use spaces between words so POPFile uses a parser to split the text
# into words so the text can be analysed properly. POPFile 0.22.5 (and earlier) only supported
# one parser (Kakasi) for Japanese text. Starting with the 1.0.0 release a choice of three
# parsers is offered: Kakasi, MeCab and Internal.
#
# The 'Kakasi' parser is suggested as the default parser for new installations as it offers
# a reasonable compromise between accuracy and speed. 'MeCab' uses much larger dictionaries
# than Kakasi (about 40 MB instead of about 2 MB) and is therefore more accurate at parsing.
# The 'Internal' parser does not use dictionaries so it is less accurate but it is faster
# than the other two parsers.
#
# Further information about Kakasi, including 'download' links for the Kakasi package and the
# Text::Kakasi Perl module, can be found at http://kakasi.namazu.org/
# (ActivePerl's PPM4 can also be used to download and install the Text::Kakasi Perl module).
#
# Further information about MeCab can be found at http://sourceforge.net/projects/mecab
# Since the MeCab package is much larger than the Kakasi one, the installation files are not
# included in the installer. If the MeCab parser is selected then the MeCab files (about 13 MB)
# will be downloaded from the POPFile project's website during the installation.
#
# This version of the installer also installs the complete Perl 'Encode' collection of modules
# to complete the Japanese support requirements.
#
#--------------------------------------------------------------------------

  ;------------------------------------------------
  ; Define PFI_VERBOSE to get more compiler output
  ;------------------------------------------------

## !define PFI_VERBOSE

  ;--------------------------------------------------------------------------
  ; Select LZMA compression to reduce 'setup.exe' size by around 30%
  ;--------------------------------------------------------------------------

##  SetCompress off

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
  ;--------------------------------------------------------------------------

  !ifndef C_POPFILE_MAJOR_VERSION
    !error "${MB_NL}${MB_NL}Fatal error: 'POPFile Major Version' parameter not supplied${MB_NL}"
  !endif

  !ifndef C_POPFILE_MINOR_VERSION
    !error "${MB_NL}${MB_NL}Fatal error: 'POPFile Minor Version' parameter not supplied${MB_NL}"
  !endif

  !ifndef C_POPFILE_REVISION
    !error "${MB_NL}${MB_NL}Fatal error: 'POPFile Revision' parameter not supplied${MB_NL}"
  !endif

  !ifndef C_POPFILE_RC
    !error "${MB_NL}${MB_NL}Fatal error: 'POPFile RC' parameter not supplied${MB_NL}"
  !endif

  !define C_PFI_PRODUCT  "POPFile"

  ; Name to be used for the installer program file (also used for the 'Version Information')

  !define C_OUTFILE     "setup${C_POPFILE_RC}.exe"

  Name                   "${C_PFI_PRODUCT}"

  !define C_PFI_VERSION  "${C_POPFILE_MAJOR_VERSION}.${C_POPFILE_MINOR_VERSION}.${C_POPFILE_REVISION}${C_POPFILE_RC}"

  ; Mention the POPFile version number in the titles of the installer & uninstaller windows

  Caption                "${C_PFI_PRODUCT} ${C_PFI_VERSION} Setup"
  UninstallCaption       "${C_PFI_PRODUCT} ${C_PFI_VERSION} Add/Remove"

  !define C_README        "v${C_POPFILE_MAJOR_VERSION}.${C_POPFILE_MINOR_VERSION}.${C_POPFILE_REVISION}.change"
  !define C_RELEASE_NOTES "..\engine\${C_README}"

  ; Some releases may include a Japanese translation of the release notes

  !define C_JAPANESE_RELEASE_NOTES "${C_RELEASE_NOTES}.nihongo"

  ;--------------------------------------------------------------------------
  ; Windows Vista expects to find a manifest specifying the execution level
  ;
  ; The POPFile installer has two stages; the first stage (setup.exe) installs the
  ; POPFile program and then calls the second stage (adduser.exe) to configure POPFile
  ; for the current user.
  ;
  ; The first stage has to be able to write to the default installation folder
  ; (C:\Program Files\POPFile, or its equivalent) and be able to create/update
  ; some HKLM registry entries so it requires 'administrator' privileges. The
  ; second stage creates user-specific environment variables and HKCU registry
  ; entries so it requires 'current user' privileges.
  ;
  ; A special NSIS plugin (UAC) is used to allow these two stages of the
  ; installer to run with the required privileges. Although this script is
  ; used to create the 'administrator' privileges stage of the installer
  ; the UAC plugin requires this script to specify 'user' instead of 'admin'
  ; when requesting the execution level.
  ;--------------------------------------------------------------------------

  RequestExecutionLevel   user

  ;----------------------------------------------------------------------
  ; Root directory for the Perl files (used when building the installer)
  ; and the version number and build number required for the minimal Perl
  ;----------------------------------------------------------------------

  !define C_PERL_DIR      "C:\Perl"
  !define C_PERL_VERSION  "5.8.8"
  !define C_PERL_BUILD    "822"

  ;----------------------------------------------------------------------
  ; Recently there have been some significant changes to the structure and
  ; behaviour of ActivePerl. These changes have affected the way in which
  ; the minimal Perl is assembled therefore a new compile-time check has
  ; been introduced to ensure that a suitable ActivePerl installation is
  ; available for use in preparing the minimal Perl used by POPFile.
  ;----------------------------------------------------------------------

  !system 'if exist ".\ap-version.nsh" del ".\ap-version.nsh"'
  !system '".\toolkit\ap-vcheck.exe" ${C_PERL_DIR}'
  !include /NONFATAL ".\ap-version.nsh"

  ; The above '!system' call can fail on older (slower/Win9x?) systems so if the expected
  ; output file is not found we try a safer version of the '!system' call. If this call
  ; also fails then the NSIS compiler will stop with a fatal error.

  !ifndef C_AP_STATUS
    !system 'start /w toolkit\ap-vcheck.exe ${C_PERL_DIR}'
    !include ".\ap-version.nsh"
   !endif

  ; Delete the "include" file after it has been read

  !delfile ".\ap-version.nsh"

  ; Now we can check that the location defined in ${C_PERL_DIR} is suitable

  !if "${C_AP_STATUS}" == "failure"
    !error "${MB_NL}${MB_NL}Fatal error:${MB_NL}\
        ${MB_NL}   ActivePerl version check failed${MB_NL}\
        ${MB_NL}   (${C_AP_ERRORMSG})${MB_NL}"
  !endif

  ; For this build of the installer we require an exact match for the ActivePerl version number _and_ build number

  !if "${C_AP_VERSION}.${C_AP_BUILD}" != "${C_PERL_VERSION}.${C_PERL_BUILD}"
    !error "${MB_NL}${MB_NL}Fatal error:${MB_NL}\
        ${MB_NL}   ActivePerl ${C_PERL_VERSION} Build ${C_PERL_BUILD} is required for this installer\
        ${MB_NL}   but ActivePerl ${C_AP_VERSION} Build ${C_AP_BUILD} has been detected in the\
        ${MB_NL}   $\"${C_AP_FOLDER}$\" folder${MB_NL}"
  !endif

  !echo "${MB_NL}\
      ${MB_NL}   ActivePerl version ${C_AP_VERSION} Build ${C_AP_BUILD} will be used to prepare the minimal Perl${MB_NL}${MB_NL}"

  ;----------------------------------------------------------------------------------
  ; Root directory for the Kakasi package.
  ;
  ; The Kakasi package is distributed as a ZIP file which contains several folders
  ; (bin, doc, include, lib and share) all of which are under a top level folder
  ; called 'kakasi'. 'C_KAKASI_DIR' is used to refer to the folder into which the
  ; Kakasi ZIP file has been unzipped so that NSIS can find the files when making the installer.
  ;
  ; The 'itaijidict' file's path should be '${C_KAKASI_DIR}\kakasi\share\kakasi\itaijidict'
  ; The 'kanwadict'  file's path should be '${C_KAKASI_DIR}\kakasi\share\kakasi\kanwadict'
  ;----------------------------------------------------------------------------------

  !define C_KAKASI_DIR      "kakasi_package"

  ;-------------------------------------------------------------------------------
  ; Constant used to avoid problems with Banner.dll
  ;
  ; (some versions of the DLL do not like being 'destroyed' immediately)
  ;-------------------------------------------------------------------------------

  ; Minimum time for the banner to be shown (in milliseconds)

  !define C_MIN_BANNER_DISPLAY_TIME    250

#--------------------------------------------------------------------------
# User Registers (Global)
#--------------------------------------------------------------------------

  ; This script uses 'User Variables' (with names starting with 'G_') to hold GLOBAL data.

  Var G_ROOTDIR            ; full path to the folder used for the POPFile PROGRAM files
  Var G_USERDIR            ; full path to the folder containing the 'popfile.cfg' file
  Var G_MPLIBDIR           ; full path to the folder used for the rest of the minimal Perl files

  Var G_GUI                ; GUI port (1-65535)

  Var G_PFIFLAG            ; Multi-purpose variable:
                           ; (1) used to indicate if banner was shown before the 'WELCOME' page
                           ; (2) used to avoid unnecessary Install/Upgrade button text updates

  Var G_NOTEPAD            ; path to notepad.exe ("" = not found in search path)

  Var G_WINUSERNAME        ; current Windows user login name
  Var G_WINUSERTYPE        ; user group ('Admin', 'Power', 'User', 'Guest' or 'Unknown')

  Var G_PARSER             ; used to indicate which Nihongo (Japanese) parser is to be installed
                           ; (1) Internal, (2) Kakasi (the default), or (3) MeCab
                           ; (if "MeCab" is selected then it will be downloaded during the install)

  Var G_SSL_ONLY           ; 1 = SSL-only installation, 0 = normal installation

  Var G_PLS_FIELD_1        ; used to customize translated text strings

  Var G_DLGITEM            ; HWND of the UI dialog field we are going to modify

  ;-------------------------------------------------------------------------------
  ; At present (14 March 2004) POPFile does not work properly if POPFILE_ROOT or POPFILE_USER
  ; are set to values containing spaces. A simple workaround is to use short file name format
  ; values for these environment variables. But some systems may not support short file names
  ; (e.g. using short file names on NTFS volumes can have a significant impact on performance)
  ; so we need to check if short file names are supported (if they are not, we insist upon paths
  ; which do not contain spaces).
  ;-------------------------------------------------------------------------------

  Var G_SFN_DISABLED       ; 1 = short file names not supported, 0 = short file names available

  ;-------------------------------------------------------------------------------

  ; NSIS provides 20 general purpose user registers:
  ; (a) $R0 to $R9   are used as local registers
  ; (b) $0 to $9     are used as additional local registers

  ; Local registers referred to by 'defines' use names starting with 'L_' (eg L_LNE, L_OLDUI)
  ; and the scope of these 'defines' is limited to the "routine" where they are used.

  ; In earlier versions of the NSIS compiler, 'User Variables' did not exist, and the convention
  ; was to use $R0 to $R9 as 'local' registers and $0 to $9 as 'global' ones. This is why this
  ; script uses registers $R0 to $R9 in preference to registers $0 to $9.

  ; POPFile constants have been given names beginning with 'C_' (eg C_README)

#--------------------------------------------------------------------------
# Use the "Modern User Interface", the standard NSIS Section flag utilities
# and the standard NSIS list of common Windows Messages
#--------------------------------------------------------------------------

  !include "MUI.nsh"
  !include "Sections.nsh"
  !include "WinMessages.nsh"

#--------------------------------------------------------------------------
# Include private library functions and macro definitions
#--------------------------------------------------------------------------

  ; Avoid compiler warnings by disabling the functions and definitions we do not use

  !define INSTALLER

  !include "pfi-library.nsh"
  !include "WriteEnvStr.nsh"

  ; Macros used for entries in the installation log file

  !macro SECTIONLOG_ENTER NAME
      SetDetailsPrint listonly
      DetailPrint "----------------------------------------"
      DetailPrint "$\"${NAME}$\" Section (entry)"
      DetailPrint "----------------------------------------"
      DetailPrint ""
  !macroend

  !macro SECTIONLOG_EXIT NAME
      SetDetailsPrint listonly
      DetailPrint ""
      DetailPrint "----------------------------------------"
      DetailPrint "$\"${NAME}$\" Section (exit)"
      DetailPrint "----------------------------------------"
      DetailPrint ""
  !macroend

#--------------------------------------------------------------------------
# Version Information settings (for the installer EXE and uninstaller EXE)
#--------------------------------------------------------------------------

  ; 'VIProductVersion' format is X.X.X.X where X is a number in range 0 to 65535
  ; representing the following values: Major.Minor.Release.Build

  VIProductVersion "${C_POPFILE_MAJOR_VERSION}.${C_POPFILE_MINOR_VERSION}.${C_POPFILE_REVISION}.0"

  !define /date C_BUILD_YEAR                "%Y"

  VIAddVersionKey "ProductName"             "${C_PFI_PRODUCT}"
  VIAddVersionKey "Comments"                "POPFile Homepage: http://getpopfile.org/"
  VIAddVersionKey "CompanyName"             "The POPFile Project"
  VIAddVersionKey "LegalTrademarks"         "POPFile is a registered trademark of John Graham-Cumming"
  VIAddVersionKey "LegalCopyright"          "Copyright (c) ${C_BUILD_YEAR}  John Graham-Cumming"
  VIAddVersionKey "FileDescription"         "POPFile Automatic email classification"
  VIAddVersionKey "FileVersion"             "${C_PFI_VERSION}"
  VIAddVersionKey "OriginalFilename"        "${C_OUTFILE}"

  !ifndef ENGLISH_MODE
      VIAddVersionKey "Build"               "Multi-Language installer"
  !else
      VIAddVersionKey "Build"               "English-Mode installer"
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

  ; The icon files for the installer and uninstaller must have the same structure. For example,
  ; if one icon file contains a 32x32 16-colour image and a 16x16 16-colour image then the other
  ; file cannot just contain a 32x32 16-colour image, it must also have a 16x16 16-colour image.
  ; The order of the images in each icon file must also be the same.

  !define MUI_ICON                            "POPFileIcon\popfile.ico"
  !define MUI_UNICON                          "remove.ico"

  ; The "Header" bitmap appears on all pages of the installer (except 'WELCOME' & 'FINISH')
  ; and on all pages of the uninstaller.

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
  ;  Interface Settings - WELCOME/FINISH Page Interface Settings
  ;----------------------------------------------------------------

  ; The "Special" bitmap appears on the 'WELCOME' and 'FINISH' pages

  !define MUI_WELCOMEFINISHPAGE_BITMAP        "special.bmp"

  !define MUI_UNWELCOMEFINISHPAGE_BITMAP      "special.bmp"

  ;----------------------------------------------------------------
  ;  Interface Settings - Installer/Uninstaller FINISH Page Interface Settings
  ;----------------------------------------------------------------

  ; Debug aid: Hide the installation log but let user display it (using "Show details" button)

  !define MUI_FINISHPAGE_NOAUTOCLOSE

  !define MUI_UNFINISHPAGE_NOAUTOCLOSE

  ;----------------------------------------------------------------
  ;  Interface Settings - Abort Warning Settings
  ;----------------------------------------------------------------

  ; Show a message box with a warning when the user closes the installation

  !define MUI_ABORTWARNING

  ;----------------------------------------------------------------
  ; Customize MUI - General Custom Function
  ;----------------------------------------------------------------

  ; Use a custom '.onGUIInit' function to add language-specific texts to custom page INI files

  !define MUI_CUSTOMFUNCTION_GUIINIT          "PFIGUIInit"

  ; Use a custom 'un.onGUIInit' function to add language-specific texts to custom page INI files

  !define MUI_CUSTOMFUNCTION_UNGUIINIT        "un.PFIGUIInit"

  ;----------------------------------------------------------------
  ; Language Settings for MUI pages
  ;----------------------------------------------------------------

  ; Override the standard "Installer Language" title for the language selection dialogue

  !define MUI_LANGDLL_WINDOWTITLE             "POPFile Installer Language Selection"

  ; Always show the language selection dialog, even if a language has been stored in the
  ; registry (the language stored in the registry will be selected as the default language)
  ; This makes it easy to recover from a previous 'bad' choice of language for the installer

  !define MUI_LANGDLL_ALWAYSSHOW

  ; Remember user's language selection and offer this as the default when re-installing
  ; (uninstaller also uses this setting to determine which language is to be used)

  !define MUI_LANGDLL_REGISTRY_ROOT           "HKCU"
  !define MUI_LANGDLL_REGISTRY_KEY            "SOFTWARE\POPFile Project\${C_PFI_PRODUCT}\MRI"
  !define MUI_LANGDLL_REGISTRY_VALUENAME      "Installer Language"

#--------------------------------------------------------------------------
# Define the Page order for the installer (and the uninstaller)
#--------------------------------------------------------------------------

  ;---------------------------------------------------
  ; Installer Page - WELCOME
  ;---------------------------------------------------

  ; Use a "pre" function for the 'WELCOME' page to remove the banner
  ; (if one has been displayed)

  !define MUI_PAGE_CUSTOMFUNCTION_PRE         "RemoveBanner"

  !define MUI_WELCOMEPAGE_TEXT                "$(PFI_LANG_WELCOME_INFO_TEXT)"

  !insertmacro MUI_PAGE_WELCOME

  ;---------------------------------------------------
  ; Installer Page - Check some system requirements of the minimal Perl we install
  ;---------------------------------------------------

  Page custom CheckPerlRequirementsPage

  ;---------------------------------------------------
  ; Installer Page - License Page (uses English GPL)
  ;---------------------------------------------------

  ; Three styles of 'License Agreement' page are available:
  ; (1) New style with an 'I accept' checkbox below the license window
  ; (2) New style with 'I accept/I do not accept' radio buttons below the license window
  ; (3) Classic style with the 'Next' button replaced by an 'Agree' button
  ;     (to get the 'Classic' style, comment-out the CHECKBOX and the RADIOBUTTONS 'defines')

  !define MUI_LICENSEPAGE_CHECKBOX
##  !define MUI_LICENSEPAGE_RADIOBUTTONS

  !insertmacro MUI_PAGE_LICENSE               "..\engine\license"

  ;---------------------------------------------------
  ; Installer Page - Allow user to select the "Nihongo" parser, if "Nihongo" language selected
  ;---------------------------------------------------

  Page custom ChooseParser HandleParserSelection

  ;---------------------------------------------------
  ; Installer Page - Select Components to be installed
  ;---------------------------------------------------

  ; Use a "pre" function to check if only the SSL Support files are to be installed

  !define MUI_PAGE_CUSTOMFUNCTION_PRE         "CheckSSLOnlyFlag"

  !insertmacro MUI_PAGE_COMPONENTS

  ;---------------------------------------------------
  ; Installer Page - Select Installation Directory
  ;---------------------------------------------------

  ; Use a "pre" function to select an initial value for the PROGRAM files installation folder

  !define MUI_PAGE_CUSTOMFUNCTION_PRE         "CheckForExistingLocation"

  ; Use a "leave" function to check if we are upgrading an existing installation

  !define MUI_PAGE_CUSTOMFUNCTION_LEAVE       "CheckExistingProgDir"

  ; This page is used to select the folder for the POPFile PROGRAM files

  !define MUI_PAGE_HEADER_TEXT                "$(PFI_LANG_ROOTDIR_TITLE)"
  !define MUI_DIRECTORYPAGE_TEXT_DESTINATION  "$(PFI_LANG_ROOTDIR_TEXT_DESTN)"

  !insertmacro MUI_PAGE_DIRECTORY

  ;---------------------------------------------------
  ; Installer Page - Show user what we are about to do and get permission to proceed
  ;
  ; This page must come immediately before the INSTFILES page ('MUI_PAGE_INSTFILES')
  ;---------------------------------------------------

  Page custom GetPermissionToInstall

  ;---------------------------------------------------
  ; Installer Page - Install POPFile PROGRAM files
  ;---------------------------------------------------

  ; Replace the standard "Installation Complete/Setup was completed successfully" header
  ; with one indicating that the next step is to configure POPFile

  !define MUI_INSTFILESPAGE_FINISHHEADER_TEXT    "$(PFI_LANG_INSTFINISH_TITLE)"
  !define MUI_INSTFILESPAGE_FINISHHEADER_SUBTEXT "$(PFI_LANG_INSTFINISH_SUBTITLE)"

  !insertmacro MUI_PAGE_INSTFILES

  ;---------------------------------------------------
  ; Installer Page - FINISH
  ;---------------------------------------------------

  ; Use a "pre" function for the FINISH page to run the 'Add POPFile User' wizard to
  ; configure POPFile for the user running the installer.

  ; For this build we skip our own FINISH page and disable the wizard's language selection
  ; dialog to make the wizard appear as an extension of the main 'setup.exe' installer.

  !define MUI_PAGE_CUSTOMFUNCTION_PRE         "InstallUserData"

  ; Provide a checkbox to let user display the Release Notes for this version of POPFile

  !define MUI_FINISHPAGE_SHOWREADME
  !define MUI_FINISHPAGE_SHOWREADME_NOTCHECKED
  !define MUI_FINISHPAGE_SHOWREADME_FUNCTION  "ShowReadMe"

  !insertmacro MUI_PAGE_FINISH

  ;---------------------------------------------------
  ; Uninstaller Page - Select "Change" or "Uninstall" Mode
  ;---------------------------------------------------

  UninstPage custom un.SelectMode

  ;---------------------------------------------------
  ; Uninstaller Page - Allow user to select the "Nihongo" parser, if "Nihongo" language selected
  ;---------------------------------------------------

  UninstPage custom un.ChooseParser un.HandleParserSelection

  ;---------------------------------------------------
  ; Uninstaller Page - Select Components to be installed in "Change" mode
  ;---------------------------------------------------

  ; Use a "pre" function to skip the COMPONENTS page if uninstalling POPFile

  !define MUI_PAGE_CUSTOMFUNCTION_PRE         "un.ComponentsCheckModeFlag"

  ; Override some default strings because we are ADDING components, not uninstalling them

  !define MUI_PAGE_HEADER_SUBTEXT             "$(MUI_TEXT_COMPONENTS_SUBTITLE)"
  !define MUI_COMPONENTSPAGE_TEXT_TOP         "$(^ComponentsText)"
  !define MUI_COMPONENTSPAGE_TEXT_COMPLIST    "$(^ComponentsSubText2_NoInstTypes)"

  !insertmacro MUI_UNPAGE_COMPONENTS

  ;---------------------------------------------------
  ; Uninstaller Page - Check available space in "Change" mode
  ;---------------------------------------------------

  ; Use a "pre" function to skip the DIRECTORY page when uninstalling

  !define MUI_PAGE_CUSTOMFUNCTION_PRE         "un.DirectoryCheckModeFlag"

  ; We are only going to add files to an existing installation so the DIRECTORY
  ; page is for information only (it shows the required space, available space
  ; and the location which will be used)

  !define MUI_PAGE_CUSTOMFUNCTION_SHOW        "un.MakeDirectoryPageReadOnly"

  ; Replace the default text because we are NOT uninstalling POPFile

  !define MUI_PAGE_HEADER_TEXT                "$(PFI_LANG_UN_DIR_TITLE)"
  !define MUI_PAGE_HEADER_SUBTEXT             "$(PFI_LANG_UN_DIR_SUBTITLE)"

  !define MUI_DIRECTORYPAGE_TEXT_TOP          "$(PFI_LANG_UN_DIR_EXPLANATION)"

  !define MUI_DIRECTORYPAGE_TEXT_DESTINATION  "$(PFI_LANG_UN_DIR_TEXT_DESTN)"

  !insertmacro MUI_UNPAGE_DIRECTORY

  ;---------------------------------------------------
  ; Uninstaller Page - Confirmation Page
  ;---------------------------------------------------

  ; Use a "pre" function to skip the confirmation page if not uninstalling POPFile

  !define MUI_PAGE_CUSTOMFUNCTION_PRE         "un.UninstallCheckModeFlag"

  !insertmacro MUI_UNPAGE_CONFIRM

  ;---------------------------------------------------
  ; Uninstaller Page - Modify or Uninstall POPFile
  ;---------------------------------------------------

  ; Override the standard "Uninstallation complete..." page header

  !define MUI_INSTFILESPAGE_FINISHHEADER_TEXT     "$(PFI_LANG_UN_INST_OK_TITLE)"
  !define MUI_INSTFILESPAGE_FINISHHEADER_SUBTEXT  "$(PFI_LANG_UN_INST_OK_SUBTITLE)"

  ; Override the standard "Uninstallation Aborted..." page header

  !define MUI_INSTFILESPAGE_ABORTHEADER_TEXT      "$(PFI_LANG_UN_INST_BAD_TITLE)"
  !define MUI_INSTFILESPAGE_ABORTHEADER_SUBTEXT   "$(PFI_LANG_UN_INST_BAD_SUBTITLE)"

  ; Use a "show" function to adjust the header for the INSTFILES page when "Change" mode is selected

  !define MUI_PAGE_CUSTOMFUNCTION_SHOW            "un.AdjustUninstHeaderText"

  !insertmacro MUI_UNPAGE_INSTFILES

  ;---------------------------------------------------
  ; Uninstaller Page - FINISH
  ;---------------------------------------------------

  ; Override the standard "Uninstall complete" text

  !define MUI_FINISHPAGE_TITLE                    "$(PFI_LANG_UN_FINISH_TITLE)"
  !define MUI_FINISHPAGE_TEXT                     "$(PFI_LANG_UN_FINISH_TEXT)"
  !define MUI_FINISHPAGE_TITLE_3LINES

  ; If we need a reboot then we might have been modifying the installation
  ; so override the standard "reboot to complete the uninstall" text
  ; (Quick fix: this is less confusing than having the wrong text on an uninstall)

  !define MUI_FINISHPAGE_TEXT_REBOOT              "$(MUI_TEXT_FINISH_INFO_REBOOT)"

  !insertmacro MUI_UNPAGE_FINISH

#--------------------------------------------------------------------------
# Language Support for the installer and uninstaller
#--------------------------------------------------------------------------

  ;-----------------------------------------
  ; Select the languages to be supported by installer/uninstaller.
  ;-----------------------------------------

  ; At least one language must be specified for the installer (the default is "English")

  !insertmacro PFI_LANG_LOAD "English" "-"

  ; Conditional compilation: if ENGLISH_MODE is defined, support only 'English'

  !ifndef ENGLISH_MODE

        !include "pfi-languages.nsh"

  !endif

  ;--------------------------------------------------------------------------
  ; The strings used in connection with the installation of the "Nihongo Parser"
  ; are only provided in two languages: Japanese (for the normal multi-language
  ; build of the installer) and English (for the special "English-only" build).
  ; Therefore the necessary strings are simply defined as constants in separate
  ; files, only one of which is included at build time (instead of putting the
  ; strings in the *-pfi.nsh files used for all of the other translated text).
  ;--------------------------------------------------------------------------

  !ifdef ENGLISH_MODE
      !include "languages\English-parser.nsh"
  !else
      !include "languages\Japanese-parser.nsh"
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

  ; Note that the 'InstallDir' value has a trailing slash (to override the default behaviour)
  ;
  ; By default, NSIS will append '\${C_PFI_PRODUCT}' to the path selected using the 'Browse'
  ; button if the path does not already end with '\${C_PFI_PRODUCT}'. If the 'Browse' button
  ; is used to select 'C:\Program Files\POPFile Test' the installer will install the program
  ; in the 'C:\Program Files\POPFile Test\POPFile' folder and although this location is shown
  ; on the DIRECTORY page before the user clicks the 'Next' button most users will not notice
  ; that '\POPFile' has been appended to the location they selected. This problem will be made
  ; worse if there is an existing version of POPFile in the 'C:\Program Files\POPFile Test'
  ; folder since there will already be a 'C:\Program Files\POPFile Test\POPFile' folder holding
  ; Configuration.pm, History.pm, etc
  ;
  ; By adding a trailing slash we ensure that if the user selects a folder using the 'Browse'
  ; button then that is what the installer will use. One side effect of this change is that it
  ; is now easier for users to select a folder such as 'C:\Program Files' for the installation
  ; (which is not a good choice - so we refuse to accept any path matching the target system's
  ; "program files" folder; see the 'CheckExistingProgDir' function)

  InstallDir "$PROGRAMFILES\${C_PFI_PRODUCT}\"
  InstallDirRegKey HKCU "Software\POPFile Project\${C_PFI_PRODUCT}\MRI" "InstallPath"

#--------------------------------------------------------------------------
# Reserve the files required by the installer (to improve performance)
#--------------------------------------------------------------------------

  ; Things that need to be extracted on startup (keep these lines before any File command!)
  ; Only useful when solid compression is used (by default, solid compression is enabled
  ; for BZIP2 and LZMA compression)

  !insertmacro MUI_RESERVEFILE_LANGDLL
  !insertmacro MUI_RESERVEFILE_INSTALLOPTIONS
  ReserveFile "${NSISDIR}\Plugins\Banner.dll"
  ReserveFile "${NSISDIR}\Plugins\DumpLog.dll"
  ReserveFile "${NSISDIR}\Plugins\inetc.dll"
  ReserveFile "${NSISDIR}\Plugins\LockedList.dll"
  ReserveFile "${NSISDIR}\Plugins\md5dll.dll"
  ReserveFile "${NSISDIR}\Plugins\NSISdl.dll"
  ReserveFile "${NSISDIR}\Plugins\ShellLink.dll"
  ReserveFile "${NSISDIR}\Plugins\System.dll"
  ReserveFile "${NSISDIR}\Plugins\UAC.dll"
  ReserveFile "${NSISDIR}\Plugins\untgz.dll"
  ReserveFile "${NSISDIR}\Plugins\UserInfo.dll"
  ReserveFile "${NSISDIR}\Plugins\vpatch.dll"
  ReserveFile "${NSISDIR}\Plugins\ZipDLL.dll"
  ReserveFile "ioG.ini"
  ReserveFile "ioP.ini"
  ReserveFile "ioUM.ini"
  ReserveFile "${C_RELEASE_NOTES}"
  ReserveFile /nonfatal "${C_JAPANESE_RELEASE_NOTES}"
  ReserveFile "${C_POPFILE_MAJOR_VERSION}.${C_POPFILE_MINOR_VERSION}.${C_POPFILE_REVISION}.pcf"
;  ReserveFile "SSL_pm.pat"     ; 0.22.5 does not need any SSL patches so there's no need for a built-in copy

#--------------------------------------------------------------------------
# Installer Function: .onInit - installer starts by offering a choice of languages
#--------------------------------------------------------------------------

Function .onInit

  ; WARNING: The UAC plugin uses $0, $1, $2 and $3 registers

  !define L_UAC_0   $0
  !define L_UAC_1   $1
  !define L_UAC_2   $2
  !define L_UAC_3   $3

  ; The reason why '.onInit' preserves the registers it uses is that it makes debugging easier!

  Push ${L_UAC_0}
  Push ${L_UAC_1}
  Push ${L_UAC_2}
  Push ${L_UAC_3}

  ; Initialise the G_WINUSERNAME and $G_WINUSERTYPE globals _before_ trying to elevate
  ; as this makes it easier to cope with the visible and hidden processes after elevation

  ; The 'UserInfo' plugin may return an error if run on a Win9x system but since Win9x systems
  ; do not support different account types, we treat this error as if user has 'Admin' rights.

  ClearErrors
  UserInfo::GetName
  IfErrors 0 got_name

  ; Assume Win9x system, so user has 'Admin' rights
  ; (UserInfo works on Win98SE so perhaps it is only Win95 that fails ?)

  StrCpy $G_WINUSERNAME "UnknownUser"
  StrCpy $G_WINUSERTYPE "Admin"
  Goto UAC_Elevate

got_name:
  Pop $G_WINUSERNAME
  StrCmp $G_WINUSERNAME "" 0 get_usertype
  StrCpy $G_WINUSERNAME "UnknownUser"

get_usertype:
  UserInfo::GetAccountType
  Pop $G_WINUSERTYPE
  StrCmp $G_WINUSERTYPE "Admin" UAC_Elevate
  StrCmp $G_WINUSERTYPE "Power" UAC_Elevate
  StrCmp $G_WINUSERTYPE "User" UAC_Elevate
  StrCmp $G_WINUSERTYPE "Guest" UAC_Elevate
  StrCpy $G_WINUSERTYPE "Unknown"

  ; Use the UAC plugin to ensure that this installer runs with 'administrator' privileges
  ; (UAC = Vista's new "User Account Control" feature).

UAC_Elevate:
;  MessageBox MB_OK "Debug message (UAC_Elevate label in .onInit function)\
;      ${MB_NL}${MB_NL}\
;      Command-line = $CMDLINE\
;      ${MB_NL}${MB_NL}\
;      $$G_WINUSERNAME = $G_WINUSERNAME\
;      ${MB_NL}${MB_NL}\
;      $$G_WINUSERTYPE = $G_WINUSERTYPE"

  UAC::RunElevated
  StrCmp 1223 ${L_UAC_0} UAC_ElevationAborted   ; Jump if UAC dialog was aborted by user
  StrCmp 0 ${L_UAC_0} 0 UAC_Err                 ; If ${L_UAC_0} is not 0 then an error was detected
  StrCmp 1 ${L_UAC_1} 0 UAC_Success             ; Are we the real deal or just the wrapper ?
  Quit                                          ; UAC not supported (probably pre-NT6), run as normal

UAC_Err:
  MessageBox mb_iconstop "Unable to elevate , error ${L_UAC_0}"
  Abort

UAC_ElevationAborted:
  MessageBox mb_iconstop "This installer requires admin access, aborting!"
  Abort

UAC_Success:
  StrCmp 1 ${L_UAC_3} continue                ; Jump if we are a member of the admin group (any OS)
  StrCmp 3 ${L_UAC_1} 0 UAC_ElevationAborted  ; Can we try to elevate again ?
  MessageBox mb_iconstop "This installer requires admin access, try again"
  goto UAC_Elevate                            ; ... try again

continue:

  !define L_INPUT_FILE_HANDLE   $R9
  !define L_OUTPUT_FILE_HANDLE  $R8
  !define L_TEMP                $R7

  Push ${L_INPUT_FILE_HANDLE}
  Push ${L_OUTPUT_FILE_HANDLE}
  Push ${L_TEMP}

  ; Conditional compilation: if ENGLISH_MODE is defined, support only 'English'

  !ifndef ENGLISH_MODE
        !insertmacro MUI_LANGDLL_DISPLAY
  !endif

  !insertmacro MUI_INSTALLOPTIONS_EXTRACT "ioG.ini"
  !insertmacro MUI_INSTALLOPTIONS_EXTRACT "ioP.ini"

  ; The 1.0.0 release introduced some significant improvements to the support for
  ; the Japanese language so a Japanese version of the release notes was provided
  ; for that release. If future releases do not have a Japanese translation of these
  ; notes then the normal English version will be used.

  StrCmp $LANGUAGE ${LANG_JAPANESE} 0 English_release_notes
  File /nonfatal "/oname=$PLUGINSDIR\${C_README}" "${C_JAPANESE_RELEASE_NOTES}"
  IfFileExists "$PLUGINSDIR\${C_README}" make_txt_file

English_release_notes:
  File "/oname=$PLUGINSDIR\${C_README}" "${C_RELEASE_NOTES}"

make_txt_file:

  ; Ensure the release notes are in a format which the standard Windows NOTEPAD.EXE can use.
  ; When the "POPFile" section is processed, the converted release notes will be copied to the
  ; installation directory to ensure user has a copy which can be read by NOTEPAD.EXE later.

  FileOpen ${L_INPUT_FILE_HANDLE}  "$PLUGINSDIR\${C_README}" r
  FileOpen ${L_OUTPUT_FILE_HANDLE} "$PLUGINSDIR\${C_README}.txt" w
  ClearErrors

loop:
  FileRead ${L_INPUT_FILE_HANDLE} ${L_TEMP}
  IfErrors close_files
  Push ${L_TEMP}
  Call PFI_TrimNewlines
  Pop ${L_TEMP}
  FileWrite ${L_OUTPUT_FILE_HANDLE} "${L_TEMP}${MB_NL}"
  Goto loop

close_files:
  FileClose ${L_INPUT_FILE_HANDLE}
  FileClose ${L_OUTPUT_FILE_HANDLE}

  Pop ${L_TEMP}
  Pop ${L_OUTPUT_FILE_HANDLE}
  Pop ${L_INPUT_FILE_HANDLE}

  !undef L_INPUT_FILE_HANDLE
  !undef L_OUTPUT_FILE_HANDLE
  !undef L_TEMP

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
# Installer Function: .OnInstFailed               (required by UAC plugin)
#--------------------------------------------------------------------------

Function .OnInstFailed

  UAC::Unload     ; Must call unload!

FunctionEnd

#--------------------------------------------------------------------------
# Installer Function: .OnInstSuccess              (required by UAC plugin)
#--------------------------------------------------------------------------

Function .OnInstSuccess

  UAC::Unload     ; Must call unload!

FunctionEnd

#--------------------------------------------------------------------------
# Installer Function: PFIGUIInit
# (custom .onGUIInit function)
#
# Used to complete the initialization of the installer.
# This code was moved from '.onInit' in order to permit the use of language-specific strings
# (the selected language is not available inside the '.onInit' function)
#--------------------------------------------------------------------------

Function PFIGUIInit

  !define L_RESERVED      $1    ; used in the system.dll call

  Push ${L_RESERVED}

  ; Ensure only one copy of this installer is running

  System::Call 'kernel32::CreateMutexA(i 0, i 0, t "OnlyOnePFI_mutex") i .r1 ?e'
  Pop ${L_RESERVED}
  StrCmp ${L_RESERVED} 0 mutex_ok
  MessageBox MB_OK|MB_ICONEXCLAMATION "$(PFI_LANG_INSTALLER_MUTEX)"
  Abort

mutex_ok:
  SearchPath $G_NOTEPAD notepad.exe

  ; Assume user displays the release notes

  StrCpy $G_PFIFLAG "no banner"

  MessageBox MB_YESNO|MB_ICONQUESTION \
      "$(PFI_LANG_MBRELNOTES_1)\
      ${MB_NL}${MB_NL}\
      $(PFI_LANG_MBRELNOTES_2)" IDNO notes_ignored

  StrCmp $G_NOTEPAD "" use_file_association
  Exec 'notepad.exe "$PLUGINSDIR\${C_README}.txt"'
  GoTo continue

use_file_association:
  ExecShell "open" "$PLUGINSDIR\${C_README}.txt"
  Goto continue

notes_ignored:

  ; There may be a slight delay at this point and on some systems the 'WELCOME' page may appear
  ; in two stages (first an empty MUI page appears and a little later the page contents appear).
  ; This looks a little strange (and may prompt the user to start clicking buttons too soon)
  ; so we display a banner to reassure the user. The banner will be removed by 'RemoveBanner'

  StrCpy $G_PFIFLAG "banner displayed"

  Call ShowPleaseWaitBanner

continue:

  ; If 'Nihongo' (Japanese) language has been selected for the installer, ensure the
  ; 'Nihongo Parser' entry is shown on the COMPONENTS page to confirm that a parser will
  ; be installed. The "Nihongo Parser Selection" page appears immediately before the
  ; COMPONENTS page.

  Call ShowOrHideNihongoParser

  StrCpy $G_SSL_ONLY "0"    ; assume a full installation is required
  Call PFI_GetParameters    ; The UAC plugin may modify the command-line
  Push "/SSL"               ; so we need to check for "/SSL" anywhere on
  Call PFI_StrStr           ; the command-line (instead of assuming the
  Pop ${L_RESERVED}         ; command-line is either /SSL or empty)
  StrCmp ${L_RESERVED} "" exit
  StrCpy ${L_RESERVED} ${L_RESERVED} 5
  StrCmp ${L_RESERVED} "/SSL" sslonly
  StrCmp ${L_RESERVED} "/SSL " 0 exit

sslonly:
  StrCpy $G_SSL_ONLY "1"    ; just download and install the SSL support files

exit:
  Pop ${L_RESERVED}

  !undef L_RESERVED

FunctionEnd

#--------------------------------------------------------------------------
# Installer Function: .onVerifyInstDir
#
# This function is called every time the user changes the installation directory. It ensures
# that the button used to start the installation process is labelled "Install" or "Upgrade"
# depending upon the currently selected directory. As this function is called EVERY time the
# directory is altered, the button text is only updated when a change is required.
#
# The '$G_PFIFLAG' global variable is initialized by 'CheckForExistingLocation'
# (the "pre" function for the PROGRAM DIRECTORY page).
#--------------------------------------------------------------------------

Function .onVerifyInstDir

  IfFileExists "$INSTDIR\popfile.pl" upgrade
  StrCmp $G_PFIFLAG "install" exit
  StrCpy $G_PFIFLAG "install"
  GetDlgItem $G_DLGITEM $HWNDPARENT 1
  SendMessage $G_DLGITEM ${WM_SETTEXT} 0 "STR:$(^InstallBtn)"
  Goto exit

upgrade:
  StrCmp $G_PFIFLAG "upgrade" exit
  StrCpy $G_PFIFLAG "upgrade"
  GetDlgItem $G_DLGITEM $HWNDPARENT 1
  SendMessage $G_DLGITEM ${WM_SETTEXT} 0 "STR:$(PFI_LANG_INST_BTN_UPGRADE)"

exit:
FunctionEnd

#--------------------------------------------------------------------------
# Installer Section: StartLog (this must be the very first section)
#
# Creates the log header with information about this installation
#--------------------------------------------------------------------------

Section "-StartLog"

  SetDetailsPrint listonly

  DetailPrint "------------------------------------------------------------"
  DetailPrint "$(^Name) v${C_PFI_VERSION} Installer Log"
  DetailPrint "------------------------------------------------------------"
  DetailPrint "Command-line: $CMDLINE"
  DetailPrint "User Details: $G_WINUSERNAME ($G_WINUSERTYPE)"
  DetailPrint "PFI Language: $LANGUAGE"
  DetailPrint "------------------------------------------------------------"
  Call PFI_GetDateTimeStamp
  Pop $G_PLS_FIELD_1
  DetailPrint "Installation started $G_PLS_FIELD_1"
  DetailPrint "------------------------------------------------------------"
  DetailPrint ""

SectionEnd

#--------------------------------------------------------------------------
# Installer Section: POPFile component (always installed)
#
# Installs the POPFile program files.
#--------------------------------------------------------------------------

Section "POPFile" SecPOPFile
  !include "installer-SecPOPFile-body.nsh"
SectionEnd

; Functions used only by "installer-SecPOPFile-body.nsh"

!include "installer-SecPOPFile-func.nsh"

#--------------------------------------------------------------------------
# Installer Section: Minimal Perl component (always installed)
#
# Installs the minimal Perl.
#--------------------------------------------------------------------------

Section "-Minimal Perl" SecMinPerl
  !include "installer-SecMinPerl-body.nsh"
SectionEnd

#--------------------------------------------------------------------------
# Installer Section: (optional) Skins component (default = selected)
#
# Installs additional skins to allow the look-and-feel of the User Interface
# to be changed. The 'default' skin is always installed (by the 'POPFile'
# section) since this is the default skin for POPFile.
#--------------------------------------------------------------------------

Section "Skins" SecSkins

  !insertmacro SECTIONLOG_ENTER "Skins"

  SetDetailsPrint textonly
  DetailPrint "$(PFI_LANG_INST_PROG_SKINS)"
  SetDetailsPrint listonly

  SetOutPath "$G_ROOTDIR\skins\blue"
  File "..\engine\skins\blue\*.*"

  SetOutPath "$G_ROOTDIR\skins\coolblue"
  File "..\engine\skins\coolblue\*.*"

  SetOutPath "$G_ROOTDIR\skins\coolbrown"
  File "..\engine\skins\coolbrown\*.*"

  SetOutPath "$G_ROOTDIR\skins\coolgreen"
  File "..\engine\skins\coolgreen\*.*"

  SetOutPath "$G_ROOTDIR\skins\coolmint"
  File "..\engine\skins\coolmint\*.*"

  SetOutPath "$G_ROOTDIR\skins\coolorange"
  File "..\engine\skins\coolorange\*.*"

  SetOutPath "$G_ROOTDIR\skins\coolyellow"
  File "..\engine\skins\coolyellow\*.*"

  SetOutPath "$G_ROOTDIR\skins\default"
  File "..\engine\skins\default\*.*"

  SetOutPath "$G_ROOTDIR\skins\glassblue"
  File "..\engine\skins\glassblue\*.*"

  SetOutPath "$G_ROOTDIR\skins\green"
  File "..\engine\skins\green\*.*"

  SetOutPath "$G_ROOTDIR\skins\lavish"
  File "..\engine\skins\lavish\*.*"

  SetOutPath "$G_ROOTDIR\skins\ocean"
  File "..\engine\skins\ocean\*.*"

  SetOutPath "$G_ROOTDIR\skins\oceanblue"
  File "..\engine\skins\oceanblue\*.*"

  SetOutPath "$G_ROOTDIR\skins\orange"
  File "..\engine\skins\orange\*.*"

  SetOutPath "$G_ROOTDIR\skins\orangecream"
  File "..\engine\skins\orangecream\*.*"

  SetOutPath "$G_ROOTDIR\skins\osx"
  File "..\engine\skins\osx\*.*"

  SetOutPath "$G_ROOTDIR\skins\outlook"
  File "..\engine\skins\outlook\*.*"

  SetOutPath "$G_ROOTDIR\skins\simplyblue"
  File "..\engine\skins\simplyblue\*.*"

  SetOutPath "$G_ROOTDIR\skins\sleet"
  File "..\engine\skins\sleet\*.*"

  SetOutPath "$G_ROOTDIR\skins\sleet-rtl"
  File "..\engine\skins\sleet-rtl\*.*"

  SetOutPath "$G_ROOTDIR\skins\smalldefault"
  File "..\engine\skins\smalldefault\*.*"

  SetOutPath "$G_ROOTDIR\skins\smallgrey"
  File "..\engine\skins\smallgrey\*.*"

  SetOutPath "$G_ROOTDIR\skins\strawberryrose"
  File "..\engine\skins\strawberryrose\*.*"

  SetOutPath "$G_ROOTDIR\skins\tinygrey"
  File "..\engine\skins\tinygrey\*.*"

  SetOutPath "$G_ROOTDIR\skins\white"
  File "..\engine\skins\white\*.*"

  SetOutPath "$G_ROOTDIR\skins\windows"
  File "..\engine\skins\windows\*.*"

  SetDetailsPrint textonly
  DetailPrint "$(PFI_LANG_INST_PROG_ENDSEC)"
  SetDetailsPrint listonly

  !insertmacro SECTIONLOG_EXIT "Skins"

SectionEnd

#--------------------------------------------------------------------------
# Installer Section: (optional) UI Languages component (default = selected)
#--------------------------------------------------------------------------

Section "Languages" SecLangs

  !insertmacro SECTIONLOG_ENTER "Languages"

  SetDetailsPrint textonly
  DetailPrint "$(PFI_LANG_INST_PROG_LANGS)"
  SetDetailsPrint listonly

  SetOutPath "$G_ROOTDIR\languages"
  File "..\engine\languages\*.msg"

  SetDetailsPrint textonly
  DetailPrint "$(PFI_LANG_INST_PROG_ENDSEC)"
  SetDetailsPrint listonly

  !insertmacro SECTIONLOG_EXIT "Languages"

SectionEnd

#==========================================================================
#==========================================================================
# The macro-based 'Section' and 'Function' definitions used to handle the
# selection and installation of the Nihongo Parser are in a separate file
#==========================================================================
#==========================================================================

  !include "getparser.nsh"

#==========================================================================
#==========================================================================

#--------------------------------------------------------------------------
# Installer Section: Nihongo Parser component (listed on COMPONENTS page when
# Nihongo language selected, otherwise it is hidden by the 'ShowOrHideNihongoParser'
# function)
#
# Note that this section must always be executed and must always come before
# the sections for the 'Kakasi', 'MeCab' and 'Internal' Nihongo parsers
#--------------------------------------------------------------------------

  !insertmacro SECTION_NIHONGO_PARSER ""

#--------------------------------------------------------------------------
# Installer Section: (optional) Kakasi component (one of the three Nihongo parsers supported)
#
# Although the COMPONENTS page will show a 'Nihongo Parser' component when the installer
# language is set to 'Nihongo', the individual parser components are never shown there.
#--------------------------------------------------------------------------

  !insertmacro SECTION_KAKASI ""

#--------------------------------------------------------------------------
# Installer Section: (optional) MeCab component (one of the three Nihongo parsers supported)
#
# Although the COMPONENTS page will show a 'Nihongo Parser' component when the installer
# language is set to 'Nihongo', the individual parser components are never shown there.
#--------------------------------------------------------------------------

  !insertmacro SECTION_MECAB ""

#--------------------------------------------------------------------------
# Installer Function: VerifyMeCabInstall
#
# Inputs:
#         (top of stack)     - full path to the top-level MeCab folder
# Outputs:
#         (top of stack)     - result ("OK" or "fail")
#--------------------------------------------------------------------------

  !insertmacro FUNCTION_VERIFY_MECAB_INSTALL ""

#--------------------------------------------------------------------------
# Installer Function: GetMeCabFile
#
# Inputs:
#         (top of stack)     - full URL used to download the MeCab file
# Outputs:
#         (top of stack)     - status returned by the download plugin
#--------------------------------------------------------------------------

  !insertmacro FUNCTION_GETMECABFILE ""

#--------------------------------------------------------------------------
# Installer Section: (optional) Internal component (one of the three Nihongo parsers supported)
#
# Although the COMPONENTS page will show a 'Nihongo Parser' component when the installer
# language is set to 'Nihongo', the individual parser components are never shown there.
#--------------------------------------------------------------------------

  !insertmacro SECTION_INTERNALPARSER ""

#--------------------------------------------------------------------------
# Installer Section Group: Optional POPFile Modules which are not part of the
# basic (i.e. default) POPFile installation.
#--------------------------------------------------------------------------

SubSection /e "Optional modules" SubSecOptional

#--------------------------------------------------------------------------
# Installer Section: (optional) POPFile NNTP proxy (default = not selected)
#
# If this component is selected, the installer installs the POPFile NNTP proxy module
#--------------------------------------------------------------------------

Section /o "NNTP proxy" SecNNTP

  !insertmacro SECTIONLOG_ENTER "NNTP Proxy"

  SetOutPath "$G_ROOTDIR\Proxy"
  File "..\engine\Proxy\NNTP.pm"

  !insertmacro SECTIONLOG_EXIT "NNTP Proxy"

SectionEnd

#--------------------------------------------------------------------------
# Installer Section: (optional) POPFile SMTP proxy (default = not selected)
#
# If this component is selected, the installer installs the POPFile SMTP proxy module
#--------------------------------------------------------------------------

Section /o "SMTP proxy" SecSMTP

  !insertmacro SECTIONLOG_ENTER "SMTP Proxy"

  SetOutPath "$G_ROOTDIR\Proxy"
  File "..\engine\Proxy\SMTP.pm"

  !insertmacro SECTIONLOG_EXIT "SMTP Proxy"

SectionEnd

#--------------------------------------------------------------------------
# Installer Section: (optional) POPFile XMLRPC component (default = not selected)
#
# If this component is selected, the installer installs the POPFile XMLRPC support
# (UI\XMLRPC.pm and POPFile\API.pm) and the extra Perl modules required by XMLRPC.pm.
# The XMLRPC module exposes the POPFile API to allow access to many POPFile functions.
#--------------------------------------------------------------------------

Section /o "XMLRPC" SecXMLRPC

  !insertmacro SECTIONLOG_ENTER "XMLRPC"

  SetDetailsPrint textonly
  DetailPrint "$(PFI_LANG_INST_PROG_XMLRPC)"
  SetDetailsPrint listonly

  ; POPFile XMLRPC component

  SetOutPath "$G_ROOTDIR\UI"
  File "..\engine\UI\XMLRPC.pm"

  ; POPFile API component used by XMLRPC.pm

  SetOutPath "$G_ROOTDIR\POPFile"
  File "..\engine\POPFile\API.pm"

  ; Perl modules required to support the POPFile XMLRPC component

  SetOutPath "$G_MPLIBDIR"
  File "${C_PERL_DIR}\lib\LWP.pm"
  File "${C_PERL_DIR}\lib\re.pm"
  File "${C_PERL_DIR}\lib\URI.pm"

  SetOutPath "$G_MPLIBDIR\HTTP"
  File /r "${C_PERL_DIR}\lib\HTTP\*"

  SetOutPath "$G_MPLIBDIR\LWP"
  File /r "${C_PERL_DIR}\lib\LWP\*"

  SetOutPath "$G_MPLIBDIR\Net"
  File "${C_PERL_DIR}\lib\Net\HTT*"

  SetOutPath "$G_MPLIBDIR\Net\HTTP"
  File "${C_PERL_DIR}\lib\Net\HTTP\*"

  SetOutPath "$G_MPLIBDIR\SOAP"
  File /r "${C_PERL_DIR}\site\lib\SOAP\*"

  SetOutPath "$G_MPLIBDIR\Time"
  File /r "${C_PERL_DIR}\lib\Time\*"

  SetOutPath "$G_MPLIBDIR\URI"
  File /r "${C_PERL_DIR}\lib\URI\*"

  SetOutPath "$G_MPLIBDIR\XML"
  File /r "${C_PERL_DIR}\lib\XML\*"

  SetOutPath "$G_MPLIBDIR\XMLRPC"
  File /r "${C_PERL_DIR}\site\lib\XMLRPC\*"

  SetDetailsPrint textonly
  DetailPrint "$(PFI_LANG_INST_PROG_ENDSEC)"
  SetDetailsPrint listonly

  !insertmacro SECTIONLOG_EXIT "XMLRPC"

SectionEnd

#--------------------------------------------------------------------------
# Installer Section: (optional) POPFile IMAP component (default = not selected)
#
# If this component is selected, the installer installs the experimental IMAP module.
#--------------------------------------------------------------------------

Section /o "IMAP" SecIMAP

  !insertmacro SECTIONLOG_ENTER "IMAP"

  SetDetailsPrint textonly
  DetailPrint "Installing IMAP module..."
  SetDetailsPrint listonly

  ; At present (30 July 2004) the IMAP.pm module resides in the 'Services' sub-folder.
  ; Before the 0.22.0 release, the IMAP.pm module was stored in the 'POPFile' sub-folder
  ; then it was moved (briefly) to the 'Server' sub-folder before finally ending up in
  ; the 'Services' sub-folder for the 0.22.0 release.

  SetOutpath "$G_ROOTDIR\Services"
  File "..\engine\Services\IMAP.pm"

  SetOutpath "$G_ROOTDIR\Services\IMAP"
  File "..\engine\Services\IMAP\Client.pm"

  Delete "$G_ROOTDIR\POPFile\IMAP.pm"
  Delete "$G_ROOTDIR\Server\IMAP.pm"

  SetDetailsPrint textonly
  DetailPrint "$(PFI_LANG_INST_PROG_ENDSEC)"
  SetDetailsPrint listonly

  !insertmacro SECTIONLOG_EXIT "IMAP"

SectionEnd

#--------------------------------------------------------------------------
# Installer Section: (optional) Perl IO::Socket::Socks module (default = not selected)
#
# If this component is selected, the installer installs the Perl Socks module to provide
# SOCKS V support for all of the POPFile proxies.
#--------------------------------------------------------------------------

Section /o "SOCKS" SecSOCKS

  !insertmacro SECTIONLOG_ENTER "SOCKS"

  SetOutPath "$G_MPLIBDIR\IO\Socket"
  File "${C_PERL_DIR}\site\lib\IO\Socket\Socks.pm"

  !insertmacro SECTIONLOG_EXIT "SOCKS"

SectionEnd

#--------------------------------------------------------------------------
# Installer Section: (optional) SSL Support for POPFile (default = not selected)
#
# If this component is selected, the installer downloads and installs the extra
# Perl modules and the necessary OpenSSL libraries required to support SSL access
# access to mail servers. The installer waits until all of these extra files have
# been downloaded before installing any of them. If the download attempt fails, the
# installation will continue (since SSL support is an optional feature). A later
# attempt can be made by running the stand-alone 'SSL Setup' wizard to download
# and install only these extra SSL support files.
#
# Note: The 'getssl.nsh' file includes more than just the 'Section' code.
#
# The 'getssl.nsh' file is used by the 'SSL Setup' wizard to ensure it
# handles the downloading and installation of the SSL support files in the
# same way as the main POPFile installer.
#--------------------------------------------------------------------------

  !include "getssl.nsh"

  !insertmacro SSL_SUPPORT_FOR_INSTALLER

SubSectionEnd

#--------------------------------------------------------------------------
# Installer Section: StopLog (this must be the very last section)
#
# Finishes the log file and saves it (making backups of up to 3 previous logs)
#--------------------------------------------------------------------------

Section "-StopLog"

  SetDetailsPrint textonly
  DetailPrint "$(PFI_LANG_PROG_SAVELOG)"
  SetDetailsPrint listonly
  Call PFI_GetDateTimeStamp
  Pop $G_PLS_FIELD_1
  StrCmp $G_SSL_ONLY "0" normal_log
  DetailPrint "------------------------------------------------------------"
  DetailPrint "SSL Support installation finished $G_PLS_FIELD_1"
  DetailPrint "------------------------------------------------------------"
  Goto save_log

normal_log:
  DetailPrint "------------------------------------------------------------"
  DetailPrint "'Add POPFile User' will be called to configure POPFile"
  IfRebootFlag 0 close_log
  DetailPrint "(a reboot is required to complete the Kakasi installation)"

close_log:
  DetailPrint "------------------------------------------------------------"
  DetailPrint "Main program installation finished $G_PLS_FIELD_1"
  DetailPrint "------------------------------------------------------------"

save_log:

  ; Save a log showing what was installed

  !insertmacro PFI_BACKUP_123_DP "$G_ROOTDIR" "install.log"
  Push "$G_ROOTDIR\install.log"
  Call PFI_DumpLog
  DetailPrint "Log report saved in '$G_ROOTDIR\install.log'"
  SetDetailsPrint textonly
  DetailPrint "$(PFI_LANG_INST_PROG_ENDSEC)"
  SetDetailsPrint listonly

SectionEnd

#--------------------------------------------------------------------------
# Component-selection page descriptions
#--------------------------------------------------------------------------

  !insertmacro MUI_FUNCTION_DESCRIPTION_BEGIN
    !insertmacro MUI_DESCRIPTION_TEXT ${SecPOPFile}     $(DESC_SecPOPFile)
    !insertmacro MUI_DESCRIPTION_TEXT ${SecSkins}       $(DESC_SecSkins)
    !insertmacro MUI_DESCRIPTION_TEXT ${SecLangs}       $(DESC_SecLangs)
    !insertmacro MUI_DESCRIPTION_TEXT ${SecParser}      "${C_NPLS_DESC_SecParser}"
    !insertmacro MUI_DESCRIPTION_TEXT ${SubSecOptional} $(DESC_SubSecOptional)
    !insertmacro MUI_DESCRIPTION_TEXT ${SecNNTP}        $(DESC_SecNNTP)
    !insertmacro MUI_DESCRIPTION_TEXT ${SecSMTP}        $(DESC_SecSMTP)
    !insertmacro MUI_DESCRIPTION_TEXT ${SecXMLRPC}      $(DESC_SecXMLRPC)
    !insertmacro MUI_DESCRIPTION_TEXT ${SecIMAP}        $(DESC_SecIMAP)
    !insertmacro MUI_DESCRIPTION_TEXT ${SecSOCKS}       $(DESC_SecSOCKS)
    !insertmacro MUI_DESCRIPTION_TEXT ${SecSSL}         $(DESC_SecSSL)
  !insertmacro MUI_FUNCTION_DESCRIPTION_END

#--------------------------------------------------------------------------
# Installer Function: ShowOrHideNihongoParser
#
# (called by 'PFIGUIInit', our custom '.onGUIInit' function)
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

  !insertmacro FUNCTION_SHOW_OR_HIDE_NIHONGO_PARSER ""

#--------------------------------------------------------------------------
# Installer Function: CheckPerlRequirementsPage
#
# The minimal Perl we install requires some Microsoft components which are included in the
# current versions of Windows. Older systems will have suitable versions of these components
# provided Internet Explorer 5.5 or later has been installed. If we find an earlier version
# of Internet Explorer is installed, we suggest the user upgrades to IE 5.5 or later.
#
# It seems that the functions required by POPFile can be supplied by IE 5.0 so we only show
# this page if we find a version earlier than IE 5 (or if we fail to detect the IE version).
#--------------------------------------------------------------------------

Function CheckPerlRequirementsPage

  !define L_TEMP      $R9

  Push ${L_TEMP}

  Call PFI_GetIEVersion
  Pop $G_PLS_FIELD_1

  StrCpy ${L_TEMP} $G_PLS_FIELD_1 1
  StrCmp ${L_TEMP} '?' not_good
  IntCmp ${L_TEMP} 5 exit not_good exit

not_good:

  ; Ensure custom page matches the selected language (left-to-right or right-to-left order)

  !insertmacro MUI_INSTALLOPTIONS_WRITE "ioG.ini" "Settings" "RTL" "$(^RTL)"

  !insertmacro PFI_IO_TEXT "ioG.ini" "1" \
      "$(PFI_LANG_PERLREQ_IO_TEXT_A)\
       $(PFI_LANG_PERLREQ_IO_TEXT_B)\
       $(PFI_LANG_PERLREQ_IO_TEXT_C)\
       $(PFI_LANG_PERLREQ_IO_TEXT_D)"

  !insertmacro PFI_IO_TEXT "ioG.ini" "2" \
      "$(PFI_LANG_PERLREQ_IO_TEXT_E)\
       $(PFI_LANG_PERLREQ_IO_TEXT_F)\
       $(PFI_LANG_PERLREQ_IO_TEXT_G)"

  !insertmacro MUI_HEADER_TEXT "$(PFI_LANG_PERLREQ_TITLE)" " "

  !insertmacro MUI_INSTALLOPTIONS_DISPLAY "ioG.ini"

exit:
  Pop ${L_TEMP}

  !undef L_TEMP

FunctionEnd

#--------------------------------------------------------------------------
# Installer Function: ChooseParser
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

  !insertmacro FUNCTION_CHOOSEPARSER ""

#--------------------------------------------------------------------------
# Installer Function: GetPermissionToInstall
# (this is the last page shown before the installation starts)
#
# Display the information collected from the user to show what we are about to do.
# The 'Back' button can be used to navigate to earlier pages if the user wishes to
# change this information (i.e. select/deselect a component or change the install folder)
#--------------------------------------------------------------------------

Function GetPermissionToInstall

  !define L_TEMP   $R9

  Push ${L_TEMP}

  ; This is a very simple custom page so we create the INI file here

  ; Ensure custom page matches the selected language (left-to-right or right-to-left order)

  !insertmacro MUI_INSTALLOPTIONS_WRITE "ioData.ini" "Settings" "RTL" "$(^RTL)"

  !insertmacro MUI_INSTALLOPTIONS_WRITE "ioData.ini" "Settings" "NumFields" "1"

  !insertmacro MUI_INSTALLOPTIONS_WRITE "ioData.ini" "Field 1"  "Type"   "text"
  !insertmacro MUI_INSTALLOPTIONS_WRITE "ioData.ini" "Field 1"  "Left"   "0"
  !insertmacro MUI_INSTALLOPTIONS_WRITE "ioData.ini" "Field 1"  "Right"  "300"
  !insertmacro MUI_INSTALLOPTIONS_WRITE "ioData.ini" "Field 1"  "Top"    "0"
  !insertmacro MUI_INSTALLOPTIONS_WRITE "ioData.ini" "Field 1"  "Bottom" "140"
  !insertmacro MUI_INSTALLOPTIONS_WRITE "ioData.ini" "Field 1"  "Flags"  "MULTILINE|HSCROLL|VSCROLL|READONLY"

  !insertmacro MUI_HEADER_TEXT "$(PFI_LANG_SUMMARY_TITLE)" "$(PFI_LANG_SUMMARY_SUBTITLE)"

  ; The entries in the "Basic" and "Optional" component lists are indented a little

  !define C_NLT     "${IO_NL}\t"

  ; Convert the installation pathname into a string which is safe to use in the summary page

  Push $G_ROOTDIR
  Call NSIS2IO
  Pop $G_PLS_FIELD_2

  IfFileExists "$G_ROOTDIR\popfile.pl" upgrade
  StrCpy ${L_TEMP} "$(PFI_LANG_SUMMARY_NEWLOCN)"
  GetDlgItem $G_DLGITEM $HWNDPARENT 1
  SendMessage $G_DLGITEM ${WM_SETTEXT} 0 "STR:$(^InstallBtn)"
  Goto start_summary

upgrade:
  StrCpy ${L_TEMP} "$(PFI_LANG_SUMMARY_UPGRADELOCN)"
  GetDlgItem $G_DLGITEM $HWNDPARENT 1
  SendMessage $G_DLGITEM ${WM_SETTEXT} 0 "STR:$(PFI_LANG_INST_BTN_UPGRADE)"

start_summary:
  StrCpy $G_PLS_FIELD_1 "${L_TEMP}${IO_NL}${IO_NL}\
      $(PFI_LANG_SUMMARY_BASICLIST)"
  StrCpy ${L_TEMP} "${C_NLT}$(PFI_LANG_SUMMARY_NONE)"

  !insertmacro PFI_SectionNotSelected ${SecPOPFile} check_min_perl
  StrCpy ${L_TEMP} ""
  StrCpy $G_PLS_FIELD_1 "$G_PLS_FIELD_1${C_NLT}\
          $(PFI_LANG_SUMMARY_POPFILECORE)${C_NLT}\
          $(PFI_LANG_SUMMARY_DEFAULTSKIN)${C_NLT}\
          $(PFI_LANG_SUMMARY_DEFAULTLANG)"

check_min_perl:
  !insertmacro PFI_SectionNotSelected ${SecMinPerl} check_skins
  StrCpy ${L_TEMP} ""
  StrCpy $G_PLS_FIELD_1 "$G_PLS_FIELD_1${C_NLT}$(PFI_LANG_SUMMARY_MINPERL)"

check_skins:
  !insertmacro PFI_SectionNotSelected ${SecSkins} check_langs
  StrCpy ${L_TEMP} ""
  StrCpy $G_PLS_FIELD_1 "$G_PLS_FIELD_1${C_NLT}$(PFI_LANG_SUMMARY_EXTRASKINS)"

check_langs:
  !insertmacro PFI_SectionNotSelected ${SecLangs} check_kakasi
  StrCpy ${L_TEMP} ""
  StrCpy $G_PLS_FIELD_1 "$G_PLS_FIELD_1${C_NLT}$(PFI_LANG_SUMMARY_EXTRALANGS)"

check_kakasi:
  !insertmacro PFI_SectionNotSelected ${SecKakasi} check_mecab
  StrCpy ${L_TEMP} ""
  StrCpy $G_PLS_FIELD_1 "$G_PLS_FIELD_1${C_NLT}${C_NPLS_SUMMARY_KAKASI}"

check_mecab:
  !insertmacro PFI_SectionNotSelected ${SecMeCab} check_internal
  StrCpy ${L_TEMP} ""
  StrCpy $G_PLS_FIELD_1 "$G_PLS_FIELD_1${C_NLT}${C_NPLS_SUMMARY_MECAB}"

check_internal:
  !insertmacro PFI_SectionNotSelected ${SecInternalParser} end_basic
  StrCpy ${L_TEMP} ""
  StrCpy $G_PLS_FIELD_1 "$G_PLS_FIELD_1${C_NLT}${C_NPLS_SUMMARY_INTERNAL}"

end_basic:
  StrCpy $G_PLS_FIELD_1 "$G_PLS_FIELD_1${L_TEMP}${IO_NL}${IO_NL}\
      $(PFI_LANG_SUMMARY_OPTIONLIST)"

  ; Check the optional components in alphabetic order

  StrCpy ${L_TEMP} "${C_NLT}$(PFI_LANG_SUMMARY_NONE)"

  !insertmacro PFI_SectionNotSelected ${SecIMAP} check_nntp
  StrCpy ${L_TEMP} ""
  StrCpy $G_PLS_FIELD_1 "$G_PLS_FIELD_1${C_NLT}$(PFI_LANG_SUMMARY_IMAP)"

check_nntp:
  !insertmacro PFI_SectionNotSelected ${SecNNTP} check_smtp
  StrCpy ${L_TEMP} ""
  StrCpy $G_PLS_FIELD_1 "$G_PLS_FIELD_1${C_NLT}$(PFI_LANG_SUMMARY_NNTP)"

check_smtp:
  !insertmacro PFI_SectionNotSelected ${SecSMTP} check_socks
  StrCpy ${L_TEMP} ""
  StrCpy $G_PLS_FIELD_1 "$G_PLS_FIELD_1${C_NLT}$(PFI_LANG_SUMMARY_SMTP)"

check_socks:
  !insertmacro PFI_SectionNotSelected ${SecSOCKS} check_ssl
  StrCpy ${L_TEMP} ""
  StrCpy $G_PLS_FIELD_1 "$G_PLS_FIELD_1${C_NLT}$(PFI_LANG_SUMMARY_SOCKS)"

check_ssl:
  !insertmacro PFI_SectionNotSelected ${SecSSL} check_xmlrpc
  StrCpy ${L_TEMP} ""
  StrCpy $G_PLS_FIELD_1 "$G_PLS_FIELD_1${C_NLT}$(PFI_LANG_SUMMARY_SSL)"

check_xmlrpc:
  !insertmacro PFI_SectionNotSelected ${SecXMLRPC} end_optional
  StrCpy ${L_TEMP} ""
  StrCpy $G_PLS_FIELD_1 "$G_PLS_FIELD_1${C_NLT}$(PFI_LANG_SUMMARY_XMLRPC)"

end_optional:
  StrCpy $G_PLS_FIELD_1 "$G_PLS_FIELD_1${L_TEMP}${IO_NL}${IO_NL}\
      $(PFI_LANG_SUMMARY_BACKBUTTON)"

  !insertmacro MUI_INSTALLOPTIONS_WRITE "ioData.ini" "Field 1" "State" $G_PLS_FIELD_1

  ; Set focus to the button labelled "Install" or "Upgrade" (instead of the "Summary" data)

  !insertmacro MUI_INSTALLOPTIONS_INITDIALOG "ioData.ini"
  Pop ${L_TEMP}
  GetDlgItem $G_DLGITEM $HWNDPARENT 1
  SendMessage $HWNDPARENT ${WM_NEXTDLGCTL} $G_DLGITEM 1
  !insertmacro MUI_INSTALLOPTIONS_SHOW

  Pop ${L_TEMP}

  !undef L_TEMP

FunctionEnd

#--------------------------------------------------------------------------
# Installer Function: RemoveBanner
# (the "pre" function for the 'WELCOME' page)
#--------------------------------------------------------------------------

Function RemoveBanner

  StrCmp $G_PFIFLAG "no banner" exit

  ; Remove the banner which was displayed by the 'PFIGUIInit' function

  Sleep ${C_MIN_BANNER_DISPLAY_TIME}
  Banner::destroy

exit:

FunctionEnd

#--------------------------------------------------------------------------
# Installer Function: HandleParserSelection
# (the "leave" function for the Nihongo Parser selection page)
#
# Used to handle user input on the Nihongo Parser selection page.
#--------------------------------------------------------------------------

  !insertmacro FUNCTION_HANDLE_PARSER_SELECTION ""

#--------------------------------------------------------------------------
# Installer Function: CheckSSLOnlyFlag
# (the "pre" function for the COMPONENTS selection page)
#
# If only the SSL Support files are to be installed, disable the other
# POPFile-component sections and skip the COMPONENTS page
#--------------------------------------------------------------------------

Function CheckSSLOnlyFlag

  StrCmp $G_SSL_ONLY "0" exit

  !insertmacro UnselectSection ${SecPOPFile}
  !insertmacro UnselectSection ${SecMinPerl}
  !insertmacro UnselectSection ${SecSkins}
  !insertmacro UnselectSection ${SecLangs}
  !insertmacro UnselectSection ${SecKakasi}
  !insertmacro UnselectSection ${SecMeCab}
  !insertmacro UnselectSection ${SecInternalParser}
  !insertmacro UnselectSection ${SecNNTP}
  !insertmacro UnselectSection ${SecSMTP}
  !insertmacro UnselectSection ${SecXMLRPC}
  !insertmacro UnselectSection ${SecIMAP}
  !insertmacro UnselectSection ${SecSOCKS}

  !insertmacro SelectSection ${SecSSL}

  ; Do not display the COMPONENTS page

  Abort

exit:

  ; Display the COMPONENTS page

FunctionEnd

#--------------------------------------------------------------------------
# Installer Function: CheckForExistingLocation
# (the "pre" function for the POPFile PROGRAM DIRECTORY selection page)
#
# Set the initial value used by the POPFile PROGRAM DIRECTORY page to the location used by
# the most recent 0.21.0 (or later version) or the location of any pre-0.21.0 installation.
#--------------------------------------------------------------------------

Function CheckForExistingLocation

  ; Initialize the $G_PFIFLAG used by the '.onVerifyInstDir' function to avoid sending
  ; unnecessary messages to change the text on the button used to start the installation

  StrCpy $G_PFIFLAG ""

  ReadRegStr $INSTDIR HKCU "Software\POPFile Project\${C_PFI_PRODUCT}\MRI" "InstallPath"
  StrCmp $INSTDIR "" try_HKLM
  IfFileExists "$INSTDIR\*.*" exit

try_HKLM:
  ReadRegStr $INSTDIR HKLM "Software\POPFile Project\${C_PFI_PRODUCT}\MRI" "InstallPath"
  StrCmp $INSTDIR "" try_old_style
  IfFileExists "$INSTDIR\*.*" exit

try_old_style:
  ReadRegStr $INSTDIR HKLM "Software\POPFile" "InstallLocation"
  StrCmp $INSTDIR "" use_default
  IfFileExists "$INSTDIR\*.*" exit

use_default:
  StrCpy $INSTDIR "$PROGRAMFILES\${C_PFI_PRODUCT}"

exit:
FunctionEnd

#--------------------------------------------------------------------------
# Installer Function: CheckExistingProgDir
# (the "leave" function for the POPFile PROGRAM DIRECTORY selection page)
#
# The POPFile PROGRAM DIRECTORY page uses the standard $INSTDIR variable so NSIS
# automatically strips any trailing backslashes from the path selected by the user.
#
# Now that we are overriding the default 'InstallDir' behaviour it is easier for the
# user to select the main 'Program Files' folder so we check for this case and refuse
# to accept this path.
#
# This function is used to check if a previous POPFile installation exists in the directory
# chosen for this installation's POPFile PROGRAM files (popfile.pl, etc). If we find one,
# we check if it contains any of the optional components and remind the user if it seems that
# they have forgotten to 'upgrade' them.
#--------------------------------------------------------------------------

Function CheckExistingProgDir

  !define L_RESULT  $R9

  Push ${L_RESULT}

  ; We do not permit POPFile to be installed in the target system's 'Program Files' folder
  ; (i.e. we do not allow 'popfile.pl' etc to be stored there)

  StrCmp $INSTDIR "$PROGRAMFILES" return_to_directory_selection

  ; Assume SFN support is enabled (the default setting for Windows)

  StrCpy $G_SFN_DISABLED "0"

  Push $INSTDIR
  Call PFI_GetSFNStatus
  Pop ${L_RESULT}
  StrCmp ${L_RESULT} "1" check_SFN_PROGRAMFILES
  StrCpy $G_SFN_DISABLED "1"

  ; Short file names are not supported here, so we cannot accept any path containing spaces.

  Push $INSTDIR
  Push ' '
  Call PFI_StrStr
  Pop ${L_RESULT}
  StrCmp ${L_RESULT} "" check_locn
  Push $INSTDIR
  Call PFI_GetRoot
  Pop $G_PLS_FIELD_1
  MessageBox MB_OK|MB_ICONEXCLAMATION "$(PFI_LANG_DIRSELECT_MBNOSFN)"

  ; Return to the POPFile PROGRAM DIRECTORY selection page

return_to_directory_selection:
  Pop ${L_RESULT}
  Abort

check_SFN_PROGRAMFILES:
  GetFullPathName /SHORT ${L_RESULT} "$PROGRAMFILES"
  StrCmp $INSTDIR ${L_RESULT} return_to_directory_selection

check_locn:

  ; Initialise the global user variable used for the POPFile PROGRAM files location
  ; (we always try to use the LFN format, even if the user has entered a SFN format path)

  StrCpy $G_ROOTDIR "$INSTDIR"
  Push $G_ROOTDIR
  Call PFI_GetCompleteFPN
  Pop ${L_RESULT}
  StrCmp ${L_RESULT} "" got_path
  StrCpy $G_ROOTDIR ${L_RESULT}

got_path:
  Pop ${L_RESULT}

  ; Warn the user if we are about to upgrade an existing installation
  ; and allow user to select a different directory if they wish

  IfFileExists "$G_ROOTDIR\popfile.pl" warning
  Goto continue

warning:
  MessageBox MB_YESNO|MB_ICONQUESTION "$(PFI_LANG_DIRSELECT_MBWARN_1)\
      ${MB_NL}${MB_NL}\
      $G_ROOTDIR\
      ${MB_NL}${MB_NL}${MB_NL}\
      $(PFI_LANG_DIRSELECT_MBWARN_2)" IDYES check_options

  ; Return to the POPFile PROGRAM DIRECTORY selection page

  Abort

check_options:

  ; If we are only installing the SSL support files, there is no need to check the options

  StrCmp $G_SSL_ONLY "1" continue

  ; If user has NOT selected a program component on the COMPONENTS page and we find that the
  ; version we are about to upgrade includes that program component then the user is asked for
  ; permission to upgrade the component [To do: disable the component if user says 'No' ??]

  !insertmacro SectionFlagIsSet ${SecIMAP} ${SF_SELECTED} check_nntp look_for_imap

look_for_imap:
  IfFileExists "$G_ROOTDIR\Services\IMAP.pm" ask_about_imap
  IfFileExists "$G_ROOTDIR\Server\IMAP.pm" ask_about_imap
  IfFileExists "$G_ROOTDIR\POPFile\IMAP.pm" ask_about_imap check_nntp

ask_about_imap:
  StrCpy $G_PLS_FIELD_1 "POPFile IMAP"
  MessageBox MB_YESNO|MB_ICONQUESTION "$(MBCOMPONENT_PROB_1)\
      ${MB_NL}${MB_NL}\
      $(MBCOMPONENT_PROB_2)" IDNO check_nntp
  !insertmacro SelectSection ${SecIMAP}

check_nntp:
  !insertmacro SectionFlagIsSet ${SecNNTP} ${SF_SELECTED} check_smtp look_for_nntp

look_for_nntp:
  IfFileExists "$G_ROOTDIR\Proxy\NNTP.pm" 0 check_smtp
  StrCpy $G_PLS_FIELD_1 "POPFile NNTP proxy"
  MessageBox MB_YESNO|MB_ICONQUESTION "$(MBCOMPONENT_PROB_1)\
      ${MB_NL}${MB_NL}\
      $(MBCOMPONENT_PROB_2)" IDNO check_smtp
  !insertmacro SelectSection ${SecNNTP}

check_smtp:
  !insertmacro SectionFlagIsSet ${SecSMTP} ${SF_SELECTED} check_socks look_for_smtp

look_for_smtp:
  IfFileExists "$G_ROOTDIR\Proxy\SMTP.pm" 0 check_socks
  StrCpy $G_PLS_FIELD_1 "POPFile SMTP proxy"
  MessageBox MB_YESNO|MB_ICONQUESTION "$(MBCOMPONENT_PROB_1)\
      ${MB_NL}${MB_NL}\
      $(MBCOMPONENT_PROB_2)" IDNO check_socks
  !insertmacro SelectSection ${SecSMTP}

check_socks:
  !insertmacro SectionFlagIsSet ${SecSOCKS} ${SF_SELECTED} check_xmlrpc look_for_socks

look_for_socks:
  IfFileExists "$G_ROOTDIR\lib\IO\Socket\Socks.pm" 0 check_xmlrpc
  StrCpy $G_PLS_FIELD_1 "SOCKS support"
  MessageBox MB_YESNO|MB_ICONQUESTION "$(MBCOMPONENT_PROB_1)\
      ${MB_NL}${MB_NL}\
      $(MBCOMPONENT_PROB_2)" IDNO check_xmlrpc
  !insertmacro SelectSection ${SecSOCKS}

check_xmlrpc:
  !insertmacro SectionFlagIsSet ${SecXMLRPC} ${SF_SELECTED} continue look_for_xmlrpc

look_for_xmlrpc:
  IfFileExists "$G_ROOTDIR\UI\XMLRPC.pm" 0 continue
  StrCpy $G_PLS_FIELD_1 "POPFile XMLRPC"
  MessageBox MB_YESNO|MB_ICONQUESTION "$(MBCOMPONENT_PROB_1)\
      ${MB_NL}${MB_NL}\
      $(MBCOMPONENT_PROB_2)" IDNO continue
  !insertmacro SelectSection ${SecXMLRPC}

continue:

  ; Move on to the next page in the installer

  !undef L_RESULT

FunctionEnd

#--------------------------------------------------------------------------
# Installer Function: InstallUserData
# (the "pre" function for the FINISH page)
#--------------------------------------------------------------------------

Function InstallUserData

  !define L_UAC_0   $0

  ; If we are only downloading and installing the SSL support files, display the FINISH page

  StrCmp $G_SSL_ONLY "1" exit

  ; For normal installations, skip our own FINISH page and disable the "Add POPFile User"
  ; wizard's language selection dialog to make the wizard appear as an extension of the main
  ; 'setup.exe' installer.
  ; [Future builds may pass more than just a command-line switch to the wizard]

  ; Use the UAC plugin to ensure that adduser.exe runs with 'current user' privileges
  ; (UAC = Vista's new "User Account Control" feature).
  ;
  ; WARNING: The UAC plugin uses $0, $1, $2 and $3 registers

  IfRebootFlag special_case
  Push ${L_UAC_0}
  UAC::Exec "" "$G_ROOTDIR\adduser.exe" "/install" ""
  Pop ${L_UAC_0}
  Abort

special_case:
  Push ${L_UAC_0}
  UAC::Exec "" "$G_ROOTDIR\adduser.exe" "/installreboot" ""
  Pop ${L_UAC_0}
  Abort

exit:

  ; Display the FINISH page

  !undef L_UAC_0

FunctionEnd

#--------------------------------------------------------------------------
# Installer Function: ShowReadMe
# (the "ReadMe" function for the FINISH page)
#--------------------------------------------------------------------------

Function ShowReadMe

  StrCmp $G_NOTEPAD "" use_file_association
  Exec 'notepad.exe "$G_ROOTDIR\${C_README}.txt"'
  goto exit

use_file_association:
  ExecShell "open" "$G_ROOTDIR\${C_README}.txt"

exit:
FunctionEnd


#==========================================================================
#==========================================================================
# The 'Uninstall' part of the script is in a separate file
#==========================================================================
#==========================================================================

  !include "installer-Uninstall.nsh"

#==========================================================================
#==========================================================================


#--------------------------------------------------------------------------
# Macro-based Functions make it easier to maintain identical functions
# which are (or might be) used in the installer and in the uninstaller.
#--------------------------------------------------------------------------

!macro ShowPleaseWaitBanner UN
  Function ${UN}ShowPleaseWaitBanner

    !ifndef ENGLISH_MODE

      ; The Banner plug-in uses the "MS Shell Dlg" font to display the banner text but
      ; East Asian versions of Windows 9x do not support this so in these cases we use
      ; "English" text for the banner (otherwise the text would be unreadable garbage).

      !define L_RESULT    $R9   ; The 'IsNT' function returns 0 if Win9x was detected

      Push ${L_RESULT}

      Call PFI_IsNT
      Pop ${L_RESULT}
      StrCmp ${L_RESULT} "1" show_banner

      ; Windows 9x has been detected

      StrCmp $LANGUAGE ${LANG_SIMPCHINESE} use_ENGLISH_banner
      StrCmp $LANGUAGE ${LANG_TRADCHINESE} use_ENGLISH_banner
      StrCmp $LANGUAGE ${LANG_JAPANESE} use_ENGLISH_banner
      StrCmp $LANGUAGE ${LANG_KOREAN} use_ENGLISH_banner
      Goto show_banner

    use_ENGLISH_banner:
      Banner::show /NOUNLOAD /set 76 "Please be patient." "This may take a few seconds..."
      Goto continue

      show_banner:
    !endif

    Banner::show /NOUNLOAD /set 76 "$(PFI_LANG_BE_PATIENT)" "$(PFI_LANG_TAKE_A_FEW_SECONDS)"

    !ifndef ENGLISH_MODE
      continue:
        Pop ${L_RESULT}

        !undef L_RESULT
    !endif

  FunctionEnd
!macroend

#--------------------------------------------------------------------------
# Installer Function: ShowPleaseWaitBanner
#
# This function is used during the installation process
#--------------------------------------------------------------------------

!insertmacro ShowPleaseWaitBanner ""

#--------------------------------------------------------------------------
# Uninstaller Function: un.ShowPleaseWaitBanner
#
# This function is used during the uninstall process
#--------------------------------------------------------------------------

;!insertmacro ShowPleaseWaitBanner "un."

#--------------------------------------------------------------------------
# Macro-based Function: NSIS2IO
#
# Convert an NSIS string to a form suitable for use by InstallOptions
#
# Inputs:
#         (top of stack)     - a string to be used on an InstallOptions page
# Outputs:
#         (top of stack)     - a safe version of the input which will be displayed correctly
#
# Usage:
#         Push "C:\Install\Workshop\restore"        ; InstallOptions treats '\r' as a CR char
#         Call NSIS2IO
#         Pop $R0
#
#         $R0 will now hold "C:\\Install\\Workshop\\restore"
#         to make InstallOptions display "C:\Install\Workshop\restore" on one line
#         instead of using two lines to display the string like this:
#             C:\Install\Workshop
#             estore
#
#--------------------------------------------------------------------------

!macro NSIS2IO UN
  Function ${UN}NSIS2IO

    !define L_STRING      $R0   ; the string to be converted
    !define L_LENGTH      $R1   ; length of string
    !define L_OFFSET      $R2   ; current character offset (offset 0 = first character)
    !define L_CURRENT     $R3   ; current character(s) from string
    !define L_CONVERTED   $R4   ; InstallOptions equivalent character-pair

    Exch ${L_STRING}
    Push ${L_LENGTH}
    Push ${L_OFFSET}
    Push ${L_CURRENT}
    Push ${L_CONVERTED}

    ; Get length of input string (use length so we can cope with MBCS strings;
    ; the previous version of this function looped through the string until
    ; a null byte ("") was found - this resulted in the truncation of some
    ; MBCS strings)

    StrLen ${L_LENGTH} ${L_STRING}

    StrCpy ${L_OFFSET} -1

    ; Loop until end of string is reached

  loop:
    IntOp ${L_OFFSET} ${L_OFFSET} + 1
    IntCmp ${L_OFFSET} ${L_LENGTH} exit 0 exit

    ; Get the next character from the string

    StrCpy ${L_CURRENT} ${L_STRING} 1 ${L_OFFSET}

    ; Check if this is one of the characters that needs to be converted

    StrCmp ${L_CURRENT} "$\r" carriagereturn
    StrCmp ${L_CURRENT} "$\n" linefeed
    StrCmp ${L_CURRENT} "$\t" tab
    StrCmp ${L_CURRENT} "\"   backslash
    Goto loop

  carriagereturn:
    StrCpy ${L_CONVERTED} "\r"
    Goto replace_char

  linefeed:
    StrCpy ${L_CONVERTED} "\n"
    Goto replace_char

  tab:
    StrCpy ${L_CONVERTED} "\t"
    Goto replace_char

  backslash:
    StrCpy ${L_CONVERTED} "\\"

  replace_char:
    StrCpy ${L_CURRENT} ${L_STRING} ${L_OFFSET}
    IntOp ${L_OFFSET} ${L_OFFSET} + 1
    StrCpy ${L_STRING} ${L_STRING} "" ${L_OFFSET}
    StrCpy ${L_STRING} "${L_CURRENT}${L_CONVERTED}${L_STRING}"
    IntOp ${L_LENGTH} ${L_LENGTH} + 1
    Goto loop

    ; Return "InstallOptions-safe" string

  exit:
    Pop ${L_CONVERTED}
    Pop ${L_CURRENT}
    Pop ${L_OFFSET}
    Pop ${L_LENGTH}
    Exch ${L_STRING}

    !undef L_STRING
    !undef L_LENGTH
    !undef L_OFFSET
    !undef L_CURRENT
    !undef L_CONVERTED

  FunctionEnd
!macroend

#--------------------------------------------------------------------------
# Installer Function: NSIS2IO
#
# This function is used during the installation process
#--------------------------------------------------------------------------

!insertmacro NSIS2IO ""

#--------------------------------------------------------------------------
# Uninstaller Function: un.NSIS2IO
#
# This function is used during the uninstall process
#--------------------------------------------------------------------------

!insertmacro NSIS2IO "un."

#--------------------------------------------------------------------------
# End of 'installer.nsi'
#--------------------------------------------------------------------------