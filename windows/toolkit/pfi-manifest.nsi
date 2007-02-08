#-------------------------------------------------------------------------------------------
#
# pfi-manifest.nsi --- A simple utility used at compile-time to adjust the manifest created
#                      by the NSIS compiler. Windows Vista uses this manifest to determine
#                      the privileges required by a program. This manifest also identifies
#                      programs as being built using NSIS which may result in Windows Vista
#                      wrongly identifying the NSIS-based POPFile utilities as "installers".
#                      This utility changes the two 'NSIS' references in the manifest.
#
# Copyright (c) 2007  John Graham-Cumming
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

#-------------------------------------------------------------------------------------------
# Usage:
#
# PFI_MANIFEST /FILE="filename" /NAME="new 'name' text" /DESCRIPTION="new 'description' text"
#
# where
#
#   "filename" is the fullpathname to the file to be modified (normally the 'exehead' header)
#
#   "new 'name' text" is the text used to replace the default "Nullsoft.NSIS.exehead" string
#   in the manifest
#
#   "new 'description' text" is the text used to replace the default description string
#   in the manifest (the NSIS 2.22 compiler inserts the string "Nullsoft Install System v2.22")
#
# ('/FILE', '/NAME' and '/DESCRIPTION' can be in uppercase or lowercase)
#
# Normally this utility will be used at compile time via the '!packhdr' command, e.g.
#
#       ;--------------------------------------------------------------------------
#       ; Windows Vista expects to find a manifest specifying the execution level
#       ;--------------------------------------------------------------------------
#
#       RequestExecutionLevel   user
#
#       !tempfile EXE_HDR
#       !packhdr "${EXE_HDR}" \
#         '"toolkit\pfi-manifest.exe" \
#             /FILE="${EXE_HDR}" \
#             /NAME="POPFile.utility" \
#             /DESCRIPTION="Capture console messages from POPFile"'
#
#-------------------------------------------------------------------------------------------
#
# 'Resource Hacker (TM)', a freeware utility, is used to extract (save) the manifest resource
# created by the NSIS compiler and to replace it with our modified version. 'Resource Hacker'
# can be used interactively or, as here, via the command-line. The home page, with download
# links, for 'Resource Hacker' is at http://www.angusj.com/resourcehacker/
#
#-------------------------------------------------------------------------------------------

  ;------------------------------------------------
  ; This script requires the 'XML' NSIS plugin
  ;------------------------------------------------

  ; The manifest is stored as an XML document therefore this script uses a special NSIS plugin
  ; (XML) to modify the manifest after it has been extracted from the header.
  ;
  ; The 'NSIS Wiki' page for the 'XML' plugin (description and download links):
  ; http://nsis.sourceforge.net/XML_plug-in
  ;
  ; Unlike most plugins, this one requires _two_ files to be installed before it can be used.
  ;
  ; To compile this script, copy the 'xml.dll' file to the standard NSIS plugins folder
  ; (${NSISDIR}\Plugins\) and the 'XML.nsh' header file to the standard NSIS 'Include' folder
  ; (${NSISDIR}\Include\). The 'XML' documentation, example & source files can be unzipped
  ; to the appropriate ${NSISDIR} sub-folders if you wish, but this step is entirely optional.
  ;
  ; Tested with Version 1.8 of the XML plugin
  ;------------------------------------------------

  ; This version of the script has been tested with the "NSIS v2.22" compiler,
  ; released 27 November 2006. This particular compiler can be downloaded from
  ; http://prdownloads.sourceforge.net/nsis/nsis-2.22-setup.exe?download

  !define ${NSIS_VERSION}_found

  !ifndef v2.22_found
      !warning \
          "$\r$\n\
          $\r$\n***   NSIS COMPILER WARNING:\
          $\r$\n***\
          $\r$\n***   This script has only been tested using the NSIS v2.22 compiler\
          $\r$\n***   and may not work properly with this NSIS ${NSIS_VERSION} compiler\
          $\r$\n***\
          $\r$\n***   The resulting 'installer' program should be tested carefully!\
          $\r$\n$\r$\n"
  !endif

  !undef  ${NSIS_VERSION}_found

  ;--------------------------------------------------------------------------
  ; Symbol used to avoid confusion over where the line breaks occur.
  ;
  ; ${MB_NL} is used for MessageBox-style 'new line' sequences.
  ;
  ; (this constant does not follow the 'C_' naming convention described below)
  ;--------------------------------------------------------------------------

  !define MB_NL   "$\r$\n"

  ;--------------------------------------------------------------------------
  ; POPFile constants have been given names beginning with 'C_' (eg C_README)
  ;--------------------------------------------------------------------------

  !define C_VERSION   "0.0.1"     ; see 'VIProductVersion' comment below for format details
  !define C_OUTFILE   "pfi-manifest.exe"

  ; The default NSIS caption is "Name Setup" so we override it here

  Name    "POPFile Manifest Updater ${C_VERSION}"
  Caption "$(^Name)"

  ; Specify EXE filename and icon for the 'installer'

  OutFile "${C_OUTFILE}"

  Icon "..\POPFileIcon\popfile.ico"

  ; Selecting 'silent' mode makes the installer behave like a command-line utility

  SilentInstall silent

  ;--------------------------------------------------------------------------
  ; Windows Vista expects to find a manifest specifying the execution level
  ;--------------------------------------------------------------------------

  RequestExecutionLevel   user

  ; Define the temporary file used when modifying the manifest

  !define C_MANIFEST_OLD    "$PLUGINSDIR\manifest"
  !define C_MANIFEST_XML    "$PLUGINSDIR\manifest.xml"
  !define C_MANIFEST_NEW    "$PLUGINSDIR\manifest.new"

#--------------------------------------------------------------------------
# Include library functions and macro definitions
#--------------------------------------------------------------------------

  !include "XML.nsh"
  !include "FileFunc.nsh"
  !insertmacro GetParameters
  !insertmacro GetOptions

#--------------------------------------------------------------------------

  ; 'VIProductVersion' format is X.X.X.X where X is a number in range 0 to 65535
  ; representing the following values: Major.Minor.Release.Build

  VIProductVersion                          "${C_VERSION}.0"

  !define /date C_BUILD_YEAR                "%Y"

  VIAddVersionKey "ProductName"             "This utility changes some NSIS references \
                                             in the manifest used by Vista"
  VIAddVersionKey "Comments"                "POPFile Homepage: http://getpopfile.org/"
  VIAddVersionKey "CompanyName"             "The POPFile Project"
  VIAddVersionKey "LegalTrademarks"         "POPFile is a registered trademark of \
                                             John Graham-Cumming"
  VIAddVersionKey "LegalCopyright"          "Copyright (c) ${C_BUILD_YEAR}  John Graham-Cumming"
  VIAddVersionKey "FileDescription"         "Vista manifest updater for POPFile"
  VIAddVersionKey "FileVersion"             "${C_VERSION}"
  VIAddVersionKey "OriginalFilename"        "${C_OUTFILE}"

  VIAddVersionKey "Build Compiler"           "NSIS ${NSIS_VERSION}"
  VIAddVersionKey "Build Date/Time"         "${__DATE__} @ ${__TIME__}"
  !ifdef C_PFI_LIBRARY_VERSION
    VIAddVersionKey "Build Library Version" "${C_PFI_LIBRARY_VERSION}"
  !endif
  VIAddVersionKey "Build Script"            "${__FILE__}${MB_NL}(${__TIMESTAMP__})"

#----------------------------------------------------------------------------------------

#--------------------------------------------------------------------------
# User Variables (Global)
#--------------------------------------------------------------------------

  ; This script uses 'User Variables' (with names starting with 'G_') to hold GLOBAL data.

  Var G_DESC      ; the text string to be used for the "description" in the manifest
  Var G_FILE      ; full pathname of the file to be modified
  Var G_NAME      ; the text string to be used for the "name" in the manifest

;--------------------------------------
; Initialisation
;--------------------------------------

Function .onInit

  !define L_ERRORMSG  $R9   ; used to customise the error message
  !define L_OPTIONS   $R8   ; command-line options supplied at run-time
  !define L_UTILNAME  $R7   ; utility's name (for use in error message)

  Push ${L_ERRORMSG}
  Push ${L_OPTIONS}
  Push ${L_UTILNAME}

  ${GetParameters} ${L_OPTIONS}

  ${GetOptions} "${L_OPTIONS}" "/FILE=" $G_FILE
  IfErrors file_error

  ${GetOptions} "${L_OPTIONS}" "/NAME=" $G_NAME
  IfErrors name_error

  ${GetOptions} "${L_OPTIONS}" "/DESCRIPTION=" $G_DESC
  IfErrors description_error
  Goto exit

file_error:
  StrCpy ${L_ERRORMSG} '"File name" parameter is missing!'
  Goto error_msg

name_error:
  StrCpy ${L_ERRORMSG} '"New name text" parameter is missing!'
  Goto error_msg

description_error:
  StrCpy ${L_ERRORMSG} '"New description text" parameter is missing!'

error_msg:
  Push $R0
  Push $R1

  ; The first system call gets the full pathname (returned in $R0) and the second call
  ; extracts the filename (and possibly the extension) part (returned in $R1)

  System::Call 'kernel32::GetModuleFileNameA(i 0, t .R0, i 1024)'
  System::Call 'comdlg32::GetFileTitleA(t R0, t .R1, i 1024)'
  StrCpy ${L_UTILNAME} $R1

  Pop $R1
  Pop $R0

  MessageBox MB_OK|MB_ICONSTOP '${L_ERRORMSG}\
      ${MB_NL}${MB_NL}\
      Usage: \
      ${L_UTILNAME} /FILE="file name" /NAME="new name text" /DESCRIPTION="new description text"'
  Quit

exit:
  InitPluginsDir

  Pop ${L_UTILNAME}
  Pop ${L_OPTIONS}
  Pop ${L_ERRORMSG}

  !undef L_ERRORMSG
  !undef L_OPTIONS
  !undef L_UTILNAME

FunctionEnd

;--------------------------------------
; Extract, Update and Replace the manifest
;--------------------------------------

Section "UpdateManifest"

  ; First extract the manifest created by NSIS

  ExecWait '"$EXEDIR\reshacker\reshacker.exe" -extract "$G_FILE", "${C_MANIFEST_OLD}", 24, 1,'

  ; Now replace the two references to "NSIS" in the manifest with references to POPFile

  Call AdjustManifest

  ; Ensure the modified manifest is in same format as the NSIS-created one
  ; (i.e. one line with no extra whitespace)

  Push "${C_MANIFEST_XML}"
  Push "${C_MANIFEST_NEW}"
  Call CleanupXML

  ; Overwrite the existing NSIS-created manifest with the modified manifest

  ExecWait '"$EXEDIR\reshacker\reshacker.exe" \
    -addoverwrite "$G_FILE", "$G_FILE", "${C_MANIFEST_NEW}", 24, 1,'

SectionEnd

;--------------------------------------
; Function: Change the two NSIS entries in the manifest
;--------------------------------------

Function AdjustManifest

  !define L_ERRORMSG  $R9     ; used to customise the error messages
  !define L_RESULT    $R8     ; result code returned by the XML plugin
  !define L_STRING    $R7     ; text string read from the manifest

  Push ${L_ERRORMSG}
  Push ${L_RESULT}
  Push ${L_STRING}

  ${xml::LoadFile} "${C_MANIFEST_OLD}" ${L_RESULT}
  StrCmp ${L_RESULT} "-1" load_error

  ${xml::GotoPath} "/assembly/assemblyIdentity" ${L_RESULT}
  StrCmp ${L_RESULT} "-1" identity_path_error

  ${xml::GetAttribute} "name" ${L_STRING} ${L_RESULT}
  StrCmp ${L_RESULT} "-1" get_name_error
  StrCmp ${L_STRING} "Nullsoft.NSIS.exehead" change_name
  MessageBox MB_OK|MB_ICONINFORMATION "Unexpected value found for 'name' attribute\
    ${MB_NL}\
    (${L_STRING})"

change_name:
  ${xml::SetAttribute} "name" "$G_NAME" ${L_RESULT}
  StrCmp ${L_RESULT} "-1" set_name_error

  ${xml::GotoPath} "/assembly/description" ${L_RESULT}
  StrCmp ${L_RESULT} "-1" description_path_error

  ${xml::GetText} ${L_STRING} ${L_RESULT}
  StrCmp ${L_RESULT} "-1" get_description_error
  StrCpy ${L_RESULT} ${L_STRING} 23
  StrCmp ${L_RESULT} "Nullsoft Install System" change_description
  MessageBox MB_OK|MB_ICONINFORMATION "Unexpected value found for 'description' text\
    ${MB_NL}\
    (${L_STRING})"

change_description:
  ${xml::SetText} "$G_DESC" ${L_RESULT}
  StrCmp ${L_RESULT} "-1" set_description_error

  ${xml::SetCondenseWhiteSpace} "1"

  ${xml::SaveFile} "${C_MANIFEST_XML}" ${L_RESULT}
  StrCmp ${L_RESULT} "0" exit

;save_error:
  StrCpy ${L_ERRORMSG} "Unable to save the modified manifest XML file (${C_MANIFEST_XML})"
  Goto error_exit

load_error:
  StrCpy ${L_ERRORMSG} "Unable to load the manifest XML file (${C_MANIFEST_OLD})"
  Goto error_exit

identity_path_error:
  StrCpy ${L_ERRORMSG} "Unable to find '/assembly/assemblyIdentity' path"
  Goto error_exit

get_name_error:
  StrCpy ${L_ERRORMSG} "Unable to read the 'name' attribute"
  Goto error_exit

set_name_error:
  StrCpy ${L_ERRORMSG} "Unable to set the 'name' attribute"
  Goto error_exit

description_path_error:
  StrCpy ${L_ERRORMSG} "Unable to find '/assembly/description' path"
  Goto error_exit

get_description_error:
  StrCpy ${L_ERRORMSG} "Unable to read the 'description' text"
  Goto error_exit

set_description_error:
  StrCpy ${L_ERRORMSG} "Unable to set the 'description' text"
  Goto error_exit

error_exit:
  MessageBox MB_OK|MB_ICONEXCLAMATION "${L_ERRORMSG}\
    ${MB_NL}${MB_NL}\
    Manifest has _not_ been updated"

exit:
  ${xml::Unload}

  Pop ${L_STRING}
  Pop ${L_RESULT}
  Pop ${L_ERRORMSG}

  !undef L_ERRORMSG
  !undef L_RESULT
  !undef L_STRING

FunctionEnd

#--------------------------------------
# Function: Remove the formatting inserted by the XML plugin
#
# Inputs:
#         (top of stack)        - full pathname of output file
#         (top of stack - 1)    - full pathname of input file
#
# Outputs:
#         (none)
#
# Usage:
#         Push "C:\TEMP\input_file.xml"
#         Push "C:\TEMP\output_file.xml"
#         Call CleanupXML
#
#--------------------------------------

Function CleanupXML

  !define L_FILENAME_IN   $R9     ; fullpathname of the input file
  !define L_FILENAME_OUT  $R8     ; fullpathname of the output file
  !define L_INPUT         $R7     ; handle used to access input file
  !define L_OUTPUT        $R6     ; handle used to access the output file
  !define L_STRING        $R5     ; line of data read from/written to a file

  Exch ${L_FILENAME_OUT}
  Exch
  Exch ${L_FILENAME_IN}
  Exch
  Push ${L_INPUT}
  Push ${L_OUTPUT}
  Push ${L_STRING}

  StrCmp "${L_FILENAME_IN}" "${L_FILENAME_OUT}" 0 continue
  MessageBox MB_OK|MB_ICONSTOP "Error: 'CleanupXML' input file = output file!\
      ${MB_NL}${MB_NL}\
      input = ${L_FILENAME_IN}\
      ${MB_NL}\
      output = ${L_FILENAME_OUT}"
  Goto exit

continue:
  FileOpen ${L_INPUT}  "${L_FILENAME_IN}" "r"
  FileOpen ${L_OUTPUT} "${L_FILENAME_OUT}" "w"

loop:
  FileRead ${L_INPUT} ${L_STRING}
  StrCmp ${L_STRING} "" done
  Push ${L_STRING}
  Call TrimNewlines
  Call StrStripLS
  Pop ${L_STRING}
  FileWrite ${L_OUTPUT} ${L_STRING}
  Goto loop

done:
  FileClose ${L_INPUT}
  FileClose ${L_OUTPUT}

exit:
  Pop ${L_STRING}
  Pop ${L_OUTPUT}
  Pop ${L_INPUT}
  Pop ${L_FILENAME_OUT}
  Pop ${L_FILENAME_IN}

  !undef L_FILENAME_IN
  !undef L_FILENAME_OUT
  !undef L_INPUT
  !undef L_OUTPUT
  !undef L_STRING

FunctionEnd

;--------------------------------------
; Function: Strip any end-of-line sequences from a string
;--------------------------------------

 Function TrimNewlines
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

#--------------------------------------------------------------------------
# Installer Function: StrStripLS
#
# Strips leading spaces from a string.
#
# Inputs:
#         (top of stack)     - string to be processed
# Outputs:
#         (top of stack)     - processed string (with no leading spaces)
#
# Usage:
#         Push "  123"
#         Call StrStripLS
#         Pop $R0
#
#         ($R0 at this point is "123")
#
#--------------------------------------------------------------------------

Function StrStripLS

  !define L_CHAR      $R9
  !define L_STRING    $R8

  Exch ${L_STRING}
  Push ${L_CHAR}

loop:
  StrCpy ${L_CHAR} ${L_STRING} 1
  StrCmp ${L_CHAR} "" done
  StrCmp ${L_CHAR} " " strip_char
  Goto done

strip_char:
  StrCpy ${L_STRING} ${L_STRING} "" 1
  Goto loop

done:
  Pop ${L_CHAR}
  Exch ${L_STRING}

  !undef L_CHAR
  !undef L_STRING

FunctionEnd

;--------------------------------------
; end-of-file
;--------------------------------------
