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
#                On 18 July 2006 the University of Winnipeg repository was updated to provide
#                IO::Socket::SSL v0.99 which is not compatible with POPFile so a patch will be
#                applied to downgrade the relevant file to the compatible v0.97 version.
#
#                On 18 August 2006 the University of Winnipeg repository was updated to supply
#                IO::Socket::SSL v0.999 which is not compatible with POPFile so a patch will
#                be applied to downgrade the relevant file to the compatible v0.97 version.
#
#                On 13 September 2006 the University of Winnipeg repository was updated to
#                provide IO::Socket::SSL v1.01 which is not compatible with POPFile so this
#                utility will apply a patch to downgrade this to the compatible v0.97 version.
#
# Copyright (c) 2005-2006 John Graham-Cumming
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

  ; This version of the script has been tested with the "NSIS v2.21" compiler,
  ; released 20 October 2006. This particular compiler can be downloaded from
  ; http://prdownloads.sourceforge.net/nsis/nsis-2.21-setup.exe?download

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
  ; Tested with the inetc.dll plugin timestamped 12 November 2006 15:32:16

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
  ; ${NSISDIR}\Contrib\untgz\ folder if you wish, but this step is entirely optional.
  ;
  ; Tested with versions 1.0.5, 1.0.6, 1.0.7 and 1.0.8 of the 'untgz' plugin.

  ;------------------------------------------------
  ; How the SSL.pm patch was created
  ;------------------------------------------------

  ; The patch used to downgrade SSL.pm v0.99, SSL.pm v0.999 or SSL.pm v1.01 to v0.97 was
  ; created using the VPATCH package which is supplied with NSIS. The following commands
  ; were used to create the patch:
  ;
  ;   GenPat.exe SSL_0.99.pm SSL_0.97.pm SSL_pm.pat
  ;   GenPat.exe SSL_0.999.pm SSL_0.97.pm SSL_pm.pat
  ;   GenPat.exe SSL_1.01.pm SSL_0.97.pm SSL_pm.pat
  ;
  ; where SSL_0.97.pm  was the SSL.pm file from v0.97  of the IO::Socket:SSL module
  ;  and  SSL_0.99.pm  was the SSL.pm file from v0.99  of the IO::Socket:SSL module
  ;  and  SSL_0.999.pm was the SSL.pm file from v0.999 of the IO::Socket:SSL module
  ;  and  SSL_1.01.pm  was the SSL.pm file from v1.01  of the IO::Socket:SSL module

#--------------------------------------------------------------------------
# URLs used to download the necessary SSL support archives and files
# (all from the University of Winnipeg Repository)
#--------------------------------------------------------------------------

  ; In addition to some extra Perl modules, POPFile's SSL support needs two OpenSSL DLLs.

  !define C_UWR_IO_SOCKET_SSL "http://theoryx5.uwinnipeg.ca/ppms/x86/IO-Socket-SSL.tar.gz"
  !define C_UWR_NET_SSLEAY    "http://theoryx5.uwinnipeg.ca/ppms/x86/Net_SSLeay.pm.tar.gz"
  !define C_UWR_DLL_SSLEAY32  "http://theoryx5.uwinnipeg.ca/ppms/scripts/ssleay32.dll"
  !define C_UWR_DLL_LIBEAY32  "http://theoryx5.uwinnipeg.ca/ppms/scripts/libeay32.dll"


#--------------------------------------------------------------------------
# User Registers (Global)
#--------------------------------------------------------------------------

  Var G_SSL_FILEURL        ; full URL used to download SSL file

  Var G_PLS_FIELD_2        ; used to customise translated text strings


#--------------------------------------------------------------------------
# Installer Section: POPFile SSL Support
#--------------------------------------------------------------------------

!ifdef INSTALLER
    Section /o "SSL Support" SecSSL
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


  !define L_RESULT  $R0  ; used by the 'untgz' plugin to return the result

  Push ${L_RESULT}

  !ifdef ADDSSL

      ; Assume we will use the built-in SSL files which are compatible with pre-0.22.3 releases

      StrCpy $G_SSL_SOURCE "${C_BUILTIN}"

      ; For POPFile 0.22.3 (and later) releases this stand-alone utility will download and,
      ; if necessary, patch the SSL support files from the University of Winnipeg repository.
      ;
      ; However there will always be some delay between the repository being updated with SSL
      ; files which are not compatible with POPFile and the generation of an updated version
      ; of this stand-alone utility which fixes the SSL compatibility problem.
      ;
      ; The /BUILTIN command-line switch provides an easy way to force the installation of
      ; the old SSL support files normally used only for the POPFile 0.22.0, 0.22.1 and
      ; 0.22.2 releases as a workaround until this utility can be updated to handle the new
      ; SSL support files.

      Call PFI_GetParameters
      Pop ${L_RESULT}
      StrCmp ${L_RESULT} "/BUILTIN" 0 look_for_minimal_Perl
      DetailPrint "The '/BUILTIN' option was supplied on the command-line"
      Goto assume_pre_0_22_3

    look_for_minimal_Perl:

      ; The stand-alone utility may be used to add SSL support to an 0.22.x installation
      ; which is not compatible with the files in the University of Winnipeg repository,
      ; so we check the minimal Perl's version number to see if we should use the built-in
      ; SSL files instead of downloading the most up-to-date ones.

      IfFileExists "$G_ROOTDIR\perl58.dll" check_Perl_version
      DetailPrint "Assume pre-0.22.3 installation (perl58.dll not found in '$G_ROOTDIR' folder)"
      Goto assume_pre_0_22_3

    check_Perl_version:

      !define L_VER_X    $R1     ; We check only the first three fields in the version number
      !define L_VER_Y    $R2     ; but the code could be further simplified by merely testing
      !define L_VER_Z    $R3     ; the 'build number' field (the field we currently ignore)

      Push ${L_VER_X}
      Push ${L_VER_Y}
      Push ${L_VER_Z}

      GetDllVersion "$G_ROOTDIR\perl58.dll" ${L_VER_Y} ${L_VER_Z}
      IntOp ${L_VER_X} ${L_VER_Y} / 0x00010000
      IntOp ${L_VER_Y} ${L_VER_Y} & 0x0000FFFF
      IntOp ${L_VER_Z} ${L_VER_Z} / 0x00010000
      DetailPrint "Minimal Perl version ${L_VER_X}.${L_VER_Y}.${L_VER_Z} detected in '$G_ROOTDIR' folder"

      ; Only download the SSL files if the minimal Perl version is 5.8.7 or higher

      IntCmp ${L_VER_X} 5 0 restore_vars set_download_flag
      IntCmp ${L_VER_Y} 8 0 restore_vars set_download_flag
      IntCmp ${L_VER_Z} 7 0 restore_vars set_download_flag

    set_download_flag:
      StrCpy $G_SSL_SOURCE "${C_INTERNET}"

    restore_vars:
      Pop ${L_VER_Z}
      Pop ${L_VER_Y}
      Pop ${L_VER_X}

      !undef L_VER_X
      !undef L_VER_Y
      !undef L_VER_Z

      StrCmp $G_SSL_SOURCE "${C_INTERNET}" download_ssl

    assume_pre_0_22_3:

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

  ; Download the SSL archives and OpenSSL DLLs

  Push "${C_UWR_IO_SOCKET_SSL}"
  Call GetSSLFile

  Push "${C_UWR_NET_SSLEAY}"
  Call GetSSLFile

  Push "${C_UWR_DLL_SSLEAY32}"
  Call GetSSLFile

  Push "${C_UWR_DLL_LIBEAY32}"
  Call GetSSLFile

  !ifdef INSTALLER
      IfFileExists "$PLUGINSDIR\IO-Socket-SSL.tar.gz" 0 installer_error_exit
      IfFileExists "$PLUGINSDIR\Net_SSLeay.pm.tar.gz" 0 installer_error_exit
      IfFileExists "$PLUGINSDIR\ssleay32.dll" 0 installer_error_exit
      IfFileExists "$PLUGINSDIR\libeay32.dll" 0 installer_error_exit
      StrCmp $G_SSL_ONLY "0" install_SSL_support

      ; The '/SSL' option was supplied so we need to make sure it is safe to install the files

      DetailPrint ""
      SetDetailsPrint both
      DetailPrint "$(PFI_LANG_PROG_CHECKIFRUNNING) $(PFI_LANG_TAKE_SEVERAL_SECONDS)"
      SetDetailsPrint listonly
      DetailPrint ""
      Call MakeRootDirSafe
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

  !ifdef ADDSSL

      ; If the built-in SSL Support files are being used then there is no need to patch SSL.pm

      StrCmp $G_SSL_SOURCE "${C_BUILTIN}" extract_Net_SSLeay_files
  !endif

  ; If IO::Socket::SSL v0.99 (or v0.999 or v1.01) has been downloaded and installed, apply
  ; the patch which downgrades the SSL.pm file to v0.97 to make it compatible with POPFile

  DetailPrint ""
  DetailPrint "$(PFI_LANG_SSLPREPAREPATCH)"

  SetDetailsPrint none
  !ifdef INSTALLER
      File "/oname=$PLUGINSDIR\SSL_pm.pat" "SSL_pm.pat"
  !else
      File "/oname=$PLUGINSDIR\SSL_pm.pat" "..\SSL_pm.pat"
  !endif
  SetDetailsPrint listonly

  DetailPrint ""
  vpatch::vpatchfile "$PLUGINSDIR\SSL_pm.pat" "$G_PLS_FIELD_1\SSL.pm" "$PLUGINSDIR\SSL_v097.pm"
  Pop $G_PLS_FIELD_2

  SetDetailsPrint both
  DetailPrint "$(PFI_LANG_SSLPATCHSTATUS)"
  SetDetailsPrint listonly
  DetailPrint ""

  StrCmp $G_PLS_FIELD_2 "OK" 0 show_downgrade_status
  !insertmacro PFI_BACKUP_123_DP "$G_PLS_FIELD_1" "SSL.pm"
  SetDetailsPrint none
  Rename "$PLUGINSDIR\SSL_v097.pm" "$G_PLS_FIELD_1\SSL.pm"
  IfFileExists "$G_PLS_FIELD_1\SSL.pm" downgrade_success
  Rename "$G_PLS_FIELD_1\SSL.pm.bk1" "$G_PLS_FIELD_1\SSL.pm"
  SetDetailsPrint listonly
  DetailPrint ""
  SetDetailsPrint both
  DetailPrint "$(PFI_LANG_SSLPATCHFAILED)"
  Goto extract_Net_SSLeay_files

downgrade_success:
  SetDetailsPrint listonly
  DetailPrint "$(PFI_LANG_SSLPATCHCOMPLETED)"
  DetailPrint ""

show_downgrade_status:
  !ifdef ADDSSL
      MessageBox MB_OK|MB_ICONEXCLAMATION "$(PFI_LANG_SSLPATCHSTATUS)"
  !endif

extract_Net_SSLeay_files:
  DetailPrint ""
  StrCpy $G_PLS_FIELD_1 "$G_MPLIBDIR\Net"
  CreateDirectory $G_PLS_FIELD_1
  SetDetailsPrint both
  StrCpy $G_PLS_FIELD_2 "Net_SSLeay.pm.tar.gz"
  DetailPrint "$(PFI_LANG_PROG_FILEEXTRACT)"
  SetDetailsPrint listonly
  untgz::extractFile -d "$G_PLS_FIELD_1" "$PLUGINSDIR\Net_SSLeay.pm.tar.gz" "SSLeay.pm"
  StrCmp ${L_RESULT} "success" label_b error_exit

label_b:
  DetailPrint ""
  StrCpy $G_PLS_FIELD_1 "$G_MPLIBDIR\Net\SSLeay"
  CreateDirectory $G_PLS_FIELD_1
  SetDetailsPrint both
  StrCpy $G_PLS_FIELD_2 "Net_SSLeay.pm.tar.gz"
  DetailPrint "$(PFI_LANG_PROG_FILEEXTRACT)"
  SetDetailsPrint listonly
  untgz::extractFile -d "$G_PLS_FIELD_1" "$PLUGINSDIR\Net_SSLeay.pm.tar.gz" "Handle.pm"
  StrCmp ${L_RESULT} "success" label_c error_exit

label_c:
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
      Push $R1    ; No need to preserve $R0 here as it is known as ${L_RESULT} in this 'Section'

      ; The first system call gets the full pathname (returned in $R0) and the second call
      ; extracts the filename (and possibly the extension) part (returned in $R1)

      System::Call 'kernel32::GetModuleFileNameA(i 0, t .R0, i 1024)'
      System::Call 'comdlg32::GetFileTitleA(t R0, t .R1, i 1024)'
      StrCpy $G_PLS_FIELD_1 $R1
      MessageBox MB_OK|MB_ICONEXCLAMATION "$(PFI_LANG_MB_REPEATSSL)"

      Pop $R1
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

  IfFileExists "$G_PLS_FIELD_1\SSLeay.bs" done
  !ifdef INSTALLER
      File "/oname=$G_PLS_FIELD_1\SSLeay.bs" "zerobyte.file"
  !else
      File "/oname=$G_PLS_FIELD_1\SSLeay.bs" "..\zerobyte.file"
  !endif

done:
  DetailPrint ""

  !ifdef INSTALLER
    exit:
      SetDetailsPrint textonly
      DetailPrint "$(PFI_LANG_INST_PROG_ENDSEC)"
      SetDetailsPrint listonly
      !insertmacro SECTIONLOG_EXIT "SSL Support"
  !endif

  Pop ${L_RESULT}

  !undef L_RESULT

SectionEnd


#--------------------------------------------------------------------------
# Installer Function: GetSSLFile
#
# Inputs:
#         (top of stack)     - full URL used to download the SSL file
# Outputs:
#         none
#--------------------------------------------------------------------------

  !define C_NSISDL_TRANSLATIONS "/TRANSLATE '$(PFI_LANG_NSISDL_DOWNLOADING)' '$(PFI_LANG_NSISDL_CONNECTING)' '$(PFI_LANG_NSISDL_SECOND)' '$(PFI_LANG_NSISDL_MINUTE)' '$(PFI_LANG_NSISDL_HOUR)' '$(PFI_LANG_NSISDL_PLURAL)' '$(PFI_LANG_NSISDL_PROGRESS)' '$(PFI_LANG_NSISDL_REMAINING)'"

Function GetSSLFile

  Pop $G_SSL_FILEURL

  !define L_DLG_ITEM  $R9

  Push ${L_DLG_ITEM}

  StrCpy $G_PLS_FIELD_1 $G_SSL_FILEURL
  Push $G_PLS_FIELD_1
  Call PFI_StrBackSlash
  Call PFI_GetParent
  Pop $G_PLS_FIELD_2
  StrLen $G_PLS_FIELD_2 $G_PLS_FIELD_2
  IntOp $G_PLS_FIELD_2 $G_PLS_FIELD_2 + 1
  StrCpy $G_PLS_FIELD_1 "$G_PLS_FIELD_1" "" $G_PLS_FIELD_2
  StrCpy $G_PLS_FIELD_2 "$G_SSL_FILEURL" $G_PLS_FIELD_2
  DetailPrint ""
  DetailPrint "$(PFI_LANG_PROG_STARTDOWNLOAD)"

  ; The current version of the Inetc plugin (dated 8 September 2006) leaves the "Show Details"
  ; button in view so we temporarily disable it during the download to avoid a messy display
  ; (if the user has already clicked the button then they'll just need to put up with the mess)

  FindWindow ${L_DLG_ITEM} "#32770" "" $HWNDPARENT
  GetDlgItem ${L_DLG_ITEM} ${L_DLG_ITEM} 0x403
  EnableWindow ${L_DLG_ITEM} 0

  inetc::get /CAPTION "Internet Download" /RESUME "$(PFI_LANG_MB_CHECKINTERNET)" ${C_NSISDL_TRANSLATIONS} "$G_SSL_FILEURL" "$PLUGINSDIR\$G_PLS_FIELD_1" /END
  Pop $G_PLS_FIELD_2

  ; Enable the "Show Details" button now that the download has been completed

  EnableWindow ${L_DLG_ITEM} 1

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
  Pop ${L_DLG_ITEM}

  !undef L_DLG_ITEM

FunctionEnd


#--------------------------------------------------------------------------
# End of 'getssl.nsh'
#--------------------------------------------------------------------------
