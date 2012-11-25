#--------------------------------------------------------------------------
#
# pfidiag.nsi --- This NSIS script is used to create a diagnostic utility
#                 to assist in solving problems with the Windows version
#                 of POPFile, especially POPFile version 0.21.0 or later.
#
# Copyright (c) 2004-2012 John Graham-Cumming
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

  ; This version of the script has been tested with the "NSIS v2.46" compiler,
  ; released 6 December 2009. This particular compiler can be downloaded from
  ; http://prdownloads.sourceforge.net/nsis/nsis-2.46-setup.exe?download

  !define C_EXPECTED_VERSION  "v2.46"

  !define ${NSIS_VERSION}_found

  !ifndef ${C_EXPECTED_VERSION}_found
      !warning \
          "$\n\
          $\n***   NSIS COMPILER WARNING:\
          $\n***\
          $\n***   This script has only been tested using the \
          NSIS ${C_EXPECTED_VERSION} compiler\
          $\n***   and may not work properly with this \
          NSIS ${NSIS_VERSION} compiler\
          $\n***\
          $\n***   The resulting 'installer' program should be tested carefully!\
          $\n$\n"
  !endif

  !undef  ${NSIS_VERSION}_found
  !undef  C_EXPECTED_VERSION

  ;--------------------------------------------------------------------------
  ; Optional check on status of the extra NSIS plugins required by POPFile
  ; (The plugin status is _always_ checked when installer.nsi is compiled)
  ;--------------------------------------------------------------------------

  !include /NONFATAL "..\plugin-status.nsh"

#--------------------------------------------------------------------------
# Run-time command-line switches (used by 'pfidiag.exe')
#--------------------------------------------------------------------------
#
# /SIMPLE
#
# (If no command-line switch is supplied then this mode is selected)
#
# This command-line switch selects the default mode which displays a few key values.
# The display window is automatically scrolled to display the POPFile program and
# 'User Data' locations since these are likely to be of most interest to the user.
#
# /FULL
#
# By default (i.e. when no parameters are supplied) the utility displays enough
# information to identify the location of the 'User Data' files. If the /FULL
# command-line switch is supplied, the utility displays much more information
# (which might help debug strange behaviour, for example).
#
# /SHORTCUT
#
# This command-line switch creates a 'Start Menu' shortcut to the 'User Data' folder,
# accessed via Start -> Programs -> POPFile -> Support -> User Data (<username>)
#
# /MENU
#
# This command-line switch displays a page with a drop-down list allowing the required
# mode to be selected.
#
# /HELP
#
# Displays some simple notes about the command-line options.
#
#
# NOTES:
#
# (1)  Uppercase or lowercase may be used for the command-line switches.
#
# (2)  If no command-line switch is supplied then the utility assumes '/SIMPLE' was
#      entered since a 'simple' report is likely to contain sufficient information
#      for the user.
#
# (3)  It is assumed that only one command-line option will be supplied. If an
#      invalid option or a combination of options is supplied then the /HELP
#      option is selected.
#
#--------------------------------------------------------------------------


  ;--------------------------------------------------------------------------
  ; POPFile constants have names beginning with 'C_' (e.g. C_README)
  ;--------------------------------------------------------------------------

  !define C_VERSION   "0.5.0"

  !define C_OUTFILE   "pfidiag.exe"

  ;--------------------------------------------------------------------------
  ; The default NSIS caption is "$(^Name) Setup" so we override it here
  ;--------------------------------------------------------------------------

  Name    "PFI Diagnostic Utility"
  Caption "$(^Name) v${C_VERSION}"

  ; Check data created by the "main" POPFile installer (setup.exe) and/or
  ; its 'Add POPFile User' wizard (adduser.exe)

  !define C_PFI_PRODUCT                 "POPFile"
  !define C_PFI_PRODUCT_REGISTRY_ENTRY  "Software\POPFile Project\${C_PFI_PRODUCT}\MRI"

  ;--------------------------------------------------------------------------
  ; Windows Vista & Windows 7 expect to find a manifest specifying the execution level
  ;--------------------------------------------------------------------------

  RequestExecutionLevel   user

#--------------------------------------------------------------------------
# Use the "Modern User Interface"
#--------------------------------------------------------------------------

  !include "MUI.nsh"

#--------------------------------------------------------------------------
# Include private library functions and macro definitions
#--------------------------------------------------------------------------

  ; Avoid compiler warnings by disabling the functions and definitions we do not use

  !define PFIDIAG

  !include "..\pfi-library.nsh"
  !include "..\pfi-nsis-library.nsh"

#--------------------------------------------------------------------------
# Version Information settings (for the utility's EXE file)
#--------------------------------------------------------------------------

  ; 'VIProductVersion' format is X.X.X.X where X is a number in range 0 to 65535
  ; representing the following values: Major.Minor.Release.Build

  VIProductVersion                          "${C_VERSION}.0"

  !define /date C_BUILD_YEAR                "%Y"

  VIAddVersionKey "ProductName"             "PFI Diagnostic Utility"
  VIAddVersionKey "Comments"                "POPFile Homepage: http://getpopfile.org/"
  VIAddVersionKey "CompanyName"             "The POPFile Project"
  VIAddVersionKey "LegalTrademarks"         "POPFile is a registered trademark of \
                                            John Graham-Cumming"
  VIAddVersionKey "LegalCopyright"          "Copyright (c) ${C_BUILD_YEAR} \
                                            John Graham-Cumming"
  VIAddVersionKey "FileDescription"         "PFI Diagnostic Utility"
  VIAddVersionKey "FileVersion"             "${C_VERSION}"
  VIAddVersionKey "OriginalFilename"        "${C_OUTFILE}"

  VIAddVersionKey "Build Compiler"          "NSIS ${NSIS_VERSION}"
  VIAddVersionKey "Build Date/Time"         "${__DATE__} @ ${__TIME__}"
  !ifdef C_PFI_LIBRARY_VERSION
    VIAddVersionKey "Build Library Version" "${C_PFI_LIBRARY_VERSION}"
  !endif
  !ifdef C_NSIS_LIBRARY_VERSION
    VIAddVersionKey "NSIS Library Version"  "${C_NSIS_LIBRARY_VERSION}"
  !endif
  VIAddVersionKey "Build Script"            "${__FILE__}$\r$\n(${__TIMESTAMP__})"

#--------------------------------------------------------------------------
# User Variables (Global)
#--------------------------------------------------------------------------

  ; 'User Variables' (with names starting with 'G_') are used to hold GLOBAL data.

  Var G_WINUSERNAME       ; current Windows user login name

  Var G_WIN_OS_TYPE       ; 0 = Win9x, 1 = more modern version of Windows

  Var G_EXPECTED_ROOT     ; expected POPFILE_ROOT value (POPFile program location)
  Var G_EXPECTED_USER     ; expected POPFILE_USER value (User Data' location)

  Var G_POPFILE_USER      ; used to pass 'User Data' path to various internal functions
  Var G_POPFILE_USER_ENV  ; path to the 'User Data' location (from environment variable)
  Var G_POPFILE_USER_REG  ; path to the 'User Data' location (from HKCU registry data)

  Var G_REPORT_MODE       ; used to check for 'simple' or 'full' report mode

#--------------------------------------------------------------------------
# Macros used to simplify many of the tests
#--------------------------------------------------------------------------

  ;---------------------------------------------------------------
  ; Differentiate between non-existent and empty registry strings
  ;---------------------------------------------------------------

  !macro CHECK_REG_ENTRY VALUE ROOT_KEY SUB_KEY NAME MESSAGE

      !insertmacro PFI_UNIQUE_ID

      ClearErrors
      ReadRegStr "${VALUE}" ${ROOT_KEY} "${SUB_KEY}" "${NAME}"
      StrCmp "${VALUE}" "" 0 show_value_${PFI_UNIQUE_ID}
      IfErrors 0 show_value_${PFI_UNIQUE_ID}
      DetailPrint "${MESSAGE}= ><"
      Goto continue_${PFI_UNIQUE_ID}

    show_value_${PFI_UNIQUE_ID}:
      DetailPrint "${MESSAGE}= < ${VALUE} >"

    continue_${PFI_UNIQUE_ID}:
  !macroend

  ;---------------------------------------------------------------------
  ; Check registry strings used for the "0.21 Test Installer"
  ;---------------------------------------------------------------------

  !macro CHECK_TESTMRI_ENTRY VALUE ROOT_KEY NAME MESSAGE
    !insertmacro CHECK_REG_ENTRY "${VALUE}" \
                "${ROOT_KEY}" "Software\POPFile Project\POPFileTest\MRI" \
                "${NAME}" "${MESSAGE}"
  !macroend

  ;---------------------------------------------------------------------
  ; Check registry strings used for the "PFI Testbed"
  ; used to test installer translations
  ;---------------------------------------------------------------------

  !macro CHECK_TESTBED_ENTRY VALUE ROOT_KEY NAME MESSAGE
    !insertmacro CHECK_REG_ENTRY "${VALUE}" \
                "${ROOT_KEY}" "Software\POPFile Project\PFI Testbed\MRI" \
                "${NAME}" "${MESSAGE}"
  !macroend

  ;---------------------------------------------------------------------
  ; Check registry strings used for the "real" POPFile installer (0.21.0 or later)
  ;---------------------------------------------------------------------

  !macro CHECK_MRI_ENTRY VALUE ROOT_KEY NAME MESSAGE
    !insertmacro CHECK_REG_ENTRY "${VALUE}" \
                "${ROOT_KEY}" "Software\POPFile Project\POPFile\MRI" \
                "${NAME}" "${MESSAGE}"
  !macroend

  ;---------------------------------------------------------------------------
  ; Differentiate between non-existent and empty POPFile environment variables
  ; (on Win9x systems it is quite normal for these variables to be undefined, as
  ; the 'runpopfile.exe' program creates them 'on the fly' when it runs POPFile)
  ;---------------------------------------------------------------------------

  !macro CHECK_ENVIRONMENT REGISTER ENV_VARIABLE MESSAGE

      !insertmacro PFI_UNIQUE_ID

      ClearErrors
      ReadEnvStr "${REGISTER}" "${ENV_VARIABLE}"
      StrCmp "${REGISTER}" "" 0 show_value_${PFI_UNIQUE_ID}
      IfErrors 0 show_value_${PFI_UNIQUE_ID}
      StrCmp $G_WIN_OS_TYPE "1" notWin9x_${PFI_UNIQUE_ID}
      DetailPrint "${MESSAGE}= ><   (this is OK)"
      Goto continue_${PFI_UNIQUE_ID}

    notWin9x_${PFI_UNIQUE_ID}:
      DetailPrint "${MESSAGE}= ><"
      Goto continue_${PFI_UNIQUE_ID}

    show_value_${PFI_UNIQUE_ID}:
      DetailPrint "${MESSAGE}= < ${REGISTER} >"

    continue_${PFI_UNIQUE_ID}:
  !macroend

  ;---------------------------------------------------------------------------
  ; Differentiate between non-existent and empty Kakasi environment variables
  ; (these variables are only defined if the Kakasi software, one of the Nihongo
  ; (Japanese) parsers, has been installed)
  ;---------------------------------------------------------------------------

  !macro CHECK_KAKASI REGISTER ENV_VARIABLE MESSAGE

      !insertmacro PFI_UNIQUE_ID

      ClearErrors
      ReadEnvStr "${REGISTER}" "${ENV_VARIABLE}"
      StrCmp "${REGISTER}" "" 0 show_value_${PFI_UNIQUE_ID}
      IfErrors 0 show_value_${PFI_UNIQUE_ID}
      IfFileExists "$G_EXPECTED_ROOT\kakasi\*.*" Kakasi_${PFI_UNIQUE_ID}
      DetailPrint "${MESSAGE}= ><   (this is OK)"
      Goto continue_${PFI_UNIQUE_ID}

    Kakasi_${PFI_UNIQUE_ID}:
      DetailPrint "${MESSAGE}= ><"
      Goto continue_${PFI_UNIQUE_ID}

    show_value_${PFI_UNIQUE_ID}:
      DetailPrint "${MESSAGE}= < ${REGISTER} >"

    continue_${PFI_UNIQUE_ID}:
  !macroend

  ;---------------------------------------------------------------------------
  ; Differentiate between a non-existent and an empty MeCab environment variable
  ; (this variable is only defined if the MeCab software, one of the Nihongo
  ; (Japanese) parsers, has been installed)
  ;---------------------------------------------------------------------------

  !macro CHECK_MECAB REGISTER ENV_VARIABLE MESSAGE

      !insertmacro PFI_UNIQUE_ID

      ClearErrors
      ReadEnvStr "${REGISTER}" "${ENV_VARIABLE}"
      StrCmp "${REGISTER}" "" 0 show_value_${PFI_UNIQUE_ID}
      IfErrors 0 show_value_${PFI_UNIQUE_ID}
      IfFileExists "$G_EXPECTED_ROOT\mecab\*.*" MeCab_${PFI_UNIQUE_ID}
      DetailPrint "${MESSAGE}= ><   (this is OK)"
      Goto continue_${PFI_UNIQUE_ID}

    MeCab_${PFI_UNIQUE_ID}:
      DetailPrint "${MESSAGE}= ><"
      Goto continue_${PFI_UNIQUE_ID}

    show_value_${PFI_UNIQUE_ID}:
      DetailPrint "${MESSAGE}= < ${REGISTER} >"

    continue_${PFI_UNIQUE_ID}:
  !macroend

  ;---------------------------------------------------------------------------
  ; Macro used to simplify the code used to extract settings from
  ; POPFile's configuration data (popfile.cfg)
  ;---------------------------------------------------------------------------

!macro READ_CONFIG VARIABLE SETTING

  Push "$G_POPFILE_USER\popfile.cfg"
  Push "${SETTING}"
  Call PFI_CfgSettingRead
  Pop ${VARIABLE}

!macroend


#--------------------------------------------------------------------------
# Configure the MUI pages
#--------------------------------------------------------------------------

  ;----------------------------------------------------------------
  ; Interface Settings - General Interface Settings
  ;----------------------------------------------------------------

  ; The icon file for the utility

  !define MUI_ICON                            "pfinfo.ico"

  !define MUI_HEADERIMAGE
  !define MUI_HEADERIMAGE_BITMAP              "..\hdr-common.bmp"
  !define MUI_HEADERIMAGE_RIGHT

  ; If the /MENU command-line option is used then the COMPONENTS page will
  ; be shown to allow the user to select the required mode from a drop-down
  ; list. Override the text shown on the COMPONENT page's "Install" button.

  InstallButtonText                           "$(PFI_LANG_DIAG_INSTALLBUTTON_TEXT)"

  ;----------------------------------------------------------------
  ;  Interface Settings - Interface Resource Settings
  ;----------------------------------------------------------------

  ; The banner provided by the default 'modern.exe' UI does not provide much room
  ; for the two lines of text, e.g. the German version is truncated, so we use a
  ; custom UI which provides slightly wider text areas. Each area is still limited
  ; to a single line of text.

  !define MUI_UI                              "..\UI\pfi_modern.exe"

  ; The 'hdr-common.bmp' logo is only 90 x 57 pixels, much smaller than the
  ; 150 x 57 pixel space provided by the default 'modern_headerbmpr.exe' UI,
  ; so we use a custom UI which leaves more room for the TITLE and SUBTITLE text.

  !define MUI_UI_HEADERIMAGE_RIGHT            "..\UI\pfi_headerbmpr.exe"

  ;----------------------------------------------------------------
  ;  Interface Settings - Installer Finish Page Interface Settings
  ;----------------------------------------------------------------

  ; Show the installation log and leave the window open when this utility has finished.

  ShowInstDetails show

  !define MUI_FINISHPAGE_NOAUTOCLOSE

#--------------------------------------------------------------------------
# Define the Page order for the utility
#--------------------------------------------------------------------------

  ;---------------------------------------------------
  ; Installer Page - Select diagnostic mode (optional)
  ;---------------------------------------------------

  ; Use a "pre" function to determine whether or not the COMPONENTS page is shown
  ; (the COMPONENTS page displays a dropdown list of program modes or options)

  !define MUI_PAGE_CUSTOMFUNCTION_PRE CheckIfMenuPageRequired

  ; Override the standard "Choose Components" page header

  !define MUI_PAGE_HEADER_TEXT                      "$(PFI_LANG_DIAG_COMP_HDR)"
  !define MUI_PAGE_HEADER_SUBTEXT                   "$(PFI_LANG_DIAG_COMP_SUBHDR)"

  ; Override the standard "Choose installation..." text and
  ; disable the display of the components list and space requirements

  !define MUI_COMPONENTSPAGE_TEXT_TOP               "$(PFI_LANG_DIAG_COMP_TEXT_TOP)"
  !define MUI_COMPONENTSPAGE_TEXT_INSTTYPE          \
      "$(PFI_LANG_DIAG_COMP_TEXT_INSTTYPE)"

  !define MUI_COMPONENTSPAGE_NODESC

  SpaceTexts none

  !insertmacro MUI_PAGE_COMPONENTS

  ;---------------------------------------------------
  ; Installer Page - Generate Diagnostic Report
  ;---------------------------------------------------

  ; Override the standard "Installing..." page header

  !define MUI_PAGE_HEADER_TEXT                      "$(PFI_LANG_DIAG_STD_HDR)"
  !define MUI_PAGE_HEADER_SUBTEXT                   "$(PFI_LANG_DIAG_STD_SUBHDR)"

  ; Override the standard "Installation complete..." page header

  !define MUI_INSTFILESPAGE_FINISHHEADER_TEXT       "$(PFI_LANG_DIAG_END_HDR)"
  !define MUI_INSTFILESPAGE_FINISHHEADER_SUBTEXT    "$(PFI_LANG_DIAG_END_SUBHDR)"

  !insertmacro MUI_PAGE_INSTFILES

#--------------------------------------------------------------------------
# Language Support for the utility
#--------------------------------------------------------------------------

  !insertmacro MUI_LANGUAGE "English"

  ;--------------------------------------------------------------------------
  ; Current build only supports English and uses local strings
  ; instead of language strings from 'languages\*-pfi.nsh' files
  ;--------------------------------------------------------------------------

  !macro PFI_DIAG_TEXT NAME VALUE
    LangString ${NAME} ${LANG_ENGLISH} "${VALUE}"
  !macroend

  ;--------------------------------------------------------------------------
  ; COMPONENTS page: Text for the "Install" button
  ;--------------------------------------------------------------------------

  !insertmacro PFI_DIAG_TEXT "PFI_LANG_DIAG_INSTALLBUTTON_TEXT" \
         "Start"

  ;--------------------------------------------------------------------------
  ; COMPONENTS page: MUI Header text strings
  ;--------------------------------------------------------------------------

  !insertmacro PFI_DIAG_TEXT "PFI_LANG_DIAG_COMP_HDR" \
         "Select required diagnostic action"
  !insertmacro PFI_DIAG_TEXT "PFI_LANG_DIAG_COMP_SUBHDR" \
        "Prepare simple or full diagnostic reports, create a 'UserData' shortcut, \
        or show help"

  ;--------------------------------------------------------------------------
  ; COMPONENTS page: Text strings used above and to the left of the drop-down list
  ;--------------------------------------------------------------------------

  !insertmacro PFI_DIAG_TEXT "PFI_LANG_DIAG_COMP_TEXT_TOP" \
         "Select the required action from the list below. \
         Click '$(PFI_LANG_DIAG_INSTALLBUTTON_TEXT)' to perform the selected action."
  !insertmacro PFI_DIAG_TEXT "PFI_LANG_DIAG_COMP_TEXT_INSTTYPE" \
        "Select the diagnostic action:"

  ;--------------------------------------------------------------------------
  ; COMPONENTS page: Text strings for the drop-down list
  ;--------------------------------------------------------------------------

  !insertmacro PFI_DIAG_TEXT "PFI_LANG_DIAG_COMP_TEXT_INSTTYPE_SIMPLE" \
         "Simple report with the program and data locations"
  !insertmacro PFI_DIAG_TEXT "PFI_LANG_DIAG_COMP_TEXT_INSTTYPE_FULL" \
         "Full diagnostic report"
  !insertmacro PFI_DIAG_TEXT "PFI_LANG_DIAG_COMP_TEXT_INSTTYPE_HELP" \
         "Display a simple help page for this utility"
  !insertmacro PFI_DIAG_TEXT "PFI_LANG_DIAG_COMP_TEXT_INSTTYPE_SHORTCUT" \
         "Make a 'Start Menu' shortcut to the 'User Data' folder"

  ;--------------------------------------------------------------------------
  ; INSTFILES page: MUI Header text strings shown whilst processing
  ;--------------------------------------------------------------------------

  !insertmacro PFI_DIAG_TEXT "PFI_LANG_DIAG_STD_HDR" \
         "Generating the PFI Diagnostic report..."
  !insertmacro PFI_DIAG_TEXT "PFI_LANG_DIAG_STD_SUBHDR" \
        "Searching for POPFile registry entries and the POPFile environment variables"

  ;--------------------------------------------------------------------------
  ; INSTFILES page: : Final MUI Header text strings
  ;--------------------------------------------------------------------------

  !insertmacro PFI_DIAG_TEXT "PFI_LANG_DIAG_END_HDR" \
        "POPFile Installer Diagnostic Utility"
  !insertmacro PFI_DIAG_TEXT "PFI_LANG_DIAG_END_SUBHDR" \
        "Use 'PFIDIAG /MENU' to get a menu or 'PFIDIAG /HELP' to show help screen"

  ;--------------------------------------------------------------------------
  ; INSTFILES page: Text string shown above the progress bar when finished
  ;--------------------------------------------------------------------------

  !insertmacro PFI_DIAG_TEXT "PFI_LANG_DIAG_RIGHTCLICK" \
        "Right-click in the window below to copy the report to the clipboard"


#--------------------------------------------------------------------------
# General settings
#--------------------------------------------------------------------------

  ; Specify EXE filename and icon for the utility

  OutFile "${C_OUTFILE}"

  ; Ensure details are shown, so user can see the diagnostic report

  ShowInstDetails show

  ; Only a fixed number of installation types are supported
  ; so there is no need to display a components list

  InstType /COMPONENTSONLYONCUSTOM
  InstType /NOCUSTOM

  ; Use installation types to control which sections get executed. Defines
  ; are used instead of hard coded numbers because it is easier to maintain
  ; code like
  ;
  ;     SectionIn ${C_INST_TYPE_SIMPLE} ${C_INST_TYPE_FULL} ${C_INST_TYPE_SHORTCUT} RO
  ;     StrCmp ${L_TEMP} "${C_INST_TYPE_INDEX_SIMPLE}" simple
  ;
  ; than it is to maintain code like
  ;
  ;     SectionIn 1 2 4 RO
  ;     StrCmp $R9 0 simple
  ;

  ; The following macro automates the generation of the C_INST_TYPE_* constants
  ; mentioned above and assigns meaningful strings for the component selection
  ; drop-down list

  !macro ADD_INST_TYPE INSTALL_TYPE_NAME
      !ifndef V_INST_TYPE_IDX
        !define V_INST_TYPE_IDX   "0"
      !endif
      InstType "${INSTALL_TYPE_NAME}"
      !define /math C_INST_TYPE_${INSTALL_TYPE_NAME} ${V_INST_TYPE_IDX} + 1
      !define C_INST_TYPE_INDEX_${INSTALL_TYPE_NAME} ${V_INST_TYPE_IDX}
      !undef V_INST_TYPE_IDX
      !define V_INST_TYPE_IDX ${C_INST_TYPE_${INSTALL_TYPE_NAME}}
  !macroend

  ; If the COMPONENTS page is displayed the 'CheckIfMenuPageRequired' function
  ; ensures the drop-down list of installation types contains more than just
  ; these rather cryptic one-word descriptions for the installation types.

  !insertmacro ADD_INST_TYPE "simple"
  !insertmacro ADD_INST_TYPE "full"
  !insertmacro ADD_INST_TYPE "help"
  !insertmacro ADD_INST_TYPE "shortcut"


;--------------------------------------------------------------------------
; Section: Start Report
;--------------------------------------------------------------------------

Section "Start Report"
  SectionIn ${C_INST_TYPE_SIMPLE} ${C_INST_TYPE_FULL} RO

  !define L_TEMP        $R9

  Push ${L_TEMP}

  GetCurInstType $G_REPORT_MODE
  StrCmp $G_REPORT_MODE "${C_INST_TYPE_INDEX_SIMPLE}" simple
  StrCmp $G_REPORT_MODE "${C_INST_TYPE_INDEX_FULL}" full
  StrCpy ${L_TEMP} "Internal Error: GetCurInstType = $G_REPORT_MODE"
  Goto report

simple:
  StrCpy ${L_TEMP} "simple mode"
  Goto report

full:
  StrCpy ${L_TEMP} "full mode"

report:
  SetDetailsPrint listonly

  DetailPrint "------------------------------------------------------------"
  DetailPrint "POPFile $(^Name) v${C_VERSION} (${L_TEMP})"
  DetailPrint "------------------------------------------------------------"
  DetailPrint "String data report format (not used for numeric data)"
  DetailPrint ""
  DetailPrint "string not found              :  ><"
  DetailPrint "empty string found            :  <  >"
  DetailPrint "string with 'xyz' value found :  < xyz >"
  DetailPrint "------------------------------------------------------------"
  DetailPrint ""

  Pop ${L_TEMP}

  !undef L_TEMP

SectionEnd


;--------------------------------------------------------------------------
; Section: User Name And Type
;--------------------------------------------------------------------------

Section "User Name And Type"
  SectionIn ${C_INST_TYPE_SIMPLE} ${C_INST_TYPE_FULL} ${C_INST_TYPE_SHORTCUT} RO

  !define L_WINUSERTYPE    $R9     ; user's rights

  Push ${L_WINUSERTYPE}

  ; The 'UserInfo' plugin may return an error if run on a Win9x system but
  ; since Win9x systems do not support different account types, we treat this
  ; error as if user has 'Admin' rights.

  ClearErrors
  UserInfo::GetName
  IfErrors 0 got_name

  ; Assume Win9x system, so user has 'Admin' rights

  StrCpy $G_WINUSERNAME "UnknownUser"
  StrCpy ${L_WINUSERTYPE} "Admin"
  Goto section_end

got_name:
  Pop $G_WINUSERNAME
  StrCmp $G_WINUSERNAME "" 0 get_usertype
  StrCpy $G_WINUSERNAME "UnknownUser"

get_usertype:
  UserInfo::GetAccountType
  Pop ${L_WINUSERTYPE}
  StrCmp ${L_WINUSERTYPE} "Admin" section_end
  StrCmp ${L_WINUSERTYPE} "Power" section_end
  StrCmp ${L_WINUSERTYPE} "User" section_end
  StrCmp ${L_WINUSERTYPE} "Guest" section_end
  StrCpy ${L_WINUSERTYPE} "Unknown"

section_end:
  DetailPrint "Current UserName  = $G_WINUSERNAME (${L_WINUSERTYPE})"
  DetailPrint ""

  Pop ${L_WINUSERTYPE}

  !undef L_WINUSERTYPE

SectionEnd


;--------------------------------------------------------------------------
; Section: OS Type And IE Version
;--------------------------------------------------------------------------

Section "OS Type and IE Version"
  SectionIn ${C_INST_TYPE_FULL} RO

  !define L_OSARCH    $R9
  !define L_OSNAME    $R8
  !define L_OSTYPE    $R7
  !define L_VERSION   $R6

  Push ${L_OSARCH}
  Push ${L_OSNAME}
  Push ${L_OSTYPE}
  Push ${L_VERSION}

  GetVersion::WindowsName
  Pop ${L_OSNAME}
  GetVersion::WindowsType
  Pop ${L_OSTYPE}
  GetVersion::WindowsPlatformArchitecture
  Pop ${L_OSARCH}
  DetailPrint "Operating System  = Windows ${L_OSNAME} ${L_OSTYPE} (${L_OSARCH}-bit)"
  DetailPrint "IsNT return code  = $G_WIN_OS_TYPE"

  Call PFI_GetIEVersion
  Pop ${L_VERSION}
  DetailPrint "Internet Explorer = ${L_VERSION}"
  DetailPrint ""

  Pop ${L_VERSION}
  Pop ${L_OSTYPE}
  Pop ${L_OSNAME}
  Pop ${L_OSARCH}

  !undef L_OSARCH
  !undef L_OSNAME
  !undef L_OSTYPE
  !undef L_VERSION

SectionEnd


;--------------------------------------------------------------------------
; Section: Location of temporary files
;--------------------------------------------------------------------------

Section "Location of temporary files"
  SectionIn ${C_INST_TYPE_FULL} RO

  DetailPrint "------------------------------------------------------------"
  DetailPrint "Location used to store temporary files"
  DetailPrint "------------------------------------------------------------"

  DetailPrint ""
  DetailPrint "$$TEMP folder path = < $TEMP >"
  DetailPrint ""

SectionEnd


;--------------------------------------------------------------------------
; Section: Start Menu Locations and Shortcuts
;--------------------------------------------------------------------------

Section "Start Menu and Shortcuts"
  SectionIn ${C_INST_TYPE_FULL} RO

  !define L_ALL_USERS       $R9   ; count of 'all users' StartUp POPFile shortcuts
  !define L_CURRENT_USER    $R8   ; count of 'current user' StartUp POPFile shortcuts
  !define L_TEMP            $R7

  Push ${L_ALL_USERS}
  Push ${L_CURRENT_USER}
  Push ${L_TEMP}

  DetailPrint "------------------------------------------------------------"
  DetailPrint "Start Menu Locations"
  DetailPrint "------------------------------------------------------------"
  DetailPrint ""

  SetShellVarContext all
  DetailPrint "AU: $$SMPROGRAMS   = < $SMPROGRAMS >"
  DetailPrint "AU: $$SMSTARTUP    = < $SMSTARTUP >"
  StrCpy ${L_TEMP} $SMSTARTUP
  DetailPrint ""
  DetailPrint "Search results for the $\"AU: $$SMSTARTUP$\" folder:"
  Push "$SMSTARTUP"
  Call AnalyseShortcuts
  Pop ${L_ALL_USERS}
  DetailPrint ""

  SetShellVarContext current
  DetailPrint "CU: $$SMPROGRAMS   = < $SMPROGRAMS >"
  DetailPrint "CU: $$SMSTARTUP    = < $SMSTARTUP >"

  ; If 'all users' and 'current user' use the same StartUp folder
  ; then there is no need to check it again

  StrCmp ${L_TEMP} "$SMSTARTUP" 0 check_CU_shortcuts
  DetailPrint ""
  DetailPrint "($\"CU: $$SMSTARTUP$\" folder is same as $\"AU: $$SMSTARTUP$\" folder)"
  Goto section_end

check_CU_shortcuts:
  DetailPrint ""
  DetailPrint "Search results for the $\"CU: $$SMSTARTUP$\" folder:"
  Push "$SMSTARTUP"
  Call AnalyseShortcuts
  Pop ${L_CURRENT_USER}

  IntOp ${L_TEMP}  ${L_ALL_USERS} +  ${L_CURRENT_USER}
  IntCmp ${L_TEMP} 1 section_end section_end
  DetailPrint ""
  DetailPrint "'POPFile' total   = ${L_TEMP}"
  DetailPrint "^^^^ Warning ^^^^   The $\"'POPFile' total$\" is greater than one"

section_end:
  Pop ${L_TEMP}
  Pop ${L_CURRENT_USER}
  Pop ${L_ALL_USERS}

  !undef L_ALL_USERS
  !undef L_CURRENT_USER
  !undef L_TEMP

SectionEnd


;--------------------------------------------------------------------------
; Section: Obsolete/Testbed Registry Entries
;--------------------------------------------------------------------------

Section "Obsolete/Testbed Registry Data"
  SectionIn ${C_INST_TYPE_FULL} RO

  !define L_REGDATA    $R9   ; data read from registry

  Push ${L_REGDATA}

  DetailPrint ""
  DetailPrint "------------------------------------------------------------"
  DetailPrint "Obsolete/testbed Registry Entries"
  DetailPrint "------------------------------------------------------------"
  DetailPrint ""

  DetailPrint "[1] Pre-0.21 Data:"
  DetailPrint ""

  !insertmacro CHECK_REG_ENTRY "${L_REGDATA}" \
      "HKLM" "Software\POPFile" "InstallLocation" "Pre-0.21 POPFile  "
  !insertmacro CHECK_REG_ENTRY "${L_REGDATA}" \
      "HKLM" "Software\POPFile Testbed" "InstallLocation" "Pre-0.21 Testbed  "
  DetailPrint ""

  DetailPrint "[2] 0.21 Test Installer Data:"
  DetailPrint ""

  !insertmacro CHECK_TESTMRI_ENTRY "${L_REGDATA}" \
      "HKLM" "RootDir_LFN" "HKLM: RootDir_LFN "
  !insertmacro CHECK_TESTMRI_ENTRY "${L_REGDATA}" \
      "HKLM" "RootDir_SFN" "HKLM: RootDir_SFN "
  DetailPrint ""

  !insertmacro CHECK_TESTMRI_ENTRY "${L_REGDATA}" \
      "HKCU" "RootDir_LFN" "HKCU: RootDir_LFN "
  !insertmacro CHECK_TESTMRI_ENTRY "${L_REGDATA}" \
      "HKCU" "RootDir_SFN" "HKCU: RootDir_SFN "
  !insertmacro CHECK_TESTMRI_ENTRY "${L_REGDATA}" \
      "HKCU" "UserDir_LFN" "HKCU: UserDir_LFN "
  !insertmacro CHECK_TESTMRI_ENTRY "${L_REGDATA}" \
      "HKCU" "UserDir_SFN" "HKCU: UserDir_SFN "
  DetailPrint ""

  DetailPrint "[3] Current PFI Testbed Data:"
  DetailPrint ""

  !insertmacro CHECK_TESTBED_ENTRY "${L_REGDATA}" \
      "HKCU" "InstallPath"  "MRI PFI Testbed   "
  !insertmacro CHECK_TESTBED_ENTRY "${L_REGDATA}" \
      "HKCU" "UserDataPath" "MRI PFI Testdata  "
  DetailPrint ""

  Pop ${L_REGDATA}

  !undef L_REGDATA

SectionEnd


;--------------------------------------------------------------------------
; Section: POPFile Registry Data
;--------------------------------------------------------------------------

Section "POPFile Registry Data"
  SectionIn ${C_INST_TYPE_FULL} RO

  !define L_REGDATA         $R9   ; data read from registry
  !define L_STATUS_ROOT     $R8   ; used to report whether or not 'popfile.pl' exists
  !define L_STATUS_USER     $R7   ; used to report whether or not 'popfile.cfg' exists
  !define L_TEMP            $R6

  Push ${L_REGDATA}
  Push ${L_STATUS_ROOT}
  Push ${L_STATUS_USER}
  Push ${L_TEMP}

  DetailPrint "------------------------------------------------------------"
  DetailPrint "POPFile Registry Data"
  DetailPrint "------------------------------------------------------------"
  DetailPrint ""

  ; Check NTFS Short File Name support

  ReadRegDWORD ${L_REGDATA} \
      HKLM "System\CurrentControlSet\Control\FileSystem" "NtfsDisable8dot3NameCreation"
  DetailPrint "NTFS SFN Disabled = < ${L_REGDATA} >"
  DetailPrint ""

  ; Check HKLM data

  ReadRegStr ${L_TEMP} HKLM "${C_PFI_PRODUCT_REGISTRY_ENTRY}" "POPFile Major Version"
  StrCpy ${L_REGDATA} ${L_TEMP}
  ReadRegStr ${L_TEMP} HKLM "${C_PFI_PRODUCT_REGISTRY_ENTRY}" "POPFile Minor Version"
  StrCpy ${L_REGDATA} ${L_REGDATA}.${L_TEMP}
  ReadRegStr ${L_TEMP} HKLM "${C_PFI_PRODUCT_REGISTRY_ENTRY}" "POPFile Revision"
  StrCpy ${L_REGDATA} ${L_REGDATA}.${L_TEMP}
  ReadRegStr ${L_TEMP} HKLM "${C_PFI_PRODUCT_REGISTRY_ENTRY}" "POPFile RevStatus"
  StrCpy ${L_REGDATA} ${L_REGDATA}${L_TEMP}
  DetailPrint "HKLM: MRI Version = < ${L_REGDATA} >"

  DetailPrint ""
  !insertmacro CHECK_MRI_ENTRY "${L_REGDATA}" "HKLM" "NihongoParser" \
      "HKLM: NewParser   "
  DetailPrint ""

  !insertmacro CHECK_MRI_ENTRY "${L_REGDATA}" "HKLM" "InstallPath" \
      "HKLM: InstallPath "
  !insertmacro CHECK_MRI_ENTRY "${L_REGDATA}" "HKLM" "RootDir_LFN" \
      "HKLM: RootDir_LFN "
  Push ${L_REGDATA}
  Call CheckForTrailingSlash
  StrCpy $G_EXPECTED_ROOT ${L_REGDATA}
  StrCpy $INSTDIR ${L_REGDATA}          ; search path for EXE files (no trailing slash)
  ClearErrors
  ReadRegStr ${L_REGDATA} HKLM "${C_PFI_PRODUCT_REGISTRY_ENTRY}" "RootDir_SFN"
  IfErrors 0 check_HKLM_root_data
  DetailPrint "HKLM: RootDir_SFN = ><"
  Goto end_HKLM_root

check_HKLM_root_data:
  StrCmp ${L_REGDATA} "Not supported" 0 short_HKLM_root
  Push $G_EXPECTED_ROOT
  Call CheckForSpaces
  DetailPrint "HKLM: RootDir_SFN = < ${L_REGDATA} >"
  Goto end_HKLM_root

short_HKLM_root:
  DetailPrint "HKLM: RootDir_SFN = < ${L_REGDATA} >"
  Push ${L_REGDATA}
  Call CheckForTrailingSlash
  GetFullPathName /SHORT $G_EXPECTED_ROOT $G_EXPECTED_ROOT
  StrCmp $G_EXPECTED_ROOT "" 0 compare_HKLM_root_lfn_sfn
  DetailPrint "^^^^^ Error ^^^^^"
  DetailPrint "***** Unable to verify SFN because the LFN path does not exist"
  Goto end_HKLM_root

compare_HKLM_root_lfn_sfn:
  StrCpy ${L_TEMP} $G_EXPECTED_ROOT 1 -1
  StrCmp ${L_TEMP} "\" end_HKLM_root
  StrCmp $G_EXPECTED_ROOT ${L_REGDATA} end_HKLM_root
  DetailPrint "^^^^^ Error ^^^^^"
  DetailPrint "Expected Root SFN = < $G_EXPECTED_ROOT >"

end_HKLM_root:
  DetailPrint ""
  Push "HKLM"
  Call CheckExeFilesExist

  ; Check HKCU data

  !insertmacro CHECK_MRI_ENTRY "${L_REGDATA}" "HKCU" "Owner" "HKCU: Data Owner  "
  ReadRegStr ${L_TEMP} HKCU "${C_PFI_PRODUCT_REGISTRY_ENTRY}" "POPFile Major Version"
  StrCpy ${L_REGDATA} ${L_TEMP}
  ReadRegStr ${L_TEMP} HKCU "${C_PFI_PRODUCT_REGISTRY_ENTRY}" "POPFile Minor Version"
  StrCpy ${L_REGDATA} ${L_REGDATA}.${L_TEMP}
  ReadRegStr ${L_TEMP} HKCU "${C_PFI_PRODUCT_REGISTRY_ENTRY}" "POPFile Revision"
  StrCpy ${L_REGDATA} ${L_REGDATA}.${L_TEMP}
  ReadRegStr ${L_TEMP} HKCU "${C_PFI_PRODUCT_REGISTRY_ENTRY}" "POPFile RevStatus"
  StrCpy ${L_REGDATA} ${L_REGDATA}${L_TEMP}
  DetailPrint "HKCU: MRI Version = < ${L_REGDATA} >"

  !insertmacro CHECK_MRI_ENTRY "${L_REGDATA}" "HKCU" "RootDir_LFN" "HKCU: RootDir_LFN "
  Push ${L_REGDATA}
  Call CheckForTrailingSlash
  StrCpy $G_EXPECTED_ROOT ${L_REGDATA}
  StrCpy $INSTDIR ${L_REGDATA}          ; search path for EXE files (no trailing slash)
  StrCpy ${L_STATUS_ROOT} ""
  IfFileExists "${L_REGDATA}\popfile.pl" root_sfn
  StrCpy ${L_STATUS_ROOT} "not "

root_sfn:
  ClearErrors
  ReadRegStr ${L_REGDATA} HKCU "${C_PFI_PRODUCT_REGISTRY_ENTRY}" "RootDir_SFN"
  IfErrors 0 check_HKCU_root_data
  DetailPrint "HKCU: RootDir_SFN = ><"
  Goto end_HKCU_root

check_HKCU_root_data:
  StrCmp ${L_REGDATA} "Not supported"  0 short_HKCU_root
  Push $G_EXPECTED_ROOT
  Call CheckForSpaces
  DetailPrint "HKCU: RootDir_SFN = < ${L_REGDATA} >"
  Goto end_HKCU_root

short_HKCU_root:
  DetailPrint "HKCU: RootDir_SFN = < ${L_REGDATA} >"
  Push ${L_REGDATA}
  Call CheckForTrailingSlash
  GetFullPathName /SHORT $G_EXPECTED_ROOT $G_EXPECTED_ROOT
  StrCmp $G_EXPECTED_ROOT "" 0 compare_HKCU_root_lfn_sfn
  DetailPrint "^^^^^ Error ^^^^^"
  DetailPrint "***** Unable to verify SFN because the LFN path does not exist"
  Goto end_HKCU_root

compare_HKCU_root_lfn_sfn:
  StrCpy ${L_TEMP} $G_EXPECTED_ROOT 1 -1
  StrCmp ${L_TEMP} "\" end_HKCU_root
  StrCmp $G_EXPECTED_ROOT ${L_REGDATA} end_HKCU_root
  DetailPrint "^^^^^ Error ^^^^^"
  DetailPrint "Expected Root SFN = < $G_EXPECTED_ROOT >"

end_HKCU_root:
  DetailPrint ""

  !insertmacro CHECK_MRI_ENTRY "${L_REGDATA}" "HKCU" "UserDir_LFN" "HKCU: UserDir_LFN "
  Push ${L_REGDATA}
  Call CheckForTrailingSlash
  StrCpy $G_POPFILE_USER_REG ${L_REGDATA}
  StrCpy $G_EXPECTED_USER ${L_REGDATA}
  StrCpy ${L_STATUS_USER} ""
  IfFileExists "${L_REGDATA}\popfile.cfg" user_sfn
  StrCpy ${L_STATUS_USER} "not "

user_sfn:
  ClearErrors
  ReadRegStr ${L_REGDATA} HKCU "${C_PFI_PRODUCT_REGISTRY_ENTRY}" "UserDir_SFN"
  IfErrors 0 check_HKCU_user_data
  DetailPrint "HKCU: UserDir_SFN = ><"
  Goto end_HKCU_user

check_HKCU_user_data:
  StrCmp ${L_REGDATA} "Not supported" 0 short_HKCU_user
  Push $G_EXPECTED_USER
  Call CheckForSpaces
  DetailPrint "HKCU: UserDir_SFN = < ${L_REGDATA} >"
  Goto end_HKCU_user

short_HKCU_user:
  DetailPrint "HKCU: UserDir_SFN = < ${L_REGDATA} >"
  Push ${L_REGDATA}
  Call CheckForTrailingSlash
  GetFullPathName /SHORT $G_EXPECTED_USER $G_EXPECTED_USER
  StrCmp $G_EXPECTED_USER "" 0 compare_user_lfn_sfn
  DetailPrint "^^^^^ Error ^^^^^"
  DetailPrint "***** Unable to verify SFN because the LFN path does not exist"
  Goto end_HKCU_user

compare_user_lfn_sfn:
  StrCpy ${L_TEMP} $G_EXPECTED_USER 1 -1
  StrCmp ${L_TEMP} "\" end_HKCU_user
  StrCmp $G_EXPECTED_USER ${L_REGDATA} end_HKCU_user
  DetailPrint "^^^^^ Error ^^^^^"
  DetailPrint "Expected User SFN = < $G_EXPECTED_USER >"

end_HKCU_user:
  DetailPrint ""
  DetailPrint "HKCU: popfile.pl  = ${L_STATUS_ROOT}found"
  DetailPrint "HKCU: popfile.cfg = ${L_STATUS_USER}found"
  DetailPrint ""
  Push "HKCU"
  Call CheckExeFilesExist

  Pop ${L_TEMP}
  Pop ${L_STATUS_USER}
  Pop ${L_STATUS_ROOT}
  Pop ${L_REGDATA}

  !undef L_REGDATA
  !undef L_STATUS_ROOT
  !undef L_STATUS_USER
  !undef L_TEMP

SectionEnd


;--------------------------------------------------------------------------
; Section: POPFile Corpus/Database Backup Data
;--------------------------------------------------------------------------

Section "Corpus/Database Backup Data"
  SectionIn ${C_INST_TYPE_FULL} RO

  !define L_STATUS_USER     $R9   ; used to report whether or not 'popfile.cfg' exists
  !define L_TEMP            $R8

  Push ${L_STATUS_USER}
  Push ${L_TEMP}

  IfFileExists  "$G_POPFILE_USER_REG\backup\*.*" 0 section_end

  DetailPrint "------------------------------------------------------------"
  DetailPrint "POPFile Corpus/Database Backup Data"
  DetailPrint "------------------------------------------------------------"
  DetailPrint ""

  DetailPrint "HKCU: backup locn = < $G_POPFILE_USER_REG\backup >"
  DetailPrint ""

  StrCpy ${L_STATUS_USER} ""
  IfFileExists "$G_POPFILE_USER_REG\backup\backup.ini" ini_status
  StrCpy ${L_STATUS_USER} "not "

ini_status:
  DetailPrint "backup.ini file   = ${L_STATUS_USER}found"

  ReadINIStr ${L_TEMP} "$G_POPFILE_USER_REG\backup\backup.ini" "FlatFileCorpus" "Corpus"
  StrCmp ${L_TEMP} "" no_flat_folder
  StrCpy ${L_STATUS_USER} ""
  IfFileExists "$G_POPFILE_USER_REG\backup\${L_TEMP}\*.*" flat_status

no_flat_folder:
  StrCpy ${L_STATUS_USER} "not "

flat_status:
  DetailPrint "Flat-file  folder = ${L_STATUS_USER}found"

  ReadINIStr ${L_TEMP} "$G_POPFILE_USER_REG\backup\backup.ini" "NonSQLCorpus" "Corpus"
  StrCmp ${L_TEMP} "" no_nonsql_folder
  StrCpy ${L_STATUS_USER} ""
  IfFileExists "$G_POPFILE_USER_REG\backup\nonsql\${L_TEMP}\*.*" nonsql_status

no_nonsql_folder:
  StrCpy ${L_STATUS_USER} "not "

nonsql_status:
  DetailPrint "Flat / BDB folder = ${L_STATUS_USER}found"

  ReadINIStr ${L_TEMP} "$G_POPFILE_USER_REG\backup\backup.ini" "OldSQLdatabase" "Database"
  StrCmp ${L_TEMP} "" no_sql_backup
  StrCpy ${L_STATUS_USER} ""
  IfFileExists "$G_POPFILE_USER_REG\backup\oldsql\${L_TEMP}" sql_backup_status

no_sql_backup:
  StrCpy ${L_STATUS_USER} "not "

sql_backup_status:
  DetailPrint "SQLite DB  backup = ${L_STATUS_USER}found"
  DetailPrint ""

section_end:
  Pop ${L_TEMP}
  Pop ${L_STATUS_USER}

  !undef L_STATUS_USER
  !undef L_TEMP

SectionEnd


;--------------------------------------------------------------------------
; Section: User-Friendly Program and User Data locations
;--------------------------------------------------------------------------

Section "User-Friendly Program/User Data Locations"
  SectionIn ${C_INST_TYPE_SIMPLE} RO

  !define L_REGDATA         $R9   ; data read from registry
  !define L_STATUS_ROOT     $R8   ; used to report whether or not 'popfile.pl' exists
  !define L_STATUS_USER     $R7   ; used to report whether or not 'popfile.cfg' exists
  !define L_TEMP            $R6

  Push ${L_REGDATA}
  Push ${L_STATUS_ROOT}
  Push ${L_STATUS_USER}
  Push ${L_TEMP}

  !insertmacro CHECK_MRI_ENTRY "${L_REGDATA}" "HKCU" "RootDir_LFN" "Program folder    "
  Push ${L_REGDATA}
  Call CheckForTrailingSlash
  StrCpy $G_EXPECTED_ROOT ${L_REGDATA}
  StrCpy $INSTDIR ${L_REGDATA}
  StrCpy ${L_STATUS_ROOT} ""
  IfFileExists "${L_REGDATA}\popfile.pl" simple_root_sfn
  StrCpy ${L_STATUS_ROOT} "not "

simple_root_sfn:
  ClearErrors
  ReadRegStr ${L_REGDATA} HKCU "${C_PFI_PRODUCT_REGISTRY_ENTRY}" "RootDir_SFN"
  IfErrors 0 check_simple_root_data
  DetailPrint "SFN equivalent    = ><"
  Goto end_simple_root

check_simple_root_data:
  StrCmp ${L_REGDATA} "Not supported" 0 short_simple_root
  Push $G_EXPECTED_ROOT
  Call CheckForSpaces
  DetailPrint "SFN equivalent    = < ${L_REGDATA} >"
  Goto end_simple_root

short_simple_root:
  DetailPrint "SFN equivalent    = < ${L_REGDATA} >"
  Push ${L_REGDATA}
  Call CheckForTrailingSlash
  GetFullPathName /SHORT $G_EXPECTED_ROOT $G_EXPECTED_ROOT
  StrCmp $G_EXPECTED_ROOT "" 0 compare_root_lfn_sfn
  DetailPrint "^^^^^ Error ^^^^^"
  DetailPrint "***** Unable to verify SFN because the LFN path does not exist"
  Goto end_simple_root

compare_root_lfn_sfn:
  StrCpy ${L_TEMP} $G_EXPECTED_ROOT 1 -1
  StrCmp ${L_TEMP} "\" end_simple_root
  StrCmp $G_EXPECTED_ROOT ${L_REGDATA} end_simple_root
  DetailPrint "^^^^^ Error ^^^^^"
  DetailPrint "Expected value    = < $G_EXPECTED_ROOT >"

end_simple_root:
  DetailPrint ""

  !insertmacro CHECK_MRI_ENTRY "${L_REGDATA}" "HKCU" "UserDir_LFN" "User Data folder  "
  Push ${L_REGDATA}
  Call CheckForTrailingSlash
  StrCpy $G_EXPECTED_USER ${L_REGDATA}
  StrCpy ${L_STATUS_USER} ""
  IfFileExists "${L_REGDATA}\popfile.cfg" simple_user_sfn
  StrCpy ${L_STATUS_USER} "not "

simple_user_sfn:
  ClearErrors
  ReadRegStr ${L_REGDATA} HKCU "${C_PFI_PRODUCT_REGISTRY_ENTRY}" "UserDir_SFN"
  IfErrors 0 check_simple_user_data
  DetailPrint "SFN equivalent    = ><"
  Goto end_simple_user

check_simple_user_data:
  StrCmp ${L_REGDATA} "Not supported" 0 short_simple_user
  Push $G_EXPECTED_USER
  Call CheckForSpaces
  DetailPrint "SFN equivalent    = < ${L_REGDATA} >"
  Goto end_simple_user

short_simple_user:
  DetailPrint "SFN equivalent    = < ${L_REGDATA} >"
  Push ${L_REGDATA}
  Call CheckForTrailingSlash
  GetFullPathName /SHORT $G_EXPECTED_USER $G_EXPECTED_USER
  StrCmp $G_EXPECTED_USER "" 0 compare_user_lfn_sfn
  DetailPrint "^^^^^ Error ^^^^^"
  DetailPrint "***** Unable to verify SFN because the LFN path does not exist"
  Goto end_simple_user

compare_user_lfn_sfn:
  StrCpy ${L_TEMP} $G_EXPECTED_USER 1 -1
  StrCmp ${L_TEMP} "\" end_simple_user
  StrCmp $G_EXPECTED_USER ${L_REGDATA} end_simple_user
  DetailPrint "^^^^^ Error ^^^^^"
  DetailPrint "Expected value    = < $G_EXPECTED_USER >"

end_simple_user:
  DetailPrint ""
  DetailPrint "popfile.pl  file  = ${L_STATUS_ROOT}found"
  DetailPrint "popfile.cfg file  = ${L_STATUS_USER}found"

  StrCmp ${L_STATUS_ROOT} "" 0 exit_section
  Push "HKCU"
  Call CheckExeFilesExist

exit_section:
  Pop ${L_TEMP}
  Pop ${L_STATUS_USER}
  Pop ${L_STATUS_ROOT}
  Pop ${L_REGDATA}

  !undef L_REGDATA
  !undef L_STATUS_ROOT
  !undef L_STATUS_USER
  !undef L_TEMP

SectionEnd


;--------------------------------------------------------------------------
; Section: EnvironmentVariables
;--------------------------------------------------------------------------

Section "Environment Variables"
  SectionIn ${C_INST_TYPE_SIMPLE} ${C_INST_TYPE_FULL} RO

  !define L_ITAIJIDICTPATH  $R9   ; value of one of the Kakasi variables
  !define L_KANWADICTPATH   $R8   ; value of one of the Kakasi variables
  !define L_MECABRC         $R7   ; current MeCab environment variable
  !define L_POPFILE_ROOT    $R6   ; current value of POPFILE_ROOT environment variable
  !define L_TEMP            $R5

  Push ${L_ITAIJIDICTPATH}
  Push ${L_KANWADICTPATH}
  Push ${L_MECABRC}
  Push ${L_POPFILE_ROOT}
  Push ${L_TEMP}

  DetailPrint "------------------------------------------------------------"
  DetailPrint "POPFile Environment Variables"
  DetailPrint "------------------------------------------------------------"
  DetailPrint ""

  !insertmacro CHECK_ENVIRONMENT "${L_POPFILE_ROOT}" "POPFILE_ROOT" "'POPFILE_ROOT'    "
  StrCmp $G_WIN_OS_TYPE "1" compare_root_var
  StrCmp ${L_POPFILE_ROOT} "" check_user

compare_root_var:
  Push ${L_POPFILE_ROOT}
  Call CheckForTrailingSlash
  Push ${L_POPFILE_ROOT}
  Call CheckForSpaces
  StrCmp $G_EXPECTED_ROOT ${L_POPFILE_ROOT} check_user
  Push $G_EXPECTED_ROOT
  Push " "
  Call PFI_StrStr
  Pop ${L_TEMP}
  StrCmp ${L_TEMP} "" 0 check_user
  DetailPrint "^^^^^ Error ^^^^^"
  DetailPrint "Expected value    = < $G_EXPECTED_ROOT >"
  DetailPrint ""

check_user:
  !insertmacro CHECK_ENVIRONMENT "$G_POPFILE_USER_ENV" "POPFILE_USER" "'POPFILE_USER'    "
  StrCmp $G_WIN_OS_TYPE "1" compare_user_var
  StrCmp $G_POPFILE_USER_ENV "" check_vars

compare_user_var:
  Push $G_POPFILE_USER_ENV
  Call CheckForTrailingSlash
  Push $G_POPFILE_USER_ENV
  Call CheckForSpaces
  StrCmp $G_EXPECTED_USER $G_POPFILE_USER_ENV check_vars
  Push $G_EXPECTED_USER
  Push " "
  Call PFI_StrStr
  Pop ${L_TEMP}
  StrCmp ${L_TEMP} "" 0 check_vars
  DetailPrint "^^^^^ Error ^^^^^"
  DetailPrint "Expected value    = < $G_EXPECTED_USER >"

check_vars:
  DetailPrint ""

  StrCmp ${L_POPFILE_ROOT} "" check_user_var

  StrCpy ${L_TEMP} ""
  IfFileExists "${L_POPFILE_ROOT}\popfile.pl" root_var_status
  StrCpy ${L_TEMP} "not "

root_var_status:
  StrCmp $G_REPORT_MODE "${C_INST_TYPE_INDEX_SIMPLE}" simple_root_status

  DetailPrint "Env: popfile.pl   = ${L_TEMP}found"
  Goto check_user_var

simple_root_status:
  DetailPrint "popfile.pl  file  = ${L_TEMP}found"

check_user_var:
  StrCmp $G_POPFILE_USER_ENV "" 0 user_result
  StrCmp ${L_POPFILE_ROOT} "" check_kakasi file_check

user_result:
  StrCpy ${L_TEMP} ""
  IfFileExists "$G_POPFILE_USER_ENV\popfile.cfg" user_var_status
  StrCpy ${L_TEMP} "not "

user_var_status:
  StrCmp $G_REPORT_MODE "${C_INST_TYPE_INDEX_SIMPLE}" simple_user_status

  DetailPrint "Env: popfile.cfg  = ${L_TEMP}found"
  DetailPrint ""
  Goto file_check

simple_user_status:
  DetailPrint "popfile.cfg file  = ${L_TEMP}found"

file_check:
  StrCpy $INSTDIR ${L_POPFILE_ROOT}
  Push "ROOT"
  Call CheckExeFilesExist

check_kakasi:
  !insertmacro CHECK_KAKASI "${L_ITAIJIDICTPATH}" "ITAIJIDICTPATH" "'ITAIJIDICTPATH'  "
  !insertmacro CHECK_KAKASI "${L_KANWADICTPATH}"  "KANWADICTPATH"  "'KANWADICTPATH'   "
  DetailPrint ""

  StrCmp $G_REPORT_MODE "${C_INST_TYPE_INDEX_SIMPLE}" check_mecab

  StrCmp ${L_ITAIJIDICTPATH} "" check_other_kakaksi
  StrCpy ${L_TEMP} ""
  IfFileExists "${L_ITAIJIDICTPATH}" display_itaiji_result
  StrCpy ${L_TEMP} "not "

display_itaiji_result:
  DetailPrint "'itaijidict' file = ${L_TEMP}found"

check_other_kakaksi:
  StrCmp ${L_KANWADICTPATH} "" 0 check_kanwa
  StrCmp ${L_ITAIJIDICTPATH} "" check_mecab kakasi_blank_line

check_kanwa:
  StrCpy ${L_TEMP} ""
  IfFileExists "${L_KANWADICTPATH}" display_kanwa_result
  StrCpy ${L_TEMP} "not "

display_kanwa_result:
  DetailPrint "'kanwadict'  file = ${L_TEMP}found"

kakasi_blank_line:
  DetailPrint ""

check_mecab:
  !insertmacro CHECK_MECAB "${L_MECABRC}" "MECABRC" "'MECABRC'         "
  DetailPrint ""

  StrCmp $G_REPORT_MODE "${C_INST_TYPE_INDEX_SIMPLE}" section_end

  StrCmp ${L_MECABRC} "" section_end
  StrCpy ${L_TEMP} ""
  IfFileExists "${L_MECABRC}" display_mecab_result
  StrCpy ${L_TEMP} "not "

display_mecab_result:
  DetailPrint "'mecabrc'    file = ${L_TEMP}found"
  DetailPrint ""

section_end:
  Pop ${L_TEMP}
  Pop ${L_POPFILE_ROOT}
  Pop ${L_MECABRC}
  Pop ${L_KANWADICTPATH}
  Pop ${L_ITAIJIDICTPATH}

  !undef L_ITAIJIDICTPATH
  !undef L_KANWADICTPATH
  !undef L_MECABRC
  !undef L_POPFILE_ROOT
  !undef L_TEMP

SectionEnd


;--------------------------------------------------------------------------
; Section: Some important POPFile Configuration Settings
;          (to avoid the need to ask users to report them)
;--------------------------------------------------------------------------

Section "POPFile Configuration Settings"
  SectionIn ${C_INST_TYPE_SIMPLE} ${C_INST_TYPE_FULL} RO

  StrCmp $G_POPFILE_USER_ENV "?" try_registry_source
  StrCpy $G_POPFILE_USER $G_POPFILE_USER_ENV
  StrCmp $G_POPFILE_USER_ENV $G_POPFILE_USER_REG 0 paths_differ
  Push "'POPFILE_USER' and HKCU"
  Call POPFileConfigurationSettings
  Goto exit

paths_differ:
  Push "'POPFILE_USER'"
  Call POPFileConfigurationSettings

try_registry_source:
  StrCmp $G_POPFILE_USER_REG "?" exit
  StrCpy $G_POPFILE_USER $G_POPFILE_USER_REG
  Push "HKCU data"
  Call POPFileConfigurationSettings

exit:

SectionEnd

;--------------------------------------------------------------------------
; Installer Function: POPFileConfigurationSettings
;
; Inputs:
;         $G_POPFILE_USER  - global variable holding path to 'User Data' folder
;         (top of stack)   - string indicating source of the 'User Data' path
;--------------------------------------------------------------------------

Function POPFileConfigurationSettings

  !define L_CFG_SETTING         $R9

  Exch ${L_CFG_SETTING}

  DetailPrint "------------------------------------------------------------"
  DetailPrint "POPFile Configuration (subset) from ${L_CFG_SETTING}"
  DetailPrint "------------------------------------------------------------"
  DetailPrint ""

  !insertmacro READ_CONFIG ${L_CFG_SETTING} "html_port"
  IfErrors 0 report_html_port
  !insertmacro READ_CONFIG ${L_CFG_SETTING} "ui_port"
  IfErrors 0 report_html_port
  DetailPrint "POPFile UI port   = ><"
  Goto check_pop3_listen_port

report_html_port:
  DetailPrint "POPFile UI port   = < ${L_CFG_SETTING} >"

check_pop3_listen_port:
  !insertmacro READ_CONFIG ${L_CFG_SETTING} "pop3_port"
  IfErrors 0 report_pop3_listen_port
  !insertmacro READ_CONFIG ${L_CFG_SETTING} "port"
  IfErrors 0 report_pop3_listen_port
  DetailPrint "POP3 Listen port  = ><"
  Goto check_concurrent_pop3

report_pop3_listen_port:
  DetailPrint "POP3 Listen port  = < ${L_CFG_SETTING} >"

check_concurrent_pop3:
  !insertmacro READ_CONFIG ${L_CFG_SETTING} "pop3_force_fork"
  IfErrors 0 report_concurrent_pop3
  DetailPrint "Concurrent POP3   = ><"
  Goto check_report_mode

report_concurrent_pop3:
  DetailPrint "Concurrent POP3   = < ${L_CFG_SETTING} >"

check_report_mode:
  DetailPrint ""
  StrCmp $G_REPORT_MODE "${C_INST_TYPE_INDEX_SIMPLE}" settings_done
  Call CheckLoggerSettings

settings_done:
  Pop ${L_CFG_SETTING}

  !undef L_CFG_SETTING

FunctionEnd

;--------------------------------------------------------------------------
; Installer Function: CheckLoggerSettings
;
; Inputs:
;         $G_POPFILE_USER  - global variable holding path to 'User Data' folder
;--------------------------------------------------------------------------

Function CheckLoggerSettings

  !define L_CFG_SETTING       $R9
  !define L_TEMP              $R8

  Push ${L_CFG_SETTING}
  Push ${L_TEMP}

  !insertmacro READ_CONFIG ${L_CFG_SETTING} "GLOBAL_debug"
  IfErrors 0 check_log_mode
  !insertmacro READ_CONFIG ${L_CFG_SETTING} "debug"
  IfErrors 0 check_log_mode
  DetailPrint "Logger output     = ><"
  Goto get_log_format

check_log_mode:
  StrCpy ${L_TEMP} "To File"
  StrCmp ${L_CFG_SETTING} "1" show_log_mode
  StrCpy ${L_TEMP} "None"
  StrCmp ${L_CFG_SETTING} "0" show_log_mode
  StrCpy ${L_TEMP} "To Screen (console)"
  StrCmp ${L_CFG_SETTING} "2" show_log_mode
  StrCpy ${L_TEMP} "To Screen and File"
  StrCmp ${L_CFG_SETTING} "3" show_log_mode
  StrCpy ${L_TEMP} "** invalid **"

show_log_mode:
  DetailPrint "Logger output     = < ${L_CFG_SETTING} > (${L_TEMP})"

get_log_format:
  !insertmacro READ_CONFIG ${L_CFG_SETTING} "logger_format"
  IfErrors 0 show_log_format
  DetailPrint "Logger format     = ><"
  Goto get_log_level

show_log_format:
  DetailPrint "Logger format     = < ${L_CFG_SETTING} >"

get_log_level:
  !insertmacro READ_CONFIG ${L_CFG_SETTING} "logger_level"
  IfErrors 0 show_log_level
  DetailPrint "Logger level      = ><"
  Goto get_log_dir

show_log_level:
  DetailPrint "Logger level      = < ${L_CFG_SETTING} >"

get_log_dir:
  !insertmacro READ_CONFIG ${L_CFG_SETTING} "logger_logdir"
  IfErrors 0 check_log_dir
  !insertmacro READ_CONFIG ${L_CFG_SETTING} "logdir"
  IfErrors 0 check_log_dir
  DetailPrint "Logger directory  = ><"
  Goto logger_end

check_log_dir:
  Push $G_POPFILE_USER
  Push "${L_CFG_SETTING}"
  Call PFI_GetDataPath
  Pop ${L_TEMP}
  DetailPrint "Logger directory  = < ${L_CFG_SETTING} > (${L_TEMP})"
  IfFileExists "${L_TEMP}\*.*" logger_end
  DetailPrint "^^^^^ Error ^^^^^"
  DetailPrint "***** '${L_TEMP}' directory does not exist"

logger_end:
  DetailPrint ""

  Pop ${L_TEMP}
  Pop ${L_CFG_SETTING}

  !undef L_CFG_SETTING
  !undef L_TEMP

FunctionEnd


;--------------------------------------------------------------------------
; Section: Insert TimeStamp (and scroll, if 'simple' mode)
;--------------------------------------------------------------------------

Section "Insert TimeStamp"
  SectionIn ${C_INST_TYPE_SIMPLE} ${C_INST_TYPE_FULL} RO

  !define L_TEMP    $R9

  Push ${L_TEMP}

  Call PFI_GetDateTimeStamp
  Pop ${L_TEMP}
  DetailPrint "------------------------------------------------------------"
  DetailPrint "(report created ${L_TEMP})"
  DetailPrint "------------------------------------------------------------"

  StrCmp $G_REPORT_MODE "${C_INST_TYPE_INDEX_SIMPLE}" 0 section_end

  ; For 'simple' reports, scroll to the LFN and SFN versions
  ; of the installation locations

  Call ScrollToShowPaths

section_end:
  Pop ${L_TEMP}

  !undef L_TEMP

SectionEnd


;--------------------------------------------------------------------------
; Section: Create 'User Data' folder shortcut
;--------------------------------------------------------------------------

Section "Create 'User Data' Shortcut"
  SectionIn ${C_INST_TYPE_SHORTCUT} RO

  SetDetailsPrint listonly

  !define L_REGDATA         $R9   ; data read from registry

  Push ${L_REGDATA}

  ReadRegStr ${L_REGDATA} HKCU "${C_PFI_PRODUCT_REGISTRY_ENTRY}" "UserDir_LFN"
  StrCmp ${L_REGDATA} "" no_reg_data
  IfFileExists "${L_REGDATA}\*.*" folder_found

no_reg_data:
  DetailPrint "ERROR:"
  DetailPrint ""
  DetailPrint "Unable to create the POPFile 'User Data' shortcut for \
              '$G_WINUSERNAME' user"
  DetailPrint ""
  DetailPrint "(registry entry missing or invalid - run 'adduser.exe' to repair)"
  DetailPrint ""
  Goto section_end

folder_found:
  SetDetailsPrint none
  SetOutPath "$SMPROGRAMS\${C_PFI_PRODUCT}\Support"
  SetFileAttributes "$SMPROGRAMS\${C_PFI_PRODUCT}\Support\User Data \
      ($G_WINUSERNAME).lnk" NORMAL
  CreateShortCut "$SMPROGRAMS\${C_PFI_PRODUCT}\Support\User Data \
      ($G_WINUSERNAME).lnk" "${L_REGDATA}"
  SetDetailsPrint listonly
  DetailPrint "For easy access to the POPFile 'User Data' for '$G_WINUSERNAME' \
              use the shortcut:"
  DetailPrint ""
  DetailPrint "Start --> Programs --> POPFile --> Support --> \
              User Data ($G_WINUSERNAME)"
  DetailPrint ""

section_end:
  Pop ${L_REGDATA}

  !undef L_REGDATA

SectionEnd


;--------------------------------------------------------------------------
; Section: Help Screen
;--------------------------------------------------------------------------

Section "Help Screen"
  SectionIn ${C_INST_TYPE_HELP} RO

  SetDetailsPrint listonly

  DetailPrint "POPFile $(^Name) v${C_VERSION}"
  DetailPrint ""
  DetailPrint "pfidiag            --- displays location of POPFile program and \
                                      the 'User Data' files"
  DetailPrint ""
  DetailPrint "pfidiag /simple    --- displays location of POPFile program and \
                                      the 'User Data' files"
  DetailPrint ""
  DetailPrint "pfidiag /full      --- displays a more detailed report than /simple"
  DetailPrint ""
  DetailPrint "pfidiag /shortcut  --- creates a Start Menu shortcut to the \
                                      'User Data' folder"
  DetailPrint ""
  DetailPrint "pfidiag /menu      --- displays a drop-down list of the available \
                                      options"
  DetailPrint ""
  DetailPrint "pfidiag /help      --- displays this help screen"

SectionEnd


;--------------------------------------------------------------------------
; Section: The End (always executed)
;--------------------------------------------------------------------------

Section "The End"
  SectionIn ${C_INST_TYPE_SIMPLE} ${C_INST_TYPE_FULL} \
            ${C_INST_TYPE_HELP} ${C_INST_TYPE_SHORTCUT} RO

  SetDetailsPrint textonly
  DetailPrint "$(PFI_LANG_DIAG_RIGHTCLICK)"
  SetDetailsPrint none

SectionEnd


;--------------------------------------------------------------------------
; Installer Function: CheckIfMenuPageRequired
; (this is the 'pre' function for the standard MUI COMPONENTS page)
;
; The OS type (0 = Win9x, 1 = non-Win9x) is checked more than once in this utility
; so we detect it here and store the result in a global variable for later use.
;
; Get the optional diagnostic mode from command-line and select the appropriate
; mode (i.e. the installation type) for the utility. The command-line options all
; start with a '/' character. If no option is supplied assume '/simple' instead.
; If an invalid option was supplied then display the help page.
;--------------------------------------------------------------------------

Function CheckIfMenuPageRequired

  !define L_DIAG_MODE   $R9
  !define L_TEMP        $R8

  Push ${L_DIAG_MODE}
  Push ${L_TEMP}

  ; Initialise both 'User Data' variables to illegal values
  ; to make it easy to detect cases where the environment
  ; variable and/or registry data is missing or undefined

  StrCpy $G_POPFILE_USER_ENV "?"
  StrCpy $G_POPFILE_USER_REG "?"

  Call NSIS_IsNT
  Pop $G_WIN_OS_TYPE

  Call NSIS_GetParameters
  Pop ${L_DIAG_MODE}

  StrCmp ${L_DIAG_MODE} "" set_simple_mode      ; default is equivalent to '/simple'
  StrCpy ${L_TEMP} ${L_DIAG_MODE} 1
  StrCmp ${L_TEMP} "/" 0 set_help_mode

  StrCpy ${L_DIAG_MODE} ${L_DIAG_MODE} "" 1
  StrCmp ${L_DIAG_MODE} "simple" set_simple_mode
  StrCmp ${L_DIAG_MODE} "full" set_full_mode
  StrCmp ${L_DIAG_MODE} "help" set_help_mode
  StrCmp ${L_DIAG_MODE} "shortcut" set_shortcut_mode
  StrCmp ${L_DIAG_MODE} "menu" set_menu_mode
  Goto set_help_mode

set_simple_mode:
  SetCurInstType ${C_INST_TYPE_INDEX_SIMPLE}
  Goto skip_menu_page

set_full_mode:
  SetCurInstType ${C_INST_TYPE_INDEX_FULL}
  Goto skip_menu_page

set_help_mode:
  SetCurInstType ${C_INST_TYPE_INDEX_HELP}
  Goto skip_menu_page

set_shortcut_mode:
  SetCurInstType ${C_INST_TYPE_INDEX_SHORTCUT}

skip_menu_page:
  Pop ${L_TEMP}
  Pop ${L_DIAG_MODE}
  Abort

set_menu_mode:
  InstTypeSetText ${C_INST_TYPE_INDEX_SIMPLE} \
                  "$(PFI_LANG_DIAG_COMP_TEXT_INSTTYPE_SIMPLE)"
  InstTypeSetText ${C_INST_TYPE_INDEX_FULL} \
                  "$(PFI_LANG_DIAG_COMP_TEXT_INSTTYPE_FULL)"
  InstTypeSetText ${C_INST_TYPE_INDEX_HELP} \
                  "$(PFI_LANG_DIAG_COMP_TEXT_INSTTYPE_HELP)"
  InstTypeSetText ${C_INST_TYPE_INDEX_SHORTCUT} \
                  "$(PFI_LANG_DIAG_COMP_TEXT_INSTTYPE_SHORTCUT)"

  Pop ${L_TEMP}
  Pop ${L_DIAG_MODE}

  !undef L_DIAG_MODE
  !undef L_TEMP

FunctionEnd


#--------------------------------------------------------------------------
# Installer Function: AnalyseShortcuts
#
# The Windows installer (setup.exe) and the "Add POPFile User" wizard (adduser.exe)
# only check for specific StartUp shortcut names so if the user has renamed a POPFile
# StartUp shortcut created during a previous installation or has created their own
# shortcut then there may be more than one StartUp shortcut for POPFile. This function
# analyses all shortcuts in the specified folder and lists those that appear to start
# POPFile.
#
# POPFile shortcuts are expected to use command-lines which include
# one of the following:
#
#  (1) runpopfile.exe
#  (2) popfile.exe
#  (3) popfileb.exe
#  (4) popfilef.exe
#  (5) popfileib.exe
#  (6) popfileif.exe
#  (7) perl.exe popfile.pl
#  (8) wperl.exe popfile.pl
#
# Additional command-line options may be supplied
# (to override some configuration settings).
#
# For simplicity this version of the function merely looks for the string "POPFile"
# in the shortcut's "target" command-line using a case-insensitive search.
#
# Inputs:
#         (top of stack)   - path of the folder containing the shortcuts to be analysed
#
# Outputs:
#         (top of stack)   - number of shortcuts found which appear to start POPFile
#
# Usage:
#
#         Push "$SMSTARTUP"
#         Call AnalyseShortcuts
#         Pop $R0
#
#         ; if $R0 is 2 or more then something has gone wrong!
#
#--------------------------------------------------------------------------

Function AnalyseShortcuts

  !define L_LNK_FOLDER         $R9   ; folder where the shortcuts (if any) are stored
  !define L_LNK_HANDLE         $R8   ; file handle used in search for shortcut files
  !define L_LNK_NAME           $R7   ; name of a shortcut file
  !define L_LNK_TOTAL          $R6   ; counts the number of shortcuts we find
  !define L_POPFILE_TOTAL      $R5   ; number of shortcuts which appear to start POPFile
  !define L_SHORTCUT_ARGS      $R4
  !define L_SHORTCUT_START_IN  $R3
  !define L_SHORTCUT_TARGET    $R2
  !define L_TEMP               $R1

  Exch ${L_LNK_FOLDER}
  Push ${L_LNK_HANDLE}
  Push ${L_LNK_NAME}
  Push ${L_LNK_TOTAL}
  Push ${L_POPFILE_TOTAL}
  Push ${L_SHORTCUT_ARGS}
  Push ${L_SHORTCUT_START_IN}
  Push ${L_SHORTCUT_TARGET}
  Push ${L_TEMP}

  StrCpy ${L_LNK_TOTAL}     0
  StrCpy ${L_POPFILE_TOTAL} 0

  IfFileExists "${L_LNK_FOLDER}\*.*" 0 exit

  FindFirst ${L_LNK_HANDLE} ${L_LNK_NAME} "${L_LNK_FOLDER}\*.lnk"
  StrCmp ${L_LNK_HANDLE} "" all_done_now

examine_shortcut:
  StrCmp ${L_LNK_NAME} "." look_again
  StrCmp ${L_LNK_NAME} ".." look_again
  IfFileExists "${L_LNK_FOLDER}\${L_LNK_NAME}\*.*" look_again
  IntOp ${L_LNK_TOTAL} ${L_LNK_TOTAL} + 1
  ShellLink::GetShortCutTarget "${L_LNK_FOLDER}\${L_LNK_NAME}"
  Pop ${L_SHORTCUT_TARGET}
  ShellLink::GetShortCutArgs "${L_LNK_FOLDER}\${L_LNK_NAME}"
  Pop ${L_SHORTCUT_ARGS}

  Push ${L_SHORTCUT_TARGET}
  Push "popfile"
  Call PFI_StrStr
  Pop ${L_TEMP}
  StrCmp ${L_TEMP} "" 0 show_details
  Push ${L_SHORTCUT_ARGS}
  Push "popfile"
  Call PFI_StrStr
  Pop ${L_TEMP}
  StrCmp ${L_TEMP} "" look_again

show_details:
  IntOp ${L_POPFILE_TOTAL} ${L_POPFILE_TOTAL} + 1
  ShellLink::GetShortCutWorkingDirectory "${L_LNK_FOLDER}\${L_LNK_NAME}"
  Pop ${L_SHORTCUT_START_IN}
  DetailPrint ""
  DetailPrint "Shortcut name     = < ${L_LNK_NAME} >"
  DetailPrint "Shortcut start in = < ${L_SHORTCUT_START_IN} >"
  DetailPrint "Shortcut target   = < ${L_SHORTCUT_TARGET} >"
  StrCpy ${L_TEMP} "found"
  IfFileExists ${L_SHORTCUT_TARGET} show_args
  StrCpy ${L_TEMP} "not found"

show_args:
  StrCmp ${L_SHORTCUT_ARGS} "" no_args
  DetailPrint "Shortcut argument = < ${L_SHORTCUT_ARGS} >"
  Goto show_status

no_args:
  DetailPrint "Shortcut argument = ><"

show_status:
  DetailPrint "Target status     = ${L_TEMP}"

look_again:
  FindNext ${L_LNK_HANDLE} ${L_LNK_NAME}
  StrCmp ${L_LNK_NAME} "" all_done_now examine_shortcut

all_done_now:
  FindClose ${L_LNK_HANDLE}

exit:
  DetailPrint ""
  DetailPrint "*.lnk files found = ${L_LNK_TOTAL}"
  DetailPrint "POPFile shortcuts = ${L_POPFILE_TOTAL}"
  IntCmp ${L_POPFILE_TOTAL} 1 restore_regs restore_regs
  DetailPrint "^^^^ Warning ^^^^   More than one POPFile StartUp shortcut found \
              in this folder"

restore_regs:
  StrCpy ${L_LNK_FOLDER} ${L_POPFILE_TOTAL}

  Pop ${L_TEMP}
  Pop ${L_SHORTCUT_TARGET}
  Pop ${L_SHORTCUT_START_IN}
  Pop ${L_SHORTCUT_ARGS}
  Pop ${L_POPFILE_TOTAL}
  Pop ${L_LNK_TOTAL}
  Pop ${L_LNK_NAME}
  Pop ${L_LNK_HANDLE}
  Exch ${L_LNK_FOLDER}          ; return number of POPFile startup shortcuts found

  !undef L_LNK_FOLDER
  !undef L_LNK_HANDLE
  !undef L_LNK_NAME
  !undef L_LNK_TOTAL
  !undef L_POPFILE_TOTAL
  !undef L_SHORTCUT_ARGS
  !undef L_SHORTCUT_START_IN
  !undef L_SHORTCUT_TARGET
  !undef L_TEMP

FunctionEnd


#--------------------------------------------------------------------------
# Installer Function: CheckForSpaces
#
# This function logs an error message if there are any spaces in the input string
#
# Inputs:
#         (top of stack)   - input string
#
# Outputs:
#         (none)
#
# Usage:
#
#         Push "an example"
#         Call CheckForSpaces
#
#         (an error message will be added to the log)
#
#--------------------------------------------------------------------------

Function CheckForSpaces

  !define L_TEMP  $R9

  Exch ${L_TEMP}
  Push ${L_TEMP}
  Push " "
  Call PFI_StrStr
  Pop ${L_TEMP}
  StrCmp ${L_TEMP} "" exit
  DetailPrint "^^^^^ Error ^^^^^   The above value should not contain spaces"

exit:
  Pop ${L_TEMP}

  !undef L_TEMP

FunctionEnd


#--------------------------------------------------------------------------
# Installer Function: CheckForTrailingSlash
#
# This function logs an error message if there is a trailing slash in the input string
#
# Inputs:
#         (top of stack)   - input string
#
# Outputs:
#         (none)
#
# Usage:
#
#         Push "C:\Program Files\POPFile\"
#         Call CheckForTrailingSlash
#
#         (an error message will be added to the log)
#
#--------------------------------------------------------------------------

Function CheckForTrailingSlash

  !define L_STRING  $R9
  !define L_TEMP    $R8

  Exch ${L_STRING}
  Push ${L_TEMP}

  StrCpy ${L_TEMP} ${L_STRING} 1 -1
  StrCmp ${L_TEMP} "\" 0 exit
  DetailPrint "^^^^^ Error ^^^^^   The above value should not end with '\' character"

exit:
  Pop ${L_TEMP}
  Pop ${L_STRING}

  !undef L_STRING
  !undef L_TEMP

FunctionEnd


#--------------------------------------------------------------------------
# Installer Function: CheckExeFilesExist
#
# This function checks that some important POPFile programs exist in the $INSTDIR folder
#
# Inputs:
#         (top of stack)   - source of the search path ("HKLM", HKCU" or "ROOT")
#
# Outputs:
#         (none)
#
# Usage:
#
#         Push "HKLM"
#         Call CheckExeFilesExist
#
#         (messages will be added to the log)
#
#--------------------------------------------------------------------------

Function CheckExeFilesExist

  !define C_EXPECTED_COUNT  6        ; at present we only check the popfile*.exe files

  !define L_COUNT       $R9          ; keeps track of the number of files found
  !define L_DIAG_MODE   $R8
  !define L_SOURCE      $R7          ; a four-character string: HKLM, HKCU or ROOT

  Exch ${L_SOURCE}
  Push ${L_COUNT}
  Push ${L_DIAG_MODE}

  StrCpy ${L_COUNT} ${C_EXPECTED_COUNT}
  GetCurInstType ${L_DIAG_MODE}

  !macro CHECK_EXE_EXISTS FILENAME
        !insertmacro PFI_UNIQUE_ID
        IfFileExists "$INSTDIR\${FILENAME}" lbl_b_${PFI_UNIQUE_ID}
        StrCmp ${L_DIAG_MODE} "${C_INST_TYPE_INDEX_SIMPLE}" lbl_a_${PFI_UNIQUE_ID}
        DetailPrint "${L_SOURCE}: missing EXE = *** ${FILENAME} ***"

      lbl_a_${PFI_UNIQUE_ID}:
        IntOp ${L_COUNT} ${L_COUNT} - 1

      lbl_b_${PFI_UNIQUE_ID}:
  !macroend

  StrCmp $INSTDIR "" unable_to_search
  IfFileExists "$INSTDIR\*.*" check_files

unable_to_search:
  DetailPrint "${L_SOURCE}: non-existent path specified ($INSTDIR)"
  DetailPrint "${L_SOURCE}: unable to search for 'popfile*.exe' files"
  Goto done

check_files:
  !insertmacro CHECK_EXE_EXISTS "popfile.exe"
  !insertmacro CHECK_EXE_EXISTS "popfileb.exe"
  !insertmacro CHECK_EXE_EXISTS "popfilef.exe"
  !insertmacro CHECK_EXE_EXISTS "popfileib.exe"
  !insertmacro CHECK_EXE_EXISTS "popfileif.exe"
  !insertmacro CHECK_EXE_EXISTS "popfile-service.exe"

  IntCmp ${L_COUNT} ${C_EXPECTED_COUNT} 0 errors_found
  StrCmp ${L_DIAG_MODE} "${C_INST_TYPE_INDEX_SIMPLE}" 0 continue
  DetailPrint ""

continue:
  DetailPrint "${L_SOURCE}: *.exe count = ${L_COUNT} (this is OK)"
  Goto done

errors_found:
  DetailPrint ""
  DetailPrint "${L_SOURCE}: *.exe count = ${L_COUNT}"
  DetailPrint "^^^^^ Error ^^^^^   The *.exe count should be ${C_EXPECTED_COUNT}"

done:
  DetailPrint ""

  Pop ${L_DIAG_MODE}
  Pop ${L_COUNT}
  Pop ${L_SOURCE}

  !undef L_COUNT
  !undef L_DIAG_MODE
  !undef L_SOURCE

FunctionEnd


#--------------------------------------------------------------------------
# Function used to manipulate the contents of the details view
#--------------------------------------------------------------------------

  ;------------------------------------------------------------------------
  ; Constants used when accessing the details view
  ;------------------------------------------------------------------------

  !define C_LVM_GETITEMCOUNT        0x1004
  !define C_LVM_ENSUREVISIBLE       0x1013
  !define C_LVM_COUNTPERPAGE        0x1028

#--------------------------------------------------------------------------
# Installer Function: ScrollToShowPaths
#
# Scrolls the details view up to make it show the locations of the
# program files and the 'User Data' files in LFN and SFN formats.
#
# Inputs:
#         none
#
# Outputs:
#         none
#
# Usage:
#         Call ScrollToShowPaths
#
#--------------------------------------------------------------------------

Function ScrollToShowPaths

  !define L_DLG_ITEM    $R9   ; the dialog item we are going to manipulate
  !define L_TEMP        $R8
  !define L_TOPROW      $R7   ; item index of the line we want at the top of the window

  Push ${L_DLG_ITEM}
  Push ${L_TEMP}
  Push ${L_TOPROW}

  ; Even the 'simple' report is too long to fit in the details view window so we
  ; automatically scroll the view to make it display the LFN and SFN versions of
  ; the POPFile program and 'User Data' folder locations (on the assumption that
  ; this is the information most users will want to find first).

  FindWindow ${L_DLG_ITEM} "#32770" "" $HWNDPARENT
  GetDlgItem ${L_DLG_ITEM} ${L_DLG_ITEM} 0x3F8      ; Control ID of the details view

  ; Check how many lines can be shown in the details view

  SendMessage ${L_DLG_ITEM} ${C_LVM_COUNTPERPAGE} 0 0 ${L_TEMP}

  ; The important data in a simple report is held in rows 10 to 19 (starting from 0)

  StrCpy ${L_TOPROW} 10   ; index of the "Current UserName" row in the simple report
  IntCmp ${L_TEMP} 10 getrowcount getrowcount
  StrCpy ${L_TOPROW} 9    ; index of the blank line before "Current UserName"

getrowcount:

  ; Check how many 'details' lines there are in the report

  SendMessage ${L_DLG_ITEM} ${C_LVM_GETITEMCOUNT} 0 0 ${L_TEMP}

  ; No point in trying to display a non-existent line

  IntCmp ${L_TEMP} ${L_TOPROW} exit exit

  ; Scroll up (in effect) to show the Current UserName, Program & User Data folder info

  SendMessage ${L_DLG_ITEM} ${C_LVM_ENSUREVISIBLE} ${L_TOPROW} 0

exit:
  Pop ${L_TOPROW}
  Pop ${L_TEMP}
  Pop ${L_DLG_ITEM}

  !undef L_DLG_ITEM
  !undef L_TEMP
  !undef L_TOPROW

FunctionEnd

#--------------------------------------------------------------------------
# End of 'pfidiag.nsi'
#--------------------------------------------------------------------------
