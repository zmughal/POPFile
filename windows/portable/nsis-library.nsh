#--------------------------------------------------------------------------
#
# nsis-library.nsh --- This is a collection of library functions based
#                      upon functions shipped with the NSIS compiler.
#                      The functions in this library have been given
#                      names starting 'NSIS_' to identify their source.
#
#--------------------------------------------------------------------------
#                      NSIS 'Include' files used:
#
#                      (1) ${NSISDIR}\Include\FileFunc.nsh
#                      (2) ${NSISDIR}\Include\TextFunc.nsh
#
#                      The above NSIS files support a 'macro-based' syntax,
#                      e.g.
#
#                      ${GetParent} "C:\Program Files\Winamp\uninstwa.exe" $R0
#
#                      This library makes it easier to use these functions in
#                      a traditional 'function-based' environment,e.g.
#
#                      Push "C:\Program Files\Winamp\uninstwa.exe"
#                      Call GetParent
#                      Pop $R0
#--------------------------------------------------------------------------

  !define C_NSIS_LIBRARY_VERSION     "0.0.1"

  ;----------------------------------------------
  ; Use the following standard NSIS header files:
  ;----------------------------------------------

  !include  FileFunc.nsh
  !include  TextFunc.nsh

#=============================================================================================
#
# Functions used only during 'installation':
#
#    Installer Function: NSIS_GetRoot
#
#=============================================================================================

!ifdef PORTABLE

  #--------------------------------------------------------------------------
  # Installer Function: NSIS_GetRoot
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
  #         Call NSIS_GetRoot
  #         Pop $R0
  #
  #         ($R0 at this point is ""C:")
  #
  #--------------------------------------------------------------------------

  Function NSIS_GetRoot

    !define L_INPUT   $R9
    !define L_OUTPUT  $R8

    Exch ${L_INPUT}
    Push ${L_OUTPUT}
    Exch

    ${GetRoot} ${L_INPUT} ${L_OUTPUT}

    Pop ${L_INPUT}
    Exch ${L_OUTPUT}

    !undef L_INPUT
    !undef L_OUTPUT

  FunctionEnd
!endif

#=============================================================================================
#
# Macro-based Functions which may be used by installer or uninstaller (in alphabetic order)
#
#    Macro:                NSIS_GetParameters
#    Installer Function:   NSIS_GetParameters
#    Uninstaller Function: un.NSIS_GetParameters
#
#    Macro:                NSIS_GetParent
#    Installer Function:   NSIS_GetParent
#    Uninstaller Function: un.NSIS_GetParent
#
#    Macro:                NSIS_TrimNewlines
#    Installer Function:   NSIS_TrimNewlines
#    Uninstaller Function: un.NSIS_TrimNewlines
#
#=============================================================================================


#--------------------------------------------------------------------------
# Macro: NSIS_GetParameters
#
# The installation process and the uninstall process may need a function which extracts
# the parameters (if any) supplied on the command-line. This macro makes maintenance
# easier by ensuring that both processes use identical functions, with the only difference
# being their names.
#
# NOTE:
# The !insertmacro NSIS_GetParameters "" and !insertmacro NSIS_GetParameters "un." commands are
# included in this file so the NSIS script can use 'Call NSIS_GetParameters' and
# 'Call un.NSIS_GetParameters' without additional preparation.
#
# Inputs:
#         none
#
# Outputs:
#         top of stack)     - all of the parameters supplied on the command line (may be "")
#
# Usage (after macro has been 'inserted'):
#
#         Call NSIS_GetParameters
#         Pop $R0
#
#         (if 'setup.exe /SSL' was used to start the installer, $R0 will hold '/SSL')
#--------------------------------------------------------------------------

!macro NSIS_GetParameters UN
  Function ${UN}NSIS_GetParameters

    !define L_OUTPUT  $R9

    Push ${L_OUTPUT}

    ${GetParameters} ${L_OUTPUT}

    Exch ${L_OUTPUT}

    !undef L_OUTPUT

  FunctionEnd
!macroend

!ifndef CREATEUSER
    #--------------------------------------------------------------------------
    # Installer Function: NSIS_GetParameters
    #
    # This function is used during the installation process
    #--------------------------------------------------------------------------

    !insertmacro NSIS_GetParameters ""
!endif

;    #--------------------------------------------------------------------------
;    # Uninnstaller Function: un.NSIS_GetParameters
;    #
;    # This function is used during the uninstallation process
;    #--------------------------------------------------------------------------
;
;    !insertmacro NSIS_GetParameters "un."


#--------------------------------------------------------------------------
# Macro: NSIS_GetParent
#
# The installation process and the uninstall process may both use a function which extracts
# the parent directory from a given path. This macro makes maintenance easier by ensuring
# that both processes use identical functions, with the only difference being their names.
#
# NB: The path is assumed to use backslashes (\)
#
# NOTE:
# The !insertmacro NSIS_GetParent "" and !insertmacro NSIS_GetParent "un." commands are
# included in this file so the NSIS script can use 'Call NSIS_GetParent' and
# 'Call un.NSIS_GetParent' without additional preparation.
#
# Inputs:
#         (top of stack)          - string containing a path (e.g. C:\A\B\C)
#
# Outputs:
#         (top of stack)          - the parent part of the input string (e.g. C:\A\B)
#                                   or an empty string if only a filename was supplied
#
# Usage (after macro has been 'inserted'):
#
#         Push "C:\Program Files\Directory\Whatever"
#         Call un.NSIS_GetParent
#         Pop $R0
#
#         ($R0 at this point is ""C:\Program Files\Directory")
#
#--------------------------------------------------------------------------

!macro NSIS_GetParent UN
  Function ${UN}NSIS_GetParent

    !define L_INPUT   $R9
    !define L_OUTPUT  $R8

    Exch ${L_INPUT}
    Push ${L_OUTPUT}
    Exch

    ${GetParent} ${L_INPUT} ${L_OUTPUT}

    Pop ${L_INPUT}
    Exch ${L_OUTPUT}

    !undef L_INPUT
    !undef L_OUTPUT

  FunctionEnd
!macroend

!ifdef CREATEUSER | LFNFIXER | PORTABLE
    #--------------------------------------------------------------------------
    # Installer Function: NSIS_GetParent
    #
    # This function is used during the installation process
    #--------------------------------------------------------------------------

    !insertmacro NSIS_GetParent ""
!endif

;    #--------------------------------------------------------------------------
;    # Uninnstaller Function: un.NSIS_GetParent
;    #
;    # This function is used during the uninstallation process
;    #--------------------------------------------------------------------------
;
;    !insertmacro NSIS_GetParent "un."


#--------------------------------------------------------------------------
# Macro: NSIS_TrimNewlines
#
# The installation process and the uninstall process may both use a function to trim newlines
# from lines of text. This macro makes maintenance easier by ensuring that both processes use
# identical functions, with the only difference being their names.
#
# NOTE:
# The !insertmacro NSIS_TrimNewlines "" and !insertmacro NSIS_TrimNewlines "un." commands are
# included in this file so the NSIS script can use 'Call NSIS_TrimNewlines' and
# 'Call un.NSIS_TrimNewlines' without additional preparation.
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
#         Call un.NSIS_TrimNewlines
#         Pop $R0
#         ($R0 at this point is "whatever")
#
#--------------------------------------------------------------------------

!macro NSIS_TrimNewlines UN
  Function ${UN}NSIS_TrimNewlines

    !define L_INPUT   $R9
    !define L_OUTPUT  $R8

    Exch ${L_INPUT}
    Push ${L_OUTPUT}
    Exch

    ${TrimNewlines} ${L_INPUT} ${L_OUTPUT}

    Pop ${L_INPUT}
    Exch ${L_OUTPUT}

    !undef L_INPUT
    !undef L_OUTPUT

  FunctionEnd
!macroend

!ifndef LFNFIXER
    #--------------------------------------------------------------------------
    # Installer Function: NSIS_TrimNewlines
    #
    # This function is used during the installation process
    #--------------------------------------------------------------------------

    !insertmacro NSIS_TrimNewlines ""
!endif

;    #--------------------------------------------------------------------------
;    # Uninnstaller Function: un.NSIS_TrimNewlines
;    #
;    # This function is used during the uninstallation process
;    #--------------------------------------------------------------------------
;
;    !insertmacro NSIS_TrimNewlines "un."


#--------------------------------------------------------------------------
# End of 'nsis-library.nsh'
#--------------------------------------------------------------------------
