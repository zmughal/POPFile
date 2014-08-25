#--------------------------------------------------------------------------
#
# installer-SecMinPerl-body.nsh
#   This 'include' file contains the body of the "MinPerl" Section of the
#   main 'installer.nsi' NSIS script used to create the Windows installer
#   for POPFile. The "MinPerl" section installs a minimal Perl which suits
#   the default POPFile configuration.
#
#   For some of the optional POPFile components (e.g. XMLRPC) additional
#   Perl components are required and these are installed at the same time
#   as the optional POPFile component (see 'installer.nsi' & 'getparser.nsh').
#
# Copyright (c) 2005-2014 John Graham-Cumming
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
#         Section "-Minimal Perl" SecMinPerl
#           !include "installer-SecMinPerl-body.nsh"
#         SectionEnd
#--------------------------------------------------------------------------

; Section "-Minimal Perl" SecMinPerl

  ; This section installs the "core" version of the minimal Perl. Some of the
  ; optional POPFile components, such as the Nihongo (Japanese) parser and
  ; POPFile's XMLRPC module, require extra Perl components which are added
  ; when the optional POPFile components are installed (see 'installer.nsi'
  ; and 'getparser.nsh').

  !insertmacro SECTIONLOG_ENTER "Minimal Perl"

  ; Install the Minimal Perl files

  SetDetailsPrint textonly
  DetailPrint "$(PFI_LANG_INST_PROG_PERL)"
  SetDetailsPrint listonly

  ; This minimal Perl supports the POPFile User Interface (UI), POP3 mail,
  ; IMAP mail, SSL connections to mail servers, SOCKS V support for all of
  ; the POPFile proxies, the system tray icon, the system tray icon's menu
  ; functions and the SQLite 3.x format database.
  ;
  ; POPFile has used SQLite 3.x format databases by default since the release
  ; of POPFile 1.1.0 on 30 November 2008.
  ;
  ; POPFile 1.1.4 is the first release which is unable to automatically import
  ; the database from ANY previous release. This is because POPFile 1.1.4 uses
  ; a more up-to-date version of Perl which does not support the BerkeleyDB
  ; format (used by POPFile 0.20.0 released 17 October 2003 and POPFile 0.20.1
  ; released 4 November 2003) or the SQLite 2.x format (used by POPFile from
  ; the 0.21.0 release of 9 March 2004 to the 1.0.1 release of 26 May 2008).
  ;
  ; POPFile 1.1.3 is the last release of POPFile which is able to update the
  ; database from ANY previous release of POPFile.
  ;
  ; Extra Perl files are added by the optional "XMLRPC" section in the main
  ; 'installer.nsi' file and also by the macro-based "Kakasi", "MeCab" and
  ; "InternalParser" sections defined in 'getparser.nsh' (another 'include'
  ; file used by 'installer.nsi').

  SetOutPath "$G_ROOTDIR"
  File "${C_PERL_DIR}\bin\perl.exe"
  File "${C_PERL_DIR}\bin\wperl.exe"
  File "${C_PERL_DIR}\bin\perl516.dll"

  SetOutPath "$G_MPLIBDIR"
  File "${C_PERL_DIR}\lib\AutoLoader.pm"
  File "${C_PERL_DIR}\site\lib\base.pm"
  File "${C_PERL_DIR}\lib\bytes.pm"
  File "${C_PERL_DIR}\lib\bytes_heavy.pl"
  File "${C_PERL_DIR}\site\lib\Carp.pm"
  File "${C_PERL_DIR}\lib\Config.pm"
  File "${C_PERL_DIR}\lib\Config_git.pl"
  File "${C_PERL_DIR}\lib\Config_heavy.pl"
  File "${C_PERL_DIR}\lib\constant.pm"
  File "${C_PERL_DIR}\lib\Cwd.pm"
        SetOutPath "$G_MPLIBDIR\auto\Cwd"
        File "${C_PERL_DIR}\lib\auto\Cwd\Cwd.dll"
        SetOutPath "$G_MPLIBDIR"
  File "${C_PERL_DIR}\site\lib\DBI.pm"
        SetOutPath "$G_MPLIBDIR\auto\DBI"
        File "${C_PERL_DIR}\site\lib\auto\DBI\DBI.dll"
        SetOutPath "$G_MPLIBDIR"
  File "${C_PERL_DIR}\site\lib\Encode.pm"
        SetOutPath "$G_MPLIBDIR\auto\Encode"
        File "${C_PERL_DIR}\site\lib\auto\Encode\Encode.dll"
        SetOutPath "$G_MPLIBDIR"
  File "${C_PERL_DIR}\lib\Errno.pm"
  File "${C_PERL_DIR}\lib\Exporter.pm"
  File "${C_PERL_DIR}\lib\Fcntl.pm"
        SetOutPath "$G_MPLIBDIR\auto\Fcntl"
        File "${C_PERL_DIR}\lib\auto\Fcntl\Fcntl.dll"
        SetOutPath "$G_MPLIBDIR"
  File "${C_PERL_DIR}\lib\feature.pm"
  File "${C_PERL_DIR}\lib\integer.pm"
  File "${C_PERL_DIR}\lib\IO.pm"
        SetOutPath "$G_MPLIBDIR\auto\IO"
        File "${C_PERL_DIR}\lib\auto\IO\IO.dll"
        SetOutPath "$G_MPLIBDIR"
  File "${C_PERL_DIR}\lib\lib.pm"
  File "${C_PERL_DIR}\lib\locale.pm"
  File "${C_PERL_DIR}\lib\LWP.pm"
  File "${C_PERL_DIR}\lib\overload.pm"
  File "${C_PERL_DIR}\lib\overloading.pm"
  File "${C_PERL_DIR}\lib\POSIX.pm"
        SetOutPath "$G_MPLIBDIR\auto\POSIX"
        File "${C_PERL_DIR}\lib\auto\POSIX\POSIX.dll"
        SetOutPath "$G_MPLIBDIR"
  File "${C_PERL_DIR}\lib\SelectSaver.pm"
  File "${C_PERL_DIR}\lib\Socket.pm"
        SetOutPath "$G_MPLIBDIR\auto\Socket"
        File "${C_PERL_DIR}\lib\auto\Socket\Socket.dll"
        SetOutPath "$G_MPLIBDIR"
  File "${C_PERL_DIR}\lib\strict.pm"
  File "${C_PERL_DIR}\lib\Symbol.pm"
  File "${C_PERL_DIR}\site\lib\URI.pm"
  File "${C_PERL_DIR}\lib\vars.pm"
  File "${C_PERL_DIR}\lib\warnings.pm"
  File "${C_PERL_DIR}\site\lib\Win32.pm"
        SetOutPath "$G_MPLIBDIR\auto\Win32"
        File "${C_PERL_DIR}\site\lib\auto\Win32\Win32.dll"

  SetOutPath "$G_MPLIBDIR\Date"
  File "${C_PERL_DIR}\site\lib\Date\Format.pm"
  File "${C_PERL_DIR}\site\lib\Date\Parse.pm"

  SetOutPath "$G_MPLIBDIR\DBD"
  File "${C_PERL_DIR}\site\lib\DBD\SQLite.pm"
        SetOutPath "$G_MPLIBDIR\auto\DBD\SQLite"
        File "${C_PERL_DIR}\site\lib\auto\DBD\SQLite\SQLite.dll"

  SetOutPath "$G_MPLIBDIR\Digest"
  File "${C_PERL_DIR}\lib\Digest\MD5.pm"
        SetOutPath "$G_MPLIBDIR\auto\Digest\MD5"
        File "${C_PERL_DIR}\lib\auto\Digest\MD5\MD5.dll"

  SetOutPath "$G_MPLIBDIR\Encode"
  File "${C_PERL_DIR}\site\lib\Encode\Alias.pm"
  File "${C_PERL_DIR}\site\lib\Encode\Byte.pm"
        SetOutPath "$G_MPLIBDIR\auto\Encode\Byte"
        File "${C_PERL_DIR}\site\lib\auto\Encode\Byte\Byte.dll"
        SetOutPath "$G_MPLIBDIR\Encode"
  File "${C_PERL_DIR}\site\lib\Encode\Config.pm"
  File "${C_PERL_DIR}\site\lib\Encode\Encoding.pm"
  File "${C_PERL_DIR}\lib\Encode\Locale.pm"

  SetOutPath "$G_MPLIBDIR\Exporter"
  File "${C_PERL_DIR}\lib\Exporter\Heavy.pm"

  SetOutPath "$G_MPLIBDIR\File"
  File "${C_PERL_DIR}\lib\File\Basename.pm"
  File "${C_PERL_DIR}\lib\File\Copy.pm"
  File "${C_PERL_DIR}\lib\File\Glob.pm"
  File "${C_PERL_DIR}\lib\File\Spec.pm"
        SetOutPath "$G_MPLIBDIR\auto\File\Glob"
        File "${C_PERL_DIR}\lib\auto\File\Glob\Glob.dll"

  SetOutPath "$G_MPLIBDIR\File\Spec"
  File "${C_PERL_DIR}\lib\File\Spec\Unix.pm"
  File "${C_PERL_DIR}\lib\File\Spec\Win32.pm"

  SetOutPath "$G_MPLIBDIR\Getopt"
  File "${C_PERL_DIR}\lib\Getopt\Long.pm"

  SetOutPath "$G_MPLIBDIR\HTML"
  File "${C_PERL_DIR}\lib\HTML\Tagset.pm"
  File "${C_PERL_DIR}\lib\HTML\Template.pm"

  SetOutPath "$G_MPLIBDIR\HTTP"
  File "${C_PERL_DIR}\lib\HTTP\Config.pm"
  File "${C_PERL_DIR}\lib\HTTP\Date.pm"
  File "${C_PERL_DIR}\lib\HTTP\Headers.pm"
  File "${C_PERL_DIR}\lib\HTTP\Message.pm"
  File "${C_PERL_DIR}\lib\HTTP\Request.pm"
  File "${C_PERL_DIR}\lib\HTTP\Response.pm"
  File "${C_PERL_DIR}\lib\HTTP\Status.pm"

  SetOutPath "$G_MPLIBDIR\HTTP\Request"
  File "${C_PERL_DIR}\lib\HTTP\Request\Common.pm"

  SetOutPath "$G_MPLIBDIR\IO"
  File "${C_PERL_DIR}\lib\IO\Handle.pm"
  File "${C_PERL_DIR}\lib\IO\Select.pm"
  File "${C_PERL_DIR}\lib\IO\Socket.pm"

  SetOutPath "$G_MPLIBDIR\IO\Socket"
  File "${C_PERL_DIR}\lib\IO\Socket\INET.pm"
  File "${C_PERL_DIR}\lib\IO\Socket\UNIX.pm"
  File "${C_PERL_DIR}\site\lib\IO\Socket\Socks.pm"
  File "${C_PERL_DIR}\site\lib\IO\Socket\SSL.pm"

  SetOutPath "$G_MPLIBDIR\List"
  File "${C_PERL_DIR}\site\lib\List\Util.pm"
        SetOutPath "$G_MPLIBDIR\auto\List\Util"
        File "${C_PERL_DIR}\site\lib\auto\List\Util\Util.dll"

  SetOutPath "$G_MPLIBDIR\LWP"
  File "${C_PERL_DIR}\lib\LWP\MemberMixin.pm"
  File "${C_PERL_DIR}\lib\LWP\Protocol.pm"
  File "${C_PERL_DIR}\lib\LWP\UserAgent.pm"

  SetOutPath "$G_MPLIBDIR\LWP\Protocol"
  File "${C_PERL_DIR}\lib\LWP\Protocol\http.pm"

  SetOutPath "$G_MPLIBDIR\MIME"
  File "${C_PERL_DIR}\lib\MIME\Base64.pm"
  File "${C_PERL_DIR}\lib\MIME\QuotedPrint.pm"
        SetOutPath "$G_MPLIBDIR\auto\MIME\Base64"
        File "${C_PERL_DIR}\lib\auto\MIME\Base64\Base64.dll"

  SetOutPath "$G_MPLIBDIR\Mozilla"
  File "${C_PERL_DIR}\lib\Mozilla\CA.pm"

  SetOutPath "$G_MPLIBDIR\Mozilla\CA"
  File "${C_PERL_DIR}\lib\Mozilla\CA\cacert.pem"

  SetOutPath "$G_MPLIBDIR\Net"
  File "${C_PERL_DIR}\site\lib\Net\HTTP.pm"
  File "${C_PERL_DIR}\site\lib\Net\SSLeay.pm"
        SetOutPath "$G_MPLIBDIR\auto\Net\SSLeay"
        File "${C_PERL_DIR}\site\lib\auto\Net\SSLeay\SSLeay.dll"
        File "${C_PERL_DIR}\site\lib\auto\Net\SSLeay\autosplit.ix"
        File "${C_PERL_DIR}\site\lib\auto\Net\SSLeay\debug_read.al"
        File "${C_PERL_DIR}\site\lib\auto\Net\SSLeay\do_https.al"
        File "${C_PERL_DIR}\site\lib\auto\Net\SSLeay\do_https2.al"
        File "${C_PERL_DIR}\site\lib\auto\Net\SSLeay\do_https3.al"
        File "${C_PERL_DIR}\site\lib\auto\Net\SSLeay\do_https4.al"
        File "${C_PERL_DIR}\site\lib\auto\Net\SSLeay\do_httpx2.al"
        File "${C_PERL_DIR}\site\lib\auto\Net\SSLeay\do_httpx3.al"
        File "${C_PERL_DIR}\site\lib\auto\Net\SSLeay\do_httpx4.al"
        File "${C_PERL_DIR}\site\lib\auto\Net\SSLeay\dump_peer_certificate.al"
        File "${C_PERL_DIR}\site\lib\auto\Net\SSLeay\get_http.al"
        File "${C_PERL_DIR}\site\lib\auto\Net\SSLeay\get_http3.al"
        File "${C_PERL_DIR}\site\lib\auto\Net\SSLeay\get_http4.al"
        File "${C_PERL_DIR}\site\lib\auto\Net\SSLeay\get_https.al"
        File "${C_PERL_DIR}\site\lib\auto\Net\SSLeay\get_https3.al"
        File "${C_PERL_DIR}\site\lib\auto\Net\SSLeay\get_https4.al"
        File "${C_PERL_DIR}\site\lib\auto\Net\SSLeay\get_httpx.al"
        File "${C_PERL_DIR}\site\lib\auto\Net\SSLeay\get_httpx3.al"
        File "${C_PERL_DIR}\site\lib\auto\Net\SSLeay\get_httpx4.al"
        File "${C_PERL_DIR}\site\lib\auto\Net\SSLeay\head_http.al"
        File "${C_PERL_DIR}\site\lib\auto\Net\SSLeay\head_http3.al"
        File "${C_PERL_DIR}\site\lib\auto\Net\SSLeay\head_http4.al"
        File "${C_PERL_DIR}\site\lib\auto\Net\SSLeay\head_https.al"
        File "${C_PERL_DIR}\site\lib\auto\Net\SSLeay\head_https3.al"
        File "${C_PERL_DIR}\site\lib\auto\Net\SSLeay\head_https4.al"
        File "${C_PERL_DIR}\site\lib\auto\Net\SSLeay\head_httpx.al"
        File "${C_PERL_DIR}\site\lib\auto\Net\SSLeay\head_httpx3.al"
        File "${C_PERL_DIR}\site\lib\auto\Net\SSLeay\head_httpx4.al"
        File "${C_PERL_DIR}\site\lib\auto\Net\SSLeay\https_cat.al"
        File "${C_PERL_DIR}\site\lib\auto\Net\SSLeay\httpx_cat.al"
        File "${C_PERL_DIR}\site\lib\auto\Net\SSLeay\http_cat.al"
        File "${C_PERL_DIR}\site\lib\auto\Net\SSLeay\initialize.al"
        File "${C_PERL_DIR}\site\lib\auto\Net\SSLeay\make_form.al"
        File "${C_PERL_DIR}\site\lib\auto\Net\SSLeay\make_headers.al"
        File "${C_PERL_DIR}\site\lib\auto\Net\SSLeay\new_x_ctx.al"
        File "${C_PERL_DIR}\site\lib\auto\Net\SSLeay\open_proxy_tcp_connection.al"
        File "${C_PERL_DIR}\site\lib\auto\Net\SSLeay\open_tcp_connection.al"
        File "${C_PERL_DIR}\site\lib\auto\Net\SSLeay\post_http.al"
        File "${C_PERL_DIR}\site\lib\auto\Net\SSLeay\post_http3.al"
        File "${C_PERL_DIR}\site\lib\auto\Net\SSLeay\post_http4.al"
        File "${C_PERL_DIR}\site\lib\auto\Net\SSLeay\post_https.al"
        File "${C_PERL_DIR}\site\lib\auto\Net\SSLeay\post_https3.al"
        File "${C_PERL_DIR}\site\lib\auto\Net\SSLeay\post_https4.al"
        File "${C_PERL_DIR}\site\lib\auto\Net\SSLeay\post_httpx.al"
        File "${C_PERL_DIR}\site\lib\auto\Net\SSLeay\post_httpx3.al"
        File "${C_PERL_DIR}\site\lib\auto\Net\SSLeay\post_httpx4.al"
        File "${C_PERL_DIR}\site\lib\auto\Net\SSLeay\put_http.al"
        File "${C_PERL_DIR}\site\lib\auto\Net\SSLeay\put_http3.al"
        File "${C_PERL_DIR}\site\lib\auto\Net\SSLeay\put_http4.al"
        File "${C_PERL_DIR}\site\lib\auto\Net\SSLeay\put_https.al"
        File "${C_PERL_DIR}\site\lib\auto\Net\SSLeay\put_https3.al"
        File "${C_PERL_DIR}\site\lib\auto\Net\SSLeay\put_https4.al"
        File "${C_PERL_DIR}\site\lib\auto\Net\SSLeay\put_httpx.al"
        File "${C_PERL_DIR}\site\lib\auto\Net\SSLeay\put_httpx3.al"
        File "${C_PERL_DIR}\site\lib\auto\Net\SSLeay\put_httpx4.al"
        File "${C_PERL_DIR}\site\lib\auto\Net\SSLeay\randomize.al"
        File "${C_PERL_DIR}\site\lib\auto\Net\SSLeay\set_cert_and_key.al"
        File "${C_PERL_DIR}\site\lib\auto\Net\SSLeay\set_proxy.al"
        File "${C_PERL_DIR}\site\lib\auto\Net\SSLeay\set_server_cert_and_key.al"
        File "${C_PERL_DIR}\site\lib\auto\Net\SSLeay\sslcat.al"
        File "${C_PERL_DIR}\site\lib\auto\Net\SSLeay\ssl_read_all.al"
        File "${C_PERL_DIR}\site\lib\auto\Net\SSLeay\ssl_read_CRLF.al"
        File "${C_PERL_DIR}\site\lib\auto\Net\SSLeay\ssl_read_until.al"
        File "${C_PERL_DIR}\site\lib\auto\Net\SSLeay\ssl_write_all.al"
        File "${C_PERL_DIR}\site\lib\auto\Net\SSLeay\ssl_write_CRLF.al"
        File "${C_PERL_DIR}\site\lib\auto\Net\SSLeay\tcpcat.al"
        File "${C_PERL_DIR}\site\lib\auto\Net\SSLeay\tcpxcat.al"
        File "${C_PERL_DIR}\site\lib\auto\Net\SSLeay\tcp_read_all.al"
        File "${C_PERL_DIR}\site\lib\auto\Net\SSLeay\tcp_read_CRLF.al"
        File "${C_PERL_DIR}\site\lib\auto\Net\SSLeay\tcp_read_until.al"
        File "${C_PERL_DIR}\site\lib\auto\Net\SSLeay\tcp_write_all.al"
        File "${C_PERL_DIR}\site\lib\auto\Net\SSLeay\tcp_write_CRLF.al"
        File "${C_PERL_DIR}\site\lib\auto\Net\SSLeay\want_nothing.al"
        File "${C_PERL_DIR}\site\lib\auto\Net\SSLeay\want_read.al"
        File "${C_PERL_DIR}\site\lib\auto\Net\SSLeay\want_write.al"
        File "${C_PERL_DIR}\site\lib\auto\Net\SSLeay\want_X509_lookup.al"

  SetOutPath "$G_MPLIBDIR\Net\HTTP"
  File "${C_PERL_DIR}\site\lib\Net\HTTP\Methods.pm"

  SetOutPath "$G_MPLIBDIR\Net\SSLeay"
  File "${C_PERL_DIR}\site\lib\Net\SSLeay\Handle.pm"

  SetOutPath "$G_MPLIBDIR\Scalar"
  File "${C_PERL_DIR}\site\lib\Scalar\Util.pm"

  SetOutPath "$G_MPLIBDIR\Sys"
  File "${C_PERL_DIR}\lib\Sys\Hostname.pm"
        SetOutPath "$G_MPLIBDIR\auto\Sys\Hostname"
        File "${C_PERL_DIR}\lib\auto\Sys\Hostname\Hostname.dll"

  SetOutPath "$G_MPLIBDIR\Tie"
  File "${C_PERL_DIR}\lib\Tie\Hash.pm"

  SetOutPath "$G_MPLIBDIR\Time"
  File "${C_PERL_DIR}\lib\Time\Local.pm"
  File "${C_PERL_DIR}\site\lib\Time\Zone.pm"

  SetOutPath "$G_MPLIBDIR\URI"
  File "${C_PERL_DIR}\site\lib\URI\Escape.pm"
  File "${C_PERL_DIR}\site\lib\URI\http.pm"
  File "${C_PERL_DIR}\site\lib\URI\_foreign.pm"
  File "${C_PERL_DIR}\site\lib\URI\_generic.pm"
  File "${C_PERL_DIR}\site\lib\URI\_query.pm"
  File "${C_PERL_DIR}\site\lib\URI\_server.pm"

  SetOutPath "$G_MPLIBDIR\warnings"
  File "${C_PERL_DIR}\lib\warnings\register.pm"

  SetOutPath "$G_MPLIBDIR\Win32"
  File "${C_PERL_DIR}\site\lib\Win32\GUI.pm"

  SetOutPath "$G_MPLIBDIR\Win32\GUI"
  File "${C_PERL_DIR}\site\lib\Win32\GUI\Constants.pm"
        SetOutPath "$G_MPLIBDIR\auto\Win32\GUI"
        File "${C_PERL_DIR}\site\lib\auto\Win32\GUI\GUI.dll"
        SetOutPath "$G_MPLIBDIR\auto\Win32\GUI\Constants"
        File "${C_PERL_DIR}\site\lib\auto\Win32\GUI\Constants\Constants.dll"
        SetOutPath "$G_MPLIBDIR\auto\Win32\GUI\Constants\Tags"
        File "${C_PERL_DIR}\site\lib\auto\Win32\GUI\Constants\Tags\autosplit.ix"
        File "${C_PERL_DIR}\site\lib\auto\Win32\GUI\Constants\Tags\tag_compatibility_win32_gui.al"

  SetDetailsPrint textonly
  DetailPrint "$(PFI_LANG_INST_PROG_ENDSEC)"
  SetDetailsPrint listonly

  !insertmacro SECTIONLOG_EXIT "Minimal Perl"

; SectionEnd

#--------------------------------------------------------------------------
# End of 'installer-SecMinPerl-body.nsh'
#--------------------------------------------------------------------------
