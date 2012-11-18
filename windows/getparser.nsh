#--------------------------------------------------------------------------
#
# getparser.nsh --- Japanese (Nihongo) text does not use spaces between words so
#                   POPFile uses a 'Nihongo Parser' to split the text into words
#                   to allow the text to be analysed properly. POPFile 0.22.5
#                   (and earlier) only supported the 'Kakasi' parser. Starting
#                   with the 1.0.0 release POPFile offers a choice of 3 parsers
#                   (Kakasi, MeCab and internal). To make it easier to change
#                   the Nihongo Parser a "Change" option is created in the
#                   "Add/Remove Programs" entry for POPFile. This new option
#                   is handled by the POPFile uninstaller.
#
#                   The 'MeCab' parser is too big (about 13 MB) to include in the
#                   installer so if necessary it is downloaded from the Internet
#                   when the user selects the MeCab parser.
#
#                   Since the installer and uninstaller both need to offer a choice
#                   of Nihongo Parser and may need to download the MeCab files, this
#                   INCLUDE file contains macro-based SECTION and FUNCTION definitions
#                   to make future maintenance easier.
#
# Copyright (c) 2007-2012 John Graham-Cumming
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

#--------------------------------------------------------------------------
# URLs used to download the 'MeCab' parser support files from the POPFile
# website (the Perl package, Windows binaries and the large dictionary files
# are too big to include in the POPFile installer)
#--------------------------------------------------------------------------

  !ifndef C_MD5SUMS_FILE
    !define C_MD5SUMS_FILE    "MD5SUMS"
  !endif

  !ifndef C_MECAB_MD5
    !define C_MECAB_MD5       "mecab.md5"
  !endif

  !define C_MECAB_PERL_TGZ    "MeCab.tar.gz"
  !define C_MECAB_DICT_ZIP    "mecab-ipadic.zip"

  !define C_NPD_MD5SUMS       "http://getpopfile.org/installer/nihongo/mecab/${C_MD5SUMS_FILE}"
  !define C_NPD_MECAB_MD5     "http://getpopfile.org/installer/nihongo/mecab/${C_MECAB_MD5}"

  !define C_NPD_MECAB_PERL    "http://getpopfile.org/installer/nihongo/mecab/${C_MECAB_PERL_TGZ}"
  !define C_NPD_MECAB_DICT    "http://getpopfile.org/installer/nihongo/mecab/${C_MECAB_DICT_ZIP}"

#--------------------------------------------------------------------------
# User Registers (Global)
#--------------------------------------------------------------------------

  Var G_MECAB_FILEURL         ; full URL used to download a MeCab file

  Var G_PLS_FIELD_2           ; used to customise translated text strings

#==============================================================================================
#
# Macro-based Sections which may be used by the installer and uninstaller
#
#    Macro:               SECTION_NIHONGO_PARSER
#    Installer Section:   Section "Nihongo Parser" SecParser
#    Uninstaller Section: un.Section "Nihongo Parser" un.SecParser
#
#    Macro:               SECTION_KAKASI
#    Installer Section:   Section "-Kakasi" SecKakasi
#    Uninstaller Section: un.Section "-Kakasi" un.SecKakasi
#
#    Macro:               SECTION_MECAB
#    Installer Section:   Section "-MeCab" SecMeCab
#    Uninstaller Section: un.Section "-MeCab" un.SecMeCab
#
#    Macro:               SECTION_INTERNALPARSER
#    Installer Section:   Section "-Internal" SecInternalParser
#    Uninstaller Section: un.Section "-Internal" un.SecInternalParser
#
#==============================================================================================


#--------------------------------------------------------------------------
# Macro: SECTION_NIHONGO_PARSER
#
# The installation process and the uninstall process both need a 'Nihongo Parser'
# section which is listed on the COMPONENTS page when the Nihongo (Japanese) language
# has been selected, otherwise it is hidden by the 'ShowOrHideNihongoParser' function
# (or the equivalent uninstaller function). This macro makes maintenance easier by
# ensuring that both processes do the same thing.
#
# If an English-only build of the installer or uninstaller is used then this section
# must appear in the COMPONENTS page in case the user needs to install a parser.
#
# Note that this section must always be executed and must always come before
# the sections for the 'Kakasi', 'MeCab' and 'Internal' Nihongo parsers as
# it performs some essential initialisation.
#
#--------------------------------------------------------------------------

!macro SECTION_NIHONGO_PARSER UN
  Section "${UN}Nihongo Parser" ${UN}SecParser
    !if '${UN}' == 'un.'
      StrCmp $G_UNINST_MODE "uninstall" skip_section
    !endif

    SectionIn RO

    !insertmacro SECTIONLOG_ENTER "Nihongo Parser"

    DeleteRegValue HKLM "Software\POPFile Project\${C_PFI_PRODUCT}\MRI" "NihongoParser"

    DetailPrint "Removed the 'NihongoParser' setting from the registry (HKLM)"

    !insertmacro SECTIONLOG_EXIT "Nihongo Parser"

    !if '${UN}' == 'un.'
      skip_section:
    !endif
  SectionEnd
!macroend


#--------------------------------------------------------------------------
# Macro: NIHONGO_PERL_SUPPORT
#
# When processing 'Nihongo' (i.e. Japanese) text POPFile needs some Perl
# packages which are not part of the basic minimal Perl. All three parsers
# are assumed to have similar Perl requirements so we install more or less
# the same extra Perl packages for each parser (hence this macro).
#
# In order to keep the size of the uninstaller down (and thus reduce the
# overall size of the installer) we only install these extra Perl packages
# when _installing_ POPFile.
#
# To Do:
# When the uninstaller is used to _change_ the selected Nihongo parser
# an error message asking the user to re-run the installer should be shown
# if it looks like these extra Perl packages are missing from the existing
# installation.
#--------------------------------------------------------------------------

!macro NIHONGO_PERL_SUPPORT PARSER

    !if '${UN}' != 'un.'

        ;--------------------------------------------------------------------------
        ; Install Perl modules: base.pm, bytes.pm, the Encode collection and,
        ; if relevant, Text::Kakasi (the requirement for bytes_heavy.pl was
        ; added when the minimal Perl was updated to use ActivePerl 5.8.7)
        ;--------------------------------------------------------------------------

        SetOutPath "$G_MPLIBDIR"
        File "${C_PERL_DIR}\site\lib\base.pm"
        File "${C_PERL_DIR}\lib\bytes.pm"
        File "${C_PERL_DIR}\lib\bytes_heavy.pl"
        File "${C_PERL_DIR}\site\lib\Encode.pm"

        SetOutPath "$G_MPLIBDIR\Encode"
        File "${C_PERL_DIR}\site\lib\Encode\Alias.pm"
        File "${C_PERL_DIR}\site\lib\Encode\Byte.pm"
        File "${C_PERL_DIR}\site\lib\Encode\CJKConstants.pm"
        File "${C_PERL_DIR}\site\lib\Encode\CN.pm"
        File "${C_PERL_DIR}\site\lib\Encode\Config.pm"
        File "${C_PERL_DIR}\site\lib\Encode\EBCDIC.pm"
        File "${C_PERL_DIR}\site\lib\Encode\Encoder.pm"
        File "${C_PERL_DIR}\site\lib\Encode\Encoding.pm"
        File "${C_PERL_DIR}\site\lib\Encode\GSM0338.pm"
        File "${C_PERL_DIR}\site\lib\Encode\Guess.pm"
        File "${C_PERL_DIR}\site\lib\Encode\JP.pm"
        File "${C_PERL_DIR}\site\lib\Encode\KR.pm"
        File "${C_PERL_DIR}\site\lib\Encode\Symbol.pm"
        File "${C_PERL_DIR}\site\lib\Encode\TW.pm"
        File "${C_PERL_DIR}\site\lib\Encode\Unicode.pm"

        SetOutPath "$G_MPLIBDIR\auto\Encode"
        File "${C_PERL_DIR}\site\lib\auto\Encode\Encode.dll"

        SetOutPath "$G_MPLIBDIR\auto\Encode\Byte"
        File "${C_PERL_DIR}\site\lib\auto\Encode\Byte\Byte.dll"

        SetOutPath "$G_MPLIBDIR\auto\Encode\CN"
        File "${C_PERL_DIR}\site\lib\auto\Encode\CN\CN.dll"

        SetOutPath "$G_MPLIBDIR\auto\Encode\EBCDIC"
        File "${C_PERL_DIR}\site\lib\auto\Encode\EBCDIC\EBCDIC.dll"

        SetOutPath "$G_MPLIBDIR\auto\Encode\JP"
        File "${C_PERL_DIR}\site\lib\auto\Encode\JP\JP.dll"

        SetOutPath "$G_MPLIBDIR\auto\Encode\KR"
        File "${C_PERL_DIR}\site\lib\auto\Encode\KR\KR.dll"

        SetOutPath "$G_MPLIBDIR\auto\Encode\Symbol"
        File "${C_PERL_DIR}\site\lib\auto\Encode\Symbol\Symbol.dll"

        SetOutPath "$G_MPLIBDIR\auto\Encode\TW"
        File "${C_PERL_DIR}\site\lib\auto\Encode\TW\TW.dll"

        SetOutPath "$G_MPLIBDIR\auto\Encode\Unicode"
        File "${C_PERL_DIR}\site\lib\auto\Encode\Unicode\Unicode.dll"

        SetOutPath "$G_MPLIBDIR\Encode\CN"
        File "${C_PERL_DIR}\site\lib\Encode\CN\HZ.pm"

        SetOutPath "$G_MPLIBDIR\Encode\JP"
        File "${C_PERL_DIR}\site\lib\Encode\JP\H2Z.pm"
        File "${C_PERL_DIR}\site\lib\Encode\JP\JIS7.pm"

        SetOutPath "$G_MPLIBDIR\Encode\KR"
        File "${C_PERL_DIR}\site\lib\Encode\KR\2022_KR.pm"

        SetOutPath "$G_MPLIBDIR\Encode\MIME"
        File "${C_PERL_DIR}\site\lib\Encode\MIME\Header.pm"
        File "${C_PERL_DIR}\site\lib\Encode\MIME\Name.pm"

        SetOutPath "$G_MPLIBDIR\Encode\MIME\Header"
        File "${C_PERL_DIR}\site\lib\Encode\MIME\Header\ISO_2022_JP.pm"

        SetOutPath "$G_MPLIBDIR\Encode\Unicode"
        File "${C_PERL_DIR}\site\lib\Encode\Unicode\UTF7.pm"

        ;--------------------------------------------------------------------------
        ; For the 1.1.1 release File::Glob::Windows and the necessary support files
        ; were added to solve problems when the 'User Data' is installed using
        ; a path containing non-ASCII characters (e.g. when the Windows login
        ; name is a Japanese name)
        ;--------------------------------------------------------------------------

        SetOutPath "$G_MPLIBDIR"
        File "${C_PERL_DIR}\lib\DirHandle.pm"

        SetOutPath "$G_MPLIBDIR\File\Glob"
        File "${C_PERL_DIR}\site\lib\File\Glob\Windows.pm"

        SetOutPath "$G_MPLIBDIR\Win32\"
        File "${C_PERL_DIR}\site\lib\Win32\API.pm"

        SetOutPath "$G_MPLIBDIR\Win32\API"
        File "${C_PERL_DIR}\site\lib\Win32\API\Callback.pm"
        File "${C_PERL_DIR}\site\lib\Win32\API\Struct.pm"
        File "${C_PERL_DIR}\site\lib\Win32\API\Test.pm"
        File "${C_PERL_DIR}\site\lib\Win32\API\Type.pm"
              SetOutPath "$G_MPLIBDIR\auto\Win32\API"
              File "${C_PERL_DIR}\site\lib\auto\Win32\API\API.dll"
              SetOutPath "$G_MPLIBDIR\auto\Win32\API\Callback"
              File "${C_PERL_DIR}\site\lib\auto\Win32\API\Callback\Callback.dll"
              SetOutPath "$G_MPLIBDIR"

    !endif

    !if '${PARSER}' == 'kakasi'
        SetOutPath "$G_MPLIBDIR\Text"
        File "${C_PERL_DIR}\site\lib\Text\Kakasi.pm"

        SetOutPath "$G_MPLIBDIR\auto\Text\Kakasi"
        File "${C_PERL_DIR}\site\lib\auto\Text\Kakasi\Kakasi.dll"
    !endif

!macroend


#--------------------------------------------------------------------------
# Macro: SECTION_KAKASI
#
# The installation process and the uninstall process both need a section which
# installs the 'Kakasi' parser, one of the three parsers supported by POPFile.
# This macro makes maintenance easier by ensuring that both processes do the
# same thing.
#
# Although the COMPONENTS page will show a 'Nihongo Parser' component when the
# installer language is set to 'Nihongo' (or when an English-only build of the
# installer or uninstaller is used), the individual parser components are never
# shown on the COMPONENTS page.
#--------------------------------------------------------------------------

!macro SECTION_KAKASI UN
  Section "-${UN}Kakasi" ${UN}SecKakasi
    !if '${UN}' == 'un.'
      StrCmp $G_UNINST_MODE "uninstall" skip_section
    !endif

    !insertmacro SECTIONLOG_ENTER "Kakasi"

    StrCmp $G_PARSER "kakasi" 0 do_nothing

    !define L_RESERVED  $0    ; used in system.dll call

    Push ${L_RESERVED}

    ;--------------------------------------------------------------------------
    ; Install Kakasi package
    ;--------------------------------------------------------------------------

    SetOutPath "$G_ROOTDIR"
    File /r "${C_KAKASI_DIR}\kakasi"

    ; Add Environment Variables for Kakasi

    Push "ITAIJIDICTPATH"
    Push "$G_ROOTDIR\kakasi\share\kakasi\itaijidict"

    StrCmp $G_WINUSERTYPE "Admin" all_users_1
    Call ${UN}PFI_WriteEnvStr
    Goto next_var

  all_users_1:
    Call ${UN}PFI_WriteEnvStrNTAU

  next_var:
    Push "KANWADICTPATH"
    Push "$G_ROOTDIR\kakasi\share\kakasi\kanwadict"

    StrCmp $G_WINUSERTYPE "Admin" all_users_2
    Call ${UN}PFI_WriteEnvStr
    Goto set_env

  all_users_2:
    Call ${UN}PFI_WriteEnvStrNTAU

  set_env:
    IfRebootFlag set_vars_now

    ; Running on a non-Win9x system which already has the correct Kakasi environment data
    ; or running on a non-Win9x system

    Call ${UN}NSIS_IsNT
    Pop ${L_RESERVED}
    StrCmp ${L_RESERVED} "0" update_minPerl

    ; Running on a non-Win9x system so we ensure the Kakasi environment variables
    ; are updated to match this installation

  set_vars_now:
    System::Call 'Kernel32::SetEnvironmentVariableA(t, t) \
                  i("ITAIJIDICTPATH", "$G_ROOTDIR\kakasi\share\kakasi\itaijidict").r0'
    StrCmp ${L_RESERVED} 0 0 itaiji_set_ok
    MessageBox MB_OK|MB_ICONSTOP "$(PFI_LANG_CONVERT_ENVNOTSET) (ITAIJIDICTPATH)"

  itaiji_set_ok:
    System::Call 'Kernel32::SetEnvironmentVariableA(t, t) \
                  i("KANWADICTPATH", "$G_ROOTDIR\kakasi\share\kakasi\kanwadict").r0'
    StrCmp ${L_RESERVED} 0 0 update_minPerl
    MessageBox MB_OK|MB_ICONSTOP "$(PFI_LANG_CONVERT_ENVNOTSET) (KANWADICTPATH)"

  update_minPerl:
    !insertmacro NIHONGO_PERL_SUPPORT "kakasi"

    WriteRegStr HKLM "Software\POPFile Project\${C_PFI_PRODUCT}\MRI" "NihongoParser" "$G_PARSER"
    DetailPrint ""
    DetailPrint "'NihongoParser' setting in registry (HKLM) updated to '$G_PARSER'"

    !if '${UN}' == 'un.'
        ReadINIStr ${L_RESERVED} "$G_COMMS_FILE" "RealUser" "Parser"
        StrCmp ${L_RESERVED} $G_PARSER no_change
        SetDetailsPrint none
        UAC::StackPush "$G_PARSER"
        GetFunctionAddress ${L_RESERVED} un.SetNihongoConfig
        UAC::ExecCodeSegment ${L_RESERVED}
        SetDetailsPrint listonly
        DetailPrint ""
        DetailPrint "'bayes_nihongo_parser' setting in 'popfile.cfg' updated to '$G_PARSER'"

      no_change:
    !endif

    SetDetailsPrint textonly
    DetailPrint ""
    DetailPrint "$(PFI_LANG_INST_PROG_ENDSEC)"
    SetDetailsPrint listonly

    Pop ${L_RESERVED}

    !undef L_RESERVED

   do_nothing:
    !insertmacro SECTIONLOG_EXIT "Kakasi"

    !if '${UN}' == 'un.'
      skip_section:
    !endif
  SectionEnd
!macroend


#--------------------------------------------------------------------------
# Macro: SECTION_MECAB
#
# The installation process and the uninstall process both need a section which
# downloads and installs the 'MeCab' parser, one of the three parsers supported
# by POPFile. This macro makes maintenance easier by ensuring that both processes
# do the same thing.
#
# The MeCab package is a large download (over 12 MB) which could take a long time,
# especially for users with a dial-up connection. If the selected installation
# folder already contains a valid copy of the MeCab package then there is no need
# to download the package again.
#
# Although the COMPONENTS page will show a 'Nihongo Parser' component when the
# installer language is set to 'Nihongo' (or when an English-only build of the
# installer or uninstaller is used), the individual parser components are never
# shown on the COMPONENTS page.
#--------------------------------------------------------------------------

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
    Call ${UN}NSIS_TrimNewlines
    Pop ${L_DATA}
    StrCmp ${L_DATA} "" read_next_line
    StrCpy ${L_RESULT} ${L_DATA} "" 34       ; NSIS strings start at position 0 not 1
    StrCmp ${L_RESULT} ${L_MD5NAME} 0 read_next_line
    StrCpy ${L_RESULT} ${L_DATA} 32
    Push ${L_RESULT}
    Call ${UN}PFI_StrCheckHexadecimal
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

!insertmacro FUNCTION_EXTRACTMD5SUM       ""
!insertmacro FUNCTION_EXTRACTMD5SUM       "un."

!macro CODEBLOCK_CHECK_MD5SUM_FOR_FILE FILENAME

  !insertmacro PFI_UNIQUE_ID

    md5dll::GetMD5File "$PLUGINSDIR\${FILENAME}"
    Pop ${L_RESULT}
    DetailPrint ""
    DetailPrint "Calculated MD5 sum for ${FILENAME}: ${L_RESULT}"
    Push "${FILENAME}"
    Call ${UN}ExtractMD5sum
    Pop $G_PLS_FIELD_1
    DetailPrint "Downloaded MD5 sum for ${FILENAME}: $G_PLS_FIELD_1"
    StrCmp $G_PLS_FIELD_1 ${L_RESULT} continue_${PFI_UNIQUE_ID}
    DetailPrint "MD5 sums differ!"
    MessageBox MB_OK|MB_ICONEXCLAMATION "'${FILENAME}' file has bad checksum!"
    Goto installer_error_exit

  continue_${PFI_UNIQUE_ID}:
!macroend

!macro SECTION_MECAB UN
  Section "-${UN}MeCab" ${UN}SecMeCab
    !if '${UN}' == 'un.'
      StrCmp $G_UNINST_MODE "uninstall" skip_section
    !endif

    !insertmacro SECTIONLOG_ENTER "MeCab"

    StrCmp $G_PARSER "mecab" 0 do_nothing

    ; The main installer does not contain the MeCab support files so we provide an estimate
    ; which includes a slack space allowance (based upon the development system's statistics)

    AddSize 43000

    !define L_RESERVED    $0    ; used in system.dll call

    !define L_RESULT      $R0   ; result from 'GetMeCabFile' function or the 'untgz' plugin
                                ; WARNING: The 'untgz' plugin is hard-coded to use $R0

    !define L_LISTSIZE    $R1   ; number of patches to be applied

    Push ${L_RESERVED}
    Push ${L_RESULT}
    Push ${L_LISTSIZE}

    ; Install the necessary extra Perl packages required by the MeCab parser. If there is a
    ; problem downloading or installing the MeCab parser then POPFile will automatically
    ; use the internal parser instead. Since the internal parser requires the same set of
    ; extra Perl packages, we install them now in order to keep the MeCab install code simple.

    !insertmacro NIHONGO_PERL_SUPPORT "mecab"

    ; Use MD5 sums to check the integrity of the Mecab files we download

    Push "${C_NPD_MD5SUMS}"
    Call ${UN}GetMeCabFile
    Pop ${L_RESULT}
    StrCmp ${L_RESULT} "OK" 0 installer_error_exit

    Push "${C_NPD_MECAB_MD5}"
    Call ${UN}GetMeCabFile
    Pop ${L_RESULT}
    StrCmp ${L_RESULT} "OK" 0 installer_error_exit

    !insertmacro CODEBLOCK_CHECK_MD5SUM_FOR_FILE "${C_MECAB_MD5}"

    IfFileExists "$G_ROOTDIR\mecab\etc\mecabrc" 0 download_mecab
    Push "$G_ROOTDIR\mecab"
    Call ${UN}VerifyMeCabInstall
    Pop ${L_RESULT}
    StrCmp ${L_RESULT} "OK" set_environment

    ; Download the MeCab archives

  download_mecab:
    Push "${C_NPD_MECAB_PERL}"
    Call ${UN}GetMeCabFile
    Pop ${L_RESULT}
    StrCmp ${L_RESULT} "OK" 0 installer_error_exit

    !insertmacro CODEBLOCK_CHECK_MD5SUM_FOR_FILE "${C_MECAB_PERL_TGZ}"

    Push "${C_NPD_MECAB_DICT}"
    Call ${UN}GetMeCabFile
    Pop ${L_RESULT}
    StrCmp ${L_RESULT} "OK" 0 installer_error_exit

    !insertmacro CODEBLOCK_CHECK_MD5SUM_FOR_FILE "${C_MECAB_DICT_ZIP}"

    ; Now install the files required for the MeCab parser

    StrCpy $G_PLS_FIELD_1 "$G_ROOTDIR\lib"
    DetailPrint ""
    CreateDirectory $G_PLS_FIELD_1
    SetDetailsPrint both
    StrCpy $G_PLS_FIELD_2 "MeCab.tar.gz"
    DetailPrint "$(PFI_LANG_PROG_FILEEXTRACT)"
    SetDetailsPrint listonly
    untgz::extractFile -j -d "$G_PLS_FIELD_1" "$PLUGINSDIR\MeCab.tar.gz" "MeCab.pm"
    StrCmp ${L_RESULT} "success" 0 error_exit

    StrCpy $G_PLS_FIELD_1 "$G_ROOTDIR\lib\auto\MeCab"
    DetailPrint ""
    CreateDirectory $G_PLS_FIELD_1
    SetDetailsPrint both
    StrCpy $G_PLS_FIELD_2 "MeCab.tar.gz"
    DetailPrint "$(PFI_LANG_PROG_FILEEXTRACT)"
    SetDetailsPrint listonly
    untgz::extractV -j -d "$G_PLS_FIELD_1" "$PLUGINSDIR\MeCab.tar.gz" -i "MeCab.bs" "MeCab.dll" --
    StrCmp ${L_RESULT} "success" check_bs_file

  error_exit:
    SetDetailsPrint listonly
    DetailPrint ""
    SetDetailsPrint both
    DetailPrint "$(PFI_LANG_MB_UNPACKFAIL)"
    SetDetailsPrint listonly
    DetailPrint ""
    MessageBox MB_OK|MB_ICONSTOP "$(PFI_LANG_MB_UNPACKFAIL)"

  installer_error_exit:
    StrCpy $G_PLS_FIELD_1 "(undefined)"
    MessageBox MB_OK|MB_ICONEXCLAMATION "${C_NPLS_REPEATMECAB}"
    Goto exit

  check_bs_file:

    ; 'untgz' versions earlier than 1.0.6 (released 28 November 2004) are unable to extract
    ; empty files so this script creates the empty 'MeCab.bs' file if necessary

    IfFileExists "$G_PLS_FIELD_1\MeCab.bs" unpack_dictionaries
    File "/oname=$G_PLS_FIELD_1\MeCab.bs" "zerobyte.file"

  unpack_dictionaries:
    Push "$G_ROOTDIR"
    Call ${UN}UnpackDictionaries
    Pop ${L_RESULT}

  set_environment:

    ; Add the Environment Variable for MeCab

    Push "MECABRC"
    Push "$G_ROOTDIR\mecab\etc\mecabrc"

    StrCmp $G_WINUSERTYPE "Admin" all_users_1
    Call ${UN}PFI_WriteEnvStr
    Goto set_env

  all_users_1:
    Call ${UN}PFI_WriteEnvStrNTAU

  set_env:
    IfRebootFlag set_vars_now

    ; Running on a non-Win9x system which already has the correct MeCab environment data
    ; or running on a non-Win9x system

    Call ${UN}NSIS_IsNT
    Pop ${L_RESERVED}
    StrCmp ${L_RESERVED} "0" set_parser_in_registry

    ; Running on a non-Win9x system so we ensure the MeCab environment variable
    ; is updated to match this installation

  set_vars_now:
    System::Call 'Kernel32::SetEnvironmentVariableA(t, t) \
                  i("MECABRC", "$G_ROOTDIR\mecab\etc\mecabrc").r0'
    StrCmp ${L_RESERVED} 0 0 set_parser_in_registry
    MessageBox MB_OK|MB_ICONSTOP "$(PFI_LANG_CONVERT_ENVNOTSET) (MECABRC)"

  set_parser_in_registry:
    WriteRegStr HKLM "Software\POPFile Project\${C_PFI_PRODUCT}\MRI" "NihongoParser" "$G_PARSER"
    DetailPrint ""
    DetailPrint "'NihongoParser' setting in registry (HKLM) updated to '$G_PARSER'"

    !if '${UN}' == 'un.'
        ReadINIStr ${L_RESERVED} "$G_COMMS_FILE" "RealUser" "Parser"
        StrCmp ${L_RESERVED} $G_PARSER no_change
        SetDetailsPrint none
        UAC::StackPush "$G_PARSER"
        GetFunctionAddress ${L_RESERVED} un.SetNihongoConfig
        UAC::ExecCodeSegment ${L_RESERVED}
        SetDetailsPrint listonly
        DetailPrint ""
        DetailPrint "'bayes_nihongo_parser' setting in 'popfile.cfg' updated to '$G_PARSER'"

      no_change:
    !endif

  exit:
    SetDetailsPrint textonly
    DetailPrint ""
    DetailPrint "$(PFI_LANG_INST_PROG_ENDSEC)"
    SetDetailsPrint listonly

    Pop ${L_LISTSIZE}
    Pop ${L_RESULT}
    Pop ${L_RESERVED}

    !undef L_RESERVED

    !undef L_RESULT
    !undef L_LISTSIZE

  do_nothing:
    !insertmacro SECTIONLOG_EXIT "MeCab"

    !if '${UN}' == 'un.'
      skip_section:
    !endif
  SectionEnd
!macroend


#--------------------------------------------------------------------------
# Macro: SECTION_INTERNALPARSER
#
# The installation process and the uninstall process both need a section which
# installs the 'Internal' parser, one of the three parsers supported by POPFile.
# This macro makes maintenance easier by ensuring that both processes do the
# same thing.
#
# Although the COMPONENTS page will show a 'Nihongo Parser' component when the
# installer language is set to 'Nihongo' (or when an English-only build of the
# installer or uninstaller is used), the individual parser components are never
# shown on the COMPONENTS page.
#--------------------------------------------------------------------------

!macro SECTION_INTERNALPARSER UN
  Section "-${UN}Internal" ${UN}SecInternalParser
    !if '${UN}' == 'un.'
      StrCmp $G_UNINST_MODE "uninstall" skip_section
    !endif

    !insertmacro SECTIONLOG_ENTER "Internal Parser"
    StrCmp $G_PARSER "internal" 0 do_nothing

    SetDetailsPrint textonly
    DetailPrint "Internal parser selected"
    SetDetailsPrint listonly

    !insertmacro NIHONGO_PERL_SUPPORT "internal"

    WriteRegStr HKLM "Software\POPFile Project\${C_PFI_PRODUCT}\MRI" "NihongoParser" "$G_PARSER"
    DetailPrint ""
    DetailPrint "'NihongoParser' setting in registry (HKLM) updated to '$G_PARSER'"

    !if '${UN}' == 'un.'
        Push $G_PLS_FIELD_1
        ReadINIStr $G_PLS_FIELD_1 "$G_COMMS_FILE" "RealUser" "Parser"
        StrCmp $G_PLS_FIELD_1 $G_PARSER no_change
        SetDetailsPrint none
        UAC::StackPush "$G_PARSER"
        GetFunctionAddress $G_PLS_FIELD_1 un.SetNihongoConfig
        UAC::ExecCodeSegment $G_PLS_FIELD_1
        SetDetailsPrint listonly
        DetailPrint ""
        DetailPrint "'bayes_nihongo_parser' setting in 'popfile.cfg' updated to '$G_PARSER'"
        Pop $G_PLS_FIELD_1

      no_change:
    !endif

    SetDetailsPrint textonly
    DetailPrint ""
    DetailPrint "$(PFI_LANG_INST_PROG_ENDSEC)"
    SetDetailsPrint listonly

  do_nothing:
    !insertmacro SECTIONLOG_EXIT "Internal Parser"

    !if '${UN}' == 'un.'
      skip_section:
    !endif
  SectionEnd
!macroend


#==============================================================================================
#
# Macro-based Functions which may be used by the installer and uninstaller
#
#    Macro:                FUNCTION_VERIFY_MECAB_INSTALL
#    Installer Function:   VerifyMeCabInstall
#    Uninstaller Function: un.VerifyMeCabInstall
#
#    Macro:                FUNCTION_UNPACK_DICTIONARIES
#    Installer Function:   UnpackDictionaries
#    Uninstaller Function: un.UnpackDictionaries
#
#    Macro:                FUNCTION_GETMECABFILE
#    Installer Function:   GetMeCabFile
#    Uninstaller Function: un.GetMeCabFile
#
#    Macro:                FUNCTION_SHOW_OR_HIDE_NIHONGO_PARSER
#    Installer Function:   ShowOrHideNihongoParser
#    Uninstaller Function: un.ShowOrHideNihongoParser
#
#    Macro:                FUNCTION_CHOOSEPARSER
#    Installer Function:   ChooseParser
#    Uninstaller Function: un.ChooseParser
#
#    Macro:                FUNCTION_HANDLE_PARSER_SELECTION
#    Installer Function:   HandleParserSelection
#    Uninstaller Function: un.HandleParserSelection
#
#==============================================================================================


#--------------------------------------------------------------------------
# Macro: FUNCTION_VERIFY_MECAB_INSTALL
#
# The installation process and the uninstall process may both need a function
# which verifies the contents of the 'mecab' installation folder. This macro
# makes maintenance easier by ensuring that both processes use identical
# functions, with the only difference being their names.
#
# The files in the 'mecab' folder as checked by comparing their MD5 sums against
# the expected values found in the 'mecab.md5' file downloaded from the POPFile
# web site. 'mecab.md5' contains an entry for each file in the Mecab zip file,
# as shown in this extract:
#
#      # MD5 checksums generated by MD5summer (http://www.md5summer.org)
#      # Generated 18/11/07 12:38:45
#
#      dafe94718a85a63809ec1ed2f6652694 *doc/en/bindings.html
#      511cbced26190010bfd8038593d00bf0 *doc/Makefile
#      143a77233074c7b86f7f5328fe81603a *etc/mecabrc
#      4162fab178e43c764adee2da1987964d *AUTHORS
#
# Lines starting with '#' or ';' in 'mecab.md5' are ignored, as are empty lines.
#
# Lines in 'mecab.md5' which contain MD5 sums are assumed to be in this format:
# (a) positions 1 to 32 contain a 32 character hexadecimal number (line starts in column 1)
# (b) column 33 is a space character (' ')
# (c) column 34 is the text/binary flag (' ' = text, '*' = binary)
# (d) column 35 is the first character of the filename (filename terminates with end-of-line)
#     The MeCab zip file contains several folders so the filename is really a relative path.
#
# Inputs:
#         (top of stack)     - full path to the top-level MeCab folder
#
# Outputs:
#         (top of stack)     - result ("OK" or "fail")
#
# Usage (after macro has been 'inserted'):
#
#         Push "C:\Program Files\POPFile\mecab"
#         Call VerifyMeCabInstall
#         Pop $0
#
#         ($R0 at this point is "OK" if the existing installation has same
#         MD5 sums as the current downloadable version of the MeCab zip file)
#
#--------------------------------------------------------------------------

!macro FUNCTION_VERIFY_MECAB_INSTALL UN
  Function ${UN}VerifyMeCabInstall

    !define L_DATA          $R9   ; relative path and expected MD5 sum for a file
    !define L_EXPECTED_MD5  $R8   ; the expected MD5 sum for the file
    !define L_FILEPATH      $R7   ; path to the file to be checked
    !define L_HANDLE        $R6   ; handle used to access the MD5 sums file (mecab.md5)
    !define L_MECABROOT     $R5   ; the top-level MeCab folder (e.g. C:\Program Files\POPFile\mecab)
    !define L_RESULT        $R4   ; result to be returned by this function ("OK" or "fail")
    !define L_TEMP          $R3

    Exch ${L_MECABROOT}

    Push ${L_DATA}
    Push ${L_EXPECTED_MD5}
    Push ${L_FILEPATH}
    Push ${L_HANDLE}
    Push ${L_RESULT}
    Push ${L_TEMP}

    SetPluginUnload alwaysoff

    StrCpy $G_PLS_FIELD_1 "${L_MECABROOT}"
    DetailPrint ""
    SetDetailsPrint both
    DetailPrint "${C_NPLS_VERIFYING_MECAB}"
    SetDetailsPrint listonly
    DetailPrint ""

    StrCpy ${L_RESULT} "OK"

    FileOpen ${L_HANDLE} "$PLUGINSDIR\${C_MECAB_MD5}" r

  read_next_line:
    FileRead ${L_HANDLE} ${L_DATA}
    StrCmp ${L_DATA} "" end_of_file
    StrCpy ${L_TEMP} ${L_DATA} 1
    StrCmp ${L_TEMP} '#' read_next_line
    StrCmp ${L_TEMP} ';' read_next_line
    Push ${L_DATA}
    Call ${UN}NSIS_TrimNewlines
    Pop ${L_DATA}
    StrCmp ${L_DATA} "" read_next_line
    StrCpy ${L_FILEPATH} ${L_DATA} "" 34       ; NSIS strings start at position 0 not 1
    StrCpy $G_PLS_FIELD_1 "${L_FILEPATH} :"
    StrCpy ${L_FILEPATH} "${L_MECABROOT}\${L_FILEPATH}"
    IfFileExists "${L_FILEPATH}" get_expected_MD5
    StrCpy $G_PLS_FIELD_1 "$G_PLS_FIELD_1 missing"
    StrCpy ${L_RESULT} "fail"
    Goto print_result

  get_expected_MD5:
    StrCpy ${L_EXPECTED_MD5} ${L_DATA} 32
    Push ${L_EXPECTED_MD5}
    Call ${UN}PFI_StrCheckHexadecimal
    Pop ${L_EXPECTED_MD5}
    md5dll::GetMD5File "${L_FILEPATH}"
    Pop ${L_TEMP}
    StrCmp ${L_EXPECTED_MD5} ${L_TEMP} sums_match
    StrCpy $G_PLS_FIELD_1 "$G_PLS_FIELD_1 changed"
    StrCpy ${L_RESULT} "fail"
    Goto print_result

  sums_match:
    StrCpy $G_PLS_FIELD_1 "$G_PLS_FIELD_1 OK"

  print_result:
    DetailPrint $G_PLS_FIELD_1
    Goto read_next_line

  end_of_file:
    FileClose ${L_HANDLE}
    StrCpy $G_PLS_FIELD_1 "${L_RESULT}"
    DetailPrint ""
    SetDetailsPrint both
    DetailPrint "${C_NPLS_MECAB_MD5_RESULT}"
    SetDetailsPrint listonly

    SetPluginUnload manual

    ; Now unload the MD5 DLL to allow the $PLUGINSDIR to be removed automatically

    md5dll::GetMD5String "dummy"
    Pop ${L_TEMP}

    StrCpy ${L_MECABROOT} ${L_RESULT}

    Pop ${L_TEMP}
    Pop ${L_RESULT}
    Pop ${L_HANDLE}
    Pop ${L_FILEPATH}
    Pop ${L_EXPECTED_MD5}
    Pop ${L_DATA}

    Exch ${L_MECABROOT}

    !undef L_DATA
    !undef L_EXPECTED_MD5
    !undef L_FILEPATH
    !undef L_HANDLE
    !undef L_MECABROOT
    !undef L_RESULT
    !undef L_TEMP

  FunctionEnd
!macroend


#--------------------------------------------------------------------------
# Macro: FUNCTION_UNPACK_DICTIONARIES
#
# The installation process and the uninstall process may both need a function
# which extracts the dictionary files from the large MeCab ZIP file. This macro
# makes maintenance easier by ensuring that both processes use identical
# functions, with the only difference being their names.
#
# Instead of blindly unzipping 'mecab-ipadic.zip' in one operation, the files
# are extracted one at a time using the path and filename information in the
# 'mecab.md5' file downloaded from the POPFile web site. This is safer than
# simply unzipping the entire file as it make it easy to ensure that no files
# are written outside of the POPFile installation folder. 'mecab.md5' contains
# an entry for each file in the Mecab zip file, as shown in this extract:
#
#      dafe94718a85a63809ec1ed2f6652694 *doc/en/bindings.html
#      511cbced26190010bfd8038593d00bf0 *doc/Makefile
#      143a77233074c7b86f7f5328fe81603a *etc/mecabrc
#      4162fab178e43c764adee2da1987964d *AUTHORS
#
# Lines starting with '#' or ';' in 'mecab.md5' are ignored, as are empty lines.
#
# Lines in 'mecab.md5' which contain MD5 sums are assumed to be in this format:
# (a) positions 1 to 32 contain a 32 character hexadecimal number (line starts in column 1)
# (b) column 33 is a space character (' ')
# (c) column 34 is the text/binary flag (' ' = text, '*' = binary)
# (d) column 35 is the first character of the filename (filename terminates with end-of-line)
#
# NOTE: The MeCab zip file contains several folders nested inside a top-level 'mecab' folder
#       which means that the pathnames in the 'mecab.md5' file are relative to this 'mecab'
#       folder (e.g. the 'doc/en/bindings.html' entry in 'mecab.md5' refers to the file which
#       gets installed at '$G_ROOTDIR\mecab\doc\en\bindings.html' where $G_ROOTDIR is the
#       main POPFile program folder)
#
# Inputs:
#         (top of stack)     - full path to the top-level POPFile program folder
#
# Outputs:
#         (top of stack)     - result ("OK" or "fail")
#
# Usage (after macro has been 'inserted'):
#
#         Push "C:\Program Files\POPFile"
#         Call UnpackDictionaries
#         Pop $0
#
#         ($R0 at this point is "OK" if all of the expected files were
#         successfully extracted from the downloaded MeCab zip file)
#
#--------------------------------------------------------------------------

!macro FUNCTION_UNPACK_DICTIONARIES UN
  Function ${UN}UnpackDictionaries

    !define L_DATA          $R9   ; relative path and expected MD5 sum for a file
    !define L_FILEPATH      $R8   ; relative path to the file to be extracted
    !define L_HANDLE        $R7   ; handle used to access the MD5 sums file (mecab.md5)
    !define L_MECABROOT     $R6   ; the top-level POPFile program folder (e.g. C:\Program Files\POPFile)
    !define L_RESULT        $R5   ; result to be returned by this function ("OK" or "fail")
    !define L_TEMP          $R4

    Exch ${L_MECABROOT}

    Push ${L_DATA}
    Push ${L_FILEPATH}
    Push ${L_HANDLE}
    Push ${L_RESULT}
    Push ${L_TEMP}

    SetPluginUnload alwaysoff

    StrCpy $G_PLS_FIELD_1 "${L_MECABROOT}"
    DetailPrint ""
    SetDetailsPrint both
    DetailPrint "${C_NPLS_UNPACKING_MECAB}"
    SetDetailsPrint listonly
    DetailPrint ""

    StrCpy ${L_RESULT} "OK"

    FileOpen ${L_HANDLE} "$PLUGINSDIR\${C_MECAB_MD5}" r

  read_next_line:
    FileRead ${L_HANDLE} ${L_DATA}
    StrCmp ${L_DATA} "" end_of_file
    StrCpy ${L_TEMP} ${L_DATA} 1
    StrCmp ${L_TEMP} '#' read_next_line
    StrCmp ${L_TEMP} ';' read_next_line
    Push ${L_DATA}
    Call ${UN}NSIS_TrimNewlines
    Pop ${L_DATA}
    StrCmp ${L_DATA} "" read_next_line
    StrCpy ${L_FILEPATH} ${L_DATA} "" 34        ; NSIS strings start at position 0 not 1
    Push ${L_FILEPATH}
    Call ${UN}PFI_StrBackSlash                  ; ensure relative path uses backslashes
    Pop ${L_FILEPATH}
    StrCpy ${L_FILEPATH} "mecab\${L_FILEPATH}"  ; make path relative to ${L_MECABROOT}
    Push "${L_FILEPATH}"
    Push ".."
    Call ${UN}PFI_StrStr
    Pop ${L_TEMP}
    StrCmp ${L_TEMP} "" unpack_file
    StrCpy ${L_TEMP} "- invalid target path"
    Goto unpack_error

  unpack_file:
    StrCpy $G_PLS_FIELD_1 "${L_FILEPATH} :"
    nsUnzip::Extract "/d=${L_MECABROOT}" "$PLUGINSDIR\${C_MECAB_DICT_ZIP}" "${L_FILEPATH}" /END
    Pop ${L_TEMP}
    StrCmp ${L_TEMP} "0" 0 unpack_error
    StrCpy ${L_TEMP} "OK"
    Goto print_result

  unpack_error:
    StrCpy ${L_RESULT} "fail"
    StrCpy ${L_TEMP} "UnZip error ${L_TEMP}"

  print_result:
    DetailPrint "$G_PLS_FIELD_1 ${L_TEMP}"
    Goto read_next_line

  end_of_file:
    FileClose ${L_HANDLE}
    StrCpy $G_PLS_FIELD_1 "${L_RESULT}"
    DetailPrint ""
    SetDetailsPrint both
    DetailPrint "${C_NPLS_MECAB_UNPACK_RESULT}"
    SetDetailsPrint listonly

    SetPluginUnload manual

    ; Now unload the nsUnzip plugin to allow the $PLUGINSDIR to be removed automatically
    ; (the plugin will return an error code because the 'dummy.zip' file does not exist)

    nsUnzip::Extract "/t" "$PLUGINSDIR\dummy.zip" /END
    Pop ${L_TEMP}

    StrCpy ${L_MECABROOT} ${L_RESULT}

    Pop ${L_TEMP}
    Pop ${L_RESULT}
    Pop ${L_HANDLE}
    Pop ${L_FILEPATH}
    Pop ${L_DATA}

    Exch ${L_MECABROOT}

    !undef L_DATA
    !undef L_FILEPATH
    !undef L_HANDLE
    !undef L_MECABROOT
    !undef L_RESULT
    !undef L_TEMP

  FunctionEnd
!macroend


#--------------------------------------------------------------------------
# Macro: FUNCTION_GETMECABFILE
#
# The installation process and the uninstall process may both need a function which
# downloads a single MeCab support file from the POPFile website. This macro makes
# maintenance easier by ensuring that both processes use identical functions, with
# the only difference being their names.
#
# Inputs:
#         (top of stack)     - full URL used to download the MeCab file
#
# Outputs:
#         (top of stack)     - status returned by the download plugin
#
# Usage (after macro has been 'inserted'):
#
#         Push "http://www.example.com/download/MeCab.zip"
#         Call GetMeCabFile
#         Pop $0
#
#         ($R0 at this point is "OK" if the file was downloaded without any errors being detected)
#
#--------------------------------------------------------------------------

  !define C_NSISDL_TRANSLATIONS "/TRANSLATE '$(PFI_LANG_NSISDL_DOWNLOADING)' '$(PFI_LANG_NSISDL_CONNECTING)' '$(PFI_LANG_NSISDL_SECOND)' '$(PFI_LANG_NSISDL_MINUTE)' '$(PFI_LANG_NSISDL_HOUR)' '$(PFI_LANG_NSISDL_PLURAL)' '$(PFI_LANG_NSISDL_PROGRESS)' '$(PFI_LANG_NSISDL_REMAINING)'"

!macro FUNCTION_GETMECABFILE UN
  Function ${UN}GetMeCabFile

    Pop $G_MECAB_FILEURL

    StrCpy $G_PLS_FIELD_1 $G_MECAB_FILEURL
    Push $G_PLS_FIELD_1
    Call ${UN}PFI_StrBackSlash
    Call ${UN}NSIS_GetParent
    Pop $G_PLS_FIELD_2
    StrLen $G_PLS_FIELD_2 $G_PLS_FIELD_2
    IntOp $G_PLS_FIELD_2 $G_PLS_FIELD_2 + 1
    StrCpy $G_PLS_FIELD_1 "$G_PLS_FIELD_1" "" $G_PLS_FIELD_2
    StrCpy $G_PLS_FIELD_2 "$G_MECAB_FILEURL" $G_PLS_FIELD_2
    DetailPrint ""
    DetailPrint "$(PFI_LANG_PROG_STARTDOWNLOAD)"

    !ifndef C_DLTIMEOUT
      !define C_DLTIMEOUT  /CONNECTTIMEOUT=20
    !endif

    inetc::get ${C_DLTIMEOUT} /CAPTION "Internet Download" /RESUME "${C_NPLS_CHECKINTERNET}" ${C_NSISDL_TRANSLATIONS} "$G_MECAB_FILEURL" "$PLUGINSDIR\$G_PLS_FIELD_1" /END
    Pop $G_PLS_FIELD_2

    StrCmp $G_PLS_FIELD_2 "OK" file_received
    SetDetailsPrint both
    DetailPrint "$(PFI_LANG_MB_NSISDLFAIL_1)"
    SetDetailsPrint listonly
    DetailPrint "$(PFI_LANG_MB_NSISDLFAIL_2)"
    MessageBox MB_OK|MB_ICONEXCLAMATION "$(PFI_LANG_MB_NSISDLFAIL_1)${MB_NL}$(PFI_LANG_MB_NSISDLFAIL_2)"
    SetDetailsPrint listonly
    DetailPrint ""

  file_received:
    Push $G_PLS_FIELD_2

  FunctionEnd
!macroend


#--------------------------------------------------------------------------
# Macro: FUNCTION_SHOW_OR_HIDE_NIHONGO_PARSER
#
# Called by  'PFIGUIInit', our custom '.onGUIInit' function (or 'un.PFIGUIInit',
# our custom 'un.onGUIInit' function).
#
# The installation process and the uninstall process may both need a function which
# ensures that when 'Nihongo' (Japanese) has been selected as the language for the
# installer, 'Nihongo Parser' appears in the list of components.
#
# If any other language is selected, this component is hidden from view and the
# three parser sections are disabled (i.e. unselected so nothing gets installed).
#
# For a clean installation the default parser is 'Kakasi', as used by POPFile
# 0.22.5 and earlier releases. If, however, a previous Nihongo parser selection
# is found in the registry it will be used as the default when initialising the
# "Choose Nihongo Parser" page's radiobuttons.
#
# Note that the 'Nihongo Parser' section is _always_ executed, even if the user
# does not select the 'Nihongo' language.
#
# Note also that when an English-only build of the installer or uninstaller is
# used then 'Nihongo Parser' must appear in the COMPONENTS page otherwise there
# would be no way to install a Nihongo parser.
#
# This macro makes maintenance easier by ensuring that both processes use identical
# functions, with the only difference being their names.
#--------------------------------------------------------------------------

!macro FUNCTION_SHOW_OR_HIDE_NIHONGO_PARSER UN
  Function ${UN}ShowOrHideNihongoParser

    ; Reset (clear) all parser selection data

    !insertmacro UnselectSection ${${UN}SecKakasi}
    !insertmacro MUI_INSTALLOPTIONS_WRITE "ioP.ini" "Field 1" "State" "0"

    !insertmacro UnselectSection ${${UN}SecMeCab}
    !insertmacro MUI_INSTALLOPTIONS_WRITE "ioP.ini" "Field 2" "State" "0"

    !insertmacro UnselectSection ${${UN}SecInternalParser}
    !insertmacro MUI_INSTALLOPTIONS_WRITE "ioP.ini" "Field 3" "State" "0"

    !ifndef ENGLISH_MODE
        StrCmp $LANGUAGE ${LANG_JAPANESE} select_default_parser
        StrCpy $G_PARSER ""                            ; Do not install a Nihongo parser
        SectionSetText ${${UN}SecParser} ""            ; This makes the component invisible
        Goto exit

      select_default_parser:
    !endif

    ; If we are upgrading then use the "real" user's current setting as the default
    ; Nihongo parser if available, otherwise use the most recently installed parser

    ReadINIStr $G_PARSER "$G_COMMS_FILE" "RealUser" "Parser"
    StrCmp $G_PARSER "" 0 select_parser_section
    ReadRegStr $G_PARSER HKLM "Software\POPFile Project\${C_PFI_PRODUCT}\MRI" "NihongoParser"

  select_parser_section:
    StrCmp $G_PARSER "mecab" mecab
    StrCmp $G_PARSER "internal" internal

    ; Use 'Kakasi' as the default selection

    StrCpy $G_PARSER "kakasi"
    !insertmacro SelectSection ${${UN}SecKakasi}
    !insertmacro MUI_INSTALLOPTIONS_WRITE "ioP.ini" "Field 1" "State" "1"
    Goto exit

  mecab:
    !insertmacro SelectSection ${${UN}SecMeCab}
    !insertmacro MUI_INSTALLOPTIONS_WRITE "ioP.ini" "Field 2" "State" "1"
    Goto exit

  internal:
    !insertmacro SelectSection ${${UN}SecInternalParser}
    !insertmacro MUI_INSTALLOPTIONS_WRITE "ioP.ini" "Field 3" "State" "1"

  exit:
  FunctionEnd
!macroend


#--------------------------------------------------------------------------
# Macro: FUNCTION_CHOOSEPARSER
#
# Unlike English and many other languages, Japanese text does not use spaces to separate
# the words so POPFile has to use a parser in order to analyse the words in a Japanese
# message. The 1.0.0 release of POPFile is the first to offer a choice of parser (previous
# releases of POPFile always used the "Kakasi" parser).
#
# Three parsers are currently supported: Internal, Kakasi and MeCab. The installer contains
# all of the files needed for the first two but the MeCab parser uses a large dictionary
# (a 12 MB download) which will be downloaded during installation if MeCab is selected.
#
# This macro makes maintenance easier by ensuring that the installer and uninstaller use
# identical functions, with the only difference being their names.
#--------------------------------------------------------------------------

!macro FUNCTION_CHOOSEPARSER UN
  Function ${UN}ChooseParser
    !if '${UN}' == 'un.'
      StrCmp $G_UNINST_MODE "uninstall" exit
    !endif

    !ifndef ENGLISH_MODE

        ; If 'Nihongo' (Japanese) has been selected then we need to let the user choose which parser to install

        StrCmp $LANGUAGE ${LANG_JAPANESE} choose_parser
        StrCpy $G_PARSER ""
        Goto exit

      choose_parser:

    !endif

    !insertmacro MUI_INSTALLOPTIONS_WRITE "ioP.ini" "Field 1" "Text" "${C_NPLS_Option_Kakasi}"
    !insertmacro MUI_INSTALLOPTIONS_WRITE "ioP.ini" "Field 2" "Text" "${C_NPLS_Option_MeCab}"
    !insertmacro MUI_INSTALLOPTIONS_WRITE "ioP.ini" "Field 3" "Text" "${C_NPLS_Option_Internal}"

    !insertmacro MUI_INSTALLOPTIONS_WRITE "ioP.ini" "Field 5" "Text" "${C_NPLS_Note}"
    !insertmacro MUI_INSTALLOPTIONS_WRITE "ioP.ini" "Field 6" "Text" "${C_NPLS_Link}"
    !insertmacro MUI_INSTALLOPTIONS_WRITE "ioP.ini" "Field 6" "State" "${C_NPLS_Link}"

    Push '"${C_NPLS_DESC_Kakasi}"'
    Call ${UN}NSIS2IO
    Pop $G_PLS_FIELD_1
    !insertmacro MUI_INSTALLOPTIONS_WRITE "ioP.ini" "Field 4" "State" "$G_PLS_FIELD_1"

    !insertmacro MUI_INSTALLOPTIONS_WRITE "ioP.ini" "Field 4" "Flags" "${C_NPLS_DESC_Flags}"

    !insertmacro MUI_HEADER_TEXT "${C_NPLS_HEADER_ChooseParser}" "${C_NPLS_DESC_ChooseParser}"

    !insertmacro MUI_INSTALLOPTIONS_DISPLAY "ioP.ini"

    StrCmp $G_PARSER "kakasi"   enable_Kakasi
    StrCmp $G_PARSER "mecab"    enable_MeCab
    StrCmp $G_PARSER "internal" enable_Internal
    MessageBox MB_OK|MB_ICONEXCLAMATION "Internal Error:\
        ${MB_NL}${MB_NL}\
        Unexpected $$G_PARSER value ('$G_PARSER')\
        ${MB_NL}${MB_NL}\
        Defaulting to 'Kakasi' parser"
    StrCpy $G_PARSER "kakasi"
    Goto enable_Kakasi

  enable_Internal:
   !insertmacro UnselectSection ${${UN}SecKakasi}
   !insertmacro UnselectSection ${${UN}SecMeCab}
   !insertmacro SelectSection ${${UN}SecInternalParser}
    Goto exit

  enable_Kakasi:
   !insertmacro SelectSection ${${UN}SecKakasi}
   !insertmacro UnselectSection ${${UN}SecMeCab}
   !insertmacro UnselectSection ${${UN}SecInternalParser}
    Goto exit

  enable_MeCab:
   !insertmacro UnselectSection ${${UN}SecKakasi}
   !insertmacro SelectSection ${${UN}SecMeCab}
   !insertmacro UnselectSection ${${UN}SecInternalParser}

  exit:
  FunctionEnd
!macroend


#--------------------------------------------------------------------------
# Macro: FUNCTION_HANDLE_PARSER_SELECTION
#
# (the "leave" function for the Nihongo Parser selection page)
#
# Used to handle user input on the Nihongo Parser selection page.
#
# This macro makes maintenance easier by ensuring that the installer and
# uninstaller use identical functions, with the only difference being their
# names.
#--------------------------------------------------------------------------

!macro FUNCTION_HANDLE_PARSER_SELECTION UN
  Function ${UN}HandleParserSelection

    !define L_SELECTION   $R9

    Push ${L_SELECTION}

    !insertmacro MUI_INSTALLOPTIONS_READ ${L_SELECTION} "ioP.ini" "Settings" "State"

    StrCmp ${L_SELECTION} 0 done    ; "Next" button clicked

    !insertmacro MUI_INSTALLOPTIONS_READ $G_DLGITEM "ioP.ini" "Field 4" "HWND"
    StrCmp ${L_SELECTION} 1 kakasi
    StrCmp ${L_SELECTION} 2 mecab
    StrCmp ${L_SELECTION} 3 internal
    Goto return_to_page

  kakasi:
    StrCpy $G_PARSER "kakasi"
    SendMessage $G_DLGITEM ${WM_SETTEXT} 1 "STR:${C_NPLS_DESC_Kakasi}"
    Goto return_to_page

  mecab:
    StrCpy $G_PARSER "mecab"
    SendMessage $G_DLGITEM ${WM_SETTEXT} 1 "STR:${C_NPLS_DESC_MeCab}"
    Goto return_to_page

  internal:
    StrCpy $G_PARSER "internal"
    SendMessage $G_DLGITEM ${WM_SETTEXT} 1 "STR:${C_NPLS_DESC_Internal}"

  return_to_page:
    Pop ${L_SELECTION}
    Abort

  done:
    Pop ${L_SELECTION}

    !undef L_SELECTION

  FunctionEnd
!macroend

#--------------------------------------------------------------------------
# End of 'getparser.nsh'
#--------------------------------------------------------------------------
