#--------------------------------------------------------------------------
# Japanese-mui.nsh
#
# This file contains additional "Japanese" text strings used by the Windows installer
# for POPFile (these strings are customised versions of strings provided by NSIS).
#
# See 'Japanese-pfi.nsh' for the strings which are used on the custom pages.
#
# These strings are grouped according to the page/window where they are used
#
# Copyright (c) 2001-2003 John Graham-Cumming
#
#   This file is part of POPFile
#
#   POPFile is free software; you can redistribute it and/or modify
#   it under the terms of the GNU General Public License as published by
#   the Free Software Foundation; either version 2 of the License, or
#   (at your option) any later version.
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

!ifndef PFI_VERBOSE
  !verbose 3
!endif

#--------------------------------------------------------------------------
# Standard MUI Page - Welcome
#
# The sequence \r\n\r\n inserts a blank line (note that the MUI_TEXT_WELCOME_INFO_TEXT string
# should end with a \r\n\r\n sequence because another paragraph follows this string).
#--------------------------------------------------------------------------

; POPFile translation not available - use default NSIS message

;!insertmacro MUI_LANGUAGEFILE_STRING MUI_TEXT_WELCOME_INFO_TEXT \
;"This wizard will guide you through the installation of POPFile.\r\n\r\n\It is recommended that you close all other applications before starting Setup.\r\n\r\n"

; Default NSIS message:

;!insertmacro MUI_LANGUAGEFILE_STRING MUI_TEXT_WELCOME_INFO_TEXT \
;"���̃E�B�U�[�h�́APOPFile �̃C���X�g�[�����K�C�h���Ă����܂��B\r\n\r\n�Z�b�g�A�b�v���J�n����O�ɁA���̂��ׂẴA�v���P�[�V�������I�����邱�Ƃ𐄏����܂��B����ɂ���āA�Z�b�g�A�b�v�����̃R���s���[�^���ċN�������ɁA�m���ɃV�X�e�� �t�@�C�����A�b�v�f�[�g���邱�Ƃ��o����悤�ɂȂ�܂��B\r\n\r\n"

#--------------------------------------------------------------------------
# Standard MUI Page - Finish
#
# The MUI_TEXT_FINISH_RUN text should be a short phrase (not a long paragraph)
#--------------------------------------------------------------------------

!insertmacro MUI_LANGUAGEFILE_STRING MUI_TEXT_FINISH_RUN \
"POPFile User Interface"

#--------------------------------------------------------------------------
# End of 'Japanese-mui.nsh'
#--------------------------------------------------------------------------
