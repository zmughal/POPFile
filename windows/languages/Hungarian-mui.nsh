#--------------------------------------------------------------------------
# Hungarian-mui.nsh
#
# This file contains additional "Hungarian" text strings used by the Windows installer
# for POPFile (these strings are customised versions of strings provided by NSIS).
#
# See 'Hungarian-pfi.nsh' for the strings which are used on the custom pages.
#
# These strings are grouped according to the page/window where they are used
#
# Copyright (c) 2001-2003 John Graham-Cumming
#
#--------------------------------------------------------------------------

!ifndef PFI_VERBOSE
  !verbose 3
!endif

#--------------------------------------------------------------------------
# Standard MUI Page - Welcome
#
# The sequence \r\n\r\n inserts a blank line (note that the MUI_TEXT_WELCOME_INFO_TEXT string
# should end with a \r\n\r\n sequence because another paragraph follows this string).
#--------------------------------------------------------------------------

!insertmacro MUI_LANGUAGEFILE_STRING MUI_TEXT_WELCOME_INFO_TEXT \
"A(z) POPFile telep�t�se k�vetkezik a sz�m�t�g�pre.\r\n\r\nJavasoljuk, hogy ind�t�s el�tt z�rja be a fut� alkalmaz�sokat. �gy a telep�t� a rendszer �jraind�t�sa n�lk�l tudja friss�teni a sz�ks�ges rendszerf�jlokat.\r\n\r\n"

#--------------------------------------------------------------------------
# Standard MUI Page - Finish
#
# The MUI_TEXT_FINISH_RUN text should be a short phrase (not a long paragraph)
#--------------------------------------------------------------------------

!insertmacro MUI_LANGUAGEFILE_STRING MUI_TEXT_FINISH_RUN \
"POPFile Felhaszn�l�i fel�let"

#--------------------------------------------------------------------------
# End of 'Hungarian-mui.nsh'
#--------------------------------------------------------------------------
