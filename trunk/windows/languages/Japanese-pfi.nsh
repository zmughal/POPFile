#--------------------------------------------------------------------------
# Japanese-pfi.nsh
#
# This file contains the "Japanese" text strings used by the Windows installer
# for POPFile (includes customised versions of strings provided by NSIS and
# strings which are unique to POPFile).
#
# These strings are grouped according to the page/window where they are used
#
# Copyright (c) 2001-2004 John Graham-Cumming
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
#
# Translation created by: Junya Ishihara (UTF-8: E79FB3 E58E9F E6B7B3 E4B99F) (jishiha at users.sourceforge.net)
# Translation updated by: Junya Ishihara (UTF-8: E79FB3 E58E9F E6B7B3 E4B99F) (jishiha at users.sourceforge.net) 
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

#==========================================================================
# Customised versions of strings used on standard MUI pages
#==========================================================================

#--------------------------------------------------------------------------
# Standard MUI Page - Welcome
#
# The sequence \r\n\r\n inserts a blank line (note that the PFI_LANG_WELCOME_INFO_TEXT string
# should end with a \r\n\r\n$_CLICK sequence).
#--------------------------------------------------------------------------

!insertmacro PFI_LANG_STRING PFI_LANG_WELCOME_INFO_TEXT \
"���̃E�B�U�[�h�́APOPFile �̃C���X�g�[�����K�C�h���Ă����܂��B\r\n\r\n�Z�b�g�A�b�v���J�n����O�ɁA���̂��ׂẴA�v���P�[�V�������I�����邱�Ƃ𐄏����܂��B\r\n\r\n$_CLICK"

!insertmacro PFI_LANG_STRING PFI_LANG_WELCOME_ADMIN_TEXT \
"IMPORTANT NOTICE:\r\n\r\nThe current user does NOT have 'Administrator' rights.\r\n\r\nIf multi-user support is required, it is recommended that you cancel this installation and use an 'Administrator' account to install POPFile."

#--------------------------------------------------------------------------
# Standard MUI Page - Finish
#
# The PFI_LANG_FINISH_RUN_TEXT text should be a short phrase (not a long paragraph)
#--------------------------------------------------------------------------

!insertmacro PFI_LANG_STRING PFI_LANG_FINISH_RUN_TEXT \
"POPFile ���[�U�[�C���^�[�t�F�[�X���N��"

#==========================================================================
# Strings used for custom pages, message boxes and banners
#==========================================================================

#--------------------------------------------------------------------------
# General purpose banner text (also suitable for page titles/subtitles)
#--------------------------------------------------------------------------

!insertmacro PFI_LANG_STRING PFI_LANG_OPTIONS_BANNER_1    "���҂��������B"
!insertmacro PFI_LANG_STRING PFI_LANG_OPTIONS_BANNER_2    "���̏����ɂ͂��΂炭���Ԃ�������܂�..."

#--------------------------------------------------------------------------
# Message box warning that a previous installation has been found
#--------------------------------------------------------------------------

!insertmacro PFI_LANG_STRING PFI_LANG_DIRSELECT_MBWARN_1  "���̏ꏊ�ɈȑO�ɃC���X�g�[�����ꂽ POPFile ��������܂���:"
!insertmacro PFI_LANG_STRING PFI_LANG_DIRSELECT_MBWARN_2  "Do you want to upgrade it ?"

#--------------------------------------------------------------------------
# Startup message box offering to display the Release Notes
#--------------------------------------------------------------------------

!insertmacro PFI_LANG_STRING PFI_LANG_MBRELNOTES_1        "POPFile �̃����[�X�m�[�g��\�����܂����H"
!insertmacro PFI_LANG_STRING PFI_LANG_MBRELNOTES_2        "�A�b�v�O���[�h�̏ꍇ�́uYes�v�𐄏����܂��B(�A�b�v�O���[�h�̑O�Ƀo�b�N�A�b�v����邱�Ƃ𐄏����܂��B)"

#--------------------------------------------------------------------------
# Custom Page - Check Perl Requirements
#--------------------------------------------------------------------------

; Page Title and Sub-title displayed in the page header

!insertmacro PFI_LANG_STRING PFI_LANG_PERLREQ_TITLE       "Out-of-date System Components Detected"
!insertmacro PFI_LANG_STRING PFI_LANG_PERLREQ_SUBTITLE    "The version of Perl used by POPFile may not work properly on this system"

; Text strings displayed on the custom page

!insertmacro PFI_LANG_STRING PFI_LANG_PERLREQ_IO_TEXT_1   "When POPFile displays its User Interface, the current default browser will be used.\r\n\r\nPOPFile does not require a specific browser, it will work with almost any browser.\r\n\r\nPOPFile is written in Perl so a minimal version of Perl is installed which uses some components distributed with Internet Explorer."
!insertmacro PFI_LANG_STRING PFI_LANG_PERLREQ_IO_TEXT_2   "The installer has detected that this system has Internet Explorer"
!insertmacro PFI_LANG_STRING PFI_LANG_PERLREQ_IO_TEXT_3   "The version of Perl supplied with POPFile requires Internet Explorer 5.5 (or later).\r\n\r\nIt is recommended that this system is upgraded to use Internet Explorer 5.5 or a later version."

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

!insertmacro PFI_LANG_STRING PFI_LANG_OPTIONS_MBPOP3_1    "������ POP3 �|�[�g�ԍ�:"
!insertmacro PFI_LANG_STRING PFI_LANG_OPTIONS_MBPOP3_2    "�|�[�g�ԍ��ɂ� 1 ���� 65535 �܂ł̔ԍ���I��ŉ������B"
!insertmacro PFI_LANG_STRING PFI_LANG_OPTIONS_MBPOP3_3    "POP3 �|�[�g�ԍ���ύX���ĉ������B"

!insertmacro PFI_LANG_STRING PFI_LANG_OPTIONS_MBGUI_1     "�����ȁu���[�U�[�C���^�[�t�F�[�X�v�|�[�g�ԍ�:"
!insertmacro PFI_LANG_STRING PFI_LANG_OPTIONS_MBGUI_2     "�|�[�g�ԍ��ɂ� 1 ���� 65535 �܂ł̔ԍ���I��ŉ������B"
!insertmacro PFI_LANG_STRING PFI_LANG_OPTIONS_MBGUI_3     "�u���[�U�[�C���^�[�t�F�[�X�v�|�[�g�ԍ���ύX���ĉ������B"

!insertmacro PFI_LANG_STRING PFI_LANG_OPTIONS_MBDIFF_1    "POP3 �|�[�g�ԍ��ɂ́u���[�U�[�C���^�[�t�F�[�X�v�|�[�g�ԍ��ƈقȂ�ԍ���I��ŉ������B"
!insertmacro PFI_LANG_STRING PFI_LANG_OPTIONS_MBDIFF_2    "�|�[�g�ԍ���ύX���ĉ������B"

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
# Custom Page - Email Client Reconfiguration
#--------------------------------------------------------------------------

; Page Title and Sub-title displayed in the page header

!insertmacro PFI_LANG_STRING PFI_LANG_MAILCFG_TITLE       "Email Client Configuration"
!insertmacro PFI_LANG_STRING PFI_LANG_MAILCFG_SUBTITLE    "POPFile can reconfigure several email clients for you"

; Text displayed on the custom page

!insertmacro PFI_LANG_STRING PFI_LANG_MAILCFG_IO_TEXT_1   "Mail clients marked (*) can be reconfigured automatically, assuming simple accounts are used.\r\n\r\nIt is strongly recommended that accounts which require authentication are configured manually."
!insertmacro PFI_LANG_STRING PFI_LANG_MAILCFG_IO_TEXT_2   "IMPORTANT: PLEASE SHUT DOWN THE RECONFIGURABLE EMAIL CLIENTS NOW\r\n\r\nThis feature is still under development (e.g. some Outlook accounts may not be detected).\r\n\r\nPlease check that the reconfiguration was successful (before using the email client)."

!insertmacro PFI_LANG_STRING PFI_LANG_MAILCFG_IO_CANCEL   "Email client reconfiguration cancelled by user"

#--------------------------------------------------------------------------
# Text used on buttons to skip configuration of email clients
#--------------------------------------------------------------------------

!insertmacro PFI_LANG_STRING PFI_LANG_MAILCFG_IO_SKIPALL  "Skip All"
!insertmacro PFI_LANG_STRING PFI_LANG_MAILCFG_IO_SKIPONE  "Skip Client"

#--------------------------------------------------------------------------
# Message box warnings that an email client is still running
#--------------------------------------------------------------------------

!insertmacro PFI_LANG_STRING PFI_LANG_MBCLIENT_EXP        "WARNING: Outlook Express appears to be running !"
!insertmacro PFI_LANG_STRING PFI_LANG_MBCLIENT_OUT        "WARNING: Outlook appears to be running !"
!insertmacro PFI_LANG_STRING PFI_LANG_MBCLIENT_EUD        "WARNING: Eudora appears to be running !"

!insertmacro PFI_LANG_STRING PFI_LANG_MBCLIENT_STOP_1     "Please SHUT DOWN the email program then click 'Retry' to reconfigure it"
!insertmacro PFI_LANG_STRING PFI_LANG_MBCLIENT_STOP_2     "(You can click 'Ignore' to reconfigure it, but this is not recommended)"
!insertmacro PFI_LANG_STRING PFI_LANG_MBCLIENT_STOP_3     "Click 'Abort' to skip the reconfiguration of this email program"

!insertmacro PFI_LANG_STRING PFI_LANG_MBCLIENT_STOP_4     "Please SHUT DOWN the email program then click 'Retry' to restore the settings"
!insertmacro PFI_LANG_STRING PFI_LANG_MBCLIENT_STOP_5     "(You can click 'Ignore' to restore the settings, but this is not recommended)"
!insertmacro PFI_LANG_STRING PFI_LANG_MBCLIENT_STOP_6     "Click 'Abort' to skip the restoring of the original settings"

#--------------------------------------------------------------------------
# Custom Page - Reconfigure Outlook/Outlook Express
#--------------------------------------------------------------------------

; Page Title and Sub-title displayed in the page header

!insertmacro PFI_LANG_STRING PFI_LANG_EXPCFG_TITLE         "Outlook Express �̐ݒ�ύX"
!insertmacro PFI_LANG_STRING PFI_LANG_EXPCFG_SUBTITLE      "POPFile �� Outlook Express �̐ݒ��ύX���邱�Ƃ��ł��܂��B"

!insertmacro PFI_LANG_STRING PFI_LANG_OUTCFG_TITLE         "Reconfigure Outlook"
!insertmacro PFI_LANG_STRING PFI_LANG_OUTCFG_SUBTITLE      "POPFile can reconfigure Outlook for you"

; Text displayed on the custom page

!insertmacro PFI_LANG_STRING PFI_LANG_EXPCFG_IO_CANCELLED  "Outlook Express reconfiguration cancelled by user"
!insertmacro PFI_LANG_STRING PFI_LANG_OUTCFG_IO_CANCELLED  "Outlook reconfiguration cancelled by user"

!insertmacro PFI_LANG_STRING PFI_LANG_OOECFG_IO_BOXHDR     "accounts"
!insertmacro PFI_LANG_STRING PFI_LANG_OOECFG_IO_ACCOUNTHDR "Account"
!insertmacro PFI_LANG_STRING PFI_LANG_OOECFG_IO_EMAILHDR   "Email address"
!insertmacro PFI_LANG_STRING PFI_LANG_OOECFG_IO_SERVERHDR  "Server"
!insertmacro PFI_LANG_STRING PFI_LANG_OOECFG_IO_USRNAMEHDR "Username"
!insertmacro PFI_LANG_STRING PFI_LANG_OOECFG_IO_FOOTNOTE   "Tick box(es) to reconfigure account(s).\r\nIf you uninstall POPFile the original settings will be restored."

; Message Box to confirm changes to Outlook/Outlook Express account configuration

!insertmacro PFI_LANG_STRING PFI_LANG_EXPCFG_MBIDENTITY    "Outlook Express Identity :"
!insertmacro PFI_LANG_STRING PFI_LANG_EXPCFG_MBACCOUNT     "Outlook Express Account :"

!insertmacro PFI_LANG_STRING PFI_LANG_OUTCFG_MBIDENTITY    "Outlook User :"
!insertmacro PFI_LANG_STRING PFI_LANG_OUTCFG_MBACCOUNT     "Outlook Account :"

!insertmacro PFI_LANG_STRING PFI_LANG_OOECFG_MBEMAIL       "Email address :"
!insertmacro PFI_LANG_STRING PFI_LANG_OOECFG_MBSERVER      "POP3 server :"
!insertmacro PFI_LANG_STRING PFI_LANG_OOECFG_MBUSERNAME    "POP3 username :"
!insertmacro PFI_LANG_STRING PFI_LANG_OOECFG_MBOEPORT      "POP3 port :"
!insertmacro PFI_LANG_STRING PFI_LANG_OOECFG_MBOLDVALUE    "currently"
!insertmacro PFI_LANG_STRING PFI_LANG_OOECFG_MBQUESTION    "Reconfigure this account to work with POPFile ?"

; Title and Column headings for report/log files

!insertmacro PFI_LANG_STRING PFI_LANG_EXPCFG_LOG_BEFORE    "Outlook Express Settings before any changes were made"
!insertmacro PFI_LANG_STRING PFI_LANG_EXPCFG_LOG_AFTER     "Changes made to Outlook Express Settings"

!insertmacro PFI_LANG_STRING PFI_LANG_OUTCFG_LOG_BEFORE    "Outlook Settings before any changes were made"
!insertmacro PFI_LANG_STRING PFI_LANG_OUTCFG_LOG_AFTER     "Changes made to Outlook Settings"

!insertmacro PFI_LANG_STRING PFI_LANG_OOECFG_LOG_END       "(end)"

!insertmacro PFI_LANG_STRING PFI_LANG_EXPCFG_LOG_IDENTITY  "'IDENTITY'"
!insertmacro PFI_LANG_STRING PFI_LANG_OUTCFG_LOG_IDENTITY  "'OUTLOOK USER'"

!insertmacro PFI_LANG_STRING PFI_LANG_OOECFG_LOG_ACCOUNT   "'ACCOUNT'"

!insertmacro PFI_LANG_STRING PFI_LANG_OOECFG_LOG_EMAIL     "'EMAIL ADDRESS'"
!insertmacro PFI_LANG_STRING PFI_LANG_OOECFG_LOG_SERVER    "'POP3 SERVER'"
!insertmacro PFI_LANG_STRING PFI_LANG_OOECFG_LOG_USER      "'POP3 USERNAME'"
!insertmacro PFI_LANG_STRING PFI_LANG_OOECFG_LOG_PORT      "'POP3 PORT'"

!insertmacro PFI_LANG_STRING PFI_LANG_OOECFG_LOG_NEWSERVER "'NEW POP3 SERVER'"
!insertmacro PFI_LANG_STRING PFI_LANG_OOECFG_LOG_NEWUSER   "'NEW POP3 USERNAME'"
!insertmacro PFI_LANG_STRING PFI_LANG_OOECFG_LOG_NEWPORT   "'NEW POP3 PORT'"

#--------------------------------------------------------------------------
# Custom Page - Reconfigure Eudora
#--------------------------------------------------------------------------

; Page Title and Sub-title displayed in the page header

!insertmacro PFI_LANG_STRING PFI_LANG_EUCFG_TITLE         "Eudora �̐ݒ�ύX"
!insertmacro PFI_LANG_STRING PFI_LANG_EUCFG_SUBTITLE      "POPFile �� Eudora �̐ݒ��ύX���邱�Ƃ��ł��܂��B"

; Text displayed on the custom page

!insertmacro PFI_LANG_STRING PFI_LANG_EUCFG_IO_CANCELLED  "Eudora reconfiguration cancelled by user"

!insertmacro PFI_LANG_STRING PFI_LANG_EUCFG_IO_INTRO_1    "POPFile has detected the following Eudora personality"
!insertmacro PFI_LANG_STRING PFI_LANG_EUCFG_IO_INTRO_2    " and can automatically configure it to work with POPFile"
!insertmacro PFI_LANG_STRING PFI_LANG_EUCFG_IO_CHECKBOX   "Reconfigure this personality to work with POPFile"
!insertmacro PFI_LANG_STRING PFI_LANG_EUCFG_IO_DOMINANT   "<Dominant> personality"
!insertmacro PFI_LANG_STRING PFI_LANG_EUCFG_IO_PERSONA    "personality"
!insertmacro PFI_LANG_STRING PFI_LANG_EUCFG_IO_EMAIL      "���[���A�h���X:"
!insertmacro PFI_LANG_STRING PFI_LANG_EUCFG_IO_SERVER     "POP3 �T�[�o�[:"
!insertmacro PFI_LANG_STRING PFI_LANG_EUCFG_IO_USERNAME   "POP3 ���[�U�[�l�[��:"
!insertmacro PFI_LANG_STRING PFI_LANG_EUCFG_IO_POP3PORT   "POP3 port:"
!insertmacro PFI_LANG_STRING PFI_LANG_EUCFG_IO_RESTORE    "POPFile ���A���C���X�g�[������Ό��̐ݒ�ɖ߂�܂��B"

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
!insertmacro PFI_LANG_STRING PFI_LANG_FLATFILE_IO_NOTE_5   "When 'POPFile Engine v${C_POPFILE_MAJOR_VERSION}.${C_POPFILE_MINOR_VERSION}.${C_POPFILE_REVISION} running' appears in the console window, this means"
!insertmacro PFI_LANG_STRING PFI_LANG_FLATFILE_IO_NOTE_6   "- POPFile is ready for use"
!insertmacro PFI_LANG_STRING PFI_LANG_FLATFILE_IO_NOTE_7   "- POPFile can be safely shutdown using the Start Menu"
!insertmacro PFI_LANG_STRING PFI_LANG_FLATFILE_IO_NOTE_8   "Click Next to convert the corpus."

#--------------------------------------------------------------------------
# Standard MUI Page - Uninstall POPFile
#--------------------------------------------------------------------------

; Uninstall Progress Reports displayed above the progress bar

!insertmacro PFI_LANG_STRING PFI_LANG_UN_PROGRESS_1        "POPFile ���V���b�g�_�E����..."
!insertmacro PFI_LANG_STRING PFI_LANG_UN_PROGRESS_2        "�u�X�^�[�g���j���[�v���� POPFile ���폜��..."
!insertmacro PFI_LANG_STRING PFI_LANG_UN_PROGRESS_3        "POPFile �̃R�A�t�@�C�����폜��..."
!insertmacro PFI_LANG_STRING PFI_LANG_UN_PROGRESS_4        "Outlook Express �̐ݒ�����ɖ߂��Ă��܂�..."
!insertmacro PFI_LANG_STRING PFI_LANG_UN_PROGRESS_5        "POPFile �̃X�L���t�@�C�����폜��..."
!insertmacro PFI_LANG_STRING PFI_LANG_UN_PROGRESS_6        "�ŏ��o�[�W������ Perl ���폜��..."
!insertmacro PFI_LANG_STRING PFI_LANG_UN_PROGRESS_7        "Restoring Outlook settings..."
!insertmacro PFI_LANG_STRING PFI_LANG_UN_PROGRESS_8        "Restoring Eudora settings..."

; Uninstall Log Messages

!insertmacro PFI_LANG_STRING PFI_LANG_UN_LOG_1             "POPFile ���V���b�g�_�E�����܂��B�|�[�g�ԍ�:"
!insertmacro PFI_LANG_STRING PFI_LANG_UN_LOG_2             "�I�[�v��"
!insertmacro PFI_LANG_STRING PFI_LANG_UN_LOG_3             "����"
!insertmacro PFI_LANG_STRING PFI_LANG_UN_LOG_4             "�N���[�Y"
!insertmacro PFI_LANG_STRING PFI_LANG_UN_LOG_5             "POPFile �f�B���N�g���ȉ��̑S�Ẵt�@�C�����폜��"
!insertmacro PFI_LANG_STRING PFI_LANG_UN_LOG_6             "����: POPFile �f�B���N�g���ȉ��̑S�Ẵt�@�C�����폜�ł��܂���ł����B"
!insertmacro PFI_LANG_STRING PFI_LANG_UN_LOG_7             "Data problems"

; Message Box text strings

!insertmacro PFI_LANG_STRING PFI_LANG_UN_MBNOTFOUND_1      "POPFile �͎��̃f�B���N�g���ɃC���X�g�[������Ă��Ȃ��悤�ł�:"
!insertmacro PFI_LANG_STRING PFI_LANG_UN_MBNOTFOUND_2      "����ł����s���܂���(�����ł��܂���)�H"

!insertmacro PFI_LANG_STRING PFI_LANG_UN_ABORT_1           "�A���C���X�g�[���̓��[�U�[��蒆�~����܂���"

!insertmacro PFI_LANG_STRING PFI_LANG_UN_MBCLIENT_1        "'Outlook Express' problem !"
!insertmacro PFI_LANG_STRING PFI_LANG_UN_MBCLIENT_2        "'Outlook' problem !"
!insertmacro PFI_LANG_STRING PFI_LANG_UN_MBCLIENT_3        "'Eudora' problem !"

!insertmacro PFI_LANG_STRING PFI_LANG_UN_MBEMAIL_1         "Unable to restore some original settings"
!insertmacro PFI_LANG_STRING PFI_LANG_UN_MBEMAIL_2         "Display the error report ?"

!insertmacro PFI_LANG_STRING PFI_LANG_UN_MBRERUN_1         "Some email client settings have not been restored !"
!insertmacro PFI_LANG_STRING PFI_LANG_UN_MBRERUN_2         "(Details can be found in $INSTDIR folder)"
!insertmacro PFI_LANG_STRING PFI_LANG_UN_MBRERUN_3         "Click 'No' to ignore these errors and delete everything"
!insertmacro PFI_LANG_STRING PFI_LANG_UN_MBRERUN_4         "Click 'Yes' to keep this data (to allow another attempt later)"

!insertmacro PFI_LANG_STRING PFI_LANG_UN_MBREMDIR_1        "POPFile �f�B���N�g���ȉ��̑S�Ẵt�@�C�����폜���܂����H$\r$\n$\r$\n(�c�������t�@�C��������� No ���N���b�N���ĉ������B)"

!insertmacro PFI_LANG_STRING PFI_LANG_UN_MBREMERR_1        "����"
!insertmacro PFI_LANG_STRING PFI_LANG_UN_MBREMERR_2        "�͍폜�ł��܂���ł����B"

#--------------------------------------------------------------------------
# Mark the end of the language data
#--------------------------------------------------------------------------

!undef PFI_LANG

#--------------------------------------------------------------------------
# End of 'Japanese-pfi.nsh'
#--------------------------------------------------------------------------
