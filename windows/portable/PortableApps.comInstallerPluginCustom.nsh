#-------------------------------------------------------------------------------------------
#
# PortableApps.comInstallerPluginCustom.nsh  --- Custom code for the POPFilePortable plugin
#                                                installer used to install the MeCab parser
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

    ; Set the Nihongo parser to 'mecab' in the main POPFile configuration file
    ; (Data\popfile.cfg) if it exists and in the default configuration file
    ; (App\DefaultData\popfile.cfg). If the default file is missing, create it.

    !define L_CFG_FILE    $R9
    !define L_RESULT      $R8

    Push ${L_CFG_FILE}
    Push ${L_RESULT}

    StrCpy ${L_CFG_FILE} "$INSTDIR\Data\popfile.cfg"
    IfFileExists "${L_CFG_FILE}" set_parser_CCPostInstall

  use_default_cfg_CCPostInstall:
    StrCpy ${L_CFG_FILE} "$INSTDIR\App\DefaultData\popfile.cfg"

  set_parser_CCPostInstall:
    Push "${L_CFG_FILE}"
    Push "bayes_nihongo_parser"
    Push "mecab"

    #------------------------------------------------
    #   Call PPL_CfgSettingWrite_with_backup (start)
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
  #   Call PPL_CfgSettingWrite_with_backup (end)
  #------------------------------------------------

    Pop ${L_RESULT}
 ;;;   MessageBox MB_OK "CfgSettingWrite (backup) status: ${L_RESULT}${MB_NL}(${L_CFG_FILE})"
    StrCmp ${L_RESULT} ${C_CFG_WRITE_ERROR} 0 cfg_update_ok_CCPostInstall
    MessageBox MB_OK|MB_ICONSTOP "*** Internal error ***\
        ${MB_NL}\
        Unable to set Nihongo parser to 'mecab'\
        ${MB_NL}${MB_NL}\
        (${L_CFG_FILE})"

  cfg_update_ok_CCPostInstall:
    StrCmp ${L_CFG_FILE} "$INSTDIR\Data\popfile.cfg" use_default_cfg_CCPostInstall

    Pop ${L_RESULT}
    Pop ${L_CFG_FILE}

    !undef L_CFG_FILE
    !undef L_RESULT

!macroend

#--------------------------------------------------------------------------
# End of 'PortableApps.comInstallerPluginCustom.nsh'
#--------------------------------------------------------------------------
