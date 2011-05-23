#--------------------------------------------------------------------------
#
# installer-SecMinPerl-body.nsh --- This 'include' file contains the body of the "MinPerl"
#                                   Section of the main 'installer.nsi' NSIS script used to
#                                   create the Windows installer for POPFile. The "MinPerl"
#                                   section installs a minimal Perl which suits the default
#                                   POPFile configuration. For some of the optional POPFile
#                                   components (e.g. XMLRPC) additional Perl components are
#                                   required and these are installed at the same time as the
#                                   optional POPFile component.
#
# Copyright (c) 2005-2011 John Graham-Cumming
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

  ; This section installs the "core" version of the minimal Perl. Some of the optional
  ; POPFile components, such as the Nihongo (Japanese) parser and POPFile's XMLRPC
  ; module, require extra Perl components which are added when the optional POPFile
  ; components are installed.

  !insertmacro SECTIONLOG_ENTER "Minimal Perl"

  ; Install the Minimal Perl files

  SetDetailsPrint textonly
  DetailPrint "$(PFI_LANG_INST_PROG_PERL)"
  SetDetailsPrint listonly

  ; Install the minimal Perl "core" based upon ActivePerl 5.8.9 Build 825
  ; (extra Perl files are added by the "SOCKS" & "XMLRPC" sections in installer.nsi
  ; and by the macro-based "Kakasi", "MeCab" and "InternalParser" sections defined
  ; in getparser.nsh)

  SetOutPath "$G_ROOTDIR"
  File "${C_PERL_DIR}\bin\perl.exe"
  File "${C_PERL_DIR}\bin\wperl.exe"
  File "${C_PERL_DIR}\bin\perl58.dll"

  SetOutPath "$G_MPLIBDIR"
  File "${C_PERL_DIR}\lib\AutoLoader.pm"
  File "${C_PERL_DIR}\lib\Carp.pm"
  File "${C_PERL_DIR}\lib\Config.pm"
  File "${C_PERL_DIR}\lib\Config_heavy.pl"
  File "${C_PERL_DIR}\lib\constant.pm"
  File "${C_PERL_DIR}\lib\Cwd.pm"
        SetOutPath "$G_MPLIBDIR\auto\Cwd"
        File "${C_PERL_DIR}\lib\auto\Cwd\Cwd.dll"
        SetOutPath "$G_MPLIBDIR"
  File "${C_PERL_DIR}\lib\DynaLoader.pm"
        SetOutPath "$G_MPLIBDIR\auto\DynaLoader"
        File "${C_PERL_DIR}\lib\auto\DynaLoader\autosplit.ix"
        File "${C_PERL_DIR}\lib\auto\DynaLoader\dl_expandspec.al"
        File "${C_PERL_DIR}\lib\auto\DynaLoader\dl_findfile.al"
        File "${C_PERL_DIR}\lib\auto\DynaLoader\dl_find_symbol_anywhere.al"
        SetOutPath "$G_MPLIBDIR"
  File "${C_PERL_DIR}\lib\Errno.pm"
  File "${C_PERL_DIR}\lib\Exporter.pm"
  File "${C_PERL_DIR}\lib\Fcntl.pm"
        SetOutPath "$G_MPLIBDIR\auto\Fcntl"
        File "${C_PERL_DIR}\lib\auto\Fcntl\Fcntl.dll"
        SetOutPath "$G_MPLIBDIR"
  File "${C_PERL_DIR}\lib\integer.pm"
  File "${C_PERL_DIR}\lib\IO.pm"
  File "${C_PERL_DIR}\lib\lib.pm"
  File "${C_PERL_DIR}\lib\locale.pm"
  File "${C_PERL_DIR}\lib\LWP.pm"
  File "${C_PERL_DIR}\lib\POSIX.pm"
        SetOutPath "$G_MPLIBDIR\auto\POSIX"
        File "${C_PERL_DIR}\lib\auto\POSIX\POSIX.dll"
        File "${C_PERL_DIR}\lib\auto\POSIX\autosplit.ix"
        File "${C_PERL_DIR}\lib\auto\POSIX\load_imports.al"
        SetOutPath "$G_MPLIBDIR"
  File "${C_PERL_DIR}\lib\re.pm"
  File "${C_PERL_DIR}\lib\SelectSaver.pm"
  File "${C_PERL_DIR}\lib\Socket.pm"
        SetOutPath "$G_MPLIBDIR\auto\Socket"
        File "${C_PERL_DIR}\lib\auto\Socket\Socket.dll"
        SetOutPath "$G_MPLIBDIR"
  File "${C_PERL_DIR}\lib\strict.pm"
  File "${C_PERL_DIR}\lib\Symbol.pm"
  File "${C_PERL_DIR}\site\lib\URI.pm"
  File "${C_PERL_DIR}\lib\utf8.pm"
  File "${C_PERL_DIR}\lib\utf8_heavy.pl"
  File "${C_PERL_DIR}\lib\vars.pm"
  File "${C_PERL_DIR}\lib\warnings.pm"
  File "${C_PERL_DIR}\lib\Win32.pm"
        SetOutPath "$G_MPLIBDIR\auto\Win32"
        File "${C_PERL_DIR}\lib\auto\Win32\Win32.dll"
        SetOutPath "$G_MPLIBDIR"
  File "${C_PERL_DIR}\lib\XSLoader.pm"

  SetOutPath "$G_MPLIBDIR\Carp"
  File "${C_PERL_DIR}\lib\Carp\Clan.pm"
  File "${C_PERL_DIR}\lib\Carp\Heavy.pm"

  SetOutPath "$G_MPLIBDIR\Date"
  File "${C_PERL_DIR}\site\lib\Date\Format.pm"
  File "${C_PERL_DIR}\site\lib\Date\Parse.pm"

  SetOutPath "$G_MPLIBDIR\Digest"
  File "${C_PERL_DIR}\lib\Digest\MD5.pm"
        SetOutPath "$G_MPLIBDIR\auto\Digest\MD5"
        File "${C_PERL_DIR}\lib\auto\Digest\MD5\MD5.dll"

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
  File "${C_PERL_DIR}\lib\IO\Dir.pm"
  File "${C_PERL_DIR}\lib\IO\File.pm"
  File "${C_PERL_DIR}\lib\IO\Handle.pm"
  File "${C_PERL_DIR}\lib\IO\Pipe.pm"
  File "${C_PERL_DIR}\lib\IO\Poll.pm"
  File "${C_PERL_DIR}\lib\IO\Seekable.pm"
  File "${C_PERL_DIR}\lib\IO\Select.pm"
  File "${C_PERL_DIR}\lib\IO\SessionData.pm"
  File "${C_PERL_DIR}\lib\IO\SessionSet.pm"
  File "${C_PERL_DIR}\lib\IO\Socket.pm"
  File "${C_PERL_DIR}\lib\IO\String.pm"
  File "${C_PERL_DIR}\lib\IO\Zlib.pm"
        SetOutPath "$G_MPLIBDIR\auto\IO"
        File "${C_PERL_DIR}\lib\auto\IO\IO.dll"

  SetOutPath "$G_MPLIBDIR\IO\Socket"
  File "${C_PERL_DIR}\lib\IO\Socket\INET.pm"
  File "${C_PERL_DIR}\lib\IO\Socket\UNIX.pm"

  SetOutPath "$G_MPLIBDIR\List"
  File "${C_PERL_DIR}\lib\List\Util.pm"
        SetOutPath "$G_MPLIBDIR\auto\List\Util"
        File "${C_PERL_DIR}\lib\auto\List\Util\Util.dll"

  SetOutPath "$G_MPLIBDIR\LWP"
  File "${C_PERL_DIR}\lib\LWP\MemberMixin.pm"
  File "${C_PERL_DIR}\lib\LWP\Protocol.pm"
  File "${C_PERL_DIR}\lib\LWP\Simple.pm"
  File "${C_PERL_DIR}\lib\LWP\UserAgent.pm"

  SetOutPath "$G_MPLIBDIR\LWP\Protocol"
  File "${C_PERL_DIR}\lib\LWP\Protocol\http.pm"

  SetOutPath "$G_MPLIBDIR\MIME"
  File "${C_PERL_DIR}\lib\MIME\Base64.pm"
  File "${C_PERL_DIR}\lib\MIME\QuotedPrint.pm"
        SetOutPath "$G_MPLIBDIR\auto\MIME\Base64"
        File "${C_PERL_DIR}\lib\auto\MIME\Base64\Base64.dll"

  SetOutPath "$G_MPLIBDIR\Net"
  File "${C_PERL_DIR}\lib\Net\HTTP.pm"

  SetOutPath "$G_MPLIBDIR\Net\HTTP"
  File "${C_PERL_DIR}\lib\Net\HTTP\Methods.pm"

  SetOutPath "$G_MPLIBDIR\Scalar"
  File "${C_PERL_DIR}\lib\Scalar\Util.pm"

  SetOutPath "$G_MPLIBDIR\Sys"
  File "${C_PERL_DIR}\lib\Sys\Hostname.pm"
        SetOutPath "$G_MPLIBDIR\auto\Sys\Hostname"
        File "${C_PERL_DIR}\lib\auto\Sys\Hostname\Hostname.dll"
        File "${C_PERL_DIR}\lib\auto\Sys\Hostname\autosplit.ix"

  SetOutPath "$G_MPLIBDIR\Text"
  File "${C_PERL_DIR}\lib\Text\ParseWords.pm"

  SetOutPath "$G_MPLIBDIR\Tie"
  File "${C_PERL_DIR}\lib\Tie\Hash.pm"

  SetOutPath "$G_MPLIBDIR\Time"
  File "${C_PERL_DIR}\lib\Time\Local.pm"
  File "${C_PERL_DIR}\site\lib\Time\Zone.pm"

  SetOutPath "$G_MPLIBDIR\unicore"
  File "${C_PERL_DIR}\lib\unicore\Exact.pl"
  File "${C_PERL_DIR}\lib\unicore\PVA.pl"

  SetOutPath "$G_MPLIBDIR\unicore\lib\gc_sc"
  File "${C_PERL_DIR}\lib\unicore\lib\gc_sc\Digit.pl"

  SetOutPath "$G_MPLIBDIR\URI"
  File "${C_PERL_DIR}\site\lib\URI\_foreign.pm"
  File "${C_PERL_DIR}\site\lib\URI\_generic.pm"
  File "${C_PERL_DIR}\site\lib\URI\_query.pm"
  File "${C_PERL_DIR}\site\lib\URI\_server.pm"
  File "${C_PERL_DIR}\site\lib\URI\Escape.pm"
  File "${C_PERL_DIR}\site\lib\URI\http.pm"

  SetOutPath "$G_MPLIBDIR\warnings"
  File "${C_PERL_DIR}\lib\warnings\register.pm"

  SetOutPath "$G_MPLIBDIR\Win32"
  File "${C_PERL_DIR}\site\lib\Win32\GUI.pm"

  SetOutPath "$G_MPLIBDIR\Win32\GUI"
  File "${C_PERL_DIR}\site\lib\Win32\GUI\AxWindow.pm"
  File "${C_PERL_DIR}\site\lib\Win32\GUI\BitmapInline.pm"
  File "${C_PERL_DIR}\site\lib\Win32\GUI\Constants.pm"
  File "${C_PERL_DIR}\site\lib\Win32\GUI\DIBitmap.pm"
  File "${C_PERL_DIR}\site\lib\Win32\GUI\DropFiles.pm"
  File "${C_PERL_DIR}\site\lib\Win32\GUI\Grid.pm"
  File "${C_PERL_DIR}\site\lib\Win32\GUI\GridLayout.pm"
  File "${C_PERL_DIR}\site\lib\Win32\GUI\Scintilla.pm"
        SetOutPath "$G_MPLIBDIR\auto\Win32\GUI"
        File "${C_PERL_DIR}\site\lib\auto\Win32\GUI\GUI.dll"

  SetOutPath "$G_MPLIBDIR\Win32\GUI\Constants"
  File "${C_PERL_DIR}\site\lib\Win32\GUI\Constants\Tags.pm"
        SetOutPath "$G_MPLIBDIR\auto\Win32\GUI\Constants"
        File "${C_PERL_DIR}\site\lib\auto\Win32\GUI\Constants\Constants.dll"
        SetOutPath "$G_MPLIBDIR\auto\Win32\GUI\Constants\Tags"
        File "${C_PERL_DIR}\site\lib\auto\Win32\GUI\Constants\Tags\autosplit.ix"
        File "${C_PERL_DIR}\site\lib\auto\Win32\GUI\Constants\Tags\tag_compatibility_win32_gui.al"

  ; Install Perl modules and library files for BerkeleyDB support. Although POPFile now uses
  ; SQLite (or another SQL database) to store the corpus and other essential data, it retains
  ; the ability to automatically convert old BerkeleyDB format corpus files to the SQL database
  ; format. Therefore the installer still installs the BerkeleyDB Perl components.
  ;
  ; WARNING: An old version of BerkeleyDB.pm is required here in order to be compatible with the
  ; BerkeleyDB databases generated by POPFile 0.20.x (BerkeleyDB.pm v0.22 is safe to use here).

  SetOutPath "$G_MPLIBDIR"
  File "${C_PERL_DIR}\site\lib\BerkeleyDB.pm"
  File "${C_PERL_DIR}\lib\UNIVERSAL.pm"

  SetOutPath "$G_MPLIBDIR\auto\BerkeleyDB"
  File "${C_PERL_DIR}\site\lib\auto\BerkeleyDB\autosplit.ix"
  File "${C_PERL_DIR}\site\lib\auto\BerkeleyDB\BerkeleyDB.dll"

  ; Install Perl modules and library files for SQLite support

  SetOutPath "$G_MPLIBDIR"
  File "${C_PERL_DIR}\lib\base.pm"
  File "${C_PERL_DIR}\lib\overload.pm"
  File "${C_PERL_DIR}\lib\DBI.pm"

  ; Required in order to use any version of SQLite

  SetOutPath "$G_MPLIBDIR\auto\DBI"
  File "${C_PERL_DIR}\lib\auto\DBI\DBI.dll"

  ; POPFile 1.1.0 was the first version of POPFile to work with SQLite 3.x libraries.
  ; SQLite databases built using SQLite 3.x are incompatible with those built using
  ; SQLite 2.x so the installer needs to install support for both types of database in
  ; order to allow old POPFile databases to be upgraded to the new SQLite 3.x format.

  SetOutPath "$G_MPLIBDIR\DBD"
  File "${C_PERL_DIR}\lib\DBD\SQLite.pm"
  File "${C_PERL_DIR}\site\lib\DBD\SQLite2.pm"

  SetOutPath "$G_MPLIBDIR\auto\DBD\SQLite"
  File "${C_PERL_DIR}\lib\auto\DBD\SQLite\SQLite.dll"

  SetOutPath "$G_MPLIBDIR\auto\DBD\SQLite2"
  File "${C_PERL_DIR}\site\lib\auto\DBD\SQLite2\SQLite2.dll"

  SetDetailsPrint textonly
  DetailPrint "$(PFI_LANG_INST_PROG_ENDSEC)"
  SetDetailsPrint listonly

  !insertmacro SECTIONLOG_EXIT "Minimal Perl"

; SectionEnd

#--------------------------------------------------------------------------
# End of 'installer-SecMinPerl-body.nsh'
#--------------------------------------------------------------------------
