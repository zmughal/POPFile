#--------------------------------------------------------------------------
# Japanese-parser.nsh
#
# This file contains the "Japanese" text strings used by the Windows installer
# when installing the "Nihongo Parser". Normally the multi-language build of
# the installer uses language strings for the text but since the "Nihongo Parser"
# is only installed when the "Nihongo" (Japanese) language is selected, this
# file defines some constants instead of using LanguageString commands.
#
# Copyright (c) 2007 John Graham-Cumming
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

;-------------------------------------------------------------------------------------------
; Custom Page - Choose Nihongo Parser
;-------------------------------------------------------------------------------------------

; Page title and sub-title

!define C_NPLS_HEADER_ChooseParser  "���{��̕����������Ɏg�p����v���O������I�����Ă��������B"
!define C_NPLS_DESC_ChooseParser    "POPFile ���g���ē��{��̃��[���𕪐͂��邽�߂ɂ́A���[���̖{����P�ꂲ�Ƃɕ�������i�����������j�K�v������܂��B"

; Description shown in the text box when 'Kakasi' has been selected

!define C_NPLS_DESC_Kakasi          "POPFile 0.22.5 �܂ł̃o�[�W�����Ŏg�p����Ă����v���O�����ł��B$\r$\n$\r$\n�����������̐��x�� MeCab �ɔ�ׂ�ƒႢ�i�Ђ炪�Ȃ�J�^�J�i�ō\������Ă���P��̏��������Ă��Ȃ��j�ł����AMeCab �ɔ�׎����T�C�Y���������Ă��݂܂��iMeCab 40MB �ɑ΂��� 2MB ���x�j�B$\r$\n$\r$\nKakasi �Ǝ����t�@�C���̓C���X�g�[���ɓ�������Ă��܂��B"

; Description shown in the text box when 'MeCab' has been selected

!define C_NPLS_DESC_MeCab           "Kakasi ������萳�m�ȕ������������s�����Ƃ��ł��܂����A�����T�C�Y���傫���Ȃ�܂��i40MB ���x�j�B$\r$\n$\r$\n�C���X�g�[���ɂ͓�������Ă��܂���BMeCab �I�v�V������I�������ꍇ�A���悻 13MB �̃t�@�C�����C���^�[�l�b�g���_�E�����[�h����A�C���X�g�[������܂��B"

; Description shown in the text box when 'Internal' has been selected

!define C_NPLS_DESC_Internal        "�O���v���O�������g�킸�ɁA�����̎�ށi�����A�Ђ炪�ȁA�J�^�J�i�Ȃǁj�����������ɕ������������s���܂��B$\r$\n$\r$\n�������g�p���������������ɔ�ו����������̐��x�͗����܂����A������K�v�Ƃ����A�����ɓ��삵�܂��B"

; Flags setting for the text box (allows English version to use a vertical scroll bar even if the Japanese version does not use one)

!define C_NPLS_DESC_Flags           "READONLY|MULTILINE|VSCROLL"

; Text for the three radio buttons used to select the parser to be installed

!define C_NPLS_Option_Kakasi        "Kakasi: ����������(���[�}��)�ϊ��v���O�����i�����j(&K)"
!define C_NPLS_Option_MeCab         "MeCab: Yet Another Part-of-Speech and Morphological Analyzer (&M)"
!define C_NPLS_Option_Internal      "�����p�[�T: ������ɂ�镪�� (&I)"

; Text and URL used in the area below the description text box

!define C_NPLS_Note                 "�� �����������̐��x�� POPFile �̕��ސ��x�Ƃ̊Ԃɂ͒��ڂ̈��ʊ֌W�͂Ȃ��A�ǂ̃v���O�������g�p���Ă� POPFile �̕��ސ��x�ɂ͂قƂ�ǈႢ�͂Ȃ��Ƃ������ʂ��o�Ă��܂��B\r\n\r\n�� �����������̃v���O������ύX����ƁA�ꎞ�I�� POPFile �̕��ސ��x���ቺ����\��������܂��B\r\n\r\n�� �C���X�g�[����ɕ����������̃v���O������ύX���邱�Ƃ��ł��܂��B�ڂ����͉��̃����N���N���b�N�B"
!define C_NPLS_Link                 "http://getpopfile.org/wiki/jp:faq:mecab"

;-------------------------------------------------------------------------------------------
; Standard MUI Page - COMPONENTS (text used when the mouse hovers over the "Nihongo Parser" entry)
;-------------------------------------------------------------------------------------------

!define C_NPLS_DESC_SecParser       "POPFile �͓��{��̃e�L�X�g��P�ꂲ�Ƃɕ������邽�߂̃v���O�������g�p���܂��B����́u$G_PARSER�v���I������Ă��܂�"

;-------------------------------------------------------------------------------------------
; Custom Page - Setup Summary Page (lists the items which are going to be installed)
;-------------------------------------------------------------------------------------------

!define C_NPLS_SUMMARY_KAKASI      "���{�ꏈ���v���O�����i�uKakasi�v���C���X�g�[������܂��j"
!define C_NPLS_SUMMARY_MECAB       "���{�ꏈ���v���O�����i�uMeCab�v���_�E�����[�h�E�C���X�g�[������܂��j"
!define C_NPLS_SUMMARY_INTERNAL    "���{�ꏈ���v���O�����i�u�����p�[�T�v���g�p����܂��j"

;-------------------------------------------------------------------------------------------
; Standard MUI Page - INSTFILES (messages displayed when attempting to download the MeCab files)
;-------------------------------------------------------------------------------------------

; Message shown above the progress bar while comparing the expected and actual MD5 sums for the files listed in 'mecab.md5'

!define C_NPLS_VERIFYING_MECAB     "'$G_PLS_FIELD_1' �t�H���_�̃t�@�C�������؂��Ă��܂�..."

; Message shown above the progress bar with the result of the 'mecab.md5' MD5 checks

!define C_NPLS_MECAB_MD5_RESULT    "MeCab �̌��،���: $G_PLS_FIELD_1"

; Message shown if internet connection does not appear to be working

!define C_NPLS_CHECKINTERNET       "MeCab �̃t�@�C���̓C���^�[�l�b�g����_�E�����[�h����܂��B${MB_NL}${MB_NL}�C���^�[�l�b�g�ڑ����_�E�����Ă��邩�����ɂȂ��Ă���悤�ł��B${MB_NL}${MB_NL}�C���X�g�[���𑱂���ɂ͐ڑ����Ȃ����Ă��� Retry ���N���b�N���Ă�������"

; Message shown if unable to download and install the MeCab files)

!define C_NPLS_REPEATMECAB         "MeCab �̃t�@�C�����C���X�g�[���ł��܂���ł���!${MB_NL}${MB_NL}�ēx�C���X�g�[�������݂�ɂ́A�u�v���O�����̒ǉ��ƍ폜�v��${MB_NL}${MB_NL}POPFile ${C_POPFILE_MAJOR_VERSION}.${C_POPFILE_MINOR_VERSION}.${C_POPFILE_REVISION}${C_POPFILE_RC} �̍��ڂ��g�p���Ă�������"

#--------------------------------------------------------------------------
# End of 'Japanese-parser.nsh'
#--------------------------------------------------------------------------
