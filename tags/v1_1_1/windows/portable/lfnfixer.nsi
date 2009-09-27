#--------------------------------------------------------------------------
#
# lfnfixer.nsi --- This NSIS script is used to create a simple utility which ensures
#                  the portable version of POPFile will run on Win9x systems if the
#                  installer was run on a more modern system such as Vista.
#
# Copyright (c) 2009  John Graham-Cumming
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
          $\r$\n***   This script has only been tested using the NSIS \
          ${C_EXPECTED_VERSION} compiler\
          $\r$\n***   and may not work properly with this NSIS ${NSIS_VERSION} \
          compiler\
          $\r$\n***\
          $\r$\n***   The resulting 'installer' program should be tested \
          carefully!\
          $\r$\n$\r$\n"
  !endif

  !undef  ${NSIS_VERSION}_found
  !undef  C_EXPECTED_VERSION

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

  !define C_VERSION             "0.0.24"

  !define C_OUTFILE             "lfnfixer.exe"

  ;--------------------------------------------------------------------------
  ; The default NSIS caption is "$(^Name) Setup" so we override it here
  ;--------------------------------------------------------------------------

  Name    "POPFilePortable LFN Fixer"
  Caption "$(^Name) v${C_VERSION}"
  SubCaption 3 ": Processing"

  ;--------------------------------------------------------------------------
  ; Windows Vista expects to find a manifest specifying the execution level
  ;--------------------------------------------------------------------------

  RequestExecutionLevel   user

#--------------------------------------------------------------------------
# Include library functions and macro definitions
#--------------------------------------------------------------------------

  ; Avoid compiler warnings by disabling the functions and definitions we do not use

  !define LFNFIXER

  !include "ppl-library.nsh"

  !include "nsis-library.nsh"

#--------------------------------------------------------------------------
# Version Information settings (for the utility's EXE file)
#--------------------------------------------------------------------------

  ; 'VIProductVersion' format is X.X.X.X where X is a number in range 0 to 65535
  ; representing the following values: Major.Minor.Release.Build

  VIProductVersion                          "${C_VERSION}.0"

  !define /date C_BUILD_YEAR                "%Y"

  VIAddVersionKey "ProductName"             "POPFilePortable LFN Fixer Utility"
  VIAddVersionKey "Comments"                "POPFile Homepage: http://getpopfile.org/"
  VIAddVersionKey "CompanyName"             "The POPFile Project"
  VIAddVersionKey "LegalTrademarks"         "POPFile is a registered trademark of John Graham-Cumming"
  VIAddVersionKey "LegalCopyright"          "Copyright (c) ${C_BUILD_YEAR} John Graham-Cumming"
  VIAddVersionKey "FileDescription"         "Helps make POPFilePortable run on Win9x systems"
  VIAddVersionKey "FileVersion"             "${C_VERSION}"
  VIAddVersionKey "OriginalFilename"        "${C_OUTFILE}"

  VIAddVersionKey "Build Compiler"          "NSIS ${NSIS_VERSION}"
  VIAddVersionKey "Build Date/Time"         "${__DATE__} @ ${__TIME__}"
  !ifdef C_PPL_LIBRARY_VERSION
    VIAddVersionKey "PPL Library Version"   "${C_PPL_LIBRARY_VERSION}"
  !endif
  VIAddVersionKey "Build Script"            "${__FILE__}${MB_NL}(${__TIMESTAMP__})"

#--------------------------------------------------------------------------
# User Registers (Global)
#--------------------------------------------------------------------------

  ; This script uses 'User Variables' (with names starting with 'G_') to hold GLOBAL data.

  Var G_ROOTDIR

  ;----------------------------------------------------------------
  ;  Interface Settings - Interface Resource Settings
  ;----------------------------------------------------------------

  ; Use a small window for this utility

  ChangeUI all "${NSISDIR}\Contrib\UIs\sdbarker_tiny.exe"

  Icon "..\POPFileIcon\popfile.ico"

  AutoCloseWindow true

#--------------------------------------------------------------------------
# General settings
#--------------------------------------------------------------------------

  ; Specify EXE filename and icon for the utility

  OutFile "${C_OUTFILE}"

  ; Ensure user cannot use the /NCRC command-line switch to disable CRC checking

  CRCcheck Force

;--------------------------------------------------------------------------
; Section: default
;--------------------------------------------------------------------------

Section default

  !define L_COUNT         $R9
  !define L_TEMP          $R8

  SetDetailsPrint textonly
  DetailPrint "Adjusting folder and file names for Win9x..."
  SetDetailsPrint listonly

  ; Based upon a full installation of POPFile 1.1.1 RC5 including SSL Support and all
  ; three Nihongo parsers: internal, Kakasi and MeCab

  DetailPrint "------------------------------------------------------------"
  DetailPrint "$(^Name) v${C_VERSION}"
  DetailPrint "Intended for use with the portable version of POPFile 1.1.1"
  DetailPrint "------------------------------------------------------------"
  Call PPL_GetDateTimeStamp
  Pop ${L_TEMP}
  DetailPrint "(report started ${L_TEMP})"
  DetailPrint "------------------------------------------------------------"

  StrCpy $G_ROOTDIR $EXEDIR

  DetailPrint "POPFILE_ROOT = $G_ROOTDIR"
  DetailPrint "------------------------------------------------------------"

  StrCpy ${L_COUNT} 0

  !macro SFN2LFN SFN_FORMAT LFN_FORMAT

      !insertmacro PPL_UNIQUE_ID

      IfFileExists "$G_ROOTDIR\${SFN_FORMAT}" adjust_${PPL_UNIQUE_ID}
      DetailPrint "${LFN_FORMAT} not found"
      Goto continue_${PPL_UNIQUE_ID}

    adjust_${PPL_UNIQUE_ID}:
      IntOp ${L_COUNT} ${L_COUNT} + 1
      SetDetailsPrint none
      Rename "$G_ROOTDIR\${SFN_FORMAT}" "$G_ROOTDIR\${LFN_FORMAT}"
      SetDetailsPrint listonly
      DetailPrint "LFN fix applied to ${LFN_FORMAT}"

    continue_${PPL_UNIQUE_ID}:
  !macroend

  !insertmacro SFN2LFN  "BAYES.PL"                                  "bayes.pl"
  !insertmacro SFN2LFN  "FAVICON.ICO"                               "favicon.ico"
  !insertmacro SFN2LFN  "INSERT.PL"                                 "insert.pl"
  !insertmacro SFN2LFN  "LFNFIXER.EXE"                              "lfnfixer.exe"
  !insertmacro SFN2LFN  "LICENSE"                                   "license"
  !insertmacro SFN2LFN  "OTTO.PNG"                                  "otto.png"
  !insertmacro SFN2LFN  "PERL.EXE"                                  "perl.exe"
  !insertmacro SFN2LFN  "PERL58.DLL"                                "perl58.dll"
  !insertmacro SFN2LFN  "PIPE.PL"                                   "pipe.pl"
  !insertmacro SFN2LFN  "PIX.GIF"                                   "pix.gif"
  !insertmacro SFN2LFN  "POPFILE.PCK"                               "popfile.pck"
  !insertmacro SFN2LFN  "POPFILE.PL"                                "popfile.pl"
  !insertmacro SFN2LFN  "POPFILEB.EXE"                              "popfileb.exe"
  !insertmacro SFN2LFN  "POPFILEF.EXE"                              "popfilef.exe"
  !insertmacro SFN2LFN  "SQLITE.EXE"                                "sqlite.exe"
  !insertmacro SFN2LFN  "SQLITE3.EXE"                               "sqlite3.exe"
  !insertmacro SFN2LFN  "STOP_PF.EXE"                               "stop_pf.exe"
  !insertmacro SFN2LFN  "TRAYICON.ICO"                              "trayicon.ico"
  !insertmacro SFN2LFN  "WPERL.EXE"                                 "wperl.exe"

  !insertmacro SFN2LFN  "Classifier\POPFILE.SQL"                    "Classifier\popfile.sql"

  !insertmacro SFN2LFN  "KAKASI"                                    "kakasi"
  !insertmacro SFN2LFN  "KAKASI\BIN"                                "kakasi\bin"
  !insertmacro SFN2LFN  "KAKASI\BIN\KAKASI.EXE"                     "kakasi\bin\kakasi.exe"
  !insertmacro SFN2LFN  "KAKASI\BIN\MKKANWA.EXE"                    "kakasi\bin\mkkanwa.exe"
  !insertmacro SFN2LFN  "KAKASI\BIN\WX2_CONV.EXE"                   "kakasi\bin\wx2_conv.exe"
  !insertmacro SFN2LFN  "KAKASI\DOC"                                "kakasi\doc"
  !insertmacro SFN2LFN  "KAKASI\DOC\KAKASI.1"                       "kakasi\doc\kakasi.1"
  !insertmacro SFN2LFN  "KAKASI\DOC\KAKASI.CAT"                     "kakasi\doc\kakasi.cat"
  !insertmacro SFN2LFN  "KAKASI\DOC\README.LIB"                     "kakasi\doc\README.lib"
  !insertmacro SFN2LFN  "KAKASI\INCLUDE"                            "kakasi\include"
  !insertmacro SFN2LFN  "KAKASI\LIB"                                "kakasi\lib"
  !insertmacro SFN2LFN  "KAKASI\LIB\KAKASI.DLL"                     "kakasi\lib\kakasi.dll"
  !insertmacro SFN2LFN  "KAKASI\LIB\KAKASI.LIB"                     "kakasi\lib\kakasi.lib"
  !insertmacro SFN2LFN  "KAKASI\SHARE"                              "kakasi\share"
  !insertmacro SFN2LFN  "KAKASI\SHARE\KAKASI"                       "kakasi\share\kakasi"

  !insertmacro SFN2LFN  "LIB"                                       "lib"
  !insertmacro SFN2LFN  "LIB\BASE.PM"                               "lib\base.pm"
  !insertmacro SFN2LFN  "LIB\BYTES.PM"                              "lib\bytes.pm"
  !insertmacro SFN2LFN  "LIB\CONSTANT.PM"                           "lib\constant.pm"
  !insertmacro SFN2LFN  "LIB\DBI.PM"                                "lib\DBI.pm"
  !insertmacro SFN2LFN  "LIB\INTEGER.PM"                            "lib\integer.pm"
  !insertmacro SFN2LFN  "LIB\IO.PM"                                 "lib\IO.pm"
  !insertmacro SFN2LFN  "LIB\LIB.PM"                                "lib\lib.pm"
  !insertmacro SFN2LFN  "LIB\LOCALE.PM"                             "lib\locale.pm"
  !insertmacro SFN2LFN  "LIB\LWP.PM"                                "lib\LWP.pm"
  !insertmacro SFN2LFN  "LIB\OVERLOAD.PM"                           "lib\overload.pm"
  !insertmacro SFN2LFN  "LIB\POSIX.PM"                              "lib\POSIX.pm"
  !insertmacro SFN2LFN  "LIB\RE.PM"                                 "lib\re.pm"
  !insertmacro SFN2LFN  "LIB\STRICT.PM"                             "lib\strict.pm"
  !insertmacro SFN2LFN  "LIB\URI.PM"                                "lib\URI.pm"
  !insertmacro SFN2LFN  "LIB\UTF8.PM"                               "lib\utf8.pm"
  !insertmacro SFN2LFN  "LIB\VARS.PM"                               "lib\vars.pm"
  !insertmacro SFN2LFN  "LIB\WARNINGS.PM"                           "lib\warnings.pm"

  !insertmacro SFN2LFN  "LIB\AUTO"                                  "lib\auto"
  !insertmacro SFN2LFN  "LIB\AUTO\DBI\DBI.BS"                       "lib\auto\DBI\DBI.bs"
  !insertmacro SFN2LFN  "LIB\AUTO\DBI\DBI.BS"                       "lib\auto\DBI\DBI.bs"
  !insertmacro SFN2LFN  "LIB\AUTO\DBI\DBI.DLL"                      "lib\auto\DBI\DBI.dll"
  !insertmacro SFN2LFN  "LIB\AUTO\DBI\DBI.EXP"                      "lib\auto\DBI\DBI.exp"
  !insertmacro SFN2LFN  "LIB\AUTO\DBI\DBI.LIB"                      "lib\auto\DBI\DBI.lib"

  !insertmacro SFN2LFN  "LIB\AUTO\Digest\MD5\MD5.DLL"               "lib\auto\Digest\MD5\MD5.dll"

  !insertmacro SFN2LFN  "LIB\AUTO\Encode\CN\CN.DLL"                 "lib\auto\Encode\CN\CN.dll"
  !insertmacro SFN2LFN  "LIB\AUTO\Encode\EBCDIC\EBCDIC.DLL"         "lib\auto\Encode\EBCDIC\EBCDIC.dll"
  !insertmacro SFN2LFN  "LIB\AUTO\Encode\JP\JP.DLL"                 "lib\auto\Encode\JP\JP.dll"
  !insertmacro SFN2LFN  "LIB\AUTO\Encode\KR\KR.DLL"                 "lib\auto\Encode\KR\KR.dll"
  !insertmacro SFN2LFN  "LIB\AUTO\Encode\TW\TW.DLL"                 "lib\auto\Encode\TW\TW.dll"

  !insertmacro SFN2LFN  "LIB\AUTO\IO\IO.DLL"                        "lib\auto\IO\IO.dll"

  !insertmacro SFN2LFN  "LIB\AUTO\Net\SSLeay\DO_HTTPS.AL"           "lib\auto\Net\SSLeay\do_https.al"
  !insertmacro SFN2LFN  "LIB\AUTO\Net\SSLeay\GET_HTTP.AL"           "lib\auto\Net\SSLeay\get_http.al"
  !insertmacro SFN2LFN  "LIB\AUTO\Net\SSLeay\HTTP_CAT.AL"           "lib\auto\Net\SSLeay\http_cat.al"
  !insertmacro SFN2LFN  "LIB\AUTO\Net\SSLeay\LIBEAY32.DLL"          "lib\auto\Net\SSLeay\libeay32.dll"
  !insertmacro SFN2LFN  "LIB\AUTO\Net\SSLeay\PUT_HTTP.AL"           "lib\auto\Net\SSLeay\put_http.al"
  !insertmacro SFN2LFN  "LIB\AUTO\Net\SSLeay\SSLCAT.AL"             "lib\auto\Net\SSLeay\sslcat.al"
  !insertmacro SFN2LFN  "LIB\AUTO\Net\SSLeay\SSLEAY32.DLL"          "lib\auto\Net\SSLeay\ssleay32.dll"
  !insertmacro SFN2LFN  "LIB\AUTO\Net\SSLeay\TCPCAT.AL"             "lib\auto\Net\SSLeay\tcpcat.al"
  !insertmacro SFN2LFN  "LIB\AUTO\Net\SSLeay\TCPXCAT.AL"            "lib\auto\Net\SSLeay\tcpxcat.al"

  !insertmacro SFN2LFN  "LIB\AUTO\POSIX\POSIX.DLL"                  "lib\auto\POSIX\POSIX.dll"

  !insertmacro SFN2LFN  "LIB\AUTO\Win32\API\API.DLL"                "lib\auto\Win32\API\API.dll"

  !insertmacro SFN2LFN  "LIB\AUTO\Win32\GUI\GUI.BS"                 "lib\auto\Win32\GUI\GUI.bs"
  !insertmacro SFN2LFN  "LIB\AUTO\Win32\GUI\GUI.DLL"                "lib\auto\Win32\GUI\GUI.dll"
  !insertmacro SFN2LFN  "LIB\AUTO\Win32\GUI\GUI.EXP"                "lib\auto\Win32\GUI\GUI.exp"
  !insertmacro SFN2LFN  "LIB\AUTO\Win32\GUI\GUI.LIB"                "lib\auto\Win32\GUI\GUI.lib"

  !insertmacro SFN2LFN  "LIB\Digest\MD5.PM"                         "lib\Digest\MD5.pm"

  !insertmacro SFN2LFN  "LIB\Encode\_PM.E2X"                        "lib\Encode\_PM.e2x"
  !insertmacro SFN2LFN  "LIB\Encode\_T.E2X"                         "lib\Encode\_T.e2x"
  !insertmacro SFN2LFN  "LIB\Encode\CN.PM"                          "lib\Encode\CN.pm"
  !insertmacro SFN2LFN  "LIB\Encode\CN\HZ.PM"                       "lib\Encode\CN\HZ.pm"
  !insertmacro SFN2LFN  "LIB\Encode\EBCDIC.PM"                      "lib\Encode\EBCDIC.pm"
  !insertmacro SFN2LFN  "LIB\Encode\ENCODE.H"                       "lib\Encode\encode.h"
  !insertmacro SFN2LFN  "LIB\Encode\GSM0338.PM"                     "lib\Encode\GSM0338.pm"
  !insertmacro SFN2LFN  "LIB\Encode\JP.PM"                          "lib\Encode\JP.pm"
  !insertmacro SFN2LFN  "LIB\Encode\JP\H2Z.PM"                      "lib\Encode\JP\H2Z.pm"
  !insertmacro SFN2LFN  "LIB\Encode\JP\JIS7.PM"                     "lib\Encode\JP\JIS7.pm"
  !insertmacro SFN2LFN  "LIB\Encode\KR.PM"                          "lib\Encode\KR.pm"
  !insertmacro SFN2LFN  "LIB\Encode\KR\2022_KR.PM"                  "lib\Encode\KR\2022_KR.pm"
  !insertmacro SFN2LFN  "LIB\Encode\README.E2X"                     "lib\Encode\README.e2x"
  !insertmacro SFN2LFN  "LIB\Encode\TW.PM"                          "lib\Encode\TW.pm"
  !insertmacro SFN2LFN  "LIB\Encode\Unicode\UTF7.PM"                "lib\Encode\Unicode\UTF7.pm"

  !insertmacro SFN2LFN  "LIB\IO\Socket\INET.PM"                     "lib\IO\Socket\INET.pm"
  !insertmacro SFN2LFN  "LIB\IO\Socket\SSL.PM"                      "lib\IO\Socket\SSL.pm"
  !insertmacro SFN2LFN  "LIB\IO\Socket\UNIX.PM"                     "lib\IO\Socket\UNIX.pm"

  !insertmacro SFN2LFN  "LIB\LWP\Protocol\CPAN.PM"                  "lib\LWP\Protocol\cpan.pm"
  !insertmacro SFN2LFN  "LIB\LWP\Protocol\DATA.PM"                  "lib\LWP\Protocol\data.pm"
  !insertmacro SFN2LFN  "LIB\LWP\Protocol\FILE.PM"                  "lib\LWP\Protocol\file.pm"
  !insertmacro SFN2LFN  "LIB\LWP\Protocol\FTP.PM"                   "lib\LWP\Protocol\ftp.pm"
  !insertmacro SFN2LFN  "LIB\LWP\Protocol\GHTTP.PM"                 "lib\LWP\Protocol\GHTTP.pm"
  !insertmacro SFN2LFN  "LIB\LWP\Protocol\GOPHER.PM"                "lib\LWP\Protocol\gopher.pm"
  !insertmacro SFN2LFN  "LIB\LWP\Protocol\HTTP.PM"                  "lib\LWP\Protocol\http.pm"
  !insertmacro SFN2LFN  "LIB\LWP\Protocol\HTTP10.PM"                "lib\LWP\Protocol\http10.pm"
  !insertmacro SFN2LFN  "LIB\LWP\Protocol\HTTPS.PM"                 "lib\LWP\Protocol\https.pm"
  !insertmacro SFN2LFN  "LIB\LWP\Protocol\HTTPS10.PM"               "lib\LWP\Protocol\https10.pm"
  !insertmacro SFN2LFN  "LIB\LWP\Protocol\LOOPBACK.PM"              "lib\LWP\Protocol\loopback.pm"
  !insertmacro SFN2LFN  "LIB\LWP\Protocol\MAILTO.PM"                "lib\LWP\Protocol\mailto.pm"
  !insertmacro SFN2LFN  "LIB\LWP\Protocol\NNTP.PM"                  "lib\LWP\Protocol\nntp.pm"
  !insertmacro SFN2LFN  "LIB\LWP\Protocol\NOGO.PM"                  "lib\LWP\Protocol\nogo.pm"

  !insertmacro SFN2LFN  "LIB\Net\HTTP.PM"                           "lib\Net\HTTP.pm"
  !insertmacro SFN2LFN  "LIB\Net\HTTP\NB.PM"                        "lib\Net\HTTP\NB.pm"
  !insertmacro SFN2LFN  "LIB\Net\HTTPS.PM"                          "lib\Net\HTTPS.pm"

  !insertmacro SFN2LFN  "LIB\SOAP\Transport\FTP.PM"                 "lib\SOAP\Transport\FTP.pm"
  !insertmacro SFN2LFN  "LIB\SOAP\Transport\HTTP.PM"                "lib\SOAP\Transport\HTTP.pm"
  !insertmacro SFN2LFN  "LIB\SOAP\Transport\IO.PM"                  "lib\SOAP\Transport\IO.pm"
  !insertmacro SFN2LFN  "LIB\SOAP\Transport\JABBER.PM"              "lib\SOAP\Transport\JABBER.pm"
  !insertmacro SFN2LFN  "LIB\SOAP\Transport\LOCAL.PM"               "lib\SOAP\Transport\LOCAL.pm"
  !insertmacro SFN2LFN  "LIB\SOAP\Transport\MAILTO.PM"              "lib\SOAP\Transport\MAILTO.pm"
  !insertmacro SFN2LFN  "LIB\SOAP\Transport\MQ.PM"                  "lib\SOAP\Transport\MQ.pm"
  !insertmacro SFN2LFN  "LIB\SOAP\Transport\POP3.PM"                "lib\SOAP\Transport\POP3.pm"
  !insertmacro SFN2LFN  "LIB\SOAP\Transport\TCP.PM"                 "lib\SOAP\Transport\TCP.pm"

  !insertmacro SFN2LFN  "LIB\Time\GMTIME.PM"                        "lib\Time\gmtime.pm"
  !insertmacro SFN2LFN  "LIB\Time\TM.PM"                            "lib\Time\tm.pm"

  !insertmacro SFN2LFN  "LIB\UNICORE"                               "lib\unicore"
  !insertmacro SFN2LFN  "LIB\UNICORE\PVA.PL"                        "lib\unicore\PVA.pl"
  !insertmacro SFN2LFN  "LIB\UNICORE\LIB"                           "lib\unicore\lib"
  !insertmacro SFN2LFN  "LIB\UNICORE\LIB\GC_SC"                     "lib\unicore\lib\gc_sc"

  !insertmacro SFN2LFN  "LIB\URI\FILE"                              "lib\URI\file"
  !insertmacro SFN2LFN  "LIB\URI\URN"                               "lib\URI\urn"
  !insertmacro SFN2LFN  "LIB\URI\_FOREIGN.PM"                       "lib\URI\_foreign.pm"
  !insertmacro SFN2LFN  "LIB\URI\_GENERIC.PM"                       "lib\URI\_generic.pm"
  !insertmacro SFN2LFN  "LIB\URI\_LDAP.PM"                          "lib\URI\_ldap.pm"
  !insertmacro SFN2LFN  "LIB\URI\_LOGIN.PM"                         "lib\URI\_login.pm"
  !insertmacro SFN2LFN  "LIB\URI\_QUERY.PM"                         "lib\URI\_query.pm"
  !insertmacro SFN2LFN  "LIB\URI\_SEGMENT.PM"                       "lib\URI\_segment.pm"
  !insertmacro SFN2LFN  "LIB\URI\_SERVER.PM"                        "lib\URI\_server.pm"
  !insertmacro SFN2LFN  "LIB\URI\DATA.PM"                           "lib\URI\data.pm"
  !insertmacro SFN2LFN  "LIB\URI\FILE.PM"                           "lib\URI\file.pm"
  !insertmacro SFN2LFN  "LIB\URI\file\FAT.PM"                       "lib\URI\file\FAT.pm"
  !insertmacro SFN2LFN  "LIB\URI\file\OS2.PM"                       "lib\URI\file\OS2.pm"
  !insertmacro SFN2LFN  "LIB\URI\file\QNX.PM"                       "lib\URI\file\QNX.pm"
  !insertmacro SFN2LFN  "LIB\URI\FTP.PM"                            "lib\URI\ftp.pm"
  !insertmacro SFN2LFN  "LIB\URI\GOPHER.PM"                         "lib\URI\gopher.pm"
  !insertmacro SFN2LFN  "LIB\URI\HTTP.PM"                           "lib\URI\http.pm"
  !insertmacro SFN2LFN  "LIB\URI\HTTPS.PM"                          "lib\URI\https.pm"
  !insertmacro SFN2LFN  "LIB\URI\LDAP.PM"                           "lib\URI\ldap.pm"
  !insertmacro SFN2LFN  "LIB\URI\LDAPI.PM"                          "lib\URI\ldapi.pm"
  !insertmacro SFN2LFN  "LIB\URI\LDAPS.PM"                          "lib\URI\ldaps.pm"
  !insertmacro SFN2LFN  "LIB\URI\MAILTO.PM"                         "lib\URI\mailto.pm"
  !insertmacro SFN2LFN  "LIB\URI\MMS.PM"                            "lib\URI\mms.pm"
  !insertmacro SFN2LFN  "LIB\URI\NEWS.PM"                           "lib\URI\news.pm"
  !insertmacro SFN2LFN  "LIB\URI\NNTP.PM"                           "lib\URI\nntp.pm"
  !insertmacro SFN2LFN  "LIB\URI\POP.PM"                            "lib\URI\pop.pm"
  !insertmacro SFN2LFN  "LIB\URI\RLOGIN.PM"                         "lib\URI\rlogin.pm"
  !insertmacro SFN2LFN  "LIB\URI\RSYNC.PM"                          "lib\URI\rsync.pm"
  !insertmacro SFN2LFN  "LIB\URI\RTSP.PM"                           "lib\URI\rtsp.pm"
  !insertmacro SFN2LFN  "LIB\URI\RTSPU.PM"                          "lib\URI\rtspu.pm"
  !insertmacro SFN2LFN  "LIB\URI\SIP.PM"                            "lib\URI\sip.pm"
  !insertmacro SFN2LFN  "LIB\URI\SIPS.PM"                           "lib\URI\sips.pm"
  !insertmacro SFN2LFN  "LIB\URI\SNEWS.PM"                          "lib\URI\snews.pm"
  !insertmacro SFN2LFN  "LIB\URI\SSH.PM"                            "lib\URI\ssh.pm"
  !insertmacro SFN2LFN  "LIB\URI\TELNET.PM"                         "lib\URI\telnet.pm"
  !insertmacro SFN2LFN  "LIB\URI\TN3270.PM"                         "lib\URI\tn3270.pm"
  !insertmacro SFN2LFN  "LIB\URI\URL.PM"                            "lib\URI\URL.pm"
  !insertmacro SFN2LFN  "LIB\URI\URN.PM"                            "lib\URI\urn.pm"
  !insertmacro SFN2LFN  "LIB\URI\urn\ISBN.PM"                       "lib\URI\urn\isbn.pm"
  !insertmacro SFN2LFN  "LIB\URI\urn\OID.PM"                        "lib\URI\urn\oid.pm"

  !insertmacro SFN2LFN  "LIB\WARNINGS"                              "lib\warnings"
  !insertmacro SFN2LFN  "LIB\WARNINGS\REGISTER.PM"                  "lib\warnings\register.pm"

  !insertmacro SFN2LFN  "LIB\Win32\API.PM"                          "lib\Win32\API.pm"
  !insertmacro SFN2LFN  "LIB\Win32\GUI.PM"                          "lib\Win32\GUI.pm"

  !insertmacro SFN2LFN  "LIB\XML\Parser\Encodings\BIG5.ENC"         "lib\XML\Parser\Encodings\big5.enc"
  !insertmacro SFN2LFN  "LIB\XML\Parser\Encodings\EUC-KR.ENC"       "lib\XML\Parser\Encodings\euc-kr.enc"
  !insertmacro SFN2LFN  "LIB\XML\Simple\FAQ.POD"                    "lib\XML\Simple\FAQ.pod"

  !insertmacro SFN2LFN  "LIB\XMLRPC\Transport\HTTP.PM"              "lib\XMLRPC\Transport\HTTP.pm"
  !insertmacro SFN2LFN  "LIB\XMLRPC\Transport\POP3.PM"              "lib\XMLRPC\Transport\POP3.pm"
  !insertmacro SFN2LFN  "LIB\XMLRPC\Transport\TCP.PM"               "lib\XMLRPC\Transport\TCP.pm"

  !insertmacro SFN2LFN  "MECAB"                                     "mecab"
  !insertmacro SFN2LFN  "MECAB\DIC"                                 "mecab\dic"
  !insertmacro SFN2LFN  "MECAB\DIC\IPADIC"                          "mecab\dic\ipadic"
  !insertmacro SFN2LFN  "MECAB\DIC\IPADIC\CHAR.BIN"                 "mecab\dic\ipadic\char.bin"
  !insertmacro SFN2LFN  "MECAB\DIC\IPADIC\DICRC"                    "mecab\dic\ipadic\dicrc"
  !insertmacro SFN2LFN  "MECAB\DIC\IPADIC\LEFT-ID.DEF"              "mecab\dic\ipadic\left-id.def"
  !insertmacro SFN2LFN  "MECAB\DIC\IPADIC\MATRIX.BIN"               "mecab\dic\ipadic\matrix.bin"
  !insertmacro SFN2LFN  "MECAB\DIC\IPADIC\POS-ID.DEF"               "mecab\dic\ipadic\pos-id.def"
  !insertmacro SFN2LFN  "MECAB\DIC\IPADIC\REWRITE.DEF"              "mecab\dic\ipadic\rewrite.def"
  !insertmacro SFN2LFN  "MECAB\DIC\IPADIC\RIGHT-ID.DEF"             "mecab\dic\ipadic\right-id.def"
  !insertmacro SFN2LFN  "MECAB\DIC\IPADIC\SYS.DIC"                  "mecab\dic\ipadic\sys.dic"
  !insertmacro SFN2LFN  "MECAB\DIC\IPADIC\UNK.DIC"                  "mecab\dic\ipadic\unk.dic"
  !insertmacro SFN2LFN  "MECAB\DIC\SRC"                             "mecab\dic\src"
  !insertmacro SFN2LFN  "MECAB\DOC"                                 "mecab\doc"
  !insertmacro SFN2LFN  "MECAB\DOC\FEATURE.PNG"                     "mecab\doc\feature.png"
  !insertmacro SFN2LFN  "MECAB\DOC\FLOW.PNG"                        "mecab\doc\flow.png"
  !insertmacro SFN2LFN  "MECAB\DOC\MECAB.CSS"                       "mecab\doc\mecab.css"
  !insertmacro SFN2LFN  "MECAB\DOC\RESULT.PNG"                      "mecab\doc\result.png"
  !insertmacro SFN2LFN  "MECAB\DOC\EN"                              "mecab\doc\en"
  !insertmacro SFN2LFN  "MECAB\ETC"                                 "mecab\etc"
  !insertmacro SFN2LFN  "MECAB\ETC\MECABRC"                         "mecab\etc\mecabrc"
  !insertmacro SFN2LFN  "MECAB\MAN"                                 "mecab\man"
  !insertmacro SFN2LFN  "MECAB\MAN\MECAB.1"                         "mecab\man\mecab.1"

  !insertmacro SFN2LFN  "POPFile\API.PM"                            "POPFile\API.pm"
  !insertmacro SFN2LFN  "POPFile\MQ.PM"                             "POPFile\MQ.pm"

  !insertmacro SFN2LFN  "Proxy\NNTP.PM"                             "Proxy\NNTP.pm"
  !insertmacro SFN2LFN  "Proxy\POP3.PM"                             "Proxy\POP3.pm"
  !insertmacro SFN2LFN  "Proxy\SMTP.PM"                             "Proxy\SMTP.pm"

  !insertmacro SFN2LFN  "Services\IMAP.PM"                          "Services\IMAP.pm"

  !insertmacro SFN2LFN  "SKINS"                                     "skins"
  !insertmacro SFN2LFN  "SKINS\BLUE"                                "skins\blue"
  !insertmacro SFN2LFN  "SKINS\BLUE\STYLE.CSS"                      "skins\blue\style.css"
  !insertmacro SFN2LFN  "SKINS\COOLBLUE"                            "skins\coolblue"
  !insertmacro SFN2LFN  "SKINS\COOLBLUE\STYLE.CSS"                  "skins\coolblue\style.css"
  !insertmacro SFN2LFN  "SKINS\coolbrown\STYLE.CSS"                 "skins\coolbrown\style.css"
  !insertmacro SFN2LFN  "SKINS\coolgreen\STYLE.CSS"                 "skins\coolgreen\style.css"
  !insertmacro SFN2LFN  "SKINS\COOLMINT"                            "skins\coolmint"
  !insertmacro SFN2LFN  "SKINS\COOLMINT\STYLE.CSS"                  "skins\coolmint\style.css"
  !insertmacro SFN2LFN  "SKINS\coolorange\STYLE.CSS"                "skins\coolorange\style.css"
  !insertmacro SFN2LFN  "SKINS\coolyellow\STYLE.CSS"                "skins\coolyellow\style.css"
  !insertmacro SFN2LFN  "SKINS\DEFAULT"                             "skins\default"
  !insertmacro SFN2LFN  "SKINS\DEFAULT\MAGNET.PNG"                  "skins\default\magnet.png"
  !insertmacro SFN2LFN  "SKINS\DEFAULT\STYLE.CSS"                   "skins\default\style.css"
  !insertmacro SFN2LFN  "SKINS\glassblue\STYLE.CSS"                 "skins\glassblue\style.css"
  !insertmacro SFN2LFN  "SKINS\GREEN"                               "skins\green"
  !insertmacro SFN2LFN  "SKINS\GREEN\STYLE.CSS"                     "skins\green\style.css"
  !insertmacro SFN2LFN  "SKINS\LAVISH"                              "skins\lavish"
  !insertmacro SFN2LFN  "SKINS\LAVISH\BOTTOM.GIF"                   "skins\lavish\bottom.gif"
  !insertmacro SFN2LFN  "SKINS\LAVISH\LEFT.GIF"                     "skins\lavish\left.gif"
  !insertmacro SFN2LFN  "SKINS\LAVISH\RIGHT.GIF"                    "skins\lavish\right.gif"
  !insertmacro SFN2LFN  "SKINS\LAVISH\STYLE.CSS"                    "skins\lavish\style.css"
  !insertmacro SFN2LFN  "SKINS\LAVISH\TOP.GIF"                      "skins\lavish\top.gif"
  !insertmacro SFN2LFN  "SKINS\OCEAN"                               "skins\ocean"
  !insertmacro SFN2LFN  "SKINS\OCEAN\STYLE.CSS"                     "skins\ocean\style.css"
  !insertmacro SFN2LFN  "SKINS\oceanblue\IE6.CSS"                   "skins\oceanblue\ie6.css"
  !insertmacro SFN2LFN  "SKINS\oceanblue\STYLE.CSS"                 "skins\oceanblue\style.css"
  !insertmacro SFN2LFN  "SKINS\ORANGE"                              "skins\orange"
  !insertmacro SFN2LFN  "SKINS\ORANGE\STYLE.CSS"                    "skins\orange\style.css"
  !insertmacro SFN2LFN  "SKINS\orangecream\STYLE.CSS"               "skins\orangecream\style.css"
  !insertmacro SFN2LFN  "SKINS\OSX"                                 "skins\osx"
  !insertmacro SFN2LFN  "SKINS\OSX\STYLE.CSS"                       "skins\osx\style.css"
  !insertmacro SFN2LFN  "SKINS\OUTLOOK"                             "skins\outlook"
  !insertmacro SFN2LFN  "SKINS\OUTLOOK\STYLE.CSS"                   "skins\outlook\style.css"
  !insertmacro SFN2LFN  "SKINS\simplyblue\STYLE.CSS"                "skins\simplyblue\style.css"
  !insertmacro SFN2LFN  "SKINS\sleet-rtl\BOTTOM.GIF"                "skins\sleet-rtl\bottom.gif"
  !insertmacro SFN2LFN  "SKINS\sleet-rtl\BUTTON.GIF"                "skins\sleet-rtl\button.gif"
  !insertmacro SFN2LFN  "SKINS\sleet-rtl\BUTTON2.GIF"               "skins\sleet-rtl\button2.gif"
  !insertmacro SFN2LFN  "SKINS\sleet-rtl\LEFT.GIF"                  "skins\sleet-rtl\left.gif"
  !insertmacro SFN2LFN  "SKINS\sleet-rtl\MENU.GIF"                  "skins\sleet-rtl\menu.gif"
  !insertmacro SFN2LFN  "SKINS\sleet-rtl\RIGHT.GIF"                 "skins\sleet-rtl\right.gif"
  !insertmacro SFN2LFN  "SKINS\sleet-rtl\STYLE.CSS"                 "skins\sleet-rtl\style.css"
  !insertmacro SFN2LFN  "SKINS\sleet-rtl\TOP.GIF"                   "skins\sleet-rtl\top.gif"
  !insertmacro SFN2LFN  "SKINS\sleet\BOTTOM.GIF"                    "skins\sleet\bottom.gif"
  !insertmacro SFN2LFN  "SKINS\sleet\BUTTON.GIF"                    "skins\sleet\button.gif"
  !insertmacro SFN2LFN  "SKINS\SLEET"                               "skins\sleet"
  !insertmacro SFN2LFN  "SKINS\SLEET\BUTTON2.GIF"                   "skins\sleet\button2.gif"
  !insertmacro SFN2LFN  "SKINS\SLEET\LEFT.GIF"                      "skins\sleet\left.gif"
  !insertmacro SFN2LFN  "SKINS\SLEET\MENU.GIF"                      "skins\sleet\menu.gif"
  !insertmacro SFN2LFN  "SKINS\SLEET\RIGHT.GIF"                     "skins\sleet\right.gif"
  !insertmacro SFN2LFN  "SKINS\SLEET\STYLE.CSS"                     "skins\sleet\style.css"
  !insertmacro SFN2LFN  "SKINS\SLEET\TOP.GIF"                       "skins\sleet\top.gif"
  !insertmacro SFN2LFN  "SKINS\smalldefault\STYLE.CSS"              "skins\smalldefault\style.css"
  !insertmacro SFN2LFN  "SKINS\smallgrey\STYLE.CSS"                 "skins\smallgrey\style.css"
  !insertmacro SFN2LFN  "SKINS\strawberryrose\STYLE.CSS"            "skins\strawberryrose\style.css"
  !insertmacro SFN2LFN  "SKINS\TINYGREY"                            "skins\tinygrey"
  !insertmacro SFN2LFN  "SKINS\TINYGREY\STYLE.CSS"                  "skins\tinygrey\style.css"
  !insertmacro SFN2LFN  "SKINS\WHITE"                               "skins\white"
  !insertmacro SFN2LFN  "SKINS\WHITE\STYLE.CSS"                     "skins\white\style.css"
  !insertmacro SFN2LFN  "SKINS\WINDOWS"                             "skins\windows"
  !insertmacro SFN2LFN  "SKINS\WINDOWS\STYLE.CSS"                   "skins\windows\style.css"

  !insertmacro SFN2LFN  "UI\HTML.PM"                                "UI\HTML.pm"
  !insertmacro SFN2LFN  "UI\HTTP.PM"                                "UI\HTTP.pm"
  !insertmacro SFN2LFN  "UI\XMLRPC.PM"                              "UI\XMLRPC.pm"

  ;-----------------------------------------------------------------------------------------

  ; Now adjust the default user data and the current user data (if any)

  Push $G_ROOTDIR
  Call NSIS_GetParent
  Call NSIS_GetParent
  Pop $G_ROOTDIR

  !insertmacro SFN2LFN  "App\DefaultData\POPFILE.CFG"               "App\DefaultData\popfile.cfg"

  !insertmacro SFN2LFN  "Data\POPFILE.CFG"                          "Data\popfile.cfg"
  !insertmacro SFN2LFN  "Data\POPFILE.DB"                           "Data\popfile.db"
  !insertmacro SFN2LFN  "Data\MESSAGES"                             "Data\messages"

  ;-----------------------------------------------------------------------------------------

  DetailPrint ""
  SetDetailsPrint both
  DetailPrint "${L_COUNT} fixes applied"
  SetDetailsPrint listonly

  Call PPL_GetDateTimeStamp
  Pop ${L_TEMP}
  DetailPrint ""
  DetailPrint "------------------------------------------------------------"
  DetailPrint "(report finished ${L_TEMP})"
  DetailPrint "------------------------------------------------------------"
  SetDetailsPrint none

  Call NSIS_GetParameters
  Pop ${L_TEMP}
  StrCmp ${L_TEMP} "/wait" 0 exit
  SetAutoClose false

exit:
 !undef L_TEMP

SectionEnd

#--------------------------------------------------------------------------
# End of 'lfnfixer.nsi'
#--------------------------------------------------------------------------
