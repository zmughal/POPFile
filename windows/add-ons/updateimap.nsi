#--------------------------------------------------------------------------
#
# updateimap.nsi --- This is the NSIS script used to create a utility which downloads and
#                    installs either the latest version of the experimental IMAP.pm module
#                    or the version specified on the command-line. This utility is intended
#                    for use with an existing POPFile 0.22.x installation (the IMAP module
#                    is still 'experimental' so it was not shipped with the 0.22.0 or 0.22.1
#                    releases).
#
# Copyright (c) 2004-2007 John Graham-Cumming
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


  ;------------------------------------------------
  ; This script requires the 'Inetc' NSIS plugin
  ;------------------------------------------------

  ; This script uses a special NSIS plugin (Inetc) to download the IMAP.pm file.
  ; The standard NSISdl plugin shipped with NSIS cannot be used here because the
  ; SourceForge server does not supply the necessary header information. The Inetc
  ; plugin also has much better proxy support than the standard NSISdl plugin.
  ;
  ; The 'NSIS Wiki' page for the 'Inetc' plugin (description, example and download links):
  ; http://nsis.sourceforge.net/Inetc_plug-in
  ;
  ; To compile this script, copy the 'inetc.dll' file to the standard NSIS plugins folder
  ; (${NSISDIR}\Plugins\). The 'Inetc' source and example files can be unzipped to the
  ; appropriate ${NSISDIR} sub-folders if you wish, but this step is entirely optional.
  ;
  ; Tested with the inetc.dll plugin timestamped 1 January 2007 19:03:52


#--------------------------------------------------------------------------
# Optional run-time command-line switch (used by 'updateimap.exe')
#--------------------------------------------------------------------------
#
# /revision=CVS revision number
#
# By default this wizard downloads the most recent compatible version found in CVS.
# If the wizard fails to correctly identify the most recent compatible version or
# if the user wishes to download and install a particular revision then this
# command-line switch can be used.
#
# For example, to download and install IMAP.pm v1.4 use the command:
#
#   updateimap.exe /revision=1.4
#
# To get the most recent version from the main CVS trunk without knowing its revision number,
# use the command:
#
#   updateimap.exe /revision=1.999
#
# (assuming the most recent version number is less than or equal to 1.999)
#--------------------------------------------------------------------------

  ;------------------------------------------------
  ; Define PFI_VERBOSE to get more compiler output
  ;------------------------------------------------

## !define PFI_VERBOSE

  ;--------------------------------------------------------------------------
  ; Select SOLID LZMA compression (to generate smallest EXE file)
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
  ; (two commonly used exceptions to this rule are 'IO_NL' and 'MB_NL')
  ;--------------------------------------------------------------------------

  ; This build is for use with the POPFile installer-created installations

  !define C_PFI_PRODUCT  "POPFile"

  Name                   "POPFile IMAP Updater"

  !define C_PFI_VERSION  "0.0.13"

  ; Mention the wizard's version number in the window title

  Caption                "POPFile IMAP Updater v${C_PFI_VERSION}"

  ; Name to be used for the program file (also used for the 'Version Information')

  !define C_OUTFILE      "updateimap.exe"

  ;--------------------------------------------------------------------------
  ; Addresses used to download the list of available IMAP.pm revisions and to
  ; download a particular revision. Some simple parsing is performed on the
  ; available IMAP.pm revisions list in an attempt to find the most recent one.
  ;--------------------------------------------------------------------------

  ; SourceForge URL for the CVS Revision History for the POPFile IMAP module

  !define C_CVS_HISTORY_URL   "http://popfile.cvs.sourceforge.net/popfile/engine/Services/IMAP.pm?view=log"

  ; Restrict the Revision History to the current CVS version (for forthcoming 0.23.0 release)

  !define C_CVS_PATHREV       "&pathrev=MAIN"

  ; Restrict the Revision History to the versions which are compatible with 0.22.x releases

  !define C_PRE_23_PATHREV    "&pathrev=b0_22_2"

  ; SourceForge URL used when downloading a particular CVS revision of the IMAP module

  !define C_CVS_IMAP_DL_URL   "http://popfile.cvs.sourceforge.net/*checkout*/popfile/engine/Services/IMAP.pm?revision=$G_REVISION"

#--------------------------------------------------------------------------
# User Registers (Global)
#--------------------------------------------------------------------------

  ; This script uses 'User Variables' (with names starting with 'G_') to hold GLOBAL data.

  Var G_ROOTDIR            ; full path to the folder used for the POPFile program files

  Var G_REVISION           ; The IMAP.pm CVS revision to be downloaded (e.g. 1.5) which is
                           ; extracted from the CVS history page or specified on command-line

  Var G_REVDATE            ; The date of the most recent CVS revision found in the list
                           ; (e.g. "Mon Aug 23 12:18:58 2004 UTC")

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

  !define IMAPUPDATER

  !include "..\pfi-library.nsh"


#--------------------------------------------------------------------------
# Version Information settings (for the wizard's EXE file)
#--------------------------------------------------------------------------

  ; 'VIProductVersion' format is X.X.X.X where X is a number in range 0 to 65535
  ; representing the following values: Major.Minor.Release.Build

  VIProductVersion                          "${C_PFI_VERSION}.0"

  !define /date C_BUILD_YEAR                "%Y"

  VIAddVersionKey "ProductName"             "POPFile IMAP Updater wizard"
  VIAddVersionKey "Comments"                "POPFile Homepage: http://getpopfile.org/"
  VIAddVersionKey "CompanyName"             "The POPFile Project"
  VIAddVersionKey "LegalCopyright"          "Copyright (c) ${C_BUILD_YEAR}  John Graham-Cumming"
  VIAddVersionKey "FileDescription"         "Updates the IMAP module for POPFile 0.22.x"
  VIAddVersionKey "FileVersion"             "${C_PFI_VERSION}"
  VIAddVersionKey "OriginalFilename"        "${C_OUTFILE}"

  VIAddVersionKey "Build"                   "English-Mode"

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

  ; The log window shows progress messages and download statistics

  ShowInstDetails show
  !define MUI_FINISHPAGE_NOAUTOCLOSE

  ;----------------------------------------------------------------
  ;  Interface Settings - Abort Warning Settings
  ;----------------------------------------------------------------

  ; Show a message box with a warning when the user closes the wizard before it has finished

  !define MUI_ABORTWARNING

  ;----------------------------------------------------------------
  ; Customize MUI - General Custom Function
  ;----------------------------------------------------------------

  ; Use a custom '.onGUIInit' function to permit language-specific error messages
  ; (the user-selected language is not available for use in the .onInit function)

  !define MUI_CUSTOMFUNCTION_GUIINIT          PFIGUIInit


#--------------------------------------------------------------------------
# Define the Page order for the wizard
#--------------------------------------------------------------------------

  ;---------------------------------------------------
  ; Installer Page - Welcome
  ;---------------------------------------------------

  !define MUI_WELCOMEPAGE_TITLE                   "$(PIU_LANG_WELCOME_TITLE)"
  !define MUI_WELCOMEPAGE_TEXT                    "$(PIU_LANG_WELCOME_TEXT)"

  !insertmacro MUI_PAGE_WELCOME

  ;---------------------------------------------------
  ; Installer Page - License Page (uses English GPL)
  ;---------------------------------------------------

  !define MUI_LICENSEPAGE_CHECKBOX
  !define MUI_PAGE_HEADER_SUBTEXT                 "$(PIU_LANG_LICENSE_SUBHDR)"
  !define MUI_LICENSEPAGE_TEXT_BOTTOM             "$(PIU_LANG_LICENSE_BOTTOM)"

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
  ; (we use this to generate the installation path for the POPFile IMAP module)

  !define MUI_PAGE_HEADER_TEXT                    "$(PIU_LANG_DESTNDIR_TITLE)"
  !define MUI_PAGE_HEADER_SUBTEXT                 "$(PIU_LANG_DESTNDIR_SUBTITLE)"
  !define MUI_DIRECTORYPAGE_TEXT_TOP              "$(PIU_LANG_DESTNDIR_TEXT_TOP)"
  !define MUI_DIRECTORYPAGE_TEXT_DESTINATION      "$(PIU_LANG_DESTNDIR_TEXT_DESTN)"

  !insertmacro MUI_PAGE_DIRECTORY

  ;---------------------------------------------------
  ; Installer Page - Install files
  ;---------------------------------------------------

  ; Override the standard "Installing..." page header

  !define MUI_PAGE_HEADER_TEXT                    "$(PIU_LANG_STD_HDR)"
  !define MUI_PAGE_HEADER_SUBTEXT                 "$(PIU_LANG_STD_SUBHDR)"

  ; Override the standard "Installation complete..." page header

  !define MUI_INSTFILESPAGE_FINISHHEADER_TEXT     "$(PIU_LANG_END_HDR)"
  !define MUI_INSTFILESPAGE_FINISHHEADER_SUBTEXT  "$(PIU_LANG_END_SUBHDR)"

  ; Override the standard "Installation Aborted..." page header

  !define MUI_INSTFILESPAGE_ABORTHEADER_TEXT      "$(PIU_LANG_ABORT_HDR)"
  !define MUI_INSTFILESPAGE_ABORTHEADER_SUBTEXT   "$(PIU_LANG_ABORT_SUBHDR)"

  !insertmacro MUI_PAGE_INSTFILES

  ;---------------------------------------------------
  ; Installer Page - Finish
  ;---------------------------------------------------

  !define MUI_FINISHPAGE_TITLE                    "$(PIU_LANG_FINISH_TITLE)"
  !define MUI_FINISHPAGE_TEXT                     "$(PIU_LANG_FINISH_TEXT)"

  !insertmacro MUI_PAGE_FINISH


#--------------------------------------------------------------------------
# Language Support for the utility
#--------------------------------------------------------------------------

  !insertmacro MUI_LANGUAGE "English"

  ;--------------------------------------------------------------------------
  ; Current build only supports English and uses local strings
  ; instead of language strings from languages\*-pfi.nsh files
  ;--------------------------------------------------------------------------

  !macro PLS_TEXT NAME VALUE
      LangString ${NAME} ${LANG_ENGLISH} "${VALUE}"
  !macroend

  ;--------------------------------------------------------------------------
  ; WELCOME page
  ;--------------------------------------------------------------------------

  !insertmacro PLS_TEXT PIU_LANG_WELCOME_TITLE         "Welcome to the $(^NameDA) Wizard"
  !insertmacro PLS_TEXT PIU_LANG_WELCOME_TEXT          "This utility will download the POPFile IMAP module from CVS.${IO_NL}${IO_NL}Normally it will download the most up-to-date version, but you can request a particular version by starting the utility with the /revision=1.x option (where x is the revision of interest).${IO_NL}${IO_NL}Example (a):   updateimap.exe /revision=1.5${IO_NL}Example (b):   updateimap.exe /revision=1.2.3.4${IO_NL}${IO_NL}~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~${IO_NL}   WARNING:${IO_NL}${IO_NL}   PLEASE SHUT DOWN POPFILE NOW !${IO_NL}~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~${IO_NL}${IO_NL}$_CLICK"

  ;--------------------------------------------------------------------------
  ; LICENSE page
  ;--------------------------------------------------------------------------

  !insertmacro PLS_TEXT PIU_LANG_LICENSE_SUBHDR        "Please review the license terms before using $(^NameDA)."
  !insertmacro PLS_TEXT PIU_LANG_LICENSE_BOTTOM        "If you accept the terms of the agreement, click the check box below. You must accept the agreement to use $(^NameDA). $_CLICK"

  ;--------------------------------------------------------------------------
  ; Source DIRECTORY page
  ;--------------------------------------------------------------------------

  !insertmacro PLS_TEXT PIU_LANG_DESTNDIR_TITLE        "Choose existing POPFile installation"
  !insertmacro PLS_TEXT PIU_LANG_DESTNDIR_SUBTITLE     "This IMAP module should only be added to an existing POPFile 0.22.x installation"
  !insertmacro PLS_TEXT PIU_LANG_DESTNDIR_TEXT_TOP     "The IMAP module must be installed using the same installation folder as POPFile 0.22.x.${MB_NL}${MB_NL}This utility will update the IMAP module in the version of POPFile which is installed in the following folder. To install in a different POPFile 0.22.x installation, click Browse and select another folder. $_CLICK"
  !insertmacro PLS_TEXT PIU_LANG_DESTNDIR_TEXT_DESTN   "Existing POPFile 0.22.x installation folder"

  !insertmacro PLS_TEXT PIU_LANG_DESTNDIR_MB_WARN_1    "POPFile 0.22.x does NOT seem to be installed in${MB_NL}${MB_NL}$G_PLS_FIELD_1"
  !insertmacro PLS_TEXT PIU_LANG_DESTNDIR_MB_WARN_2    "Are you sure you want to use this folder ?"

  ;--------------------------------------------------------------------------
  ; INSTFILES page
  ;--------------------------------------------------------------------------

  ; Initial page header

  !insertmacro PLS_TEXT PIU_LANG_STD_HDR               "Adding/Updating the IMAP module (for POPFile 0.22.x)"
  !insertmacro PLS_TEXT PIU_LANG_STD_SUBHDR            "Please wait while the IMAP module is downloaded and installed..."

  ; Successful completion page header

  !insertmacro PLS_TEXT PIU_LANG_END_HDR               "IMAP installation completed"
  !insertmacro PLS_TEXT PIU_LANG_END_SUBHDR            "IMAP module v$G_REVISION has been installed successfully"

  ; Unsuccessful completion page header

  !insertmacro PLS_TEXT PIU_LANG_ABORT_HDR             "IMAP installation failed"
  !insertmacro PLS_TEXT PIU_LANG_ABORT_SUBHDR          "The attempt to add or update the IMAP module has failed"

  ; Progress reports

  !insertmacro PLS_TEXT PIU_LANG_PROG_INITIALISE       "Initializing..."
  !insertmacro PLS_TEXT PIU_LANG_PROG_CMDLINE_REQUEST  "User has requested IMAP.pm v$G_REVISION"
  !insertmacro PLS_TEXT PIU_LANG_PROG_PRE_23_FOUND     "Pre-0.23.0 installation found"
  !insertmacro PLS_TEXT PIU_LANG_PROG_MAIN_CVS_FOUND   "0.23.0 (or later) installation found"
  !insertmacro PLS_TEXT PIU_LANG_PROG_GETLIST          "Downloading list of available CVS revisions..."
  !insertmacro PLS_TEXT PIU_LANG_PROG_CHECKDOWNLOAD    "Analyzing the result of the download operation..."
  !insertmacro PLS_TEXT PIU_LANG_PROG_FINDREVISION     "Searching the list to find the most recent compatible IMAP revision..."
  !insertmacro PLS_TEXT PIU_LANG_PROG_RESULTFOUND      "Search result: IMAP.pm v$G_REVISION ($G_REVDATE)"
  !insertmacro PLS_TEXT PIU_LANG_PROG_READYTODOWNLOAD  "Ready to download IMAP.pm v$G_REVISION from CVS"
  !insertmacro PLS_TEXT PIU_LANG_PROG_USERCANCELLED    "IMAP update cancelled by the user"
  !insertmacro PLS_TEXT PIU_LANG_PROG_GETIMAP          "Downloading the IMAP.pm module..."
  !insertmacro PLS_TEXT PIU_LANG_PROG_DOWNLOADFAILED   "IMAP Updater failed ($G_PLS_FIELD_1)"
  !insertmacro PLS_TEXT PIU_LANG_PROG_BACKUPIMAP       "Making backup copy of previous IMAP.pm file..."
  !insertmacro PLS_TEXT PIU_LANG_PROG_INSTALLIMAP      "Updating the IMAP.pm file..."
  !insertmacro PLS_TEXT PIU_LANG_PROG_SUCCESS          "POPFile 0.22.x IMAP support updated to v$G_REVISION"
  !insertmacro PLS_TEXT PIU_LANG_PROG_UPDATECOMPLETED  "IMAP Updater completed $G_PLS_FIELD_1"
  !insertmacro PLS_TEXT PIU_LANG_PROG_SAVELOG          "Saving install log file..."
  !insertmacro PLS_TEXT PIU_LANG_PROG_LOGLOCATION      "Log report saved in '$G_ROOTDIR\updateimap.log'"

  !insertmacro PLS_TEXT PIU_LANG_TAKE_A_FEW_SECONDS    "(this may take a few seconds)"

  ;--------------------------------------------------------------------------
  ; FINISH page
  ;--------------------------------------------------------------------------

  !insertmacro PLS_TEXT PIU_LANG_FINISH_TITLE          "Completing the $(^NameDA) Wizard"
  !insertmacro PLS_TEXT PIU_LANG_FINISH_TEXT           "POPFile IMAP module v$G_REVISION has been installed.${IO_NL}${IO_NL}You can now start POPFile and use the POPFile User Interface to activate and configure the IMAP module.${IO_NL}${IO_NL}Click Finish to close this wizard."

  ;--------------------------------------------------------------------------
  ; Miscellaneous strings
  ;--------------------------------------------------------------------------

  !insertmacro PLS_TEXT PIU_LANG_MUTEX                 "Another copy of the IMAP Updater wizard is running!"

  !insertmacro PLS_TEXT PIU_LANG_COMPAT_NOTFOUND       "Warning: Cannot find compatible version of POPFile !"

  !insertmacro PLS_TEXT PIU_LANG_MB_BADOPTION_1        "Invalid command-line option supplied ($G_PLS_FIELD_1)"
  !insertmacro PLS_TEXT PIU_LANG_MB_BADOPTION_2        "Usage examples:"
  !insertmacro PLS_TEXT PIU_LANG_MB_BADOPTION_3        "(to get the most up-to-date compatible revision)"
  !insertmacro PLS_TEXT PIU_LANG_MB_BADOPTION_4        "(where 1.x is the required revision number, eg 1.5 or 1.2.3.4)"
  !insertmacro PLS_TEXT PIU_LANG_MB_BADOPTION_ALL      "$(PIU_LANG_MB_BADOPTION_1)${MB_NL}${MB_NL}$(PIU_LANG_MB_BADOPTION_2)${MB_NL}${MB_NL}updateimap.exe${MB_NL}$(PIU_LANG_MB_BADOPTION_3)${MB_NL}${MB_NL}or${MB_NL}${MB_NL}updateimap.exe /revision=1.x${MB_NL}$(PIU_LANG_MB_BADOPTION_4)"

  !insertmacro PLS_TEXT PIU_LANG_ANALYSISFAILED_1      "Sorry, unable to determine the most recent revision!"
  !insertmacro PLS_TEXT PIU_LANG_ANALYSISFAILED_2      "You can specify a particular revision using the command"
  !insertmacro PLS_TEXT PIU_LANG_ANALYSISFAILED_3      "updateimap.exe /revision=1.x"
  !insertmacro PLS_TEXT PIU_LANG_MB_ANALYSISFAILED     "$(PIU_LANG_ANALYSISFAILED_1)${MB_NL}${MB_NL}$(PIU_LANG_ANALYSISFAILED_2)${MB_NL}${MB_NL}$(PIU_LANG_ANALYSISFAILED_3)"

  !insertmacro PLS_TEXT PIU_LANG_MB_GETPERMISSION      "Do you want to download and install IMAP.pm v$G_REVISION ?$G_REVDATE"

  !insertmacro PLS_TEXT PIU_LANG_MB_HISTORYFAIL_1      "Download of the list of available CVS revisions failed"
  !insertmacro PLS_TEXT PIU_LANG_MB_HISTORYFAIL_2      "(error: $G_PLS_FIELD_1)"

  !insertmacro PLS_TEXT PIU_LANG_MB_IMAPFAIL_1         "Download of IMAP module failed"
  !insertmacro PLS_TEXT PIU_LANG_MB_IMAPFAIL_2         "(error: $G_PLS_FIELD_1)"

  !insertmacro PLS_TEXT PIU_LANG_MB_BADIMAPFILE_1      "The downloaded file is not a POPFile module !"
  !insertmacro PLS_TEXT PIU_LANG_MB_BADIMAPFILE_2      "First line starts with '$G_PLS_FIELD_1'"
  !insertmacro PLS_TEXT PIU_LANG_MB_BADIMAPFILE_3      "Expected to find only '# POPFILE LOADABLE MODULE'"
  !insertmacro PLS_TEXT PIU_LANG_MB_BADIMAPFILE_4      "Downloaded file ignored - no changes made to POPFile"

  ; String required by the 'PFI_DumpLog' library function (hence the 'PFI_LANG_' prefix)

  !insertmacro PLS_TEXT PFI_LANG_MB_SAVELOG_ERROR      "Error: problem detected when saving the log file"

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

  !insertmacro MUI_RESERVEFILE_INSTALLOPTIONS
  ReserveFile "${NSISDIR}\Plugins\inetc.dll"
  ReserveFile "${NSISDIR}\Plugins\System.dll"


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
  !define L_TEMP             $R9   ; used when checking the command-line parameter (if any)

  Push ${L_RESERVED}
  Push ${L_TEMP}

  ; Ensure only one copy of this wizard (or any other POPFile installer) is running

  System::Call 'kernel32::CreateMutexA(i 0, i 0, t "OnlyOnePFI_mutex") i .r1 ?e'
  Pop ${L_RESERVED}
  StrCmp ${L_RESERVED} 0 mutex_ok
  MessageBox MB_OK|MB_ICONEXCLAMATION "$(PIU_LANG_MUTEX)"
  Abort

bad_option:
  MessageBox MB_OK|MB_ICONSTOP "$(PIU_LANG_MB_BADOPTION_ALL)"
  Abort

mutex_ok:
  Call PFI_GetParameters
  Pop $G_REVISION
  StrCmp $G_REVISION "" exit
  StrCpy $G_PLS_FIELD_1 $G_REVISION
  StrCpy ${L_TEMP} $G_REVISION 12
  StrCmp ${L_TEMP} "/revision=1." 0 bad_option
  StrCpy $G_REVISION $G_REVISION "" 12
  StrCmp $G_REVISION "" bad_option
  Push $G_REVISION
  Call CheckRevisionNumber
  Pop $G_REVISION
  StrCmp $G_REVISION "" bad_option
  StrCpy $G_REVISION "1.$G_REVISION"

exit:
  Pop ${L_TEMP}
  Pop ${L_RESERVED}

  !undef L_RESERVED
  !undef L_TEMP

FunctionEnd


#--------------------------------------------------------------------------
# Installer Function: .onGUIEnd
#
# Called right after the installer window closes. This workaround might help
# ensure that all of the temporary files created by this utility get deleted
#--------------------------------------------------------------------------

Function .onGUIEnd

  SetOutPath "$TEMP"

FunctionEnd


#--------------------------------------------------------------------------
# Installer Section: POPFile IMAP component
#
# The Inetc plugin is used here instead of the standard NSISdl plugin because the
# server does not specify the content length.
#
#--------------------------------------------------------------------------

Section "IMAP" SecIMAP

  !define L_HANDLE        $R9   ; file handle used to access the CVS log history list
  !define L_RESULT        $R8
  !define L_TEMP          $R7

  ; Local copy of the CVS log history file (which we use to find the most recent revision)

  !define C_CVS_HISTORY_FILE  "$PLUGINSDIR\cvslog.htm"

  Push ${L_HANDLE}
  Push ${L_RESULT}
  Push ${L_TEMP}

  SetDetailsPrint textonly
  DetailPrint "$(PIU_LANG_PROG_INITIALISE)"
  SetDetailsPrint listonly

  StrCpy $G_REVDATE ""

  DetailPrint "----------------------------------------------"
  DetailPrint "POPFile IMAP Updater wizard v${C_PFI_VERSION}"
  DetailPrint "----------------------------------------------"
  DetailPrint ""

  IfFileExists "$G_ROOTDIR\*.*" check_param
  CreateDirectory $G_ROOTDIR

check_param:
  StrCmp $G_REVISION "" look_for_compatible_version
  DetailPrint "$(PIU_LANG_PROG_CMDLINE_REQUEST)"
  Goto get_imap_module

  ;--------------------------------------------------------------------------
  ; The user has not specified a particular revision so we try to get the most
  ; recent _compatible_ version. POPFile's module format was changed for the
  ; POPFile 0.23.0 release so any modules intended for 0.23.0 (or later) are
  ; no longer compatible with any of the earlier releases of POPFile.
  ;--------------------------------------------------------------------------

look_for_compatible_version:
  IfFileExists "$G_ROOTDIR\POPFile\Database.pm" use_main_trunk
  DetailPrint "$(PIU_LANG_PROG_PRE_23_FOUND)"
  StrCpy $G_REVISION ${C_PRE_23_PATHREV}
  Goto look_for_most_recent_version

use_main_trunk:
  DetailPrint "$(PIU_LANG_PROG_MAIN_CVS_FOUND)"
  StrCpy $G_REVISION ${C_CVS_PATHREV}

look_for_most_recent_version:
  SetDetailsPrint both
  DetailPrint "$(PIU_LANG_PROG_GETLIST) $(PIU_LANG_TAKE_A_FEW_SECONDS)"
  SetDetailsPrint listonly
  Inetc::get /CAPTION "CVS History log" /POPUP "${C_CVS_HISTORY_URL}$G_REVISION" "${C_CVS_HISTORY_FILE}" /END
  Pop ${L_RESULT}
  DetailPrint ""
  SetDetailsPrint textonly
  DetailPrint "$(PIU_LANG_PROG_CHECKDOWNLOAD)"
  SetDetailsPrint listonly
  StrCmp ${L_RESULT} "OK" analyse_history
  StrCpy $G_PLS_FIELD_1 ${L_RESULT}
  SetDetailsPrint both
  DetailPrint "$(PIU_LANG_MB_HISTORYFAIL_1)"
  SetDetailsPrint listonly
  DetailPrint "$(PIU_LANG_MB_HISTORYFAIL_2)"
  MessageBox MB_OK|MB_ICONEXCLAMATION "$(PIU_LANG_MB_HISTORYFAIL_1)${MB_NL}$(PIU_LANG_MB_HISTORYFAIL_2)"
  Goto error_exit

analyse_history:
  SetDetailsPrint both
  DetailPrint "$(PIU_LANG_PROG_FINDREVISION)"
  SetDetailsPrint listonly
  Call GetMostRecentVersionInfo
  Pop $G_REVDATE
  Pop $G_REVISION
  StrCmp $G_REVISION "" analysis_failed
  DetailPrint "$(PIU_LANG_PROG_RESULTFOUND)"
  StrCpy $G_REVDATE "${MB_NL}${MB_NL}(CVS timestamp $G_REVDATE)"
  Goto get_imap_module

analysis_failed:
  DetailPrint ""
  DetailPrint "$(PIU_LANG_ANALYSISFAILED_1)"
  DetailPrint ""
  DetailPrint "$(PIU_LANG_ANALYSISFAILED_2)"
  DetailPrint "$(PIU_LANG_ANALYSISFAILED_3)"
  DetailPrint "$(PIU_LANG_MB_BADOPTION_4)"
  MessageBox MB_OK|MB_ICONSTOP "$(PIU_LANG_MB_ANALYSISFAILED)${MB_NL}${MB_NL}$(PIU_LANG_MB_BADOPTION_4)"
  Goto error_exit

get_imap_module:
  DetailPrint ""
  SetDetailsPrint both
  DetailPrint "$(PIU_LANG_PROG_READYTODOWNLOAD)"
  SetDetailsPrint listonly
  MessageBox MB_YESNO|MB_ICONQUESTION "$(PIU_LANG_MB_GETPERMISSION)" IDYES download_imap
  DetailPrint ""
  SetDetailsPrint both
  DetailPrint "$(PIU_LANG_PROG_USERCANCELLED)"
  SetDetailsPrint listonly
  Goto error_exit

download_imap:
  DetailPrint ""
  SetDetailsPrint both
  DetailPrint "$(PIU_LANG_PROG_GETIMAP) $(PIU_LANG_TAKE_A_FEW_SECONDS)"
  SetDetailsPrint listonly
  Inetc::get /CAPTION "IMAP module" /POPUP "${C_CVS_IMAP_DL_URL}" "$PLUGINSDIR\IMAP.pm" /END
  Pop ${L_RESULT}
  DetailPrint ""
  SetDetailsPrint textonly
  DetailPrint "$(PIU_LANG_PROG_CHECKDOWNLOAD)"
  SetDetailsPrint listonly
  StrCmp ${L_RESULT} "OK" file_received
  StrCpy $G_PLS_FIELD_1 ${L_RESULT}
  SetDetailsPrint both
  DetailPrint "$(PIU_LANG_MB_IMAPFAIL_1)"
  SetDetailsPrint listonly
  DetailPrint "$(PIU_LANG_MB_IMAPFAIL_2)"
  MessageBox MB_OK|MB_ICONEXCLAMATION "$(PIU_LANG_MB_IMAPFAIL_1)${MB_NL}$(PIU_LANG_MB_IMAPFAIL_2)"
  Goto error_exit

file_received:
  FileOpen ${L_HANDLE} "$PLUGINSDIR\IMAP.pm" r
  FileRead ${L_HANDLE} ${L_RESULT}
  FileClose ${L_HANDLE}
  Push ${L_RESULT}
  Call PFI_TrimNewlines
  Pop $G_PLS_FIELD_1
  StrCpy $G_PLS_FIELD_1 $G_PLS_FIELD_1 25
  StrCmp $G_PLS_FIELD_1 "# POPFILE LOADABLE MODULE" success
  DetailPrint "$(PIU_LANG_MB_BADIMAPFILE_1)"
  DetailPrint ""
  DetailPrint "$(PIU_LANG_MB_BADIMAPFILE_2)"
  DetailPrint "$(PIU_LANG_MB_BADIMAPFILE_3)"
  DetailPrint ""
  DetailPrint "$(PIU_LANG_MB_BADIMAPFILE_4)"
  MessageBox MB_OK|MB_ICONEXCLAMATION "$(PIU_LANG_MB_BADIMAPFILE_1)\
      ${MB_NL}${MB_NL}${MB_NL}\
      $(PIU_LANG_MB_BADIMAPFILE_2)\
      ${MB_NL}${MB_NL}\
      $(PIU_LANG_MB_BADIMAPFILE_3)\
      ${MB_NL}${MB_NL}${MB_NL}\
      $(PIU_LANG_MB_BADIMAPFILE_4)"

error_exit:
  SetDetailsPrint listonly
  DetailPrint ""
  Call PFI_GetDateTimeStamp
  Pop $G_PLS_FIELD_1
  DetailPrint "----------------------------------------------"
  DetailPrint "$(PIU_LANG_PROG_DOWNLOADFAILED)"
  DetailPrint "----------------------------------------------"
  Abort

success:
  IfFileExists "$G_ROOTDIR\Services\*.*" backup_current_file
  CreateDirectory "$G_ROOTDIR\Services"
  Goto copy_file

backup_current_file:
  DetailPrint "$(PIU_LANG_PROG_BACKUPIMAP)"
  DetailPrint ""
  !insertmacro PFI_BACKUP_123_DP "$G_ROOTDIR\Services" "IMAP.pm"

copy_file:
  DetailPrint ""
  DetailPrint "$(PIU_LANG_PROG_INSTALLIMAP)"
  Rename "$PLUGINSDIR\IMAP.pm" "$G_ROOTDIR\Services\IMAP.pm"
  DetailPrint ""
  SetDetailsPrint both
  DetailPrint "$(PIU_LANG_PROG_SUCCESS)"
  SetDetailsPrint listonly
  DetailPrint ""
  Call PFI_GetDateTimeStamp
  Pop $G_PLS_FIELD_1
  DetailPrint "----------------------------------------------"
  DetailPrint "$(PIU_LANG_PROG_UPDATECOMPLETED)"
  DetailPrint "----------------------------------------------"
  DetailPrint ""
  SetDetailsPrint textonly
  DetailPrint "$(PIU_LANG_PROG_SAVELOG)"

  ; Save a log showing what was installed

  !insertmacro PFI_BACKUP_123 "$G_ROOTDIR" "updateimap.log"
  Push "$G_ROOTDIR\updateimap.log"
  Call PFI_DumpLog

  SetDetailsPrint both
  DetailPrint "$(PIU_LANG_PROG_LOGLOCATION)"
  SetDetailsPrint none

  Pop ${L_TEMP}
  Pop ${L_RESULT}
  Pop ${L_HANDLE}

  !undef L_HANDLE
  !undef L_RESULT
  !undef L_TEMP

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
  MessageBox MB_OK|MB_ICONEXCLAMATION "$(PIU_LANG_COMPAT_NOTFOUND)"
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

  IfFileExists "$G_ROOTDIR\popfile-service.exe" continue
  IfFileExists "$G_ROOTDIR\runpopfile.exe" continue
  IfFileExists "$G_ROOTDIR\UI\HTML.pm" continue

  MessageBox MB_YESNO|MB_ICONQUESTION "$(PIU_LANG_DESTNDIR_MB_WARN_1)\
      ${MB_NL}${MB_NL}\
      $INSTDIR\
      ${MB_NL}${MB_NL}${MB_NL}\
      $(PIU_LANG_DESTNDIR_MB_WARN_2)" IDYES continue

  ; Return to the DIRECTORY selection page

  Abort

continue:

  ; Move to the INSTFILES page (to install the files)

FunctionEnd


#--------------------------------------------------------------------------
# Installer Function: GetMostRecentVersionInfo
#
# Extracts information from the downloaded CVS history log
#
# Inputs:
#         none
# Outputs:
#         (top of stack)     - CVS timestamp for it (e.g. "Mon Aug 23 12:18:58 2004 UTC")
#                              (if unable to find the data, an empty string is returned)
#         (top of stack - 1) - first revision found, assumed to be the most recent (e.g. "1.6")
#                              (if unable to find the data, an empty string is returned)
#
# Usage:
#         Call GetMostRecentVersionInfo
#         Pop $R0     ; get the timestamp (e.g. "Mon Aug 23 12:18:58 2004 UTC")
#         Pop $R1     ; ge the CVS revision (e.g. "1.6")
#
#         (if no valid data found, $R1 = "" and $R0 = "")
#--------------------------------------------------------------------------

Function GetMostRecentVersionInfo

  !define L_HANDLE      $R9   ; file handle for the log history file
  !define L_LINE        $R8   ; a line from the log history  file
  !define L_PARAM       $R7
  !define L_RESULT_DATE $R6   ; either the most recent CVS revision's timestamp or ""
  !define L_RESULT_REV  $R5   ; either the most recent CVS revision number (e.g. "1.6") or ""
  !define L_TEMP        $R4

  Push ${L_RESULT_DATE}
  Push ${L_RESULT_REV}
  Push ${L_HANDLE}
  Push ${L_LINE}
  Push ${L_PARAM}
  Push ${L_TEMP}

  StrCpy ${L_RESULT_REV} ""
  StrCpy ${L_RESULT_DATE} ""

  FileOpen  ${L_HANDLE} "${C_CVS_HISTORY_FILE}" r

loop:
  FileRead ${L_HANDLE} ${L_LINE}
  StrCmp ${L_LINE} "" done

  StrCpy ${L_PARAM} ${L_LINE} 17
  StrCmp ${L_PARAM} "Revision <strong>" 0 loop
  StrCpy ${L_TEMP} 17

revision_loop:
  StrCpy ${L_PARAM} ${L_LINE} 1 ${L_TEMP}
  StrCmp ${L_PARAM} "<" date_loop
  StrCpy ${L_RESULT_REV} "${L_RESULT_REV}${L_PARAM}"
  IntOp ${L_TEMP} ${L_TEMP} + 1
  Goto revision_loop

date_loop:
  FileRead ${L_HANDLE} ${L_LINE}
  StrCmp ${L_LINE} "" done
  StrCpy ${L_PARAM} ${L_LINE} 4
  StrCmp ${L_PARAM} "<em>" 0 date_loop
  StrCpy ${L_RESULT_DATE} ${L_LINE} 28 4

done:
  FileClose ${L_HANDLE}

  Pop ${L_TEMP}
  Pop ${L_PARAM}
  Pop ${L_LINE}
  Pop ${L_HANDLE}
  Exch ${L_RESULT_REV}
  Exch
  Exch ${L_RESULT_DATE}

  !undef L_HANDLE
  !undef L_LINE
  !undef L_PARAM
  !undef L_RESULT_DATE
  !undef L_RESULT_REV
  !undef L_TEMP

FunctionEnd


#--------------------------------------------------------------------------
# Installer Function: CheckRevisionNumber
#
# This function performs some simple checks on the IMAP.pm revision number supplied on the
# command-line by the user. Revision numbers for the main trunk are in the form 1.xxx but
# the numbers used on the branches have more than one decimal point (e.g. 1.9.4.3)
#
# Inputs:
#         (top of stack)   - the string to be checked
#
# Outputs:
#         (top of stack)   - the input string (if valid) or "" (if invalid)
#
# Usage:
#
#         Push "1.234"
#         Call CheckRevisionNumber
#         Pop $R0
#         ($R0 at this point is "1.234")
#
#         Push "1.234-A"
#         Call CheckRevisionNumber
#         Pop $R0
#         ($R0 at this point is "")

#--------------------------------------------------------------------------

Function CheckRevisionNumber

  !define VALID_CHAR    "0123456789."   ; string defining the valid characters
  !define BAD_OFFSET    11              ; length of VALID_CHAR string

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
  StrCpy $5 ${VALID_CHAR}$2  ; Add it to end of "validity check" to guarantee a match
  StrCpy $0 $0 "" 1
  StrCpy $3 -1

next_valid_char:
  IntOp $3 $3 + 1
  StrCpy $4 $5 1 $3             ; Extract next "valid" character (from "validity check" string)
  StrCmp $2 $4 0 next_valid_char
  IntCmp $3 ${BAD_OFFSET} invalid 0 invalid  ; If match is with the char we added, input is bad
  StrCpy $1 $1$4                ; Add "valid" character to the result
  goto next_input_char

invalid:
  StrCpy $1 ""

done:
  StrCpy $0 $1      ; Result is either a decimal number string or ""
  Pop $5
  Pop $4
  Pop $3
  Pop $2
  Pop $1
  Exch $0           ; place result on top of the stack

  !undef VALID_CHAR
  !undef BAD_OFFSET

FunctionEnd


#--------------------------------------------------------------------------
# End of 'updatemap.nsi'
#--------------------------------------------------------------------------
