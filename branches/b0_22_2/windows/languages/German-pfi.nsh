#--------------------------------------------------------------------------
# German-pfi.nsh
#
# This file contains the "German" text strings used by the Windows installer
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
# Translation created by: Matthias Deege (pfaelzerchen at users.sourceforge.net)
#
# Translation updated by: Matthias Deege (pfaelzerchen at users.sourceforge.net)
# Translation updated by: Manni Heumann (mannih2001 at users.sourceforge.net)
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

!define PFI_LANG  "GERMAN"

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

!insertmacro PFI_LANG_STRING PFI_LANG_BE_PATIENT           "Bitte haben Sie einen Moment Geduld."
!insertmacro PFI_LANG_STRING PFI_LANG_TAKE_A_FEW_SECONDS   "Dies kann einige Sekunden dauern..."

###########################################################################
###########################################################################

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; Shared: Message displayed when wizard does not seem to belong to the current installation [adduser.nsi, runpopfile.nsi]
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

!insertmacro PFI_LANG_STRING PFI_LANG_COMPAT_NOTFOUND      "Fehler: Es konnte keine kompatible Version von ${C_PFI_PRODUCT} gefunden werden!"

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; Shared: Message box shown (before the WELCOME page) if another installer is running [installer.nsi, adduser.nsi]
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

!insertmacro PFI_LANG_STRING PFI_LANG_INSTALLER_MUTEX      "Eine andere Version des POPFile-Installationsprogramms läuft bereits!"

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; Shared: Message box shown if 'SetEnvironmentVariableA' fails [installer.nsi, adduser.nsi, MonitorCC.nsi]
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

!insertmacro PFI_LANG_STRING PFI_LANG_CONVERT_ENVNOTSET    "Fehler: Kann Umgebungsvariable nicht setzen"

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; Shared: Standard MUI Page - DIRECTORY
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

; Used in message box shown if SFN support has been disabled [installer.nsi, adduser.nsi]

!insertmacro PFI_LANG_STRING PFI_LANG_DIRSELECT_MBNOSFN    "Für eine Installation auf Laufwerk '$G_PLS_FIELD_1'${MB_NL}${MB_NL}, wählen Sie bitte einen Ordner, dessen Namen keine Leerzeichen enthält."

; Used in message box shown if existing files found when installing [installer.nsi, adduser.nsi]

!insertmacro PFI_LANG_STRING PFI_LANG_DIRSELECT_MBWARN_2   "Wollen Sie die bestehende Version aktualisieren?"

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; Shared: Standard MUI Page - INSTFILES
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

; When upgrading an existing installation, change the normal "Install" button to "Upgrade" [installer.nsi, adduser.nsi]

!insertmacro PFI_LANG_STRING PFI_LANG_INST_BTN_UPGRADE     "Aktualisieren"

; Installation Progress Reports displayed above the progress bar [installer.nsi, adduser.nsi]

!insertmacro PFI_LANG_STRING PFI_LANG_INST_PROG_UPGRADE    "Suche nach installierten ältere Versionen..."
!insertmacro PFI_LANG_STRING PFI_LANG_INST_PROG_SHORT      "Erzeuge Verknüpfungen..."
!insertmacro PFI_LANG_STRING PFI_LANG_INST_PROG_LANGS      "Installiere Sprachdateien..."

; Installation Progress Reports displayed above the progress bar [installer.nsi, adduser.nsi, getssl.nsh]

!insertmacro PFI_LANG_STRING PFI_LANG_INST_PROG_ENDSEC     "Klicken Sie auf 'Weiter', um fortzufahren"

; Progress Reports displayed above the progress bar when downloading/installing SSL support [addssl.nsi, getssl.nsh]

!insertmacro PFI_LANG_STRING PFI_LANG_PROG_CHECKIFRUNNING  "Prüfe, ob POPFile läuft..."

; Installation Log Messages [installer.nsi, adduser.nsi]

!insertmacro PFI_LANG_STRING PFI_LANG_INST_LOG_SHUTDOWN    "Beende ältere POPFile Version am Port"

; Installation Log Messages [installer.nsi, addssl.nsi]

!insertmacro PFI_LANG_STRING PFI_LANG_PROG_SAVELOG         "Installations-Protokoll wird gespeichert..."

; Message Box text strings [installer.nsi, adduser.nsi, pfi-library.nsh]

!insertmacro PFI_LANG_STRING PFI_LANG_MBMANSHUT_1          "$G_PLS_FIELD_1 kann nicht automatisch beendet werden."
!insertmacro PFI_LANG_STRING PFI_LANG_MBMANSHUT_2          "Bitte beenden Sie $G_PLS_FIELD_1 jetzt manuell."
!insertmacro PFI_LANG_STRING PFI_LANG_MBMANSHUT_3          "Klicken Sie bitte auf 'OK', sobald $G_PLS_FIELD_1 beendet wurde, um die Installation fortzusetzen."

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; Shared: Message box shown if problem detected when trying to save the log file [installer.nsi, addssl.nsi, backup.nsi, restore.nsi]
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

!insertmacro PFI_LANG_STRING PFI_LANG_MB_SAVELOG_ERROR     "Fehler: Protokolldatei konnte nicht gespeichert werden"

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; Shared: Message boxes shown if uninstallation is not straightforward [installer.nsi, adduser.nsi]
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

!insertmacro PFI_LANG_STRING PFI_LANG_UN_MBDIFFUSER_1      "'$G_WINUSERNAME' will die Daten eines anderen Benutzers löschen"

!insertmacro PFI_LANG_STRING PFI_LANG_UN_MBNOTFOUND_1      "POPFile scheint nicht im folgenden Verzeichnis installiert zu sein:"
!insertmacro PFI_LANG_STRING PFI_LANG_UN_MBNOTFOUND_2      "Trotzdem fortfahren (nicht empfohlen)?"

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; Shared: Message box shown if uninstaller is cancelled by the user [installer.nsi, adduser.nsi]
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

!insertmacro PFI_LANG_STRING PFI_LANG_UN_ABORT_1           "Deinstallation vom Anwender abgebrochen"

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; Shared: Standard MUI Page - UNPAGE_INSTFILES [installer.nsi, adduser.nsi]
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

; Uninstall Progress Reports displayed above the progress bar

!insertmacro PFI_LANG_STRING PFI_LANG_UN_PROG_SHUTDOWN     "POPFile beenden..."
!insertmacro PFI_LANG_STRING PFI_LANG_UN_PROG_SHORT        "Startmenü-Einträge von POPFile löschen..."

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; Shared: Message box shown if uninstaller failed to remove files/folders [installer.nsi, adduser.nsi]
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

; TempTranslationNote: PFI_LANG_UN_MBREMERR_A = PFI_LANG_UN_MBREMERR_1 + ": $G_PLS_FIELD_1 " + PFI_LANG_UN_MBREMERR_2

!insertmacro PFI_LANG_STRING PFI_LANG_UN_MBREMERR_A        "Hinweis: $G_PLS_FIELD_1 konnte nicht entfernt werden."

###########################################################################
###########################################################################

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; POPFile Installer: Message box shown (before the WELCOME page) offering to display the release notes [installer.nsi]
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

!insertmacro PFI_LANG_STRING PFI_LANG_MBRELNOTES_1         "Hinweise zu dieser POPFile-Version anzeigen?"
!insertmacro PFI_LANG_STRING PFI_LANG_MBRELNOTES_2         "Falls Sie von einer älteren Version updaten, sollten Sie 'Ja' wählen.${MB_NL}VOR dem Update sollten Sie evtl. Backups anlegen."

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; POPFile Installer: Standard MUI Page - WELCOME [installer.nsi]
;
; The PFI_LANG_WELCOME_INFO_TEXT string should end with a '${IO_NL}${IO_NL}$_CLICK' sequence).
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

!insertmacro PFI_LANG_STRING PFI_LANG_WELCOME_INFO_TEXT    "Dieser Assistent wird Sie durch die Installation von POPFile führen.${IO_NL}${IO_NL}Es wird empfohlen, vor der Installation alle anderen Programme zu schließen.${IO_NL}${IO_NL}$_CLICK"
!insertmacro PFI_LANG_STRING PFI_LANG_WELCOME_ADMIN_TEXT   "ACHTUNG:${IO_NL}${IO_NL}Der aktuell angemeldete Benutzer hat KEINE Administratorrechte.${IO_NL}${IO_NL}Falls Sie Mehrbenutzerunterstützung benötigen, sollten Sie die Installation abbrechen und POPFile unter einem Administratorkonto installieren."

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; POPFile Installer: Custom Page - Check Perl Requirements [installer.nsi]
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

; Page Title displayed in the page header (there is no sub-title for this page)

!insertmacro PFI_LANG_STRING PFI_LANG_PERLREQ_TITLE        "Veraltete Systemkomponenten entdeckt"

; Text strings displayed on the custom page when OS version is too old

!insertmacro PFI_LANG_STRING PFI_LANG_PERLREQ_IO_TXT_OS_1  "A minimal version of Perl is about to be installed (POPFile is written in Perl).${IO_NL}${IO_NL}"
!insertmacro PFI_LANG_STRING PFI_LANG_PERLREQ_IO_TXT_OS_2  "The Perl supplied with POPFile is designed for Windows 2000 or later.${IO_NL}${IO_NL}"
!insertmacro PFI_LANG_STRING PFI_LANG_PERLREQ_IO_TXT_OS_3  "The installer has detected that this system uses Windows $G_PLS_FIELD_1${IO_NL}${IO_NL}"
!insertmacro PFI_LANG_STRING PFI_LANG_PERLREQ_IO_TXT_OS_4  "It is possible that some features of POPFile may not work properly on this system.${IO_NL}${IO_NL}"
!insertmacro PFI_LANG_STRING PFI_LANG_PERLREQ_IO_TXT_OS_5  "It is recommended that you DO NOT install this version of POPFile on this system.${IO_NL}${IO_NL}"
!insertmacro PFI_LANG_STRING PFI_LANG_PERLREQ_IO_TXT_OS_6  "Click here to visit http://getpopfile.org for further help and advice."
!insertmacro PFI_LANG_STRING PFI_LANG_PERLREQ_IO_TXT_OS_7  "http://getpopfile.org/docs/howtos:oldwindows"

; Text strings displayed on the custom page when IE version is too old

!insertmacro PFI_LANG_STRING PFI_LANG_PERLREQ_IO_TXT_IE_1  "Der Standardbrowser wird zum Anzeigen der POPFile Benutzeroberfläche verwendet.${IO_NL}${IO_NL}"
!insertmacro PFI_LANG_STRING PFI_LANG_PERLREQ_IO_TXT_IE_2  "POPFile benötigt keinen speziellen Browser und wird mit fast jedem Browser funktionieren.${IO_NL}${IO_NL}"
!insertmacro PFI_LANG_STRING PFI_LANG_PERLREQ_IO_TXT_IE_3  "Eine minimale Version des Perl-Interpreters wird installiert werden.${IO_NL}${IO_NL}"
!insertmacro PFI_LANG_STRING PFI_LANG_PERLREQ_IO_TXT_IE_4  "Die Perlversion, die von POPFile installiert wird, verwendet einige Komponenten des Internet Explorers und benötigt daher mindestes Internet Explorer 5.5."
!insertmacro PFI_LANG_STRING PFI_LANG_PERLREQ_IO_TXT_IE_5  "Das Installationsprogramm hat festgestellt, dass der Internet Explorer auf diesem System installiert ist $G_PLS_FIELD_1${IO_NL}${IO_NL}"
!insertmacro PFI_LANG_STRING PFI_LANG_PERLREQ_IO_TXT_IE_6  "Es ist möglich, dass einige Funktionen von POPFile auf diesem System nicht korrekt funktionieren.${IO_NL}${IO_NL}"
!insertmacro PFI_LANG_STRING PFI_LANG_PERLREQ_IO_TXT_IE_7  "Falls Sie irgendwelche Probleme mit POPFile haben, versuchen Sie zunächst ein Update auf eine neuere Version des Internet Explorers."

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; POPFile Installer: Standard MUI Page - COMPONENTS [installer.nsi]
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

!insertmacro PFI_LANG_STRING DESC_SecPOPFile               "Installiert die Kernkomponenten inklusive einer Minimalversion des Perl-Interpreters."
!insertmacro PFI_LANG_STRING DESC_SecSkins                 "Installiert POPFile Skins, mit denen Sie die Benutzeroberfläche von POPFile anpassen können."
!insertmacro PFI_LANG_STRING DESC_SecLangs                 "Installiert Unterstützung für weitere (nicht-englische) Sprachen."

!insertmacro PFI_LANG_STRING DESC_SubSecOptional           "Zusätzliche POPFile Komponenten (für fortgeschrittene Benutzer)"
!insertmacro PFI_LANG_STRING DESC_SecIMAP                  "Installiert das POPFile IMAP-Modul"
!insertmacro PFI_LANG_STRING DESC_SecNNTP                  "Installiert POPFiles NNTP-Proxy"
!insertmacro PFI_LANG_STRING DESC_SecSMTP                  "Installiert POPFiles SMTP-Proxy"
!insertmacro PFI_LANG_STRING DESC_SecSOCKS                 "Installiert zusätzliche Perl-Module, die es den POPFile Proxies erlauben, SOCKS zu verwenden"
!insertmacro PFI_LANG_STRING DESC_SecSSL                   "Installiert zusätzliche Perl-Module, mit deren Hilfe POPFile über eine SSL-gesicherte Verbindung mit dem Mail-Server kommunizieren kann."
!insertmacro PFI_LANG_STRING DESC_SecXMLRPC                "Installiert das POPFile XMLRPC-Modul, das Zugriff zum POPFile-API erlaubt, und die benötigten Perl Komponenten"

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; POPFile Installer: Standard MUI Page - DIRECTORY (for POPFile program files) [installer.nsi]
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

; Page Title shown in the page header and Text shown above the box showing the folder selected for the installation

!insertmacro PFI_LANG_STRING PFI_LANG_ROOTDIR_TITLE        "Wählen Sie ein Verzeichnis für die Programminstallation"
!insertmacro PFI_LANG_STRING PFI_LANG_ROOTDIR_TEXT_DESTN   "Zielverzeichnis für die POPFile Programmdateien"

; Message box warnings used when verifying the installation folder chosen by user

!insertmacro PFI_LANG_STRING PFI_LANG_DIRSELECT_MBWARN_1   "Vorhandene Installation gefunden:"

; Text strings used when user has NOT selected a component found in the existing installation

!insertmacro PFI_LANG_STRING MBCOMPONENT_PROB_1            "Möchten Sie die existierende $G_PLS_FIELD_1 Komponente aktualisieren?"
!insertmacro PFI_LANG_STRING MBCOMPONENT_PROB_2            "(die Benutzung veralteter Komponenten kann Probleme verursachen)"

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; POPFile Installer: Custom Page - Setup Summary [installer.nsi]
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

; Page Title and Sub-title displayed in the page header
; $G_WINUSERNAME holds the Windows login name and $G_WINUSERTYPE holds 'Admin', 'Power', 'User', 'Guest' or 'Unknown'

!insertmacro PFI_LANG_STRING PFI_LANG_SUMMARY_TITLE        "Zusammenfassung der Installation für '$G_WINUSERNAME' ($G_WINUSERTYPE)"
!insertmacro PFI_LANG_STRING PFI_LANG_SUMMARY_SUBTITLE     "Diese Einstellungen werden für die Installation von POPFile verwendet werden"

; Display selected installation location and whether or not an upgrade will be performed
; $G_ROOTDIR holds the installation location, e.g. C:\Program Files\POPFile

!insertmacro PFI_LANG_STRING PFI_LANG_SUMMARY_NEWLOCN      "Neue POPFile Installation in $G_PLS_FIELD_2"
!insertmacro PFI_LANG_STRING PFI_LANG_SUMMARY_UPGRADELOCN  "Upgrade der bestehenden POPFile Installation in $G_PLS_FIELD_2"

; By default all of these components are installed (but Kakasi is only installed when Japanese/Nihongo language is chosen)

!insertmacro PFI_LANG_STRING PFI_LANG_SUMMARY_BASICLIST    "Folgende Basiskomponenten werden installiert:"
!insertmacro PFI_LANG_STRING PFI_LANG_SUMMARY_POPFILECORE  "POPFile Programm-Dateien"
!insertmacro PFI_LANG_STRING PFI_LANG_SUMMARY_MINPERL      "Minimal-Perl"
!insertmacro PFI_LANG_STRING PFI_LANG_SUMMARY_DEFAULTSKIN  "Standard-Skin"
!insertmacro PFI_LANG_STRING PFI_LANG_SUMMARY_DEFAULTLANG  "Standard-Sprache"
!insertmacro PFI_LANG_STRING PFI_LANG_SUMMARY_EXTRASKINS   "Zusätzliche Skins"
!insertmacro PFI_LANG_STRING PFI_LANG_SUMMARY_EXTRALANGS   "Zusätzliche Sprachen"
!insertmacro PFI_LANG_STRING PFI_LANG_SUMMARY_KAKASI       "Kakasi-Paket (Unterstützung für Japanisch)"

; By default none of the optional components is installed (user has to select them)

!insertmacro PFI_LANG_STRING PFI_LANG_SUMMARY_OPTIONLIST   "Folgende optionale POPFile Komponenten werden installiert:"
!insertmacro PFI_LANG_STRING PFI_LANG_SUMMARY_NONE         "(keine)"
!insertmacro PFI_LANG_STRING PFI_LANG_SUMMARY_IMAP         "IMAP-Modul"
!insertmacro PFI_LANG_STRING PFI_LANG_SUMMARY_NNTP         "NNTP-Proxy"
!insertmacro PFI_LANG_STRING PFI_LANG_SUMMARY_SMTP         "SMTP-Proxy"
!insertmacro PFI_LANG_STRING PFI_LANG_SUMMARY_SOCKS        "SOCKS-Unterstützung"
!insertmacro PFI_LANG_STRING PFI_LANG_SUMMARY_SSL          "SSL-Unterstützung"
!insertmacro PFI_LANG_STRING PFI_LANG_SUMMARY_XMLRPC       "XMLRPC-Modul"

; The last line in the summary explains how to change the installation selections

!insertmacro PFI_LANG_STRING PFI_LANG_SUMMARY_BACKBUTTON   "Wenn Sie noch Änderungen vornehmen wollen, drücken Sie bitte den 'Zurück'-Knopf"

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; POPFile Installer: Standard MUI Page - INSTFILES [installer.nsi]
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

; Page Title and Sub-title displayed in the page header after installing all the files

!insertmacro PFI_LANG_STRING PFI_LANG_INSTFINISH_TITLE     "Komponenten wurden installiert"
!insertmacro PFI_LANG_STRING PFI_LANG_INSTFINISH_SUBTITLE  "${C_PFI_PRODUCT} muss konfiguriert werden, bevor es benutzt werden kann"

; Installation Progress Reports displayed above the progress bar

!insertmacro PFI_LANG_STRING PFI_LANG_INST_PROG_CORE       "Installiere Basiskomponenten..."
!insertmacro PFI_LANG_STRING PFI_LANG_INST_PROG_PERL       "Installiere Minimal-Perl-Umgebung..."
!insertmacro PFI_LANG_STRING PFI_LANG_INST_PROG_SKINS      "Installiere Skins..."
!insertmacro PFI_LANG_STRING PFI_LANG_INST_PROG_XMLRPC     "Installiere POPFile XMLRPC-Dateien..."

; Message box used to get permission to delete the old minimal Perl before installing the new one

!insertmacro PFI_LANG_STRING PFI_LANG_MINPERL_MBREMOLD     "Soll der komplette Inhalt des alten Minimal-Perl Ordners gelöscht werden, bevor die neue Version installiert wird?${MB_NL}${MB_NL}($G_PLS_FIELD_1)"

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; POPFile Installer: Custom Page - Select uninstaller mode [installer.nsi]
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

; Page Title and Sub-title displayed in the page header of the uninstaller's first page

!insertmacro PFI_LANG_STRING PFI_LANG_UN_MODE_TITLE        "In welchem Modus soll die Deinstallation durchgeführt werden?"
!insertmacro PFI_LANG_STRING PFI_LANG_UN_MODE_SUBTITLE     "Die Installation im Ordner $INSTDIR verändern oder deinstallieren"

; Text for the MODIFY mode radio-button and the label underneath it

!insertmacro PFI_LANG_STRING PFI_LANG_UN_IO_MODE_RADIO     "Die bestehende POPFile Installation verändern"
!insertmacro PFI_LANG_STRING PFI_LANG_UN_IO_MODE_LABEL     "(z.B. SSL-Unterstützung hinzufügen)"

; Text for the UNINSTALL mode radio-button and the label underneath it

!insertmacro PFI_LANG_STRING PFI_LANG_UN_IO_UNINST_RADIO   "POPFile deinstallieren"
!insertmacro PFI_LANG_STRING PFI_LANG_UN_IO_UNINST_LABEL   "(alle POPFile Programmkomponenten entfernen)"

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; POPFile Installer: Standard MUI Page - UNPAGE_DIRECTORY [installer.nsi]
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

; Page Title/Sub-Title shown in the page header

!insertmacro PFI_LANG_STRING PFI_LANG_UN_DIR_TITLE         "Ordner der existierenden POPFile Installation"
!insertmacro PFI_LANG_STRING PFI_LANG_UN_DIR_SUBTITLE      "Hier werden die ausgewählten POPFile Komponenten installiert werden"

; Text explaining what this page shows

!insertmacro PFI_LANG_STRING PFI_LANG_UN_DIR_EXPLANATION   "Das Setup-Programm wird die POPFile-Installation in diesem Ornder ändern und zusätzliche Komponenten hier installieren. Um die Auswahl dieser Komponenten zu verändern, klicken Sie bitte auf den 'Zurück'-Knopf. $_CLICK"

; Text shown above the box showing the folder where the extra components will be installed

!insertmacro PFI_LANG_STRING PFI_LANG_UN_DIR_TEXT_DESTN    "Zielordner für die neuen POPFile-Komponenten"

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; POPFile Installer: Standard MUI Page - UNPAGE_INSTFILES [installer.nsi]
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

; Page Sub-title displayed when MODIFYING the installation (one of the standard MUI strings is used for the Title)

!insertmacro PFI_LANG_STRING PFI_LANG_UN_INST_SUBTITLE     "Bitte warten Sie einen Moment während $(^NameDA) auf den neuesten Stand gebracht wird"

; Page Title and Sub-Title shown instead of the default "Uninstallation complete..." page header

!insertmacro PFI_LANG_STRING PFI_LANG_UN_INST_OK_TITLE     "Hinzufügen/Entfernen erledigt"
!insertmacro PFI_LANG_STRING PFI_LANG_UN_INST_OK_SUBTITLE  "Hinzufügen/Entfernen erfolgreich abgeschlossen."

; Page Title and Sub-Title shown instead of the default "Uninstallation Aborted..." page header

!insertmacro PFI_LANG_STRING PFI_LANG_UN_INST_BAD_TITLE    "Hinzufügen/Entfernen abgebrochen"
!insertmacro PFI_LANG_STRING PFI_LANG_UN_INST_BAD_SUBTITLE "Hinzufügen/Entfernen wurde nicht abgeschlossen."

; Uninstall Progress Reports displayed above the progress bar

!insertmacro PFI_LANG_STRING PFI_LANG_UN_PROG_CORE         "Kernkomponenten löschen..."
!insertmacro PFI_LANG_STRING PFI_LANG_UN_PROG_SKINS        "Skins löschen..."
!insertmacro PFI_LANG_STRING PFI_LANG_UN_PROG_PERL         "Minimal-Perl-Umgebung löschen..."

; Uninstall Log Messages

!insertmacro PFI_LANG_STRING PFI_LANG_UN_LOG_SHUTDOWN      "Beende POPFile an Port"
!insertmacro PFI_LANG_STRING PFI_LANG_UN_LOG_DELROOTDIR    "Alle Dateien im POPFile-Verzeichnis löschen"
!insertmacro PFI_LANG_STRING PFI_LANG_UN_LOG_DELROOTERR    "Hinweis: Es konnten nicht alle Dateien im POPFile-Verzeichnis gelöscht werden"

; Message Box text strings

!insertmacro PFI_LANG_STRING PFI_LANG_UN_MBREMDIR_1        "Wollen Sie alle Dateien im POPFile-Verzeichnis löschen?${MB_NL}${MB_NL}$G_ROOTDIR${MB_NL}${MB_NL}(Wenn Sie selbst dort irgendetwas gespeichert haben, was sie behalten möchten, wählen Sie Nein)"

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; POPFile Installer: Standard MUI Page - UNPAGE_FINISH [installer.nsi]
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

!insertmacro PFI_LANG_STRING PFI_LANG_UN_FINISH_TITLE      "Beende die $(^NameDA) Komponente des Hinzifügen/Entfernen Assistenten"
!insertmacro PFI_LANG_STRING PFI_LANG_UN_FINISH_TEXT       "Klicken Sie auf 'Beenden', um den Assistenten abzuschließen."

###########################################################################
###########################################################################

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; SSL Setup: Standard MUI Page - WELCOME
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

!insertmacro PFI_LANG_STRING PSS_LANG_WELCOME_TITLE        "Willkommen bei $(^NameDA) Assistenten"
!insertmacro PFI_LANG_STRING PSS_LANG_WELCOME_TEXT         "Dieses Hilfsprogramm wird die benötigten Dateien herunterladen und installieren, die POPFile braucht, um über SSL-gesicherte Verbindungen mit Mailservern zu kommunizieren.${IO_NL}${IO_NL}Email-Konten werden nicht verändert werden. Es werden lediglich die für SSL-Verbindungen nötigen Dateien installiert werden.${IO_NL}${IO_NL}Es werden Dateien heruntergeladen und installiert, die vom OpenSSL-Projekt für den Gebrauch des OpenSSL-Toolkit entwickelt wurden (http://www.openssl.org/)${IO_NL}${IO_NL}~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~${IO_NL}${IO_NL}   BITTE BEENDEN SIE POPFILE JETZT${IO_NL}${IO_NL}~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~${IO_NL}${IO_NL}$_CLICK"

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; SSL Setup: Standard MUI Page - LICENSE
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

!insertmacro PFI_LANG_STRING PSS_LANG_LICENSE_SUBHDR       "Bitte sehen Sie sich die Lizenzbedingunden an, bevor Sie $(^NameDA) benutzen."
!insertmacro PFI_LANG_STRING PSS_LANG_LICENSE_BOTTOM       "Wenn Sie mit den Bedingungen einverstanden sind, dann kreuzen Sie bitte das Kästchen unten an. Sie müssen die Bedingungen akzeptieren, um $(^NameDA) zu benutzen. $_CLICK"

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; SSL Setup: Standard MUI Page - DIRECTORY
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

!insertmacro PFI_LANG_STRING PSS_LANG_DESTNDIR_TITLE       "Wählen Sie die bestehende POPFile 0.22 (oder höher) Installation"
!insertmacro PFI_LANG_STRING PSS_LANG_DESTNDIR_SUBTITLE    "SSL-Unterstützung sollte nur zu einer bestehenden POPFile-Installation hinzugefügt werden"
!insertmacro PFI_LANG_STRING PSS_LANG_DESTNDIR_TEXT_TOP    "Die SSL-Unterstützung muss in den gleichen Ordner installiert werden wie das POPFile Programm${MB_NL}${MB_NL}Die SSL-Unterstützung wird zu den POPFile Programmdateien hinzugefügt werden, das im folgenden Ordner installiert ist. Um sie in einen anderen Ordner zu installieren, klicken Sie auf 'Auswählen' und wählen Sie den gewünschten Ordner aus. $_CLICK"
!insertmacro PFI_LANG_STRING PSS_LANG_DESTNDIR_TEXT_DESTN  "Ordner der bestehenden POPFile-Installation (0.22 oder höher)"

!insertmacro PFI_LANG_STRING PSS_LANG_DESTNDIR_MB_WARN_1   "POPFile 0.22 (oder höher) scheint NICHT in ${MB_NL}${MB_NL}$G_PLS_FIELD_1 installiert zu sein."
!insertmacro PFI_LANG_STRING PSS_LANG_DESTNDIR_MB_WARN_2   "Sind Sie sicher, dass Sie diesen Ordner benutzen wollen?"

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; SSL Setup: Standard MUI Page - INSTFILES
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

; Initial page header

!insertmacro PFI_LANG_STRING PSS_LANG_STD_HDR              "Installiere SSL-Unterstützung"
!insertmacro PFI_LANG_STRING PSS_LANG_STD_SUBHDR           "Bitte warten Sie, während die SSL-Unterstützungsdateien heruntergeladen und installiert werden..."

; Successful completion page header

!insertmacro PFI_LANG_STRING PSS_LANG_END_HDR              "POPFile SSL-Unterstützung wurde installiert"
!insertmacro PFI_LANG_STRING PSS_LANG_END_SUBHDR           "Die SSL-Unterstützung für POPFile wurde erfolgreich installiert"

; Unsuccessful completion page header

!insertmacro PFI_LANG_STRING PSS_LANG_ABORT_HDR            "Installation schlug fehl"
!insertmacro PFI_LANG_STRING PSS_LANG_ABORT_SUBHDR         "Der Versuch, die POPFile SSL-Unterstützung zu installieren schlug fehl"

; Progress reports

!insertmacro PFI_LANG_STRING PSS_LANG_PROG_INITIALISE      "Initialisierung..."
!insertmacro PFI_LANG_STRING PSS_LANG_PROG_USERCANCELLED   "Installation vom Benutzer abgebrochen"
!insertmacro PFI_LANG_STRING PSS_LANG_PROG_SUCCESS         "POPFile SSL-Unterstützung wurde installiert"

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; SSL Setup: Standard MUI Page - FINISH
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

!insertmacro PFI_LANG_STRING PSS_LANG_FINISH_TITLE         "Der $(^NameDA) Assistent wird vervollständigt"
!insertmacro PFI_LANG_STRING PSS_LANG_FINISH_TEXT          "SSL-Unterstützung für POPFile wurde installliert.${IO_NL}${IO_NL}Sie können jetzt POPFile starten und für eine SSL-Verbindung konfigurieren.${IO_NL}${IO_NL}Klicken Sie auf 'Fertigstellen', um den Assistenten zu beenden."

!insertmacro PFI_LANG_STRING PSS_LANG_FINISH_README        "Wichtige Information"

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; SSL Setup: Miscellaneous Strings
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

!insertmacro PFI_LANG_STRING PSS_LANG_MUTEX                "Eine andere Instanz des SSL-Setup Assistenten läuft bereits!"

!insertmacro PFI_LANG_STRING PSS_LANG_COMPAT_NOTFOUND      "Warnung: Kann keine kompatible POPFile Version finden!"

!insertmacro PFI_LANG_STRING PSS_LANG_ABORT_WARNING        "Sind sie sicher, dass Sie den $(^NameDA) Assistenten beenden wollen?"

!insertmacro PFI_LANG_STRING PSS_LANG_PREPAREPATCH         "Update von Module.pm (zur Beschleunigung von SSL-Verbindungen)"
!insertmacro PFI_LANG_STRING PSS_LANG_PATCHSTATUS          "Module.pm Patch Status: $G_PLS_FIELD_1"
!insertmacro PFI_LANG_STRING PSS_LANG_PATCHCOMPLETED       "Module.pm-Update beendet"
!insertmacro PFI_LANG_STRING PSS_LANG_PATCHFAILED          "Module.pm wurde nicht verändert"

###########################################################################
###########################################################################

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; Get SSL: Strings used when downloading and installing the optional SSL files [getssl.nsh]
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

; Progress reports

!insertmacro PFI_LANG_STRING PFI_LANG_PROG_STARTDOWNLOAD   "Lade $G_PLS_FIELD_1 von $G_PLS_FIELD_2"
!insertmacro PFI_LANG_STRING PFI_LANG_PROG_FILECOPY        "Kopiere $G_PLS_FIELD_2 Dateien..."
!insertmacro PFI_LANG_STRING PFI_LANG_PROG_FILEEXTRACT     "Extrahiere Dateien aus dem $G_PLS_FIELD_2 Archiv..."

!insertmacro PFI_LANG_STRING PFI_LANG_TAKE_SEVERAL_SECONDS "(diese kann einige Sekunden dauern)"

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; Get SSL: Message Box strings used when installing SSL Support [getssl.nsh]
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

!insertmacro PFI_LANG_STRING PFI_LANG_MB_CHECKINTERNET     "Die Dateien für die SSL-Unterstützung werden aus dem Internet geladen.${MB_NL}${MB_NL}Sie scheinen nicht mit dem Internet verbunden zu sein.${MB_NL}${MB_NL}Bitte stellen Sie eine Internetverbindung her und klicken Sie dann auf 'Wiederholen'"

!insertmacro PFI_LANG_STRING PFI_LANG_MB_NSISDLFAIL_1      "Download der Datei $G_PLS_FIELD_1 schlug fehl"
!insertmacro PFI_LANG_STRING PFI_LANG_MB_NSISDLFAIL_2      "(Fehler: $G_PLS_FIELD_2)"

!insertmacro PFI_LANG_STRING PFI_LANG_MB_UNPACKFAIL        "Fehler bei der Installation in den Ordner $G_PLS_FIELD_1"

!insertmacro PFI_LANG_STRING PFI_LANG_MB_REPEATSSL         "Die Dateien für die SSL-Unterstützung konnten nicht installiert werden!${MB_NL}${MB_NL}Um es noch einmal zu versuchen, benutzen Sie bitte später den Menüpunkt 'Programme hinzufügen/entfernen' ${MB_NL}${MB_NL}für POPFile ${C_POPFILE_MAJOR_VERSION}.${C_POPFILE_MINOR_VERSION}.${C_POPFILE_REVISION}${C_POPFILE_RC}"

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; Get SSL: Strings used when patching SSL.pm from IO::Socket::SSL [getssl.nsh]
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

!insertmacro PFI_LANG_STRING PFI_LANG_SSLPREPAREPATCH      "Downgrade von SSL.pm auf v0.97"
!insertmacro PFI_LANG_STRING PFI_LANG_SSLPATCHSTATUS       "SSL.pm Patch Status: $G_PLS_FIELD_2"
!insertmacro PFI_LANG_STRING PFI_LANG_SSLPATCHCOMPLETED    "SSL.pm wurde auf Version v0.97 geändert"
!insertmacro PFI_LANG_STRING PFI_LANG_SSLPATCHFAILED       "SSL.pm wurde nicht geändert"

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

!insertmacro PFI_LANG_STRING PFI_LANG_NSISDL_DOWNLOADING   "Herunterladen von %s"
!insertmacro PFI_LANG_STRING PFI_LANG_NSISDL_CONNECTING    "Stelle Verbindung her..."
!insertmacro PFI_LANG_STRING PFI_LANG_NSISDL_SECOND        "Sekunde"
!insertmacro PFI_LANG_STRING PFI_LANG_NSISDL_MINUTE        "Minute"
!insertmacro PFI_LANG_STRING PFI_LANG_NSISDL_HOUR          "Stunde"
!insertmacro PFI_LANG_STRING PFI_LANG_NSISDL_PLURAL        "n"
!insertmacro PFI_LANG_STRING PFI_LANG_NSISDL_PROGRESS      "%dkB (%d%%) of %dkB @ %d.%01dkB/s"
!insertmacro PFI_LANG_STRING PFI_LANG_NSISDL_REMAINING     " (%d %s%s verbleiben)"

###########################################################################
###########################################################################

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; Add User: Standard MUI Page - WELCOME [adduser.nsi]
;
; The PFI_LANG_ADDUSER_INFO_TEXT string should end with a '${IO_NL}${IO_NL}$_CLICK' sequence).
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

!insertmacro PFI_LANG_STRING PFI_LANG_ADDUSER_INFO_TEXT    "Dieser Assistent wird Sie durch die Konfiguration von POPFile für den Benutzer '$G_WINUSERNAME' führen.${IO_NL}${IO_NL}Es wird empfohlen, alle anderen Anwendungen zu schließen, bevor Sie fortfahren.${IO_NL}${IO_NL}$_CLICK"

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; Add User: Standard MUI Page - DIRECTORY [adduser.nsi]
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

; $G_WINUSERNAME holds the Windows login name for the user running the wizard

!insertmacro PFI_LANG_STRING PFI_LANG_USERDIR_TITLE        "Wählen Sie das Datenverzeichnis für '$G_WINUSERNAME'"
!insertmacro PFI_LANG_STRING PFI_LANG_USERDIR_SUBTITLE     "Wählen Sie das Verzeichnis, in dem die Daten für '$G_WINUSERNAME' gespeichert werden sollen."
!insertmacro PFI_LANG_STRING PFI_LANG_USERDIR_TEXT_TOP     "Diese Version von POPFile verwendet seperate Datendateien für jeden angemeldeten Benutzer.${MB_NL}${MB_NL}Setup wird das folgende Verzeichnis verwenden, um alle zum Benutzer '$G_WINUSERNAME' gehörenden Daten zu speichern. Um ein anderes Verzeichnis für diesen Benutzer zu verwenden, klicken Sie auf 'Durchsuchen' und wählen Sie ein anderes Verzeichnis. $_CLICK"
!insertmacro PFI_LANG_STRING PFI_LANG_USERDIR_TEXT_DESTN   "Verzeichnis zur Speicherung der POPFile-Daten für '$G_WINUSERNAME'"

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; Add User: Standard MUI Page - INSTFILES [adduser.nsi]
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

; Page Title and Sub-title displayed in the page header

!insertmacro PFI_LANG_STRING PFI_LANG_ADDUSER_TITLE        "Richte POPFile für '$G_WINUSERNAME' ein"
!insertmacro PFI_LANG_STRING PFI_LANG_ADDUSER_SUBTITLE     "Bitte warten Sie, während die Konfigurationsdateien für diesen Benutzer aktualisiert werden."

; When resetting POPFile to use newly restored 'User Data', change "Install" button to "Restore"

!insertmacro PFI_LANG_STRING PFI_LANG_INST_BTN_RESTORE     "Wiederherstellen"

; Installation Progress Reports displayed above the progress bar

!insertmacro PFI_LANG_STRING PFI_LANG_INST_PROG_CORPUS     "Erstelle Korpus Backup. Dies kann einige Sekunden dauern..."
!insertmacro PFI_LANG_STRING PFI_LANG_INST_PROG_SQLBACKUP  "Erstelle Sicherungskopie der alten SQLite Datenbank..."
!insertmacro PFI_LANG_STRING PFI_LANG_INST_PROG_FINDCORPUS "Suche nach vorhandenem nur-Text oder BerkeleyDB Korpus..."
!insertmacro PFI_LANG_STRING PFI_LANG_INST_PROG_MAKEBAT    "Erstelle die 'pfi-run.bat' Batch Datei..."
!insertmacro PFI_LANG_STRING PFI_LANG_INST_PROG_REGSET     "Aktualisieren Registry und Umgebungsvariablen..."

; Message Box text strings

; TempTranslationNote: PFI_LANG_MBSTPWDS_A = "POPFile 'stopwords' " + PFI_LANG_MBSTPWDS_1
; TempTranslationNote: PFI_LANG_MBSTPWDS_B = PFI_LANG_MBSTPWDS_2
; TempTranslationNote: PFI_LANG_MBSTPWDS_C = PFI_LANG_MBSTPWDS_3 + " 'stopwords.bak')"
; TempTranslationNote: PFI_LANG_MBSTPWDS_D = PFI_LANG_MBSTPWDS_4 + " 'stopwords.default')"

!insertmacro PFI_LANG_STRING PFI_LANG_MBSTPWDS_A           "POPFile 'stopwords' Datei einer älteren Version gefunden."
!insertmacro PFI_LANG_STRING PFI_LANG_MBSTPWDS_B           "Diese Datei aktualisieren?"
!insertmacro PFI_LANG_STRING PFI_LANG_MBSTPWDS_C           "Wählen Sie 'Ja', um diese zu aktualisieren (die alte Datei wird gespeichert unter 'stopwords.bak')"
!insertmacro PFI_LANG_STRING PFI_LANG_MBSTPWDS_D           "Wählen Sie 'Nein', um die alte Datei zu behalten (die neue Datei wird gespeichert unter 'stopwords.default')"

!insertmacro PFI_LANG_STRING PFI_LANG_MBCORPUS_1           "Beim Erstellen eines Backups der alten Korpus Dateien ist ein Fehler aufgetreten."

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; Add User: Message box warnings used when verifying the installation folder chosen by user [adduser.nsi]
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

!insertmacro PFI_LANG_STRING PFI_LANG_DIRSELECT_MBWARN_3   "Ältere Konfigurationsdaten gefunden:"
!insertmacro PFI_LANG_STRING PFI_LANG_DIRSELECT_MBWARN_4   "Wiederhergestellte Konfigurationsdaten wurden gefunden"
!insertmacro PFI_LANG_STRING PFI_LANG_DIRSELECT_MBWARN_5   "Möchten Sie die wiederhergestellten Daten verwenden?"

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; Add User: Custom Page - POPFile Installation Options [adduser.nsi]
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

; Page Title and Sub-title displayed in the page header

!insertmacro PFI_LANG_STRING PFI_LANG_OPTIONS_TITLE        "POPFile Installationseinstellungen"
!insertmacro PFI_LANG_STRING PFI_LANG_OPTIONS_SUBTITLE     "Lassen Sie diese Einstellungen unverändert, sofern Sie sie nicht ändern müssen"

; Text strings displayed on the custom page

!insertmacro PFI_LANG_STRING PFI_LANG_OPTIONS_IO_POP3      "Wählen Sie den Standard-Port für POP3-Verbindungen (110 empfohlen)"
!insertmacro PFI_LANG_STRING PFI_LANG_OPTIONS_IO_GUI       "Wählen Sie den Standard-Port für Verbindungen zur Benutzeroberfläche (8080 empfohlen)"
!insertmacro PFI_LANG_STRING PFI_LANG_OPTIONS_IO_STARTUP   "POPFile mit Windows starten"
!insertmacro PFI_LANG_STRING PFI_LANG_OPTIONS_IO_WARNING   "WICHTIGER HINWEIS"
!insertmacro PFI_LANG_STRING PFI_LANG_OPTIONS_IO_MESSAGE   "Wenn Sie POPFile aktualisieren: Setup wird die vorhandene Version beenden, falls diese im Hintergrund läuft"

; Message Boxes used when validating user's selections

; TempTranslationNote: PFI_LANG_OPTIONS_MBPOP3_A = PFI_LANG_OPTIONS_MBPOP3_1 + " '$G_POP3'."
; TempTranslationNote: PFI_LANG_OPTIONS_MBPOP3_B = PFI_LANG_OPTIONS_MBPOP3_2
; TempTranslationNote: PFI_LANG_OPTIONS_MBPOP3_C = PFI_LANG_OPTIONS_MBPOP3_3

!insertmacro PFI_LANG_STRING PFI_LANG_OPTIONS_MBPOP3_A     "Der POP3-Port kann nicht übernommen werden. '$G_POP3'."
!insertmacro PFI_LANG_STRING PFI_LANG_OPTIONS_MBPOP3_B     "Der Port muss eine Zahl zwischen 1 und 65535 sein."
!insertmacro PFI_LANG_STRING PFI_LANG_OPTIONS_MBPOP3_C     "Bitte korrigieren Sie ihre Eingabe für den POP3-Port."

; TempTranslationNote: PFI_LANG_OPTIONS_MBGUI_A = PFI_LANG_OPTIONS_MBGUI_1 + " '$G_GUI'."
; TempTranslationNote: PFI_LANG_OPTIONS_MBGUI_B = PFI_LANG_OPTIONS_MBGUI_2
; TempTranslationNote: PFI_LANG_OPTIONS_MBGUI_C = PFI_LANG_OPTIONS_MBGUI_3

!insertmacro PFI_LANG_STRING PFI_LANG_OPTIONS_MBGUI_A      "Der Port für die Benutzeroberfläche kann nicht übernommen werden. '$G_GUI'."
!insertmacro PFI_LANG_STRING PFI_LANG_OPTIONS_MBGUI_B      "Der Port muss eine Zahl zwischen 1 und 65535 sein."
!insertmacro PFI_LANG_STRING PFI_LANG_OPTIONS_MBGUI_C      "Bitte korrigieren Sie ihre Eingabe für den Port für die Benutzeroberfläche."

!insertmacro PFI_LANG_STRING PFI_LANG_OPTIONS_MBDIFF_1     "POP3-Port und Port für die Benutzeroberfläche dürfen nicht identisch sein."
!insertmacro PFI_LANG_STRING PFI_LANG_OPTIONS_MBDIFF_2     "Bitte ändern Sie ihre Port-Einstellungen."

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

!insertmacro PFI_LANG_STRING PFI_LANG_CBP_DEFAULT_BUCKETS  "spam|persoenlich|arbeit|sonstiges"
!insertmacro PFI_LANG_STRING PFI_LANG_CBP_SUGGESTED_NAMES  "admin|geschaeftlich|computer|familie|finanziell|generell|hobby|inbox|muell|list-admin|vermischtes|kein_spam|anderes|persoenlich|freizeit|schule|sicherheit|einkaufen|spam|reisen|arbeit"

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; Add User: Custom Page - POPFile Classification Bucket Creation [CBP.nsh]
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

; Page Title and Sub-title displayed in the page header

!insertmacro PFI_LANG_STRING PFI_LANG_CBP_TITLE            "POPFile Klassifikationskategorien erstellen"
!insertmacro PFI_LANG_STRING PFI_LANG_CBP_SUBTITLE         "POPFile benötigt MINDESTENS ZWEI Kategorien, um Ihre Emails klassifizieren zu können"

; Text strings displayed on the custom page

!insertmacro PFI_LANG_STRING PFI_LANG_CBP_IO_INTRO         "Nach der Installation können Sie die Anzahl der Kategorien (und deren Name) ohne Probleme an ihre Bedürfnisse anpassen.${IO_NL}${IO_NL}Kategorienamen bestehen aus Kleinbuchstaben, Ziffern von 0 bis 9, Bindestrich oder Unterstrich (keine Umlaute)."
!insertmacro PFI_LANG_STRING PFI_LANG_CBP_IO_CREATE        "Erstellen Sie eine neue Kategorie, indem Sie entweder einen Namen aus der Liste wählen oder einen Namen ihrer Wahl eingeben."
!insertmacro PFI_LANG_STRING PFI_LANG_CBP_IO_DELETE        "Um eine oder mehr Kategorien von der Liste zu löschen, markieren Sie die entsprechenden 'Entfernen' Kästchen und klicken Sie auf 'Weiter'."
!insertmacro PFI_LANG_STRING PFI_LANG_CBP_IO_LISTHDR       "Bereits eingerichtete Kategorien"
!insertmacro PFI_LANG_STRING PFI_LANG_CBP_IO_REMOVE        "Entfernen"
!insertmacro PFI_LANG_STRING PFI_LANG_CBP_IO_CONTINUE      "Weiter"

; Text strings used for status messages under the bucket list

; TempTranslationNote: PFI_LANG_CBP_IO_MSG_A = PFI_LANG_CBP_IO_MSG_1
; TempTranslationNote: PFI_LANG_CBP_IO_MSG_B = PFI_LANG_CBP_IO_MSG_2
; TempTranslationNote: PFI_LANG_CBP_IO_MSG_C = PFI_LANG_CBP_IO_MSG_3
; TempTranslationNote: PFI_LANG_CBP_IO_MSG_D = PFI_LANG_CBP_IO_MSG_4 + " $G_PLS_FIELD_1 " + PFI_LANG_CBP_IO_MSG_5

!insertmacro PFI_LANG_STRING PFI_LANG_CBP_IO_MSG_A         "Sie müssen keine weiteren Kategorien hinzufügen"
!insertmacro PFI_LANG_STRING PFI_LANG_CBP_IO_MSG_B         "Sie müssen mindestens zwei Kategorien angeben"
!insertmacro PFI_LANG_STRING PFI_LANG_CBP_IO_MSG_C         "Mindestens eine weitere Kategorie wird benötigt"
!insertmacro PFI_LANG_STRING PFI_LANG_CBP_IO_MSG_D         "Der Installer kann nicht mehr als $G_PLS_FIELD_1 Kategorien anlegen."

; Message box text strings

; TempTranslationNote: PFI_LANG_CBP_MBDUPERR_A = PFI_LANG_CBP_MBDUPERR_1 + " '$G_PLS_FIELD_1' " + PFI_LANG_CBP_MBDUPERR_2
; TempTranslationNote: PFI_LANG_CBP_MBDUPERR_B = PFI_LANG_CBP_MBDUPERR_3

!insertmacro PFI_LANG_STRING PFI_LANG_CBP_MBDUPERR_A       "Eine Kategorie mit dem Namen '$G_PLS_FIELD_1' wurde bereits angelegt."
!insertmacro PFI_LANG_STRING PFI_LANG_CBP_MBDUPERR_B       "Bitte wählen Sie einen anderen Namen für die neue Kategorie."

; TempTranslationNote: PFI_LANG_CBP_MBMAXERR_A = PFI_LANG_CBP_MBMAXERR_1 + " $G_PLS_FIELD_1 " + PFI_LANG_CBP_MBMAXERR_2
; TempTranslationNote: PFI_LANG_CBP_MBMAXERR_B = PFI_LANG_CBP_MBMAXERR_3 + " $G_PLS_FIELD_1 " + PFI_LANG_CBP_MBMAXERR_2

!insertmacro PFI_LANG_STRING PFI_LANG_CBP_MBMAXERR_A       "Der Installer kann nur bis zu $G_PLS_FIELD_1 Kategorien anlegen."
!insertmacro PFI_LANG_STRING PFI_LANG_CBP_MBMAXERR_B       "Nach der Installation können Sie mehr als $G_PLS_FIELD_1 Kategorien anlegen."

; TempTranslationNote: PFI_LANG_CBP_MBNAMERR_A = PFI_LANG_CBP_MBNAMERR_1 + " '$G_PLS_FIELD_1' " + PFI_LANG_CBP_MBNAMERR_2
; TempTranslationNote: PFI_LANG_CBP_MBNAMERR_B = PFI_LANG_CBP_MBNAMERR_3
; TempTranslationNote: PFI_LANG_CBP_MBNAMERR_C = PFI_LANG_CBP_MBNAMERR_4

!insertmacro PFI_LANG_STRING PFI_LANG_CBP_MBNAMERR_A       "Der Name '$G_PLS_FIELD_1' ist ungültig."
!insertmacro PFI_LANG_STRING PFI_LANG_CBP_MBNAMERR_B       "Kategorienamen können nur Kleinbuchstaben von a bis z, Ziffern von 0 bis 9, - oder _ enthalten (keine Umlaute)"
!insertmacro PFI_LANG_STRING PFI_LANG_CBP_MBNAMERR_C       "Bitte wählen Sie einen anderen Namen für die neue Kategorie."

!insertmacro PFI_LANG_STRING PFI_LANG_CBP_MBCONTERR_1      "POPFile benötigt mindestens ZWEI Kategorien, um ihre Emails klassifizieren zu können."
!insertmacro PFI_LANG_STRING PFI_LANG_CBP_MBCONTERR_2      "Bitte geben Sie den Namen einer zu erstellenden Kategorie ein,${MB_NL}${MB_NL}indem Sie entweder einen der Vorschläge aus der Liste auswählen${MB_NL}${MB_NL}oder indem Sie einen Namen Ihrer Wahl eingeben."
!insertmacro PFI_LANG_STRING PFI_LANG_CBP_MBCONTERR_3      "Sie müssen mindestens ZWEI Kategorien anlegen, bevor Sie die Installation fortsetzen können."

; TempTranslationNote: PFI_LANG_CBP_MBDONE_A = "$G_PLS_FIELD_1 " + PFI_LANG_CBP_MBDONE_1
; TempTranslationNote: PFI_LANG_CBP_MBDONE_B = PFI_LANG_CBP_MBDONE_2
; TempTranslationNote: PFI_LANG_CBP_MBDONE_C = PFI_LANG_CBP_MBDONE_3

!insertmacro PFI_LANG_STRING PFI_LANG_CBP_MBDONE_A         "$G_PLS_FIELD_1 Kategorien zur Nutzung durch POPFile wurden angelegt."
!insertmacro PFI_LANG_STRING PFI_LANG_CBP_MBDONE_B         "Sollen diese Kategorien für POPFile eingerichtet werden?"
!insertmacro PFI_LANG_STRING PFI_LANG_CBP_MBDONE_C         "Wählen Sie 'Nein', wenn Sie Ihre Auswahl korrigieren möchten."

; TempTranslationNote: PFI_LANG_CBP_MBMAKERR_A = PFI_LANG_CBP_MBMAKERR_1 + " $G_PLS_FIELD_1 " + PFI_LANG_CBP_MBMAKERR_2 + " $G_PLS_FIELD_2 " + PFI_LANG_CBP_MBMAKERR_3
; TempTranslationNote: PFI_LANG_CBP_MBMAKERR_B = PFI_LANG_CBP_MBMAKERR_4

!insertmacro PFI_LANG_STRING PFI_LANG_CBP_MBMAKERR_A       "Der Installer konnte $G_PLS_FIELD_1 der $G_PLS_FIELD_2 von Ihnen angegebenen Kategorien nicht einrichten."
!insertmacro PFI_LANG_STRING PFI_LANG_CBP_MBMAKERR_B       "Nach Abschluß der Installation können Sie über die Benutzeroberfläche die fehlende(n) Kategorie(n) nachträglich einrichten."

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; Add User: Custom Page - Email Client Reconfiguration [adduser.nsi]
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

; Page Title and Sub-title displayed in the page header

!insertmacro PFI_LANG_STRING PFI_LANG_MAILCFG_TITLE        "Email Konfiguration"
!insertmacro PFI_LANG_STRING PFI_LANG_MAILCFG_SUBTITLE     "POPFile kann einige Emailprogramme für Sie neu konfigurieren."

; Text displayed on the custom page

!insertmacro PFI_LANG_STRING PFI_LANG_MAILCFG_IO_TEXT_1    "Programme, die mit (*) markiert sind, können automatisch konfiguriert werden - vorausgesetzt, einfache Konten werden verwendet.${IO_NL}${IO_NL}Es wird dringendst empfohlen, Konten, die eine Authentifizierung benötigen, manuell zu konfigurieren."
!insertmacro PFI_LANG_STRING PFI_LANG_MAILCFG_IO_TEXT_2    "WICHTIG: BEENDEN SIE JETZT DIE BETROFFENEN EMAILPROGRAMME!${IO_NL}${IO_NL}Diese Funktion befindet sich noch in Entwicklung (einige Outlook Konten können z.B. nicht gefunden werden).${IO_NL}${IO_NL}Bitte überprüfen Sie, ob die Neukonfiguration erfolgreich war bevor Sie das Emailprogramm verwenden."

!insertmacro PFI_LANG_STRING PFI_LANG_MAILCFG_IO_CANCEL    "Die Konfiguration wurde vom Benutzer abgebrochen"
!insertmacro PFI_LANG_STRING PFI_LANG_MAILCFG_IO_NOMATCHES "Keine geeigneten Emailprogramme gefunden"

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; Add User: Text used on buttons to skip configuration of email clients [adduser.nsi]
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

!insertmacro PFI_LANG_STRING PFI_LANG_MAILCFG_IO_SKIPALL   "Alle überspringen"
!insertmacro PFI_LANG_STRING PFI_LANG_MAILCFG_IO_SKIPONE   "Überspringen"

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; Add User: Message box warnings that an email client is still running [adduser.nsi]
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

!insertmacro PFI_LANG_STRING PFI_LANG_MBCLIENT_EXP         "ACHTUNG: Outlook Express scheint geöffnet zu sein!"
!insertmacro PFI_LANG_STRING PFI_LANG_MBCLIENT_OUT         "ACHTUNG: Outlook scheint geöffnet zu sein!"
!insertmacro PFI_LANG_STRING PFI_LANG_MBCLIENT_EUD         "ACHTUNG: Eudora scheint geöffnet zu sein!"

!insertmacro PFI_LANG_STRING PFI_LANG_MBCLIENT_STOP_1      "Bitte beenden Sie das Emailprogramme. Klicken Sie dann auf 'Wiederholen', um die Konfiguration fortzusetzen."
!insertmacro PFI_LANG_STRING PFI_LANG_MBCLIENT_STOP_2      "(Klicken Sie auf 'Ignorieren', um die Konfiguration trotzdem fortzusetzen. Dies ist nicht empfohlen.)"
!insertmacro PFI_LANG_STRING PFI_LANG_MBCLIENT_STOP_3      "Klicken Sie auf 'Abbrechen', um die Konfiguration für dieses Email Programm zu überspringen."

; Following three strings are used when uninstalling

!insertmacro PFI_LANG_STRING PFI_LANG_MBCLIENT_STOP_4      "Bitte beenden Sie das Emailprogramm. Klicken Sie dann auf 'Wiederholen', um die Einstellungen wiederherzustellen."
!insertmacro PFI_LANG_STRING PFI_LANG_MBCLIENT_STOP_5      "(Klicken Sie auf 'Ignorieren', um die Wiederherstellung trotzdem durchzuführen. Dies ist nicht empfohlen.)"
!insertmacro PFI_LANG_STRING PFI_LANG_MBCLIENT_STOP_6      "Klicken Sie auf 'Abbrechen', um die Wiederherstellung der Originaleinstellungen zu überspringen."

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; Add User: Custom Page - Reconfigure Outlook/Outlook Express [adduser.nsi]
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

; Page Title and Sub-title displayed in the page header

!insertmacro PFI_LANG_STRING PFI_LANG_EXPCFG_TITLE         "Outlook Express konfigurieren"
!insertmacro PFI_LANG_STRING PFI_LANG_EXPCFG_SUBTITLE      "POPFile kann Outlook Express automatisch zur Nutzung mit POPFile konfigurieren"

!insertmacro PFI_LANG_STRING PFI_LANG_OUTCFG_TITLE         "Outlook konfigurieren"
!insertmacro PFI_LANG_STRING PFI_LANG_OUTCFG_SUBTITLE      "POPFile kann Outlook automatisch zur Nutzung mit POPFile konfigurieren"

; Text displayed on the custom page

!insertmacro PFI_LANG_STRING PFI_LANG_EXPCFG_IO_CANCELLED  "Outlook Express Konfiguration vom Benutzer abgebrochen"
!insertmacro PFI_LANG_STRING PFI_LANG_OUTCFG_IO_CANCELLED  "Outlook Konfiguration vom Benutzer abgebrochen"

!insertmacro PFI_LANG_STRING PFI_LANG_OOECFG_IO_BOXHDR     "Konten"
!insertmacro PFI_LANG_STRING PFI_LANG_OOECFG_IO_ACCOUNTHDR "Konto"
!insertmacro PFI_LANG_STRING PFI_LANG_OOECFG_IO_EMAILHDR   "Email Adresse"
!insertmacro PFI_LANG_STRING PFI_LANG_OOECFG_IO_SERVERHDR  "Server"
!insertmacro PFI_LANG_STRING PFI_LANG_OOECFG_IO_USRNAMEHDR "Benutzername"
!insertmacro PFI_LANG_STRING PFI_LANG_OOECFG_IO_FOOTNOTE   "Markieren Sie die Kästchen der Konten, die neu konfiguriert werden sollen.${IO_NL}Wenn Sie POPFile deinstallieren, werden die alten Einstellungen wiederhergestellt."

; Message Box to confirm changes to Outlook/Outlook Express account configuration

!insertmacro PFI_LANG_STRING PFI_LANG_EXPCFG_MBIDENTITY    "Outlook Express Identität:"
!insertmacro PFI_LANG_STRING PFI_LANG_EXPCFG_MBACCOUNT     "Outlook Express Konto:"

!insertmacro PFI_LANG_STRING PFI_LANG_OUTCFG_MBIDENTITY    "Outlook Benutzer:"
!insertmacro PFI_LANG_STRING PFI_LANG_OUTCFG_MBACCOUNT     "Outlook Konto:"

!insertmacro PFI_LANG_STRING PFI_LANG_OOECFG_MBEMAIL       "Email Adresse:"
!insertmacro PFI_LANG_STRING PFI_LANG_OOECFG_MBSERVER      "POP3 Server:"
!insertmacro PFI_LANG_STRING PFI_LANG_OOECFG_MBUSERNAME    "POP3 Benutzername:"
!insertmacro PFI_LANG_STRING PFI_LANG_OOECFG_MBOEPORT      "POP3 Port:"
!insertmacro PFI_LANG_STRING PFI_LANG_OOECFG_MBSMTPLOGIN   "SMTP Benutzername wird auf '$G_PLS_FIELD_2' gesetzt"
!insertmacro PFI_LANG_STRING PFI_LANG_OOECFG_MBOLDVALUE    "aktuell"
!insertmacro PFI_LANG_STRING PFI_LANG_OOECFG_MBQUESTION    "Konto zur Nutzung mit POPFile konfigurieren?"

; Title and Column headings for report/log files

!insertmacro PFI_LANG_STRING PFI_LANG_EXPCFG_LOG_BEFORE    "Outlook Express Einstellungen bisher"
!insertmacro PFI_LANG_STRING PFI_LANG_EXPCFG_LOG_AFTER     "Änderungen, die an den Outlook Express Einstellungen vorgenommen werden"

!insertmacro PFI_LANG_STRING PFI_LANG_OUTCFG_LOG_BEFORE    "Outlook Einstellungen bisher"
!insertmacro PFI_LANG_STRING PFI_LANG_OUTCFG_LOG_AFTER     "Ändeurngen, die an den Outlook Einstellungen vorgenommen werden"

!insertmacro PFI_LANG_STRING PFI_LANG_OOECFG_LOG_END       "(Ende)"

!insertmacro PFI_LANG_STRING PFI_LANG_EXPCFG_LOG_IDENTITY  "'IDENTITÄT'"
!insertmacro PFI_LANG_STRING PFI_LANG_OUTCFG_LOG_IDENTITY  "'OUTLOOK BENUTZER'"

!insertmacro PFI_LANG_STRING PFI_LANG_OOECFG_LOG_ACCOUNT   "'KONTO'"

!insertmacro PFI_LANG_STRING PFI_LANG_OOECFG_LOG_EMAIL     "'EMAIL ADRESSE'"
!insertmacro PFI_LANG_STRING PFI_LANG_OOECFG_LOG_SERVER    "'POP3 SERVER'"
!insertmacro PFI_LANG_STRING PFI_LANG_OOECFG_LOG_USER      "'POP3 BENUTZERNAME'"
!insertmacro PFI_LANG_STRING PFI_LANG_OOECFG_LOG_PORT      "'POP3 PORT'"

!insertmacro PFI_LANG_STRING PFI_LANG_OOECFG_LOG_NEWSERVER "'NEUER POP3 SERVER'"
!insertmacro PFI_LANG_STRING PFI_LANG_OOECFG_LOG_NEWUSER   "'NEUER POP3 BENUTZERNAME'"
!insertmacro PFI_LANG_STRING PFI_LANG_OOECFG_LOG_NEWPORT   "'NEUER POP3 PORT'"

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; Add User: Custom Page - Reconfigure Eudora [adduser.nsi]
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

; Page Title and Sub-title displayed in the page header

!insertmacro PFI_LANG_STRING PFI_LANG_EUCFG_TITLE          "Eudora konfigurieren"
!insertmacro PFI_LANG_STRING PFI_LANG_EUCFG_SUBTITLE       "POPFile kann Eudora automatisch zur Nutzung mit POPFile konfigurieren"

; Text displayed on the custom page

!insertmacro PFI_LANG_STRING PFI_LANG_EUCFG_IO_CANCELLED   "Eudora Konfiguration vom Benutzer abgebrochen"

!insertmacro PFI_LANG_STRING PFI_LANG_EUCFG_IO_INTRO_1     "POPFile hat die folgenden Eudorabenutzer entdeckt"
!insertmacro PFI_LANG_STRING PFI_LANG_EUCFG_IO_INTRO_2     "und kann diese automatisch für die Benutzung mit POPFile konfigurieren."
!insertmacro PFI_LANG_STRING PFI_LANG_EUCFG_IO_CHECKBOX    "Diesen Benutzer für POPFile einrichten"
!insertmacro PFI_LANG_STRING PFI_LANG_EUCFG_IO_DOMINANT    "<Dominant> personality"
!insertmacro PFI_LANG_STRING PFI_LANG_EUCFG_IO_PERSONA     "Benutzer"
!insertmacro PFI_LANG_STRING PFI_LANG_EUCFG_IO_EMAIL       "Email Adresse:"
!insertmacro PFI_LANG_STRING PFI_LANG_EUCFG_IO_SERVER      "POP3 Server:"
!insertmacro PFI_LANG_STRING PFI_LANG_EUCFG_IO_USERNAME    "POP3 Benutzername:"
!insertmacro PFI_LANG_STRING PFI_LANG_EUCFG_IO_POP3PORT    "POP3 Port:"
!insertmacro PFI_LANG_STRING PFI_LANG_EUCFG_IO_RESTORE     "Wenn Sie POPFile deinstallieren, werden die alten Einstellungen wiederhergestellt"

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; Add User: Custom Page - POPFile can now be started [adduser.nsi]
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

; Page Title and Sub-title displayed in the page header

!insertmacro PFI_LANG_STRING PFI_LANG_LAUNCH_TITLE         "POPFile kann nun gestartet werden"
!insertmacro PFI_LANG_STRING PFI_LANG_LAUNCH_SUBTITLE      "Die POPFile Benutzeroberfläche funktioniert nur, wenn POPFile gestartet wurde"

; Text displayed on the custom page

!insertmacro PFI_LANG_STRING PFI_LANG_LAUNCH_IO_INTRO      "POPFile jetzt starten?"
!insertmacro PFI_LANG_STRING PFI_LANG_LAUNCH_IO_NO         "Nein (Die Benutzeroberfläche kann bis zum Start von POPFile nicht verwendet werden)"
!insertmacro PFI_LANG_STRING PFI_LANG_LAUNCH_IO_DOSBOX     "POPFile starten (in einem Fenster)"
!insertmacro PFI_LANG_STRING PFI_LANG_LAUNCH_IO_BCKGRND    "POPFile im Hintergrund starten (kein Fenster anzeigen)"
!insertmacro PFI_LANG_STRING PFI_LANG_LAUNCH_IO_NOICON     "POPFile ohne Symbol im Infobereich starten"
!insertmacro PFI_LANG_STRING PFI_LANG_LAUNCH_IO_TRAYICON   "POPFile mit Symbol im Infobereich starten"
!insertmacro PFI_LANG_STRING PFI_LANG_LAUNCH_IO_NOTE_1     "Wenn POPFile gestartet wurde, können Sie die Benutzeroberfläche aufrufen, indem"
!insertmacro PFI_LANG_STRING PFI_LANG_LAUNCH_IO_NOTE_2     "(a) Sie auf das POPFile-Symbol neben der Uhr doppelklicken oder indem"
!insertmacro PFI_LANG_STRING PFI_LANG_LAUNCH_IO_NOTE_3     "(b) Sie Start --> Programme --> POPFile --> POPFile User Interface wählen."

; Banner message displayed whilst waiting for POPFile to start

!insertmacro PFI_LANG_STRING PFI_LANG_LAUNCH_BANNER_1      "Start von POPFile vorbereiten."
!insertmacro PFI_LANG_STRING PFI_LANG_LAUNCH_BANNER_2      "Dies kann einige Sekunden dauern..."

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; Add User: Standard MUI Page - FINISH [adduser.nsi]
;
; The PFI_LANG_FINISH_RUN_TEXT text should be a short phrase (not a long paragraph)
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

; $G_WINUSERNAME holds the Windows login name of the user running the wizard

!insertmacro PFI_LANG_STRING PFI_LANG_ADDUSER_FINISH_INFO "POPFile wurde für '$G_WINUSERNAME' eingerichtet.${IO_NL}${IO_NL}Klicken sie auf 'Fertigstellen', um diesen Assistenten zu beenden.."

!insertmacro PFI_LANG_STRING PFI_LANG_FINISH_RUN_TEXT      "POPFile Benutzeroberfläche"
!insertmacro PFI_LANG_STRING PFI_LANG_FINISH_WEB_LINK_TEXT "Klicken Sie hier, um die POPFile Webseite zu besuchen"

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; Add User: Standard MUI Page - Uninstall Confirmation Page (for the 'Add POPFile User' wizard) [adduser.nsi]
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

; $G_WINUSERNAME holds the Windows login name for the user running the uninstall wizard

!insertmacro PFI_LANG_STRING PFI_LANG_REMUSER_TITLE        "Deinstalliere alle POPFile-Daten für den Benutzer '$G_WINUSERNAME'"
!insertmacro PFI_LANG_STRING PFI_LANG_REMUSER_SUBTITLE     "Lösche POPFile Konfigurationsdaten für diesen Benutzer von Ihrem Computer."

!insertmacro PFI_LANG_STRING PFI_LANG_REMUSER_TEXT_TOP     "Die POPFile Konfigurationsdaten für '$G_WINUSERNAME' werden aus dem folgenden Verzeichnis gelöscht. $_CLICK"

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; Add User: Standard MUI Page - Uninstallation Page (for the 'Add POPFile User' wizard) [adduser.nsi]
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

; $G_WINUSERNAME holds the Windows login name for the user running the uninstall wizard

!insertmacro PFI_LANG_STRING PFI_LANG_REMOVING_TITLE       "Deinstalliere POPFile-Daten für den Benutzer '$G_WINUSERNAME'"
!insertmacro PFI_LANG_STRING PFI_LANG_REMOVING_SUBTITLE    "Bitten warten Sie, während die Konfiguratoinsdateien für diesen Benutzer gelöscht werden."

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; Add User: Standard MUI Page - UNPAGE_INSTFILES [adduser.nsi]
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

; Uninstall Progress Reports displayed above the progress bar

!insertmacro PFI_LANG_STRING PFI_LANG_UN_PROG_OUTEXPRESS   "Outlook Express Einstellungen wiederherstellen..."
!insertmacro PFI_LANG_STRING PFI_LANG_UN_PROG_OUTLOOK      "Outlook Einstellungen wiederherstellen..."
!insertmacro PFI_LANG_STRING PFI_LANG_UN_PROG_EUDORA       "Eudora Einstellungen wiederherstellen..."
!insertmacro PFI_LANG_STRING PFI_LANG_UN_PROG_DBMSGDIR     "Lösche Korpus und Nachrichten-Historie..."
!insertmacro PFI_LANG_STRING PFI_LANG_UN_PROG_CONFIG       "Lösche Konfigurationsdateien..."
!insertmacro PFI_LANG_STRING PFI_LANG_UN_PROG_EXESTATUS    "Überprüfe Programm-Status..."
!insertmacro PFI_LANG_STRING PFI_LANG_UN_PROG_REGISTRY     "Lösche POPFile Registry Einträge..."

; Uninstall Log Messages

!insertmacro PFI_LANG_STRING PFI_LANG_UN_LOG_EXPRUN        "Outlook Express läuft noch!"
!insertmacro PFI_LANG_STRING PFI_LANG_UN_LOG_OUTRUN        "Outlook läuft noch!"
!insertmacro PFI_LANG_STRING PFI_LANG_UN_LOG_EUDRUN        "Eudora läuft noch!"
!insertmacro PFI_LANG_STRING PFI_LANG_UN_LOG_IGNORE        "User requested restore while email program is running"

!insertmacro PFI_LANG_STRING PFI_LANG_UN_LOG_OPENED        "Geöffnet"
!insertmacro PFI_LANG_STRING PFI_LANG_UN_LOG_RESTORED      "Wiederhergestellt"
!insertmacro PFI_LANG_STRING PFI_LANG_UN_LOG_CLOSED        "Geschlossen"
!insertmacro PFI_LANG_STRING PFI_LANG_UN_LOG_DATAPROBS     "Datenprobleme"
!insertmacro PFI_LANG_STRING PFI_LANG_UN_LOG_DELUSERDIR    "Lösche alle Dateien aus dem POPFile Benutzerdaten-VerzeichnisRemoving all files from POPFile 'User Data' directory"
!insertmacro PFI_LANG_STRING PFI_LANG_UN_LOG_DELUSERERR    "HINWEIS: Nicht alle Dateien konnten aus den Benutzerdaten-Verzeichnis gelöscht werden"

; Message Box text strings

!insertmacro PFI_LANG_STRING PFI_LANG_UN_MBCLIENT_1        "'Outlook Express' Problem!"
!insertmacro PFI_LANG_STRING PFI_LANG_UN_MBCLIENT_2        "'Outlook' Problem!"
!insertmacro PFI_LANG_STRING PFI_LANG_UN_MBCLIENT_3        "'Eudora' Problem!"

!insertmacro PFI_LANG_STRING PFI_LANG_UN_MBEMAIL_1         "Kann Originaleinstellungen nicht wiederherstellen"
!insertmacro PFI_LANG_STRING PFI_LANG_UN_MBEMAIL_2         "Fehlerbericht anzeigen?"

!insertmacro PFI_LANG_STRING PFI_LANG_UN_MBRERUN_1         "Einige Emailprogrammeinstellungen konnten nicht wiederhergestellt werden!"
!insertmacro PFI_LANG_STRING PFI_LANG_UN_MBRERUN_2         "(Details: siehe $INSTDIR Verzeichnis)"
!insertmacro PFI_LANG_STRING PFI_LANG_UN_MBRERUN_3         "Klicken Sie auf 'Nein', um diese Fehler zu ignorieren und alles zu löschen"
!insertmacro PFI_LANG_STRING PFI_LANG_UN_MBRERUN_4         "Klicken Sie auf 'Ja', um diese Daten zu behalten (und einen späteren Versuch zu ermöglichen)"

!insertmacro PFI_LANG_STRING PFI_LANG_UN_MBREMDIR_2        "Wollen Sie alle Dateien im Benutzerdatenverzeichnis löschen?${MB_NL}${MB_NL}$G_USERDIR${MB_NL}${MB_NL}(Wenn Sie hier irgendetwas gespeichert haben, was Sie behalten möchten, wählen Sie 'Nein')"

!insertmacro PFI_LANG_STRING PFI_LANG_UN_MBDELMSGS_1       "Möchten Sie alle Dateien aus der Liste der 'Aktuellen Nachrichten' entfernen?"

###########################################################################
###########################################################################

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; Corpus Conversion: Standard MUI Page - INSTFILES [MonitorCC.nsi]
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

!insertmacro PFI_LANG_STRING PFI_LANG_CONVERT_TITLE        "POPFile Korpus-Konvertierung"
!insertmacro PFI_LANG_STRING PFI_LANG_CONVERT_SUBTITLE     "Der bestehende Korpus muss konvertiert werden, um mit der neuen Version von POPFile verwendet werden zu können."

!insertmacro PFI_LANG_STRING PFI_LANG_ENDCONVERT_TITLE     "POPFile Korpus-Konvertierung abgeschlossen"
!insertmacro PFI_LANG_STRING PFI_LANG_ENDCONVERT_SUBTITLE  "Bitte klicken Sie Beenden, um fortzufahren."

!insertmacro PFI_LANG_STRING PFI_LANG_BADCONVERT_TITLE     "POPFile Korpus: Konvertierung fehlgeschlagen"
!insertmacro PFI_LANG_STRING PFI_LANG_BADCONVERT_SUBTITLE  "Bitte klicken Sie auf Abbrechen, um fortzufahren."

!insertmacro PFI_LANG_STRING PFI_LANG_CONVERT_MUTEX        "Eine andere Version der Korpus Konvertierung läuft bereits!"
!insertmacro PFI_LANG_STRING PFI_LANG_CONVERT_PRIVATE      "Die 'Korpus Konvertierung' ist Teil des POPFile Installationsprogramms"
!insertmacro PFI_LANG_STRING PFI_LANG_CONVERT_NOFILE       "Fehler: Konvertierungsdatendatei existiert nicht!"
!insertmacro PFI_LANG_STRING PFI_LANG_CONVERT_NOPOPFILE    "Fehler: POPFile Pfad nicht gefunden"
!insertmacro PFI_LANG_STRING PFI_LANG_CONVERT_STARTERR     "Ein Fehler ist beim Start des Konvertierungsprozesses aufgetreten"
!insertmacro PFI_LANG_STRING PFI_LANG_CONVERT_FATALERR     "Ein schwerer Fehler ist während der Konvertierung des Korpus aufgetreten!"
!insertmacro PFI_LANG_STRING PFI_LANG_CONVERT_ESTIMATE     "Geschätzte Wartezeit: "
!insertmacro PFI_LANG_STRING PFI_LANG_CONVERT_MINUTES      "Minuten"
!insertmacro PFI_LANG_STRING PFI_LANG_CONVERT_WAITING      "(warte auf Konvertierung der ersten Datei)"
!insertmacro PFI_LANG_STRING PFI_LANG_CONVERT_TOTALFILES   "Es müssen insgesamt $G_BUCKET_COUNT Dateien konvertiert werden"
!insertmacro PFI_LANG_STRING PFI_LANG_CONVERT_PROGRESS_N   "Nach $G_ELAPSED_TIME.$G_DECPLACES Minuten müssen noch $G_STILL_TO_DO Dateien konvertiert werden"
!insertmacro PFI_LANG_STRING PFI_LANG_CONVERT_PROGRESS_1   "Nach $G_ELAPSED_TIME.$G_DECPLACES Minuten muss noch eine Datei konvertiert werden"
!insertmacro PFI_LANG_STRING PFI_LANG_CONVERT_SUMMARY      "Die Konvertierung dauerte $G_ELAPSED_TIME.$G_DECPLACES Minuten"

###########################################################################
###########################################################################

#--------------------------------------------------------------------------
# Mark the end of the language data
#--------------------------------------------------------------------------

!undef PFI_LANG

#--------------------------------------------------------------------------
# End of 'German-pfi.nsh'
#--------------------------------------------------------------------------
