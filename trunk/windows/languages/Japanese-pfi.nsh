#--------------------------------------------------------------------------
# Japanese-pfi.nsh
#
# This file contains additional "Japanese" text strings used by the Windows installer
# for POPFile (these strings are unique to POPFile).
#
# See 'Japanese-mui.nsh' for the strings which modify standard NSIS MUI messages.
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
# String Formatting (applies to PFI_LANG_*_MB* text used for message boxes):
#
#   (1) The sequence  $\r$\n        inserts a newline
#   (2) The sequence  $\r$\n$\r\$n  inserts a blank line
#
# (the 'PFI_LANG_CBP_MBCONTERR_2' message box string which is listed under the heading
# 'Custom Page - POPFile Classification Bucket Creation' includes some examples)
#--------------------------------------------------------------------------
# String Formatting (applies to PFI_LANG_*_IO_ text used for custom pages):
#
#   (1) The sequence  \r\n      inserts a newline
#   (2) The sequence  \r\n\r\n  inserts a blank line
#
# (the 'PFI_LANG_CBP_IO_INTRO' custom page string which is listed under the heading
# 'Custom Page - POPFile Classification Bucket Creation' includes some examples)
#--------------------------------------------------------------------------

!ifndef PFI_VERBOSE
  !verbose 3
!endif

#--------------------------------------------------------------------------
# Mark the start of the language data
#--------------------------------------------------------------------------

!define PFI_LANG  "JAPANESE"

#--------------------------------------------------------------------------
# Startup message box offering to display the Release Notes
#--------------------------------------------------------------------------

!insertmacro PFI_LANG_STRING PFI_LANG_MBRELNOTES_1        "POPFile �̃����[�X�m�[�g��\�����܂����H"
!insertmacro PFI_LANG_STRING PFI_LANG_MBRELNOTES_2        "�A�b�v�O���[�h�̏ꍇ�́uYes�v�𐄏����܂��B(�A�b�v�O���[�h�̑O�Ƀo�b�N�A�b�v����邱�Ƃ𐄏����܂��B)"

#--------------------------------------------------------------------------
# Standard MUI Page - Choose Components
#--------------------------------------------------------------------------

!insertmacro PFI_LANG_STRING DESC_SecPOPFile              "POPFile �̃R�A�t�@�C�����C���X�g�[�����܂��B�ŏ��o�[�W������ Perl ���܂݂܂��B"
!insertmacro PFI_LANG_STRING DESC_SecSkins                "POPFile ���[�U�[�C���^�[�t�F�[�X�̃f�U�C����ς��邱�Ƃ��ł��� POPFile �X�L�����C���X�g�[�����܂��B"
!insertmacro PFI_LANG_STRING DESC_SecLangs                "POPFile UI �̉p��ȊO�̃o�[�W�������C���X�g�[�����܂��B"

#--------------------------------------------------------------------------
# Custom Page - POPFile Installation Options
#--------------------------------------------------------------------------

; Page Title and Sub-title displayed in the page header

!insertmacro PFI_LANG_STRING PFI_LANG_OPTIONS_TITLE       "POPFile �C���X�g�[���I�v�V����"
!insertmacro PFI_LANG_STRING PFI_LANG_OPTIONS_SUBTITLE    "�����̃I�v�V�����͕K�v�łȂ�����ύX���Ȃ��ŉ������B"

; Text strings displayed on the custom page

!insertmacro PFI_LANG_STRING PFI_LANG_OPTIONS_IO_POP3     "POP3 �ڑ��Ɏg�p����f�t�H���g�|�[�g�ԍ���I��ŉ������B(�����l:110)"
!insertmacro PFI_LANG_STRING PFI_LANG_OPTIONS_IO_GUI      "�u���[�U�[�C���^�[�t�F�[�X�v�Ɏg�p����f�t�H���g�|�[�g�ԍ���I��ŉ������B(�����l:8080)"
!insertmacro PFI_LANG_STRING PFI_LANG_OPTIONS_IO_STARTUP  "Windows �̋N������ POPFile �������I�ɋN������B(�o�b�N�O���E���h�ŋN��)"
!insertmacro PFI_LANG_STRING PFI_LANG_OPTIONS_IO_WARNING  "�d�v�Ȍx��"
!insertmacro PFI_LANG_STRING PFI_LANG_OPTIONS_IO_MESSAGE  "POPFile �̃A�b�v�O���[�h�̏ꍇ --- �C���X�g�[���[�͌��݂̃o�[�W�������V���b�g�_�E�����܂��B"

; Message Boxes used when validating user's selections

!insertmacro PFI_LANG_STRING PFI_LANG_OPTIONS_MBUNINST_1    "���̏ꏊ�ɈȑO�ɃC���X�g�[�����ꂽ POPFile ��������܂���:"
!insertmacro PFI_LANG_STRING PFI_LANG_OPTIONS_MBUNINST_2    "�A���C���X�g�[�����܂����H"
!insertmacro PFI_LANG_STRING PFI_LANG_OPTIONS_MBUNINST_3    "�uYes�v�𐄏����܂��B"

!insertmacro PFI_LANG_STRING PFI_LANG_OPTIONS_MBPOP3_1    "������ POP3 �|�[�g�ԍ�:"
!insertmacro PFI_LANG_STRING PFI_LANG_OPTIONS_MBPOP3_2    "�|�[�g�ԍ��ɂ� 1 ���� 65535 �܂ł̔ԍ���I��ŉ������B"
!insertmacro PFI_LANG_STRING PFI_LANG_OPTIONS_MBPOP3_3    "POP3 �|�[�g�ԍ���ύX���ĉ������B"

!insertmacro PFI_LANG_STRING PFI_LANG_OPTIONS_MBGUI_1     "�����ȁu���[�U�[�C���^�[�t�F�[�X�v�|�[�g�ԍ�:"
!insertmacro PFI_LANG_STRING PFI_LANG_OPTIONS_MBGUI_2     "�|�[�g�ԍ��ɂ� 1 ���� 65535 �܂ł̔ԍ���I��ŉ������B"
!insertmacro PFI_LANG_STRING PFI_LANG_OPTIONS_MBGUI_3     "�u���[�U�[�C���^�[�t�F�[�X�v�|�[�g�ԍ���ύX���ĉ������B"

!insertmacro PFI_LANG_STRING PFI_LANG_OPTIONS_MBDIFF_1    "POP3 �|�[�g�ԍ��ɂ́u���[�U�[�C���^�[�t�F�[�X�v�|�[�g�ԍ��ƈقȂ�ԍ���I��ŉ������B"
!insertmacro PFI_LANG_STRING PFI_LANG_OPTIONS_MBDIFF_2    "�|�[�g�ԍ���ύX���ĉ������B"

; Banner message displayed whilst uninstalling old version

!insertmacro PFI_LANG_STRING PFI_LANG_OPTIONS_BANNER_1     "���҂��������B"
!insertmacro PFI_LANG_STRING PFI_LANG_OPTIONS_BANNER_2     "���̏����ɂ͂��΂炭���Ԃ�������܂�..."

#--------------------------------------------------------------------------
# Standard MUI Page - Installing POPfile
#--------------------------------------------------------------------------

; Installation Progress Reports displayed above the progress bar

!insertmacro PFI_LANG_STRING PFI_LANG_INST_PROG_UPGRADE   "�A�b�v�O���[�h�C���X�g�[�����ǂ����`�F�b�N���Ă��܂�..."
!insertmacro PFI_LANG_STRING PFI_LANG_INST_PROG_CORE      "POPFile �̃R�A�t�@�C�����C���X�g�[����..."
!insertmacro PFI_LANG_STRING PFI_LANG_INST_PROG_PERL      "�ŏ��o�[�W������ Perl ���C���X�g�[����..."
!insertmacro PFI_LANG_STRING PFI_LANG_INST_PROG_SHORT     "POPFile �̃V���[�g�J�b�g���쐬��..."
!insertmacro PFI_LANG_STRING PFI_LANG_INST_PROG_FFCBACK   "corpus(�R�[�p�X�A�P��t�@�C��)�̃o�b�N�A�b�v���쐬���B���΂炭���҂�������..."
!insertmacro PFI_LANG_STRING PFI_LANG_INST_PROG_SKINS     "POPFile �̃X�L���t�@�C�����C���X�g�[����..."
!insertmacro PFI_LANG_STRING PFI_LANG_INST_PROG_LANGS     "POPFile UI ����t�@�C�����C���X�g�[����..."
!insertmacro PFI_LANG_STRING PFI_LANG_INST_PROG_ENDSEC    "�u���ցv���N���b�N���đ��s���ĉ������B"

; Installation Log Messages

!insertmacro PFI_LANG_STRING PFI_LANG_INST_LOG_1          "�ȑO�̃o�[�W������ POPFile ���V���b�g�_�E�����܂��B�|�[�g�ԍ�:"

; Message Box text strings

!insertmacro PFI_LANG_STRING PFI_LANG_MBSTPWDS_1          "�͈ȑO�ɃC���X�g�[�����ꂽ�t�@�C���ł��B"
!insertmacro PFI_LANG_STRING PFI_LANG_MBSTPWDS_2          "�A�b�v�f�[�g���Ă���낵���ł����H"
!insertmacro PFI_LANG_STRING PFI_LANG_MBSTPWDS_3          "�A�b�v�f�[�g����ɂ́uYes�v���N���b�N���ĉ������B(�Â��t�@�C���͎��̖��O�ŕۑ�����܂�:"
!insertmacro PFI_LANG_STRING PFI_LANG_MBSTPWDS_4          "�Â��t�@�C�����c���ɂ́uNo�v���N���b�N���ĉ������B(�V�����t�@�C���͎��̖��O�ŕۑ�����܂�:"

!insertmacro PFI_LANG_STRING PFI_LANG_MBCFGBK_1           "�t�@�C��"
!insertmacro PFI_LANG_STRING PFI_LANG_MBCFGBK_2           "�̃o�b�N�A�b�v�͊��ɑ��݂��܂��B"
!insertmacro PFI_LANG_STRING PFI_LANG_MBCFGBK_3           "�㏑�����Ă���낵���ł����H"
!insertmacro PFI_LANG_STRING PFI_LANG_MBCFGBK_4           "�㏑������ɂ́uYes�v�A�o�b�N�A�b�v���X�L�b�v����Ȃ�uNo�v���N���b�N���Ă��������B"

!insertmacro PFI_LANG_STRING PFI_LANG_MBMANSHUT_1         "Unable to shutdown POPFile automatically."
!insertmacro PFI_LANG_STRING PFI_LANG_MBMANSHUT_2         "Please shutdown POPFile manually now."
!insertmacro PFI_LANG_STRING PFI_LANG_MBMANSHUT_3         "When POPFile has been shutdown, click 'OK' to continue."

!insertmacro PFI_LANG_STRING PFI_LANG_MBFFCERR_1          "Error detected when the installer tried to backup the old corpus."

#--------------------------------------------------------------------------
# Custom Page - POPFile Classification Bucket Creation
#--------------------------------------------------------------------------

; Page Title and Sub-title displayed in the page header

!insertmacro PFI_LANG_STRING PFI_LANG_CBP_TITLE           "POPFile �̕��ޗp�̃o�P�c�쐬"
!insertmacro PFI_LANG_STRING PFI_LANG_CBP_SUBTITLE        "POPFile �̓��[���𕪗ނ���̂ɍŒ��̃o�P�c��K�v�Ƃ��܂��B"

; Text strings displayed on the custom page

!insertmacro PFI_LANG_STRING PFI_LANG_CBP_IO_INTRO        "�C���X�g�[���I������A�K�v�ɉ����ĊȒP�Ƀo�P�c�̐������O���ύX���邱�Ƃ��ł��܂��B\r\n\r\n�o�P�c�̖��O�ɂ̓A���t�@�x�b�g�̏������A0 ���� 9 �̐����A- �܂��� _ ����Ȃ�P����g�p���ĉ������B"
!insertmacro PFI_LANG_STRING PFI_LANG_CBP_IO_CREATE       "�ȉ��̃��X�g���I�Ԃ��A�K���Ȗ��O����͂��ĐV�����o�P�c���쐬���ĉ������B"
!insertmacro PFI_LANG_STRING PFI_LANG_CBP_IO_DELETE       "�������ȏ�̃o�P�c�����X�g���폜����ɂ́A�Ή�����u�폜�v�{�b�N�X�Ƀ`�F�b�N�����āu���s�v�{�^�����N���b�N���ĉ������B"
!insertmacro PFI_LANG_STRING PFI_LANG_CBP_IO_LISTHDR      "POPFile �Ɏg�p����o�P�c"
!insertmacro PFI_LANG_STRING PFI_LANG_CBP_IO_REMOVE       "�폜"
!insertmacro PFI_LANG_STRING PFI_LANG_CBP_IO_CONTINUE     "���s"

; Text strings used for status messages under the bucket list

!insertmacro PFI_LANG_STRING PFI_LANG_CBP_IO_MSG_1        "��������ȏ�̃o�P�c�͕K�v����܂���B"
!insertmacro PFI_LANG_STRING PFI_LANG_CBP_IO_MSG_2        "�Œ��̃o�P�c���쐬���ĉ������B"
!insertmacro PFI_LANG_STRING PFI_LANG_CBP_IO_MSG_3        "�Œ������̃o�P�c���K�v�ł��B"
!insertmacro PFI_LANG_STRING PFI_LANG_CBP_IO_MSG_4        "�C���X�g�[���[�́A"
!insertmacro PFI_LANG_STRING PFI_LANG_CBP_IO_MSG_5        "�ȏ�̃o�P�c����邱�Ƃ͂ł��܂���B"

; Message box text strings

!insertmacro PFI_LANG_STRING PFI_LANG_CBP_MBDUPERR_1      "�o�P�c"
!insertmacro PFI_LANG_STRING PFI_LANG_CBP_MBDUPERR_2      "�͊��ɍ쐬����Ă��܂��B"
!insertmacro PFI_LANG_STRING PFI_LANG_CBP_MBDUPERR_3      "�V�����o�P�c�ɂ͈Ⴄ���O��I��ŉ������B"

!insertmacro PFI_LANG_STRING PFI_LANG_CBP_MBMAXERR_1      "�C���X�g�[���[���쐬�ł���o�P�c��"
!insertmacro PFI_LANG_STRING PFI_LANG_CBP_MBMAXERR_2      "�ł��B"
!insertmacro PFI_LANG_STRING PFI_LANG_CBP_MBMAXERR_3      "�C���X�g�[���I����ɂ��o�P�c���쐬�ł��܂��B���݂̃o�P�c�̌�:"

!insertmacro PFI_LANG_STRING PFI_LANG_CBP_MBNAMERR_1      "�o�P�c��:"
!insertmacro PFI_LANG_STRING PFI_LANG_CBP_MBNAMERR_2      "�͖����Ȗ��O�ł��B"
!insertmacro PFI_LANG_STRING PFI_LANG_CBP_MBNAMERR_3      "�o�P�c�̖��O�ɂ� a ���� z �̏������A0 ���� 9 �̐����A- �܂��� _ ���g�p���ĉ������B"
!insertmacro PFI_LANG_STRING PFI_LANG_CBP_MBNAMERR_4      "�V�����o�P�c�ɂ͈Ⴄ���O��I��ŉ������B"

!insertmacro PFI_LANG_STRING PFI_LANG_CBP_MBCONTERR_1     "POPFile �̓��[���𕪗ނ���̂ɍŒ��̃o�P�c��K�v�Ƃ��܂��B"
!insertmacro PFI_LANG_STRING PFI_LANG_CBP_MBCONTERR_2     "�쐬����o�P�c�̖��O����͂��ĉ������B$\r$\n$\r$\n�h���b�v�_�E�����X�g�̗���I�����邩�A$\r$\n$\r$\n�K���Ȗ��O����͂��ĉ������B"
!insertmacro PFI_LANG_STRING PFI_LANG_CBP_MBCONTERR_3     "POPFile �̃C���X�g�[���𑱍s����ɂ́A�Œ��̃o�P�c���쐬���Ȃ���΂Ȃ�܂���B"

!insertmacro PFI_LANG_STRING PFI_LANG_CBP_MBDONE_1        "�̃o�P�c�� POPFile �p�ɍ쐬����܂����B"
!insertmacro PFI_LANG_STRING PFI_LANG_CBP_MBDONE_2        "�����̃o�P�c���g���悤 POPFile ��ݒ肵�Ă���낵���ł����H"
!insertmacro PFI_LANG_STRING PFI_LANG_CBP_MBDONE_3        "�o�P�c�̑I����ύX����ɂ́uNo�v���N���b�N���ĉ������B"

!insertmacro PFI_LANG_STRING PFI_LANG_CBP_MBMAKERR_1      "�C���X�g�[���[�͑I�����ꂽ�o�P�c��S�č쐬�ł��܂���ł����B�쐬�Ɏ��s�����o�P�c:"
!insertmacro PFI_LANG_STRING PFI_LANG_CBP_MBMAKERR_2      "�� / �I�����ꂽ�o�P�c:"
!insertmacro PFI_LANG_STRING PFI_LANG_CBP_MBMAKERR_3      "�� "
!insertmacro PFI_LANG_STRING PFI_LANG_CBP_MBMAKERR_4      "�쐬�ł��Ȃ������o�P�c�́APOPFile �̃C���X�g�[�����$\r$\n$\r$\n�u���[�U�[�C���^�[�t�F�[�X�v�R���g���[���p�l�����쐬�ł��܂��B"

#--------------------------------------------------------------------------
# Custom Page - Reconfigure Outlook Express
#--------------------------------------------------------------------------

; Page Title and Sub-title displayed in the page header

!insertmacro PFI_LANG_STRING PFI_LANG_OECFG_TITLE         "Outlook Express �̐ݒ�ύX"
!insertmacro PFI_LANG_STRING PFI_LANG_OECFG_SUBTITLE      "POPFile �� Outlook Express �̐ݒ��ύX���邱�Ƃ��ł��܂��B"

; Text displayed on the custom page

!insertmacro PFI_LANG_STRING PFI_LANG_OECFG_IO_INTRO      "POPFile �͈ȉ��� Outlook Express ���[���A�J�E���g�����o���܂����BPOPFile ���g�p�ł���悤�Ɏ����I�ɐݒ肷�邱�Ƃ��ł��܂��B"
!insertmacro PFI_LANG_STRING PFI_LANG_OECFG_IO_CHECKBOX   "POPFile ���g�p�ł���悤�ɂ��̃A�J�E���g�̐ݒ��ύX����B"
!insertmacro PFI_LANG_STRING PFI_LANG_OECFG_IO_EMAIL      "���[���A�h���X:"
!insertmacro PFI_LANG_STRING PFI_LANG_OECFG_IO_SERVER     "POP3 �T�[�o�[:"
!insertmacro PFI_LANG_STRING PFI_LANG_OECFG_IO_USERNAME   "POP3 ���[�U�[�l�[��:"
!insertmacro PFI_LANG_STRING PFI_LANG_OECFG_IO_RESTORE    "POPFile ���A���C���X�g�[������Ό��̐ݒ�ɖ߂�܂��B"

!insertmacro PFI_LANG_STRING PFI_LANG_OECFG_IO_LINK_1     "�A�J�E���g��"
!insertmacro PFI_LANG_STRING PFI_LANG_OECFG_IO_LINK_2     "�A�C�f���e�B�e�B"

#--------------------------------------------------------------------------
# Custom Page - POPFile can now be started
#--------------------------------------------------------------------------

; Page Title and Sub-title displayed in the page header

!insertmacro PFI_LANG_STRING PFI_LANG_LAUNCH_TITLE        "POPFile �̋N��"
!insertmacro PFI_LANG_STRING PFI_LANG_LAUNCH_SUBTITLE     "���[�U�[�C���^�[�t�F�[�X�� POPFile ���N�����Ȃ��Ǝg���܂���B"

; Text displayed on the custom page

!insertmacro PFI_LANG_STRING PFI_LANG_LAUNCH_IO_INTRO     "POPFile ���N�����܂����H"
!insertmacro PFI_LANG_STRING PFI_LANG_LAUNCH_IO_NO        "������(�u���[�U�[�C���^�[�t�F�[�X�v�� POPFile ���N�����Ȃ��Ǝg���܂���B)"
!insertmacro PFI_LANG_STRING PFI_LANG_LAUNCH_IO_DOSBOX    "POPFile ���N��(�R���\�[��)"
!insertmacro PFI_LANG_STRING PFI_LANG_LAUNCH_IO_BCKGRND   "POPFile ���o�b�N�O���E���h�ŋN��(�R���\�[���Ȃ�)"
!insertmacro PFI_LANG_STRING PFI_LANG_LAUNCH_IO_NOTE_1    "POPFile ���N������Έȉ��̕��@�Łu���[�U�[�C���^�[�t�F�[�X�v���g�p�ł��܂��B"
!insertmacro PFI_LANG_STRING PFI_LANG_LAUNCH_IO_NOTE_2    "(a) �V�X�e���g���C���� POPFile �A�C�R�����_�u���N���b�N���邩�A"
!insertmacro PFI_LANG_STRING PFI_LANG_LAUNCH_IO_NOTE_3    "(b) �X�^�[�g --> �v���O���� --> POPFile --> POPFile User Interface ��I�����܂��B"

; Banner message displayed whilst waiting for POPFile to start

!insertmacro PFI_LANG_STRING PFI_LANG_LAUNCH_BANNER_1     "POPFile ���N����"
!insertmacro PFI_LANG_STRING PFI_LANG_LAUNCH_BANNER_2     "���΂炭���҂���������..."

#--------------------------------------------------------------------------
# Custom Page - Flat file corpus needs to be converted to new format
#--------------------------------------------------------------------------

; Page Title and Sub-title displayed in the page header

!insertmacro PFI_LANG_STRING PFI_LANG_FLATFILE_TITLE       "POPFile Corpus Conversion"
!insertmacro PFI_LANG_STRING PFI_LANG_FLATFILE_SUBTITLE    "The existing corpus must be converted to work with this version of POPFile"

; Text displayed on the custom page

!insertmacro PFI_LANG_STRING PFI_LANG_FLATFILE_IO_NOTE_1   "POPFile will now be started in a console window to convert the existing corpus."
!insertmacro PFI_LANG_STRING PFI_LANG_FLATFILE_IO_NOTE_2   "THIS PROCESS MAY TAKE SEVERAL MINUTES (if the corpus is large)."
!insertmacro PFI_LANG_STRING PFI_LANG_FLATFILE_IO_NOTE_3   "WARNING"
!insertmacro PFI_LANG_STRING PFI_LANG_FLATFILE_IO_NOTE_4   "Do NOT close the POPFile console window!"
!insertmacro PFI_LANG_STRING PFI_LANG_FLATFILE_IO_NOTE_5   "When 'POPFile Engine v0.20.0 running' appears in the console window, this means"
!insertmacro PFI_LANG_STRING PFI_LANG_FLATFILE_IO_NOTE_6   "- POPFile is ready for use"
!insertmacro PFI_LANG_STRING PFI_LANG_FLATFILE_IO_NOTE_7   "- POPFile can be safely shutdown using the Start Menu"

#--------------------------------------------------------------------------
# Standard MUI Page - Uninstall POPFile
#--------------------------------------------------------------------------

; Uninstall Progress Reports displayed above the progress bar

!insertmacro PFI_LANG_UNSTRING PFI_LANG_PROGRESS_1        "POPFile ���V���b�g�_�E����..."
!insertmacro PFI_LANG_UNSTRING PFI_LANG_PROGRESS_2        "�u�X�^�[�g���j���[�v���� POPFile ���폜��..."
!insertmacro PFI_LANG_UNSTRING PFI_LANG_PROGRESS_3        "POPFile �̃R�A�t�@�C�����폜��..."
!insertmacro PFI_LANG_UNSTRING PFI_LANG_PROGRESS_4        "Outlook Express �̐ݒ�����ɖ߂��Ă��܂�..."
!insertmacro PFI_LANG_UNSTRING PFI_LANG_PROGRESS_5        "POPFile �̃X�L���t�@�C�����폜��..."
!insertmacro PFI_LANG_UNSTRING PFI_LANG_PROGRESS_6        "�ŏ��o�[�W������ Perl ���폜��..."

; Uninstall Log Messages

!insertmacro PFI_LANG_UNSTRING PFI_LANG_LOG_1             "POPFile ���V���b�g�_�E�����܂��B�|�[�g�ԍ�:"
!insertmacro PFI_LANG_UNSTRING PFI_LANG_LOG_2             "�I�[�v��"
!insertmacro PFI_LANG_UNSTRING PFI_LANG_LOG_3             "����"
!insertmacro PFI_LANG_UNSTRING PFI_LANG_LOG_4             "�N���[�Y"
!insertmacro PFI_LANG_UNSTRING PFI_LANG_LOG_5             "POPFile �f�B���N�g���ȉ��̑S�Ẵt�@�C�����폜��"
!insertmacro PFI_LANG_UNSTRING PFI_LANG_LOG_6             "����: POPFile �f�B���N�g���ȉ��̑S�Ẵt�@�C�����폜�ł��܂���ł����B"

; Message Box text strings

!insertmacro PFI_LANG_UNSTRING PFI_LANG_MBNOTFOUND_1      "POPFile �͎��̃f�B���N�g���ɃC���X�g�[������Ă��Ȃ��悤�ł�:"
!insertmacro PFI_LANG_UNSTRING PFI_LANG_MBNOTFOUND_2      "����ł����s���܂���(�����ł��܂���)�H"

!insertmacro PFI_LANG_UNSTRING PFI_LANG_ABORT_1           "�A���C���X�g�[���̓��[�U�[��蒆�~����܂���"

!insertmacro PFI_LANG_UNSTRING PFI_LANG_MBREMDIR_1        "POPFile �f�B���N�g���ȉ��̑S�Ẵt�@�C�����폜���܂����H$\r$\n$\r$\n(�c�������t�@�C��������� No ���N���b�N���ĉ������B)"

!insertmacro PFI_LANG_UNSTRING PFI_LANG_MBREMERR_1        "����"
!insertmacro PFI_LANG_UNSTRING PFI_LANG_MBREMERR_2        "�͍폜�ł��܂���ł����B"

#--------------------------------------------------------------------------
# Mark the end of the language data
#--------------------------------------------------------------------------

!undef PFI_LANG

#--------------------------------------------------------------------------
# End of 'Japanese-pfi.nsh'
#--------------------------------------------------------------------------
