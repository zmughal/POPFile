#--------------------------------------------------------------------------
# Korean-pfi.nsh
#
# This file contains additional "Korean" text strings used by the Windows installer
# for POPFile (these strings are unique to POPFile).
#
# See 'Korean-mui.nsh' for the strings which modify standard NSIS MUI messages.
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

!define PFI_LANG  "KOREAN"

#--------------------------------------------------------------------------
# Startup message box offering to display the Release Notes
#--------------------------------------------------------------------------

!insertmacro PFI_LANG_STRING PFI_LANG_MBRELNOTES_1        "POPFile(������) ������ ��Ʈ�� ǥ���ұ��?"
!insertmacro PFI_LANG_STRING PFI_LANG_MBRELNOTES_2        "POPFile�� ���׷��̵��Ͻô� ���̶�� '��' �� �����մϴ�. (��ġ ���� POPFile ������ ����ϼž� �� ���� �ֽ��ϴ�.)"

#--------------------------------------------------------------------------
# Standard MUI Page - Choose Components
#--------------------------------------------------------------------------

!insertmacro PFI_LANG_STRING DESC_SecPOPFile              "POPFile�� �ʿ��� �ٽ� ����(Perl�� �ּҼ�ġ ���� ����)�� ��ġ�մϴ�."
!insertmacro PFI_LANG_STRING DESC_SecSkins                "����� �������̽� ȭ���� ����� �ٲ� �� �ִ� POPFile ��Ų�� ��ġ�մϴ�."
!insertmacro PFI_LANG_STRING DESC_SecLangs                "POPFile �����ȭ���� �ٱ��� ������ ��ġ�մϴ�."

#--------------------------------------------------------------------------
# Custom Page - POPFile Installation Options
#--------------------------------------------------------------------------

; Page Title and Sub-title displayed in the page header

!insertmacro PFI_LANG_STRING PFI_LANG_OPTIONS_TITLE       "POPFile(������) ��ġ �ɼ�"
!insertmacro PFI_LANG_STRING PFI_LANG_OPTIONS_SUBTITLE    "���� �ٲټž� ���� ������ �ٲ��� ���ʽÿ�."

; Text strings displayed on the custom page

!insertmacro PFI_LANG_STRING PFI_LANG_OPTIONS_IO_POP3     "POP3 ������ ���� ����Ʈ ��Ʈ ��ȣ�� �����Ͻʽÿ�(110�� �����մϴ�)."
!insertmacro PFI_LANG_STRING PFI_LANG_OPTIONS_IO_GUI      "'����� ȭ��' ������ ���� ����Ʈ ��Ʈ ��ȣ�� �����Ͻʽÿ�(8080�� �����մϴ�)."
!insertmacro PFI_LANG_STRING PFI_LANG_OPTIONS_IO_STARTUP  "������ ���۽ÿ� �ڵ����� POPFile�� �����մϴ�(��׶���� ����)."
!insertmacro PFI_LANG_STRING PFI_LANG_OPTIONS_IO_WARNING  "���"
!insertmacro PFI_LANG_STRING PFI_LANG_OPTIONS_IO_MESSAGE  "POPFile�� ���׷��̵��Ͻô� ���̶�� �ν��緯�� ���� ������ �����ų ���Դϴ�."

; Message Boxes used when validating user's selections

!insertmacro PFI_LANG_STRING PFI_LANG_OPTIONS_MBUNINST_1    "���� ������ POPFile(������)�� ��ġ�� ���� �����Ǿ����ϴ�."
!insertmacro PFI_LANG_STRING PFI_LANG_OPTIONS_MBUNINST_2    "���ν��� �Ͻðڽ��ϱ�?"
!insertmacro PFI_LANG_STRING PFI_LANG_OPTIONS_MBUNINST_3    "'��' �� ����˴ϴ�."

!insertmacro PFI_LANG_STRING PFI_LANG_OPTIONS_MBPOP3_1    "POP3 ��Ʈ�� ������ �� �����ϴ� - ��Ʈ:"
!insertmacro PFI_LANG_STRING PFI_LANG_OPTIONS_MBPOP3_2    "��Ʈ�� 1���� 65535 ������ ���ڿ��߸� �մϴ�."
!insertmacro PFI_LANG_STRING PFI_LANG_OPTIONS_MBPOP3_3    "POP3 ��Ʈ ������ �����Ͻʽÿ�."

!insertmacro PFI_LANG_STRING PFI_LANG_OPTIONS_MBGUI_1     "'����� ȭ��' ��Ʈ�� ������ �� �����ϴ� - ��Ʈ:"
!insertmacro PFI_LANG_STRING PFI_LANG_OPTIONS_MBGUI_2     "��Ʈ�� 1���� 65535 ������ ���ڿ��߸� �մϴ�."
!insertmacro PFI_LANG_STRING PFI_LANG_OPTIONS_MBGUI_3     "'����� ȭ��' ��Ʈ ������ �����Ͻʽÿ�."

!insertmacro PFI_LANG_STRING PFI_LANG_OPTIONS_MBDIFF_1    "POP3 ��Ʈ�� '����� ȭ��' ��Ʈ�� �ݵ�� �޶�� �մϴ�."
!insertmacro PFI_LANG_STRING PFI_LANG_OPTIONS_MBDIFF_2    "��Ʈ ������ �����Ͻʽÿ�."

; Banner message displayed whilst uninstalling old version

!insertmacro PFI_LANG_STRING PFI_LANG_OPTIONS_BANNER_1     "���� ���� ���� ��"
!insertmacro PFI_LANG_STRING PFI_LANG_OPTIONS_BANNER_2     "���� ���� �ɸ� �� �ֽ��ϴ�..."

#--------------------------------------------------------------------------
# Standard MUI Page - Installing POPfile
#--------------------------------------------------------------------------

; Installation Progress Reports displayed above the progress bar

!insertmacro PFI_LANG_STRING PFI_LANG_INST_PROG_UPGRADE   "���׷��̵� ��ġ���� Ȯ�� ��..."
!insertmacro PFI_LANG_STRING PFI_LANG_INST_PROG_CORE      "POPFile �ٽ� ������ ��ġ ��..."
!insertmacro PFI_LANG_STRING PFI_LANG_INST_PROG_PERL      "Perl �ּ� ��ġ ��..."
!insertmacro PFI_LANG_STRING PFI_LANG_INST_PROG_SHORT     "POPFile �ٷΰ��� ���� ��..."
!insertmacro PFI_LANG_STRING PFI_LANG_INST_PROG_FFCBACK   "Making corpus backup. This may take a few seconds..."
!insertmacro PFI_LANG_STRING PFI_LANG_INST_PROG_SKINS     "POPFile ��Ų ���� ��ġ ��..."
!insertmacro PFI_LANG_STRING PFI_LANG_INST_PROG_LANGS     "POPFile UI ��� ���� ��ġ ��..."
!insertmacro PFI_LANG_STRING PFI_LANG_INST_PROG_ENDSEC    "��� �����ϱ� ���� '����'�� �����ʽÿ�."

; Installation Log Messages

!insertmacro PFI_LANG_STRING PFI_LANG_INST_LOG_1          "���� ������ POPFile�� ���� �� - ��Ʈ:"

; Message Box text strings

!insertmacro PFI_LANG_STRING PFI_LANG_MBSTPWDS_1          "���� ��ġ�� ���� ���� �߰�."
!insertmacro PFI_LANG_STRING PFI_LANG_MBSTPWDS_2          "�� ������ ������Ʈ �Ͻðڽ��ϱ�?"
!insertmacro PFI_LANG_STRING PFI_LANG_MBSTPWDS_3          "'��'�� ������ ������Ʈ�մϴ�. (���� ������ �������� ����� ���Դϴ�:"
!insertmacro PFI_LANG_STRING PFI_LANG_MBSTPWDS_4          "'�ƴϿ�'�� ������ ���� ������ �����մϴ�. (�� ������ �������� ����� ���Դϴ�:"

!insertmacro PFI_LANG_STRING PFI_LANG_MBCFGBK_1           "���:"
!insertmacro PFI_LANG_STRING PFI_LANG_MBCFGBK_2           "�� �̹� �����մϴ�."
!insertmacro PFI_LANG_STRING PFI_LANG_MBCFGBK_3           "�� ������ ���� ���ðڽ��ϱ�?"
!insertmacro PFI_LANG_STRING PFI_LANG_MBCFGBK_4           "'��'�� �����ø� ���� ���ϴ�. '�ƴϿ�'�� �����ø� ����� ������ �ʽ��ϴ�."

#--------------------------------------------------------------------------
# Custom Page - POPFile Classification Bucket Creation
#--------------------------------------------------------------------------

; Page Title and Sub-title displayed in the page header

!insertmacro PFI_LANG_STRING PFI_LANG_CBP_TITLE           "POPFile �з� ��Ŷ ����"
!insertmacro PFI_LANG_STRING PFI_LANG_CBP_SUBTITLE        "POPFile�� ���� �з��� ���� �ּ��� 2���� ��Ŷ�� �ʿ�� �մϴ�."

; Text strings displayed on the custom page

!insertmacro PFI_LANG_STRING PFI_LANG_CBP_IO_INTRO        "�ʿ信 ����, ��ġ �Ŀ��� ��Ŷ ������ �̸��� ���� �ٲٽ� �� �ֽ��ϴ�.\r\n\r\n��Ŷ �̸��� �ݵ�� ���� �ҹ��ڿ� ����, �����°� ������ھ�(_)������ �̷���� �� �ܾ�� �մϴ�."
!insertmacro PFI_LANG_STRING PFI_LANG_CBP_IO_CREATE       "��Ŷ�� �����Ͻʽÿ�. ��� �ٿ� �޴����� ������ ���� �����Ͻðų� ���Ͻô� �̸��� ���� ġ�ʽÿ�."
!insertmacro PFI_LANG_STRING PFI_LANG_CBP_IO_DELETE       "��Ͽ� �ִ� ��Ŷ�� �����Ͻ÷��� '����' üũ�ڽ��� üũǥ�� �Ͻð� '���' ��ư�� Ŭ���Ͻʽÿ�."
!insertmacro PFI_LANG_STRING PFI_LANG_CBP_IO_LISTHDR      "POPFile�� ����� ��Ŷ"
!insertmacro PFI_LANG_STRING PFI_LANG_CBP_IO_REMOVE       "����"
!insertmacro PFI_LANG_STRING PFI_LANG_CBP_IO_CONTINUE     "���"

; Text strings used for status messages under the bucket list

!insertmacro PFI_LANG_STRING PFI_LANG_CBP_IO_MSG_1        "��Ŷ�� �� �߰��� �ʿ�� �����ϴ�."
!insertmacro PFI_LANG_STRING PFI_LANG_CBP_IO_MSG_2        "�ּ��� 2���� ��Ŷ�� �����ؾ� �մϴ�."
!insertmacro PFI_LANG_STRING PFI_LANG_CBP_IO_MSG_3        "��Ŷ�� �ּ��� 1�� �� �ʿ��մϴ�."
!insertmacro PFI_LANG_STRING PFI_LANG_CBP_IO_MSG_4        "�ν��緯�� "
!insertmacro PFI_LANG_STRING PFI_LANG_CBP_IO_MSG_5        "�� �̻��� ��Ŷ�� ������ �� �����ϴ�."

; Message box text strings

!insertmacro PFI_LANG_STRING PFI_LANG_CBP_MBDUPERR_1      " "
!insertmacro PFI_LANG_STRING PFI_LANG_CBP_MBDUPERR_2      "�̶�� ��Ŷ�� �̹� ���ǵǾ����ϴ�. "
!insertmacro PFI_LANG_STRING PFI_LANG_CBP_MBDUPERR_3      "�� ��Ŷ�� �ٸ� �̸��� �ֽʽÿ�."

!insertmacro PFI_LANG_STRING PFI_LANG_CBP_MBMAXERR_1      "�ν��緯�� �ִ� "
!insertmacro PFI_LANG_STRING PFI_LANG_CBP_MBMAXERR_2      "���� ��Ŷ�� ������ �� �ֽ��ϴ�."
!insertmacro PFI_LANG_STRING PFI_LANG_CBP_MBMAXERR_3      "POPFile�� ��ġ�� �Ŀ� �� ���� ��Ŷ�� ������ �� �ֽ��ϴ�"

!insertmacro PFI_LANG_STRING PFI_LANG_CBP_MBNAMERR_1      " "
!insertmacro PFI_LANG_STRING PFI_LANG_CBP_MBNAMERR_2      "��(��) ��ȿ�� ��Ŷ �̸��� �ƴմϴ�."
!insertmacro PFI_LANG_STRING PFI_LANG_CBP_MBNAMERR_3      "��Ŷ �̸��� �ݵ�� ����ҹ��ڿ� ����, �׸��� - �� _ ������ �̷���� �� �ܾ�� �մϴ�."
!insertmacro PFI_LANG_STRING PFI_LANG_CBP_MBNAMERR_4      "�� ��Ŷ�� �ٸ� �̸��� ������ �ֽʽÿ�."

!insertmacro PFI_LANG_STRING PFI_LANG_CBP_MBCONTERR_1     "POPFile�� ���� �з��� �ϱ� ���ؼ��� �ּ��� 2���� ��Ŷ�� �ʿ��մϴ�."
!insertmacro PFI_LANG_STRING PFI_LANG_CBP_MBCONTERR_2     "������ ��Ŷ �̸��� �Է��Ͻʽÿ�-$\r$\n$\r$\n��� �ٿ� �޴����� ������ ���� �����Ͻðų�$\r$\n$\r$\n���Ͻô� �̸��� ���� ġ�ʽÿ�."
!insertmacro PFI_LANG_STRING PFI_LANG_CBP_MBCONTERR_3     "��ġ�� ��� �Ƿ��� �ּ��� 2���� ��Ŷ�� �����ϼž� �մϴ�."

!insertmacro PFI_LANG_STRING PFI_LANG_CBP_MBDONE_1        "���� POPFile�� ����� ��Ŷ�� ���ǵǾ����ϴ�."
!insertmacro PFI_LANG_STRING PFI_LANG_CBP_MBDONE_2        "POPFile�� �� ��Ŷ�� ����ϵ��� �����Ͻðڽ��ϱ�?"
!insertmacro PFI_LANG_STRING PFI_LANG_CBP_MBDONE_3        "��Ŷ ������ �����Ϸ��� '�ƴϿ�'�� Ŭ���Ͻʽÿ�."

!insertmacro PFI_LANG_STRING PFI_LANG_CBP_MBMAKERR_1      "�ν��緯�� ���� ��Ŷ�� ������ �� �������ϴ�:"
!insertmacro PFI_LANG_STRING PFI_LANG_CBP_MBMAKERR_2      "��"
!insertmacro PFI_LANG_STRING PFI_LANG_CBP_MBMAKERR_3      "�� �����Ͻ� ��Ŷ"
!insertmacro PFI_LANG_STRING PFI_LANG_CBP_MBMAKERR_4      "POPFile�� ��ġ�� �� '����� ȭ��'�� �̿��Ͽ� ��Ŷ�� �߰��Ͻ� �� �ֽ��ϴ�.$\r$\n$\r$\n"

#--------------------------------------------------------------------------
# Custom Page - Reconfigure Outlook Express
#--------------------------------------------------------------------------

; Page Title and Sub-title displayed in the page header

!insertmacro PFI_LANG_STRING PFI_LANG_OECFG_TITLE         "�ƿ��� �ͽ������� ������ �����Ͻʽÿ�."
!insertmacro PFI_LANG_STRING PFI_LANG_OECFG_SUBTITLE      "POPFile�� �ƿ��� �ͽ������� ������ �����ص帱 �� �ֽ��ϴ�."

; Text displayed on the custom page

!insertmacro PFI_LANG_STRING PFI_LANG_OECFG_IO_INTRO      "������ ���� �ƿ��� �ͽ������� ���� ������ �߰ߵǾ����ϴ�. POPFile�� �����ǵ��� �ڵ����� ������ ������ �� �ֽ��ϴ�."
!insertmacro PFI_LANG_STRING PFI_LANG_OECFG_IO_CHECKBOX   "�� ������ POPFile�� �����ǵ��� ���� ������"
!insertmacro PFI_LANG_STRING PFI_LANG_OECFG_IO_EMAIL      "���� ���� �ּ�:"
!insertmacro PFI_LANG_STRING PFI_LANG_OECFG_IO_SERVER     "�޴� ����(POP3) ����:"
!insertmacro PFI_LANG_STRING PFI_LANG_OECFG_IO_USERNAME   "���� �̸�:"
!insertmacro PFI_LANG_STRING PFI_LANG_OECFG_IO_RESTORE    "POPFile�� ���ν��� �Ͻø� ���� ������ ������ ���Դϴ�."

!insertmacro PFI_LANG_STRING PFI_LANG_OECFG_IO_LINK_1     "���� ("
!insertmacro PFI_LANG_STRING PFI_LANG_OECFG_IO_LINK_2     ")"

#--------------------------------------------------------------------------
# Custom Page - POPFile can now be started
#--------------------------------------------------------------------------

; Page Title and Sub-title displayed in the page header

!insertmacro PFI_LANG_STRING PFI_LANG_LAUNCH_TITLE        "���� POPFile�� �����Ͻ� �� �ֽ��ϴ�."
!insertmacro PFI_LANG_STRING PFI_LANG_LAUNCH_SUBTITLE     "POPFile ����� ȭ���� POPFile�� ���۵� �Ŀ� ��밡���մϴ�."

; Text displayed on the custom page

!insertmacro PFI_LANG_STRING PFI_LANG_LAUNCH_IO_INTRO     "POPFile�� ���� �����ұ��?"
!insertmacro PFI_LANG_STRING PFI_LANG_LAUNCH_IO_NO        "�ƴϿ� ('����� ȭ��'�� POPFile�� ���۵��� ������ ����� �� �����ϴ�.)"
!insertmacro PFI_LANG_STRING PFI_LANG_LAUNCH_IO_DOSBOX    "POPFile ���� (â����)"
!insertmacro PFI_LANG_STRING PFI_LANG_LAUNCH_IO_BCKGRND   "POPFile�� ��׶��忡�� ���� (â�� ��Ÿ���� �ʽ��ϴ�)"
!insertmacro PFI_LANG_STRING PFI_LANG_LAUNCH_IO_NOTE_1    "POPFile ���۵ǰ� ���� '����� ȭ��'�� ǥ���� �� �ֽ��ϴ�."
!insertmacro PFI_LANG_STRING PFI_LANG_LAUNCH_IO_NOTE_2    " (a) �ý��� Ʈ������ POPFile �������� Ŭ���Ͻðų�,"
!insertmacro PFI_LANG_STRING PFI_LANG_LAUNCH_IO_NOTE_3    " (b) ���� --> ���α׷�(P) --> POPFile --> POPFile User Interface �� �����Ͻʽÿ�."

; Banner message displayed whilst waiting for POPFile to start

!insertmacro PFI_LANG_STRING PFI_LANG_LAUNCH_BANNER_1     "POPFile�� �õ� �غ� ��."
!insertmacro PFI_LANG_STRING PFI_LANG_LAUNCH_BANNER_2     "���� ���� �ɸ� �� �ֽ��ϴ�..."

#--------------------------------------------------------------------------
# Standard MUI Page - Uninstall POPFile
#--------------------------------------------------------------------------

; Uninstall Progress Reports displayed above the progress bar

!insertmacro PFI_LANG_UNSTRING PFI_LANG_PROGRESS_1        "POPFile ���� ��..."
!insertmacro PFI_LANG_UNSTRING PFI_LANG_PROGRESS_2        "'����' �޴� �� POPFile �׸��� ���� ��..."
!insertmacro PFI_LANG_UNSTRING PFI_LANG_PROGRESS_3        "POPFile �ٽ� ������ ���� ��..."
!insertmacro PFI_LANG_UNSTRING PFI_LANG_PROGRESS_4        "�ƿ��� �ͽ������� ������ ���� ��..."
!insertmacro PFI_LANG_UNSTRING PFI_LANG_PROGRESS_5        "POPFile ��Ų ���� ���� ��..."
!insertmacro PFI_LANG_UNSTRING PFI_LANG_PROGRESS_6        "Perl �ּ� ��ġ ���� ���� ��..."

; Uninstall Log Messages

!insertmacro PFI_LANG_UNSTRING PFI_LANG_LOG_1             "POPFile�� ���� �� - ��Ʈ:"
!insertmacro PFI_LANG_UNSTRING PFI_LANG_LOG_2             "����"
!insertmacro PFI_LANG_UNSTRING PFI_LANG_LOG_3             "������"
!insertmacro PFI_LANG_UNSTRING PFI_LANG_LOG_4             "����"
!insertmacro PFI_LANG_UNSTRING PFI_LANG_LOG_5             "POPFile ���丮�� ��� ������ ���� ��."
!insertmacro PFI_LANG_UNSTRING PFI_LANG_LOG_6             "����: POPFile ���丮�κ��� ��� ������ ������ �� �����ϴ�."

; Message Box text strings

!insertmacro PFI_LANG_UNSTRING PFI_LANG_MBNOTFOUND_1      "POPFile�� ���丮�� ��ġ���� ���� �� �����ϴ�."
!insertmacro PFI_LANG_UNSTRING PFI_LANG_MBNOTFOUND_2      "�׷��� ����Ͻðڽ��ϱ�?(�������� ����)"

!insertmacro PFI_LANG_UNSTRING PFI_LANG_ABORT_1           "����ڿ� ���� ���ν����� ��ҵ�"

!insertmacro PFI_LANG_UNSTRING PFI_LANG_MBREMDIR_1        "POPFile ���丮�� ��� ������ �����Ͻðڽ��ϱ�?$\r$\n$\r$\n(���� �����Ͻ� ������ �ְ�, �����ϰ� �����ø� '�ƴϿ�'�� Ŭ���Ͻʽÿ�"

!insertmacro PFI_LANG_UNSTRING PFI_LANG_MBREMERR_1        "����"
!insertmacro PFI_LANG_UNSTRING PFI_LANG_MBREMERR_2        "�� ���ŵ� �� �������ϴ�."

#--------------------------------------------------------------------------
# Mark the end of the language data
#--------------------------------------------------------------------------

!undef PFI_LANG

#--------------------------------------------------------------------------
# End of 'Korean-pfi.nsh'
#--------------------------------------------------------------------------
