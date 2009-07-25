#--------------------------------------------------------------------------
#
# ppl-library.nsh --- This is a collection of library functions and macro
#                     definitions for inclusion in the NSIS scripts used
#                     to create (and test) the POPFilePortable launcher,
#                     associated utilities, and installer custom code.
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
#
#--------------------------------------------------------------------------
# CONDITIONAL COMPILATION NOTES
#
# This library is used by many different scripts which only require subsets of the library.
# Conditional compilation is used to select the appropriate entries for a particular script
# (to avoid unnecessary compiler warnings).
#
# The following symbols are used to construct the expressions defining the required subset:
#
#  (1) CREATEUSER       defined in portable\CreateUserData.nsi (for POPFile Portable)
#  (2) LFNFIXER         defined in portable\lfnfixer.nsi (LFN fixer for POPFile Portable)
#  (3) PORTABLE         defined in portable\POPFilePortable.nsi (PortableApps format launcher)
#--------------------------------------------------------------------------

!ifndef PPL_VERBOSE
  !verbose 3
!endif

#--------------------------------------------------------------------------
# Since so many scripts rely upon this library file, provide an easy way
# for the installers/uninstallers, wizards and other utilities to identify
# the particular library file used by NSIS to compile the executable file
# (by using this constant in the executable's "Version Information" data).
#--------------------------------------------------------------------------

  !define C_PPL_LIBRARY_VERSION     "0.0.6"

#--------------------------------------------------------------------------
# Symbols used to avoid confusion over where the line breaks occur.
#
# ${IO_NL} is used for InstallOptions-style 'new line' sequences.
# ${MB_NL} is used for MessageBox-style 'new line' sequences.
#--------------------------------------------------------------------------

!ifndef IO_NL
  !define IO_NL     "\r\n"
!endif

!ifndef MB_NL
  !define MB_NL     "$\r$\n"
!endif

#--------------------------------------------------------------------------
# Universal POPFile Constant: the URL used to access the User Interface (UI)
#--------------------------------------------------------------------------
#
# Starting with the 0.22.0 release, the system tray icon will use "localhost"
# to access the User Interface (UI) instead of "127.0.0.1". The installer and
# PFI utilities will follow suit by using the ${C_UI_URL} universal constant
# when accessing the UI instead of hard-coded references to "127.0.0.1".
#
# Using a universal constant makes it easy to revert to "127.0.0.1" since
# every NSIS script used to access the UI has been updated to use this
# universal constant and the constant is only defined in this file.
#--------------------------------------------------------------------------

  !define C_UI_URL    "localhost"
##  !define C_UI_URL    "127.0.0.1"

#--------------------------------------------------------------------------
#
# Macro which makes it easy to avoid relative jumps when defining macros
#
#--------------------------------------------------------------------------

  !macro PPL_UNIQUE_ID
      !ifdef PPL_UNIQUE_ID
        !undef PPL_UNIQUE_ID
      !endif
      !define PPL_UNIQUE_ID ${__LINE__}
  !macroend

#--------------------------------------------------------------------------
#
# Macros used to simplify inclusion/selection of the necessary language files
#
#--------------------------------------------------------------------------

  ;--------------------------------------------------------------------------
  ; Used in the '*-pfi.nsh' files to define the text strings for the installer
  ;--------------------------------------------------------------------------

  !macro PFI_LANG_STRING NAME VALUE
      LangString ${NAME} ${LANG_${PFI_LANG}} "${VALUE}"
  !macroend

  ;--------------------------------------------------------------------------
  ; Used in '*-pfi.nsh' files to define the text strings for fields in a custom page INI file
  ;--------------------------------------------------------------------------

  !macro PFI_IO_TEXT PATH FIELD TEXT
      WriteINIStr "$PLUGINSDIR\${PATH}" "Field ${FIELD}" "Text" "${TEXT}"
  !macroend

  ;--------------------------------------------------------------------------
  ; Used in '*-pfi.nsh' files to define entries in [Settings] section of custom page INI file
  ;--------------------------------------------------------------------------

  !macro PFI_IO_SETTING PATH FIELD TEXT
      WriteINIStr "$PLUGINSDIR\${PATH}" "Settings" "${FIELD}" "${TEXT}"
  !macroend

  ;--------------------------------------------------------------------------
  ; Used in multi-language scripts to define the languages to be supported
  ;--------------------------------------------------------------------------

  ; Macro used to load the files required for each language:
  ; (1) The MUI_LANGUAGE macro loads the standard MUI text strings for a particular language
  ; (2) '*-pfi.nsh' contains the text strings used for pages, progress reports, logs etc
  ; (3) Normally the MUI's language selection menu uses the name defined in the MUI language
  ;     file, however it is possible to override this by supplying an alternative string
  ;     (the MENUNAME parameter in this macro). At present the only alternative string used
  ;     is "Nihongo" which replaces "Japanese" to make things easier for non-English-speaking
  ;     users - see 'pfi-languages.nsh' for details.

  !macro PFI_LANG_LOAD LANG MENUNAME
      !if "${MENUNAME}" != "-"
          !define LANGFILE_${LANG}_NAME "${MENUNAME}"
      !endif
      !insertmacro MUI_LANGUAGE "${LANG}"
      !ifdef CREATEUSER
          !include "..\languages\${LANG}-pfi.nsh"
      !else
          !include "languages\${LANG}-pfi.nsh"
      !endif
  !macroend

#--------------------------------------------------------------------------
#
# Macros used to preserve up to 3 backup copies of a file
#
# (Note: input file will be "removed" by renaming it)
#--------------------------------------------------------------------------

  ;--------------------------------------------------------------------------
  ; This version generates uses 'DetailsPrint' to generate more meaningful log entries
  ;--------------------------------------------------------------------------

  !macro PPL_BACKUP_123_DP FOLDER FILE

      !insertmacro PPL_UNIQUE_ID

      IfFileExists "${FOLDER}\${FILE}" 0 continue_${PPL_UNIQUE_ID}
      SetDetailsPrint none
      IfFileExists "${FOLDER}\${FILE}.bk1" 0 the_first_${PPL_UNIQUE_ID}
      IfFileExists "${FOLDER}\${FILE}.bk2" 0 the_second_${PPL_UNIQUE_ID}
      IfFileExists "${FOLDER}\${FILE}.bk3" 0 the_third_${PPL_UNIQUE_ID}
      Delete "${FOLDER}\${FILE}.bk3"

    the_third_${PPL_UNIQUE_ID}:
      Rename "${FOLDER}\${FILE}.bk2" "${FOLDER}\${FILE}.bk3"
      SetDetailsPrint listonly
      DetailPrint "Backup file '${FILE}.bk3' updated"
      SetDetailsPrint none

    the_second_${PPL_UNIQUE_ID}:
      Rename "${FOLDER}\${FILE}.bk1" "${FOLDER}\${FILE}.bk2"
      SetDetailsPrint listonly
      DetailPrint "Backup file '${FILE}.bk2' updated"
      SetDetailsPrint none

    the_first_${PPL_UNIQUE_ID}:
      Rename "${FOLDER}\${FILE}" "${FOLDER}\${FILE}.bk1"
      SetDetailsPrint listonly
      DetailPrint "Backup file '${FILE}.bk1' updated"

    continue_${PPL_UNIQUE_ID}:
  !macroend

  ;--------------------------------------------------------------------------
  ; This version does not include any 'DetailsPrint' instructions
  ;--------------------------------------------------------------------------

  !macro PPL_BACKUP_123 FOLDER FILE

      !insertmacro PPL_UNIQUE_ID

      IfFileExists "${FOLDER}\${FILE}" 0 continue_${PPL_UNIQUE_ID}
      IfFileExists "${FOLDER}\${FILE}.bk1" 0 the_first_${PPL_UNIQUE_ID}
      IfFileExists "${FOLDER}\${FILE}.bk2" 0 the_second_${PPL_UNIQUE_ID}
      IfFileExists "${FOLDER}\${FILE}.bk3" 0 the_third_${PPL_UNIQUE_ID}
      Delete "${FOLDER}\${FILE}.bk3"

    the_third_${PPL_UNIQUE_ID}:
      Rename "${FOLDER}\${FILE}.bk2" "${FOLDER}\${FILE}.bk3"

    the_second_${PPL_UNIQUE_ID}:
      Rename "${FOLDER}\${FILE}.bk1" "${FOLDER}\${FILE}.bk2"

    the_first_${PPL_UNIQUE_ID}:
      Rename "${FOLDER}\${FILE}" "${FOLDER}\${FILE}.bk1"

    continue_${PPL_UNIQUE_ID}:
  !macroend


#=============================================================================================
#
# Functions used only during 'installation':
#
#    Installer Function: PPL_GetRoot
#    Installer Function: PPL_GetSFNStatus
#    Installer Function: PPL_StrStripLZS
#
#=============================================================================================


!ifdef PORTABLE
    #--------------------------------------------------------------------------
    # Installer Function: PPL_GetRoot
    #
    # This function returns the root directory of a given path.
    # The given path must be a full path. Normal paths and UNC paths are supported.
    #
    # NB: The path is assumed to use backslashes (\)
    #
    # Inputs:
    #         (top of stack)          - input path
    #
    # Outputs:
    #         (top of stack)          - root part of the path (eg "X:" or "\\server\share")
    #
    # Usage:
    #
    #         Push "C:\Program Files\Directory\Whatever"
    #         Call PPL_GetRoot
    #         Pop $R0
    #
    #         ($R0 at this point is ""C:")
    #
    #--------------------------------------------------------------------------

    Function PPL_GetRoot
      Exch $0
      Push $1
      Push $2
      Push $3
      Push $4

      StrCpy $1 $0 2
      StrCmp $1 "\\" UNC
      StrCpy $0 $1
      Goto done

    UNC:
      StrCpy $2 3
      StrLen $3 $0

    loop:
      IntCmp $2 $3 "" "" loopend
      StrCpy $1 $0 1 $2
      IntOp $2 $2 + 1
      StrCmp $1 "\" loopend loop

    loopend:
      StrCmp $4 "1" +3
      StrCpy $4 1
      Goto loop

      IntOp $2 $2 - 1
      StrCpy $0 $0 $2

    done:
      Pop $4
      Pop $3
      Pop $2
      Pop $1
      Exch $0
    FunctionEnd
!endif


!ifdef PORTABLE
    #--------------------------------------------------------------------------
    # Installer Function: PPL_GetSFNStatus
    #
    # The current version of POPFile does not work properly if the values in the POPFILE_ROOT
    # and POPFILE_USER environment variables contain spaces, therefore the installer uses the
    # SFN (Short File Name) format for these values. Normally SFN support is enabled but on
    # some NTFS-based systems SFN support has been disabled for performance reasons.
    #
    # Inputs:
    #         (top of stack)     - installation folder (e.g. as selected via DIRECTORY page)
    # Outputs:
    #         (top of stack)     - SFN Support Status (1 = enabled, 0 = disabled)
    #
    # Usage:
    #         Push $INSTDIR
    #         Call PPL_GetSFNStatus
    #         Pop $R0
    #
    #         ($R0 will be "1" is SFN Support is enabled for the $INSTDIR volume)
    #
    #--------------------------------------------------------------------------

    Function PPL_GetSFNStatus

      !define L_FOLDERPATH   $0     ; NB: System plugin call uses '$0' instead of this symbol
      !define L_FILESYSTEM   $1     ; NB: System plugin call uses 'r1' instead of this symbol
      !define L_RESULT       $2     ; NB: System plugin call uses 'r2' instead of this symbol

      Exch ${L_FOLDERPATH}
      Push ${L_FILESYSTEM}
      Push ${L_RESULT}

      ReadRegStr ${L_RESULT} HKLM \
          "SOFTWARE\Microsoft\Windows NT\CurrentVersion" CurrentVersion
      StrCmp ${L_RESULT} "" sfn_enabled

      Push ${L_FOLDERPATH}
      Call PPL_GetCompleteFPN       ; convert input path to LFN format if possible
      Pop ${L_RESULT}               ; "" is returned if path does not exist yet
      StrCmp ${L_RESULT} "" getroot
      StrCpy ${L_FOLDERPATH} ${L_RESULT}

    getroot:
      Push ${L_FOLDERPATH}
      Call PPL_GetRoot              ; extract the "X:" or "\\server\share" part of the path
      Pop ${L_FOLDERPATH}
      StrCpy ${L_FILESYSTEM} ""     ; volume's file system type, eg FAT32, NTFS, CDFS, UDF, ""
      StrCpy ${L_RESULT} ""         ; return code 1 = success, 0 = fail
      System::Call \
        "kernel32::GetVolumeInformation(t '$0\',,,,,,t .r1, i ${NSIS_MAX_STRLEN}) i .r2"
      StrCmp ${L_FILESYSTEM} "NTFS" 0 sfn_enabled
      ReadRegDWORD ${L_RESULT} \
        HKLM "System\CurrentControlSet\Control\FileSystem" "NtfsDisable8dot3NameCreation"
      StrCmp ${L_RESULT} "1" 0 sfn_enabled
      StrCpy ${L_FOLDERPATH} "0"
      Goto exit

    sfn_enabled:
      StrCpy ${L_FOLDERPATH} "1"

    exit:
      Pop ${L_RESULT}
      Pop ${L_FILESYSTEM}
      Exch ${L_FOLDERPATH}

      !undef L_FOLDERPATH
      !undef L_FILESYSTEM
      !undef L_RESULT

    FunctionEnd
!endif


!ifdef CREATEUSER
    #--------------------------------------------------------------------------
    # Installer Function: PPL_StrStripLZS
    #
    # Strips any combination of leading zeroes and spaces from a string.
    #
    # Inputs:
    #         (top of stack)     - string to be processed
    # Outputs:
    #         (top of stack)     - processed string (with no leading zeroes or spaces)
    #
    # Usage:
    #         Push "  123"        ; the strings "000123" or " 0 0 0123" will give same result
    #         Call PPL_StrStripLZS
    #         Pop $R0
    #
    #         ($R0 at this point is "123")
    #
    #--------------------------------------------------------------------------

    Function PPL_StrStripLZS

      !define L_CHAR      $R9   ; current character
      !define L_LIMIT     $R8   ; use length (instead of a null char) to detect end-of-string
      !define L_STRING    $R7   ; the string to be processed

      Exch ${L_STRING}
      Push ${L_CHAR}
      Push ${L_LIMIT}

    loop:
      StrLen ${L_LIMIT} ${L_STRING}
      StrCmp ${L_LIMIT} 0 done
      StrCpy ${L_CHAR} ${L_STRING} 1
      StrCmp ${L_CHAR} " " strip_char
      StrCmp ${L_CHAR} "0" strip_char
      Goto done

    strip_char:
      StrCpy ${L_STRING} ${L_STRING} "" 1
      Goto loop

    done:
      Pop ${L_LIMIT}
      Pop ${L_CHAR}
      Exch ${L_STRING}

      !undef L_CHAR
      !undef L_LIMIT
      !undef L_STRING

    FunctionEnd
!endif


#=============================================================================================
#
# Macro-based Functions which may be used by installer or uninstaller (in alphabetic order)
#
#    Macro:                PPL_CfgSettingRead
#    Installer Function:   PPL_CfgSettingRead
#    Uninstaller Function: un.PPL_CfgSettingRead
#
#    Macro:                PPL_CfgSettingWrite_with_backup
#    Installer Function:   PPL_CfgSettingWrite_with_backup
#    Uninstaller Function: un.PPL_CfgSettingWrite_with_backup
#
#    Macro:                PPL_CfgSettingWrite_without_backup
#    Installer Function:   PPL_CfgSettingWrite_without_backup
#    Uninstaller Function: un.PPL_CfgSettingWrite_without_backup
#
#    Macro:                PPL_GetCompleteFPN
#    Installer Function:   PPL_GetCompleteFPN
#    Uninstaller Function: un.PPL_GetCompleteFPN
#
#    Macro:                PPL_GetDateTimeStamp
#    Installer Function:   PPL_GetDateTimeStamp
#    Uninstaller Function: un.PPL_GetDateTimeStamp
#
#    Macro:                PPL_GetLocalTime
#    Installer Function:   PPL_GetLocalTime
#    Uninstaller Function: un.PPL_GetLocalTime
#
#    Macro:                PPL_GetParameters
#    Installer Function:   PPL_GetParameters
#    Uninstaller Function: un.PPL_GetParameters
#
#    Macro:                PPL_GetParent
#    Installer Function:   PPL_GetParent
#    Uninstaller Function: un.PPL_GetParent
#
#    Macro:                PPL_GetSQLiteFormat
#    Installer Function:   PPL_GetSQLiteFormat
#    Uninstaller Function: un.PPL_GetSQLiteFormat
#
#    Macro:                PPL_StrCheckDecimal
#    Installer Function:   PPL_StrCheckDecimal
#    Uninstaller Function: un.PPL_StrCheckDecimal
#
#    Macro:                PPL_StrStr
#    Installer Function:   PPL_StrStr
#    Uninstaller Function: un.PPL_StrStr
#
#    Macro:                PPL_TrimNewlines
#    Installer Function:   PPL_TrimNewlines
#    Uninstaller Function: un.PPL_TrimNewlines
#
#=============================================================================================


#--------------------------------------------------------------------------
# Macro: PPL_CfgSettingRead
#
# The installation process and the uninstall process may both require a function
# to read the value of a setting from POPFile's configuration file. This macro
# makes maintenance easier by ensuring that both processes use identical functions,
# with the only difference being their names.
#
# NOTE:
# The !insertmacro PPL_CfgSettingRead "" and !insertmacro PPL_CfgSettingRead "un."
# commands are included here so the NSIS script can use 'Call PPL_CfgSettingRead' and
# 'Call un.PPL_CfgSettingRead' without additional preparation.
#
# This function is used to read the value of one of the settings in the
# POPFile configuration file (popfile.cfg). Although POPFile always uses
# the 'popfile.cfg' filename for its configuration data, some NSIS-based
# programs work with local copies so the filename and location is always
# passed as a parameter to this function.
#
# Note that the entire file is scanned and we return the last match found!
# Early versions of POPFile did not clean the file so there can be more
# than one line setting the same value (POPFile uses the last one found)
#
# Inputs:
#         (top of stack)        - the configuration setting to be read
#         (top of stack - 1)    - full path to the configuration file
#
# Outputs:
#         (top of stack)        - current value of the configuration setting
#                                (empty string returned if error detected)
#
#         ErrorFlag             - clear if no errors detected,
#                                 set if file not found, or
#                                 set if setting not found
#
# Usage (after macro has been 'inserted'):
#
#         Push "C:\User\Data\POPFile\popfile.cfg"
#         Push "html_port"
#         Call PPL_CfgSettingRead
#         Pop $R0
#
#         ($R0 at this point is "8080" if the default UI port is being used.
#          The Error flag will also be clear now).
#
#--------------------------------------------------------------------------

!macro PPL_CfgSettingRead UN
  Function ${UN}PPL_CfgSettingRead

    !define L_CFG       $R9     ; handle for the configuration file
    !define L_LINE      $R8     ; a line from the configuration file
    !define L_MATCHLEN  $R7     ; length (incl terminator space) of setting
    !define L_PARAM     $R6     ; possible match from configuration file
    !define L_RESULT    $R5
    !define L_SETTING   $R4     ; the configuration setting to be read
    !define L_TEXTEND   $R3     ; helps ensure correct handling of lines over 1023 chars long

    Exch ${L_SETTING}          ; get the name of the setting to be found
    Exch
    Exch ${L_CFG}              ; get the full path to the configuration file
    Push ${L_LINE}
    Push ${L_MATCHLEN}
    Push ${L_PARAM}
    Push ${L_RESULT}
    Push ${L_TEXTEND}

    StrCpy ${L_RESULT} ""
    StrCmp ${L_SETTING} "" error_exit

    StrCpy ${L_SETTING} "${L_SETTING} "   ; include the terminating space
    StrLen ${L_MATCHLEN} ${L_SETTING}

    ClearErrors
    FileOpen  ${L_CFG} "${L_CFG}" r
    IfErrors error_exit

  found_eol:
    StrCpy ${L_TEXTEND} "<eol>"

  loop:
    FileRead ${L_CFG} ${L_LINE}
    StrCmp ${L_LINE} "" done
    StrCmp ${L_TEXTEND} "<eol>" 0 check_eol
    StrCmp ${L_LINE} "$\n" loop

    StrCpy ${L_PARAM} ${L_LINE} ${L_MATCHLEN}
    StrCmp ${L_PARAM} ${L_SETTING} 0 check_eol
    StrCpy ${L_RESULT} ${L_LINE} "" ${L_MATCHLEN}

  check_eol:

    ; Now read file until we get to end of the current line
    ; (i.e. until we find text ending in <CR><LF>, <CR> or <LF>)

    StrCpy ${L_TEXTEND} ${L_LINE} 1 -1
    StrCmp ${L_TEXTEND} "$\n" found_eol
    StrCmp ${L_TEXTEND} "$\r" found_eol loop

  done:
    FileClose ${L_CFG}
    StrCmp ${L_RESULT} "" error_exit
    Push ${L_RESULT}
    Call ${UN}PPL_TrimNewlines
    Pop ${L_RESULT}
    ClearErrors
    StrCmp ${L_RESULT} "" 0 exit

  error_exit:
    SetErrors

  exit:
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

  FunctionEnd
!macroend

!ifdef CREATEUSER | PORTABLE
    #--------------------------------------------------------------------------
    # Installer Function: PPL_CfgSettingRead
    #
    # This function is used during the installation process
    #--------------------------------------------------------------------------

    !insertmacro PPL_CfgSettingRead ""
!endif

;    #--------------------------------------------------------------------------
;    # Uninstaller Function: un.PPL_CfgSettingRead
;    #
;    # This function is used during the uninstall process
;    #--------------------------------------------------------------------------
;
;    !insertmacro PPL_CfgSettingRead "un."


#--------------------------------------------------------------------------
# Macro: PPL_CfgSettingWrite_with_backup/PPL_CfgSettingWrite_without_backup
#
# The installation process and the uninstall process may both require a function
# to write a new setting value to POPFile's configuration file. This macro
# makes maintenance easier by ensuring that both processes use identical functions,
# with the only difference being their names.
#
# This function is used to write a value for one of the settings in the
# POPFile configuration file (popfile.cfg). Although POPFile always uses
# the 'popfile.cfg' filename for its configuration data, some NSIS-based
# programs work with local copies so the absolute path location is always
# passed as a parameter to this function.
#
# Note that if an empty string is supplied as the value then the named setting
# will be deleted from the configuration file.
#
# The 'with_backup' variants use the standard 1-2-3 backup naming sequence. For
# cases where several values are being set the "without_backup' variants may be
# more useful (since only three backups are maintained the original file could
# easily be lost).
#
# Inputs:
#         (top of stack)        - the value to be set (if "" setting will be deleted)
#         (top of stack - 1)    - the configuration setting's name
#         (top of stack - 2)    - full path to the configuration file
#
# Outputs:
#         (top of stack)        - operation result:
#                                    CHANGED - the setting has been changed,
#                                    DELETED - entry deleted from the file,
#                                    ADDED   - new entry added at end of file,
#                                    SAME    - file left unchanged,
#                                 or ERROR   - an error was detected
#
#         ErrorFlag             - clear if no errors detected,
#                                 set if file not found, or
#                                 set if setting not found
#
# Usage (after macro has been 'inserted'):
#
#         Push "C:\User\Data\POPFile\popfile.cfg"
#         Push "html_port"
#         Push "8080"
#         Call PPL_CfgSettingWrite_with_backup
#         Pop $R0
#
#         ($R0 at this point is "SAME" if the configuration file currently
#          uses the value 8080; in this case the file is not re-written so
#          a backup copy of the original file is _not_ made)
#
#--------------------------------------------------------------------------

!macro PPL_CfgSettingWrite UN BACKUP

  !if '${BACKUP}' == 'backup'
      Function ${UN}PPL_CfgSettingWrite_with_backup
  !else
      Function ${UN}PPL_CfgSettingWrite_without_backup
  !endif

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

    StrCmp ${L_SETTING} "" error_exit

    StrCpy ${L_SETTING} "${L_SETTING} "   ; include the terminating space
    StrLen ${L_MATCHLEN} ${L_SETTING}

    ClearErrors
    FileOpen  ${L_NEW_HANDLE} "$PLUGINSDIR\new.cfg" w
    IfFileExists "${L_OLD_CFG}" 0 add_setting
    FileOpen  ${L_OLD_HANDLE} "${L_OLD_CFG}" r
    IfErrors error_exit

  found_eol:
    StrCpy ${L_TEXTEND} "<eol>"

  loop:
    FileRead ${L_OLD_HANDLE} ${L_LINE}
    StrCmp ${L_LINE} "" copy_done
    StrCmp ${L_TEXTEND} "<eol>" 0 copy_line
    StrCmp ${L_LINE} "$\n" copy_line

    StrCpy ${L_PARAM} ${L_LINE} ${L_MATCHLEN}
    StrCmp ${L_PARAM} ${L_SETTING} 0 copy_line

    ; Setting found: can now change or delete it

    StrCpy ${L_FOUND} "${C_TRUE}"

    StrCmp ${L_VALUE} "" delete_it

    StrCpy ${L_TEMP} ${L_LINE} "" ${L_MATCHLEN}
    Push ${L_TEMP}
    Call ${UN}PPL_TrimNewlines
    Pop ${L_TEMP}
    StrCmp ${L_VALUE} ${L_TEMP} 0 change_it
    StrCmp ${L_STATUS} "${C_CFG_WRITE_CHANGED}" copy_line
    StrCpy ${L_STATUS} "${C_CFG_WRITE_SAME}"
    Goto copy_line

  delete_it:
    StrCpy ${L_STATUS} "${C_CFG_WRITE_DELETED}"
    Goto loop

  change_it:
    FileWrite ${L_NEW_HANDLE} "${L_SETTING}${L_VALUE}${MB_NL}"
    StrCpy ${L_STATUS} "${C_CFG_WRITE_CHANGED}"
    Goto loop

  copy_line:
    FileWrite ${L_NEW_HANDLE} ${L_LINE}

  ; Now read file until we get to end of the current line
  ; (i.e. until we find text ending in <CR><LF>, <CR> or <LF>)

    StrCpy ${L_TEXTEND} ${L_LINE} 1 -1
    StrCmp ${L_TEXTEND} "$\n" found_eol
    StrCmp ${L_TEXTEND} "$\r" found_eol loop

  copy_done:
    FileClose ${L_OLD_HANDLE}
    StrCmp ${L_FOUND} "TRUE" close_new_file

    ; Setting not found in file so we add it at the end
    ; (or create a new file with just this single entry)

  add_setting:
    FileWrite ${L_NEW_HANDLE} "${L_SETTING}${L_VALUE}${MB_NL}"
    StrCpy ${L_STATUS} ${C_CFG_WRITE_ADDED}

  close_new_file:
    FileClose ${L_NEW_HANDLE}

    StrCmp ${L_STATUS} ${C_CFG_WRITE_SAME} success_exit
    Push ${L_OLD_CFG}
    Call ${UN}PPL_GetParent
    Pop ${L_TEMP}
    StrCmp ${L_TEMP} "" 0 path_supplied
    StrCpy ${L_TEMP} "."
    Goto update_file

  path_supplied:
    StrLen ${L_VALUE} ${L_TEMP}
    IntOp ${L_VALUE} ${L_VALUE} + 1
    StrCpy ${L_OLD_CFG} ${L_OLD_CFG} "" ${L_VALUE}

  update_file:
    !if '${BACKUP}' == 'backup'
        !insertmacro PPL_BACKUP_123 "${L_TEMP}" "${L_OLD_CFG}"
    !else
        Delete "$PLUGINSDIR\old.cfg"
        Rename "${L_TEMP}\${L_OLD_CFG}"  "$PLUGINSDIR\old.cfg"
    !endif
    ClearErrors
    Rename "$PLUGINSDIR\new.cfg" "${L_TEMP}\${L_OLD_CFG}"
    IfErrors error_exit

  success_exit:
    ClearErrors
    Goto exit

  error_exit:
    StrCpy ${L_STATUS} ${C_CFG_WRITE_ERROR}
    SetErrors

  exit:
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

  FunctionEnd
!macroend

!macro PPL_CfgSettingWrite_with_backup UN
  !insertmacro PPL_CfgSettingWrite "${UN}" "backup"
!macroend

!macro PPL_CfgSettingWrite_without_backup UN
  !insertmacro PPL_CfgSettingWrite "${UN}" "no_backup"
!macroend

;--------------------------------------------------------------------------
; Examples showing how to insert all four variants
;--------------------------------------------------------------------------

;    #--------------------------------------------------------------------------
;    # Installer Function: PPL_CfgSettingWrite_with_backup
;    #
;    # This function is used during the installation process
;    #--------------------------------------------------------------------------
;
;    !insertmacro PPL_CfgSettingWrite_with_backup ""
;
;    #--------------------------------------------------------------------------
;    # Installer Function: PPL_CfgSettingWrite_without_backup
;    #
;    # This function is used during the installation process
;    #--------------------------------------------------------------------------
;
;    !insertmacro PPL_CfgSettingWrite_without_backup ""
;
;    #--------------------------------------------------------------------------
;    # Uninstaller Function: un.PPL_CfgSettingWrite_with_backup
;    #
;    # This function is used during the uninstallation process
;    #--------------------------------------------------------------------------
;
;    !insertmacro PPL_CfgSettingWrite_with_backup "un."
;
;    #--------------------------------------------------------------------------
;    # Uninstaller Function: un.PPL_CfgSettingWrite_without_backup
;    #
;    # This function is used during the uninstallation process
;    #--------------------------------------------------------------------------
;
;    !insertmacro PPL_CfgSettingWrite_without_backup "un."
;
;--------------------------------------------------------------------------


#--------------------------------------------------------------------------
# Macro: PPL_GetCompleteFPN
#
# The installation process and the uninstall process may need a function which converts a
# path into the full/long version (e.g. which converts 'C:\PROGRA~1' into 'C:\Program Files').
# There is a built-in NSIS command for this (GetFullPathName) but it only converts part of the
# path, eg. it converts 'C:\PROGRA~1\PRE-RE~1' into 'C:\PROGRA~1\Pre-release POPFile' instead
# of the expected 'C:\Program Files\Pre-release POPFile' string. This macro makes maintenance
# easier by ensuring that both processes use identical functions, with the only difference
# being their names.
#
# If the specified path does not exist, an empty string is returned in order to make this
# function act like the built-in NSIS command (GetFullPathName).
#
# NOTE:
# The !insertmacro PPL_GetCompleteFPN "" and !insertmacro PPL_GetCompleteFPN "un." commands
# are included in this file so the NSIS script and/or other library functions in this file
# can use 'Call PPL_GetCompleteFPN' and 'Call un.PPL_GetCompleteFPN' without additional
# preparation.
#
# Inputs:
#         (top of stack)     - path to be converted to long filename format
# Outputs:
#         (top of stack)     - full (long) path name or an empty string if path was not found
#
# Usage (after macro has been 'inserted'):
#
#         Push "c:\progra~1"
#         Call PPL_GetCompleteFPN
#         Pop $R0
#
#         ($R0 now holds 'C:\Program Files')
#
#--------------------------------------------------------------------------

!macro PPL_GetCompleteFPN UN
    Function ${UN}PPL_GetCompleteFPN

      Exch $0   ; the input path
      Push $1   ; the result string (will be empty if the input path does not exist)
      Exch
      Push $2

      ; 'GetLongPathNameA' is not available in Windows 95 systems (but it is in Windows 98)

      ClearErrors
      ReadRegStr $1 HKLM "SOFTWARE\Microsoft\Windows NT\CurrentVersion" CurrentVersion
      IfErrors 0 use_system_plugin
      ReadRegStr $1 HKLM "SOFTWARE\Microsoft\Windows\CurrentVersion" VersionNumber
      StrCpy $2 $1 1
      StrCmp $2 '4' 0 use_NSIS_code
      StrCpy $2 $1 3
      StrCmp $2 '4.0' use_NSIS_code use_system_plugin

    use_NSIS_code:
      Push $3

      StrCpy $1 ""                ; used to hold the long filename format result
      StrCpy $2 ""                ; holds a component part of the long filename

      ; Convert the input path ($0) into a long path ($1) if possible

    loop:
      GetFullPathName $3 $0       ; Converts the last part of the path to long filename format
      StrCmp $3 "" done           ; An empty string here means the path doesn't exist
      StrCpy $2 $3 1 -1
      StrCmp $2 '.' finished_unc  ; If last char of result is '.' then the path was a UNC one
      StrCpy $0 $3                ; Set path we are working on to the 'GetFullPathName' result
      Push $0
      Call ${UN}PPL_GetParent
      Pop $2
      StrLen $3 $2
      StrCpy $3 $0 "" $3          ; Get the last part of the path, including the leading '\'
      StrCpy $1 "$3$1"            ; Update the long filename result
      StrCpy $0 $2                ; Now prepare to convert the next part of the path
      StrCpy $3 $2 1 -1
      StrCmp $3 ':' done loop     ; We're done if all that is left is the drive letter part

    finished_unc:
      StrCpy $2 $0                ; $0 holds the '\\server\share' part of the UNC path

    done:
      StrCpy $1 "$2$1"            ; Assemble the last component of the long filename result

      Pop $3
      Goto exit

    use_system_plugin:
      StrCpy $1 ""

      ; Convert the input path ($0) into a long path ($1) if possible

      System::Call "Kernel32::GetLongPathNameA(t '$0', &t .r1, i ${NSIS_MAX_STRLEN})"

    exit:
      Pop $2
      Pop $0
      Exch $1

    FunctionEnd
!macroend

!ifdef PORTABLE
    #--------------------------------------------------------------------------
    # Installer Function: PPL_GetCompleteFPN
    #
    # This function is used during the installation process
    #--------------------------------------------------------------------------

    !insertmacro PPL_GetCompleteFPN ""
!endif


#--------------------------------------------------------------------------
# Macro: PPL_GetDateTimeStamp
#
# The installation process and the uninstall process may need a function which returns a
# string with the current date and time (using the current time from Windows). This macro
# makes maintenance easier by ensuring that both processes use identical functions, with
# the only difference being their names.
#
# NOTE:
# The !insertmacro PPL_GetDateTimeStamp "" and !insertmacro PPL_GetDateTimeStamp "un."
# commands are included in this file so the NSIS script and/or other library functions in
# 'ppl-library.nsh' can use 'Call PPL_GetDateTimeStamp' & 'Call un.PPL_GetDateTimeStamp'
# without additional preparation.
#
# Inputs:
#         (none)
# Outputs:
#         (top of stack)     - string with current date and time (eg '08-Dec-2003 @ 23:01:59')
#
# Usage (after macro has been 'inserted'):
#
#         Call PPL_GetDateTimeStamp
#         Pop $R9
#
#         ($R9 now holds a string like '08-Dec-2003 @ 23:01:59')
#--------------------------------------------------------------------------

!macro PPL_GetDateTimeStamp UN
  Function ${UN}PPL_GetDateTimeStamp

    !define L_DATETIMESTAMP   $R9
    !define L_DAY             $R8
    !define L_MONTH           $R7
    !define L_YEAR            $R6
    !define L_HOURS           $R5
    !define L_MINUTES         $R4
    !define L_SECONDS         $R3

    Push ${L_DATETIMESTAMP}
    Push ${L_DAY}
    Push ${L_MONTH}
    Push ${L_YEAR}
    Push ${L_HOURS}
    Push ${L_MINUTES}
    Push ${L_SECONDS}

    Call ${UN}PPL_GetLocalTime
    Pop ${L_YEAR}
    Pop ${L_MONTH}
    Pop ${L_DAY}              ; ignore day of week
    Pop ${L_DAY}
    Pop ${L_HOURS}
    Pop ${L_MINUTES}
    Pop ${L_SECONDS}
    Pop ${L_DATETIMESTAMP}    ; ignore milliseconds

    StrCpy ${L_DAY} "0${L_DAY}" "" -2

    IntOp ${L_MONTH} ${L_MONTH} & 0xF
    IntOp ${L_MONTH} ${L_MONTH} << 2
    StrCpy ${L_MONTH} "??? Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec ??? ??? ???" 3 ${L_MONTH}

    StrCpy ${L_HOURS} "0${L_HOURS}" "" -2
    StrCpy ${L_MINUTES} "0${L_MINUTES}" "" -2
    StrCpy ${L_SECONDS} "0${L_SECONDS}" "" -2

    StrCpy ${L_DATETIMESTAMP} \
      "${L_DAY}-${L_MONTH}-${L_YEAR} @ ${L_HOURS}:${L_MINUTES}:${L_SECONDS}"

    Pop ${L_SECONDS}
    Pop ${L_MINUTES}
    Pop ${L_HOURS}
    Pop ${L_YEAR}
    Pop ${L_MONTH}
    Pop ${L_DAY}
    Exch ${L_DATETIMESTAMP}

    !undef L_DATETIMESTAMP
    !undef L_DAY
    !undef L_MONTH
    !undef L_YEAR
    !undef L_HOURS
    !undef L_MINUTES
    !undef L_SECONDS

  FunctionEnd
!macroend

!ifdef LFNFIXER
    #--------------------------------------------------------------------------
    # Installer Function: PPL_GetDateTimeStamp
    #
    # This function is used during the installation process
    #--------------------------------------------------------------------------

    !insertmacro PPL_GetDateTimeStamp ""
!endif


#--------------------------------------------------------------------------
# Macro: PPL_GetLocalTime
#
# The installation process and the uninstall process may need a function which gets the
# local time from Windows (to generate data and/or time stamps, etc). This macro makes
# maintenance easier by ensuring that both processes use identical functions, with
# the only difference being their names.
#
# Normally this function will be used by a higher level one which returns a suitable string.
#
# NOTE:
# The !insertmacro PPL_GetLocalTime "" and !insertmacro PPL_GetLocalTime "un." commands are
# included in this file so the NSIS script and/or other library functions in this file
# can use 'Call PPL_GetLocalTime' and 'Call un.PPL_GetLocalTime' without additional
# preparation.
#
# Inputs:
#         (none)
# Outputs:
#         (top of stack)     - year         (4-digits)
#         (top of stack - 1) - month        (1 to 12)
#         (top of stack - 2) - day of week  (0 = Sunday, 6 = Saturday)
#         (top of stack - 3) - day          (1 - 31)
#         (top of stack - 4) - hours        (0 - 23)
#         (top of stack - 5) - minutes      (0 - 59)
#         (top of stack - 6) - seconds      (0 - 59)
#         (top of stack - 7) - milliseconds (0 - 999)
#
# Usage (after macro has been 'inserted'):
#
#         Call PPL_GetLocalTime
#         Pop $Year
#         Pop $Month
#         Pop $DayOfWeek
#         Pop $Day
#         Pop $Hours
#         Pop $Minutes
#         Pop $Seconds
#         Pop $Milliseconds
#--------------------------------------------------------------------------

!macro PPL_GetLocalTime UN
  Function ${UN}PPL_GetLocalTime

    Push $1
    Push $2
    Push $3
    Push $4
    Push $5
    Push $6
    Push $7
    Push $8

    System::Call '*(&i2, &i2, &i2, &i2, &i2, &i2, &i2, &i2) i .r1'
    System::Call 'kernel32::GetLocalTime(i) i(r1)'
    System::Call \
      '*$1(&i2, &i2, &i2, &i2, &i2, &i2, &i2, &i2)(.r8, .r7, .r6, .r5, .r4, .r3, .r2, .r1)'

    Exch $8
    Exch
    Exch $7
    Exch
    Exch 2
    Exch $6
    Exch 2
    Exch 3
    Exch $5
    Exch 3
    Exch 4
    Exch $4
    Exch 4
    Exch 5
    Exch $3
    Exch 5
    Exch 6
    Exch $2
    Exch 6
    Exch 7
    Exch $1
    Exch 7

  FunctionEnd
!macroend

!ifdef LFNFIXER
    #--------------------------------------------------------------------------
    # Installer Function: PPL_GetLocalTime
    #
    # This function is used during the installation process
    #--------------------------------------------------------------------------

    !insertmacro PPL_GetLocalTime ""
!endif


#--------------------------------------------------------------------------
# Macro: PPL_GetParameters
#
# The installation process and the uninstall process may need a function which extracts
# the parameters (if any) supplied on the command-line. This macro makes maintenance
# easier by ensuring that both processes use identical functions, with the only difference
# being their names.
#
# NOTE:
# The !insertmacro PPL_GetParameters "" and !insertmacro PPL_GetParameters "un." commands are
# included in this file so the NSIS script can use 'Call PPL_GetParameters' and
# 'Call un.PPL_GetParameters' without additional preparation.
#
# Inputs:
#         none
#
# Outputs:
#         top of stack)     - all of the parameters supplied on the command line (may be "")
#
# Usage (after macro has been 'inserted'):
#
#         Call PPL_GetParameters
#         Pop $R0
#
#         (if 'setup.exe /SSL' was used to start the installer, $R0 will hold '/SSL')
#--------------------------------------------------------------------------

!macro PPL_GetParameters UN
  Function ${UN}PPL_GetParameters

      Push $R0
      Push $R1
      Push $R2
      Push $R3

      StrCpy $R2 1
      StrLen $R3 $CMDLINE

      ; Check for quote or space

      StrCpy $R0 $CMDLINE $R2
      StrCmp $R0 '"' 0 +3
      StrCpy $R1 '"'
      Goto loop

      StrCpy $R1 " "

    loop:
      IntOp $R2 $R2 + 1
      StrCpy $R0 $CMDLINE 1 $R2
      StrCmp $R0 $R1 get
      StrCmp $R2 $R3 get
      Goto loop

    get:
      IntOp $R2 $R2 + 1
      StrCpy $R0 $CMDLINE 1 $R2
      StrCmp $R0 " " get
      StrCpy $R0 $CMDLINE "" $R2

      Pop $R3
      Pop $R2
      Pop $R1
      Exch $R0

    FunctionEnd
!macroend

!ifndef CREATEUSER
    #--------------------------------------------------------------------------
    # Installer Function: PPL_GetParameters
    #
    # This function is used during the installation process
    #--------------------------------------------------------------------------

    !insertmacro PPL_GetParameters ""
!endif


#--------------------------------------------------------------------------
# Macro: PPL_GetParent
#
# The installation process and the uninstall process may both use a function which extracts
# the parent directory from a given path. This macro makes maintenance easier by ensuring
# that both processes use identical functions, with the only difference being their names.
#
# NB: The path is assumed to use backslashes (\)
#
# NOTE:
# The !insertmacro PPL_GetParent "" and !insertmacro PPL_GetParent "un." commands are included
# in this file so the NSIS script can use 'Call PPL_GetParent' and 'Call un.PPL_GetParent'
# without additional preparation.
#
# Inputs:
#         (top of stack)          - string containing a path (e.g. C:\A\B\C)
#
# Outputs:
#         (top of stack)          - the parent part of the input string (e.g. C:\A\B)
#
# Usage (after macro has been 'inserted'):
#
#         Push "C:\Program Files\Directory\Whatever"
#         Call un.PPL_GetParent
#         Pop $R0
#
#         ($R0 at this point is ""C:\Program Files\Directory")
#
#--------------------------------------------------------------------------

!macro PPL_GetParent UN
  Function ${UN}PPL_GetParent
    Exch $R0
    Push $R1
    Push $R2
    Push $R3

    StrCpy $R1 0
    StrLen $R2 $R0

  loop:
    IntOp $R1 $R1 + 1
    IntCmp $R1 $R2 get 0 get
    StrCpy $R3 $R0 1 -$R1
    StrCmp $R3 "\" get
    Goto loop

  get:
    StrCpy $R0 $R0 -$R1

    Pop $R3
    Pop $R2
    Pop $R1
    Exch $R0
  FunctionEnd
!macroend

!ifdef CREATEUSER | LFNFIXER | PORTABLE
    #--------------------------------------------------------------------------
    # Installer Function: PPL_GetParent
    #
    # This function is used during the installation process
    #--------------------------------------------------------------------------

    !insertmacro PPL_GetParent ""
!endif


#--------------------------------------------------------------------------
# Macro: PPL_GetSQLiteFormat
#
# The installation process and the uninstall process may both need a function which determines
# the format of the SQLite database. SQLite 2.x and 3.x databases use incompatible formats and
# the only way to determine the format is to examine the first few bytes in the database file.
# This macro makes maintenance easier by ensuring that both processes use identical functions,
# with the only difference being their names.
#
# NOTE:
# The !insertmacro PPL_GetSQLiteFormat "" and !insertmacro PPL_GetSQLiteFormat "un." commands
# are included in this file so the NSIS script can use 'Call PPL_GetSQLiteFormat' and
# 'Call un.PPL_GetSQLiteFormat' without additional preparation.
#
# Inputs:
#         (top of stack)     - SQLite database filename (may include the path)
#
# Outputs:
#         (top of stack)     - one of the following result strings:
#                              (a) 2.x                   - SQLite 2.1 format database found
#                              (b) 3.x                   - SQLite 3.x format database found
#                              (c) (<format>)            - <format> is what was found in file
#                              (d) (unable to open file) - if file is locked or non-existent
#
#                              If result is enclosed in parentheses then an error occurred.
#
# Usage (after macro has been 'inserted'):
#
#         Push "popfile.db"
#         Call PPL_GetSQLiteFormat
#         Pop $R0
#
#         ($R0 will be "2.x" if the popfile.db file belongs to POPFile 0.21.0)
#--------------------------------------------------------------------------

!macro PPL_GetSQLiteFormat UN
  Function ${UN}PPL_GetSQLiteFormat

    !define L_BYTE       $R9  ; byte read from the database file
    !define L_COUNTER    $R8  ; expects null-terminated string, but also uses a length limit
    !define L_FILENAME   $R7  ; name of the SQLite database file
    !define L_HANDLE     $R6  ; used to access the database file
    !define L_RESULT     $R5  ; string returned on top of the stack

    Exch ${L_FILENAME}
    Push ${L_RESULT}
    Exch
    Push ${L_BYTE}
    Push ${L_COUNTER}
    Push ${L_HANDLE}

    StrCpy ${L_RESULT} "unable to open file"
    StrCpy ${L_COUNTER} 47

    ClearErrors
    FileOpen ${L_HANDLE} "${L_FILENAME}" r
    IfErrors done
    StrCpy ${L_RESULT} ""

  loop:
    FileReadByte ${L_HANDLE} ${L_BYTE}
    StrCmp ${L_BYTE} "0" done
    IntCmp ${L_BYTE} 32 0 done
    IntCmp ${L_BYTE} 127 done 0 done
    IntFmt ${L_BYTE} "%c" ${L_BYTE}
    StrCpy ${L_RESULT} "${L_RESULT}${L_BYTE}"
    IntOp ${L_COUNTER} ${L_COUNTER} - 1
    IntCmp ${L_COUNTER} 0 loop done loop

  done:
    FileClose ${L_HANDLE}
    StrCmp ${L_RESULT} "** This file contains an SQLite 2.1 database **" sqlite_2
    StrCpy ${L_COUNTER} ${L_RESULT} 15
    StrCmp ${L_COUNTER} "SQLite format 3" sqlite_3

    ; Unrecognized format string found, return it enclosed in parentheses (to indicate error)

    StrCpy ${L_RESULT} "(${L_RESULT})"
    Goto exit

  sqlite_2:
    StrCpy ${L_RESULT} "2.x"
    Goto exit

  sqlite_3:
    StrCpy ${L_RESULT} "3.x"

  exit:
    Pop ${L_HANDLE}
    Pop ${L_COUNTER}
    Pop ${L_BYTE}
    Pop ${L_FILENAME}
    Exch ${L_RESULT}

    !undef L_BYTE
    !undef L_COUNTER
    !undef L_FILENAME
    !undef L_HANDLE
    !undef L_RESULT

  FunctionEnd
!macroend

!ifdef PORTABLE
    #--------------------------------------------------------------------------
    # Installer Function: PPL_GetSQLiteFormat
    #
    # This function is used during the installation process
    #--------------------------------------------------------------------------

    !insertmacro PPL_GetSQLiteFormat ""
!endif


#--------------------------------------------------------------------------
# Macro: PPL_StrCheckDecimal
#
# The installation process and the uninstall process may both use a function which checks if
# a given string contains a decimal number. This macro makes maintenance easier by ensuring
# that both processes use identical functions, with the only difference being their names.
#
# The 'PPL_StrCheckDecimal' and 'un.PPL_StrCheckDecimal' functions check that a given string
# contains only the digits 0 to 9. (if the string contains any invalid characters, "" is
# returned)
#
# NOTE:
# The !insertmacro PPL_StrCheckDecimal "" and !insertmacro PPL_StrCheckDecimal "un." commands
# are included in this file so the NSIS script can use 'Call PPL_StrCheckDecimal' and
# 'Call un.PPL_StrCheckDecimal' without additional preparation.
#
# Inputs:
#         (top of stack)   - string which may contain a decimal number
#
# Outputs:
#         (top of stack)   - the input string (if valid) or "" (if invalid)
#
# Usage (after macro has been 'inserted'):
#
#         Push "12345"
#         Call un.PPL_StrCheckDecimal
#         Pop $R0
#         ($R0 at this point is "12345")
#
#--------------------------------------------------------------------------

!macro PPL_StrCheckDecimal UN
  Function ${UN}PPL_StrCheckDecimal

    !define DECIMAL_DIGIT   "0123456789"   ; accept only these digits
    !define BAD_OFFSET      10             ; length of DECIMAL_DIGIT string

    !define L_STRING        $0   ; The input string
    !define L_RESULT        $1   ; Holds the result: either "" (if input is invalid) or
                                 ; the input string (if the input is valid)
    !define L_CURRENT       $2   ; A character from the input string
    !define L_OFFSET        $3   ; The offset to a character in the "validity check" string
    !define L_VALIDCHAR     $4   ; A character from the "validity check" string
    !define L_VALIDLIST     $5   ; Holds the current "validity check" string
    !define L_CHARSLEFT     $6   ; To cater for MBCS input strings, terminate when end of
                                 ; string reached, not when a null byte reached

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
    StrCpy ${L_CURRENT} ${L_STRING} 1                   ; Get the next char from input string
    StrCpy ${L_VALIDLIST} ${DECIMAL_DIGIT}${L_CURRENT}  ; Add it to end of "validity check"
                                                        ; to guarantee a match
    StrCpy ${L_STRING} ${L_STRING} "" 1
    StrCpy ${L_OFFSET} -1

  next_valid_char:
    IntOp ${L_OFFSET} ${L_OFFSET} + 1
    StrCpy ${L_VALIDCHAR} ${L_VALIDLIST} 1 ${L_OFFSET}    ; Extract next "valid" char
                                                          ; (from "validity check" string)
    StrCmp ${L_CURRENT} ${L_VALIDCHAR} 0 next_valid_char
    IntCmp ${L_OFFSET} ${BAD_OFFSET} invalid 0 invalid    ; If match is with the char we
                                                          ; added, input is bad
    StrCpy ${L_RESULT} ${L_RESULT}${L_VALIDCHAR}          ; Add "valid" character to result
    goto next_input_char

  invalid:
    StrCpy ${L_RESULT} ""

  done:
    StrCpy ${L_STRING} ${L_RESULT}  ; Result is either a string of decimal digits or ""
    Pop ${L_CHARSLEFT}
    Pop ${L_VALIDLIST}
    Pop ${L_VALIDCHAR}
    Pop ${L_OFFSET}
    Pop ${L_CURRENT}
    Pop ${L_RESULT}
    Exch ${L_STRING}                ; Place result on top of the stack

    !undef DECIMAL_DIGIT
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

!ifdef CREATEUSER
    #--------------------------------------------------------------------------
    # Installer Function: PPL_StrCheckDecimal
    #
    # This function is used during the installation process
    #--------------------------------------------------------------------------

    !insertmacro PPL_StrCheckDecimal ""
!endif


#--------------------------------------------------------------------------
# Macro: PPL_StrStr
#
# The installation process and the uninstall process may both use a function which checks if
# a given string appears inside another string. This macro makes maintenance easier by ensuring
# that both processes use identical functions, with the only difference being their names.
#
# NOTE:
# The !insertmacro PPL_StrStr "" and !insertmacro PPL_StrStr "un." commands are included in
# this file so the NSIS script can use 'Call PPL_StrStr' and 'Call un.PPL_StrStr' without
# additional preparation.
#
# Search for matching string
#
# Inputs:
#         (top of stack)     - the string to be found (needle)
#         (top of stack - 1) - the string to be searched (haystack)
# Outputs:
#         (top of stack)     - string starting with the match, if any
#
# Usage (after macro has been 'inserted'):
#
#         Push "this is a long string"
#         Push "long"
#         Call PPL_StrStr
#         Pop $R0
#         ($R0 at this point is "long string")
#
#--------------------------------------------------------------------------

!macro PPL_StrStr UN
  Function ${UN}PPL_StrStr

    !define L_NEEDLE            $R1   ; the string we are trying to match
    !define L_HAYSTACK          $R2   ; the string in which we search for a match
    !define L_NEEDLE_LENGTH     $R3
    !define L_HAYSTACK_LIMIT    $R4
    !define L_HAYSTACK_OFFSET   $R5   ; the first character has an offset of zero
    !define L_SUBSTRING         $R6   ; a string that might match the 'needle' string

    Exch ${L_NEEDLE}
    Exch
    Exch ${L_HAYSTACK}
    Push ${L_NEEDLE_LENGTH}
    Push ${L_HAYSTACK_LIMIT}
    Push ${L_HAYSTACK_OFFSET}
    Push ${L_SUBSTRING}

    StrLen ${L_NEEDLE_LENGTH} ${L_NEEDLE}
    StrLen ${L_HAYSTACK_LIMIT} ${L_HAYSTACK}

    ; If 'needle' is longer than 'haystack' then return empty string
    ; (to show 'needle' was not found in 'haystack')

    IntCmp ${L_NEEDLE_LENGTH} ${L_HAYSTACK_LIMIT} 0 0 not_found

    ; Adjust the search limit as there is no point in testing substrings
    ; which are known to be shorter than the length of the 'needle' string

    IntOp ${L_HAYSTACK_LIMIT} ${L_HAYSTACK_LIMIT} - ${L_NEEDLE_LENGTH}

    ; The first character is at offset 0

    StrCpy ${L_HAYSTACK_OFFSET} 0

  loop:
    StrCpy ${L_SUBSTRING} ${L_HAYSTACK} ${L_NEEDLE_LENGTH} ${L_HAYSTACK_OFFSET}
    StrCmp ${L_SUBSTRING} ${L_NEEDLE} match_found
    IntOp ${L_HAYSTACK_OFFSET} ${L_HAYSTACK_OFFSET} + 1
    IntCmp ${L_HAYSTACK_OFFSET} ${L_HAYSTACK_LIMIT} loop loop 0

  not_found:
    StrCpy ${L_NEEDLE} ""
    Goto exit

  match_found:
    StrCpy ${L_NEEDLE} ${L_HAYSTACK} "" ${L_HAYSTACK_OFFSET}

  exit:
    Pop ${L_SUBSTRING}
    Pop ${L_HAYSTACK_OFFSET}
    Pop ${L_HAYSTACK_LIMIT}
    Pop ${L_NEEDLE_LENGTH}
    Pop ${L_HAYSTACK}
    Exch ${L_NEEDLE}

    !undef L_NEEDLE
    !undef L_HAYSTACK
    !undef L_NEEDLE_LENGTH
    !undef L_HAYSTACK_LIMIT
    !undef L_HAYSTACK_OFFSET
    !undef L_SUBSTRING

    FunctionEnd
!macroend

!ifndef LFNFIXER
    #--------------------------------------------------------------------------
    # Installer Function: PPL_StrStr
    #
    # This function is used during the installation process
    #--------------------------------------------------------------------------

    !insertmacro PPL_StrStr ""
!endif


#--------------------------------------------------------------------------
# Macro: PPL_TrimNewlines
#
# The installation process and the uninstall process may both use a function to trim newlines
# from lines of text. This macro makes maintenance easier by ensuring that both processes use
# identical functions, with the only difference being their names.
#
# NOTE:
# The !insertmacro PPL_TrimNewlines "" and !insertmacro PPL_TrimNewlines "un." commands are
# included in this file so the NSIS script can use 'Call PPL_TrimNewlines' and
# 'Call un.PPL_TrimNewlines' without additional preparation.
#
# Inputs:
#         (top of stack)   - string which may end with one or more newlines
#
# Outputs:
#         (top of stack)   - the input string with the trailing newlines (if any) removed
#
# Usage (after macro has been 'inserted'):
#
#         Push "whatever$\r$\n"
#         Call un.PPL_TrimNewlines
#         Pop $R0
#         ($R0 at this point is "whatever")
#
#--------------------------------------------------------------------------

!macro PPL_TrimNewlines UN
  Function ${UN}PPL_TrimNewlines
    Exch $R0
    Push $R1
    Push $R2
    StrCpy $R1 0

  loop:
    IntOp $R1 $R1 - 1
    StrCpy $R2 $R0 1 $R1
    StrCmp $R2 "$\r" loop
    StrCmp $R2 "$\n" loop
    IntOp $R1 $R1 + 1
    IntCmp $R1 0 no_trim_needed
    StrCpy $R0 $R0 $R1

  no_trim_needed:
    Pop $R2
    Pop $R1
    Exch $R0
  FunctionEnd
!macroend

!ifndef LFNFIXER
    #--------------------------------------------------------------------------
    # Installer Function: PPL_TrimNewlines
    #
    # This function is used during the installation process
    #--------------------------------------------------------------------------

    !insertmacro PPL_TrimNewlines ""
!endif


#--------------------------------------------------------------------------
# End of 'ppl-library.nsh'
#--------------------------------------------------------------------------
