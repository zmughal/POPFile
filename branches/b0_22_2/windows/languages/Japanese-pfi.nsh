#--------------------------------------------------------------------------
# Japanese-pfi.nsh
#
# This file contains the "Japanese" text strings used by the Windows installer
# and other NSIS-based Windows utilities for POPFile (includes customised versions
# of strings provided by NSIS and strings which are unique to POPFile).
#
# These strings are grouped according to the page/window and script where they are used
#
# Copyright (c) 2003-2009 John Graham-Cumming
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
#
# Translation created by: Junya Ishihara (UTF-8: E79FB3 E58E9F E6B7B3 E4B99F) (jishiha at users.sourceforge.net)
# Translation updated by: Naoki IIMURA (UTF-8: E38184 E38184 E38280 E38289 E381AA E3818A E3818D) (amatubu at users.sourceforge.net)
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

###########################################################################
###########################################################################

#--------------------------------------------------------------------------
# CONTENTS:
#
#   "General Purpose" strings
#
#   "Shared" strings used by more than one script
#
#   "POPFile Installer" strings used by the main POPFile installer/uninstaller (installer.nsi)
#
#   "SSL Setup" strings used by the standalone "SSL Setup" wizard (addssl.nsi)
#
#   "Get SSL" strings used when downloading/installing SSL support (getssl.nsh)
#
#   "Add User" strings used by the 'Add POPFile User' installer/uninstaller (adduser.nsi)
#
#   "Corpus Conversion" strings used by the 'Monitor Corpus Conversion' utility (MonitorCC.nsi)
#
#--------------------------------------------------------------------------

###########################################################################
###########################################################################

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; General Purpose:  (used for banners and page titles/subtitles in several scripts)
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

!insertmacro PFI_LANG_STRING PFI_LANG_BE_PATIENT           "���҂��������B"
!insertmacro PFI_LANG_STRING PFI_LANG_TAKE_A_FEW_SECONDS   "���̏����ɂ͂��΂炭���Ԃ�������܂�..."

###########################################################################
###########################################################################

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; Shared: Message displayed when wizard does not seem to belong to the current installation [adduser.nsi, runpopfile.nsi]
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

!insertmacro PFI_LANG_STRING PFI_LANG_COMPAT_NOTFOUND      "�G���[: ${C_PFI_PRODUCT} �̌݊����̂���o�[�W������������܂���I"

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; Shared: Message box shown (before the WELCOME page) if another installer is running [installer.nsi, adduser.nsi]
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

!insertmacro PFI_LANG_STRING PFI_LANG_INSTALLER_MUTEX      "�ʂ� POPFile �C���X�g�[���[�����s���ł��I"

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; Shared: Message box shown if 'SetEnvironmentVariableA' fails [installer.nsi, adduser.nsi, MonitorCC.nsi]
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

!insertmacro PFI_LANG_STRING PFI_LANG_CONVERT_ENVNOTSET    "�G���[: ���ϐ����Z�b�g���邱�Ƃ��ł��܂���B"

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; Shared: Standard MUI Page - DIRECTORY
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

; Used in message box shown if SFN support has been disabled [installer.nsi, adduser.nsi]

!insertmacro PFI_LANG_STRING PFI_LANG_DIRSELECT_MBNOSFN    "'$G_PLS_FIELD_1' �h���C�u�ɃC���X�g�[������ɂ́A${MB_NL}${MB_NL}�X�y�[�X���܂܂Ȃ��t�H���_��I�����Ă��������B"

; Used in message box shown if existing files found when installing [installer.nsi, adduser.nsi]

!insertmacro PFI_LANG_STRING PFI_LANG_DIRSELECT_MBWARN_2   "�A�b�v�O���[�h���܂����H"

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; Shared: Standard MUI Page - INSTFILES
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

; When upgrading an existing installation, change the normal "Install" button to "Upgrade" [installer.nsi, adduser.nsi]

!insertmacro PFI_LANG_STRING PFI_LANG_INST_BTN_UPGRADE     "�A�b�v�O���[�h"

; Installation Progress Reports displayed above the progress bar [installer.nsi, adduser.nsi]

!insertmacro PFI_LANG_STRING PFI_LANG_INST_PROG_UPGRADE    "�A�b�v�O���[�h�C���X�g�[�����ǂ����`�F�b�N���Ă��܂�..."
!insertmacro PFI_LANG_STRING PFI_LANG_INST_PROG_SHORT      "POPFile �̃V���[�g�J�b�g���쐬��..."
!insertmacro PFI_LANG_STRING PFI_LANG_INST_PROG_LANGS      "POPFile UI ����t�@�C�����C���X�g�[����..."

; Installation Progress Reports displayed above the progress bar [installer.nsi, adduser.nsi, getssl.nsh]

!insertmacro PFI_LANG_STRING PFI_LANG_INST_PROG_ENDSEC     "�u���ցv���N���b�N���đ��s���ĉ������B"

; Progress Reports displayed above the progress bar when downloading/installing SSL support [addssl.nsi, getssl.nsh]

!insertmacro PFI_LANG_STRING PFI_LANG_PROG_CHECKIFRUNNING  "POPFile ���N�������ǂ������`�F�b�N���Ă��܂�..."

; Installation Log Messages [installer.nsi, adduser.nsi]

!insertmacro PFI_LANG_STRING PFI_LANG_INST_LOG_SHUTDOWN    "Shutting down previous version of POPFile using port"

; Installation Log Messages [installer.nsi, addssl.nsi]

!insertmacro PFI_LANG_STRING PFI_LANG_PROG_SAVELOG         "�C���X�g�[�����O�t�@�C����ۑ����Ă��܂�..."

; Message Box text strings [installer.nsi, adduser.nsi, pfi-library.nsh]

!insertmacro PFI_LANG_STRING PFI_LANG_MBMANSHUT_1          "$G_PLS_FIELD_1 �������I�ɃV���b�g�_�E�����邱�Ƃ��ł��܂���ł����B"
!insertmacro PFI_LANG_STRING PFI_LANG_MBMANSHUT_2          "$G_PLS_FIELD_1 ���蓮�ŃV���b�g�_�E�����ĉ������B"
!insertmacro PFI_LANG_STRING PFI_LANG_MBMANSHUT_3          "$G_PLS_FIELD_1 ���V���b�g�_�E��������A�uOK�v ���N���b�N���đ��s���ĉ������B"

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; Shared: Message box shown if problem detected when trying to save the log file [installer.nsi, addssl.nsi, backup.nsi, restore.nsi]
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

!insertmacro PFI_LANG_STRING PFI_LANG_MB_SAVELOG_ERROR     "�G���[: ���O�t�@�C����ۑ����ɖ�肪�������܂����B"

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; Shared: Message boxes shown if uninstallation is not straightforward [installer.nsi, adduser.nsi]
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

!insertmacro PFI_LANG_STRING PFI_LANG_UN_MBDIFFUSER_1      "'$G_WINUSERNAME' �͑��̃��[�U�[�ɑ�����f�[�^���폜���悤�Ƃ��Ă��܂��B"

!insertmacro PFI_LANG_STRING PFI_LANG_UN_MBNOTFOUND_1      "POPFile �͎��̃f�B���N�g���ɃC���X�g�[������Ă��Ȃ��悤�ł�:"
!insertmacro PFI_LANG_STRING PFI_LANG_UN_MBNOTFOUND_2      "����ł����s���܂���(�����ł��܂���B)�H"

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; Shared: Message box shown if uninstaller is cancelled by the user [installer.nsi, adduser.nsi]
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

!insertmacro PFI_LANG_STRING PFI_LANG_UN_ABORT_1           "�A���C���X�g�[���̓��[�U�[��蒆�~����܂����B"

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; Shared: Standard MUI Page - UNPAGE_INSTFILES [installer.nsi, adduser.nsi]
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

; Uninstall Progress Reports displayed above the progress bar

!insertmacro PFI_LANG_STRING PFI_LANG_UN_PROG_SHUTDOWN     "POPFile ���V���b�g�_�E����..."
!insertmacro PFI_LANG_STRING PFI_LANG_UN_PROG_SHORT        "�u�X�^�[�g���j���[�v���� POPFile ���폜��..."

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; Shared: Message box shown if uninstaller failed to remove files/folders [installer.nsi, adduser.nsi]
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

; TempTranslationNote: PFI_LANG_UN_MBREMERR_A = PFI_LANG_UN_MBREMERR_1 + ": $G_PLS_FIELD_1 " + PFI_LANG_UN_MBREMERR_2

!insertmacro PFI_LANG_STRING PFI_LANG_UN_MBREMERR_A        "����: $G_PLS_FIELD_1 �͍폜�ł��܂���ł����B"

###########################################################################
###########################################################################

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; POPFile Installer: Message box shown (before the WELCOME page) offering to display the release notes [installer.nsi]
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

!insertmacro PFI_LANG_STRING PFI_LANG_MBRELNOTES_1         "POPFile �̃����[�X�m�[�g��\�����܂����H"
!insertmacro PFI_LANG_STRING PFI_LANG_MBRELNOTES_2         "�A�b�v�O���[�h�̏ꍇ�́u�͂��v�𐄏����܂��B(�A�b�v�O���[�h�̑O�Ƀo�b�N�A�b�v����邱�Ƃ𐄏����܂��B)"

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; POPFile Installer: Standard MUI Page - WELCOME [installer.nsi]
;
; The PFI_LANG_WELCOME_INFO_TEXT string should end with a '${IO_NL}${IO_NL}$_CLICK' sequence).
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

!insertmacro PFI_LANG_STRING PFI_LANG_WELCOME_INFO_TEXT    "���̃E�B�U�[�h�́APOPFile �̃C���X�g�[�����K�C�h���Ă����܂��B${IO_NL}${IO_NL}�Z�b�g�A�b�v���J�n����O�ɁA���̂��ׂẴA�v���P�[�V�������I�����邱�Ƃ𐄏����܂��B${IO_NL}${IO_NL}$_CLICK"
!insertmacro PFI_LANG_STRING PFI_LANG_WELCOME_ADMIN_TEXT   "�d�v:${IO_NL}${IO_NL}���݂̃��[�U�[�� Administrator �����������Ă��܂���B${IO_NL}${IO_NL}�����}���`���[�U�[�T�|�[�g���K�v�Ȃ�A�C���X�g�[�����L�����Z���� Administrator �A�J�E���g�� POPFile ���C���X�g�[�����邱�Ƃ������߂��܂��B"

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; POPFile Installer: Custom Page - Check Perl Requirements [installer.nsi]
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

; Page Title displayed in the page header (there is no sub-title for this page)

!insertmacro PFI_LANG_STRING PFI_LANG_PERLREQ_TITLE        "�����V�X�e���R���|�[�l���g�����o����܂����B"

; Text strings displayed on the custom page when OS version is too old

!insertmacro PFI_LANG_STRING PFI_LANG_PERLREQ_IO_TXT_OS_1  "�ŏ��o�[�W������ Perl ���C���X�g�[�����悤�Ƃ��Ă��܂�(POPFile �� Perl �ŏ�����Ă��܂�)�B${IO_NL}${IO_NL}"
!insertmacro PFI_LANG_STRING PFI_LANG_PERLREQ_IO_TXT_OS_2  "POPFile �ɕt������ Perl �� Windows 2000 �ȍ~�̂��߂̂��̂ł��B${IO_NL}${IO_NL}"
!insertmacro PFI_LANG_STRING PFI_LANG_PERLREQ_IO_TXT_OS_3  "�C���X�g�[���͂��̃V�X�e���� Windows $G_PLS_FIELD_1 ���g�p���Ă��邱�Ƃ����o���܂����B${IO_NL}${IO_NL}"
!insertmacro PFI_LANG_STRING PFI_LANG_PERLREQ_IO_TXT_OS_4  "POPFile �̂������̋@�\�͂��̃V�X�e���ł͐���ɓ��삵�Ȃ���������܂���B${IO_NL}${IO_NL}"
!insertmacro PFI_LANG_STRING PFI_LANG_PERLREQ_IO_TXT_OS_5  "���̃V�X�e���ɂ��̃o�[�W������ POPFile ���C���X�g�[�����Ȃ����Ƃ��������߂��܂��B${IO_NL}${IO_NL}"
!insertmacro PFI_LANG_STRING PFI_LANG_PERLREQ_IO_TXT_OS_6  "����ɏ�����A�h�o�C�X���K�v�ł���΁A���̃����N���N���b�N���� POPFile Web �T�C�g�ւ��z�����������B"
!insertmacro PFI_LANG_STRING PFI_LANG_PERLREQ_IO_TXT_OS_7  "http://getpopfile.org/docs/jp:oldwindows"

; Text strings displayed on the custom page when IE version is too old

!insertmacro PFI_LANG_STRING PFI_LANG_PERLREQ_IO_TXT_IE_1  "POPFile ���[�U�[�C���^�[�t�F�[�X(�R���g���[���Z���^�[)�̓f�t�H���g�u���E�U�[���g�p���܂��B${IO_NL}${IO_NL}"
!insertmacro PFI_LANG_STRING PFI_LANG_PERLREQ_IO_TXT_IE_2  "POPFile �͓���̃u���E�U�[��K�v�Ƃ����A�قƂ�ǂǂ̃u���E�U�[�Ƃ����삵�܂��B${IO_NL}${IO_NL}"
!insertmacro PFI_LANG_STRING PFI_LANG_PERLREQ_IO_TXT_IE_3  "�ŏ��o�[�W������ Perl ���C���X�g�[�����܂�(POPFile �� Perl �ŏ�����Ă��܂�)�B${IO_NL}${IO_NL}"
!insertmacro PFI_LANG_STRING PFI_LANG_PERLREQ_IO_TXT_IE_4  "POPFile �ɕt������ Perl �̓C���^�[�l�b�g�G�N�X�v���[���[ 5.5(���邢�͂���ȏ�)�̃R���|�[�l���g�̈ꕔ��K�v�Ƃ��܂��B"
!insertmacro PFI_LANG_STRING PFI_LANG_PERLREQ_IO_TXT_IE_5  "�C���X�g�[���[�̓C���^�[�l�b�g�G�N�X�v���[���[�����o���܂����B $G_PLS_FIELD_1${IO_NL}${IO_NL}"
!insertmacro PFI_LANG_STRING PFI_LANG_PERLREQ_IO_TXT_IE_6  "POPFile �̂������̋@�\�͐���ɓ��삵�Ȃ���������܂���B${IO_NL}${IO_NL}"
!insertmacro PFI_LANG_STRING PFI_LANG_PERLREQ_IO_TXT_IE_7  "POPFile �Ŗ�肪�N�������ꍇ�A�V�����o�[�W�����̃C���^�[�l�b�g�G�N�X�v���[���[�ɃA�b�v�O���[�h���邱�Ƃ𐄏����܂��B"

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; POPFile Installer: Standard MUI Page - COMPONENTS [installer.nsi]
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

!insertmacro PFI_LANG_STRING DESC_SecPOPFile               "POPFile �̃R�A�t�@�C�����C���X�g�[�����܂��B�ŏ��o�[�W������ Perl ���܂݂܂��B"
!insertmacro PFI_LANG_STRING DESC_SecSkins                 "POPFile ���[�U�[�C���^�[�t�F�[�X�̃f�U�C����ς��邱�Ƃ��ł��� POPFile �X�L�����C���X�g�[�����܂��B"
!insertmacro PFI_LANG_STRING DESC_SecLangs                 "POPFile UI �̉p��ȊO�̃o�[�W�������C���X�g�[�����܂��B"

!insertmacro PFI_LANG_STRING DESC_SubSecOptional           "POPFile �ǉ��R���|�[�l���g (�㋉���[�U�[�p)"
!insertmacro PFI_LANG_STRING DESC_SecIMAP                  "POPFile IMAP ���W���[�����C���X�g�[�����܂��B"
!insertmacro PFI_LANG_STRING DESC_SecNNTP                  "POPFile NNTP �v���L�V�[���C���X�g�[�����܂��B"
!insertmacro PFI_LANG_STRING DESC_SecSMTP                  "POPFile SMTP �v���L�V�[���C���X�g�[�����܂��B"
!insertmacro PFI_LANG_STRING DESC_SecSOCKS                 "POPFile �v���L�V�[�� SOCKS ���g����悤�ɂ��邽�߂� Perl �ǉ��R���|�[�l���g���C���X�g�[�����܂��B"
!insertmacro PFI_LANG_STRING DESC_SecSSL                   "POPFile �����[���T�[�o�[�ɑ΂���SSL�ڑ��ł���悤�ɁA�֘A����Perl�R���|�[�l���g��SSL���C�u�������_�E�����[�h����уC���X�g�[�����܂��B"
!insertmacro PFI_LANG_STRING DESC_SecXMLRPC                "(POPFile API �ւ̃A�N�Z�X���\�ɂ���)POPFile XMLRPC ���W���[���ƕK�v�� Perl ���W���[�����C���X�g�[�����܂��B"

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; POPFile Installer: Standard MUI Page - DIRECTORY (for POPFile program files) [installer.nsi]
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

; Page Title shown in the page header and Text shown above the box showing the folder selected for the installation

!insertmacro PFI_LANG_STRING PFI_LANG_ROOTDIR_TITLE        "�v���O�����t�@�C���̃C���X�g�[����"
!insertmacro PFI_LANG_STRING PFI_LANG_ROOTDIR_TEXT_DESTN   "POPFile �̃C���X�g�[����t�H���_���w�肵�Ă��������B"

; Message box warnings used when verifying the installation folder chosen by user

!insertmacro PFI_LANG_STRING PFI_LANG_DIRSELECT_MBWARN_1   "���̏ꏊ�ɈȑO�ɃC���X�g�[�����ꂽ POPFile ��������܂���:"

; Text strings used when user has NOT selected a component found in the existing installation

!insertmacro PFI_LANG_STRING MBCOMPONENT_PROB_1            "$G_PLS_FIELD_1 �R���|�[�l���g���A�b�v�O���[�h���܂����H"
!insertmacro PFI_LANG_STRING MBCOMPONENT_PROB_2            "(�Â��o�[�W������ POPFile �R���|�[�l���g���g���Ă���Ɩ�肪�N���邱�Ƃ�����܂��B)"

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; POPFile Installer: Custom Page - Setup Summary [installer.nsi]
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

; Page Title and Sub-title displayed in the page header
; $G_WINUSERNAME holds the Windows login name and $G_WINUSERTYPE holds 'Admin', 'Power', 'User', 'Guest' or 'Unknown'

!insertmacro PFI_LANG_STRING PFI_LANG_SUMMARY_TITLE        "'$G_WINUSERNAME' ($G_WINUSERTYPE) �̃Z�b�g�A�b�v�T�}���["
!insertmacro PFI_LANG_STRING PFI_LANG_SUMMARY_SUBTITLE     "�ȉ��̐ݒ��POPFile���C���X�g�[�����܂�"

; Display selected installation location and whether or not an upgrade will be performed
; $G_ROOTDIR holds the installation location, e.g. C:\Program Files\POPFile

!insertmacro PFI_LANG_STRING PFI_LANG_SUMMARY_NEWLOCN      "$G_PLS_FIELD_2 �ɐV�K��POPFile���C���X�g�[�����܂��B"
!insertmacro PFI_LANG_STRING PFI_LANG_SUMMARY_UPGRADELOCN  "$G_PLS_FIELD_2 �̊�����POPFile���A�b�v�O���[�h���܂��B"

; By default all of these components are installed (but Kakasi is only installed when Japanese/Nihongo language is chosen)

!insertmacro PFI_LANG_STRING PFI_LANG_SUMMARY_BASICLIST    "POPFile ��{�R���|�[�l���g:"
!insertmacro PFI_LANG_STRING PFI_LANG_SUMMARY_POPFILECORE  "POPFile �v���O�����t�@�C��"
!insertmacro PFI_LANG_STRING PFI_LANG_SUMMARY_MINPERL      "Perl �̍ŏ��o�[�W����"
!insertmacro PFI_LANG_STRING PFI_LANG_SUMMARY_DEFAULTSKIN  "�f�t�H���g UI �X�L��"
!insertmacro PFI_LANG_STRING PFI_LANG_SUMMARY_DEFAULTLANG  "�f�t�H���g����t�@�C��"
!insertmacro PFI_LANG_STRING PFI_LANG_SUMMARY_EXTRASKINS   "�ǉ� UI �X�L��"
!insertmacro PFI_LANG_STRING PFI_LANG_SUMMARY_EXTRALANGS   "�ǉ�����t�@�C��"
!insertmacro PFI_LANG_STRING PFI_LANG_SUMMARY_KAKASI       "Kakasi �p�b�P�[�W"

; By default none of the optional components is installed (user has to select them)

!insertmacro PFI_LANG_STRING PFI_LANG_SUMMARY_OPTIONLIST   "POPFile �I�v�V�����R���|�[�l���g:"
!insertmacro PFI_LANG_STRING PFI_LANG_SUMMARY_NONE         "(�Ȃ�)"
!insertmacro PFI_LANG_STRING PFI_LANG_SUMMARY_IMAP         "IMAP ���W���[��"
!insertmacro PFI_LANG_STRING PFI_LANG_SUMMARY_NNTP         "NNTP �v���L�V�["
!insertmacro PFI_LANG_STRING PFI_LANG_SUMMARY_SMTP         "SMTP �v���L�V�["
!insertmacro PFI_LANG_STRING PFI_LANG_SUMMARY_SOCKS        "SOCKS �T�|�[�g"
!insertmacro PFI_LANG_STRING PFI_LANG_SUMMARY_SSL          "SSL �T�|�[�g"
!insertmacro PFI_LANG_STRING PFI_LANG_SUMMARY_XMLRPC       "XMLRPC ���W���[��"

; The last line in the summary explains how to change the installation selections

!insertmacro PFI_LANG_STRING PFI_LANG_SUMMARY_BACKBUTTON   "�ݒ��ύX����ɂ́A�u�߂�v �{�^���őO�̃y�[�W�ɖ߂��Ă��������B"

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; POPFile Installer: Standard MUI Page - INSTFILES [installer.nsi]
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

; Page Title and Sub-title displayed in the page header after installing all the files

!insertmacro PFI_LANG_STRING PFI_LANG_INSTFINISH_TITLE     "�v���O�����t�@�C�����C���X�g�[������܂����B"
!insertmacro PFI_LANG_STRING PFI_LANG_INSTFINISH_SUBTITLE  "���� ${C_PFI_PRODUCT} ���g�p���邽�߂̐ݒ���s���܂��B"

; Installation Progress Reports displayed above the progress bar

!insertmacro PFI_LANG_STRING PFI_LANG_INST_PROG_CORE       "POPFile �̃R�A�t�@�C�����C���X�g�[����..."
!insertmacro PFI_LANG_STRING PFI_LANG_INST_PROG_PERL       "�ŏ��o�[�W������ Perl ���C���X�g�[����..."
!insertmacro PFI_LANG_STRING PFI_LANG_INST_PROG_SKINS      "POPFile �̃X�L���t�@�C�����C���X�g�[����..."
!insertmacro PFI_LANG_STRING PFI_LANG_INST_PROG_XMLRPC     "POPFile XMLRPC �t�@�C�����C���X�g�[����..."

; Message box used to get permission to delete the old minimal Perl before installing the new one

!insertmacro PFI_LANG_STRING PFI_LANG_MINPERL_MBREMOLD     "�V�����o�[�W�������C���X�g�[������O�ɁA�ȑO�̍ŏ��o�[�W������ Perl �t�H���_�ȉ��̑S�Ẵt�@�C�����폜���Ă��悢�ł���?${MB_NL}${MB_NL}($G_PLS_FIELD_1)"

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; POPFile Installer: Custom Page - Select uninstaller mode [installer.nsi]
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

; Page Title and Sub-title displayed in the page header of the uninstaller's first page

!insertmacro PFI_LANG_STRING PFI_LANG_UN_MODE_TITLE        "POPFile �A���C���X�g�[���̓��샂�[�h�̑I��"
!insertmacro PFI_LANG_STRING PFI_LANG_UN_MODE_SUBTITLE     "$INSTDIR �t�H���_�ɃC���X�g�[������Ă��� POPFile ��ύX�������̓A���C���X�g�[�����܂�"

; Text for the MODIFY mode radio-button and the label underneath it

!insertmacro PFI_LANG_STRING PFI_LANG_UN_IO_MODE_RADIO     "�C���X�g�[������Ă��� POPFile �̕ύX"
!insertmacro PFI_LANG_STRING PFI_LANG_UN_IO_MODE_LABEL     "(�� : SSL �T�|�[�g��ǉ���������{��p�[�T��ύX�����肵�܂�)"

; Text for the UNINSTALL mode radio-button and the label underneath it

!insertmacro PFI_LANG_STRING PFI_LANG_UN_IO_UNINST_RADIO   "POPFile �v���O�����̃A���C���X�g�[��"
!insertmacro PFI_LANG_STRING PFI_LANG_UN_IO_UNINST_LABEL   "(�R���s���[�^���� POPFile �v���O���������ׂč폜���܂�)"

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; POPFile Installer: Standard MUI Page - UNPAGE_DIRECTORY [installer.nsi]
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

; Page Title/Sub-Title shown in the page header

!insertmacro PFI_LANG_STRING PFI_LANG_UN_DIR_TITLE         "POPFile ���C���X�g�[������Ă���ꏊ"
!insertmacro PFI_LANG_STRING PFI_LANG_UN_DIR_SUBTITLE      "�I�����ꂽ POPFile �R���|�[�l���g���C���X�g�[�������ꏊ�ł�"

; Text explaining what this page shows

!insertmacro PFI_LANG_STRING PFI_LANG_UN_DIR_EXPLANATION   "�Z�b�g�A�b�v�͈ȉ��̃t�H���_�ɃC���X�g�[������Ă��� POPFile �ɃR���|�[�l���g��ǉ����܂��B�R���|�[�l���g��I�����Ȃ����ꍇ�́A�߂�{�^�����N���b�N���Ă��������B $_CLICK"

; Text shown above the box showing the folder where the extra components will be installed

!insertmacro PFI_LANG_STRING PFI_LANG_UN_DIR_TEXT_DESTN    "�V���� POPFile �R���|�[�l���g�̃C���X�g�[����t�H���_"

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; POPFile Installer: Standard MUI Page - UNPAGE_INSTFILES [installer.nsi]
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

; Page Sub-title displayed when MODIFYING the installation (one of the standard MUI strings is used for the Title)

!insertmacro PFI_LANG_STRING PFI_LANG_UN_INST_SUBTITLE     "$(^NameDA) ���A�b�v�f�[�g�����܂ł̊Ԃ��΂炭���҂���������"

; Page Title and Sub-Title shown instead of the default "Uninstallation complete..." page header

!insertmacro PFI_LANG_STRING PFI_LANG_UN_INST_OK_TITLE     "�ǉ��^�폜�������������܂���"
!insertmacro PFI_LANG_STRING PFI_LANG_UN_INST_OK_SUBTITLE  "�ǉ��^�폜�����͐���Ɋ������܂����B"

; Page Title and Sub-Title shown instead of the default "Uninstallation Aborted..." page header

!insertmacro PFI_LANG_STRING PFI_LANG_UN_INST_BAD_TITLE    "�ǉ��^�폜�����͎��s���܂���"
!insertmacro PFI_LANG_STRING PFI_LANG_UN_INST_BAD_SUBTITLE "�ǉ��^�폜�����͐���Ɋ������܂���ł����B"

; Uninstall Progress Reports displayed above the progress bar

!insertmacro PFI_LANG_STRING PFI_LANG_UN_PROG_CORE         "POPFile �̃R�A�t�@�C�����폜��..."
!insertmacro PFI_LANG_STRING PFI_LANG_UN_PROG_SKINS        "POPFile �̃X�L���t�@�C�����폜��..."
!insertmacro PFI_LANG_STRING PFI_LANG_UN_PROG_PERL         "�ŏ��o�[�W������ Perl ���폜��..."

; Uninstall Log Messages

!insertmacro PFI_LANG_STRING PFI_LANG_UN_LOG_SHUTDOWN      "�ȉ��̃|�[�g���g�p���Ă��� POPFile ���I�������Ă��܂�"
!insertmacro PFI_LANG_STRING PFI_LANG_UN_LOG_DELROOTDIR    "POPFile �f�B���N�g�����炷�ׂẴt�@�C�����폜���Ă��܂�"
!insertmacro PFI_LANG_STRING PFI_LANG_UN_LOG_DELROOTERR    "����: POPFile �f�B���N�g���̂��ׂẴt�@�C�����폜���邱�Ƃ��ł��܂���ł���"

; Message Box text strings

!insertmacro PFI_LANG_STRING PFI_LANG_UN_MBREMDIR_1        "POPFile �f�B���N�g���ȉ��̑S�Ẵt�@�C�����폜���܂����H${MB_NL}${MB_NL}$G_ROOTDIR${MB_NL}${MB_NL}(�c�������t�@�C��������� �u�������v ���N���b�N���ĉ������B)"

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; POPFile Installer: Standard MUI Page - UNPAGE_FINISH [installer.nsi]
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

!insertmacro PFI_LANG_STRING PFI_LANG_UN_FINISH_TITLE      "$(^NameDA) �R���|�[�l���g�̒ǉ��^�폜�E�B�U�[�h�̏I��"
!insertmacro PFI_LANG_STRING PFI_LANG_UN_FINISH_TEXT       "���� ���N���b�N���Ă��̃E�B�U�[�h����Ă��������B"

###########################################################################
###########################################################################

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; SSL Setup: Standard MUI Page - WELCOME
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

!insertmacro PFI_LANG_STRING PSS_LANG_WELCOME_TITLE        "$(^NameDA) �E�B�U�[�h�ɂ悤����"
!insertmacro PFI_LANG_STRING PSS_LANG_WELCOME_TEXT         "���̃��[�e�B���e�B�[�� POPFile �����[���T�[�o�[�ɑ΂� SSL �ڑ����邽�߂ɕK�v�ȃt�@�C�����_�E�����[�h����уC���X�g�[�����܂��B${IO_NL}${IO_NL}���̃o�[�W������ SSL �ڑ��̂��߂̐ݒ�ύX�����[���A�J�E���g�ɑ΂��čs�����Ƃ͂���܂���B�K�v�� Perl �R���|�[�l���g�� DLL ���C���X�g�[�����邾���ł��B${IO_NL}${IO_NL}�{���i�� OpenSSL �v���W�F�N�g�ɂ���ĊJ�����ꂽ OpenSSL Toolkit (http://www.openssl.org/) ���\�t�g�E�F�A���_�E�����[�h����уC���X�g�[�����܂��B${IO_NL}${IO_NL}~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~${IO_NL}${IO_NL}   POPFILE ���~���Ă�������   ${IO_NL}${IO_NL}~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~${IO_NL}${IO_NL}$_CLICK"

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; SSL Setup: Standard MUI Page - LICENSE
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

!insertmacro PFI_LANG_STRING PSS_LANG_LICENSE_SUBHDR       "$(^NameDA) ���g�p����O�Ƀ��C�Z���X�̏�����ǂ����ǂ݉������B"
!insertmacro PFI_LANG_STRING PSS_LANG_LICENSE_BOTTOM       "���C�Z���X�ɓ��ӂ��Ă���������Ȃ�ȉ��̃`�F�b�N�{�b�N�X���N���b�N���Ă��������B$(^NameDA) ���g�p����ɂ͓��ӂ���K�v������܂��B $_CLICK"

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; SSL Setup: Standard MUI Page - DIRECTORY
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

!insertmacro PFI_LANG_STRING PSS_LANG_DESTNDIR_TITLE       "�C���X�g�[���ς݂� POPFile 0.22 (�ȍ~) ��I�����Ă�������"
!insertmacro PFI_LANG_STRING PSS_LANG_DESTNDIR_SUBTITLE    "SSL �T�|�[�g��ǉ�����ɂ� POPFile �����ɃC���X�g�[������Ă���K�v������܂�"
!insertmacro PFI_LANG_STRING PSS_LANG_DESTNDIR_TEXT_TOP    "SSL �T�|�[�g�� POPFile ���C���X�g�[������Ă���̂Ɠ����t�H���_�ɃC���X�g�[������K�v������܂��B${MB_NL}${MB_NL}���̃��[�e�B���e�B�͎��̃t�H���_�ɃC���X�g�[������Ă��� POPFile �� SSL �T�|�[�g��ǉ����܂��B�قȂ� POPFile �ɑ΂��Ēǉ��������Ȃ�A�u�Q�Ɓv �{�^���������ĕʂ̃t�H���_��I�����Ă��������B $_CLICK"
!insertmacro PFI_LANG_STRING PSS_LANG_DESTNDIR_TEXT_DESTN  "POPFile 0.22 (�ȍ~) ���C���X�g�[������Ă���t�H���_"

!insertmacro PFI_LANG_STRING PSS_LANG_DESTNDIR_MB_WARN_1   "POPFile 0.22 (�ȍ~) �͎��̃t�H���_�ɃC���X�g�[������Ă���܂���${MB_NL}${MB_NL}$G_PLS_FIELD_1"
!insertmacro PFI_LANG_STRING PSS_LANG_DESTNDIR_MB_WARN_2   "�{���ɂ��̃t�H���_���g�p���܂���?"

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; SSL Setup: Standard MUI Page - INSTFILES
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

; Initial page header

!insertmacro PFI_LANG_STRING PSS_LANG_STD_HDR              "SSL �T�|�[�g�C���X�g�[���� (POPFile 0.22 �ȍ~)"
!insertmacro PFI_LANG_STRING PSS_LANG_STD_SUBHDR           "SSL �p�̃t�@�C�����_�E�����[�h����уC���X�g�[�����܂��B�������҂�������..."

; Successful completion page header

!insertmacro PFI_LANG_STRING PSS_LANG_END_HDR              "POPFile SSL �T�|�[�g�̃C���X�g�[�����������܂���"
!insertmacro PFI_LANG_STRING PSS_LANG_END_SUBHDR           "POPFile �p SSL �T�|�[�g�̃C���X�g�[���͐���Ɋ������܂����B"

; Unsuccessful completion page header

!insertmacro PFI_LANG_STRING PSS_LANG_ABORT_HDR            "POPFile SSL �T�|�[�g�̃C���X�g�[���͎��s���܂���"
!insertmacro PFI_LANG_STRING PSS_LANG_ABORT_SUBHDR         "POPFile �� SSL �T�|�[�g��ǉ����邽�߂̃C���X�g�[����Ƃ͎��s���܂����B"

; Progress reports

!insertmacro PFI_LANG_STRING PSS_LANG_PROG_INITIALISE      "��������..."
!insertmacro PFI_LANG_STRING PSS_LANG_PROG_USERCANCELLED   "POPFile SSL �T�|�[�g�̃C���X�g�[���̓��[�U�[�ɂ�蒆�f����܂���"
!insertmacro PFI_LANG_STRING PSS_LANG_PROG_SUCCESS         "POPFile SSL �T�|�[�g�̓C���X�g�[������܂���"

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; SSL Setup: Standard MUI Page - FINISH
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

!insertmacro PFI_LANG_STRING PSS_LANG_FINISH_TITLE         "$(^NameDA) �E�B�U�[�h����"
!insertmacro PFI_LANG_STRING PSS_LANG_FINISH_TEXT          "POPFile �� SSL �T�|�[�g���C���X�g�[������܂����B${IO_NL}${IO_NL}POPFile ���N�����APOPFile �ƃ��[���\�t�g�Ƃ� SSL ���g�p�ł���悤�ɐݒ肵�Ă��������B${IO_NL}${IO_NL}�u�����v �{�^���������ăE�B�U�[�h����Ă��������B"

!insertmacro PFI_LANG_STRING PSS_LANG_FINISH_README        "�d�v�ȏ��"

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; SSL Setup: Miscellaneous Strings
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

!insertmacro PFI_LANG_STRING PSS_LANG_MUTEX                "SSL �Z�b�g�A�b�v�E�B�U�[�h���ʂɋN�����Ă��܂�!"

!insertmacro PFI_LANG_STRING PSS_LANG_COMPAT_NOTFOUND      "�x��: �Ή����Ă��� POPFile �����o�ł��܂��� !"

!insertmacro PFI_LANG_STRING PSS_LANG_ABORT_WARNING        "�{���� $(^NameDA) �E�B�U�[�h�𒆒f���Ă���낵���ł���?"

!insertmacro PFI_LANG_STRING PSS_LANG_PREPAREPATCH         "Module.pm ���A�b�v�f�[�g��(SSL �_�E�����[�h�̍������ɕK�v)"
!insertmacro PFI_LANG_STRING PSS_LANG_PATCHSTATUS          "Module.pm �p�b�`�X�e�[�^�X: $G_PLS_FIELD_1"
!insertmacro PFI_LANG_STRING PSS_LANG_PATCHCOMPLETED       "Module.pm �t�@�C���̓A�b�v�f�[�g����܂���"
!insertmacro PFI_LANG_STRING PSS_LANG_PATCHFAILED          "Module.pm �t�@�C���̓A�b�v�f�[�g����܂���ł���"

###########################################################################
###########################################################################

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; Get SSL: Strings used when downloading and installing the optional SSL files [getssl.nsh]
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

; Progress reports

!insertmacro PFI_LANG_STRING PFI_LANG_PROG_STARTDOWNLOAD   "$G_PLS_FIELD_1 �� $G_PLS_FIELD_2 ���_�E�����[�h���Ă��܂��B"
!insertmacro PFI_LANG_STRING PFI_LANG_PROG_FILECOPY        "$G_PLS_FIELD_2 ���R�s�[��..."
!insertmacro PFI_LANG_STRING PFI_LANG_PROG_FILEEXTRACT     "$G_PLS_FIELD_2 ���t�@�C����W�J��..."

!insertmacro PFI_LANG_STRING PFI_LANG_TAKE_SEVERAL_SECONDS "(���΂炭���Ԃ�������܂�)"

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; Get SSL: Message Box strings used when installing SSL Support [getssl.nsh]
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

!insertmacro PFI_LANG_STRING PFI_LANG_MB_CHECKINTERNET     "SSL �p�̃t�@�C���̓C���^�[�l�b�g����_�E�����[�h����܂��B${MB_NL}${MB_NL}�C���^�[�l�b�g�ڑ����_�E�����Ă��邩�����ɂȂ��Ă���悤�ł��B${MB_NL}${MB_NL}�C���X�g�[���𑱂���ɂ͐ڑ����Ȃ����Ă��� Retry ���N���b�N���Ă�������"

!insertmacro PFI_LANG_STRING PFI_LANG_MB_NSISDLFAIL_1      "$G_PLS_FIELD_1 �t�@�C�����_�E�����[�h�ł��܂���ł����B"
!insertmacro PFI_LANG_STRING PFI_LANG_MB_NSISDLFAIL_2      "(�G���[: $G_PLS_FIELD_2)"

!insertmacro PFI_LANG_STRING PFI_LANG_MB_UNPACKFAIL        "$G_PLS_FIELD_1 �t�H���_�ɑ΂���C���X�g�[����ƒ��ɃG���[�����o����܂����B"

!insertmacro PFI_LANG_STRING PFI_LANG_MB_REPEATSSL         "SSL �p�̃t�@�C�����C���X�g�[���ł��܂���ł����B${MB_NL}${MB_NL}�ēx�C���X�g�[�������݂�ɂ́A�u�v���O�����̒ǉ��ƍ폜�v��${MB_NL}${MB_NL}POPFile ${C_POPFILE_MAJOR_VERSION}.${C_POPFILE_MINOR_VERSION}.${C_POPFILE_REVISION}${C_POPFILE_RC} �̍��ڂ��g�p���Ă�������"

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; Get SSL: Strings used when patching SSL.pm from IO::Socket::SSL [getssl.nsh]
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

!insertmacro PFI_LANG_STRING PFI_LANG_SSLPREPAREPATCH      "SSL.pm �� v0.97 �Ƀ_�E���O���[�h���Ă��܂�"
!insertmacro PFI_LANG_STRING PFI_LANG_SSLPATCHSTATUS       "SSL.pm �p�b�`�X�e�[�^�X: $G_PLS_FIELD_2"
!insertmacro PFI_LANG_STRING PFI_LANG_SSLPATCHCOMPLETED    "SSL.pm �t�@�C���� v0.97 �Ƀ_�E���O���[�h����܂���"
!insertmacro PFI_LANG_STRING PFI_LANG_SSLPATCHFAILED       "SSL.pm �t�@�C���� v0.97 �Ƀ_�E���O���[�h����܂���ł���"

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; Get SSL: NSISdl strings (displayed by the plugin which downloads the SSL files) [getssl.nsh]
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;
; The NSISdl plugin (or the Inetc plugin operating in NSISdl-compatible mode)
; shows two progress bars, for example:
;
;     Downloading libeay32.dll
;
;     118kB (14%) of 816kB @ 3.1kB/s (3 minutes remaining)
;
; The default strings used by the plugin:
;
;   downloading - "Downloading %s"
;   connecting  - "Connecting ..."
;   second      - "second"
;   minute      - "minute"
;   hour        - "hour"
;   plural      - "s"
;   progress    - "%dkB (%d%%) of %dkB @ %d.%01dkB/s"
;   remaining   - " (%d %s%s remaining)"
;
; Note that the "remaining" string starts with a space
;
; Some languages might not be translated properly because plurals are formed simply
; by adding the "plural" value, so "hours" is translated by adding the value of the
; "PFI_LANG_NSISDL_PLURAL" string to the value of the "PFI_LANG_NSISDL_HOUR" string.
; This is a limitation of the NSIS plugin which is used to download the files.
;
; If this is a problem, the plural forms could be used for the PFI_LANG_NSISDL_SECOND,
; PFI_LANG_NSISDL_MINUTE and PFI_LANG_NSISDL_HOUR strings and the PFI_LANG_NSISDL_PLURAL
; string set to a space (" ") [using "" here will generate compiler warnings]
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

!insertmacro PFI_LANG_STRING PFI_LANG_NSISDL_DOWNLOADING   "%s�@���_�E�����[�h��"
!insertmacro PFI_LANG_STRING PFI_LANG_NSISDL_CONNECTING    "�ڑ��� ..."
!insertmacro PFI_LANG_STRING PFI_LANG_NSISDL_SECOND        "�b"
!insertmacro PFI_LANG_STRING PFI_LANG_NSISDL_MINUTE        "��"
!insertmacro PFI_LANG_STRING PFI_LANG_NSISDL_HOUR          "����"
!insertmacro PFI_LANG_STRING PFI_LANG_NSISDL_PLURAL        ""
!insertmacro PFI_LANG_STRING PFI_LANG_NSISDL_PROGRESS      "%dkB (%d%%)/%dkB @ %d.%01dkB/s"
!insertmacro PFI_LANG_STRING PFI_LANG_NSISDL_REMAINING     " (�c��%d %s%s )"

###########################################################################
###########################################################################

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; Add User: Standard MUI Page - WELCOME [adduser.nsi]
;
; The PFI_LANG_ADDUSER_INFO_TEXT string should end with a '${IO_NL}${IO_NL}$_CLICK' sequence).
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

!insertmacro PFI_LANG_STRING PFI_LANG_ADDUSER_INFO_TEXT    "���̃E�B�U�[�h�� '$G_WINUSERNAME' ���[�U�[�̂��߂� POPFile �̐ݒ���K�C�h���Ă����܂��B${IO_NL}${IO_NL}���s����O�ɑ��̑S�ẴA�v���P�[�V��������邱�Ƃ𐄏����܂��B${IO_NL}${IO_NL}$_CLICK"

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; Add User: Standard MUI Page - DIRECTORY [adduser.nsi]
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

; $G_WINUSERNAME holds the Windows login name for the user running the wizard

!insertmacro PFI_LANG_STRING PFI_LANG_USERDIR_TITLE        "'$G_WINUSERNAME' �̂��߂� POPFile �f�[�^�̕ۑ���"
!insertmacro PFI_LANG_STRING PFI_LANG_USERDIR_SUBTITLE     "'$G_WINUSERNAME' �̂��߂� POPFile �f�[�^��ۑ�����t�H���_��I��ł��������B"
!insertmacro PFI_LANG_STRING PFI_LANG_USERDIR_TEXT_TOP     "���̃o�[�W������ POPFile �͊e���[�U�[���ƂɈقȂ�f�[�^�t�@�C�����g�p���܂��B${MB_NL}${MB_NL}�Z�b�g�A�b�v�͎��̃t�H���_�� '$G_WINUSERNAME' ���[�U�[�p�� POPFile �f�[�^�̂��߂Ɏg�p���܂��B�ʂ̃t�H���_���g�p����ɂ́A[�Q��] �������đ��̃t�H���_��I��ŉ������B $_CLICK"
!insertmacro PFI_LANG_STRING PFI_LANG_USERDIR_TEXT_DESTN   "'$G_WINUSERNAME' �� POPFile �f�[�^�̕ۑ���"

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; Add User: Standard MUI Page - INSTFILES [adduser.nsi]
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

; Page Title and Sub-title displayed in the page header

!insertmacro PFI_LANG_STRING PFI_LANG_ADDUSER_TITLE        "'$G_WINUSERNAME' ���[�U�[�̂��߂� POPFile �̐ݒ�"
!insertmacro PFI_LANG_STRING PFI_LANG_ADDUSER_SUBTITLE     "POPFile �ݒ�t�@�C�������̃��[�U�[�p�ɃA�b�v�f�[�g���܂��B���΂炭���҂��������B"

; When resetting POPFile to use newly restored 'User Data', change "Install" button to "Restore"

!insertmacro PFI_LANG_STRING PFI_LANG_INST_BTN_RESTORE     "���X�g�A"

; Installation Progress Reports displayed above the progress bar

!insertmacro PFI_LANG_STRING PFI_LANG_INST_PROG_CORPUS     "�R�[�p�X(�P��t�@�C��)�̃o�b�N�A�b�v���쐬���B���΂炭���҂�������..."
!insertmacro PFI_LANG_STRING PFI_LANG_INST_PROG_SQLBACKUP  "�Â� SQLite �f�[�^�x�[�X���o�b�N�A�b�v��..."
!insertmacro PFI_LANG_STRING PFI_LANG_INST_PROG_FINDCORPUS "�t���b�g�t�@�C���܂��� BerkeleyDB �̃R�[�p�X��T���Ă��܂�..."
!insertmacro PFI_LANG_STRING PFI_LANG_INST_PROG_MAKEBAT    "'pfi-run.bat' �o�b�`�t�@�C���𐶐���..."
!insertmacro PFI_LANG_STRING PFI_LANG_INST_PROG_REGSET     "���W�X�g�����Ɗ��ϐ����X�V��..."

; Message Box text strings

; TempTranslationNote: PFI_LANG_MBSTPWDS_A = "POPFile 'stopwords' " + PFI_LANG_MBSTPWDS_1
; TempTranslationNote: PFI_LANG_MBSTPWDS_B = PFI_LANG_MBSTPWDS_2
; TempTranslationNote: PFI_LANG_MBSTPWDS_C = PFI_LANG_MBSTPWDS_3 + " 'stopwords.bak')"
; TempTranslationNote: PFI_LANG_MBSTPWDS_D = PFI_LANG_MBSTPWDS_4 + " 'stopwords.default')"

!insertmacro PFI_LANG_STRING PFI_LANG_MBSTPWDS_A           "POPFile 'stopwords' �͈ȑO�ɃC���X�g�[�����ꂽ�t�@�C���ł��B"
!insertmacro PFI_LANG_STRING PFI_LANG_MBSTPWDS_B           "�A�b�v�f�[�g���Ă���낵���ł����H"
!insertmacro PFI_LANG_STRING PFI_LANG_MBSTPWDS_C           "�A�b�v�f�[�g����ɂ́u�͂��v���N���b�N���ĉ������B(�Â��t�@�C���͎��̖��O�ŕۑ�����܂�: 'stopwords.bak')"
!insertmacro PFI_LANG_STRING PFI_LANG_MBSTPWDS_D           "�Â��t�@�C�����c���ɂ́u�������v���N���b�N���ĉ������B(�V�����t�@�C���͎��̖��O�ŕۑ�����܂�: 'stopwords.default')"

!insertmacro PFI_LANG_STRING PFI_LANG_MBCORPUS_1           "�Â� �R�[�p�X ���o�b�N�A�b�v���ɃG���[��������܂����B"

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; Add User: Message box warnings used when verifying the installation folder chosen by user [adduser.nsi]
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

!insertmacro PFI_LANG_STRING PFI_LANG_DIRSELECT_MBWARN_3   "���̏ꏊ�ɈȑO�̐ݒ�f�[�^��������܂���:"
!insertmacro PFI_LANG_STRING PFI_LANG_DIRSELECT_MBWARN_4   "���X�g�A���ꂽ�ݒ�f�[�^��������܂����B"
!insertmacro PFI_LANG_STRING PFI_LANG_DIRSELECT_MBWARN_5   "���X�g�A���ꂽ�f�[�^���g�p���܂����H"

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; Add User: Custom Page - POPFile Installation Options [adduser.nsi]
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

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

; TempTranslationNote: PFI_LANG_OPTIONS_MBPOP3_A = PFI_LANG_OPTIONS_MBPOP3_1 + " '$G_POP3'."
; TempTranslationNote: PFI_LANG_OPTIONS_MBPOP3_B = PFI_LANG_OPTIONS_MBPOP3_2
; TempTranslationNote: PFI_LANG_OPTIONS_MBPOP3_C = PFI_LANG_OPTIONS_MBPOP3_3

!insertmacro PFI_LANG_STRING PFI_LANG_OPTIONS_MBPOP3_A     "������ POP3 �|�[�g�ԍ�: '$G_POP3'."
!insertmacro PFI_LANG_STRING PFI_LANG_OPTIONS_MBPOP3_B     "�|�[�g�ԍ��ɂ� 1 ���� 65535 �܂ł̔ԍ���I��ŉ������B"
!insertmacro PFI_LANG_STRING PFI_LANG_OPTIONS_MBPOP3_C     "POP3 �|�[�g�ԍ���ύX���ĉ������B"

; TempTranslationNote: PFI_LANG_OPTIONS_MBGUI_A = PFI_LANG_OPTIONS_MBGUI_1 + " '$G_GUI'."
; TempTranslationNote: PFI_LANG_OPTIONS_MBGUI_B = PFI_LANG_OPTIONS_MBGUI_2
; TempTranslationNote: PFI_LANG_OPTIONS_MBGUI_C = PFI_LANG_OPTIONS_MBGUI_3

!insertmacro PFI_LANG_STRING PFI_LANG_OPTIONS_MBGUI_A      "�����ȃ��[�U�[�C���^�[�t�F�[�X�|�[�g�ԍ�: '$G_GUI'."
!insertmacro PFI_LANG_STRING PFI_LANG_OPTIONS_MBGUI_B      "�|�[�g�ԍ��ɂ� 1 ���� 65535 �܂ł̔ԍ���I��ŉ������B"
!insertmacro PFI_LANG_STRING PFI_LANG_OPTIONS_MBGUI_C      "���[�U�[�C���^�[�t�F�[�X�̃|�[�g�ԍ���ύX���ĉ������B"

!insertmacro PFI_LANG_STRING PFI_LANG_OPTIONS_MBDIFF_1     "POP3 �|�[�g�ԍ��ɂ̓��[�U�[�C���^�[�t�F�[�X�̃|�[�g�ԍ��ƈقȂ�ԍ���I��ŉ������B"
!insertmacro PFI_LANG_STRING PFI_LANG_OPTIONS_MBDIFF_2     "�|�[�g�ԍ���ύX���ĉ������B"

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; Add User: Initialization required by POPFile Classification Bucket Creation [adduser.nsi]
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

; POPFile requires at least TWO buckets in order to work properly. PFI_LANG_CBP_DEFAULT_BUCKETS
; defines the default buckets and PFI_LANG_CBP_SUGGESTED_NAMES defines a list of suggested names
; to help the user get started with POPFile. Both lists use the | character as a name separator.

; Bucket names can only use the characters abcdefghijklmnopqrstuvwxyz_-0123456789
; (any names which contain invalid characters will be ignored by the installer)

; Empty lists ("") are allowed (but are not very user-friendly)

; The PFI_LANG_CBP_SUGGESTED_NAMES string uses alphabetic order for the suggested names.
; If these names are translated, the translated names can be rearranged to put them back
; into alphabetic order. For example, the Portuguese (Brazil) translation of this string
; starts "admin|admin-lista|..." (which is "admin|list-admin|..." in English)

!insertmacro PFI_LANG_STRING PFI_LANG_CBP_DEFAULT_BUCKETS  "spam|personal|work|other"
!insertmacro PFI_LANG_STRING PFI_LANG_CBP_SUGGESTED_NAMES  "admin|business|computers|family|financial|general|hobby|inbox|junk|list-admin|miscellaneous|not_spam|other|personal|recreation|school|security|shopping|spam|travel|work"

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; Add User: Custom Page - POPFile Classification Bucket Creation [CBP.nsh]
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

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

; TempTranslationNote: PFI_LANG_CBP_IO_MSG_A = PFI_LANG_CBP_IO_MSG_1
; TempTranslationNote: PFI_LANG_CBP_IO_MSG_B = PFI_LANG_CBP_IO_MSG_2
; TempTranslationNote: PFI_LANG_CBP_IO_MSG_C = PFI_LANG_CBP_IO_MSG_3
; TempTranslationNote: PFI_LANG_CBP_IO_MSG_D = PFI_LANG_CBP_IO_MSG_4 + " $G_PLS_FIELD_1 " + PFI_LANG_CBP_IO_MSG_5

!insertmacro PFI_LANG_STRING PFI_LANG_CBP_IO_MSG_A         "��������ȏ�̃o�P�c�͕K�v����܂���B"
!insertmacro PFI_LANG_STRING PFI_LANG_CBP_IO_MSG_B         "�Œ��̃o�P�c���쐬���ĉ������B"
!insertmacro PFI_LANG_STRING PFI_LANG_CBP_IO_MSG_C         "�Œ������̃o�P�c���K�v�ł��B"
!insertmacro PFI_LANG_STRING PFI_LANG_CBP_IO_MSG_D         "�C���X�g�[���[�́A $G_PLS_FIELD_1 �ȏ�̃o�P�c����邱�Ƃ͂ł��܂���B"

; Message box text strings

; TempTranslationNote: PFI_LANG_CBP_MBDUPERR_A = PFI_LANG_CBP_MBDUPERR_1 + " '$G_PLS_FIELD_1' " + PFI_LANG_CBP_MBDUPERR_2
; TempTranslationNote: PFI_LANG_CBP_MBDUPERR_B = PFI_LANG_CBP_MBDUPERR_3

!insertmacro PFI_LANG_STRING PFI_LANG_CBP_MBDUPERR_A       "�o�P�c '$G_PLS_FIELD_1' �͊��ɍ쐬����Ă��܂��B"
!insertmacro PFI_LANG_STRING PFI_LANG_CBP_MBDUPERR_B       "�V�����o�P�c�ɂ͈Ⴄ���O��I��ŉ������B"

; TempTranslationNote: PFI_LANG_CBP_MBMAXERR_A = PFI_LANG_CBP_MBMAXERR_1 + " $G_PLS_FIELD_1 " + PFI_LANG_CBP_MBMAXERR_2
; TempTranslationNote: PFI_LANG_CBP_MBMAXERR_B = PFI_LANG_CBP_MBMAXERR_3 + " $G_PLS_FIELD_1 " + PFI_LANG_CBP_MBMAXERR_2

!insertmacro PFI_LANG_STRING PFI_LANG_CBP_MBMAXERR_A       "�C���X�g�[���[���쐬�ł���o�P�c�� $G_PLS_FIELD_1 �ł��B"
!insertmacro PFI_LANG_STRING PFI_LANG_CBP_MBMAXERR_B       "�C���X�g�[���I����ɂ��o�P�c���쐬�ł��܂��B���݂̃o�P�c�̌�:$G_PLS_FIELD_1 �ł��B"

; TempTranslationNote: PFI_LANG_CBP_MBNAMERR_A = PFI_LANG_CBP_MBNAMERR_1 + " '$G_PLS_FIELD_1' " + PFI_LANG_CBP_MBNAMERR_2
; TempTranslationNote: PFI_LANG_CBP_MBNAMERR_B = PFI_LANG_CBP_MBNAMERR_3
; TempTranslationNote: PFI_LANG_CBP_MBNAMERR_C = PFI_LANG_CBP_MBNAMERR_4

!insertmacro PFI_LANG_STRING PFI_LANG_CBP_MBNAMERR_A       "�o�P�c��: '$G_PLS_FIELD_1' �͖����Ȗ��O�ł��B"
!insertmacro PFI_LANG_STRING PFI_LANG_CBP_MBNAMERR_B       "�o�P�c�̖��O�ɂ� a ���� z �̏������A0 ���� 9 �̐����A- �܂��� _ ���g�p���ĉ������B"
!insertmacro PFI_LANG_STRING PFI_LANG_CBP_MBNAMERR_C       "�V�����o�P�c�ɂ͈Ⴄ���O��I��ŉ������B"

!insertmacro PFI_LANG_STRING PFI_LANG_CBP_MBCONTERR_1      "POPFile �̓��[���𕪗ނ���̂ɍŒ��̃o�P�c��K�v�Ƃ��܂��B"
!insertmacro PFI_LANG_STRING PFI_LANG_CBP_MBCONTERR_2      "�쐬����o�P�c�̖��O����͂��ĉ������B${MB_NL}${MB_NL}�h���b�v�_�E�����X�g�̗���I�����邩�A${MB_NL}${MB_NL}�K���Ȗ��O����͂��ĉ������B"
!insertmacro PFI_LANG_STRING PFI_LANG_CBP_MBCONTERR_3      "POPFile �̃C���X�g�[���𑱍s����ɂ́A�Œ��̃o�P�c���쐬���Ȃ���΂Ȃ�܂���B"

; TempTranslationNote: PFI_LANG_CBP_MBDONE_A = "$G_PLS_FIELD_1 " + PFI_LANG_CBP_MBDONE_1
; TempTranslationNote: PFI_LANG_CBP_MBDONE_B = PFI_LANG_CBP_MBDONE_2
; TempTranslationNote: PFI_LANG_CBP_MBDONE_C = PFI_LANG_CBP_MBDONE_3

!insertmacro PFI_LANG_STRING PFI_LANG_CBP_MBDONE_A         "$G_PLS_FIELD_1 �̃o�P�c�� POPFile �p�ɍ쐬����܂����B"
!insertmacro PFI_LANG_STRING PFI_LANG_CBP_MBDONE_B         "�����̃o�P�c���g���悤 POPFile ��ݒ肵�Ă���낵���ł����H"
!insertmacro PFI_LANG_STRING PFI_LANG_CBP_MBDONE_C         "�o�P�c�̑I����ύX����ɂ́u�������v���N���b�N���ĉ������B"

; TempTranslationNote: PFI_LANG_CBP_MBMAKERR_A = PFI_LANG_CBP_MBMAKERR_1 + " $G_PLS_FIELD_1 " + PFI_LANG_CBP_MBMAKERR_2 + " $G_PLS_FIELD_2 " + PFI_LANG_CBP_MBMAKERR_3
; TempTranslationNote: PFI_LANG_CBP_MBMAKERR_B = PFI_LANG_CBP_MBMAKERR_4

!insertmacro PFI_LANG_STRING PFI_LANG_CBP_MBMAKERR_A       "�C���X�g�[���[�͑I�����ꂽ�o�P�c��S�č쐬�ł��܂���ł����B�쐬�Ɏ��s�����o�P�c: $G_PLS_FIELD_1 �� / �I�����ꂽ�o�P�c: $G_PLS_FIELD_2 �� "
!insertmacro PFI_LANG_STRING PFI_LANG_CBP_MBMAKERR_B       "�쐬�ł��Ȃ������o�P�c�́APOPFile �̃C���X�g�[�����${MB_NL}${MB_NL}���[�U�[�C���^�[�t�F�[�X(�R���g���[���p�l��)���쐬�ł��܂��B"

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; Add User: Custom Page - Email Client Reconfiguration [adduser.nsi]
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

; Page Title and Sub-title displayed in the page header

!insertmacro PFI_LANG_STRING PFI_LANG_MAILCFG_TITLE        "���[���N���C�A���g�̐ݒ�"
!insertmacro PFI_LANG_STRING PFI_LANG_MAILCFG_SUBTITLE     "�������̃��[���N���C�A���g�ł́A�ݒ�� POPFile �p�ɕύX���邱�Ƃ��ł��܂��B"

; Text displayed on the custom page

!insertmacro PFI_LANG_STRING PFI_LANG_MAILCFG_IO_TEXT_1    "(*) �󂪕t���Ă��郁�[���N���C�A���g�ɂ��ẮA�P���ȃA�J�E���g�ݒ�ł������A�ݒ�������I�ɕύX���邱�Ƃ��ł��܂��B${IO_NL}�F�؂�K�v�Ƃ���A�J�E���g�ɂ��Ă͎蓮�ŕύX���邱�Ƃ������������܂��B"
!insertmacro PFI_LANG_STRING PFI_LANG_MAILCFG_IO_TEXT_2    "�d�v: �����I�ɐݒ�ύX�ł��郁�[���N���C�A���g�ɂ��ẮA�������V���b�g�_�E�����ĉ������B${IO_NL}${IO_NL}���̋@�\�͂܂��J���r���̋@�\�ł��B(�Ⴆ�΂������� Outlook �A�J�E���g�͌��o����Ȃ���������܂���B)${IO_NL}���[���N���C�A���g���g�p����O�ɐݒ�ύX�����܂����������ǂ����m�F���ĉ������B"

!insertmacro PFI_LANG_STRING PFI_LANG_MAILCFG_IO_CANCEL    "���[���N���C�A���g�̐ݒ�ύX�̓L�����Z������܂����B"
!insertmacro PFI_LANG_STRING PFI_LANG_MAILCFG_IO_NOMATCHES "�ݒ�ύX���\�ȃ��[���N���C�A���g��������܂���ł���"

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; Add User: Text used on buttons to skip configuration of email clients [adduser.nsi]
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

!insertmacro PFI_LANG_STRING PFI_LANG_MAILCFG_IO_SKIPALL   "�S�ăX�L�b�v"
!insertmacro PFI_LANG_STRING PFI_LANG_MAILCFG_IO_SKIPONE   "�X�L�b�v"

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; Add User: Message box warnings that an email client is still running [adduser.nsi]
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

!insertmacro PFI_LANG_STRING PFI_LANG_MBCLIENT_EXP         "�x��: Outlook Express ���N�����ł��I"
!insertmacro PFI_LANG_STRING PFI_LANG_MBCLIENT_OUT         "�x��: Outlook ���N�����ł��I"
!insertmacro PFI_LANG_STRING PFI_LANG_MBCLIENT_EUD         "�x��: Eudora ���N�����ł��I"

!insertmacro PFI_LANG_STRING PFI_LANG_MBCLIENT_STOP_1      "���[���N���C�A���g���V���b�g�_�E��������A�u�Ď��s�v�������ĉ������B"
!insertmacro PFI_LANG_STRING PFI_LANG_MBCLIENT_STOP_2      "(�u�����v�������Α��s�ł��܂����A���܂萄�����Ȃ�����ł��B)"
!insertmacro PFI_LANG_STRING PFI_LANG_MBCLIENT_STOP_3      "�u���~�v�������ƃ��[���N���C�A���g�̐ݒ�ύX���X�L�b�v���܂��B"

; Following three strings are used when uninstalling

!insertmacro PFI_LANG_STRING PFI_LANG_MBCLIENT_STOP_4      "���[���N���C�A���g���V���b�g�_�E��������A�u�Ď��s�v���N���b�N���Č��̐ݒ�ɖ߂��ĉ������B"
!insertmacro PFI_LANG_STRING PFI_LANG_MBCLIENT_STOP_5      "(�u�����v���N���b�N����ΐݒ�����ɖ߂��܂����A���̑���͂��܂肨���߂ł��܂���B)"
!insertmacro PFI_LANG_STRING PFI_LANG_MBCLIENT_STOP_6      "�u���~�v���N���b�N���Č��̐ݒ�ɖ߂��ĉ������B"

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; Add User: Custom Page - Reconfigure Outlook/Outlook Express [adduser.nsi]
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

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

!insertmacro PFI_LANG_STRING PFI_LANG_EXPCFG_MBIDENTITY    "Outlook Express ���[�U�[ :"
!insertmacro PFI_LANG_STRING PFI_LANG_EXPCFG_MBACCOUNT     "Outlook Express �A�J�E���g :"

!insertmacro PFI_LANG_STRING PFI_LANG_OUTCFG_MBIDENTITY    "Outlook ���[�U�[ :"
!insertmacro PFI_LANG_STRING PFI_LANG_OUTCFG_MBACCOUNT     "Outlook �A�J�E���g :"

!insertmacro PFI_LANG_STRING PFI_LANG_OOECFG_MBEMAIL       "���[���A�h���X :"
!insertmacro PFI_LANG_STRING PFI_LANG_OOECFG_MBSERVER      "POP3 �T�[�o�[ :"
!insertmacro PFI_LANG_STRING PFI_LANG_OOECFG_MBUSERNAME    "POP3 ���[�U�[�� :"
!insertmacro PFI_LANG_STRING PFI_LANG_OOECFG_MBOEPORT      "POP3 �|�[�g :"
!insertmacro PFI_LANG_STRING PFI_LANG_OOECFG_MBSMTPLOGIN   "SMTP username will be set to ' $G_PLS_FIELD_2'"
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

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; Add User: Custom Page - Reconfigure Eudora [adduser.nsi]
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

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

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; Add User: Custom Page - POPFile can now be started [adduser.nsi]
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

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
!insertmacro PFI_LANG_STRING PFI_LANG_LAUNCH_BANNER_3      "POPFile �͂܂������ł��Ă��܂���"
!insertmacro PFI_LANG_STRING PFI_LANG_LAUNCH_BANNER_4      "POPFile �͂قƂ�Ǐ����ł��Ă��܂�..."

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; Add User: Standard MUI Page - FINISH [adduser.nsi]
;
; The PFI_LANG_FINISH_RUN_TEXT text should be a short phrase (not a long paragraph)
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

; $G_WINUSERNAME holds the Windows login name of the user running the wizard

!insertmacro PFI_LANG_STRING PFI_LANG_ADDUSER_FINISH_INFO "'$G_WINUSERNAME' ���[�U�[�p�� POPFile �̐ݒ��Ƃ͊������܂����B${IO_NL}${IO_NL}���� ���N���b�N���ăE�B�U�[�h����ĉ������B"

!insertmacro PFI_LANG_STRING PFI_LANG_FINISH_RUN_TEXT      "POPFile ���[�U�[�C���^�[�t�F�[�X���N��"
!insertmacro PFI_LANG_STRING PFI_LANG_FINISH_WEB_LINK_TEXT "POPFile �̃z�[���y�[�W���Q�Ƃ���ɂ͂������N���b�N���Ă��������B"

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; Add User: Standard MUI Page - Uninstall Confirmation Page (for the 'Add POPFile User' wizard) [adduser.nsi]
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

; $G_WINUSERNAME holds the Windows login name for the user running the uninstall wizard

!insertmacro PFI_LANG_STRING PFI_LANG_REMUSER_TITLE        "'$G_WINUSERNAME' ���[�U�[�̂��߂� POPFile �f�[�^�̃A���C���X�g�[��"
!insertmacro PFI_LANG_STRING PFI_LANG_REMUSER_SUBTITLE     "���̃��[�U�[�p POPFile �ݒ�f�[�^���R���s���[�^�[����폜���܂��B"

!insertmacro PFI_LANG_STRING PFI_LANG_REMUSER_TEXT_TOP     "'$G_WINUSERNAME' ���[�U�[�p POPFile �ݒ�f�[�^�����̃t�H���_����폜���܂��B $_CLICK"

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; Add User: Standard MUI Page - Uninstallation Page (for the 'Add POPFile User' wizard) [adduser.nsi]
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

; $G_WINUSERNAME holds the Windows login name for the user running the uninstall wizard

!insertmacro PFI_LANG_STRING PFI_LANG_REMOVING_TITLE       "'$G_WINUSERNAME' ���[�U�[�p POPFile �f�[�^�̍폜"
!insertmacro PFI_LANG_STRING PFI_LANG_REMOVING_SUBTITLE    "���̃��[�U�[�� POPFile �ݒ�t�@�C�����폜�����܂ł��΂炭���҂��������B"

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; Add User: Standard MUI Page - UNPAGE_INSTFILES [adduser.nsi]
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

; Uninstall Progress Reports displayed above the progress bar

!insertmacro PFI_LANG_STRING PFI_LANG_UN_PROG_OUTEXPRESS   "Outlook Express �̐ݒ�����ɖ߂��Ă��܂�..."
!insertmacro PFI_LANG_STRING PFI_LANG_UN_PROG_OUTLOOK      "Outlook �̐ݒ�����ɖ߂��Ă��܂�..."
!insertmacro PFI_LANG_STRING PFI_LANG_UN_PROG_EUDORA       "Eudora �̐ݒ�����ɖ߂��Ă��܂�..."
!insertmacro PFI_LANG_STRING PFI_LANG_UN_PROG_DBMSGDIR     "�R�[�p�X �� '�ŋ߂̃��b�Z�[�W' �f�B���N�g�����폜��..."
!insertmacro PFI_LANG_STRING PFI_LANG_UN_PROG_CONFIG       "�ݒ�f�[�^���폜��..."
!insertmacro PFI_LANG_STRING PFI_LANG_UN_PROG_EXESTATUS    "�v���O�����̃X�e�[�^�X���`�F�b�N��..."
!insertmacro PFI_LANG_STRING PFI_LANG_UN_PROG_REGISTRY     "POPFile �̃��W�X�g���G���g���[���폜��..."

; Uninstall Log Messages

!insertmacro PFI_LANG_STRING PFI_LANG_UN_LOG_EXPRUN        "Outlook Express is still running!"
!insertmacro PFI_LANG_STRING PFI_LANG_UN_LOG_OUTRUN        "Outlook is still running!"
!insertmacro PFI_LANG_STRING PFI_LANG_UN_LOG_EUDRUN        "Eudora is still running!"
!insertmacro PFI_LANG_STRING PFI_LANG_UN_LOG_IGNORE        "User requested restore while email program is running"

!insertmacro PFI_LANG_STRING PFI_LANG_UN_LOG_OPENED        "Opened"
!insertmacro PFI_LANG_STRING PFI_LANG_UN_LOG_RESTORED      "Restored"
!insertmacro PFI_LANG_STRING PFI_LANG_UN_LOG_CLOSED        "Closed"
!insertmacro PFI_LANG_STRING PFI_LANG_UN_LOG_DATAPROBS     "Data problems"
!insertmacro PFI_LANG_STRING PFI_LANG_UN_LOG_DELUSERDIR    "Removing all files from POPFile 'User Data' directory"
!insertmacro PFI_LANG_STRING PFI_LANG_UN_LOG_DELUSERERR    "Note: unable to remove all files from POPFile 'User Data' directory"

; Message Box text strings

!insertmacro PFI_LANG_STRING PFI_LANG_UN_MBCLIENT_1        "'Outlook Express' �̖��ł��I"
!insertmacro PFI_LANG_STRING PFI_LANG_UN_MBCLIENT_2        "'Outlook' �̖��ł��I"
!insertmacro PFI_LANG_STRING PFI_LANG_UN_MBCLIENT_3        "'Eudora' �̖��ł��I"

!insertmacro PFI_LANG_STRING PFI_LANG_UN_MBEMAIL_1         "�������̐ݒ�����ɖ߂����Ƃ��ł��܂���ł����B"
!insertmacro PFI_LANG_STRING PFI_LANG_UN_MBEMAIL_2         "�G���[���|�[�g��\�����܂����H"

!insertmacro PFI_LANG_STRING PFI_LANG_UN_MBRERUN_1         "�������̃��[���N���C�A���g�̐ݒ�����ɖ߂����Ƃ��ł��܂���ł����I"
!insertmacro PFI_LANG_STRING PFI_LANG_UN_MBRERUN_2         "(�ڍׂɂ��Ă� $INSTDIR �t�H���_���Q�Ƃ��Ă��������B)"
!insertmacro PFI_LANG_STRING PFI_LANG_UN_MBRERUN_3         "�u�������v ���N���b�N����΃G���[�𖳎����đS�Ă��폜���܂��B"
!insertmacro PFI_LANG_STRING PFI_LANG_UN_MBRERUN_4         "�u�͂��v ���N���b�N����΃f�[�^�͕ۑ�����܂��B(����́A��ł܂��Ď��s���鎞�̂��߂ł��B)"

!insertmacro PFI_LANG_STRING PFI_LANG_UN_MBREMDIR_2        "POPFile ���[�U�[�f�[�^ �f�B���N�g���ȉ��̑S�Ẵt�@�C�����폜���܂����H${MB_NL}${MB_NL}$G_USERDIR${MB_NL}${MB_NL}(�c�������t�@�C��������� �u�������v ���N���b�N���ĉ������B)"

!insertmacro PFI_LANG_STRING PFI_LANG_UN_MBDELMSGS_1       "'�ŋ߂̃��b�Z�[�W' �f�B���N�g�����̑S�Ẵt�@�C�����폜���܂����H"

###########################################################################
###########################################################################

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; Corpus Conversion: Standard MUI Page - INSTFILES [MonitorCC.nsi]
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

!insertmacro PFI_LANG_STRING PFI_LANG_CONVERT_TITLE        "POPFile �R�[�p�X(�P��t�@�C��)�̕ϊ�"
!insertmacro PFI_LANG_STRING PFI_LANG_CONVERT_SUBTITLE     "�C���X�g�[�����悤�Ƃ��Ă���o�[�W������ POPFile �����삷�邽�߂ɂ́A������ �R�[�p�X ��ϊ�����K�v������܂��B"

!insertmacro PFI_LANG_STRING PFI_LANG_ENDCONVERT_TITLE     "POPFile �R�[�p�X�̕ϊ��͊������܂����B"
!insertmacro PFI_LANG_STRING PFI_LANG_ENDCONVERT_SUBTITLE  "���s����ɂ́u����v���N���b�N���ĉ������B"

!insertmacro PFI_LANG_STRING PFI_LANG_BADCONVERT_TITLE     "POPFile �R�[�p�X�̕ϊ��Ɏ��s���܂����B"
!insertmacro PFI_LANG_STRING PFI_LANG_BADCONVERT_SUBTITLE  "���s����ɂ́u�L�����Z���v���N���b�N���ĉ������B"

!insertmacro PFI_LANG_STRING PFI_LANG_CONVERT_MUTEX        "�ʂ� '�R�[�p�X�ϊ����j�^' �����ɋN�����ł��I"
!insertmacro PFI_LANG_STRING PFI_LANG_CONVERT_PRIVATE      "'�R�[�p�X�ϊ����j�^' �� POPFile �C���X�g�[���[�̈ꕔ�ł��B"
!insertmacro PFI_LANG_STRING PFI_LANG_CONVERT_NOFILE       "�G���[: �R�[�p�X�ϊ��f�[�^�t�@�C�������݂��܂���I"
!insertmacro PFI_LANG_STRING PFI_LANG_CONVERT_NOPOPFILE    "�G���[: POPFile �̃p�X��������܂���B"
!insertmacro PFI_LANG_STRING PFI_LANG_CONVERT_STARTERR     "�R�[�p�X�ϊ��̃v���Z�X���N�����ɃG���[���������܂����B"
!insertmacro PFI_LANG_STRING PFI_LANG_CONVERT_FATALERR     "�R�[�p�X�ϊ��̃v���Z�X���ɒv���I�ȃG���[���������܂����I"
!insertmacro PFI_LANG_STRING PFI_LANG_CONVERT_ESTIMATE     "�\�z�c�莞��: "
!insertmacro PFI_LANG_STRING PFI_LANG_CONVERT_MINUTES      "��"
!insertmacro PFI_LANG_STRING PFI_LANG_CONVERT_WAITING      "(�ŏ��̃t�@�C�����ϊ������̂�҂��Ă��܂��B)"
!insertmacro PFI_LANG_STRING PFI_LANG_CONVERT_TOTALFILES   "$G_BUCKET_COUNT �̃o�P�c�t�@�C����ϊ����܂��B"
!insertmacro PFI_LANG_STRING PFI_LANG_CONVERT_PROGRESS_N   "$G_ELAPSED_TIME.$G_DECPLACES ���o�߁B���� $G_STILL_TO_DO �̃t�@�C����ϊ����܂��B"
!insertmacro PFI_LANG_STRING PFI_LANG_CONVERT_PROGRESS_1   "$G_ELAPSED_TIME.$G_DECPLACES ���o�߁B���� 1 �̃t�@�C����ϊ����܂��B"
!insertmacro PFI_LANG_STRING PFI_LANG_CONVERT_SUMMARY      "�R�[�p�X�̕ϊ��ɂ� $G_ELAPSED_TIME.$G_DECPLACES ��������܂����B"

###########################################################################
###########################################################################

#--------------------------------------------------------------------------
# Mark the end of the language data
#--------------------------------------------------------------------------

!undef PFI_LANG

#--------------------------------------------------------------------------
# End of 'Japanese-pfi.nsh'
#--------------------------------------------------------------------------
