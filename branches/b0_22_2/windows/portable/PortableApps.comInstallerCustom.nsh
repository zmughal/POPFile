#-------------------------------------------------------------------------------------------
#
# PortableApps.comInstallerCustom.nsh  --- Custom code for the POPFilePortable installer
#
# Copyright (c) 2009 John Graham-Cumming
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
#-------------------------------------------------------------------------------------------

  ;--------------------------------------------------------------------------
  ; Symbols used to avoid confusion over where the line breaks occur.
  ;
  ; ${IO_NL} is used for InstallOptions-style 'new line' sequences.
  ; ${MB_NL} is used for MessageBox-style 'new line' sequences.
  ;--------------------------------------------------------------------------

  !define IO_NL   "\r\n"
  !define MB_NL   "$\r$\n"

#--------------------------------------------------------------------------
# Macro which is run BEFORE installation
#--------------------------------------------------------------------------

!macro CustomCodePreInstall

;;;  MessageBox MB_OK "'CustomCodePreInstall' executed"

!macroend

#--------------------------------------------------------------------------
# Macro which is run AFTER installation
#--------------------------------------------------------------------------

!macro CustomCodePostInstall

    ; Take the language selected for the installer into account when selecting
    ; the language setting for the POPFile UI in the main POPFile configuration
    ; file (Data\popfile.cfg) if it exists and in the default configuration file
    ; (App\DefaultData\popfile.cfg). If the default file is missing, create it.

    !define L_CFG_FILE    $R9
    !define L_CFG_RESULT  $R8
    !define L_UI_LANG     $R7

    Push ${L_CFG_FILE}
    Push ${L_CFG_RESULT}
    Push ${L_UI_LANG}

    ; In some cases we leave the current UI language setting alone
    ; (e.g. "English-UK" has no NSIS equivalent)

    StrCpy ${L_CFG_FILE} "$INSTDIR\Data\popfile.cfg"
    IfFileExists "${L_CFG_FILE}" 0 select_ui_lang_CCPostInstall
    Push "${L_CFG_FILE}"
    Push "html_language"

    #------------------------------------------------
    #   Call PFI_CfgSettingRead (start)
    #------------------------------------------------

    !define L_CFG       $R9   ; handle for the configuration file
    !define L_LINE      $R8   ; a line from the configuration file
    !define L_MATCHLEN  $R7   ; length (incl terminator space) of setting
    !define L_PARAM     $R6   ; possible match from configuration file
    !define L_RESULT    $R5
    !define L_SETTING   $R4   ; the configuration setting to be read
    !define L_TEXTEND   $R3   ; helps ensure correct handling of lines over 1023 chars long

    Exch ${L_SETTING}         ; get the name of the setting to be found
    Exch
    Exch ${L_CFG}             ; get the full path to the configuration file
    Push ${L_LINE}
    Push ${L_MATCHLEN}
    Push ${L_PARAM}
    Push ${L_RESULT}
    Push ${L_TEXTEND}

    StrCpy ${L_RESULT} ""
    StrCmp ${L_SETTING} "" error_exit_CfgSettingRead

    StrCpy ${L_SETTING} "${L_SETTING} "   ; include the terminating space
    StrLen ${L_MATCHLEN} ${L_SETTING}

    ClearErrors
    FileOpen  ${L_CFG} "${L_CFG}" r
    IfErrors error_exit_CfgSettingRead

  found_eol_CfgSettingRead:
    StrCpy ${L_TEXTEND} "<eol>"

  loop_CfgSettingRead:
    FileRead ${L_CFG} ${L_LINE}
    StrCmp ${L_LINE} "" done_CfgSettingRead
    StrCmp ${L_TEXTEND} "<eol>" 0 check_eol_CfgSettingRead
    StrCmp ${L_LINE} "$\n" loop_CfgSettingRead

    StrCpy ${L_PARAM} ${L_LINE} ${L_MATCHLEN}
    StrCmp ${L_PARAM} ${L_SETTING} 0 check_eol_CfgSettingRead
    StrCpy ${L_RESULT} ${L_LINE} "" ${L_MATCHLEN}

  check_eol_CfgSettingRead:

    ; Now read file until we get to end of the current line
    ; (i.e. until we find text ending in <CR><LF>, <CR> or <LF>)

    StrCpy ${L_TEXTEND} ${L_LINE} 1 -1
    StrCmp ${L_TEXTEND} "$\n" found_eol_CfgSettingRead
    StrCmp ${L_TEXTEND} "$\r" found_eol_CfgSettingRead loop_CfgSettingRead

  done_CfgSettingRead:
    FileClose ${L_CFG}
    StrCmp ${L_RESULT} "" error_exit_CfgSettingRead
    ${TrimNewlines} ${L_RESULT} ${L_RESULT}
    ClearErrors
    StrCmp ${L_RESULT} "" 0 exit_CfgSettingRead

  error_exit_CfgSettingRead:
    SetErrors

  exit_CfgSettingRead:
    StrCpy ${L_SETTING} ${L_RESULT}
    Pop ${L_TEXTEND}
    Pop ${L_RESULT}
    Pop ${L_PARAM}
    Pop ${L_MATCHLEN}
    Pop ${L_LINE}
    Pop ${L_CFG}
    Exch ${L_SETTING}

    !undef L_CFG
    !undef L_LINE
    !undef L_MATCHLEN
    !undef L_PARAM
    !undef L_RESULT
    !undef L_SETTING
    !undef L_TEXTEND

  #------------------------------------------------
  #   Call PFI_CfgSettingRead (end)
  #------------------------------------------------

    Pop ${L_UI_LANG}

    StrCmp ${L_UI_LANG} "Chinese-Simplified-GB2312" use_default_cfg_CCPostInstall
    StrCmp ${L_UI_LANG} "Chinese-Traditional-BIG5" use_default_cfg_CCPostInstall
    StrCmp ${L_UI_LANG} "English-UK" use_default_cfg_CCPostInstall

  select_ui_lang_CCPostInstall:
    ${Select} $LANGUAGE

      ${Case} "${LANG_ENGLISH}"
        StrCpy ${L_UI_LANG} "English"

      ${Case} "${LANG_ARABIC}"
        StrCpy ${L_UI_LANG} "Arabic"

      ${Case} "${LANG_BULGARIAN}"
        StrCpy ${L_UI_LANG} "Bulgarian"

      ${Case} "${LANG_CATALAN}"
        StrCpy ${L_UI_LANG} "Catala"

      ${Case} "${LANG_SIMPCHINESE}"
        StrCpy ${L_UI_LANG} "Chinese-Simplified"

      ${Case} "${LANG_TRADCHINESE}"
        StrCpy ${L_UI_LANG} "Chinese-Traditional"

      ${Case} "${LANG_CZECH}"
        StrCpy ${L_UI_LANG} "Czech"

      ${Case} "${LANG_DANISH}"
        StrCpy ${L_UI_LANG} "Dansk"

      ${Case} "${LANG_GERMAN}"
        StrCpy ${L_UI_LANG} "Deutsch"

      ${Case} "${LANG_SPANISH}"
        StrCpy ${L_UI_LANG} "Espanol"

      ${Case} "${LANG_FRENCH}"
        StrCpy ${L_UI_LANG} "Francais"

      ${Case} "${LANG_HEBREW}"
        StrCpy ${L_UI_LANG} "Hebrew"

      ${Case} "${LANG_GREEK}"
        StrCpy ${L_UI_LANG} "Hellenic"

      ${Case} "${LANG_ITALIAN}"
        StrCpy ${L_UI_LANG} "Italiano"

      ${Case} "${LANG_KOREAN}"
        StrCpy ${L_UI_LANG} "Korean"

      ${Case} "${LANG_HUNGARIAN}"
        StrCpy ${L_UI_LANG} "Hungarian"

      ${Case} "${LANG_DUTCH}"
        StrCpy ${L_UI_LANG} "Nederlands"

      ${Case} "${LANG_JAPANESE}"
        StrCpy ${L_UI_LANG} "Nihongo"

      ${Case} "${LANG_NORWEGIAN}"
        StrCpy ${L_UI_LANG} "Norsk"

      ${Case} "${LANG_POLISH}"
        StrCpy ${L_UI_LANG} "Polish"

      ${Case} "${LANG_PORTUGUESE}"
        StrCpy ${L_UI_LANG} "Portugues"

      ${Case} "${LANG_PORTUGUESEBR}"
        StrCpy ${L_UI_LANG} "Portugues-do-Brasil"

      ${Case} "${LANG_RUSSIAN}"
        StrCpy ${L_UI_LANG} "Russian"

      ${Case} "${LANG_SLOVAK}"
        StrCpy ${L_UI_LANG} "Slovak"

      ${Case} "${LANG_FINNISH}"
        StrCpy ${L_UI_LANG} "Suomi"

      ${Case} "${LANG_SWEDISH}"
        StrCpy ${L_UI_LANG} "Svenska"

      ${Case} "${LANG_TURKISH}"
        StrCpy ${L_UI_LANG} "Turkce"

;;;   ${Case} "${LANG_UKRAINIAN}"
;;;         Use the appropriate numeric value to avoid the warning
;;;         'unknown variable/constant "{LANG_UKRAINIAN}" detected'
      ${Case} "1058"
        StrCpy ${L_UI_LANG} "Ukrainian"

      ${CaseElse}
        StrCpy ${L_UI_LANG} ""

  ${EndSelect}

    StrCpy ${L_CFG_FILE} "$INSTDIR\Data\popfile.cfg"
    IfFileExists "${L_CFG_FILE}" set_ui_lang_CCPostInstall

  use_default_cfg_CCPostInstall:
    StrCpy ${L_CFG_FILE} "$INSTDIR\App\DefaultData\popfile.cfg"

  set_ui_lang_CCPostInstall:
    Push "${L_CFG_FILE}"
    Push "html_language"
    Push "${L_UI_LANG}"

    #------------------------------------------------
    #   Call PFI_CfgSettingWrite_with_backup (start)
    #------------------------------------------------

    !ifndef C_CFG_WRITE
      !define C_CFG_WRITE
      !define C_CFG_WRITE_CHANGED   "CHANGED"
      !define C_CFG_WRITE_DELETED   "DELETED"
      !define C_CFG_WRITE_ADDED     "ADDED"
      !define C_CFG_WRITE_SAME      "SAME"
      !define C_CFG_WRITE_ERROR     "ERROR"

      !define C_FALSE               "FALSE"
      !define C_TRUE                "TRUE"
    !endif

    !define L_FOUND       $R9   ; TRUE | FALSE
    !define L_LINE        $R8   ; a line from the configuration file
    !define L_MATCHLEN    $R7   ; length (incl terminator space) of setting
    !define L_NEW_HANDLE  $R6   ; handle for the new configuration file
    !define L_OLD_CFG     $R5   ; the full path to the configuration file
    !define L_OLD_HANDLE  $R4   ; handle for the original configuration file
    !define L_PARAM       $R3   ; possible match from configuration file
    !define L_SETTING     $R2   ; the configuration setting to be written
    !define L_STATUS      $R1   ; holds one of the C_CFG_WRITE_* constants listed above
    !define L_TEMP        $R0
    !define L_TEXTEND     $9    ; helps ensure correct handling of lines over 1023 chars long
    !define L_VALUE       $8    ; the new value for the configuration setting

    Exch ${L_VALUE}             ; get the new value to be set
    Exch
    Exch ${L_SETTING}           ; get the name of the configuration setting
    Exch 2
    Exch ${L_OLD_CFG}           ; get the full path to the configuration file
    Push ${L_FOUND}
    Push ${L_LINE}
    Push ${L_MATCHLEN}
    Push ${L_NEW_HANDLE}
    Push ${L_OLD_HANDLE}
    Push ${L_PARAM}
    Push ${L_STATUS}
    Push ${L_TEMP}
    Push ${L_TEXTEND}

    StrCpy ${L_FOUND} "${C_FALSE}"
    StrCpy ${L_STATUS} ""

    StrCmp ${L_SETTING} "" error_exit_CfgSettingWrite

    StrCpy ${L_SETTING} "${L_SETTING} "   ; include the terminating space
    StrLen ${L_MATCHLEN} ${L_SETTING}

    ClearErrors
    FileOpen  ${L_NEW_HANDLE} "$PLUGINSDIR\new.cfg" w
    IfFileExists "${L_OLD_CFG}" 0 create_file_CfgSettingWrite
    FileOpen  ${L_OLD_HANDLE} "${L_OLD_CFG}" r
    IfErrors error_exit_CfgSettingWrite

  found_eol_CfgSettingWrite:
    StrCpy ${L_TEXTEND} "<eol>"

  loop_CfgSettingWrite:
    FileRead ${L_OLD_HANDLE} ${L_LINE}
    StrCmp ${L_LINE} "" copy_done_CfgSettingWrite
    StrCmp ${L_TEXTEND} "<eol>" 0 copy_line_CfgSettingWrite
    StrCmp ${L_LINE} "$\n" copy_line_CfgSettingWrite

    StrCpy ${L_PARAM} ${L_LINE} ${L_MATCHLEN}
    StrCmp ${L_PARAM} ${L_SETTING} 0 copy_line_CfgSettingWrite

    ; Setting found: can now change or delete it

    StrCpy ${L_FOUND} "${C_TRUE}"

    StrCmp ${L_VALUE} "" delete_it_CfgSettingWrite

    StrCpy ${L_TEMP} ${L_LINE} "" ${L_MATCHLEN}
    ${TrimNewlines} ${L_TEMP} ${L_TEMP}
    StrCmp ${L_VALUE} ${L_TEMP} 0 change_it_CfgSettingWrite
    StrCmp ${L_STATUS} "${C_CFG_WRITE_CHANGED}" copy_line_CfgSettingWrite
    StrCpy ${L_STATUS} "${C_CFG_WRITE_SAME}"
    Goto copy_line_CfgSettingWrite

  delete_it_CfgSettingWrite:
    StrCpy ${L_STATUS} "${C_CFG_WRITE_DELETED}"
    Goto loop_CfgSettingWrite

  change_it_CfgSettingWrite:
    FileWrite ${L_NEW_HANDLE} "${L_SETTING}${L_VALUE}${MB_NL}"
    StrCpy ${L_STATUS} "${C_CFG_WRITE_CHANGED}"
    Goto loop_CfgSettingWrite

  copy_line_CfgSettingWrite:
    FileWrite ${L_NEW_HANDLE} ${L_LINE}

    ; Now read file until we get to end of the current line
    ; (i.e. until we find text ending in <CR><LF>, <CR> or <LF>)

    StrCpy ${L_TEXTEND} ${L_LINE} 1 -1
    StrCmp ${L_TEXTEND} "$\n" found_eol_CfgSettingWrite
    StrCmp ${L_TEXTEND} "$\r" found_eol_CfgSettingWrite loop_CfgSettingWrite

  copy_done_CfgSettingWrite:
    FileClose ${L_OLD_HANDLE}
    StrCmp ${L_FOUND} "TRUE" close_new_file_CfgSettingWrite

    ; Setting not found in file so we add it at the end

  create_file_CfgSettingWrite:
    FileWrite ${L_NEW_HANDLE} "${L_SETTING}${L_VALUE}${MB_NL}"
    StrCpy ${L_STATUS} ${C_CFG_WRITE_ADDED}

  close_new_file_CfgSettingWrite:
    FileClose ${L_NEW_HANDLE}

    StrCmp ${L_STATUS} ${C_CFG_WRITE_SAME} success_exit_CfgSettingWrite
    ${GetParent} ${L_OLD_CFG} ${L_TEMP}
    StrCmp ${L_TEMP} "" 0 path_supplied_CfgSettingWrite
    StrCpy ${L_TEMP} "."
    Goto update_file_CfgSettingWrite

  path_supplied_CfgSettingWrite:
    StrLen ${L_VALUE} ${L_TEMP}
    IntOp ${L_VALUE} ${L_VALUE} + 1
    StrCpy ${L_OLD_CFG} ${L_OLD_CFG} "" ${L_VALUE}

  update_file_CfgSettingWrite:
    IfFileExists "${L_TEMP}\${L_OLD_CFG}" 0 continue_CfgSettingWrite
    IfFileExists "${L_TEMP}\${L_OLD_CFG}.bk1" 0 the_first_CfgSettingWrite
    IfFileExists "${L_TEMP}\${L_OLD_CFG}.bk2" 0 the_second_CfgSettingWrite
    IfFileExists "${L_TEMP}\${L_OLD_CFG}.bk3" 0 the_third_CfgSettingWrite
    Delete "${L_TEMP}\${L_OLD_CFG}.bk3"

  the_third_CfgSettingWrite:
    Rename "${L_TEMP}\${L_OLD_CFG}.bk2" "${L_TEMP}\${L_OLD_CFG}.bk3"

  the_second_CfgSettingWrite:
    Rename "${L_TEMP}\${L_OLD_CFG}.bk1" "${L_TEMP}\${L_OLD_CFG}.bk2"

  the_first_CfgSettingWrite:
    Rename "${L_TEMP}\${L_OLD_CFG}" "${L_TEMP}\${L_OLD_CFG}.bk1"

  continue_CfgSettingWrite:
    ClearErrors
    Rename "$PLUGINSDIR\new.cfg" "${L_TEMP}\${L_OLD_CFG}"
    IfErrors error_exit_CfgSettingWrite

  success_exit_CfgSettingWrite:
    ClearErrors
    Goto exit_CfgSettingWrite

  error_exit_CfgSettingWrite:
    StrCpy ${L_STATUS} ${C_CFG_WRITE_ERROR}
    SetErrors

  exit_CfgSettingWrite:
    StrCpy ${L_SETTING} ${L_STATUS}
    Pop ${L_TEXTEND}
    Pop ${L_TEMP}
    Pop ${L_STATUS}
    Pop ${L_PARAM}
    Pop ${L_OLD_HANDLE}
    Pop ${L_NEW_HANDLE}
    Pop ${L_MATCHLEN}
    Pop ${L_LINE}
    Pop ${L_FOUND}
    Pop ${L_OLD_CFG}
    Pop ${L_VALUE}
    Exch ${L_SETTING}

    !undef L_FOUND
    !undef L_LINE
    !undef L_MATCHLEN
    !undef L_NEW_HANDLE
    !undef L_OLD_CFG
    !undef L_OLD_HANDLE
    !undef L_PARAM
    !undef L_SETTING
    !undef L_STATUS
    !undef L_TEMP
    !undef L_TEXTEND
    !undef L_VALUE

  #------------------------------------------------
  #   Call PFI_CfgSettingWrite_with_backup (end)
  #------------------------------------------------

    Pop ${L_CFG_RESULT}
;;;    MessageBox MB_OK \
;;;           "CfgSettingWrite (backup) status: ${L_CFG_RESULT}${MB_NL}(${L_CFG_FILE})"
    StrCmp ${L_CFG_RESULT} ${C_CFG_WRITE_ERROR} 0 cfg_update_ok_CCPostInstall
    MessageBox MB_OK|MB_ICONSTOP "*** Internal error ***\
        ${MB_NL}\
        Unable to set UI Language to '${L_UI_LANG}'\
        ${MB_NL}${MB_NL}\
        (${L_CFG_FILE})"

  cfg_update_ok_CCPostInstall:
    StrCmp ${L_CFG_FILE} "$INSTDIR\Data\popfile.cfg" use_default_cfg_CCPostInstall

    Pop ${L_UI_LANG}
    Pop ${L_CFG_RESULT}
    Pop ${L_CFG_FILE}

    !undef L_CFG_FILE
    !undef L_CFG_RESULT
    !undef L_UI_LANG

!macroend

#--------------------------------------------------------------------------
# Macro which is run at the beginning of installation if the optional section
# of an installer is not selected, intended for use in app upgrades when the
# existing app may have had the optional section included
#--------------------------------------------------------------------------

!macro CustomCodeOptionalCleanup

    ; The Nihongo parser is NOT being installed. If the existing POPFilePortable
    ; installation includes the MeCab parser we need to remove it and all of its
    ; support files if it uses a different version of Perl from the one we are
    ; about to install.

    IfFileExists "$INSTDIR\App\POPFile\perl58.dll" 0 exit_CustomCodeOptionalCleanup
    IfFileExists "$INSTDIR\App\POPFile\mecab\*.*" 0 exit_CustomCodeOptionalCleanup

    !define L_NEW_MAJOR  $R9
    !define L_NEW_MINOR  $R8
    !define L_NEW_REVSN  $R7
    !define L_NEW_BUILD  $R6

    !define L_OLD_MAJOR  $R5
    !define L_OLD_MINOR  $R4
    !define L_OLD_REVSN  $R3
    !define L_OLD_BUILD  $R2

    Push ${L_NEW_MAJOR}
    Push ${L_NEW_MINOR}
    Push ${L_NEW_REVSN}
    Push ${L_NEW_BUILD}

    Push ${L_OLD_MAJOR}
    Push ${L_OLD_MINOR}
    Push ${L_OLD_REVSN}
    Push ${L_OLD_BUILD}

    GetDllVersionLocal "..\..\App\POPFile\perl58.dll" ${L_NEW_MINOR} ${L_NEW_BUILD}
    IntOp ${L_NEW_MAJOR} ${L_NEW_MINOR} / 0x00010000
    IntOp ${L_NEW_MINOR} ${L_NEW_MINOR} & 0x0000FFFF
    IntOp ${L_NEW_REVSN} ${L_NEW_BUILD} / 0x00010000
    IntOp ${L_NEW_BUILD} ${L_NEW_BUILD} & 0x0000FFFF

    GetDllVersion "$INSTDIR\App\POPFile\perl58.dll" ${L_OLD_MINOR} ${L_OLD_BUILD}
    IntOp ${L_OLD_MAJOR} ${L_OLD_MINOR} / 0x00010000
    IntOp ${L_OLD_MINOR} ${L_OLD_MINOR} & 0x0000FFFF
    IntOp ${L_OLD_REVSN} ${L_OLD_BUILD} / 0x00010000
    IntOp ${L_OLD_BUILD} ${L_OLD_BUILD} & 0x0000FFFF

;;;    MessageBox MB_OK \
;;;        "Old Perl: ${L_OLD_MAJOR}.${L_OLD_MINOR}.${L_OLD_REVSN} Build ${L_OLD_BUILD}\
;;;        ${MB_NL}${MB_NL}\
;;;        New Perl: ${L_NEW_MAJOR}.${L_NEW_MINOR}.${L_NEW_REVSN} Build ${L_NEW_BUILD}"

    StrCmp ${L_NEW_MAJOR} ${L_OLD_MAJOR} 0 remove_mecab
    StrCmp ${L_NEW_MINOR} ${L_OLD_MINOR} 0 remove_mecab
    StrCmp ${L_NEW_REVSN} ${L_OLD_REVSN} 0 remove_mecab
    StrCmp ${L_NEW_BUILD} ${L_OLD_BUILD} restore_regs_CustomCodeOptionalCleanup

  remove_mecab:
;;;    MessageBox MB_OK "Removing out-of-date MeCab files"

    Delete "$INSTDIR\App\POPFile\lib\DirHandle.pm"
    Delete "$INSTDIR\App\POPFile\lib\Encode.pm"
    Delete "$INSTDIR\App\POPFile\lib\MeCab.pm"
    Delete "$INSTDIR\App\POPFile\lib\File\Glob\Windows.pm"
    Delete "$INSTDIR\App\POPFile\lib\Win32\API.pm"

    RmDir /r "$INSTDIR\App\POPFile\lib\auto\Encode"
    RmDir /r "$INSTDIR\App\POPFile\lib\auto\MeCab"
    RmDir /r "$INSTDIR\App\POPFile\lib\auto\Win32\API"
    RmDir /r "$INSTDIR\App\POPFile\lib\Encode"
    RmDir /r "$INSTDIR\App\POPFile\lib\Win32\API"
    RmDir /r "$INSTDIR\App\POPFile\mecab"

  restore_regs_CustomCodeOptionalCleanup:
    Pop ${L_OLD_BUILD}
    Pop ${L_OLD_REVSN}
    Pop ${L_OLD_MINOR}
    Pop ${L_OLD_MAJOR}

    Pop ${L_NEW_BUILD}
    Pop ${L_NEW_REVSN}
    Pop ${L_NEW_MINOR}
    Pop ${L_NEW_MAJOR}

    !undef L_NEW_MAJOR
    !undef L_NEW_MINOR
    !undef L_NEW_REVSN
    !undef L_NEW_BUILD

    !undef L_OLD_MAJOR
    !undef L_OLD_MINOR
    !undef L_OLD_REVSN
    !undef L_OLD_BUILD

  exit_CustomCodeOptionalCleanup:
!macroend

#--------------------------------------------------------------------------
# End of 'PortableApps.comInstallerCustom.nsh'
#--------------------------------------------------------------------------
