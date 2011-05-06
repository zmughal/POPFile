#--------------------------------------------------------------------------
#
# getssl.nsh --- This NSIS 'include' file is used by the POPFile installer (installer.nsi)
#                and by the 'SSL Setup' wizard (add-ons\addssl.nsi) to download and install
#                SSL support for POPFile. If the optional SSL support is required, the
#                installer will download the necessary files during the installation. The
#                'SSL Setup' wizard can be used to add SSL support to an existing POPFile
#                0.22 (or later) installation. This 'include' file ensures that these two
#                programs download and install the same SSL files.
#
#                Starting with the 1.0.0 release the POPFile program's "Add/Remove Program"
#                entry now shows a "Change" button which can be used to add SSL support to
#                the existing POPFile installation. This is an alternative to re-running the
#                installer with /SSL specified on the command-line.
#
# Copyright (c) 2005-2008 John Graham-Cumming
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
# This product downloads software developed by the OpenSSL Project for use
# in the OpenSSL Toolkit (http://www.openssl.org/)
#--------------------------------------------------------------------------

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
  ; (${NSISDIR}\Plugins\). The 'Inetc' documentation, example & source files can be unzipped
  ; to the appropriate ${NSISDIR} sub-folders if you wish, but this step is entirely optional.
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
  ; (${NSISDIR}\Plugins\). The 'untgz'  documentation, example & source files can be unzipped
  ; to the appropriate ${NSISDIR} sub-folders if you wish, but this step is entirely optional.
  ;
  ; Tested with versions 1.0.5, 1.0.6, 1.0.7 and 1.0.8 of the 'untgz' plugin.

  ;------------------------------------------------
  ; Why are SSL patches sometimes required ?
  ;------------------------------------------------

  ; On 18 July 2006 the University of Winnipeg repository was updated to provide
  ; IO::Socket::SSL v0.99 which was not compatible with the then current version
  ; of POPFile (0.22.4) so a patch was created to downgrade the SSL.pm file to
  ; the compatible v0.97 version. This patch is also used for POPFile 0.22.3.
  ;
  ; On 18 August 2006 the University of Winnipeg repository was updated to supply
  ; IO::Socket::SSL v0.999 which was not compatible with the then current version
  ; of POPFile (0.22.4) so a patch was created to downgrade the SSL.pm file to
  ; the compatible v0.97 version. This patch is also used for POPFile 0.22.3.
  ;
  ; On 13 September 2006 the University of Winnipeg repository was updated to
  ; supply IO::Socket::SSL v1.01 which was not compatible with the then current
  ; version of POPFile (0.22.4) so a patch was created to downgrade the SSL.pm
  ; file to the compatible v0.97 version. This patch is also used for POPFile 0.22.3.
  ;
  ; POPFile 0.22.5 uses a new minimal Perl and at the time of its release (June 2007)
  ; there was no need to patch any of the SSL Support files from the University of
  ; Winnipeg repository for use with POPFile 0.22.5.
  ;
  ; On 31 August 2007 the University of Winnipeg repository was updated to
  ; supply IO::Socket::SSL v1.08 which is not compatible with POPFile 0.22.4 or
  ; 0.22.3 so a patch will be applied to downgrade the SSL.pm file to the compatible
  ; v0.97 version when SSL Support is added to POPFile 0.22.4 or 0.22.3.
  ;
  ; Starting with the 0.22.5 release any patches required to make the SSL Support files
  ; compatible with POPFile will be downloaded from the POPFile web site. This will avoid
  ; the need to rebuild the installer and the 'SSL Setup' wizard every time the SSL Support
  ; files become incompatible with the 0.22.5 or any later releases of POPFile. However the
  ; current patches, if any, will always be incorporated into each build of the installer
  ; so they can be used if the POPFile web site is not available when the installer is run.

  ;------------------------------------------------
  ; How the SSL.pm patch was created
  ;------------------------------------------------

  ; The patch used to downgrade SSL.pm v0.99, SSL.pm v0.999, SSL.pm v1.01 or SSL.pm v1.08
  ; to SSL.pm v0.97 was created using the VPATCH package which is supplied with NSIS. The
  ; following MS-DOS commands were used to create the patch file:
  ;
  ;   if exist SSL_pm.pat del SSL_pm.pat
  ;   GenPat.exe SSL_0.99.pm SSL_0.97.pm SSL_pm.pat
  ;   GenPat.exe SSL_0.999.pm SSL_0.97.pm SSL_pm.pat
  ;   GenPat.exe SSL_1.01.pm SSL_0.97.pm SSL_pm.pat
  ;   GenPat.exe SSL_1.08.pm SSL_0.97.pm SSL_pm.pat
  ;
  ; where SSL_0.97.pm  was the SSL.pm file from v0.97  of the IO::Socket:SSL module
  ;  and  SSL_0.99.pm  was the SSL.pm file from v0.99  of the IO::Socket:SSL module
  ;  and  SSL_0.999.pm was the SSL.pm file from v0.999 of the IO::Socket:SSL module
  ;  and  SSL_1.01.pm  was the SSL.pm file from v1.01  of the IO::Socket:SSL module
  ;  and  SSL_1.08.pm  was the SSL.pm file from v1.08  of the IO::Socket:SSL module
  ;
  ; The resulting SSL_pm.pat file is able to downgrade v0.99, v0.999, v1.01 or v1.08 of SSL.pm.
  ;
  ; NOTE: It is important that the various SSL.pm files used to generate this patch use
  ;       the correct end-of-line sequences. When the untgz plugin extracts SSL.pm the
  ;       output file uses LF therefore the files used to generate this patch must also
  ;       use LF instead of the normal CRLF sequence used on Windows systems. If files
  ;       with CRLF are used to make the patch then the SSL.pm file will _not_ be patched
  ;       (a "no suitable patches found" error will be reported by the 'vpatch' plugin).

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
  
#  !define C_UWR_IO_SOCKET_SSL "http://theoryx5.uwinnipeg.ca/ppms/x86/IO-Socket-SSL.tar.gz"

  !define C_UWR_IO_SOCKET_SSL "http://ppm.tcool.org/archives/IO-Socket-SSL.tar.gz"

  !define C_UWR_NET_SSLEAY    "http://theoryx5.uwinnipeg.ca/ppms/x86/Net_SSLeay.pm.tar.gz"
  !define C_UWR_DLL_SSLEAY32  "http://theoryx5.uwinnipeg.ca/ppms/scripts/ssleay32.dll"
  !define C_UWR_DLL_LIBEAY32  "http://theoryx5.uwinnipeg.ca/ppms/scripts/libeay32.dll"

#--------------------------------------------------------------------------
# It may be necessary to patch one (or more) of the SSL support files downloaded from
# the University of Winnipeg to make the file(s) compatible with POPFile. The POPFile
# website holds a control file and any necessary SSL support patches (the patches are
# created and applied by the standard VPATCH package shipped with the NSIS compiler).
#
# The patch control file, any patches and the file containing the MD5 sums of the
# patch control file and the available patches are all stored in the same directory
# on the POPFile web site.
#--------------------------------------------------------------------------

  !define C_PATCH_WEBSITE     "http://getpopfile.org/installer/ssl-patch"

  !ifdef INSTALLER
      !define C_PATCH_CTRL_FILE   "${C_POPFILE_MAJOR_VERSION}.${C_POPFILE_MINOR_VERSION}.${C_POPFILE_REVISION}.pcf"
  !else
      !define C_PATCH_CTRL_FILE   "0.22.x.pcf"
  !endif
  !ifndef C_MD5SUMS_FILE
    !define C_MD5SUMS_FILE    "MD5SUMS"
  !endif

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

  !ifdef ADDSSL
      Var G_PLS_FIELD_2    ; used to customise translated text strings
  !endif

  Var G_PATCH_SOURCE       ; indicated the source of the SSL patches we are to apply
                           ; (the possible values are either ${C_BUILTIN} or ${C_INTERNET})

  Var G_SSL_SOURCE         ; indicates the source of the SSL files we are to install
                           ; (the possible values are either ${C_BUILTIN} or ${C_INTERNET})

  Var G_PATCH_CTRL_FILE    ; the name of the appropriate Patch Control File (e.g. 0.22.x.pcf, 0.22.5.pcf, etc)

  ; Values used for the $G_PATCH_SOURCE and $G_SSL_SOURCE flags
  ; (constants are used for these values to make maintenance easier)

  !define C_BUILTIN        "built-in"     ; use files extracted from this installer/utility
  !define C_INTERNET       "internet"     ; download the latest files from the Internet

#--------------------------------------------------------------------------
# Installer Section: POPFile SSL Support
#--------------------------------------------------------------------------

!macro SECTION_SSLSUPPORT UN

    !ifdef INSTALLER
          Section /o "${UN}SSL Support" ${UN}SecSSL

            !if '${UN}' == 'un.'
              StrCmp $G_UNINST_MODE "uninstall" skip_section
            !endif

            !insertmacro SECTIONLOG_ENTER "SSL Support"

            ; The main installer does not contain the SSL support files so we provide an estimate
            ; which includes a slack space allowance (based upon the development system's statistics)

            AddSize 2560
    !else
        Section "SSL Support" SecSSL

          ; The stand-alone utility includes a compressed set of POPFile pre-0.22.3 compatible SSL
          ; support files so we increase the size estimate to take the necessary unpacking into
          ; account (and assume that there will not be a significant difference in the space
          ; required if the wizard decides to download the SSL support files instead).

          AddSize 1450
    !endif

    !define L_RESULT          $R0   ; result from 'GetSSLFile' function or the 'untgz' plugin
                                    ; WARNING: The 'untgz' plugin is hard-coded to use $R0

    !define L_LISTSIZE        $R1   ; number of patches to be applied

    Push ${L_RESULT}
    Push ${L_LISTSIZE}

    !ifdef ADDSSL

        ; We only check the first 3 fields in the version number (X.Y.Z), ignoring the BUILD number
        ; (NOTE: This means ActivePerl 5.8.8.820 and 5.8.8.822 are not handled differently )

        !define L_VER_X    $R3     ; version number's MAJOR field
        !define L_VER_Y    $R4     ; version number's MINOR field
        !define L_VER_Z    $R5     ; version number's REVISION field

        Push ${L_VER_X}
        Push ${L_VER_Y}
        Push ${L_VER_Z}

        ; Assume we will use the built-in SSL files which are compatible with pre-0.22.3 releases
        ; (these SSL support files do not require any patches to make them POPFile-compatible)

          StrCpy $G_SSL_SOURCE "${C_BUILTIN}"
          StrCpy $G_PATCH_SOURCE "${C_BUILTIN}"

        ; For POPFile 0.22.3 (and later) releases this stand-alone utility will download and,
        ; if necessary, patch the SSL support files from the University of Winnipeg repository.
        ;
        ; However there will always be some delay between the repository being updated with SSL
        ; files which are not compatible with POPFile and the provision of the necessary patches
        ; on the POPFile website.
        ;
        ; The /BUILTIN command-line switch provides an easy way to force the installation of
        ; the old SSL support files normally used only for the POPFile 0.22.0, 0.22.1 and
        ; 0.22.2 releases as a workaround

        Call PFI_GetParameters
        Pop ${L_RESULT}
        StrCmp ${L_RESULT} "/BUILTIN" 0 look_for_minimal_Perl
        DetailPrint "The '/BUILTIN' option was supplied on the command-line"
        Goto pre_0_22_3

      look_for_minimal_Perl:

        ; The stand-alone utility may be used to add SSL support to an 0.22.x installation
        ; which is not compatible with the files in the University of Winnipeg repository,
        ; so we check the minimal Perl's version number to see if we should use the built-in
        ; SSL files instead of downloading the most up-to-date ones.

        IfFileExists "$G_ROOTDIR\perl58.dll" check_Perl_version
        DetailPrint "Assume pre-0.22.3 installation (perl58.dll not found in '$G_ROOTDIR' folder)"
        Goto pre_0_22_3

      check_Perl_version:
        GetDllVersion "$G_ROOTDIR\perl58.dll" ${L_VER_Y} ${L_VER_Z}
        IntOp ${L_VER_X} ${L_VER_Y} / 0x00010000
        IntOp ${L_VER_Y} ${L_VER_Y} & 0x0000FFFF
        IntOp ${L_VER_Z} ${L_VER_Z} / 0x00010000
        DetailPrint "Minimal Perl version ${L_VER_X}.${L_VER_Y}.${L_VER_Z} detected in '$G_ROOTDIR' folder"

        ; Only download the SSL files if the minimal Perl version is 5.8.7 or higher

        IntCmp ${L_VER_X} 5 0 pre_0_22_3 set_download_flag
        IntCmp ${L_VER_Y} 8 0 pre_0_22_3 set_download_flag
        IntCmp ${L_VER_Z} 7 0 pre_0_22_3 set_download_flag

      set_download_flag:
        StrCpy $G_SSL_SOURCE "${C_INTERNET}"
        Goto download_ssl

      pre_0_22_3:

        ; Pretend we've just downloaded the SSL archives and OpenSSL DLLs from the Internet

        DetailPrint "therefore built-in SSL files used instead of downloading the latest versions"
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
    !endif

    StrCpy $G_SSL_SOURCE "${C_INTERNET}"    ; this means "download the SSL Support files"
    StrCpy $G_PATCH_SOURCE "${C_INTERNET}"  ; this means "download the latest SSL patches"

    ; Download the SSL archives and OpenSSL DLLs

    Push "${C_UWR_IO_SOCKET_SSL}"
    Call ${UN}GetSSLFile
    Pop ${L_RESULT}
    !ifdef INSTALLER
        StrCmp ${L_RESULT} "OK" 0 installer_error_exit
    !endif

    Push "${C_UWR_NET_SSLEAY}"
    Call ${UN}GetSSLFile
    Pop ${L_RESULT}
    !ifdef INSTALLER
        StrCmp ${L_RESULT} "OK" 0 installer_error_exit
    !endif

    Push "${C_UWR_DLL_SSLEAY32}"
    Call ${UN}GetSSLFile
    Pop ${L_RESULT}
    !ifdef INSTALLER
        StrCmp ${L_RESULT} "OK" 0 installer_error_exit
    !endif

    Push "${C_UWR_DLL_LIBEAY32}"
    Call ${UN}GetSSLFile
    Pop ${L_RESULT}
    !ifdef INSTALLER
        StrCmp ${L_RESULT} "OK" 0 installer_error_exit
    !endif

    !ifdef INSTALLER
        StrCmp $G_SSL_ONLY "0" install_SSL_support

        ; The '/SSL' option was supplied so we need to make sure it is safe to install the files

        DetailPrint ""
        SetDetailsPrint both
        DetailPrint "$(PFI_LANG_PROG_CHECKIFRUNNING) $(PFI_LANG_TAKE_SEVERAL_SECONDS)"
        SetDetailsPrint listonly
        DetailPrint ""

        ; Use HKLM as a simple workaround for the case where installer is started by a non-admin user
        ; (the MakeRootDirSafe function will use this HKLM data to re-initialise $G_ROOTDIR)

        WriteRegStr HKLM "Software\POPFile Project\${C_PFI_PRODUCT}\MRI" "UAC_RootDir" "$G_ROOTDIR"

        ; If we are installing over a previous version, ensure that version is not running

        GetFunctionAddress ${L_RESULT} "${UN}MakeRootDirSafe"
        UAC::ExecCodeSegment ${L_RESULT}
    !endif

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
    untgz::extractFile -d "$G_PLS_FIELD_1" "$PLUGINSDIR\IO-Socket-SSL.tar.gz" "SSL.pm"
    StrCmp ${L_RESULT} "success" 0 error_exit

    DetailPrint ""
    StrCpy $G_PLS_FIELD_1 "$G_MPLIBDIR\Net"
    CreateDirectory $G_PLS_FIELD_1
    SetDetailsPrint both
    StrCpy $G_PLS_FIELD_2 "Net_SSLeay.pm.tar.gz"
    DetailPrint "$(PFI_LANG_PROG_FILEEXTRACT)"
    SetDetailsPrint listonly
    untgz::extractFile -d "$G_PLS_FIELD_1" "$PLUGINSDIR\Net_SSLeay.pm.tar.gz" "SSLeay.pm"
    StrCmp ${L_RESULT} "success" 0 error_exit

    DetailPrint ""
    StrCpy $G_PLS_FIELD_1 "$G_MPLIBDIR\Net\SSLeay"
    CreateDirectory $G_PLS_FIELD_1
    SetDetailsPrint both
    StrCpy $G_PLS_FIELD_2 "Net_SSLeay.pm.tar.gz"
    DetailPrint "$(PFI_LANG_PROG_FILEEXTRACT)"
    SetDetailsPrint listonly
    untgz::extractFile -d "$G_PLS_FIELD_1" "$PLUGINSDIR\Net_SSLeay.pm.tar.gz" "Handle.pm"
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
    untgz::extractV -j -d "$G_PLS_FIELD_1" "$PLUGINSDIR\Net_SSLeay.pm.tar.gz" -x ".exists" "*.html" "*.pl" "*.pm" --
    StrCmp ${L_RESULT} "success" check_bs_file

  error_exit:
    SetDetailsPrint listonly
    DetailPrint ""
    SetDetailsPrint both
    DetailPrint "$(PFI_LANG_MB_UNPACKFAIL)"
    SetDetailsPrint listonly
    DetailPrint ""
    MessageBox MB_OK|MB_ICONSTOP "$(PFI_LANG_MB_UNPACKFAIL)"

    !ifdef INSTALLER
      installer_error_exit:
        StrCpy $G_PLS_FIELD_1 "(undefined)"
        MessageBox MB_OK|MB_ICONEXCLAMATION "$(PFI_LANG_MB_REPEATSSL)"
        Goto exit
    !else
        Call PFI_GetDateTimeStamp
        Pop $G_PLS_FIELD_1
        DetailPrint "----------------------------------------------------"
        DetailPrint "POPFile SSL Setup failed ($G_PLS_FIELD_1)"
        DetailPrint "----------------------------------------------------"
        Abort
    !endif

  check_bs_file:

    ; 'untgz' versions earlier than 1.0.6 (released 28 November 2004) are unable to extract
    ; empty files so this script creates the empty 'SSLeay.bs' file if necessary
    ; (to ensure all of the $G_MPLIBDIR\auto\Net\SSLeay\SSLeay.* files exist)

    IfFileExists "$G_PLS_FIELD_1\SSLeay.bs" check_if_patches_required
    !ifdef INSTALLER
        File "/oname=$G_PLS_FIELD_1\SSLeay.bs" "zerobyte.file"
    !else
        File "/oname=$G_PLS_FIELD_1\SSLeay.bs" "..\zerobyte.file"
    !endif

  check_if_patches_required:

    !ifdef ADDSSL

        ; If the built-in SSL Support files are being used then there is no need to patch SSL.pm

        StrCmp $G_SSL_SOURCE "${C_BUILTIN}" all_done

        ; If we are adding SSL Support to POPFile 0.22.5 or later then we need to get the appropriate
        ; Patch Control File from the POPFile website instead of using the generic one (0.22.x.pcf)

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
        DetailPrint "POPFile version ${L_VER_X}.${L_VER_Y}.${L_VER_Z} detected in '$G_ROOTDIR' folder"

        ; 0.22.5 was the first release to use a Patch Control File

        IntCmp ${L_VER_X}  0 0 use_generic_pcf use_appropriate_pcf
        IntCmp ${L_VER_Y} 22 0 use_generic_pcf use_appropriate_pcf
        IntCmp ${L_VER_Z}  5 0 use_generic_pcf use_appropriate_pcf

      use_appropriate_pcf:
        StrCpy $G_PATCH_CTRL_FILE "${L_VER_X}.${L_VER_Y}.${L_VER_Z}.pcf"

      download_pcf:
    !else

        ; Try to download the appropriate POPFile Patch Control File

        StrCpy $G_PATCH_CTRL_FILE "${C_PATCH_CTRL_FILE}"
    !endif

    DetailPrint ""
    DetailPrint ""
    DetailPrint "Download the Patch Control File and MD5 sums from the POPFile website..."
    DetailPrint ""

    Push "${C_PATCH_WEBSITE}/$G_PATCH_CTRL_FILE"
    Call ${UN}GetSSLFile
    Pop ${L_RESULT}
    StrCmp ${L_RESULT} "OK" 0 use_default_patches

    ; Download the file containing the MD5 sums for the files in the patch directory

    Push "${C_PATCH_WEBSITE}/${C_MD5SUMS_FILE}"
    Call ${UN}GetSSLFile
    Pop ${L_RESULT}
    StrCmp ${L_RESULT} "OK" 0 use_default_patches

    ; Calculate the MD5 sum for the patch control file and then
    ; compare the result with the value given in the MD5SUMS file

    md5dll::GetMD5File "$PLUGINSDIR\$G_PATCH_CTRL_FILE"
    Pop ${L_RESULT}
    DetailPrint ""
    DetailPrint "Calculated MD5 sum for Patch Control File: ${L_RESULT}"
    Push $G_PATCH_CTRL_FILE
    Call ${UN}ExtractMD5sum
    Pop $G_PLS_FIELD_1
    DetailPrint "Downloaded MD5 sum for Patch Control File: $G_PLS_FIELD_1"
    StrCmp $G_PLS_FIELD_1 ${L_RESULT} use_control_file
    DetailPrint "MD5 sums differ! Default patch data will be used instead of the downloaded file."
    MessageBox MB_OK|MB_ICONEXCLAMATION "POPFile Patch Control File has bad checksum!\
        ${MB_NL}${MB_NL}\
        Default SSL patch data will be used"

  use_default_patches:

    ; Failed to download POPFile's SSL Patch Control file or the MD5 sums

    StrCpy $G_PATCH_SOURCE "${C_BUILTIN}"
    DetailPrint "Unable to download data from POPFile website, using built-in SSL patches instead"
    DetailPrint ""

    SetDetailsPrint none
    !ifdef INSTALLER
        File "/oname=$PLUGINSDIR\${C_PATCH_CTRL_FILE}" "${C_PATCH_CTRL_FILE}"

        ; The 0.22.5, 1.0.0 and 1.0.1 releases do not need any SSL patches so "SSL_pm.pat" is not needed here
        ; File /nonfatal "/oname=$PLUGINSDIR\SSL_pm.pat" "SSL_pm.pat"

    !else
        File "/oname=$PLUGINSDIR\${C_PATCH_CTRL_FILE}" "..\0.22.x.pcf"
        File /nonfatal "/oname=$PLUGINSDIR\SSL_pm.pat" "..\SSL_pm.pat"
        StrCpy $G_PATCH_CTRL_FILE "${C_PATCH_CTRL_FILE}"
    !endif

    ; Ensure the patch control file uses CRLF as the EOL marker
    ; (the file is used as an INI file so it is best for it to use CRLF instead of LF)

    Push $G_PATCH_CTRL_FILE
    Call ${UN}EOL2CRLF
    SetDetailsPrint listonly

    ; Record information about the built-in Patch Control File in the installer log

    !insertmacro MUI_INSTALLOPTIONS_READ $G_PLS_FIELD_1 "$G_PATCH_CTRL_FILE" "Settings" "POPFileVersion"
    !insertmacro MUI_INSTALLOPTIONS_READ $G_PLS_FIELD_2 "$G_PATCH_CTRL_FILE" "Settings" "PatchIssue"
    DetailPrint "POPFile $G_PLS_FIELD_1 Patch Control File (issue $G_PLS_FIELD_2) [*** Built-in version ***]"
    !insertmacro MUI_INSTALLOPTIONS_READ $G_PLS_FIELD_1 "$G_PATCH_CTRL_FILE" "Settings" "Comment"
    StrCmp $G_PLS_FIELD_1 "" builtin_patch_count
    DetailPrint "$G_PLS_FIELD_1"

  builtin_patch_count:
    DetailPrint ""
    !insertmacro MUI_INSTALLOPTIONS_READ ${L_LISTSIZE} "$G_PATCH_CTRL_FILE" "Settings" "NumberOfPatches"
    StrCmp ${L_LISTSIZE} "0" 0 apply_patches
    DetailPrint "No POPFile SSL patches are required"
    Goto all_done

   use_control_file:
    DetailPrint "Patch Control File MD5 sums match"
    DetailPrint ""

    ; Ensure the patch control file uses CRLF as the EOL marker
    ; (the file is used as an INI file so it is best for it to use CRLF instead of LF)

    Push $G_PATCH_CTRL_FILE
    Call ${UN}EOL2CRLF

    ; Record information about the Patch Control File in the installer log

    !insertmacro MUI_INSTALLOPTIONS_READ $G_PLS_FIELD_1 "$G_PATCH_CTRL_FILE" "Settings" "POPFileVersion"
    !insertmacro MUI_INSTALLOPTIONS_READ $G_PLS_FIELD_2 "$G_PATCH_CTRL_FILE" "Settings" "PatchIssue"
    DetailPrint ""
    DetailPrint "POPFile $G_PLS_FIELD_1 Patch Control File (issue $G_PLS_FIELD_2)"
    !insertmacro MUI_INSTALLOPTIONS_READ $G_PLS_FIELD_1 "$G_PATCH_CTRL_FILE" "Settings" "Comment"
    StrCmp $G_PLS_FIELD_1 "" get_the_patches
    DetailPrint "$G_PLS_FIELD_1"

  get_the_patches:
    DetailPrint ""
    DetailPrint ""
    Call ${UN}DownloadPatches
    Pop ${L_RESULT}

    ; Are there any patches to be applied?

    StrCmp ${L_RESULT} "0" all_done

  apply_patches:
    Call ${UN}ApplyPatches

  all_done:
    DetailPrint ""

    !ifdef INSTALLER
      exit:
        SetDetailsPrint textonly
        DetailPrint "$(PFI_LANG_INST_PROG_ENDSEC)"
        SetDetailsPrint listonly
        !insertmacro SECTIONLOG_EXIT "SSL Support"
    !else
        Pop ${L_VER_Z}
        Pop ${L_VER_Y}
        Pop ${L_VER_X}

        !undef L_VER_X
        !undef L_VER_Y
        !undef L_VER_Z
    !endif

    Pop ${L_LISTSIZE}
    Pop ${L_RESULT}

    !undef L_RESULT
    !undef L_LISTSIZE

    !if '${UN}' == 'un.'
      skip_section:
    !endif

  SectionEnd
!macroend


#==============================================================================================
#
# Macro-based Functions which may be used by the installer and uninstaller
#
#    Macro:                FUNCTION_GETSSLFILE
#    Installer Function:   GetSSLFile
#    Uninstaller Function: un.GetSSLFile
#
#    Macro:                FUNCTION_EXTRACTMD5SUM
#    Installer Function:   ExtractMD5sum
#    Uninstaller Function: un.ExtractMD5sum
#
#    Macro:                FUNCTION_STRCHECKDECIMAL
#    Installer Function:   StrCheckHexadecimal
#    Uninstaller Function: un.StrCheckHexadecimal
#
#    Macro:                FUNCTION_EOL2CRLF
#    Installer Function:   EOL2CRLF
#    Uninstaller Function: un.EOL2CRLF
#
#    Macro:                FUNCTION_DOWNLOADPATCHES
#    Installer Function:   DownloadPatches
#    Uninstaller Function: un.DownloadPatches
#
#    Macro:                FUNCTION_APPLYPATCHES
#    Installer Function:   ApplyPatches
#    Uninstaller Function: un.ApplyPatches
#
#==============================================================================================


#--------------------------------------------------------------------------
# Macro: FUNCTION_GETSSLFILE
#
# The installation process and the uninstall process may both need a function which
# downloads a single SSL Support file from the POPFile website. This macro makes
# maintenance easier by ensuring that both processes use identical functions, with
# the only difference being their names.
#
# Inputs:
#         (top of stack)     - full URL used to download the SSL file
#
# Outputs:
#         (top of stack)     - status returned by the download plugin
#
# Usage (after macro has been 'inserted'):
#
#         Push "http://www.example.com/download/SSL.zip"
#         Call GetSSLFile
#         Pop $0
#
#         ($R0 at this point is "OK" if the file was downloaded without any errors being detected)
#
#--------------------------------------------------------------------------

  !ifdef ADDSSL
      !define C_NSISDL_TRANSLATIONS "/TRANSLATE '$(PFI_LANG_NSISDL_DOWNLOADING)' '$(PFI_LANG_NSISDL_CONNECTING)' '$(PFI_LANG_NSISDL_SECOND)' '$(PFI_LANG_NSISDL_MINUTE)' '$(PFI_LANG_NSISDL_HOUR)' '$(PFI_LANG_NSISDL_PLURAL)' '$(PFI_LANG_NSISDL_PROGRESS)' '$(PFI_LANG_NSISDL_REMAINING)'"
  !endif

!macro FUNCTION_GETSSLFILE UN
  Function ${UN}GetSSLFile

    Pop $G_SSL_FILEURL

    StrCpy $G_PLS_FIELD_1 $G_SSL_FILEURL
    Push $G_PLS_FIELD_1
    Call ${UN}PFI_StrBackSlash
    Call ${UN}PFI_GetParent
    Pop $G_PLS_FIELD_2
    StrLen $G_PLS_FIELD_2 $G_PLS_FIELD_2
    IntOp $G_PLS_FIELD_2 $G_PLS_FIELD_2 + 1
    StrCpy $G_PLS_FIELD_1 "$G_PLS_FIELD_1" "" $G_PLS_FIELD_2
    StrCpy $G_PLS_FIELD_2 "$G_SSL_FILEURL" $G_PLS_FIELD_2
    DetailPrint ""
    DetailPrint "$(PFI_LANG_PROG_STARTDOWNLOAD)"

    inetc::get /CAPTION "Internet Download" /RESUME "$(PFI_LANG_MB_CHECKINTERNET)" ${C_NSISDL_TRANSLATIONS} "$G_SSL_FILEURL" "$PLUGINSDIR\$G_PLS_FIELD_1" /END
    Pop $G_PLS_FIELD_2

    StrCmp $G_PLS_FIELD_2 "OK" file_received
    SetDetailsPrint both
    DetailPrint "$(PFI_LANG_MB_NSISDLFAIL_1)"
    SetDetailsPrint listonly
    DetailPrint "$(PFI_LANG_MB_NSISDLFAIL_2)"
    MessageBox MB_OK|MB_ICONEXCLAMATION "$(PFI_LANG_MB_NSISDLFAIL_1)${MB_NL}$(PFI_LANG_MB_NSISDLFAIL_2)"
    SetDetailsPrint listonly
    DetailPrint ""
    !ifdef ADDSSL
        Call PFI_GetDateTimeStamp
        Pop $G_PLS_FIELD_1
        DetailPrint "----------------------------------------------------"
        DetailPrint "POPFile SSL Setup failed ($G_PLS_FIELD_1)"
        DetailPrint "----------------------------------------------------"
        Abort
    !endif

  file_received:
    Push $G_PLS_FIELD_2

  FunctionEnd
!macroend


#--------------------------------------------------------------------------
# Macro: FUNCTION_EXTRACTMD5SUM
#
# The installation process and the uninstall process may both need a function which
# extracts the MD5 sum for a particular file from the list of MD5 sums downloaded
# from the POPFile website. This macro makes maintenance easier by ensuring that
# both processes use identical functions, with the only difference being their names.
#
# The MD5SUMS file contains the MD5 sums for the files in the patch directory.
# This function searches for the MD5 sum for the specified filename and returns
# either a 32-hexdigit string (if a matching entry is found in the MD5SUMS file)
# or an empty string (if the specified filename is not found in the file)
#
# Lines starting with '#' or ';' in the MD5SUMS file are ignored, as are empty lines.
#
# Lines in MD5SUMS which contain MD5 sums are assumed to be in this format:
# (a) positions 1 to 32 contain a 32 character hexadecimal number (line starts in column 1)
# (b) column 33 is a space character
# (c) column 34 is the text/binary flag (' ' = text, '*' = binary)
# (d) column 35 is the first character of the filename (filename terminates with end-of-line)
#
# Inputs:
#         (top of stack)     - name (without the path) of the file whose MD5 sum we seek
#                              (the MD5 sums file has already been downloaded to $PLUGINSDIR)
#
# Outputs:
#         (top of stack)     - the 32-digit MD5 sum (=success) or an empty string (=failure)
#
#--------------------------------------------------------------------------

!macro FUNCTION_EXTRACTMD5SUM UN
  Function ${UN}ExtractMD5sum

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
    Call ${UN}PFI_TrimNewlines
    Pop ${L_DATA}
    StrCmp ${L_DATA} "" read_next_line
    StrCpy ${L_RESULT} ${L_DATA} "" 34       ; NSIS strings start at position 0 not 1
    StrCmp ${L_RESULT} ${L_MD5NAME} 0 read_next_line
    StrCpy ${L_RESULT} ${L_DATA} 32
    Push ${L_RESULT}
    Call ${UN}StrCheckHexadecimal
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
!macroend


#--------------------------------------------------------------------------
# Macro: FUNCTION_STRCHECKHEXADECIMAL
#
# The installation process and the uninstall process both need a function which
# checks if a given string contains only hexadecimal digits. This macro makes
# maintenance easier by ensuring that both processes use identical functions,
# with the only difference being their names.
#
# Inputs:
#         (top of stack)   - string which may contain a hexadecimal number
#
# Outputs:
#         (top of stack)   - the input string (if valid) or "" (if invalid)
#
# Usage (after the macro has been inserted):
#
#         Push "123abc"
#         Call StrCheckHexadecimal
#         Pop $R0
#
#         ($R0 at this point is "123abc")
#
#--------------------------------------------------------------------------

!macro FUNCTION_STRCHECKHEXADECIMAL UN
  Function ${UN}StrCheckHexadecimal

    !define VALID_DIGIT     "0123456789abcdef"    ; accept only these digits
    !define BAD_OFFSET      16                    ; length of VALID_DIGIT string

    !define L_STRING        $0   ; The input string
    !define L_RESULT        $1   ; Holds the result: either "" (if input is invalid) or the input string (if valid)
    !define L_CURRENT       $2   ; A character from the input string
    !define L_OFFSET        $3   ; The offset to a character in the "validity check" string
    !define L_VALIDCHAR     $4   ; A character from the "validity check" string
    !define L_VALIDLIST     $5   ; Holds the current "validity check" string
    !define L_CHARSLEFT     $6   ; To cater for MBCS input strings, terminate when end of string reached, not when a null byte reached

    Exch ${L_STRING}
    Push ${L_RESULT}
    Push ${L_CURRENT}
    Push ${L_OFFSET}
    Push ${L_VALIDCHAR}
    Push ${L_VALIDLIST}
    Push ${L_CHARSLEFT}

    StrCpy ${L_RESULT} ""

  next_input_char:
    StrLen ${L_CHARSLEFT} ${L_STRING}
    StrCmp ${L_CHARSLEFT} 0 done
    StrCpy ${L_CURRENT} ${L_STRING} 1                   ; Get the next character from the input string
    StrCpy ${L_VALIDLIST} ${VALID_DIGIT}${L_CURRENT}  ; Add it to end of "validity check" to guarantee a match
    StrCpy ${L_STRING} ${L_STRING} "" 1
    StrCpy ${L_OFFSET} -1

  next_valid_char:
    IntOp ${L_OFFSET} ${L_OFFSET} + 1
    StrCpy ${L_VALIDCHAR} ${L_VALIDLIST} 1 ${L_OFFSET}    ; Extract next "valid" char (from "validity check" string)
    StrCmp ${L_CURRENT} ${L_VALIDCHAR} 0 next_valid_char
    IntCmp ${L_OFFSET} ${BAD_OFFSET} invalid 0 invalid    ; If match is with the char we added, input is bad
    StrCpy ${L_RESULT} ${L_RESULT}${L_VALIDCHAR}          ; Add "valid" character to the result
    goto next_input_char

  invalid:
    StrCpy ${L_RESULT} ""

  done:
    StrCpy ${L_STRING} ${L_RESULT}  ; Result is either a string of hexadecimal digits or ""
    Pop ${L_CHARSLEFT}
    Pop ${L_VALIDLIST}
    Pop ${L_VALIDCHAR}
    Pop ${L_OFFSET}
    Pop ${L_CURRENT}
    Pop ${L_RESULT}
    Exch ${L_STRING}                ; Place result on top of the stack

    !undef VALID_DIGIT
    !undef BAD_OFFSET

    !undef L_STRING
    !undef L_RESULT
    !undef L_CURRENT
    !undef L_OFFSET
    !undef L_VALIDCHAR
    !undef L_VALIDLIST
    !undef L_CHARSLEFT

  FunctionEnd
!macroend


#--------------------------------------------------------------------------
# Macro: FUNCTION_EOL2CRLF
#
# The installation process and the uninstall process both need a function which
# ensures that the Patch Control File downloaded from the POPFile website uses
# the standard Carriage Return-Line Feed (CRLF) pair employed by Windows as the
# end-of-line (EOL) sequence (because this file is treated as a Windows INI file).
# This macro makes maintenance easier by ensuring that both processes use identical
# functions, with the only difference being their names.
#
# Inputs:
#         (top of stack)  - name of the file to be converted (assumed to be in $PLUGINSDIR)
#
# Outputs:
#         (none)
#--------------------------------------------------------------------------

!macro FUNCTION_EOL2CRLF UN
  Function ${UN}EOL2CRLF

    !define L_FILENAME    $R9   ; name of input file (assumed to be in $PLUGINSDIR)
    !define L_SOURCE      $R8   ; handle used to access the input file
    !define L_TARGET      $R7   ; handle used to access the output file
    !define L_TEMP        $R6

    Exch ${L_FILENAME}

    IfFileExists "$PLUGINSDIR\${L_FILENAME}" 0 quickexit

    Push ${L_SOURCE}
    Push ${L_TARGET}
    Push ${L_TEMP}

    ; Ensure the Patch Control File is in standard Windows format (i.e. lines end in CRLF)

    FileOpen ${L_SOURCE} "$PLUGINSDIR\${L_FILENAME}" r
    FileOpen ${L_TARGET} "$PLUGINSDIR\${L_FILENAME}.txt" w
    ClearErrors

  loop:
    FileRead ${L_SOURCE} ${L_TEMP}
    IfErrors close_files
    Push ${L_TEMP}
    Call ${UN}PFI_TrimNewlines
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
!macroend


#--------------------------------------------------------------------------
# Macro: FUNCTION_DOWNLOADPATCHES
#
# The installation process and the uninstall process both need a function which
# function downloads all of the patches specified in the Patch Control File.
#
# A loop is used to process the list of required patches so we use a function for
# this work instead of in-line code in order to reduce progress bar flickers. The
# number of patches specified is returned, even if we were unable to download all
# of them.
#
# This macro makes maintenance easier by ensuring that both processes use identical
# functions, with the only difference being their names.
#
# Inputs:
#         (none)
#
# Outputs:
#         (top of stack)  - the number of patches specified in the patch control file
#--------------------------------------------------------------------------

!macro FUNCTION_DOWNLOADPATCHES UN
  Function ${UN}DownloadPatches

    !define L_INDEX       $R9   ; loop counter used when accessing the Patch Control File
    !define L_LISTSIZE    $R8   ; number of patches to be applied
    !define L_PATCHFILE   $R7   ; name of a file containing patch data
    !define L_PCF_ID      $R6   ; name of a '[Patch-x]' section in the patch control file
    !define L_RESULT      $R5

    Push ${L_INDEX}
    Push ${L_LISTSIZE}
    Exch
    Push ${L_PATCHFILE}
    Push ${L_PCF_ID}
    Push ${L_RESULT}

    !insertmacro MUI_INSTALLOPTIONS_READ ${L_LISTSIZE} "$G_PATCH_CTRL_FILE" "Settings" "NumberOfPatches"
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
    !insertmacro MUI_INSTALLOPTIONS_READ ${L_PATCHFILE} "$G_PATCH_CTRL_FILE" "${L_PCF_ID}" "PatchData"
    StrCmp ${L_PATCHFILE} "" no_patch_specified
    Push "${C_PATCH_WEBSITE}/${L_PATCHFILE}"
    Call ${UN}GetSSLFile
    Pop ${L_RESULT}
    !insertmacro MUI_INSTALLOPTIONS_WRITE "$G_PATCH_CTRL_FILE" "${L_PCF_ID}" "DownloadStatus" "${L_RESULT}"
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
!macroend


#--------------------------------------------------------------------------
# Macro: FUNCTION_APPLYPATCHES
#
# The installation process and the uninstall process both need a function which
# applies all of the patches specified in the patch control file in the PLUGINSDIR,
# using patch data files found in the same directory. A loop is used to process the
# list of required patches so we use a function for this work instead of in-line code
# in order to reduce progress bar flickers.
#
# This macro makes maintenance easier by ensuring that both processes use identical
# functions, with the only difference being their names.
#
# Inputs:
#         (none)
#
# Outputs:
#         (none)
#--------------------------------------------------------------------------

!macro FUNCTION_APPLYPATCHES UN
  Function ${UN}ApplyPatches

    !define L_INDEX           $R9   ; loop counter used when accessing the Patch Control File
    !define L_LISTSIZE        $R8   ; number of patches to be applied
    !define L_PATCHFILE       $R7   ; name of a file containing patch data
    !define L_PCF_ID          $R6   ; name of a '[Patch-x]' section in the patch control file
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

    !insertmacro MUI_INSTALLOPTIONS_READ ${L_LISTSIZE} "$G_PATCH_CTRL_FILE" "Settings" "NumberOfPatches"

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
    !insertmacro MUI_INSTALLOPTIONS_READ ${L_PATCHFILE} "$G_PATCH_CTRL_FILE" "${L_PCF_ID}" "PatchData"
    StrCmp ${L_PATCHFILE} "" apply_next_patch
    !insertmacro MUI_INSTALLOPTIONS_READ $G_PLS_FIELD_1 "$G_PATCH_CTRL_FILE" "${L_PCF_ID}" "LogMsg-1"
    DetailPrint ""
    DetailPrint ""
    DetailPrint "[${L_PCF_ID}] $G_PLS_FIELD_1"
    DetailPrint "[${L_PCF_ID}]"
    !insertmacro MUI_INSTALLOPTIONS_READ $G_PLS_FIELD_1 "$G_PATCH_CTRL_FILE" "${L_PCF_ID}" "Category"
    DetailPrint "[${L_PCF_ID}] This patch is $G_PLS_FIELD_1"
    DetailPrint "[${L_PCF_ID}]"
    !insertmacro MUI_INSTALLOPTIONS_READ ${L_PATCHFILE} "$G_PATCH_CTRL_FILE" "${L_PCF_ID}" "PatchData"
    !insertmacro MUI_INSTALLOPTIONS_READ ${L_TARGET_FOLDER} "$G_PATCH_CTRL_FILE" "${L_PCF_ID}" "TargetFolder"
    StrCpy ${L_TARGET_FOLDER} $G_ROOTDIR\${L_TARGET_FOLDER}
    !insertmacro MUI_INSTALLOPTIONS_READ ${L_TARGET_FILE} "$G_PATCH_CTRL_FILE" "${L_PCF_ID}" "TargetFile"
    DetailPrint "[${L_PCF_ID}] Target file: ${L_TARGET_FOLDER}\${L_TARGET_FILE}"
    DetailPrint "[${L_PCF_ID}]"
    StrCmp $G_PATCH_SOURCE "${C_BUILTIN}" check_target_path
    !insertmacro MUI_INSTALLOPTIONS_READ $G_PLS_FIELD_1 "$G_PATCH_CTRL_FILE" "${L_PCF_ID}" "DownloadStatus"
    StrCmp $G_PLS_FIELD_1 "OK" check_target_path
    StrCpy $G_PLS_FIELD_2 "Unable to apply '${L_PATCHFILE}' patch data ($G_PLS_FIELD_1)"
    DetailPrint "[${L_PCF_ID}] $G_PLS_FIELD_2"
    Goto patch_failure

  check_target_path:
    Push "${L_TARGET_FOLDER}\${L_TARGET_FILE}"
    Push ".."
    Call ${UN}PFI_StrStr
    Pop ${L_RESULT}
    StrCmp ${L_RESULT} "" apply_patch
    StrCpy $G_PLS_FIELD_2 "Patch not applied - invalid target path"
    DetailPrint "[${L_PCF_ID}] $G_PLS_FIELD_2"
    Goto patch_failure

  apply_patch:
    vpatch::vpatchfile "$PLUGINSDIR\${L_PATCHFILE}" "${L_TARGET_FOLDER}\${L_TARGET_FILE}" "$PLUGINSDIR\patched-${L_TARGET_FILE}"
    Pop $G_PLS_FIELD_2
    !insertmacro MUI_INSTALLOPTIONS_WRITE "$G_PATCH_CTRL_FILE" "${L_PCF_ID}" "PatchResult" "$G_PLS_FIELD_2"

    !insertmacro MUI_INSTALLOPTIONS_READ $G_PLS_FIELD_1 "$G_PATCH_CTRL_FILE" "${L_PCF_ID}" "LogMsg-2"
    SetDetailsPrint both
    DetailPrint "[${L_PCF_ID}] $G_PLS_FIELD_1 $G_PLS_FIELD_2"
    SetDetailsPrint listonly

    StrCmp $G_PLS_FIELD_2 "OK" vpatch_ok
    StrCmp $G_PLS_FIELD_2 "OK, new version already installed" show_good_status patch_failure

  vpatch_ok:
    DetailPrint "[${L_PCF_ID}]"
    !insertmacro SSL_BACKUP_123_DP "${L_TARGET_FOLDER}" "${L_TARGET_FILE}"
    SetDetailsPrint none
    Rename "$PLUGINSDIR\patched-${L_TARGET_FILE}" "${L_TARGET_FOLDER}\${L_TARGET_FILE}"
    IfFileExists "${L_TARGET_FOLDER}\${L_TARGET_FILE}" patch_success
    Rename "$${L_TARGET_FOLDER}\${L_TARGET_FILE}.bk1" "${L_TARGET_FOLDER}\${L_TARGET_FILE}"
    SetDetailsPrint listonly
    StrCpy $G_PLS_FIELD_2 "Unable to replace target file with patched file"

  patch_failure:
    !insertmacro MUI_INSTALLOPTIONS_WRITE "$G_PATCH_CTRL_FILE" "${L_PCF_ID}" "PatchResult" "$G_PLS_FIELD_2"
    DetailPrint "[${L_PCF_ID}]"
    SetDetailsPrint both
    !insertmacro MUI_INSTALLOPTIONS_READ $G_PLS_FIELD_1 "$G_PATCH_CTRL_FILE" "${L_PCF_ID}" "LogMsg-4"
    DetailPrint "[${L_PCF_ID}] $G_PLS_FIELD_1"
    SetDetailsPrint listonly
    !ifdef ADDSSL
        Goto show_msgbox
    !endif
    !insertmacro MUI_INSTALLOPTIONS_READ ${L_RESULT} "$G_PATCH_CTRL_FILE" "${L_PCF_ID}" "Category"
    StrCmp ${L_RESULT} "ESSENTIAL" 0 apply_next_patch

    !ifdef ADDSSL
        show_msgbox:
    !endif
    MessageBox MB_OK|MB_ICONEXCLAMATION "$G_PLS_FIELD_1\
        ${MB_NL}\
        ($G_PLS_FIELD_2)"
    Goto apply_next_patch

  patch_success:
    !insertmacro MUI_INSTALLOPTIONS_READ $G_PLS_FIELD_1 "$G_PATCH_CTRL_FILE" "${L_PCF_ID}" "LogMsg-3"
    SetDetailsPrint listonly
    DetailPrint "[${L_PCF_ID}]"
    DetailPrint "[${L_PCF_ID}] $G_PLS_FIELD_1"

  show_good_status:
    !ifdef ADDSSL
        MessageBox MB_OK|MB_ICONINFORMATION "$G_PLS_FIELD_1\
            ${MB_NL}\
            ($G_PLS_FIELD_2)"
    !endif
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
!macroend


#--------------------------------------------------------------------------
# Code block to be used when installing POPFile (i.e. used in setup.exe)
#--------------------------------------------------------------------------

!macro SSL_SUPPORT_FOR_INSTALLER

  !insertmacro SECTION_SSLSUPPORT           ""
  !insertmacro FUNCTION_GETSSLFILE          ""
  !insertmacro FUNCTION_EXTRACTMD5SUM       ""
  !insertmacro FUNCTION_STRCHECKHEXADECIMAL ""
  !insertmacro FUNCTION_EOL2CRLF            ""
  !insertmacro FUNCTION_DOWNLOADPATCHES     ""
  !insertmacro FUNCTION_APPLYPATCHES        ""

!macroend


#--------------------------------------------------------------------------
# Code block to be used when modifying POPFile (i.e. used in uninstaller.exe)
#--------------------------------------------------------------------------

!macro HANDLE_ADDING_SSL_SUPPORT

  !insertmacro SECTION_SSLSUPPORT           "un."
  !insertmacro FUNCTION_GETSSLFILE          "un."
  !insertmacro FUNCTION_EXTRACTMD5SUM       "un."
  !insertmacro FUNCTION_STRCHECKHEXADECIMAL "un."
  !insertmacro FUNCTION_EOL2CRLF            "un."
  !insertmacro FUNCTION_DOWNLOADPATCHES     "un."
  !insertmacro FUNCTION_APPLYPATCHES        "un."

!macroend


#--------------------------------------------------------------------------
# Code block to be used when compiling the POPFile SSL Setup Wizard
#--------------------------------------------------------------------------

!ifdef ADDSSL

  !insertmacro SECTION_SSLSUPPORT           ""
  !insertmacro FUNCTION_GETSSLFILE          ""
  !insertmacro FUNCTION_EXTRACTMD5SUM       ""
  !insertmacro FUNCTION_STRCHECKHEXADECIMAL ""
  !insertmacro FUNCTION_EOL2CRLF            ""
  !insertmacro FUNCTION_DOWNLOADPATCHES     ""
  !insertmacro FUNCTION_APPLYPATCHES        ""

!endif

#--------------------------------------------------------------------------
# End of 'getssl.nsh'
#--------------------------------------------------------------------------