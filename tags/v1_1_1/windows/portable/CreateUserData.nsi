#-------------------------------------------------------------------------------------------
#
# CreateUserData.nsi --- This utility is called by the launcher for POPFile Portable when
#                        an empty 'Data' folder is detected. This user-friendly utility
#                        makes it easy for a new user to start using POPFile Portable.
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
#----------------------------------------------------------------------------------------

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
  ; Select LZMA compression (to generate smallest EXE file)
  ;--------------------------------------------------------------------------

  SetCompressor lzma

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
  ;--------------------------------------------------------------------------

  !define C_PFI_VERSION   "0.0.20"

  !define C_OUTFILE       "CreateUserData.exe"

  ;--------------------------------------------------------------------------
  ; The default NSIS caption is "$(^Name) Setup" so we override it here
  ;--------------------------------------------------------------------------

  Name "Create User Data for POPFile Portable"
  Caption "$(^Name)"

  OutFile "${C_OUTFILE}"

  ;--------------------------------------------------------------------------
  ; Windows Vista expects to find a manifest specifying the execution level
  ;--------------------------------------------------------------------------

  RequestExecutionLevel   user

#--------------------------------------------------------------------------
# User Registers (Global)
#--------------------------------------------------------------------------

  ; 'User Variables' (with names starting with 'G_') are used to hold GLOBAL data.

  Var G_CFG_DATA           ; full path to the configuration data used
                           ; (either the 'real' file or the 'default' one)

  Var G_POP3               ; POP3 port (1-65535)
  Var G_GUI                ; GUI port (1-65535)

  Var G_HWND               ; HWND of the dialog we are going to modify
  Var G_DLGITEM            ; HWND of the field we are going to modify on that dialog

  Var G_PLS_FIELD_1        ; used to customize LangString text strings
  Var G_PLS_FIELD_2        ; (to make it easier to translate them later)

  Var G_USERDIR            ; full path to the folder containing the 'popfile.cfg' file

  Var G_WINUSERNAME        ; used in some standard Language Strings

#--------------------------------------------------------------------------
# Use the nsDialog version of the "Modern User Interface"
#--------------------------------------------------------------------------

  !include "MUI.nsh"

#--------------------------------------------------------------------------
# Include library functions and macro definitions
#--------------------------------------------------------------------------

  ; Avoid compiler warnings by disabling the functions and definitions we do not use

  !define CREATEUSER

  !include "ppl-library.nsh"

  !include "nsis-library.nsh"

#--------------------------------------------------------------------------
# Version Information settings (for runpopfile.exe)
#--------------------------------------------------------------------------

  ; 'VIProductVersion' format is X.X.X.X where X is a number in range 0 to 65535
  ; representing the following values: Major.Minor.Release.Build

  VIProductVersion                          "${C_PFI_VERSION}.0"

  !define /date C_BUILD_YEAR                "%Y"

  VIAddVersionKey "ProductName"             "Create User Data for POPFile Portable"
  VIAddVersionKey "Comments"                "POPFile Homepage: \
                                             http://getpopfile.org/"
  VIAddVersionKey "CompanyName"             "The POPFile Project"
  VIAddVersionKey "LegalTrademarks"         "POPFile is a registered trademark \
                                             of John Graham-Cumming"
  VIAddVersionKey "LegalCopyright"          "Copyright (c) ${C_BUILD_YEAR} \
                                             John Graham-Cumming"
  VIAddVersionKey "FileDescription"         "Creates initial User Data for \
                                             POPFile Portable"
  VIAddVersionKey "FileVersion"             "${C_PFI_VERSION}"
  VIAddVersionKey "OriginalFilename"        "${C_OUTFILE}"

  VIAddVersionKey "Build Compiler"          "NSIS ${NSIS_VERSION}"
  VIAddVersionKey "Build Date/Time"         "${__DATE__} @ ${__TIME__}"
  !ifdef C_PPL_LIBRARY_VERSION
    VIAddVersionKey "PPL Library Version"   "${C_PPL_LIBRARY_VERSION}"
  !endif
  VIAddVersionKey "Build Script"            "${__FILE__}${MB_NL}\
  (${__TIMESTAMP__})"

#----------------------------------------------------------------------------------------
# CBP Configuration Data (to override defaults, un-comment the lines below and modify them)
#----------------------------------------------------------------------------------------
#   ; Maximum number of buckets handled (in range 2 to 8)
#
#   !define CBP_MAX_BUCKETS 8
#
#   ; Default bucket selection (use "" if no buckets are to be pre-selected)
#
#   !define CBP_DEFAULT_LIST "inbox|spam|personal|work"
#
#   Allow the names of the default buckets (for a 'clean' install) to be translated,
#   but they can use only the characters abcdefghijklmnopqrstuvwxyz_-0123456789
#
  !define CBP_DEFAULT_LIST "$(PFI_LANG_CBP_DEFAULT_BUCKETS)"
#
#   ; List of suggestions for bucket names (use "" if no suggestions are required)
#
#   !define CBP_SUGGESTION_LIST \
#   "admin|business|computers|family|financial|general|hobby|inbox|junk|list-admin|\
#   miscellaneous|not_spam|other|personal|recreation|school|security|shopping|spam|\
#   travel|work"
#
#   Allow the list of suggested bucket names (for a 'clean' install) to be translated,
#   but they can use only the characters abcdefghijklmnopqrstuvwxyz_-0123456789
#
  !define CBP_SUGGESTION_LIST "$(PFI_LANG_CBP_SUGGESTED_NAMES)"
#
#----------------------------------------------------------------------------------------
# Make the CBP package available
#----------------------------------------------------------------------------------------

  !include "..\CBP.nsh"

#--------------------------------------------------------------------------
# Configure the MUI pages
#--------------------------------------------------------------------------

  ;----------------------------------------------------------------
  ; Interface Settings - General Interface Settings
  ;----------------------------------------------------------------

  ; The icon files for the installer and uninstaller must have the same structure. For example,
  ; if one icon file contains a 32x32 16-colour image and a 16x16 16-colour image then the other
  ; file cannot just contain a 32x32 16-colour image, it must also have a 16x16 16-colour image.
  ; The order of the images in each icon file must also be the same.

  !define MUI_ICON                            "..\POPFileIcon\popfile.ico"

  ; The "Header" bitmap appears on all pages of the installer (except WELCOME & FINISH pages)
  ; and on all pages of the uninstaller.

  !define MUI_HEADERIMAGE
  !define MUI_HEADERIMAGE_BITMAP              "..\hdr-common.bmp"
  !define MUI_HEADERIMAGE_RIGHT

  ;----------------------------------------------------------------
  ;  Interface Settings - Interface Resource Settings
  ;----------------------------------------------------------------

  ; The banner provided by the default 'modern.exe' UI does not provide much room for the
  ; two lines of text, e.g. the German version is truncated, so we use a custom UI which
  ; provides slightly wider text areas. Each area is still limited to a single line of text.

  !define MUI_UI                              "..\UI\pfi_modern.exe"

  ; The 'hdr-common.bmp' logo is only 90 x 57 pixels, much smaller than the 150 x 57 pixel
  ; space provided by the default 'modern_headerbmpr.exe' UI, so we use a custom UI which
  ; leaves more room for the TITLE and SUBTITLE text.

  !define MUI_UI_HEADERIMAGE_RIGHT            "..\UI\pfi_headerbmpr.exe"

  ;----------------------------------------------------------------
  ;  Interface Settings - WELCOME/FINISH Page Interface Settings
  ;----------------------------------------------------------------

  ; The "Special" bitmap appears on the "WELCOME" and "FINISH" pages

  !define MUI_WELCOMEFINISHPAGE_BITMAP        "..\special.bmp"

  ;----------------------------------------------------------------
  ;  Interface Settings - Abort Warning Settings
  ;----------------------------------------------------------------

  ; Show a message box with a warning when the user closes the installation

  !define MUI_ABORTWARNING

  ;----------------------------------------------------------------
  ; Language Settings for MUI pages
  ;----------------------------------------------------------------

  ; Same "Language selection" dialog is used for the installer and the uninstaller
  ; so we override the standard "Installer Language" title to avoid confusion.

  !define MUI_LANGDLL_WINDOWTITLE             "Create User Data for POPFile Portable"

  ; Always show the language selection dialog, even if a language has been stored in the
  ; registry (the language stored in the registry will be selected as the default language)
  ; This makes it easy to recover from a previous 'bad' choice of language for the installer

  !define MUI_LANGDLL_ALWAYSSHOW
  !define MUI_LANGDLL_ALLLANGUAGES

#--------------------------------------------------------------------------
# Define the Page order for the installer (and the uninstaller)
#--------------------------------------------------------------------------

  ;---------------------------------------------------
  ; Installer Page - POP3 and UI Port Options
  ;---------------------------------------------------

  Page custom SetOptionsPage                  "CheckPortOptions"

  ;---------------------------------------------------
  ; Installer Page - Create Buckets (if necessary)
  ;---------------------------------------------------

  !insertmacro CBP_PAGE_SELECTBUCKETS

  ;---------------------------------------------------
  ; Installer Page - CloseWindow
  ;---------------------------------------------------

  Page custom CloseWindow

#--------------------------------------------------------------------------
# Language Support for the installer and uninstaller
#--------------------------------------------------------------------------

  ;-----------------------------------------
  ; Select the languages to be supported by installer/uninstaller.
  ;-----------------------------------------

  ; At least one language must be specified for the installer (the default is "English")

  !insertmacro PFI_LANG_LOAD "English" "-"

  ; Conditional compilation: if ENGLISH_MODE is defined, support only 'English'

  !ifndef ENGLISH_MODE
      !include "..\pfi-languages.nsh"
  !endif

#--------------------------------------------------------------------------
# General settings
#--------------------------------------------------------------------------

  ; Specify NSIS output filename

  OutFile "${C_OUTFILE}"

  ; Ensure user cannot use the /NCRC command-line switch to disable CRC checking

  CRCcheck Force

#--------------------------------------------------------------------------
# Reserve the files required by the installer (to improve performance)
#--------------------------------------------------------------------------

  ; Things that need to be extracted on startup (keep these lines before any File command!)
  ; Only useful when solid compression is used (by default, solid compression is enabled
  ; for BZIP2 and LZMA compression)

  !insertmacro MUI_RESERVEFILE_LANGDLL
  !insertmacro MUI_RESERVEFILE_INSTALLOPTIONS
  ReserveFile "..\ioA.ini"

#--------------------------------------------------------------------------
# Installer Function: .onInit
#
# Do not allow more than one copy the POPFile Portable Launcher to run
#
# Run silently if the '/menu' option has not been supplied on command-line
#--------------------------------------------------------------------------

Function .onInit

  !define L_RESERVED            $1    ; used in the system.dll call

  Push ${L_RESERVED}

  ; Ensure only one copy of this launcher is running

  System::Call \
  'kernel32::CreateMutexA(i 0, i 0, t "Only_One_CBP_utility_mutex") i .r1 ?e'
  Pop ${L_RESERVED}
  StrCmp ${L_RESERVED} 0 mutex_ok
  MessageBox MB_OK|MB_ICONEXCLAMATION "$(^Name) is already running"
  Abort

mutex_ok:
  StrCpy $G_WINUSERNAME "current user"

  Push "$EXEDIR"
  Call NSIS_GetParent
  Call NSIS_GetParent
  Pop $G_USERDIR
  StrCpy $G_USERDIR "$G_USERDIR\Data"

  ; Conditional compilation: if ENGLISH_MODE is defined, support only 'English'

  !ifndef ENGLISH_MODE
        !insertmacro MUI_LANGDLL_DISPLAY
  !endif

  !insertmacro MUI_INSTALLOPTIONS_EXTRACT_AS "..\ioA.ini" "ioA.ini"

  Pop ${L_RESERVED}

  !undef L_RESERVED

FunctionEnd

#--------------------------------------------------------------------------
# Installer Function: SetOptionsPage_Init
#
# This function adds language texts to the INI file used by the "SetOptionsPage" function
# (to make the custom page use the language selected by the user for the installer)
#--------------------------------------------------------------------------

Function SetOptionsPage_Init

  ; Ensure custom page matches the selected language (left-to-right or right-to-left order)

  !insertmacro MUI_INSTALLOPTIONS_WRITE "ioA.ini" "Settings" "RTL" "$(^RTL)"
  !insertmacro MUI_INSTALLOPTIONS_WRITE "ioA.ini" "Settings" "NumFields" "4"

  !insertmacro PFI_IO_TEXT "ioA.ini" "1" "$(PFI_LANG_OPTIONS_IO_POP3)"
  !insertmacro PFI_IO_TEXT "ioA.ini" "3" "$(PFI_LANG_OPTIONS_IO_GUI)"

FunctionEnd

#--------------------------------------------------------------------------
# Installer Function: CheckExistingConfigData
#
# This function is used to extract the POP3 and UI ports from the 'popfile.cfg'
# configuration file (if a copy is found when the wizard starts up). It also
# presets the skin to 'simplyblue' if there is no skin defined.
#--------------------------------------------------------------------------

Function CheckExistingConfigData

  !define L_SKIN      $R9     ; current skin setting

  Push ${L_SKIN}

  StrCpy $G_POP3 ""
  StrCpy $G_GUI ""

  ; See if we can get the current pop3 and gui port from an existing configuration.

  StrCpy $G_CFG_DATA "$G_USERDIR\popfile.cfg"
  IfFileExists "$G_CFG_DATA" extract_settings
  StrCpy $G_CFG_DATA "$G_USERDIR" -5
  StrCpy $G_CFG_DATA "$G_CFG_DATA\App\DefaultData\popfile.cfg"

extract_settings:
  Push $G_CFG_DATA
  Push "pop3_port"
  Call PPL_CfgSettingRead
  Pop $G_POP3

  Push $G_CFG_DATA
  Push "html_port"
  Call PPL_CfgSettingRead
  Pop $G_GUI

  ; Set 'simplyblue' skin if no skin is defined

  Push $G_CFG_DATA
  Push "html_skin"
  Call PPL_CfgSettingRead
  Pop ${L_SKIN}
  IfErrors 0 check_validity
  Push $G_CFG_DATA
  Push "html_skin"
  Push "simplyblue"
  Call PPL_CfgSettingWrite_without_backup
  Pop ${L_SKIN}

check_validity:
  ; check port values (config file may have no port data or invalid port data)

  StrCmp $G_POP3 $G_GUI 0 ports_differ

  ; Config file has no port data or same port used for POP3 and GUI
  ; (i.e. the data is not valid), so use POPFile defaults

  StrCpy $G_POP3 "110"
  StrCpy $G_GUI "8080"
  Goto ports_ok

ports_differ:
  StrCmp $G_POP3 "" default_pop3
  Push $G_POP3
  Call PPL_StrCheckDecimal
  Pop $G_POP3
  StrCmp $G_POP3 "" default_pop3
  IntCmp $G_POP3 1 pop3_ok default_pop3
  IntCmp $G_POP3 65535 pop3_ok pop3_ok

default_pop3:
  StrCpy $G_POP3 "110"
  StrCmp $G_POP3 $G_GUI 0 pop3_ok
  StrCpy $G_POP3 "111"

pop3_ok:
  StrCmp $G_GUI "" default_gui
  Push $G_GUI
  Call PPL_StrCheckDecimal
  Pop $G_GUI
  StrCmp $G_GUI "" default_gui
  IntCmp $G_GUI 1 ports_ok default_gui
  IntCmp $G_GUI 65535 ports_ok ports_ok

default_gui:
  StrCpy $G_GUI "8080"
  StrCmp $G_POP3 $G_GUI 0 ports_ok
  StrCpy $G_GUI "8081"

ports_ok:
  Pop ${L_SKIN}

  !undef L_SKIN

FunctionEnd

#--------------------------------------------------------------------------
# Installer Function: SetOptionsPage (generates a custom page)
#
# This function is used to configure the POP3 and UI ports, and
# whether or not POPFile should be started automatically when Windows starts.
#
# This function loads the validated values into $G_POP3 and $G_GUI and also
# sets $G_PFIFLAG to the state of the 'Run POPFile at Windows startup' checkbox
#
# A "leave" function (CheckPortOptions) is used to validate the port
# selections made by the user.
#--------------------------------------------------------------------------

Function SetOptionsPage
  ; Insert appropriate language strings into the custom page INI files
  ; (the CBP package creates its own INI file so there is no need for a CBP *Page_Init function)

  Call SetOptionsPage_Init

  Call CheckExistingConfigData

  !define L_DEFAULT_CFG   $R9   ; used to update the data in 'DefaultData' folder
  !define L_PORTLIST      $R8   ; combo box ports list
  !define L_RESULT        $R7

  Push ${L_DEFAULT_CFG}
  Push ${L_PORTLIST}
  Push ${L_RESULT}

  ; The function 'CheckExistingConfigData' loads $G_POP3 and $G_GUI with the settings found in
  ; a previously installed "popfile.cfg" file or if no such file is found, it loads the
  ; POPFile default values. Now we display these settings and allow the user to change them.

  ; The POP3 and GUI port numbers must be in the range 1 to 65535 inclusive, and they
  ; must be different. This function assumes that the values loaded by 'CheckExistingConfigData'
  ; into $G_POP3 and $G_GUI are valid.

  !insertmacro MUI_HEADER_TEXT "$(PFI_LANG_OPTIONS_TITLE)" "$(PFI_LANG_OPTIONS_SUBTITLE)"

  ; If the POP3 (or GUI) port determined by 'CheckExistingConfigData' is not present in the
  ; list of possible values for the POP3 (or GUI) combobox, add it to the end of the list.

  !insertmacro MUI_INSTALLOPTIONS_READ ${L_PORTLIST} "ioA.ini" "Field 2" "ListItems"
  Push "|${L_PORTLIST}|"
  Push "|$G_POP3|"
  Call PPL_StrStr
  Pop ${L_RESULT}
  StrCmp ${L_RESULT} "" 0 POP3_is_in_list
  StrCpy ${L_PORTLIST} "${L_PORTLIST}|$G_POP3"
  !insertmacro MUI_INSTALLOPTIONS_WRITE "ioA.ini" "Field 2" "ListItems" ${L_PORTLIST}

POP3_is_in_list:
  !insertmacro MUI_INSTALLOPTIONS_READ ${L_PORTLIST} "ioA.ini" "Field 4" "ListItems"
  Push "|${L_PORTLIST}|"
  Push "|$G_GUI|"
  Call PPL_StrStr
  Pop ${L_RESULT}
  StrCmp ${L_RESULT} "" 0 GUI_is_in_list
  StrCpy ${L_PORTLIST} "${L_PORTLIST}|$G_GUI"
  !insertmacro MUI_INSTALLOPTIONS_WRITE "ioA.ini" "Field 4" "ListItems" ${L_PORTLIST}

GUI_is_in_list:
  !insertmacro MUI_INSTALLOPTIONS_WRITE "ioA.ini" "Field 2" "State" $G_POP3
  !insertmacro MUI_INSTALLOPTIONS_WRITE "ioA.ini" "Field 4" "State" $G_GUI

  ; Now display the custom page and wait for the user to make their selections.
  ; The function "CheckPortOptions" will check the validity of the selections
  ; and refuse to proceed until suitable ports have been chosen.

  !insertmacro MUI_INSTALLOPTIONS_INITDIALOG "ioA.ini"
  Pop $G_HWND                 ; HWND of dialog we want to modify

  GetDlgItem $G_DLGITEM $HWNDPARENT 1           ; "Next" button, also used for "Install"
  SendMessage $G_DLGITEM ${WM_SETTEXT} 0 "STR:$(PFI_LANG_CBP_IO_CONTINUE)"

  !insertmacro MUI_INSTALLOPTIONS_SHOW

  ; Store validated data (for completeness)

  !insertmacro MUI_INSTALLOPTIONS_WRITE "ioA.ini" "Field 2" "State" $G_POP3
  !insertmacro MUI_INSTALLOPTIONS_WRITE "ioA.ini" "Field 4" "State" $G_GUI

  Push $G_CFG_DATA
  Push "pop3_port"
  Push $G_POP3
  Call PPL_CfgSettingWrite_without_backup
  Pop ${L_RESULT}

  Push $G_CFG_DATA
  Push "html_port"
  Push $G_GUI
  Call PPL_CfgSettingWrite_without_backup
  Pop ${L_RESULT}

  StrCmp $G_CFG_DATA "$G_USERDIR\popfile.cfg" 0 exit
  StrCpy ${L_DEFAULT_CFG} "$G_USERDIR" -5
  StrCpy ${L_DEFAULT_CFG} "${L_DEFAULT_CFG}\App\DefaultData\popfile.cfg"

  Push ${L_DEFAULT_CFG}
  Push "pop3_port"
  Push $G_POP3
  Call PPL_CfgSettingWrite_without_backup
  Pop ${L_RESULT}

  Push ${L_DEFAULT_CFG}
  Push "html_port"
  Push $G_GUI
  Call PPL_CfgSettingWrite_without_backup
  Pop ${L_RESULT}

exit:
  Pop ${L_RESULT}
  Pop ${L_PORTLIST}
  Pop ${L_DEFAULT_CFG}

  !undef L_PORTLIST
  !undef L_RESULT
  !undef L_DEFAULT_CFG

FunctionEnd

#--------------------------------------------------------------------------
# Installer Function: CheckPortOptions
# (the "leave" function for the custom page created by "SetOptionsPage")
#
# This function is used to validate the POP3 and UI ports selected by the user.
# If the selections are not valid, user is asked to select alternative values.
#--------------------------------------------------------------------------

Function CheckPortOptions

  !define L_RESULT    $R9

  Push ${L_RESULT}

  !insertmacro MUI_INSTALLOPTIONS_READ $G_POP3 "ioA.ini" "Field 2" "State"
  !insertmacro MUI_INSTALLOPTIONS_READ $G_GUI "ioA.ini" "Field 4" "State"

  ; strip leading zeroes and spaces from user input

  Push $G_POP3
  Call PPL_StrStripLZS
  Pop $G_POP3
  Push $G_GUI
  Call PPL_StrStripLZS
  Pop $G_GUI

  StrCmp $G_POP3 $G_GUI ports_must_differ
  Push $G_POP3
  Call PPL_StrCheckDecimal
  Pop ${L_RESULT}
  StrCmp ${L_RESULT} "" bad_pop3
  IntCmp $G_POP3 1 pop3_ok bad_pop3
  IntCmp $G_POP3 65535 pop3_ok pop3_ok

bad_pop3:
  MessageBox MB_OK|MB_ICONEXCLAMATION \
      "$(PFI_LANG_OPTIONS_MBPOP3_A)\
      ${MB_NL}${MB_NL}\
      $(PFI_LANG_OPTIONS_MBPOP3_B)\
      ${MB_NL}${MB_NL}\
      $(PFI_LANG_OPTIONS_MBPOP3_C)"
  Goto bad_exit

pop3_ok:
  Push $G_GUI
  Call PPL_StrCheckDecimal
  Pop ${L_RESULT}
  StrCmp ${L_RESULT} "" bad_gui
  IntCmp $G_GUI 1 good_exit bad_gui
  IntCmp $G_GUI 65535 good_exit good_exit

bad_gui:
  MessageBox MB_OK|MB_ICONEXCLAMATION \
      "$(PFI_LANG_OPTIONS_MBGUI_A)\
      ${MB_NL}${MB_NL}\
      $(PFI_LANG_OPTIONS_MBGUI_B)\
      ${MB_NL}${MB_NL}\
      $(PFI_LANG_OPTIONS_MBGUI_C)"
  Goto bad_exit

ports_must_differ:
  MessageBox MB_OK|MB_ICONEXCLAMATION \
      "$(PFI_LANG_OPTIONS_MBDIFF_1)\
      ${MB_NL}${MB_NL}\
      $(PFI_LANG_OPTIONS_MBDIFF_2)"

bad_exit:

  ; Stay with the custom page created by "SetOptionsPage"

  Pop ${L_RESULT}
  Abort

good_exit:

  ; Allow next page in the installation sequence to be shown

  Pop ${L_RESULT}

  !undef L_RESULT

FunctionEnd

#--------------------------------------------------------------------------
# Installer Function: CloseWindow
#
# Transfer some CBP information to the main 'Data' folder to make it easy
# for POPFile Portable to remove the empty corpus folders once the SQLite
# database has been created.
#--------------------------------------------------------------------------

Function CloseWindow

  !define C_SRC_FILE  "$PLUGINSDIR\${CBP_C_INIFILE}"
  !define C_CLEANONE  "$G_USERDIR\corpus.ini"

  HideWindow

  IfFileExists "${C_SRC_FILE}" 0 nothing_to_do

  !define L_FOLDER_COUNT  $R9
  !define L_FOLDER_PATH   $R8

  Push ${L_FOLDER_COUNT}
  Push ${L_FOLDER_PATH}

  ReadINIStr ${L_FOLDER_PATH} "${C_SRC_FILE}" "CBP Data" "CorpusPath"
  WriteINIStr "${C_CLEANONE}" "CBP Data" "CorpusPath" ${L_FOLDER_PATH}

  ReadINIStr ${L_FOLDER_COUNT} "${C_SRC_FILE}" "FolderList" "MaxNum"
  WriteINIStr "${C_CLEANONE}" "FolderList" "MaxNum" ${L_FOLDER_COUNT}

  StrCmp  ${L_FOLDER_COUNT} "" done
  StrCmp  ${L_FOLDER_COUNT} "0" done

loop:
  ReadINIStr ${L_FOLDER_PATH} "${C_SRC_FILE}" "FolderList" "Path-${L_FOLDER_COUNT}"
  StrCmp  ${L_FOLDER_PATH} "" try_next_one
  WriteINIStr "${C_CLEANONE}" "FolderList" "Path-${L_FOLDER_COUNT}" ${L_FOLDER_PATH}

try_next_one:
  IntOp ${L_FOLDER_COUNT} ${L_FOLDER_COUNT} - 1
  IntCmp ${L_FOLDER_COUNT} 0 done done loop

done:
  Pop ${L_FOLDER_PATH}
  Pop ${L_FOLDER_COUNT}

nothing_to_do:
  SendMessage $HWNDPARENT "0x408" "1" ""

  !undef L_FOLDER_COUNT
  !undef L_FOLDER_PATH

FunctionEnd

#--------------------------------------------------------------------------
# Installer Function: PPL_CfgSettingWrite_without_backup
#
# This function is used during the installation process
#--------------------------------------------------------------------------

  !insertmacro PPL_CfgSettingWrite_without_backup ""

#--------------------------------------------------------------------------
# Section: default
#--------------------------------------------------------------------------

Section default

  ; dummy

SectionEnd

#--------------------------------------------------------------------------
# End of 'CreateUserData.nsi'
#--------------------------------------------------------------------------
