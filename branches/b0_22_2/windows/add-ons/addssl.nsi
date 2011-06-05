#--------------------------------------------------------------------------
#
# addssl.nsi --- This is the NSIS script used to create a utility which installs
#                SSL support for an existing POPFile 0.22.0 to 0.22.5 installation.
#
#                This utility is NOT NECESSARY for POPFile 1.0.0, 1.0.1, 1.1.0 or
#                1.1.1 installations because the installers for these releases
#                create an entry in the "Add/Remove Programs" list which allows
#                SSL support to be added by downloading and installing all of the
#                necessary files.
#
#                This utility is NOT COMPATIBLE with POPFile 1.1.2 (or later)
#                because different SSL support files are now included in the
#                installer and these SSL support files are _always_ installed.
#
#--------------------------------------------------------------------------
#   This product downloads software developed by the OpenSSL Project
#   for use in the OpenSSL Toolkit (see http://www.openssl.org/)
#--------------------------------------------------------------------------
#
# Copyright (c) 2004-2011 John Graham-Cumming
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
  ; in the NSIS Users Manual (see section D.4 in Appendix D of the manual for NSIS 2.45).
  ;
  ; The 'NSIS Wiki' page for the 'DumpLog' plugin (description, example and download links):
  ; http://nsis.sourceforge.net/DumpLog_plug-in
  ;
  ; To compile this script, copy the 'DumpLog.dll' file to the standard NSIS plugins folder
  ; (${NSISDIR}\Plugins\). The 'DumpLog' source and example files can be unzipped to the
  ; appropriate ${NSISDIR} sub-folders if you wish, but this step is entirely optional.
  ;
  ; Tested with version 1.0 of the DumpLog.dll plugin.
  ;
  ; The plugin's history can be found at http://nsis.sourceforge.net/File:DumpLog.zip

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
  ; Tested with the inetc.dll plugin timestamped 28 April 2011 14:23:12
  ;
  ; The plugin's history can be found at http://nsis.sourceforge.net/File:Inetc.zip

  ;------------------------------------------------
  ; This script requires the 'LockedList' NSIS plugin
  ;------------------------------------------------

  ; This script uses a special NSIS plugin (LockedList) to check if POPFile is running.
  ;
  ; The 'NSIS Wiki' page for the 'LockedList' plugin (description and download links):
  ; http://nsis.sourceforge.net/LockedList_plug-in
  ;
  ; To compile this script, copy the 'LockedList.dll' file to the standard NSIS plugins folder
  ; (${NSISDIR}\Plugins\). The 'LockedList' source and example files can be unzipped to the
  ; appropriate ${NSISDIR} sub-folders if you wish, but this step is entirely optional.
  ;
  ; Tested using LockedList plugin v2.3 timestamped 7 February 2011 18:52:22
  ;
  ; The plugin's history can be found at http://nsis.sourceforge.net/File:LockedList.zip

  ;------------------------------------------------
  ; This script requires the 'md5dll' NSIS plugin
  ;------------------------------------------------

  ; This script uses a special NSIS plugin (md5dll) to calculate the MD5 sum for a file.
  ;
  ; The 'NSIS Wiki' page for the 'md5dll' plugin (description, example and download links):
  ; http://nsis.sourceforge.net/MD5_plugin
  ;
  ; To compile this script, copy the 'md5dll.dll' file to the standard NSIS plugins folder
  ; (${NSISDIR}\Plugins\). The 'md5dll' source and example files can be unzipped to the
  ; appropriate ${NSISDIR} sub-folders if you wish, but this step is entirely optional.
  ;
  ; Tested using md5dll plugin v0.5 timestamped 23 January 2010 15:10:24
  ;
  ; The plugin's history can be found at http://nsis.sourceforge.net/File:Md5dll.zip

  ;------------------------------------------------
  ; This script requires the 'SimpleSC' NSIS plugin
  ;------------------------------------------------

  ; This script uses a special NSIS plugin (SimpleSC) to check if the POPFile service
  ; is running.
  ;
  ; The 'NSIS Wiki' page for the 'SimpleSC' plugin (description and download links):
  ; http://nsis.sourceforge.net/NSIS_Simple_Service_Plugin
  ;
  ; To compile this script, copy the 'SimpleSC.dll' file to the standard NSIS plugins folder
  ; (${NSISDIR}\Plugins\). The 'SimpleSC' source and example files can be unzipped to the
  ; appropriate ${NSISDIR} sub-folders if you wish, but this step is entirely optional.
  ;
  ; Tested with v1.29 of the SimpleSC.dll plugin.

  ;------------------------------------------------
  ; This script requires the 'untgz' NSIS plugin
  ;------------------------------------------------

  ; This script uses a special NSIS plugin (untgz) to extract files from the *.tar.gz archives.
  ;
  ; The 'NSIS Wiki' page for the 'untgz' plugin (description, example and download links):
  ; http://nsis.sourceforge.net/UnTGZ_plug-in
  ;
  ; To compile this script, copy the 'untgz.dll' file to the standard NSIS plugins folder
  ; (${NSISDIR}\Plugins\). The 'untgz' source and example files can be unzipped to the
  ; appropriate ${NSISDIR} sub-folders if you wish, but this step is entirely optional.
  ;
  ; Tested with version 1.0.17 of the 'untgz' plugin.
  ;
  ; The plugin's history can be found at http://nsis.sourceforge.net/File:Untgz.zip

  ;----------------------------------------------------------
  ; Different POPFile releases require different SSL support
  ;----------------------------------------------------------

  ; POPFile has supported SSL connections to mail servers since the 0.22.0 release
  ; (9 September 2004). Since that release there have been several significant
  ; changes in POPFile's SSL support and these are summarised in the POPFile wiki
  ; (see http://getpopfile.org/docs/devel:sslsupport).
  ;
  ; The installers for 0.22.0, 0.22.1 and 0.22.2 do not include the ability to
  ; download and install the necessary SSL support files so this utility was
  ; created to perform these functions.
  ;
  ; However the SSL support files from the internet are no longer compatible
  ; with the minimal Perl shipped with POPFile 0.22.0, 0.22.1 or 0.22.2 so
  ; this utility includes a set of compatible SSL files which will be installed
  ; instead. The minimal Perl's version number (obtained from the 'perl58.dll'
  ; file) is used to determine the action to be taken.
  ;
  ; The installers for 0.22.3 and 0.22.4 are able to download and install the
  ; necessary SSL support files but they cannot apply any patches required to
  ; make these files compatible with POPFile.
  ;
  ; The installer for 0.22.5 is able to download and install the necessary
  ; SSL support files and can also apply any patches required to make these
  ; files compatible with POPFile.
  ;
  ; The installers for POPFile 1.0.0, 1.0.1, 1.1.0 and 1.1.1 create a special
  ; entry in the "Add or Remove Programs" list which can be used to download
  ; and install SSL support and apply any necessary patches. This utility is
  ; therefore not recommended for use with these POPFile releases.
  ;
  ; Starting with the 1.1.2 release POPFile uses a different set of SSL support
  ; files which are included in the installer. These files are always installed.
  ; This utility is therefore of no use to POPFile 1.1.2 or any later release.

  ;----------------------------------------------------------
  ; Why are SSL patches sometimes required ?
  ;----------------------------------------------------------

  ; On 18 July 2006 the University of Winnipeg repository was updated to provide
  ; IO::Socket::SSL v0.99 which was not compatible with the then current version
  ; of POPFile (0.22.4) so a patch was created to downgrade the SSL.pm file to
  ; the compatible v0.97 version. This patch is also used for POPFile 0.22.3.
  ;
  ; On 18 August 2006 another update to IO::Socket::SSL meant that another patch
  ; had to be created to make the then current version of POPFile (0.22.4) work
  ; (and this patch could also be used with with POPFile 0.2.23).
  ;
  ; On 13 September 2006 another update to IO::Socket::SSL meant that another patch
  ; had to be created to make the then current version of POPFile (0.22.4) work
  ; (and this patch could also be used with with POPFile 0.2.23).
  ;
  ; POPFile 0.22.5 uses a new minimal Perl and at the time of its release (June 2007)
  ; there was no need to patch any of the SSL Support files from the University of
  ; Winnipeg repository for use with POPFile 0.22.5.
  ;
  ; On 31 August 2007 another update to IO::Socket::SSL meant that another patch
  ; had to be created to make this file work with POPFile 0.22.3 and 0.22.4.
  ;
  ; Starting with the 0.22.5 release any patches required to make the SSL Support
  ; files compatible with POPFile will be downloaded from the POPFile web site. This
  ; will avoid the need to rebuild the installer and the 'SSL Setup' wizard every time
  ; the SSL Support files become incompatible with the 0.22.5 or any later releases of
  ; POPFile. However the current patches, if any, will always be incorporated into each
  ; build of the installer so they can be used if the POPFile web site is not available
  ; when the installer is run.

  ;----------------------------------------------------------
  ; How the SSL.pm patch was created
  ;----------------------------------------------------------

  ; The patch used to downgrade SSL.pm v0.99, SSL.pm v0.999, SSL.pm v1.01,
  ; SSL.pm v1.08 or SSL.pm v1.13 to SSL.pm v0.97 was created using the VPATCH package
  ; which is supplied with NSIS. The following MS-DOS commands were used to create the
  ;  patch file:
  ;
  ;   if exist SSL_pm.pat del SSL_pm.pat
  ;   GenPat.exe SSL_0.99.pm SSL_0.97.pm SSL_pm.pat
  ;   GenPat.exe SSL_0.999.pm SSL_0.97.pm SSL_pm.pat
  ;   GenPat.exe SSL_1.01.pm SSL_0.97.pm SSL_pm.pat
  ;   GenPat.exe SSL_1.08.pm SSL_0.97.pm SSL_pm.pat
  ;   GenPat.exe SSL_1.13.pm SSL_0.97.pm SSL_pm.pat
  ;
  ; where SSL_0.97.pm  was the SSL.pm file from v0.97  of the IO::Socket:SSL module
  ;  and  SSL_0.99.pm  was the SSL.pm file from v0.99  of the IO::Socket:SSL module
  ;  and  SSL_0.999.pm was the SSL.pm file from v0.999 of the IO::Socket:SSL module
  ;  and  SSL_1.01.pm  was the SSL.pm file from v1.01  of the IO::Socket:SSL module
  ;  and  SSL_1.08.pm  was the SSL.pm file from v1.08  of the IO::Socket:SSL module
  ;  and  SSL_1.13.pm  was the SSL.pm file from v1.13  of the IO::Socket:SSL module
  ;
  ; The resulting SSL_pm.pat file is able to downgrade v0.99, v0.999, v1.01, v1.08 or
  ; v1.13 of SSL.pm.
  ;
  ; NOTE: It is important that the various SSL.pm files used to generate this patch
  ;       use the correct end-of-line sequences. When the untgz plugin extracts SSL.pm
  ;       the output file uses LF therefore the files used to generate this patch must
  ;       also use LF instead of the normal CRLF sequence used on Windows systems. If
  ;       files with CRLF are used to make the patch then the SSL.pm file will _not_
  ;       be patched (a "no suitable patches found" error will be reported by the
  ;       'vpatch' plugin).

  ;----------------------------------------------------------
  ; POPFile 0.22.x Compatibility Problem
  ;----------------------------------------------------------

  ; On 22 June 2005 the SSL components available from the internet became incompatible with
  ; POPFile 0.22.0, 0.22.1 or 0.22.2 because the files were updated to work with ActivePerl
  ; 5.8.7 Build 813. POPFile 0.22.0 and 0.22.1 use a minimal Perl based upon ActivePerl 5.8.3
  ; Build 809 and 0.22.2 uses a minimal Perl based upon 5.8.4 Build 810. These minimal Perl
  ; systems will crash when attempting to use files built for more recent versions of Perl.
  ;
  ; In order to support POPFile 0.22.0, 0.22.1 and 0.22.2 the wizard includes an older set of
  ; SSL files which were downloaded from the University of Winnipeg repository in January 2005.
  ; In order to simplify the code, the normal Internet download operation is replaced by "File"
  ; commands which store the old SSL files in the folder used to hold the downloaded files;
  ; these old files can then be handled as if they had been downloaded from the internet.
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

  ;----------------------------------------------------------
  ; POPFile 0.22.0's Module.pm file requires a patch
  ;----------------------------------------------------------

  ; The version of Module.pm distributed with POPFile 0.22.0 results in extremely
  ; slow message downloads (e.g. 6 minutes for a 2,713 byte msg) so this utility
  ; will apply a patch to update Module.pm v1.40 to v1.41 (the original file will
  ; be backed up as Module.pm.bk1). The patch is only applied if v1.40 is found.
  ;
  ; The patch used to update Module.pm v1.40 to v1.41 was created using the VPATCH
  ; package which is supplied with NSIS. The command used to create the patch was:
  ;
  ;   GenPat.exe Module.pm Module_ssl.pm Module_ssl.pat
  ;
  ; where Module.pm was CVS version 1.40 and Module_ssl.pm was CVS version 1.41.

  ;----------------------------------------------------------

#--------------------------------------------------------------------------
# Optional run-time command-line switch (used by 'addssl.exe')
#--------------------------------------------------------------------------
#
# /BUILTIN
#
# For POPFile 0.22.3 (and later) releases this wizard will download (and if necessary patch)
# the SSL support files from the relevant Perl Repository. However there will always be some
# delay between the repository being updated with SSL files which are not compatible with
# POPFile and the generation of an updated version of the SSL patches (or this wizard).
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

  ; This build is for use with POPFile installer-created installations

  !define C_PFI_PRODUCT  "POPFile"

  Name                   "POPFile SSL Setup"

  !define C_PFI_VERSION  "0.5.0"

  ; Mention the wizard's version number in the window title

  Caption                "POPFile SSL Setup v${C_PFI_VERSION}"

  ; Name to be used for the program file (also used for the 'Version Information')

  !define C_OUTFILE      "addssl.exe"

  ;--------------------------------------------------------------------------
  ; Windows Vista & Windows 7 expect to find a manifest specifying the execution level
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
  !include "..\pfi-nsis-library.nsh"

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
  !ifdef C_NSIS_LIBRARY_VERSION
    VIAddVersionKey "NSIS Library Version"  "${C_NSIS_LIBRARY_VERSION}"
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
# URLs used to download the necessary SSL support archives and files
# (mainly from the University of Winnipeg Repository)
#--------------------------------------------------------------------------

  ; In addition to some extra Perl modules, POPFile's SSL support needs two OpenSSL DLLs.

  ; In order to implement a timeout when attempting to connect to a SSL server POPFile
  ; needs to use IO::Socket::SSL v1.10 or later. Unfortunately at present (17 September 2008)
  ; the main source of the SSL support files (the University of Winnipeg repository) only has
  ; v1.08 of this package so we get a more up-to-date version from a different repository
  ; (currently that repository contains v1.13 of IO::Socket::SSL)

#  !define C_REPO_IO_SOCKET_SSL "http://theoryx5.uwinnipeg.ca/ppms/x86/IO-Socket-SSL.tar.gz"

  !define C_REPO_IO_SOCKET_SSL "http://ppm.tcool.org/archives/IO-Socket-SSL.tar.gz"

  !define C_REPO_NET_SSLEAY    "http://theoryx5.uwinnipeg.ca/ppms/x86/Net_SSLeay.pm.tar.gz"
  !define C_REPO_DLL_SSLEAY32  "http://theoryx5.uwinnipeg.ca/ppms/scripts/ssleay32.dll"
  !define C_REPO_DLL_LIBEAY32  "http://theoryx5.uwinnipeg.ca/ppms/scripts/libeay32.dll"

#--------------------------------------------------------------------------
# It may be necessary to patch one (or more) of the SSL support files downloaded from
# the internet to make the file(s) compatible with POPFile. The POPFile website holds
# a control file and any necessary SSL support patches (the patches are created and
# applied by the standard VPATCH package shipped with the NSIS compiler).
#
# The patch control file, any patches and the file containing the MD5 sums of the
# patch control file and the available patches are all stored in the same directory
# on the POPFile web site.
#--------------------------------------------------------------------------

  !define C_PATCH_WEBSITE     "http://getpopfile.org/installer/ssl-patch"

  !define C_PATCH_CTRL_FILE   "0.22.x.pcf"

  !define C_MD5SUMS_FILE      "MD5SUMS"

#--------------------------------------------------------------------------
# Macro used to preserve up to 3 backup copies of a file which is being patched
#
# (Note: input file will be "removed" by renaming it)
#--------------------------------------------------------------------------

  !macro SSL_BACKUP_123_DP FOLDER FILE

      !insertmacro PFI_UNIQUE_ID

      IfFileExists "${FOLDER}\${FILE}" 0 continue_${PFI_UNIQUE_ID}
      SetDetailsPrint none
      IfFileExists "${FOLDER}\${FILE}.bk1" 0 the_first_${PFI_UNIQUE_ID}
      IfFileExists "${FOLDER}\${FILE}.bk2" 0 the_second_${PFI_UNIQUE_ID}
      IfFileExists "${FOLDER}\${FILE}.bk3" 0 the_third_${PFI_UNIQUE_ID}
      Delete "${FOLDER}\${FILE}.bk3"

    the_third_${PFI_UNIQUE_ID}:
      Rename "${FOLDER}\${FILE}.bk2" "${FOLDER}\${FILE}.bk3"
      SetDetailsPrint listonly
      DetailPrint "[${L_PCF_ID}] Backup file '${FILE}.bk3' updated"
      SetDetailsPrint none

    the_second_${PFI_UNIQUE_ID}:
      Rename "${FOLDER}\${FILE}.bk1" "${FOLDER}\${FILE}.bk2"
      SetDetailsPrint listonly
      DetailPrint "[${L_PCF_ID}] Backup file '${FILE}.bk2' updated"
      SetDetailsPrint none

    the_first_${PFI_UNIQUE_ID}:
      Rename "${FOLDER}\${FILE}" "${FOLDER}\${FILE}.bk1"
      SetDetailsPrint listonly
      DetailPrint "[${L_PCF_ID}] Backup file '${FILE}.bk1' updated"

    continue_${PFI_UNIQUE_ID}:
  !macroend

#--------------------------------------------------------------------------
# User Registers (Global)
#--------------------------------------------------------------------------

  Var G_SSL_FILEURL        ; full URL used to download SSL file

  Var G_PLS_FIELD_2        ; used to customise translated text strings

  Var G_PATCH_SOURCE       ; indicates the source of the SSL patches we are to
                           ; apply (the possible values are either ${C_BUILTIN}
                           ; or ${C_INTERNET})

  Var G_SSL_SOURCE         ; indicates the source of the SSL files we are to
                           ; install (the possible values are either ${C_BUILTIN}
                           ; or ${C_INTERNET})

  Var G_PATCH_CTRL_FILE    ; the name of the appropriate Patch Control File
                           ; (e.g. 0.22.x.pcf, 0.22.5.pcf, etc)

  ; Values used for the $G_PATCH_SOURCE and $G_SSL_SOURCE flags
  ; (constants are used for these values to make maintenance easier)

  !define C_BUILTIN        "built-in"     ; use files extracted from this utility
  !define C_INTERNET       "internet"     ; download the latest files from the Internet

#--------------------------------------------------------------------------
# Installer Section: POPFile SSL Support
#--------------------------------------------------------------------------

Section "SSL Support" SecSSL

  ; The stand-alone utility includes a compressed set of POPFile pre-0.22.3
  ; compatible SSL support files so we increase the size estimate to take the
  ; necessary unpacking into account (and assume that there will not be a
  ; significant difference in the space required if the wizard decides to
  ; download the SSL support files instead).

  AddSize 1450

  !define L_RESULT          $R0   ; result from 'GetSSLFile' function or
                                  ; the 'untgz' plugin
                                  ; WARNING: plugin is hard-coded to use $R0

  !define L_LISTSIZE        $R1   ; number of patches to be applied

  Push ${L_RESULT}
  Push ${L_LISTSIZE}

  ; We only check the first 3 fields in the version number (X.Y.Z), ignoring
  ; the BUILD number (NOTE: This means ActivePerl 5.8.8.820 and 5.8.8.822 are not
  ; handled differently)

  !define L_VER_X    $R3     ; version number's MAJOR field
  !define L_VER_Y    $R4     ; version number's MINOR field
  !define L_VER_Z    $R5     ; version number's REVISION field

  Push ${L_VER_X}
  Push ${L_VER_Y}
  Push ${L_VER_Z}

  ; Assume we will use the built-in SSL files which are compatible with
  ; pre-0.22.3 releases (these SSL support files do not require any patches
  ; to make them POPFile-compatible)

  StrCpy $G_SSL_SOURCE "${C_BUILTIN}"
  StrCpy $G_PATCH_SOURCE "${C_BUILTIN}"

  ; For POPFile 0.22.3 (and later) releases this stand-alone utility will
  ; download and, if necessary, patch the SSL support files.
  ;
  ; However there will always be some delay between the repository being updated
  ; with SSL files which are not compatible with POPFile and the provision of the
  ; necessary patches on the POPFile website.
  ;
  ; The /BUILTIN command-line switch provides an easy way to force the
  ; installation of the old SSL support files normally used only for the
  ; POPFile 0.22.0, 0.22.1 and 0.22.2 releases as a workaround

  Call NSIS_GetParameters
  Pop ${L_RESULT}
  StrCmp ${L_RESULT} "/BUILTIN" 0 look_for_minimal_Perl
  DetailPrint "The '/BUILTIN' option was supplied on the command-line"
  Goto pre_0_22_3

look_for_minimal_Perl:

  ; The stand-alone utility may be used to add SSL support to an 0.22.x
  ; installation which is not compatible with the files currently available
  ; from the internet, so we check the minimal Perl's version number to see
  ; if we should use the built-in SSL files instead of downloading the most
  ; up-to-date ones.

  IfFileExists "$G_ROOTDIR\perl58.dll" check_Perl_version
  DetailPrint "Assume pre-0.22.3 installation \
        (perl58.dll not found in '$G_ROOTDIR' folder)"
  Goto pre_0_22_3

check_Perl_version:
  GetDllVersion "$G_ROOTDIR\perl58.dll" ${L_VER_Y} ${L_VER_Z}
  IntOp ${L_VER_X} ${L_VER_Y} / 0x00010000
  IntOp ${L_VER_Y} ${L_VER_Y} & 0x0000FFFF
  IntOp ${L_VER_Z} ${L_VER_Z} / 0x00010000
  DetailPrint "Minimal Perl version ${L_VER_X}.${L_VER_Y}.${L_VER_Z} \
        detected in '$G_ROOTDIR' folder"

  ; Only download the SSL files if the minimal Perl version is 5.8.7 or higher

  IntCmp ${L_VER_X} 5 0 pre_0_22_3 set_download_flag
  IntCmp ${L_VER_Y} 8 0 pre_0_22_3 set_download_flag
  IntCmp ${L_VER_Z} 7 0 pre_0_22_3 set_download_flag

set_download_flag:
  StrCpy $G_SSL_SOURCE "${C_INTERNET}"
  Goto download_ssl

pre_0_22_3:

  ; Pretend we've just downloaded the SSL archives and OpenSSL DLLs
  ; from the Internet

  DetailPrint "therefore built-in SSL files used instead of downloading \
        the latest versions"
  DetailPrint ""
  SetOutPath "$PLUGINSDIR"
  File "ssl-0.22.x\IO-Socket-SSL.tar.gz"
  File "ssl-0.22.x\Net_SSLeay.pm.tar.gz"
  File "ssl-0.22.x\ssleay32.dll"
  File "ssl-0.22.x\libeay32.dll"
  Goto install_SSL_support

download_ssl:
  DetailPrint "therefore the latest versions of the SSL files will be downloaded"
  DetailPrint ""

  StrCpy $G_SSL_SOURCE "${C_INTERNET}"    ; means "download the SSL Support files"
  StrCpy $G_PATCH_SOURCE "${C_INTERNET}"  ; means "download the latest SSL patches"

  ; Download the SSL archives and OpenSSL DLLs

  Push "${C_REPO_IO_SOCKET_SSL}"
  Call GetSSLFile
  Pop ${L_RESULT}

  Push "${C_REPO_NET_SSLEAY}"
  Call GetSSLFile
  Pop ${L_RESULT}

  Push "${C_REPO_DLL_SSLEAY32}"
  Call GetSSLFile
  Pop ${L_RESULT}

  Push "${C_REPO_DLL_LIBEAY32}"
  Call GetSSLFile
  Pop ${L_RESULT}

install_SSL_support:

  ; Now install the files required for SSL support

  StrCpy $G_MPLIBDIR "$G_ROOTDIR\lib"

  StrCpy $G_PLS_FIELD_1 "$G_MPLIBDIR\IO\Socket"
  DetailPrint ""
  CreateDirectory $G_PLS_FIELD_1
  SetDetailsPrint both
  StrCpy $G_PLS_FIELD_2 "IO-Socket-SSL.tar.gz"
  DetailPrint "$(PFI_LANG_PROG_FILEEXTRACT)"
  SetDetailsPrint listonly
  untgz::extractFile -d "$G_PLS_FIELD_1" \
        "$PLUGINSDIR\IO-Socket-SSL.tar.gz" "SSL.pm"
  StrCmp ${L_RESULT} "success" 0 error_exit

  DetailPrint ""
  StrCpy $G_PLS_FIELD_1 "$G_MPLIBDIR\Net"
  CreateDirectory $G_PLS_FIELD_1
  SetDetailsPrint both
  StrCpy $G_PLS_FIELD_2 "Net_SSLeay.pm.tar.gz"
  DetailPrint "$(PFI_LANG_PROG_FILEEXTRACT)"
  SetDetailsPrint listonly
  untgz::extractFile -d "$G_PLS_FIELD_1" \
        "$PLUGINSDIR\Net_SSLeay.pm.tar.gz" "SSLeay.pm"
  StrCmp ${L_RESULT} "success" 0 error_exit

  DetailPrint ""
  StrCpy $G_PLS_FIELD_1 "$G_MPLIBDIR\Net\SSLeay"
  CreateDirectory $G_PLS_FIELD_1
  SetDetailsPrint both
  StrCpy $G_PLS_FIELD_2 "Net_SSLeay.pm.tar.gz"
  DetailPrint "$(PFI_LANG_PROG_FILEEXTRACT)"
  SetDetailsPrint listonly
  untgz::extractFile -d "$G_PLS_FIELD_1" \
        "$PLUGINSDIR\Net_SSLeay.pm.tar.gz" "Handle.pm"
  StrCmp ${L_RESULT} "success" 0 error_exit

  DetailPrint ""
  StrCpy $G_PLS_FIELD_1 "$G_MPLIBDIR\auto\Net\SSLeay"
  CreateDirectory $G_PLS_FIELD_1
  SetDetailsPrint both
  StrCpy $G_PLS_FIELD_2 "OpenSSL DLL"
  DetailPrint "$(PFI_LANG_PROG_FILECOPY)"
  SetDetailsPrint listonly
  CopyFiles /SILENT "$PLUGINSDIR\ssleay32.dll" "$G_PLS_FIELD_1\ssleay32.dll"
  CopyFiles /SILENT "$PLUGINSDIR\libeay32.dll" "$G_PLS_FIELD_1\libeay32.dll"
  DetailPrint ""
  SetDetailsPrint both
  StrCpy $G_PLS_FIELD_2 "Net_SSLeay.pm.tar.gz"
  DetailPrint "$(PFI_LANG_PROG_FILEEXTRACT)"
  SetDetailsPrint listonly
  untgz::extractV -j -d "$G_PLS_FIELD_1" \
        "$PLUGINSDIR\Net_SSLeay.pm.tar.gz" -x ".exists" "*.html" "*.pl" "*.pm" --
  StrCmp ${L_RESULT} "success" check_if_patches_required

error_exit:
  SetDetailsPrint listonly
  DetailPrint ""
  SetDetailsPrint both
  DetailPrint "$(PFI_LANG_MB_UNPACKFAIL)"
  SetDetailsPrint listonly
  DetailPrint ""
  MessageBox MB_OK|MB_ICONSTOP "$(PFI_LANG_MB_UNPACKFAIL)"

  Call PFI_GetDateTimeStamp
  Pop $G_PLS_FIELD_1
  DetailPrint "----------------------------------------------------"
  DetailPrint "POPFile SSL Setup failed ($G_PLS_FIELD_1)"
  DetailPrint "----------------------------------------------------"
  Abort

check_if_patches_required:

  ; If the built-in SSL Support files are being used then there is no need
  ; to patch SSL.pm

  StrCmp $G_SSL_SOURCE "${C_BUILTIN}" all_done

  ; If we are adding SSL Support to POPFile 0.22.5 or later then we need to
  ; get the appropriate Patch Control File from the POPFile website instead
  ; of using the generic one (0.22.x.pcf)

  IfFileExists "$G_ROOTDIR\uninstall.exe" check_popfile_version

use_generic_pcf:
  StrCpy $G_PATCH_CTRL_FILE "${C_PATCH_CTRL_FILE}"
  Goto download_pcf

check_popfile_version:
  GetDllVersion "$G_ROOTDIR\uninstall.exe" ${L_VER_Y} ${L_VER_Z}
  IntOp ${L_VER_X} ${L_VER_Y} / 0x00010000
  IntOp ${L_VER_Y} ${L_VER_Y} & 0x0000FFFF
  IntOp ${L_VER_Z} ${L_VER_Z} / 0x00010000
  DetailPrint ""
  DetailPrint "POPFile version ${L_VER_X}.${L_VER_Y}.${L_VER_Z} \
        detected in '$G_ROOTDIR' folder"

  ; 0.22.5 was the first release to use a Patch Control File

  IntCmp ${L_VER_X}  0 0 use_generic_pcf use_appropriate_pcf
  IntCmp ${L_VER_Y} 22 0 use_generic_pcf use_appropriate_pcf
  IntCmp ${L_VER_Z}  5 0 use_generic_pcf use_appropriate_pcf

use_appropriate_pcf:
  StrCpy $G_PATCH_CTRL_FILE "${L_VER_X}.${L_VER_Y}.${L_VER_Z}.pcf"

download_pcf:
  DetailPrint ""
  DetailPrint ""
  DetailPrint "Download the Patch Control File and MD5 sums \
        from the POPFile website..."
  DetailPrint ""

  Push "${C_PATCH_WEBSITE}/$G_PATCH_CTRL_FILE"
  Call GetSSLFile
  Pop ${L_RESULT}
  StrCmp ${L_RESULT} "OK" 0 use_default_patches

  ; Download the file containing the MD5 sums for the files in the patch directory

  Push "${C_PATCH_WEBSITE}/${C_MD5SUMS_FILE}"
  Call GetSSLFile
  Pop ${L_RESULT}
  StrCmp ${L_RESULT} "OK" 0 use_default_patches

  ; Calculate the MD5 sum for the patch control file and then
  ; compare the result with the value given in the MD5SUMS file

  md5dll::GetMD5File "$PLUGINSDIR\$G_PATCH_CTRL_FILE"
  Pop ${L_RESULT}
  DetailPrint ""
  DetailPrint "Calculated MD5 sum for Patch Control File: ${L_RESULT}"
  Push $G_PATCH_CTRL_FILE
  Call ExtractMD5sum
  Pop $G_PLS_FIELD_1
  DetailPrint "Downloaded MD5 sum for Patch Control File: $G_PLS_FIELD_1"
  StrCmp $G_PLS_FIELD_1 ${L_RESULT} use_control_file
  DetailPrint "MD5 sums differ! Default patch data will be used \
        instead of the downloaded file."
  MessageBox MB_OK|MB_ICONEXCLAMATION "POPFile Patch Control File has bad checksum!\
      ${MB_NL}${MB_NL}\
      Default SSL patch data will be used"

use_default_patches:

  ; Failed to download POPFile's SSL Patch Control file or the MD5 sums

  StrCpy $G_PATCH_SOURCE "${C_BUILTIN}"
  DetailPrint "Unable to download data from POPFile website, using built-in \
        SSL patches instead"
  DetailPrint ""

  SetDetailsPrint none
  File "/oname=$PLUGINSDIR\${C_PATCH_CTRL_FILE}" "..\0.22.x.pcf"
  File /nonfatal "/oname=$PLUGINSDIR\SSL_pm.pat" "..\SSL_pm.pat"
  StrCpy $G_PATCH_CTRL_FILE "${C_PATCH_CTRL_FILE}"

  ; Ensure the patch control file uses CRLF as the EOL marker
  ; (the file is used as an INI file so it is best for it to use CRLF instead of LF)

  Push $G_PATCH_CTRL_FILE
  Call EOL2CRLF
  SetDetailsPrint listonly

  ; Record information about the built-in Patch Control File in the installer log

  !insertmacro MUI_INSTALLOPTIONS_READ $G_PLS_FIELD_1 \
        "$G_PATCH_CTRL_FILE" "Settings" "POPFileVersion"
  !insertmacro MUI_INSTALLOPTIONS_READ $G_PLS_FIELD_2 \
        "$G_PATCH_CTRL_FILE" "Settings" "PatchIssue"
  DetailPrint "POPFile $G_PLS_FIELD_1 Patch Control File (issue $G_PLS_FIELD_2) \
        [*** Built-in version ***]"
  !insertmacro MUI_INSTALLOPTIONS_READ $G_PLS_FIELD_1 \
        "$G_PATCH_CTRL_FILE" "Settings" "Comment"
  StrCmp $G_PLS_FIELD_1 "" builtin_patch_count
  DetailPrint "$G_PLS_FIELD_1"

builtin_patch_count:
  DetailPrint ""
  !insertmacro MUI_INSTALLOPTIONS_READ ${L_LISTSIZE} "$G_PATCH_CTRL_FILE" \
        "Settings" "NumberOfPatches"
  StrCmp ${L_LISTSIZE} "0" 0 apply_patches
  DetailPrint "No POPFile SSL patches are required"
  Goto all_done

use_control_file:
  DetailPrint "Patch Control File MD5 sums match"
  DetailPrint ""

  ; Ensure the patch control file uses CRLF as the EOL marker
  ; (the file is used as an INI file so it is best for it to use CRLF instead of LF)

  Push $G_PATCH_CTRL_FILE
  Call EOL2CRLF

  ; Record information about the Patch Control File in the installer log

  !insertmacro MUI_INSTALLOPTIONS_READ $G_PLS_FIELD_1 \
        "$G_PATCH_CTRL_FILE" "Settings" "POPFileVersion"
  !insertmacro MUI_INSTALLOPTIONS_READ $G_PLS_FIELD_2 \
        "$G_PATCH_CTRL_FILE" "Settings" "PatchIssue"
  DetailPrint ""
  DetailPrint "POPFile $G_PLS_FIELD_1 Patch Control File (issue $G_PLS_FIELD_2)"
  !insertmacro MUI_INSTALLOPTIONS_READ $G_PLS_FIELD_1 \
        "$G_PATCH_CTRL_FILE" "Settings" "Comment"
  StrCmp $G_PLS_FIELD_1 "" get_the_patches
  DetailPrint "$G_PLS_FIELD_1"

get_the_patches:
  DetailPrint ""
  DetailPrint ""
  Call DownloadPatches
  Pop ${L_RESULT}

  ; Are there any patches to be applied?

  StrCmp ${L_RESULT} "0" all_done

apply_patches:
  Call ApplyPatches

all_done:
  DetailPrint ""

  Pop ${L_VER_Z}
  Pop ${L_VER_Y}
  Pop ${L_VER_X}

  !undef L_VER_X
  !undef L_VER_Y
  !undef L_VER_Z

  Pop ${L_LISTSIZE}
  Pop ${L_RESULT}

  !undef L_RESULT
  !undef L_LISTSIZE

 SectionEnd

#--------------------------------------------------------------------------
# Installer Function: GetSSLFile
#
# This function downloads a single SSL Support file from the internet.
#
# Inputs:
#         (top of stack)     - full URL used to download the SSL file
#
# Outputs:
#         (top of stack)     - status returned by the download plugin
#
# Usage:
#
#         Push "http://www.example.com/download/SSL.zip"
#         Call GetSSLFile
#         Pop $0
#
#         ($R0 at this point is "OK" if the file was downloaded without any
#         errors being detected)
#
#--------------------------------------------------------------------------

  !define C_NSISDL_TRANSLATIONS "/TRANSLATE \
        '$(PFI_LANG_NSISDL_DOWNLOADING)' \
        '$(PFI_LANG_NSISDL_CONNECTING)' \
        '$(PFI_LANG_NSISDL_SECOND)' \
        '$(PFI_LANG_NSISDL_MINUTE)' \
        '$(PFI_LANG_NSISDL_HOUR)' \
        '$(PFI_LANG_NSISDL_PLURAL)' \
        '$(PFI_LANG_NSISDL_PROGRESS)' \
        '$(PFI_LANG_NSISDL_REMAINING)'"

Function GetSSLFile

  Pop $G_SSL_FILEURL

  StrCpy $G_PLS_FIELD_1 $G_SSL_FILEURL
  Push $G_PLS_FIELD_1
  Call PFI_StrBackSlash
  Call NSIS_GetParent
  Pop $G_PLS_FIELD_2
  StrLen $G_PLS_FIELD_2 $G_PLS_FIELD_2
  IntOp $G_PLS_FIELD_2 $G_PLS_FIELD_2 + 1
  StrCpy $G_PLS_FIELD_1 "$G_PLS_FIELD_1" "" $G_PLS_FIELD_2
  StrCpy $G_PLS_FIELD_2 "$G_SSL_FILEURL" $G_PLS_FIELD_2
  DetailPrint ""
  DetailPrint "$(PFI_LANG_PROG_STARTDOWNLOAD)"

  inetc::get /CAPTION "Internet Download" /RESUME \
        "$(PFI_LANG_MB_CHECKINTERNET)" ${C_NSISDL_TRANSLATIONS} \
        "$G_SSL_FILEURL" "$PLUGINSDIR\$G_PLS_FIELD_1" /END
  Pop $G_PLS_FIELD_2

  StrCmp $G_PLS_FIELD_2 "OK" file_received
  SetDetailsPrint both
  DetailPrint "$(PFI_LANG_MB_NSISDLFAIL_1)"
  SetDetailsPrint listonly
  DetailPrint "$(PFI_LANG_MB_NSISDLFAIL_2)"
  MessageBox MB_OK|MB_ICONEXCLAMATION "$(PFI_LANG_MB_NSISDLFAIL_1)${MB_NL}\
        $(PFI_LANG_MB_NSISDLFAIL_2)"
  SetDetailsPrint listonly
  DetailPrint ""
  Call PFI_GetDateTimeStamp
  Pop $G_PLS_FIELD_1
  DetailPrint "----------------------------------------------------"
  DetailPrint "POPFile SSL Setup failed ($G_PLS_FIELD_1)"
  DetailPrint "----------------------------------------------------"
  Abort

file_received:
  Push $G_PLS_FIELD_2

FunctionEnd

#--------------------------------------------------------------------------
# Installer Function: ExtractMD5sum
#
# This function extracts the MD5 sum for a particular file from
# the list of MD5 sums downloaded from the POPFile website.
#
# The MD5SUMS file contains the MD5 sums for the files in the patch directory.
# This function searches for the MD5 sum for the specified filename and returns
# either a 32-hexdigit string (if a matching entry is found in the MD5SUMS file)
# or an empty string (if the specified filename is not found in the file)
#
# Lines starting with '#' or ';' in the MD5SUMS file are ignored, as are empty lines.
#
# Lines in MD5SUMS which contain MD5 sums are assumed to be in this format:
# (a) positions 1 to 32 contain a 32 character hexadecimal number
#     (line starts in column 1)
# (b) column 33 is a space character
# (c) column 34 is the text/binary flag (' ' = text, '*' = binary)
# (d) column 35 is the first character of the filename
#     filename terminates with end-of-line)
#
# Inputs:
#         (top of stack)     - name (without the path) of the file whose MD5 sum
#                              we seek (the MD5 sums file has already been downloaded
#                              to $PLUGINSDIR)
#
# Outputs:
#         (top of stack)     - the 32-digit MD5 sum (=success) or an empty string
#                              (meaning "failure")
#
#--------------------------------------------------------------------------

Function ExtractMD5sum

  !define L_DATA      $R9
  !define L_HANDLE    $R8   ; handle used to access the MD5SUMS file
  !define L_MD5NAME   $R7   ; name of file in which we are interested
  !define L_RESULT    $R6

  Exch ${L_RESULT}

  IfFileExists "$PLUGINSDIR\${C_MD5SUMS_FILE}" examine_file
  StrCpy ${L_RESULT} ""
  Goto quick_exit

examine_file:
  Push ${L_DATA}
  Push ${L_HANDLE}
  Push ${L_MD5NAME}
  StrCpy ${L_MD5NAME} ${L_RESULT}

  FileOpen ${L_HANDLE} "$PLUGINSDIR\${C_MD5SUMS_FILE}" r

read_next_line:
  FileRead ${L_HANDLE} ${L_RESULT}
  StrCmp ${L_RESULT} "" stop_searching
  StrCpy ${L_DATA} ${L_RESULT} 1
  StrCmp ${L_DATA} '#' read_next_line
  StrCmp ${L_DATA} ';' read_next_line
  Push ${L_RESULT}
  Call NSIS_TrimNewlines
  Pop ${L_DATA}
  StrCmp ${L_DATA} "" read_next_line
  StrCpy ${L_RESULT} ${L_DATA} "" 34       ; NSIS strings start at position 0 not 1
  StrCmp ${L_RESULT} ${L_MD5NAME} 0 read_next_line
  StrCpy ${L_RESULT} ${L_DATA} 32
  Push ${L_RESULT}
  Call PFI_StrCheckHexadecimal
  Pop ${L_RESULT}

stop_searching:
  FileClose ${L_HANDLE}

  Pop ${L_MD5NAME}
  Pop ${L_HANDLE}
  Pop ${L_DATA}

quick_exit:
  Exch ${L_RESULT}

  !undef L_DATA
  !undef L_HANDLE
  !undef L_MD5NAME
  !undef L_RESULT

FunctionEnd

#--------------------------------------------------------------------------
# Installer Function: EOL2CRLF
#
# This function ensures that the Patch Control File downloaded from the POPFile
# website uses the standard Carriage Return-Line Feed (CRLF) pair employed by
# Windows as the end-of-line (EOL) sequence (because this file is treated as a
# Windows INI file).
#
# Inputs:
#         (top of stack)  - name of the file to be converted
#                           (assumed to be in $PLUGINSDIR)
#
# Outputs:
#         (none)
#--------------------------------------------------------------------------

Function EOL2CRLF

  !define L_FILENAME    $R9   ; name of input file (assumed to be in $PLUGINSDIR)
  !define L_SOURCE      $R8   ; handle used to access the input file
  !define L_TARGET      $R7   ; handle used to access the output file
  !define L_TEMP        $R6

  Exch ${L_FILENAME}

  IfFileExists "$PLUGINSDIR\${L_FILENAME}" 0 quickexit

  Push ${L_SOURCE}
  Push ${L_TARGET}
  Push ${L_TEMP}

  ; Ensure the Patch Control File is in standard Windows format
  ; (i.e. lines end in CRLF)

  FileOpen ${L_SOURCE} "$PLUGINSDIR\${L_FILENAME}" r
  FileOpen ${L_TARGET} "$PLUGINSDIR\${L_FILENAME}.txt" w
  ClearErrors

loop:
  FileRead ${L_SOURCE} ${L_TEMP}
  IfErrors close_files
  Push ${L_TEMP}
  Call NSIS_TrimNewlines
  Pop ${L_TEMP}
  FileWrite ${L_TARGET} "${L_TEMP}${MB_NL}"
  Goto loop

close_files:
  FileClose ${L_SOURCE}
  FileClose ${L_TARGET}
  SetDetailsPrint none
  Delete "$PLUGINSDIR\${L_FILENAME}"
  Rename "$PLUGINSDIR\${L_FILENAME}.txt" "$PLUGINSDIR\${L_FILENAME}"
  SetDetailsPrint listonly

  Pop ${L_TEMP}
  Pop ${L_TARGET}
  Pop ${L_SOURCE}

quickexit:
  Pop ${L_FILENAME}

  !undef L_FILENAME
  !undef L_SOURCE
  !undef L_TARGET
  !undef L_TEMP

FunctionEnd

#--------------------------------------------------------------------------
# Installer Function: DownloadPatches
#
# This function downloads all of the patches specified in the Patch Control File.
#
# A loop is used to process the list of required patches so we use a function for
# this work instead of in-line code in order to reduce progress bar flickers. The
# number of patches specified is returned, even if we were unable to download all
# of them.
#
# Inputs:
#         (none)
#
# Outputs:
#         (top of stack)  - the number of patches specified in the patch control file
#--------------------------------------------------------------------------

Function DownloadPatches

  !define L_INDEX       $R9   ; loop counter used to access the patch control file
  !define L_LISTSIZE    $R8   ; number of patches to be applied
  !define L_PATCHFILE   $R7   ; name of a file containing patch data
  !define L_PCF_ID      $R6   ; name of a '[Patch-x]' section in patch control file
  !define L_RESULT      $R5

  Push ${L_INDEX}
  Push ${L_LISTSIZE}
  Exch
  Push ${L_PATCHFILE}
  Push ${L_PCF_ID}
  Push ${L_RESULT}

  !insertmacro MUI_INSTALLOPTIONS_READ \
        ${L_LISTSIZE} "$G_PATCH_CTRL_FILE" "Settings" "NumberOfPatches"
  StrCmp ${L_LISTSIZE} "0" 0 download_patches
  DetailPrint "No POPFile SSL patches are required"
  Goto exit

download_patches:
  DetailPrint "Number of POPFile SSL patches to be downloaded = ${L_LISTSIZE}"
  StrCpy ${L_INDEX} 0

download_next_patch:
  IntOp ${L_INDEX} ${L_INDEX} + 1
  IntCmp ${L_INDEX} ${L_LISTSIZE} 0 0 exit
  StrCpy ${L_PCF_ID} "Patch-${L_INDEX}"
  !insertmacro MUI_INSTALLOPTIONS_READ \
        ${L_PATCHFILE} "$G_PATCH_CTRL_FILE" "${L_PCF_ID}" "PatchData"
  StrCmp ${L_PATCHFILE} "" no_patch_specified
  Push "${C_PATCH_WEBSITE}/${L_PATCHFILE}"
  Call GetSSLFile
  Pop ${L_RESULT}
  !insertmacro MUI_INSTALLOPTIONS_WRITE \
        "$G_PATCH_CTRL_FILE" "${L_PCF_ID}" "DownloadStatus" "${L_RESULT}"
  StrCpy $G_PLS_FIELD_1 "OK (${L_PATCHFILE})"
  StrCmp ${L_RESULT} "OK" download_status
  StrCpy $G_PLS_FIELD_1 "Unable to download [${L_PCF_ID}] file (${L_PATCHFILE})"

download_status:
  DetailPrint "$G_PLS_FIELD_1"
  Goto download_next_patch

no_patch_specified:
  DetailPrint ""
  DetailPrint "No patch file specified in [${L_PCF_ID}] entry"
  Goto download_next_patch

exit:
  Pop ${L_RESULT}
  Pop ${L_PCF_ID}
  Pop ${L_PATCHFILE}
  Pop ${L_INDEX}
  Exch ${L_LISTSIZE}

  !undef L_INDEX
  !undef L_LISTSIZE
  !undef L_PATCHFILE
  !undef L_PCF_ID
  !undef L_RESULT

FunctionEnd

#--------------------------------------------------------------------------
# Installer Function: ApplyPatches
#
# This function applies all of the patches specified in the patch control file
# found in the PLUGINSDIR, using patch data files found in the same directory.
# A loop is used to process the list of required patches so we use a function
# for this work instead of in-line code in order to reduce progress bar flickers.
#
# Inputs:
#         (none)
#
# Outputs:
#         (none)
#--------------------------------------------------------------------------

Function ApplyPatches

  !define L_INDEX           $R9   ; loop counter used to access the
                                  ; patch control file
  !define L_LISTSIZE        $R8   ; number of patches to be applied
  !define L_PATCHFILE       $R7   ; name of a file containing patch data
  !define L_PCF_ID          $R6   ; name of a '[Patch-x]' section in the
                                  ; patch control file
  !define L_RESULT          $R5
  !define L_TARGET_FILE     $R4   ; name of the file to be patched
  !define L_TARGET_FOLDER   $R3   ; path to the file to be patched

  Push ${L_INDEX}
  Push ${L_LISTSIZE}
  Push ${L_PATCHFILE}
  Push ${L_PCF_ID}
  Push ${L_RESULT}
  Push ${L_TARGET_FILE}
  Push ${L_TARGET_FOLDER}

  !insertmacro MUI_INSTALLOPTIONS_READ ${L_LISTSIZE} \
        "$G_PATCH_CTRL_FILE" "Settings" "NumberOfPatches"

  DetailPrint ""
  DetailPrint ""
  StrCmp ${L_LISTSIZE} "0" no_patches
  StrCmp ${L_LISTSIZE} "1" single_patch
  DetailPrint "Apply ${L_LISTSIZE} SSL patches..."
  Goto start_patching

no_patches:
  DetailPrint "No POPFile SSL patches are required"
  Goto all_done

single_patch:
  DetailPrint "Apply the SSL patch..."

start_patching:
  StrCpy ${L_INDEX} 0

apply_next_patch:
  IntOp ${L_INDEX} ${L_INDEX} + 1
  IntCmp ${L_INDEX} ${L_LISTSIZE} 0 0 all_done
  StrCpy ${L_PCF_ID} "Patch-${L_INDEX}"
  !insertmacro MUI_INSTALLOPTIONS_READ ${L_PATCHFILE} \
        "$G_PATCH_CTRL_FILE" "${L_PCF_ID}" "PatchData"
  StrCmp ${L_PATCHFILE} "" apply_next_patch
  !insertmacro MUI_INSTALLOPTIONS_READ $G_PLS_FIELD_1 \
        "$G_PATCH_CTRL_FILE" "${L_PCF_ID}" "LogMsg-1"
  DetailPrint ""
  DetailPrint ""
  DetailPrint "[${L_PCF_ID}] $G_PLS_FIELD_1"
  DetailPrint "[${L_PCF_ID}]"
  !insertmacro MUI_INSTALLOPTIONS_READ $G_PLS_FIELD_1 \
        "$G_PATCH_CTRL_FILE" "${L_PCF_ID}" "Category"
  DetailPrint "[${L_PCF_ID}] This patch is $G_PLS_FIELD_1"
  DetailPrint "[${L_PCF_ID}]"
  !insertmacro MUI_INSTALLOPTIONS_READ ${L_PATCHFILE} \
        "$G_PATCH_CTRL_FILE" "${L_PCF_ID}" "PatchData"
  !insertmacro MUI_INSTALLOPTIONS_READ ${L_TARGET_FOLDER} \
        "$G_PATCH_CTRL_FILE" "${L_PCF_ID}" "TargetFolder"
  StrCpy ${L_TARGET_FOLDER} $G_ROOTDIR\${L_TARGET_FOLDER}
  !insertmacro MUI_INSTALLOPTIONS_READ ${L_TARGET_FILE} \
        "$G_PATCH_CTRL_FILE" "${L_PCF_ID}" "TargetFile"
  DetailPrint "[${L_PCF_ID}] Target file: ${L_TARGET_FOLDER}\${L_TARGET_FILE}"
  DetailPrint "[${L_PCF_ID}]"
  StrCmp $G_PATCH_SOURCE "${C_BUILTIN}" check_target_path
  !insertmacro MUI_INSTALLOPTIONS_READ $G_PLS_FIELD_1 \
        "$G_PATCH_CTRL_FILE" "${L_PCF_ID}" "DownloadStatus"
  StrCmp $G_PLS_FIELD_1 "OK" check_target_path
  StrCpy $G_PLS_FIELD_2 "Unable to apply '${L_PATCHFILE}' patch data ($G_PLS_FIELD_1)"
  DetailPrint "[${L_PCF_ID}] $G_PLS_FIELD_2"
  Goto patch_failure

check_target_path:
  Push "${L_TARGET_FOLDER}\${L_TARGET_FILE}"
  Push ".."
  Call PFI_StrStr
  Pop ${L_RESULT}
  StrCmp ${L_RESULT} "" apply_patch
  StrCpy $G_PLS_FIELD_2 "Patch not applied - invalid target path"
  DetailPrint "[${L_PCF_ID}] $G_PLS_FIELD_2"
  Goto patch_failure

apply_patch:
  vpatch::vpatchfile "$PLUGINSDIR\${L_PATCHFILE}" \
        "${L_TARGET_FOLDER}\${L_TARGET_FILE}" "$PLUGINSDIR\patched-${L_TARGET_FILE}"
  Pop $G_PLS_FIELD_2
  !insertmacro MUI_INSTALLOPTIONS_WRITE "$G_PATCH_CTRL_FILE" \
        "${L_PCF_ID}" "PatchResult" "$G_PLS_FIELD_2"

  !insertmacro MUI_INSTALLOPTIONS_READ $G_PLS_FIELD_1 \
        "$G_PATCH_CTRL_FILE" "${L_PCF_ID}" "LogMsg-2"
  SetDetailsPrint both
  DetailPrint "[${L_PCF_ID}] $G_PLS_FIELD_1 $G_PLS_FIELD_2"
  SetDetailsPrint listonly

  StrCmp $G_PLS_FIELD_2 "OK" vpatch_ok
  StrCmp $G_PLS_FIELD_2 "OK, new version already installed" \
        show_good_status patch_failure

vpatch_ok:
  DetailPrint "[${L_PCF_ID}]"
  !insertmacro SSL_BACKUP_123_DP "${L_TARGET_FOLDER}" "${L_TARGET_FILE}"
  SetDetailsPrint none
  Rename "$PLUGINSDIR\patched-${L_TARGET_FILE}" "${L_TARGET_FOLDER}\${L_TARGET_FILE}"
  IfFileExists "${L_TARGET_FOLDER}\${L_TARGET_FILE}" patch_success
  Rename "$${L_TARGET_FOLDER}\${L_TARGET_FILE}.bk1" \
        "${L_TARGET_FOLDER}\${L_TARGET_FILE}"
  SetDetailsPrint listonly
  StrCpy $G_PLS_FIELD_2 "Unable to replace target file with patched file"

patch_failure:
  !insertmacro MUI_INSTALLOPTIONS_WRITE "$G_PATCH_CTRL_FILE" \
        "${L_PCF_ID}" "PatchResult" "$G_PLS_FIELD_2"
  DetailPrint "[${L_PCF_ID}]"
  SetDetailsPrint both
  !insertmacro MUI_INSTALLOPTIONS_READ $G_PLS_FIELD_1 \
        "$G_PATCH_CTRL_FILE" "${L_PCF_ID}" "LogMsg-4"
  DetailPrint "[${L_PCF_ID}] $G_PLS_FIELD_1"
  SetDetailsPrint listonly
  MessageBox MB_OK|MB_ICONEXCLAMATION "$G_PLS_FIELD_1\
      ${MB_NL}\
      ($G_PLS_FIELD_2)"
  Goto apply_next_patch

patch_success:
  !insertmacro MUI_INSTALLOPTIONS_READ $G_PLS_FIELD_1 \
        "$G_PATCH_CTRL_FILE" "${L_PCF_ID}" "LogMsg-3"
  SetDetailsPrint listonly
  DetailPrint "[${L_PCF_ID}]"
  DetailPrint "[${L_PCF_ID}] $G_PLS_FIELD_1"

show_good_status:
  MessageBox MB_OK|MB_ICONINFORMATION "$G_PLS_FIELD_1\
      ${MB_NL}\
      ($G_PLS_FIELD_2)"
  Goto apply_next_patch

all_done:
  Pop ${L_TARGET_FOLDER}
  Pop ${L_TARGET_FILE}
  Pop ${L_RESULT}
  Pop ${L_PCF_ID}
  Pop ${L_PATCHFILE}
  Pop ${L_LISTSIZE}
  Pop ${L_INDEX}

  !undef L_INDEX
  !undef L_LISTSIZE
  !undef L_PATCHFILE
  !undef L_PCF_ID
  !undef L_RESULT
  !undef L_TARGET_FILE
  !undef L_TARGET_FOLDER

FunctionEnd

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
# chosen for this installation's POPFile program files (popfile.pl, etc). If a previous
# installation is detected then a compatibility check is performed because this utility
# should not be used to add SSL support to POPFile 1.1.2 or any later release.
#--------------------------------------------------------------------------

Function CheckInstallDir

  !define L_FILE      $R0     ; file used to obtain version number
  !define L_MAJOR     $R1
  !define L_MINOR     $R2
  !define L_REVSN     $R3
  !define L_BUILD     $R4     ; build number used by Perl
                              ; (not used by POPFile installers)

  Push ${L_FILE}
  Push ${L_MAJOR}
  Push ${L_MINOR}
  Push ${L_REVSN}
  Push ${L_BUILD}

  ; Initialise the global user variable used for the main POPFile program folder location

  StrCpy $G_ROOTDIR "$INSTDIR"

  ; Try to determine which version exists in the destination folder

  StrCpy ${L_FILE} "perl58.dll"
  IfFileExists "$G_ROOTDIR\${L_FILE}" check_version

  StrCpy ${L_FILE} "perl.exe"
  IfFileExists "$G_ROOTDIR\${L_FILE}" check_version

  StrCpy ${L_FILE} "wperl.exe"
  IfFileExists "$G_ROOTDIR\${L_FILE}" check_version

  StrCpy ${L_FILE} "uninstall.exe"
  IfFileExists "$G_ROOTDIR\${L_FILE}" check_version unknown_version

check_version:
  GetDllVersion "$G_ROOTDIR\${L_FILE}" ${L_MINOR} ${L_BUILD}
  IntOp ${L_MAJOR} ${L_MINOR} / 0x00010000
  IntOp ${L_MINOR} ${L_MINOR} & 0x0000FFFF
  IntOp ${L_REVSN} ${L_BUILD} / 0x00010000
  IntOp ${L_BUILD} ${L_BUILD} & 0x0000FFFF

  ; This utility is not compatible with POPFile 1.1.2 (or later).
  ; POPFile 1.1.2 was the first release to use Perl 5.8.9 build 829

  StrCmp ${L_FILE} "uninstall.exe" check_uninstaller_version
  IntCmp ${L_BUILD} 829 not_compatible compatible not_compatible

check_uninstaller_version:
  IntCmp ${L_MAJOR} 1 0 compatible not_compatible
  IntCmp ${L_MINOR} 1 0 compatible not_compatible
  IntCmp ${L_REVSN} 2 not_compatible compatible not_compatible

not_compatible:
  MessageBox MB_OK|MB_ICONSTOP "$(PFI_LANG_COMPAT_NOTFOUND)"
  Goto do_not_continue

compatible:
unknown_version:
  IfFileExists "$G_ROOTDIR\skins\default\style.css" continue

  ; Warn the user that the selected directory does not appear to contain POPFile 0.22.x files
  ; and allow user to select a different directory if they wish

  StrCpy $G_PLS_FIELD_1 "$INSTDIR"
  MessageBox MB_YESNO|MB_ICONQUESTION "$(PSS_LANG_DESTNDIR_MB_WARN_1)\
      ${MB_NL}${MB_NL}${MB_NL}\
      $(PSS_LANG_DESTNDIR_MB_WARN_2)" IDYES continue

do_not_continue:
  ; Return to the DIRECTORY selection page

  Pop ${L_BUILD}
  Pop ${L_REVSN}
  Pop ${L_MINOR}
  Pop ${L_MAJOR}
  Pop ${L_FILE}

  Abort

continue:
  ; Move to the INSTFILES page (to install the files)

  Pop ${L_BUILD}
  Pop ${L_REVSN}
  Pop ${L_MINOR}
  Pop ${L_MAJOR}
  Pop ${L_FILE}

  !undef L_FILE
  !undef L_MAJOR
  !undef L_MINOR
  !undef L_REVSN
  !undef L_BUILD

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
  !define L_NEW_GUI  $R7
  !define L_RESULT   $R6

  Push ${L_CFG}
  Push ${L_EXE}
  Push ${L_NEW_GUI}
  Push ${L_RESULT}

  DetailPrint ""
  SetDetailsPrint both
  DetailPrint "$(PFI_LANG_PROG_CHECKIFRUNNING)"
  SetDetailsPrint listonly

  ; Starting with POPFile 0.21.0 an experimental version of 'popfile-service.exe' was included
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

  Push "${L_CFG}\popfile.cfg"
  Push "html_port"
  Call PFI_CfgSettingRead
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
  DetailPrint "Waiting for '${L_EXE}' to unlock after Inetc request..."
  DetailPrint "Please be patient, this may take more than 30 seconds"
  Push ${L_EXE}
  Call PFI_WaitUntilUnlocked
  DetailPrint "Checking if '${L_EXE}' is still locked after Inetc request..."
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
  Pop ${L_RESULT}
  Pop ${L_NEW_GUI}
  Pop ${L_EXE}
  Pop ${L_CFG}

  !undef L_CFG
  !undef L_EXE
  !undef L_NEW_GUI
  !undef L_RESULT

nothing_to_check:
FunctionEnd

#--------------------------------------------------------------------------
# End of 'addssl.nsi'
#--------------------------------------------------------------------------
