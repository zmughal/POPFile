#--------------------------------------------------------------------------
# Japanese-pfi.nsh
#
# This file contains the "Japanese" text strings used by the Windows installer
# for POPFile (includes customised versions of strings provided by NSIS and
# strings which are unique to POPFile).
#
# These strings are grouped according to the page/window where they are used
#
# Copyright (c) 2003-2004 John Graham-Cumming
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
#   (1) The sequence  ${MB_NL}          inserts a newline
#   (2) The sequence  ${MB_NL}${MB_NL}  inserts a blank line
#
# (the 'PFI_LANG_CBP_MBCONTERR_2' message box string which is listed under the heading
# 'Custom Page - POPFile Classification Bucket Creation' includes some examples)
#--------------------------------------------------------------------------
# String Formatting (applies to PFI_LANG_*_IO_ text used for custom pages):
#
#   (1) The sequence  ${IO_NL}          inserts a newline
#   (2) The sequence  ${IO_NL}${IO_NL}  inserts a blank line
#
# (the 'PFI_LANG_CBP_IO_INTRO' custom page string which is listed under the heading
# 'Custom Page - POPFile Classification Bucket Creation' includes some examples)
#--------------------------------------------------------------------------
# Some strings will be customised at run-time using data held in Global User Variables.
# These variables will have names which start with '$G_', e.g. $G_PLS_FIELD_1
#--------------------------------------------------------------------------

!ifndef PFI_VERBOSE
  !verbose 3
!endif

#--------------------------------------------------------------------------
# Mark the start of the language data
#--------------------------------------------------------------------------

!define PFI_LANG  "JAPANESE"

#--------------------------------------------------------------------------
# Symbols used to avoid confusion over where the line breaks occur.
# (normally these symbols will be defined before this file is 'included')
#
# ${IO_NL} is used for InstallOptions-style 'new line' sequences.
# ${MB_NL} is used for MessageBox-style 'new line' sequences.
#--------------------------------------------------------------------------

!ifndef IO_NL
  !define IO_NL     "\r\n"
!endif

!ifndef MB_NL
  !define MB_NL     "$\r$\n"
!endif

#==========================================================================
# Customised versions of strings used on standard MUI pages
#==========================================================================

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; Used by the main POPFile installer (main script: installer.nsi)
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

#--------------------------------------------------------------------------
# Standard MUI Page - Welcome (for the main POPFile installer)
#
# The sequence ${IO_NL}${IO_NL} inserts a blank line (note that the PFI_LANG_WELCOME_INFO_TEXT string
# should end with a ${IO_NL}${IO_NL}$_CLICK sequence).
#--------------------------------------------------------------------------

!insertmacro PFI_LANG_STRING PFI_LANG_WELCOME_INFO_TEXT    "���̃E�B�U�[�h�́APOPFile �̃C���X�g�[�����K�C�h���Ă����܂��B${IO_NL}${IO_NL}�Z�b�g�A�b�v���J�n����O�ɁA���̂��ׂẴA�v���P�[�V�������I�����邱�Ƃ𐄏����܂��B${IO_NL}${IO_NL}$_CLICK"
!insertmacro PFI_LANG_STRING PFI_LANG_WELCOME_ADMIN_TEXT   "�d�v:${IO_NL}${IO_NL}���݂̃��[�U�[�� Administrator �����������Ă��܂���B${IO_NL}${IO_NL}�����}���`���[�U�[�T�|�[�g���K�v�Ȃ�A�C���X�g�[�����L�����Z���� Administrator �A�J�E���g�� POPFile ���C���X�g�[�����邱�Ƃ������߂��܂��B"

#--------------------------------------------------------------------------
# Standard MUI Page - Directory Page (for the main POPFile installer)
#--------------------------------------------------------------------------

!insertmacro PFI_LANG_STRING PFI_LANG_ROOTDIR_TITLE        "�v���O�����t�@�C���̃C���X�g�[����"
!insertmacro PFI_LANG_STRING PFI_LANG_ROOTDIR_TEXT_DESTN   "POPFile �̃C���X�g�[����t�H���_���w�肵�Ă��������B"

#--------------------------------------------------------------------------
# Standard MUI Page - Installation Page (for the main POPFile installer)
#--------------------------------------------------------------------------

!insertmacro PFI_LANG_STRING PFI_LANG_INSTFINISH_TITLE     "�v���O�����t�@�C�����C���X�g�[������܂����B"
!insertmacro PFI_LANG_STRING PFI_LANG_INSTFINISH_SUBTITLE  "���� ${C_PFI_PRODUCT} ���g�p���邽�߂̐ݒ���s���܂��B"

#--------------------------------------------------------------------------
# Standard MUI Page - Finish (for the main POPFile installer)
#
# The PFI_LANG_FINISH_RUN_TEXT text should be a short phrase (not a long paragraph)
#--------------------------------------------------------------------------

!insertmacro PFI_LANG_STRING PFI_LANG_FINISH_RUN_TEXT      "POPFile ���[�U�[�C���^�[�t�F�[�X���N��"


;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; Used by 'Monitor Corpus Conversion' utility (main script: MonitorCC.nsi)
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

#--------------------------------------------------------------------------
# Standard MUI Page - Installation Page (for the 'Monitor Corpus Conversion' utility)
#--------------------------------------------------------------------------

!insertmacro PFI_LANG_STRING PFI_LANG_CONVERT_TITLE        "POPFile Corpus(�R�[�p�X�A�P��t�@�C��)�̕ϊ�"
!insertmacro PFI_LANG_STRING PFI_LANG_CONVERT_SUBTITLE     "�C���X�g�[�����悤�Ƃ��Ă���o�[�W������ POPFile �Ɠ��삷�邽�߂ɂ́A������ corpus ��ϊ�����K�v������܂��B"

!insertmacro PFI_LANG_STRING PFI_LANG_ENDCONVERT_TITLE     "POPFile Corpus �̕ϊ��͊������܂����B"
!insertmacro PFI_LANG_STRING PFI_LANG_ENDCONVERT_SUBTITLE  "���s����ɂ́u����v���N���b�N���ĉ������B"

!insertmacro PFI_LANG_STRING PFI_LANG_BADCONVERT_TITLE     "POPFile Corpus �̕ϊ��Ɏ��s���܂����B"
!insertmacro PFI_LANG_STRING PFI_LANG_BADCONVERT_SUBTITLE  "���s����ɂ́u�L�����Z���v���N���b�N���ĉ������B"


;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; Used by 'Add POPFile User' wizard (main script: adduser.nsi)
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

#--------------------------------------------------------------------------
# Standard MUI Page - Welcome (for the 'Add POPFile User' wizard)
#
# The sequence ${IO_NL}${IO_NL} inserts a blank line (note that the PFI_LANG_ADDUSER_INFO_TEXT string
# should end with a ${IO_NL}${IO_NL}$_CLICK sequence).
#--------------------------------------------------------------------------

!insertmacro PFI_LANG_STRING PFI_LANG_ADDUSER_INFO_TEXT    "���̃E�B�U�[�h�� '$G_WINUSERNAME' ���[�U�[�̂��߂� POPFile �̐ݒ���K�C�h���Ă����܂��B${IO_NL}${IO_NL}���s����O�ɑ��̑S�ẴA�v���P�[�V��������邱�Ƃ𐄏����܂��B${IO_NL}${IO_NL}$_CLICK"

#--------------------------------------------------------------------------
# Standard MUI Page - Directory Page (for the 'Add POPFile User' wizard)
#--------------------------------------------------------------------------

!insertmacro PFI_LANG_STRING PFI_LANG_USERDIR_TITLE        "'$G_WINUSERNAME' �̂��߂� POPFile �f�[�^�̕ۑ���"
!insertmacro PFI_LANG_STRING PFI_LANG_USERDIR_SUBTITLE     "'$G_WINUSERNAME' �̂��߂� POPFile �f�[�^��ۑ�����t�H���_��I��ł��������B"
!insertmacro PFI_LANG_STRING PFI_LANG_USERDIR_TEXT_TOP     "���̃o�[�W������ POPFile �͊e���[�U�[���ƂɈقȂ�f�[�^�t�@�C�����g�p���܂��B${MB_NL}${MB_NL}�Z�b�g�A�b�v�͎��̃t�H���_�� '$G_WINUSERNAME' ���[�U�[�p�� POPFile �f�[�^�̂��߂Ɏg�p���܂��B�ʂ̃t�H���_���g�p����ɂ́A[�Q��] �������đ��̃t�H���_��I��ŉ������B $_CLICK"
!insertmacro PFI_LANG_STRING PFI_LANG_USERDIR_TEXT_DESTN   "'$G_WINUSERNAME' �� POPFile �f�[�^�̕ۑ���"

#--------------------------------------------------------------------------
# Standard MUI Page - Installation Page (for the 'Add POPFile User' wizard)
#--------------------------------------------------------------------------

!insertmacro PFI_LANG_STRING PFI_LANG_ADDUSER_TITLE        "'$G_WINUSERNAME' ���[�U�[�̂��߂� POPFile �̐ݒ�"
!insertmacro PFI_LANG_STRING PFI_LANG_ADDUSER_SUBTITLE     "POPFile �ݒ�t�@�C�������̃��[�U�[�p�ɃA�b�v�f�[�g���܂��B���΂炭���҂��������B"

#--------------------------------------------------------------------------
# Standard MUI Page - Finish (for the 'Add POPFile User' wizard)
#--------------------------------------------------------------------------

!insertmacro PFI_LANG_STRING PFI_LANG_ADDUSER_FINISH_INFO "'$G_WINUSERNAME' ���[�U�[�p�� POPFile �̐ݒ��Ƃ͊������܂����B${IO_NL}${IO_NL}���� ���N���b�N���ăE�B�U�[�h����ĉ������B"

#--------------------------------------------------------------------------
# Standard MUI Page - Uninstall Confirmation Page (for the 'Add POPFile User' wizard)
#--------------------------------------------------------------------------

!insertmacro PFI_LANG_STRING PFI_LANG_REMUSER_TITLE        "'$G_WINUSERNAME' ���[�U�[�̂��߂� POPFile �f�[�^�̃A���C���X�g�[��"
!insertmacro PFI_LANG_STRING PFI_LANG_REMUSER_SUBTITLE     "���̃��[�U�[�p POPFile �ݒ�f�[�^���R���s���[�^�[����폜���܂��B"

!insertmacro PFI_LANG_STRING PFI_LANG_REMUSER_TEXT_TOP     "'$G_WINUSERNAME' ���[�U�[�p POPFile �ݒ�f�[�^�����̃t�H���_����폜���܂��B $_CLICK"

#--------------------------------------------------------------------------
# Standard MUI Page - Uninstallation Page (for the 'Add POPFile User' wizard)
#--------------------------------------------------------------------------

!insertmacro PFI_LANG_STRING PFI_LANG_REMOVING_TITLE       "'$G_WINUSERNAME' ���[�U�[�p POPFile �f�[�^�̍폜"
!insertmacro PFI_LANG_STRING PFI_LANG_REMOVING_SUBTITLE    "���̃��[�U�[�� POPFile �ݒ�t�@�C�����폜�����܂ł��΂炭���҂��������B"


#==========================================================================
# Strings used for custom pages, message boxes and banners
#==========================================================================

#--------------------------------------------------------------------------
# General purpose banner text (also suitable for page titles/subtitles)
#--------------------------------------------------------------------------

!insertmacro PFI_LANG_STRING PFI_LANG_BE_PATIENT           "���҂��������B"
!insertmacro PFI_LANG_STRING PFI_LANG_TAKE_A_FEW_SECONDS   "���̏����ɂ͂��΂炭���Ԃ�������܂�..."

#--------------------------------------------------------------------------
# Message displayed when 'Add User' does not seem to be part of the current version
#--------------------------------------------------------------------------

!insertmacro PFI_LANG_STRING PFI_LANG_COMPAT_NOTFOUND      "�G���[: ${C_PFI_PRODUCT} �̌݊����̂���o�[�W������������܂���I"

#--------------------------------------------------------------------------
# Message displayed when installer exits because another copy is running
#--------------------------------------------------------------------------

!insertmacro PFI_LANG_STRING PFI_LANG_INSTALLER_MUTEX      "�ʂ� POPFile �C���X�g�[���[�����s���ł��I"

#--------------------------------------------------------------------------
# Message box warnings used when verifying the installation folder chosen by user
#--------------------------------------------------------------------------

!insertmacro PFI_LANG_STRING PFI_LANG_DIRSELECT_MBWARN_1   "���̏ꏊ�ɈȑO�ɃC���X�g�[�����ꂽ POPFile ��������܂���:"
!insertmacro PFI_LANG_STRING PFI_LANG_DIRSELECT_MBWARN_2   "�A�b�v�O���[�h���܂����H"
!insertmacro PFI_LANG_STRING PFI_LANG_DIRSELECT_MBWARN_3   "���̏ꏊ�ɈȑO�̐ݒ�f�[�^��������܂���:"
!insertmacro PFI_LANG_STRING PFI_LANG_DIRSELECT_MBWARN_4   "���X�g�A���ꂽ�ݒ�f�[�^��������܂����B"
!insertmacro PFI_LANG_STRING PFI_LANG_DIRSELECT_MBWARN_5   "���X�g�A���ꂽ�f�[�^���g�p���܂����H"

#--------------------------------------------------------------------------
# Startup message box offering to display the Release Notes
#--------------------------------------------------------------------------

!insertmacro PFI_LANG_STRING PFI_LANG_MBRELNOTES_1         "POPFile �̃����[�X�m�[�g��\�����܂����H"
!insertmacro PFI_LANG_STRING PFI_LANG_MBRELNOTES_2         "�A�b�v�O���[�h�̏ꍇ�́uYes�v�𐄏����܂��B(�A�b�v�O���[�h�̑O�Ƀo�b�N�A�b�v����邱�Ƃ𐄏����܂��B)"

#--------------------------------------------------------------------------
# Custom Page - Check Perl Requirements
#--------------------------------------------------------------------------

; Page Title and Sub-title displayed in the page header

!insertmacro PFI_LANG_STRING PFI_LANG_PERLREQ_TITLE        "�����V�X�e���R���|�[�l���g�����o����܂����B"

; Text strings displayed on the custom page

!insertmacro PFI_LANG_STRING PFI_LANG_PERLREQ_IO_TEXT_1    "POPFile ���[�U�[�C���^�[�t�F�[�X(�R���g���[���Z���^�[)�̓f�t�H���g�u���E�U�[���g�p���܂��B${IO_NL}${IO_NL}"
!insertmacro PFI_LANG_STRING PFI_LANG_PERLREQ_IO_TEXT_2    "POPFile �͓���̃u���E�U�[��K�v�Ƃ����A�قƂ�ǂǂ̃u���E�U�[�Ƃ����삵�܂��B${IO_NL}${IO_NL}"
!insertmacro PFI_LANG_STRING PFI_LANG_PERLREQ_IO_TEXT_3    "�ŏ��o�[�W������ Perl ���C���X�g�[�����܂�(POPFile �� Perl �ŏ�����Ă��܂�)�B${IO_NL}${IO_NL}"
!insertmacro PFI_LANG_STRING PFI_LANG_PERLREQ_IO_TEXT_4    "POPFile �ɕt������ Perl �̓C���^�[�l�b�g�G�N�X�v���[���[ 5.5(���邢�͂���ȏ�)�̃R���|�[�l���g�̈ꕔ��K�v�Ƃ��܂��B"
!insertmacro PFI_LANG_STRING PFI_LANG_PERLREQ_IO_TEXT_5    "�C���X�g�[���[�̓C���^�[�l�b�g�G�N�X�v���[���[�����o���܂����B"
!insertmacro PFI_LANG_STRING PFI_LANG_PERLREQ_IO_TEXT_6    "POPFile �̂������̋@�\�͐���ɓ��삵�Ȃ���������܂���B${IO_NL}${IO_NL}"
!insertmacro PFI_LANG_STRING PFI_LANG_PERLREQ_IO_TEXT_7    "POPFile �Ŗ�肪�N�������ꍇ�A�V�����o�[�W�����̃C���^�[�l�b�g�G�N�X�v���[���[�ɃA�b�v�O���[�h���邱�Ƃ𐄏����܂��B"

#--------------------------------------------------------------------------
# Standard MUI Page - Choose Components
#--------------------------------------------------------------------------

!insertmacro PFI_LANG_STRING DESC_SecPOPFile               "POPFile �̃R�A�t�@�C�����C���X�g�[�����܂��B�ŏ��o�[�W������ Perl ���܂݂܂��B"
!insertmacro PFI_LANG_STRING DESC_SecSkins                 "POPFile ���[�U�[�C���^�[�t�F�[�X�̃f�U�C����ς��邱�Ƃ��ł��� POPFile �X�L�����C���X�g�[�����܂��B"
!insertmacro PFI_LANG_STRING DESC_SecLangs                 "POPFile UI �̉p��ȊO�̃o�[�W�������C���X�g�[�����܂��B"

!insertmacro PFI_LANG_STRING DESC_SubSecOptional           "POPFile �ǉ��R���|�[�l���g (�㋉���[�U�[�p)"
!insertmacro PFI_LANG_STRING DESC_SecIMAP                  "POPFile IMAP ���W���[�����C���X�g�[�����܂��B"
!insertmacro PFI_LANG_STRING DESC_SecNNTP                  "POPFile NNTP �v���L�V�[���C���X�g�[�����܂��B"
!insertmacro PFI_LANG_STRING DESC_SecSMTP                  "POPFile SMTP �v���L�V�[���C���X�g�[�����܂��B"
!insertmacro PFI_LANG_STRING DESC_SecSOCKS                 "POPFile �v���L�V�[�� SOCKS ���g����悤�ɂ��邽�߂� Perl �ǉ��R���|�[�l���g���C���X�g�[�����܂��B"
!insertmacro PFI_LANG_STRING DESC_SecXMLRPC                "(POPFile API �ւ̃A�N�Z�X���\�ɂ���)POPFile XMLRPC ���W���[���ƕK�v�� Perl ���W���[�����C���X�g�[�����܂��B"

; Text strings used when user has NOT selected a component found in the existing installation

!insertmacro PFI_LANG_STRING MBCOMPONENT_PROB_1            "$G_PLS_FIELD_1 �R���|�[�l���g���A�b�v�O���[�h���܂����H"
!insertmacro PFI_LANG_STRING MBCOMPONENT_PROB_2            "(�Â��o�[�W������ POPFile �R���|�[�l���g���g���Ă���Ɩ�肪�N���邱�Ƃ�����܂��B)"

#--------------------------------------------------------------------------
# Custom Page - POPFile Installation Options
#--------------------------------------------------------------------------

; Page Title and Sub-title displayed in the page header

!insertmacro PFI_LANG_STRING PFI_LANG_OPTIONS_TITLE        "POPFile �C���X�g�[���I�v�V����"
!insertmacro PFI_LANG_STRING PFI_LANG_OPTIONS_SUBTITLE     "�����̃I�v�V�����͕K�v�łȂ�����ύX���Ȃ��ŉ������B"

; Text strings displayed on the custom page

!insertmacro PFI_LANG_STRING PFI_LANG_OPTIONS_IO_POP3      "POP3 �ڑ��Ɏg�p����f�t�H���g�|�[�g�ԍ���I��ŉ������B(�����l:110)"
!insertmacro PFI_LANG_STRING PFI_LANG_OPTIONS_IO_GUI       "���[�U�[�C���^�[�t�F�[�X�Ɏg�p����|�[�g�ԍ���I��ŉ������B(�����l:8080)"
!insertmacro PFI_LANG_STRING PFI_LANG_OPTIONS_IO_STARTUP   "Windows �̋N������ POPFile �������I�ɋN������B(�o�b�N�O���E���h�ŋN��)"
!insertmacro PFI_LANG_STRING PFI_LANG_OPTIONS_IO_WARNING   "�d�v�Ȍx��"
!insertmacro PFI_LANG_STRING PFI_LANG_OPTIONS_IO_MESSAGE   "POPFile �̃A�b�v�O���[�h�̏ꍇ --- �C���X�g�[���[�͌��݂̃o�[�W�������V���b�g�_�E�����܂��B"

; Message Boxes used when validating user's selections

!insertmacro PFI_LANG_STRING PFI_LANG_OPTIONS_MBPOP3_1     "������ POP3 �|�[�g�ԍ�:"
!insertmacro PFI_LANG_STRING PFI_LANG_OPTIONS_MBPOP3_2     "�|�[�g�ԍ��ɂ� 1 ���� 65535 �܂ł̔ԍ���I��ŉ������B"
!insertmacro PFI_LANG_STRING PFI_LANG_OPTIONS_MBPOP3_3     "POP3 �|�[�g�ԍ���ύX���ĉ������B"

!insertmacro PFI_LANG_STRING PFI_LANG_OPTIONS_MBGUI_1      "�����ȃ��[�U�[�C���^�[�t�F�[�X�|�[�g�ԍ�:"
!insertmacro PFI_LANG_STRING PFI_LANG_OPTIONS_MBGUI_2      "�|�[�g�ԍ��ɂ� 1 ���� 65535 �܂ł̔ԍ���I��ŉ������B"
!insertmacro PFI_LANG_STRING PFI_LANG_OPTIONS_MBGUI_3      "���[�U�[�C���^�[�t�F�[�X�̃|�[�g�ԍ���ύX���ĉ������B"

!insertmacro PFI_LANG_STRING PFI_LANG_OPTIONS_MBDIFF_1     "POP3 �|�[�g�ԍ��ɂ̓��[�U�[�C���^�[�t�F�[�X�̃|�[�g�ԍ��ƈقȂ�ԍ���I��ŉ������B"
!insertmacro PFI_LANG_STRING PFI_LANG_OPTIONS_MBDIFF_2     "�|�[�g�ԍ���ύX���ĉ������B"

#--------------------------------------------------------------------------
# Standard MUI Page - Installing POPFile
#--------------------------------------------------------------------------

; When upgrading an existing installation, change the normal "Install" button to "Upgrade"
; (the page with the "Install" button will vary depending upon the page order in the script)

!insertmacro PFI_LANG_STRING PFI_LANG_INST_BTN_UPGRADE     "�A�b�v�O���[�h"

; When resetting POPFile to use newly restored 'User Data', change "Install" button to "Restore"

!insertmacro PFI_LANG_STRING PFI_LANG_INST_BTN_RESTORE     "���X�g�A"

; Installation Progress Reports displayed above the progress bar

!insertmacro PFI_LANG_STRING PFI_LANG_INST_PROG_UPGRADE    "�A�b�v�O���[�h�C���X�g�[�����ǂ����`�F�b�N���Ă��܂�..."
!insertmacro PFI_LANG_STRING PFI_LANG_INST_PROG_CORE       "POPFile �̃R�A�t�@�C�����C���X�g�[����..."
!insertmacro PFI_LANG_STRING PFI_LANG_INST_PROG_PERL       "�ŏ��o�[�W������ Perl ���C���X�g�[����..."
!insertmacro PFI_LANG_STRING PFI_LANG_INST_PROG_SHORT      "POPFile �̃V���[�g�J�b�g���쐬��..."
!insertmacro PFI_LANG_STRING PFI_LANG_INST_PROG_CORPUS     "corpus(�R�[�p�X�A�P��t�@�C��)�̃o�b�N�A�b�v���쐬���B���΂炭���҂�������..."
!insertmacro PFI_LANG_STRING PFI_LANG_INST_PROG_SKINS      "POPFile �̃X�L���t�@�C�����C���X�g�[����..."
!insertmacro PFI_LANG_STRING PFI_LANG_INST_PROG_LANGS      "POPFile UI ����t�@�C�����C���X�g�[����..."
!insertmacro PFI_LANG_STRING PFI_LANG_INST_PROG_XMLRPC     "POPFile XMLRPC �t�@�C�����C���X�g�[����..."
!insertmacro PFI_LANG_STRING PFI_LANG_INST_PROG_REGSET     "���W�X�g�����Ɗ��ϐ����X�V��..."
!insertmacro PFI_LANG_STRING PFI_LANG_INST_PROG_SQLBACKUP  "�Â� SQLite �f�[�^�x�[�X���o�b�N�A�b�v��..."
!insertmacro PFI_LANG_STRING PFI_LANG_INST_PROG_FINDCORPUS "�t���b�g�t�@�C���܂��� BerkeleyDB �̃R�[�p�X��T���Ă��܂�..."
!insertmacro PFI_LANG_STRING PFI_LANG_INST_PROG_MAKEBAT    "'pfi-run.bat' �o�b�`�t�@�C���𐶐���..."
!insertmacro PFI_LANG_STRING PFI_LANG_INST_PROG_ENDSEC     "�u���ցv���N���b�N���đ��s���ĉ������B"

; Installation Log Messages

!insertmacro PFI_LANG_STRING PFI_LANG_INST_LOG_SHUTDOWN    "Shutting down previous version of POPFile using port"

; Message Box text strings

!insertmacro PFI_LANG_STRING PFI_LANG_MBSTPWDS_1           "�͈ȑO�ɃC���X�g�[�����ꂽ�t�@�C���ł��B"
!insertmacro PFI_LANG_STRING PFI_LANG_MBSTPWDS_2           "�A�b�v�f�[�g���Ă���낵���ł����H"
!insertmacro PFI_LANG_STRING PFI_LANG_MBSTPWDS_3           "�A�b�v�f�[�g����ɂ́uYes�v���N���b�N���ĉ������B(�Â��t�@�C���͎��̖��O�ŕۑ�����܂�:"
!insertmacro PFI_LANG_STRING PFI_LANG_MBSTPWDS_4           "�Â��t�@�C�����c���ɂ́uNo�v���N���b�N���ĉ������B(�V�����t�@�C���͎��̖��O�ŕۑ�����܂�:"

!insertmacro PFI_LANG_STRING PFI_LANG_MBMANSHUT_1          "$G_PLS_FIELD_1 �������I�ɃV���b�g�_�E�����邱�Ƃ��ł��܂���ł����B"
!insertmacro PFI_LANG_STRING PFI_LANG_MBMANSHUT_2          "$G_PLS_FIELD_1 ���蓮�ŃV���b�g�_�E�����ĉ������B"
!insertmacro PFI_LANG_STRING PFI_LANG_MBMANSHUT_3          "$G_PLS_FIELD_1 ���V���b�g�_�E��������A'OK' ���N���b�N���đ��s���ĉ������B"

!insertmacro PFI_LANG_STRING PFI_LANG_MBCORPUS_1           "�Â� corpus ���o�b�N�A�b�v���ɃG���[��������܂����B"

#--------------------------------------------------------------------------
# Custom Page - POPFile Classification Bucket Creation
#--------------------------------------------------------------------------

; POPFile requires at least TWO buckets in order to work properly. PFI_LANG_CBP_DEFAULT_BUCKETS
; defines the default buckets and PFI_LANG_CBP_SUGGESTED_NAMES defines a list of suggested names
; to help the user get started with POPFile. Both lists use the | character as a name separator.

; Bucket names can only use the characters abcdefghijklmnopqrstuvwxyz_-0123456789
; (any names which contain invalid characters will be ignored by the installer)

; Empty lists ("") are allowed (but are not very user-friendly)

!insertmacro PFI_LANG_STRING PFI_LANG_CBP_DEFAULT_BUCKETS  "spam|personal|work|other"
!insertmacro PFI_LANG_STRING PFI_LANG_CBP_SUGGESTED_NAMES  "admin|business|computers|family|financial|general|hobby|inbox|junk|list-admin|miscellaneous|not_spam|other|personal|recreation|school|security|shopping|spam|travel|work"

; Page Title and Sub-title displayed in the page header

!insertmacro PFI_LANG_STRING PFI_LANG_CBP_TITLE            "POPFile �̕��ޗp�̃o�P�c�쐬"
!insertmacro PFI_LANG_STRING PFI_LANG_CBP_SUBTITLE         "POPFile �̓��[���𕪗ނ���̂ɍŒ��̃o�P�c��K�v�Ƃ��܂��B"

; Text strings displayed on the custom page

!insertmacro PFI_LANG_STRING PFI_LANG_CBP_IO_INTRO         "�C���X�g�[���I������A�K�v�ɉ����ĊȒP�Ƀo�P�c�̐������O���ύX���邱�Ƃ��ł��܂��B${IO_NL}${IO_NL}�o�P�c�̖��O�ɂ̓A���t�@�x�b�g�̏������A0 ���� 9 �̐����A- �܂��� _ ����Ȃ�P����g�p���ĉ������B"
!insertmacro PFI_LANG_STRING PFI_LANG_CBP_IO_CREATE        "�ȉ��̃��X�g���I�Ԃ��A�K���Ȗ��O����͂��ĐV�����o�P�c���쐬���ĉ������B"
!insertmacro PFI_LANG_STRING PFI_LANG_CBP_IO_DELETE        "�������ȏ�̃o�P�c�����X�g���폜����ɂ́A�Ή�����u�폜�v�{�b�N�X�Ƀ`�F�b�N�����āu���s�v�{�^�����N���b�N���ĉ������B"
!insertmacro PFI_LANG_STRING PFI_LANG_CBP_IO_LISTHDR       "POPFile �Ɏg�p����o�P�c"
!insertmacro PFI_LANG_STRING PFI_LANG_CBP_IO_REMOVE        "�폜"
!insertmacro PFI_LANG_STRING PFI_LANG_CBP_IO_CONTINUE      "���s"

; Text strings used for status messages under the bucket list

!insertmacro PFI_LANG_STRING PFI_LANG_CBP_IO_MSG_1         "��������ȏ�̃o�P�c�͕K�v����܂���B"
!insertmacro PFI_LANG_STRING PFI_LANG_CBP_IO_MSG_2         "�Œ��̃o�P�c���쐬���ĉ������B"
!insertmacro PFI_LANG_STRING PFI_LANG_CBP_IO_MSG_3         "�Œ������̃o�P�c���K�v�ł��B"
!insertmacro PFI_LANG_STRING PFI_LANG_CBP_IO_MSG_4         "�C���X�g�[���[�́A"
!insertmacro PFI_LANG_STRING PFI_LANG_CBP_IO_MSG_5         "�ȏ�̃o�P�c����邱�Ƃ͂ł��܂���B"

; Message box text strings

!insertmacro PFI_LANG_STRING PFI_LANG_CBP_MBDUPERR_1       "�o�P�c"
!insertmacro PFI_LANG_STRING PFI_LANG_CBP_MBDUPERR_2       "�͊��ɍ쐬����Ă��܂��B"
!insertmacro PFI_LANG_STRING PFI_LANG_CBP_MBDUPERR_3       "�V�����o�P�c�ɂ͈Ⴄ���O��I��ŉ������B"

!insertmacro PFI_LANG_STRING PFI_LANG_CBP_MBMAXERR_1       "�C���X�g�[���[���쐬�ł���o�P�c��"
!insertmacro PFI_LANG_STRING PFI_LANG_CBP_MBMAXERR_2       "�ł��B"
!insertmacro PFI_LANG_STRING PFI_LANG_CBP_MBMAXERR_3       "�C���X�g�[���I����ɂ��o�P�c���쐬�ł��܂��B���݂̃o�P�c�̌�:"

!insertmacro PFI_LANG_STRING PFI_LANG_CBP_MBNAMERR_1       "�o�P�c��:"
!insertmacro PFI_LANG_STRING PFI_LANG_CBP_MBNAMERR_2       "�͖����Ȗ��O�ł��B"
!insertmacro PFI_LANG_STRING PFI_LANG_CBP_MBNAMERR_3       "�o�P�c�̖��O�ɂ� a ���� z �̏������A0 ���� 9 �̐����A- �܂��� _ ���g�p���ĉ������B"
!insertmacro PFI_LANG_STRING PFI_LANG_CBP_MBNAMERR_4       "�V�����o�P�c�ɂ͈Ⴄ���O��I��ŉ������B"

!insertmacro PFI_LANG_STRING PFI_LANG_CBP_MBCONTERR_1      "POPFile �̓��[���𕪗ނ���̂ɍŒ��̃o�P�c��K�v�Ƃ��܂��B"
!insertmacro PFI_LANG_STRING PFI_LANG_CBP_MBCONTERR_2      "�쐬����o�P�c�̖��O����͂��ĉ������B${MB_NL}${MB_NL}�h���b�v�_�E�����X�g�̗���I�����邩�A${MB_NL}${MB_NL}�K���Ȗ��O����͂��ĉ������B"
!insertmacro PFI_LANG_STRING PFI_LANG_CBP_MBCONTERR_3      "POPFile �̃C���X�g�[���𑱍s����ɂ́A�Œ��̃o�P�c���쐬���Ȃ���΂Ȃ�܂���B"

!insertmacro PFI_LANG_STRING PFI_LANG_CBP_MBDONE_1         "�̃o�P�c�� POPFile �p�ɍ쐬����܂����B"
!insertmacro PFI_LANG_STRING PFI_LANG_CBP_MBDONE_2         "�����̃o�P�c���g���悤 POPFile ��ݒ肵�Ă���낵���ł����H"
!insertmacro PFI_LANG_STRING PFI_LANG_CBP_MBDONE_3         "�o�P�c�̑I����ύX����ɂ́uNo�v���N���b�N���ĉ������B"

!insertmacro PFI_LANG_STRING PFI_LANG_CBP_MBMAKERR_1       "�C���X�g�[���[�͑I�����ꂽ�o�P�c��S�č쐬�ł��܂���ł����B�쐬�Ɏ��s�����o�P�c:"
!insertmacro PFI_LANG_STRING PFI_LANG_CBP_MBMAKERR_2       "�� / �I�����ꂽ�o�P�c:"
!insertmacro PFI_LANG_STRING PFI_LANG_CBP_MBMAKERR_3       "�� "
!insertmacro PFI_LANG_STRING PFI_LANG_CBP_MBMAKERR_4       "�쐬�ł��Ȃ������o�P�c�́APOPFile �̃C���X�g�[�����${MB_NL}${MB_NL}���[�U�[�C���^�[�t�F�[�X(�R���g���[���p�l��)���쐬�ł��܂��B"

#--------------------------------------------------------------------------
# Custom Page - Email Client Reconfiguration
#--------------------------------------------------------------------------

; Page Title and Sub-title displayed in the page header

!insertmacro PFI_LANG_STRING PFI_LANG_MAILCFG_TITLE        "���[���N���C�A���g�̐ݒ�"
!insertmacro PFI_LANG_STRING PFI_LANG_MAILCFG_SUBTITLE     "�������̃��[���N���C�A���g�ł́A�ݒ�� POPFile �p�ɕύX���邱�Ƃ��ł��܂��B"

; Text displayed on the custom page

!insertmacro PFI_LANG_STRING PFI_LANG_MAILCFG_IO_TEXT_1    "(*) �󂪕t���Ă��郁�[���N���C�A���g�ɂ��ẮA�P���ȃA�J�E���g�ݒ�ł������A�ݒ�������I�ɕύX���邱�Ƃ��ł��܂��B${IO_NL}�F�؂�K�v�Ƃ���A�J�E���g�ɂ��Ă͎蓮�ŕύX���邱�Ƃ������������܂��B"
!insertmacro PFI_LANG_STRING PFI_LANG_MAILCFG_IO_TEXT_2    "�d�v: �����I�ɐݒ�ύX�ł��郁�[���N���C�A���g�ɂ��ẮA�������V���b�g�_�E�����ĉ������B${IO_NL}${IO_NL}���̋@�\�͂܂��J���r���̋@�\�ł��B(�Ⴆ�΂������� Outlook �A�J�E���g�͌��o����Ȃ���������܂���B)${IO_NL}���[���N���C�A���g���g�p����O�ɐݒ�ύX�����܂����������ǂ����m�F���ĉ������B"

!insertmacro PFI_LANG_STRING PFI_LANG_MAILCFG_IO_CANCEL    "���[���N���C�A���g�̐ݒ�ύX�̓L�����Z������܂����B"

#--------------------------------------------------------------------------
# Text used on buttons to skip configuration of email clients
#--------------------------------------------------------------------------

!insertmacro PFI_LANG_STRING PFI_LANG_MAILCFG_IO_SKIPALL   "�S�ăX�L�b�v"
!insertmacro PFI_LANG_STRING PFI_LANG_MAILCFG_IO_SKIPONE   "�X�L�b�v"

#--------------------------------------------------------------------------
# Message box warnings that an email client is still running
#--------------------------------------------------------------------------

!insertmacro PFI_LANG_STRING PFI_LANG_MBCLIENT_EXP         "�x��: Outlook Express ���N�����ł��I"
!insertmacro PFI_LANG_STRING PFI_LANG_MBCLIENT_OUT         "�x��: Outlook ���N�����ł��I"
!insertmacro PFI_LANG_STRING PFI_LANG_MBCLIENT_EUD         "�x��: Eudora ���N�����ł��I"

!insertmacro PFI_LANG_STRING PFI_LANG_MBCLIENT_STOP_1      "���[���N���C�A���g���V���b�g�_�E��������A�u�Ď��s�v�������ĉ������B"
!insertmacro PFI_LANG_STRING PFI_LANG_MBCLIENT_STOP_2      "(�u�����v�������Α��s�ł��܂����A���܂萄�����Ȃ�����ł��B)"
!insertmacro PFI_LANG_STRING PFI_LANG_MBCLIENT_STOP_3      "�u���~�v�������ƃ��[���N���C�A���g�̐ݒ�ύX���X�L�b�v���܂��B"

!insertmacro PFI_LANG_STRING PFI_LANG_MBCLIENT_STOP_4      "���[���N���C�A���g���V���b�g�_�E��������A�u�Ď��s�v���N���b�N���Č��̐ݒ�ɖ߂��ĉ������B"
!insertmacro PFI_LANG_STRING PFI_LANG_MBCLIENT_STOP_5      "(�u�����v���N���b�N����ΐݒ�����ɖ߂��܂����A���̑���͂��܂肨���߂ł��܂���B)"
!insertmacro PFI_LANG_STRING PFI_LANG_MBCLIENT_STOP_6      "�u���~�v���N���b�N���Č��̐ݒ�ɖ߂��ĉ������B"

#--------------------------------------------------------------------------
# Custom Page - Reconfigure Outlook/Outlook Express
#--------------------------------------------------------------------------

; Page Title and Sub-title displayed in the page header

!insertmacro PFI_LANG_STRING PFI_LANG_EXPCFG_TITLE         "Outlook Express �̐ݒ�ύX"
!insertmacro PFI_LANG_STRING PFI_LANG_EXPCFG_SUBTITLE      "POPFile �� Outlook Express �̐ݒ��ύX���邱�Ƃ��ł��܂��B"

!insertmacro PFI_LANG_STRING PFI_LANG_OUTCFG_TITLE         "Outlook �̐ݒ�ύX"
!insertmacro PFI_LANG_STRING PFI_LANG_OUTCFG_SUBTITLE      "POPFile �� Outlook �̐ݒ��ύX���邱�Ƃ��ł��܂��B"

; Text displayed on the custom page

!insertmacro PFI_LANG_STRING PFI_LANG_EXPCFG_IO_CANCELLED  "Outlook Express �̐ݒ�ύX�̓L�����Z������܂����B"
!insertmacro PFI_LANG_STRING PFI_LANG_OUTCFG_IO_CANCELLED  "Outlook �̐ݒ�ύX�̓L�����Z������܂����B"

!insertmacro PFI_LANG_STRING PFI_LANG_OOECFG_IO_BOXHDR     "�A�J�E���g"
!insertmacro PFI_LANG_STRING PFI_LANG_OOECFG_IO_ACCOUNTHDR "�A�J�E���g"
!insertmacro PFI_LANG_STRING PFI_LANG_OOECFG_IO_EMAILHDR   "���[���A�h���X"
!insertmacro PFI_LANG_STRING PFI_LANG_OOECFG_IO_SERVERHDR  "�T�[�o�["
!insertmacro PFI_LANG_STRING PFI_LANG_OOECFG_IO_USRNAMEHDR "���[�U�[��"
!insertmacro PFI_LANG_STRING PFI_LANG_OOECFG_IO_FOOTNOTE   "�ݒ�ύX���������A�J�E���g�̃`�F�b�N�{�b�N�X�Ƀ`�F�b�N�����Ă��������B${IO_NL}POPFile ���A���C���X�g�[������΁A�ύX�����ݒ�͂܂����ɖ߂�܂��B "

; Message Box to confirm changes to Outlook/Outlook Express account configuration

!insertmacro PFI_LANG_STRING PFI_LANG_EXPCFG_MBIDENTITY    "Outlook Express �A�C�f���e�B�e�B�[ :"
!insertmacro PFI_LANG_STRING PFI_LANG_EXPCFG_MBACCOUNT     "Outlook Express �A�J�E���g :"

!insertmacro PFI_LANG_STRING PFI_LANG_OUTCFG_MBIDENTITY    "Outlook ���[�U�[ :"
!insertmacro PFI_LANG_STRING PFI_LANG_OUTCFG_MBACCOUNT     "Outlook �A�J�E���g :"

!insertmacro PFI_LANG_STRING PFI_LANG_OOECFG_MBEMAIL       "���[���A�h���X :"
!insertmacro PFI_LANG_STRING PFI_LANG_OOECFG_MBSERVER      "POP3 �T�[�o�[ :"
!insertmacro PFI_LANG_STRING PFI_LANG_OOECFG_MBUSERNAME    "POP3 ���[�U�[�� :"
!insertmacro PFI_LANG_STRING PFI_LANG_OOECFG_MBOEPORT      "POP3 �|�[�g :"
!insertmacro PFI_LANG_STRING PFI_LANG_OOECFG_MBOLDVALUE    "���݂̐ݒ�"
!insertmacro PFI_LANG_STRING PFI_LANG_OOECFG_MBQUESTION    "���̃A�J�E���g�̐ݒ�� POPFile �p�ɕύX���܂����H"

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

!insertmacro PFI_LANG_STRING PFI_LANG_EUCFG_TITLE          "Eudora �̐ݒ�ύX"
!insertmacro PFI_LANG_STRING PFI_LANG_EUCFG_SUBTITLE       "POPFile �� Eudora �̐ݒ��ύX���邱�Ƃ��ł��܂��B"

; Text displayed on the custom page

!insertmacro PFI_LANG_STRING PFI_LANG_EUCFG_IO_CANCELLED   "Eudora �̐ݒ�ύX�̓L�����Z������܂����B"

!insertmacro PFI_LANG_STRING PFI_LANG_EUCFG_IO_INTRO_1     "POPFile �͎��� Eudora �p�[�\�i���e�B�����o���܂����B"
!insertmacro PFI_LANG_STRING PFI_LANG_EUCFG_IO_INTRO_2     "POPFile �p�Ɏ����I�ɐݒ��ύX���邱�Ƃ��ł��܂��B"
!insertmacro PFI_LANG_STRING PFI_LANG_EUCFG_IO_CHECKBOX    "POPFile �p�ɂ��̃p�[�\�i���e�B�̐ݒ��ύX����B"
!insertmacro PFI_LANG_STRING PFI_LANG_EUCFG_IO_DOMINANT    "<��v> �p�[�\�i���e�B"
!insertmacro PFI_LANG_STRING PFI_LANG_EUCFG_IO_PERSONA     "�p�[�\�i���e�B"
!insertmacro PFI_LANG_STRING PFI_LANG_EUCFG_IO_EMAIL       "���[���A�h���X:"
!insertmacro PFI_LANG_STRING PFI_LANG_EUCFG_IO_SERVER      "POP3 �T�[�o�[:"
!insertmacro PFI_LANG_STRING PFI_LANG_EUCFG_IO_USERNAME    "POP3 ���[�U�[�l�[��:"
!insertmacro PFI_LANG_STRING PFI_LANG_EUCFG_IO_POP3PORT    "POP3 �|�[�g:"
!insertmacro PFI_LANG_STRING PFI_LANG_EUCFG_IO_RESTORE     "POPFile ���A���C���X�g�[������Ό��̐ݒ�ɖ߂�܂��B"

#--------------------------------------------------------------------------
# Custom Page - POPFile can now be started
#--------------------------------------------------------------------------

; Page Title and Sub-title displayed in the page header

!insertmacro PFI_LANG_STRING PFI_LANG_LAUNCH_TITLE         "POPFile �̋N��"
!insertmacro PFI_LANG_STRING PFI_LANG_LAUNCH_SUBTITLE      "���[�U�[�C���^�[�t�F�[�X�� POPFile ���N�����Ȃ��Ǝg���܂���B"

; Text displayed on the custom page

!insertmacro PFI_LANG_STRING PFI_LANG_LAUNCH_IO_INTRO      "POPFile ���N�����܂����H"
!insertmacro PFI_LANG_STRING PFI_LANG_LAUNCH_IO_NO         "������(���[�U�[�C���^�[�t�F�[�X�� POPFile ���N�����Ȃ��Ǝg���܂���)"
!insertmacro PFI_LANG_STRING PFI_LANG_LAUNCH_IO_DOSBOX     "POPFile ���N��(�R���\�[��)"
!insertmacro PFI_LANG_STRING PFI_LANG_LAUNCH_IO_BCKGRND    "POPFile ���o�b�N�O���E���h�ŋN��(�R���\�[���Ȃ�)"
!insertmacro PFI_LANG_STRING PFI_LANG_LAUNCH_IO_NOICON     "POPFile ���N��(�V�X�e���g���C�A�C�R����\�����Ȃ�)"
!insertmacro PFI_LANG_STRING PFI_LANG_LAUNCH_IO_TRAYICON   "POPFile ���N��(�V�X�e���g���C�A�C�R����\��)"
!insertmacro PFI_LANG_STRING PFI_LANG_LAUNCH_IO_NOTE_1     "POPFile ���N������Έȉ��̕��@�Ń��[�U�[�C���^�[�t�F�[�X���g�p�ł��܂��B"
!insertmacro PFI_LANG_STRING PFI_LANG_LAUNCH_IO_NOTE_2     "(a) �V�X�e���g���C���� POPFile �A�C�R�����_�u���N���b�N"
!insertmacro PFI_LANG_STRING PFI_LANG_LAUNCH_IO_NOTE_3     "(b) �X�^�[�g --> �v���O���� --> POPFile --> POPFile User Interface ��I��"

; Banner message displayed whilst waiting for POPFile to start

!insertmacro PFI_LANG_STRING PFI_LANG_LAUNCH_BANNER_1      "POPFile ���N����"
!insertmacro PFI_LANG_STRING PFI_LANG_LAUNCH_BANNER_2      "���΂炭���҂���������..."

#--------------------------------------------------------------------------
# Standard MUI Page - Installation Page (for the 'Corpus Conversion Monitor' utility)
#--------------------------------------------------------------------------

!insertmacro PFI_LANG_STRING PFI_LANG_CONVERT_MUTEX        "�ʂ� 'Corpus Conversion Monitor' �����ɋN�����ł��I"
!insertmacro PFI_LANG_STRING PFI_LANG_CONVERT_PRIVATE      "'Corpus Conversion Monitor' �� POPFile �C���X�g�[���[�̈ꕔ�ł��B"
!insertmacro PFI_LANG_STRING PFI_LANG_CONVERT_NOFILE       "�G���[: Corpus �ϊ��f�[�^�t�@�C�������݂��܂���I"
!insertmacro PFI_LANG_STRING PFI_LANG_CONVERT_NOPOPFILE    "�G���[: POPFile �̃p�X��������܂���B"
!insertmacro PFI_LANG_STRING PFI_LANG_CONVERT_ENVNOTSET    "�G���[: ���ϐ����Z�b�g���邱�Ƃ��ł��܂���B"
!insertmacro PFI_LANG_STRING PFI_LANG_CONVERT_NOKAKASI     "�G���[: Kakasi �̃p�X��������܂���B"
!insertmacro PFI_LANG_STRING PFI_LANG_CONVERT_STARTERR     "Corpus �ϊ��̃v���Z�X���N�����ɃG���[���������܂����B"
!insertmacro PFI_LANG_STRING PFI_LANG_CONVERT_FATALERR     "Corpus �ϊ��̃v���Z�X���ɒv���I�ȃG���[���������܂����I"
!insertmacro PFI_LANG_STRING PFI_LANG_CONVERT_ESTIMATE     "�\�z�c�莞��: "
!insertmacro PFI_LANG_STRING PFI_LANG_CONVERT_MINUTES      "��"
!insertmacro PFI_LANG_STRING PFI_LANG_CONVERT_WAITING      "(�ŏ��̃t�@�C�����ϊ������̂�҂��Ă��܂��B)"
!insertmacro PFI_LANG_STRING PFI_LANG_CONVERT_TOTALFILES   "$G_BUCKET_COUNT �̃o�P�c�t�@�C����ϊ����܂��B"
!insertmacro PFI_LANG_STRING PFI_LANG_CONVERT_PROGRESS_N   "$G_ELAPSED_TIME.$G_DECPLACES ���o�߁B���� $G_STILL_TO_DO �̃t�@�C����ϊ����܂��B"
!insertmacro PFI_LANG_STRING PFI_LANG_CONVERT_PROGRESS_1   "$G_ELAPSED_TIME.$G_DECPLACES ���o�߁B����1�̃t�@�C����ϊ����܂��B"
!insertmacro PFI_LANG_STRING PFI_LANG_CONVERT_SUMMARY      "Corpus �̕ϊ��ɂ� $G_ELAPSED_TIME.$G_DECPLACES ��������܂����B"

#--------------------------------------------------------------------------
# Standard MUI Page - Uninstall POPFile
#--------------------------------------------------------------------------

; Uninstall Progress Reports displayed above the progress bar

!insertmacro PFI_LANG_STRING PFI_LANG_UN_PROG_SHUTDOWN     "POPFile ���V���b�g�_�E����..."
!insertmacro PFI_LANG_STRING PFI_LANG_UN_PROG_SHORT        "�u�X�^�[�g���j���[�v���� POPFile ���폜��..."
!insertmacro PFI_LANG_STRING PFI_LANG_UN_PROG_CORE         "POPFile �̃R�A�t�@�C�����폜��..."
!insertmacro PFI_LANG_STRING PFI_LANG_UN_PROG_OUTEXPRESS   "Outlook Express �̐ݒ�����ɖ߂��Ă��܂�..."
!insertmacro PFI_LANG_STRING PFI_LANG_UN_PROG_SKINS        "POPFile �̃X�L���t�@�C�����폜��..."
!insertmacro PFI_LANG_STRING PFI_LANG_UN_PROG_PERL         "�ŏ��o�[�W������ Perl ���폜��..."
!insertmacro PFI_LANG_STRING PFI_LANG_UN_PROG_OUTLOOK      "Outlook �̐ݒ�����ɖ߂��Ă��܂�..."
!insertmacro PFI_LANG_STRING PFI_LANG_UN_PROG_EUDORA       "Eudora �̐ݒ�����ɖ߂��Ă��܂�..."
!insertmacro PFI_LANG_STRING PFI_LANG_UN_PROG_DBMSGDIR     "corpus �� 'Recent Messages' �f�B���N�g�����폜��..."
!insertmacro PFI_LANG_STRING PFI_LANG_UN_PROG_EXESTATUS    "�v���O�����̃X�e�[�^�X���`�F�b�N��..."
!insertmacro PFI_LANG_STRING PFI_LANG_UN_PROG_CONFIG       "�ݒ�f�[�^���폜��..."
!insertmacro PFI_LANG_STRING PFI_LANG_UN_PROG_REGISTRY     "POPFile �̃��W�X�g���G���g���[���폜��..."

; Uninstall Log Messages

!insertmacro PFI_LANG_STRING PFI_LANG_UN_LOG_SHUTDOWN      "Shutting down POPFile using port"
!insertmacro PFI_LANG_STRING PFI_LANG_UN_LOG_OPENED        "Opened"
!insertmacro PFI_LANG_STRING PFI_LANG_UN_LOG_RESTORED      "Restored"
!insertmacro PFI_LANG_STRING PFI_LANG_UN_LOG_CLOSED        "Closed"
!insertmacro PFI_LANG_STRING PFI_LANG_UN_LOG_DELROOTDIR    "Removing all files from POPFile directory"
!insertmacro PFI_LANG_STRING PFI_LANG_UN_LOG_DELROOTERR    "Note: unable to remove all files from POPFile directory"
!insertmacro PFI_LANG_STRING PFI_LANG_UN_LOG_DATAPROBS     "Data problems"
!insertmacro PFI_LANG_STRING PFI_LANG_UN_LOG_DELUSERDIR    "Removing all files from POPFile 'User Data' directory"
!insertmacro PFI_LANG_STRING PFI_LANG_UN_LOG_DELUSERERR    "Note: unable to remove all files from POPFile 'User Data' directory"

; Message Box text strings

!insertmacro PFI_LANG_STRING PFI_LANG_UN_MBDIFFUSER_1      "'$G_WINUSERNAME' �͑��̃��[�U�[�ɑ�����f�[�^���폜���悤�Ƃ��Ă��܂��B"

!insertmacro PFI_LANG_STRING PFI_LANG_UN_MBNOTFOUND_1      "POPFile �͎��̃f�B���N�g���ɃC���X�g�[������Ă��Ȃ��悤�ł�:"
!insertmacro PFI_LANG_STRING PFI_LANG_UN_MBNOTFOUND_2      "����ł����s���܂���(�����ł��܂���B)�H"

!insertmacro PFI_LANG_STRING PFI_LANG_UN_ABORT_1           "�A���C���X�g�[���̓��[�U�[��蒆�~����܂����B"

!insertmacro PFI_LANG_STRING PFI_LANG_UN_MBCLIENT_1        "'Outlook Express' �̖��ł��I"
!insertmacro PFI_LANG_STRING PFI_LANG_UN_MBCLIENT_2        "'Outlook' �̖��ł��I"
!insertmacro PFI_LANG_STRING PFI_LANG_UN_MBCLIENT_3        "'Eudora' �̖��ł��I"

!insertmacro PFI_LANG_STRING PFI_LANG_UN_MBEMAIL_1         "�������̐ݒ�����ɖ߂����Ƃ��ł��܂���ł����B"
!insertmacro PFI_LANG_STRING PFI_LANG_UN_MBEMAIL_2         "�G���[���|�[�g��\�����܂����H"

!insertmacro PFI_LANG_STRING PFI_LANG_UN_MBRERUN_1         "�������̃��[���N���C�A���g�̐ݒ�����ɖ߂����Ƃ��ł��܂���ł����I"
!insertmacro PFI_LANG_STRING PFI_LANG_UN_MBRERUN_2         "(�ڍׂɂ��Ă� $INSTDIR �t�H���_���Q�Ƃ��Ă��������B)"
!insertmacro PFI_LANG_STRING PFI_LANG_UN_MBRERUN_3         "'No' ���N���b�N����΃G���[�𖳎����đS�Ă��폜���܂��B"
!insertmacro PFI_LANG_STRING PFI_LANG_UN_MBRERUN_4         "'Yes' ���N���b�N����΃f�[�^�͕ۑ�����܂��B(����́A��ł܂��Ď��s���鎞�̂��߂ł��B)"

!insertmacro PFI_LANG_STRING PFI_LANG_UN_MBREMDIR_1        "POPFile �f�B���N�g���ȉ��̑S�Ẵt�@�C�����폜���܂����H${MB_NL}${MB_NL}$G_ROOTDIR${MB_NL}${MB_NL}(�c�������t�@�C��������� No ���N���b�N���ĉ������B)"
!insertmacro PFI_LANG_STRING PFI_LANG_UN_MBREMDIR_2        "POPFile�u���[�U�[�f�[�^�v�f�B���N�g���ȉ��̑S�Ẵt�@�C�����폜���܂����H${MB_NL}${MB_NL}$G_USERDIR${MB_NL}${MB_NL}(�c�������t�@�C��������� No ���N���b�N���ĉ������B)"

!insertmacro PFI_LANG_STRING PFI_LANG_UN_MBDELMSGS_1       "'Recent Messages' �f�B���N�g�����̑S�Ẵt�@�C�����폜���܂����H"

!insertmacro PFI_LANG_STRING PFI_LANG_UN_MBREMERR_1        "����"
!insertmacro PFI_LANG_STRING PFI_LANG_UN_MBREMERR_2        "�͍폜�ł��܂���ł����B"

#--------------------------------------------------------------------------
# Mark the end of the language data
#--------------------------------------------------------------------------

!undef PFI_LANG

#--------------------------------------------------------------------------
# End of 'Japanese-pfi.nsh'
#--------------------------------------------------------------------------
