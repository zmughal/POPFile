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
#  The 'installer.nsi' script file contains the following code:
#
#         Section "-Minimal Perl" SecMinPerl
#           !include "installer-SecMinPerl-body.nsh"
#         SectionEnd
#--------------------------------------------------------------------------

; Section "-Minimal Perl" SecMinPerl

  ; This section installs the "core" version of the minimal Perl. Some of the optional
  ; POPFile components, such as the Kakasi package and POPFile's XMLRPC module, require
  ; extra Perl components which are added when the optional POPFile components are installed.

  !insertmacro SECTIONLOG_ENTER "Minimal Perl"

  ; Install the Minimal Perl files

  SetDetailsPrint textonly
  DetailPrint "$(PFI_LANG_INST_PROG_PERL)"
  SetDetailsPrint listonly

  ; Install the minimal Perl "core" based upon ActivePerl 5.8.8 Build 819
  ; (extra Perl files are added by the "Kakasi", "SOCKS" & "XMLRPC" sections in installer.nsi)

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
  File "${C_PERL_DIR}\lib\DynaLoader.pm"
  File "${C_PERL_DIR}\lib\Errno.pm"
  File "${C_PERL_DIR}\lib\Exporter.pm"
  File "${C_PERL_DIR}\lib\Fcntl.pm"
  File "${C_PERL_DIR}\lib\integer.pm"
  File "${C_PERL_DIR}\lib\IO.pm"
  File "${C_PERL_DIR}\lib\lib.pm"
  File "${C_PERL_DIR}\lib\locale.pm"
  File "${C_PERL_DIR}\lib\POSIX.pm"
  File "${C_PERL_DIR}\lib\re.pm"
  File "${C_PERL_DIR}\lib\SelectSaver.pm"
  File "${C_PERL_DIR}\lib\Socket.pm"
  File "${C_PERL_DIR}\lib\strict.pm"
  File "${C_PERL_DIR}\lib\Symbol.pm"
  File "${C_PERL_DIR}\lib\vars.pm"
  File "${C_PERL_DIR}\lib\warnings.pm"
  File "${C_PERL_DIR}\lib\XSLoader.pm"

  SetOutPath "$G_MPLIBDIR\Carp"
  File "${C_PERL_DIR}\lib\Carp\*"

  SetOutPath "$G_MPLIBDIR\Date"
  File "${C_PERL_DIR}\site\lib\Date\Format.pm"
  File "${C_PERL_DIR}\site\lib\Date\Parse.pm"

  SetOutPath "$G_MPLIBDIR\Digest"
  File "${C_PERL_DIR}\lib\Digest\MD5.pm"

  SetOutPath "$G_MPLIBDIR\Exporter"
  File "${C_PERL_DIR}\lib\Exporter\*"

  SetOutPath "$G_MPLIBDIR\File"
  File "${C_PERL_DIR}\lib\File\Copy.pm"
  File "${C_PERL_DIR}\lib\File\Glob.pm"
  File "${C_PERL_DIR}\lib\File\Spec.pm"

  SetOutPath "$G_MPLIBDIR\File\Spec"
  File "${C_PERL_DIR}\lib\File\Spec\Unix.pm"
  File "${C_PERL_DIR}\lib\File\Spec\Win32.pm"

  SetOutPath "$G_MPLIBDIR\Getopt"
  File "${C_PERL_DIR}\lib\Getopt\Long.pm"

  SetOutPath "$G_MPLIBDIR\HTML"
  File "${C_PERL_DIR}\lib\HTML\Tagset.pm"
  File "${C_PERL_DIR}\site\lib\HTML\Template.pm"

  SetOutPath "$G_MPLIBDIR\IO"
  File "${C_PERL_DIR}\lib\IO\*"

  SetOutPath "$G_MPLIBDIR\IO\Socket"
  File "${C_PERL_DIR}\lib\IO\Socket\*"

  SetOutPath "$G_MPLIBDIR\MIME"
  File "${C_PERL_DIR}\lib\MIME\*"

  SetOutPath "$G_MPLIBDIR\Sys"
  File "${C_PERL_DIR}\lib\Sys\*"

  SetOutPath "$G_MPLIBDIR\Text"
  File "${C_PERL_DIR}\lib\Text\ParseWords.pm"

  SetOutPath "$G_MPLIBDIR\Time"
  File "${C_PERL_DIR}\lib\Time\Local.pm"
  File "${C_PERL_DIR}\site\lib\Time\Zone.pm"

  SetOutPath "$G_MPLIBDIR\warnings"
  File "${C_PERL_DIR}\lib\warnings\register.pm"

  SetOutPath "$G_MPLIBDIR\auto\Digest\MD5"
  File "${C_PERL_DIR}\lib\auto\Digest\MD5\*"

  SetOutPath "$G_MPLIBDIR\auto\DynaLoader"
  File "${C_PERL_DIR}\lib\auto\DynaLoader\*"

  SetOutPath "$G_MPLIBDIR\auto\Fcntl"
  File "${C_PERL_DIR}\lib\auto\Fcntl\Fcntl.dll"

  SetOutPath "$G_MPLIBDIR\auto\File\Glob"
  File "${C_PERL_DIR}\lib\auto\File\Glob\*"

  SetOutPath "$G_MPLIBDIR\auto\IO"
  File "${C_PERL_DIR}\lib\auto\IO\*"

  SetOutPath "$G_MPLIBDIR\auto\MIME\Base64"
  File "${C_PERL_DIR}\lib\auto\MIME\Base64\*"

  SetOutPath "$G_MPLIBDIR\auto\POSIX"
  File "${C_PERL_DIR}\lib\auto\POSIX\POSIX.dll"
  File "${C_PERL_DIR}\lib\auto\POSIX\autosplit.ix"
  File "${C_PERL_DIR}\lib\auto\POSIX\load_imports.al"

  SetOutPath "$G_MPLIBDIR\auto\Socket"
  File "${C_PERL_DIR}\lib\auto\Socket\*"

  SetOutPath "$G_MPLIBDIR\auto\Sys\Hostname"
  File "${C_PERL_DIR}\lib\auto\Sys\Hostname\*"

  ; Install Perl modules and library files for BerkeleyDB support. Although POPFile now uses
  ; SQLite (or another SQL database) to store the corpus and other essential data, it retains
  ; the ability to automatically convert old BerkeleyDB format corpus files to the SQL database
  ; format. Therefore the installer still installs the BerkeleyDB Perl components.

  SetOutPath "$G_MPLIBDIR"
  File "${C_PERL_DIR}\site\lib\BerkeleyDB.pm"
  File "${C_PERL_DIR}\lib\UNIVERSAL.pm"

  SetOutPath "$G_MPLIBDIR\auto\BerkeleyDB"
  File "${C_PERL_DIR}\site\lib\auto\BerkeleyDB\autosplit.ix"
  File "${C_PERL_DIR}\site\lib\auto\BerkeleyDB\BerkeleyDB.bs"
  File "${C_PERL_DIR}\site\lib\auto\BerkeleyDB\BerkeleyDB.dll"
  File "${C_PERL_DIR}\site\lib\auto\BerkeleyDB\BerkeleyDB.exp"
  File "${C_PERL_DIR}\site\lib\auto\BerkeleyDB\BerkeleyDB.lib"

  ; Install Perl modules and library files for SQLite support

  SetOutPath "$G_MPLIBDIR"
  File "${C_PERL_DIR}\lib\base.pm"
  File "${C_PERL_DIR}\lib\overload.pm"
  File "${C_PERL_DIR}\lib\DBI.pm"

  ; Required in order to use any version of SQLite

  SetOutPath "$G_MPLIBDIR\auto\DBI"
  File "${C_PERL_DIR}\lib\auto\DBI\DBI.bs"
  File "${C_PERL_DIR}\lib\auto\DBI\DBI.dll"
  File "${C_PERL_DIR}\lib\auto\DBI\DBI.exp"
  File "${C_PERL_DIR}\lib\auto\DBI\DBI.lib"

  ; Install SQLite2 support. The 0.22.5 release is based upon ActivePerl 5.8.8 Build 819
  ; which includes the 3.x flavour of the DBD::SQLite module so we now default to using
  ; DBD::SQLite2 since POPFile 0.22.x is not compatible with SQLite 3.x. The 0.23.0 release
  ; of POPFile ia expected to use SQLite 3.x.

  SetOutPath "$G_MPLIBDIR\DBD"
  File "${C_PERL_DIR}\site\lib\DBD\SQLite2.pm"

  SetOutPath "$G_MPLIBDIR\auto\DBD\SQLite2"
  File "${C_PERL_DIR}\site\lib\auto\DBD\SQLite2\SQLite2.bs"
  File "${C_PERL_DIR}\site\lib\auto\DBD\SQLite2\SQLite2.dll"
  File "${C_PERL_DIR}\site\lib\auto\DBD\SQLite2\SQLite2.exp"
  File "${C_PERL_DIR}\site\lib\auto\DBD\SQLite2\SQLite2.lib"

  SetDetailsPrint textonly
  DetailPrint "$(PFI_LANG_INST_PROG_ENDSEC)"
  SetDetailsPrint listonly

  !insertmacro SECTIONLOG_EXIT "Minimal Perl"

; SectionEnd

#--------------------------------------------------------------------------
# End of 'installer-SecMinPerl-body.nsh'
#--------------------------------------------------------------------------
