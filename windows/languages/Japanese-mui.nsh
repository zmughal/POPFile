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
#--------------------------------------------------------------------------

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
