#--------------------------------------------------------------------------
# German-pfi.nsh
#
# This file contains the "German" text strings used by the Windows installer
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
# Translation created by: Matthias Deege (pfaelzerchen at users.sourceforge.net)
# Translation updated by: Matthias Deege (pfaelzerchen at users.sourceforge.net)
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

!define PFI_LANG  "GERMAN"

#==========================================================================
# Customised versions of strings used on standard MUI pages
#==========================================================================

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; Used by the main POPFile installer (main script: installer.nsi)
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

#--------------------------------------------------------------------------
# Standard MUI Page - Welcome (for the main POPFile installer)
#
# The sequence \r\n\r\n inserts a blank line (note that the PFI_LANG_WELCOME_INFO_TEXT string
# should end with a \r\n\r\n$_CLICK sequence).
#--------------------------------------------------------------------------

!insertmacro PFI_LANG_STRING PFI_LANG_WELCOME_INFO_TEXT    "Dieser Assistent wird Sie durch die Installation von POPFile f�hren.\r\n\r\nEs wird empfohlen vor der Installation alle anderen Programme zu schlie�en.\r\n\r\n$_CLICK"
!insertmacro PFI_LANG_STRING PFI_LANG_WELCOME_ADMIN_TEXT   "ACHTUNG:\r\n\r\nDer aktuell angemeldete Benutzer hat KEINE Administratorrechte.\r\n\r\nFalls Sie Mehrbenutzerunterst�tzung ben�tigen, sollten Sie die Installation abbrechen und POPFile unter einem Administratorkonto installieren."

#--------------------------------------------------------------------------
# Standard MUI Page - Directory Page (for the main POPFile installer)
#--------------------------------------------------------------------------

!insertmacro PFI_LANG_STRING PFI_LANG_ROOTDIR_TITLE        "W�hlen Sie ein Verzeichnis f�r die Programminstallation"
!insertmacro PFI_LANG_STRING PFI_LANG_ROOTDIR_TEXT_DESTN   "Zielverzeichnis f�r das POPFile-Programm"

#--------------------------------------------------------------------------
# Standard MUI Page - Finish (for the main POPFile installer)
#
# The PFI_LANG_FINISH_RUN_TEXT text should be a short phrase (not a long paragraph)
#--------------------------------------------------------------------------

!insertmacro PFI_LANG_STRING PFI_LANG_FINISH_RUN_TEXT      "POPFile Benutzeroberfl�che"


;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; Used by 'Monitor Corpus Conversion' utility (main script: MonitorCC.nsi)
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

#--------------------------------------------------------------------------
# Standard MUI Page - Installation Page (for the 'Monitor Corpus Conversion' utility)
#--------------------------------------------------------------------------

!insertmacro PFI_LANG_STRING PFI_LANG_CONVERT_TITLE        "POPFile Corpus-Konvertierung"
!insertmacro PFI_LANG_STRING PFI_LANG_CONVERT_SUBTITLE     "Der bestehende Corpus mu� konvertiert werden, um mit der neuen Version von POPFile verwendet werden zu k�nnen."

!insertmacro PFI_LANG_STRING PFI_LANG_ENDCONVERT_TITLE     "POPFile Corpus-Konvertierung abgeschlossen"
!insertmacro PFI_LANG_STRING PFI_LANG_ENDCONVERT_SUBTITLE  "Bitte klicken Sie Beenden, um fortzufahren."

!insertmacro PFI_LANG_STRING PFI_LANG_BADCONVERT_TITLE     "POPFile Corpus Conversion Failed"
!insertmacro PFI_LANG_STRING PFI_LANG_BADCONVERT_SUBTITLE  "Please click Cancel to continue"


;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; Used by 'Add POPFile User' wizard (main script: adduser.nsi)
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

#--------------------------------------------------------------------------
# Standard MUI Page - Welcome (for the 'Add POPFile User' wizard)
#
# The sequence \r\n\r\n inserts a blank line (note that the PFI_LANG_ADDUSER_INFO_TEXT string
# should end with a \r\n\r\n$_CLICK sequence).
#--------------------------------------------------------------------------

!insertmacro PFI_LANG_STRING PFI_LANG_ADDUSER_INFO_TEXT    "Dieser Assistent wird Sie durch die Konfiguration von POPFile f�r den Benutzer '$G_WINUSERNAME' f�hren.\r\n\r\nEs wird empfohlen, da� Sie alle anderen Anwendungen schlie�en, bevor Sie weitermachen.\r\n\r\n$_CLICK"

#--------------------------------------------------------------------------
# Standard MUI Page - Directory Page (for the 'Add POPFile User' wizard)
#--------------------------------------------------------------------------

!insertmacro PFI_LANG_STRING PFI_LANG_USERDIR_TITLE        "W�hlen Sie das Datenverzeichnis f�r '$G_WINUSERNAME'"
!insertmacro PFI_LANG_STRING PFI_LANG_USERDIR_SUBTITLE     "W�hlen Sie das Verzeichnis, in dem die Daten f�r '$G_WINUSERNAME' gespeichert werden sollen."
!insertmacro PFI_LANG_STRING PFI_LANG_USERDIR_TEXT_TOP     "Diese Version von POPFile verwendet seperate Datendateien f�r jeden angemeldeten Benutzer.$\r$\n$\r$\nSetup wird das folgende Verzeichnis verwenden, um alle zum Benutzer '$G_WINUSERNAME' geh�renden Daten zu speichern. Um ein anderes Verzeichnis f�r diesen Benutzer zu verwenden, klicken Sie auf Durchsuchen und w�hlen Sie ein anderes Verzeichnis. $_CLICK"
!insertmacro PFI_LANG_STRING PFI_LANG_USERDIR_TEXT_DESTN   "Verzeichnis zur Speicherung der POPFile-Daten f�r '$G_WINUSERNAME'"

#--------------------------------------------------------------------------
# Standard MUI Page - Installation Page (for the 'Add POPFile User' wizard)
#--------------------------------------------------------------------------

!insertmacro PFI_LANG_STRING PFI_LANG_ADDUSER_TITLE        "Richte POPFile f�r '$G_WINUSERNAME' ein"
!insertmacro PFI_LANG_STRING PFI_LANG_ADDUSER_SUBTITLE     "Bitte warten Sie, w�hrend die Konfigurationsdateien f�r diesen Benutzer aktualisiert werden."

#--------------------------------------------------------------------------
# Standard MUI Page - Finish (for the 'Add POPFile User' wizard)
#--------------------------------------------------------------------------

!insertmacro PFI_LANG_STRING PFI_LANG_ADDUSER_FINISH_INFO "POPFile wurde f�r '$G_WINUSERNAME' eingerichtet.\r\n\r\nKlicken sie auf Finish, um diesen Assistenten zu beenden.."

#--------------------------------------------------------------------------
# Standard MUI Page - Uninstall Confirmation Page (for the 'Add POPFile User' wizard)
#--------------------------------------------------------------------------

!insertmacro PFI_LANG_STRING PFI_LANG_REMUSER_TITLE        "Deinstalliere alle POPFile-Daten f�r den Benutzer '$G_WINUSERNAME'"
!insertmacro PFI_LANG_STRING PFI_LANG_REMUSER_SUBTITLE     "L�sche POPFile Konfigurationsdaten f�r diesen Benutzer von Ihrem Computer."

!insertmacro PFI_LANG_STRING PFI_LANG_REMUSER_TEXT_TOP     "Die POPFile Konfigurationsdaten f�r '$G_WINUSERNAME' werden aus dem folgenden Verzeichnis gel�scht. $_CLICK"

#--------------------------------------------------------------------------
# Standard MUI Page - Uninstallation Page (for the 'Add POPFile User' wizard)
#--------------------------------------------------------------------------

!insertmacro PFI_LANG_STRING PFI_LANG_REMOVING_TITLE       "Deinstalliere POPFile-Daten f�r den Benutzer '$G_WINUSERNAME'"
!insertmacro PFI_LANG_STRING PFI_LANG_REMOVING_SUBTITLE    "Bitten werden Sie, w�hrend die Konfiguratoinsdateien f�r diesen Benutzer gel�scht werden."


#==========================================================================
# Strings used for custom pages, message boxes and banners
#==========================================================================

#--------------------------------------------------------------------------
# General purpose banner text (also suitable for page titles/subtitles)
#--------------------------------------------------------------------------

!insertmacro PFI_LANG_STRING PFI_LANG_OPTIONS_BANNER_1     "Bitte haben Sie einen Moment Geduld."
!insertmacro PFI_LANG_STRING PFI_LANG_OPTIONS_BANNER_2     "Dies kann einige Sekunden dauern..."

#--------------------------------------------------------------------------
# Message displayed when installer exits because another copy is running
#--------------------------------------------------------------------------

!insertmacro PFI_LANG_STRING PFI_LANG_INSTALLER_MUTEX      "Eine andere Version des POPFile-Installationsprogramms l�uft bereits!"

#--------------------------------------------------------------------------
# Message box warning that a previous installation has been found
#--------------------------------------------------------------------------

!insertmacro PFI_LANG_STRING PFI_LANG_DIRSELECT_MBWARN_1   "Vorhandene Installation gefunden:"
!insertmacro PFI_LANG_STRING PFI_LANG_DIRSELECT_MBWARN_2   "Wollen Sie die bestehende Version aktualisieren?"
!insertmacro PFI_LANG_STRING PFI_LANG_DIRSELECT_MBWARN_3   "�ltere Konfigurationsdaten gefunden:"

#--------------------------------------------------------------------------
# Startup message box offering to display the Release Notes
#--------------------------------------------------------------------------

!insertmacro PFI_LANG_STRING PFI_LANG_MBRELNOTES_1         "Hinweise zu dieser POPFile-Version anzeigen?"
!insertmacro PFI_LANG_STRING PFI_LANG_MBRELNOTES_2         "Falls Sie von einer �lteren Version updaten, sollten Sie 'Ja' w�hlen. (Sie sollten evtl. Backups VOR dem Update anlegen)"

#--------------------------------------------------------------------------
# Custom Page - Check Perl Requirements
#--------------------------------------------------------------------------

; Page Title and Sub-title displayed in the page header

!insertmacro PFI_LANG_STRING PFI_LANG_PERLREQ_TITLE        "Veraltete Systemkomponenten entdeckt"

; Text strings displayed on the custom page

!insertmacro PFI_LANG_STRING PFI_LANG_PERLREQ_IO_TEXT_1    "Der Standardbrowser wird zum Anzeigen der POPFile Benutzeroberfl�che verwendet.\r\n"
!insertmacro PFI_LANG_STRING PFI_LANG_PERLREQ_IO_TEXT_2    "POPFile ben�tigt keinen speziellen Browser und wird mit fast jedem Browser funktionieren.\r\n"
!insertmacro PFI_LANG_STRING PFI_LANG_PERLREQ_IO_TEXT_3    "Eine minimale Version des Perl-Interpreters wird installiert werden.\r\n"
!insertmacro PFI_LANG_STRING PFI_LANG_PERLREQ_IO_TEXT_4    "Die Perlversion, die von POPFile installiert wird, verwendet einige Komponenten des Internet Explorers und ben�tigt daher mindestes Internet Explorer 5.5.\r\n"
!insertmacro PFI_LANG_STRING PFI_LANG_PERLREQ_IO_TEXT_5    "Das Installationsprogramm hat festgestellt, da� der Internet Explorer auf diesem System installiert ist."
!insertmacro PFI_LANG_STRING PFI_LANG_PERLREQ_IO_TEXT_6    "Es ist m�glich, da� einige Funktionen von POPFile auf diesem System nicht korrekt funktionieren. "
!insertmacro PFI_LANG_STRING PFI_LANG_PERLREQ_IO_TEXT_7    "Falls Sie irgendwelche Probleme mit POPFile haben, versuchen Sie zun�chst ein Update auf eine neuere Version des Internet Explorers."

#--------------------------------------------------------------------------
# Standard MUI Page - Choose Components
#--------------------------------------------------------------------------

!insertmacro PFI_LANG_STRING DESC_SecPOPFile               "Installiert die Kernkomponenten inklusive einer Minimalversion des Perl-Interpreters."
!insertmacro PFI_LANG_STRING DESC_SecSkins                 "Installiert POPFile Skins, mit denen Sie die Benutzeroberfl�che von POPFile anpassen k�nnen."
!insertmacro PFI_LANG_STRING DESC_SecLangs                 "Installiert Unterst�tzung f�r weitere (nicht-englische) Sprachen."

#--------------------------------------------------------------------------
# Custom Page - POPFile Installation Options
#--------------------------------------------------------------------------

; Page Title and Sub-title displayed in the page header

!insertmacro PFI_LANG_STRING PFI_LANG_OPTIONS_TITLE        "POPFile Installationseinstellungen"
!insertmacro PFI_LANG_STRING PFI_LANG_OPTIONS_SUBTITLE     "Lassen Sie diese Einstellungen unver�ndert, sofern Sie sie nicht �ndern m�ssen"

; Text strings displayed on the custom page

!insertmacro PFI_LANG_STRING PFI_LANG_OPTIONS_IO_POP3      "W�hlen Sie den Standart-Port f�r POP3-Verbindungen (110 empfohlen)"
!insertmacro PFI_LANG_STRING PFI_LANG_OPTIONS_IO_GUI       "W�hlen Sie den Standard-Port f�r Verbindungen zur Benutzeroberfl�che (8080 empfohlen)"
!insertmacro PFI_LANG_STRING PFI_LANG_OPTIONS_IO_STARTUP   "POPFile mit Windows starten"
!insertmacro PFI_LANG_STRING PFI_LANG_OPTIONS_IO_WARNING   "WICHTIGER HINWEIS"
!insertmacro PFI_LANG_STRING PFI_LANG_OPTIONS_IO_MESSAGE   "WENN SIE POPFILE UPDATEN: SETUP WIRD DIE VORHANDENE VERSION BEENDEN, FALLS DIESE IM HINTERGRUND L�UFT"

; Message Boxes used when validating user's selections

!insertmacro PFI_LANG_STRING PFI_LANG_OPTIONS_MBPOP3_1     "Der POP3-Port kann nicht �bernommen werden."
!insertmacro PFI_LANG_STRING PFI_LANG_OPTIONS_MBPOP3_2     "Der Port mu� eine Zahl zwischen 1 und 65535 sein."
!insertmacro PFI_LANG_STRING PFI_LANG_OPTIONS_MBPOP3_3     "Bitte korrigieren Sie ihre Eingabe f�r den POP3-Port."

!insertmacro PFI_LANG_STRING PFI_LANG_OPTIONS_MBGUI_1      "Der Port f�r die Benutzeroberfl�che kann nicht �bernommen werden."
!insertmacro PFI_LANG_STRING PFI_LANG_OPTIONS_MBGUI_2      "Der Port mu� eine Zahl zwischen 1 und 65535 sein."
!insertmacro PFI_LANG_STRING PFI_LANG_OPTIONS_MBGUI_3      "Bitte korrigieren Sie ihre Eingabe f�r den Port f�r die Benutzeroberfl�che."

!insertmacro PFI_LANG_STRING PFI_LANG_OPTIONS_MBDIFF_1     "POP3-Port und Port f�r die Benutzeroberfl�che d�rfen nicht identisch sein."
!insertmacro PFI_LANG_STRING PFI_LANG_OPTIONS_MBDIFF_2     "Bitte �ndern Sie ihre Port-Einstellungen."

#--------------------------------------------------------------------------
# Standard MUI Page - Installing POPfile
#--------------------------------------------------------------------------

; Installation Progress Reports displayed above the progress bar

!insertmacro PFI_LANG_STRING PFI_LANG_INST_PROG_UPGRADE    "Suche evtl. existierende �ltere Versionen..."
!insertmacro PFI_LANG_STRING PFI_LANG_INST_PROG_CORE       "Installiere Kernkomponenten..."
!insertmacro PFI_LANG_STRING PFI_LANG_INST_PROG_PERL       "Installiere Minimal-Perl-Umgebung..."
!insertmacro PFI_LANG_STRING PFI_LANG_INST_PROG_SHORT      "Erzeuge Verkn�pfungen..."
!insertmacro PFI_LANG_STRING PFI_LANG_INST_PROG_CORPUS     "Erstelle Corpus Backup. Dies kann einige Sekunden dauern..."
!insertmacro PFI_LANG_STRING PFI_LANG_INST_PROG_SKINS      "Installiere Skins..."
!insertmacro PFI_LANG_STRING PFI_LANG_INST_PROG_LANGS      "Installiere Sprachdateien..."
!insertmacro PFI_LANG_STRING PFI_LANG_INST_PROG_ENDSEC     "Klicken Sie auf Weiter um fortzufahren"

; Installation Log Messages

!insertmacro PFI_LANG_STRING PFI_LANG_INST_LOG_1           "Beende �ltere POPFile Version am Port"

; Message Box text strings

!insertmacro PFI_LANG_STRING PFI_LANG_MBSTPWDS_1           "Datei einer �lteren Version gefunden."
!insertmacro PFI_LANG_STRING PFI_LANG_MBSTPWDS_2           "Diese Datei aktualisieren?"
!insertmacro PFI_LANG_STRING PFI_LANG_MBSTPWDS_3           "W�hlen Sie 'Ja', um diese zu aktualisieren (Die alte Datei wird gespeichert unter"
!insertmacro PFI_LANG_STRING PFI_LANG_MBSTPWDS_4           "W�hlen Sie 'Nein', um die alte Datei zu behalten (Die neue Datei wird gespeichert unter"

!insertmacro PFI_LANG_STRING PFI_LANG_MBCFGBK_1            "Backup von"
!insertmacro PFI_LANG_STRING PFI_LANG_MBCFGBK_2            "existiert bereits"
!insertmacro PFI_LANG_STRING PFI_LANG_MBCFGBK_3            "Diese Datei �berschreiben?"
!insertmacro PFI_LANG_STRING PFI_LANG_MBCFGBK_4            "W�hlen Sie 'Ja', um diese zu �berschreiben, 'Nein', um kein neues Backup anzulegen."

!insertmacro PFI_LANG_STRING PFI_LANG_MBMANSHUT_1          "POPFile kann nicht automatisch beendet werden."
!insertmacro PFI_LANG_STRING PFI_LANG_MBMANSHUT_2          "Bitte beenden Sie POPFile jetzt manuell."
!insertmacro PFI_LANG_STRING PFI_LANG_MBMANSHUT_3          "Klicken Sie bitte auf 'OK', sobald POPFile beendet wurde, um die Installation fortzusetzen."

!insertmacro PFI_LANG_STRING PFI_LANG_MBCORPUS_1           "Beim Erstellen eines Backups der alten Corpus Dateien ist ein Fehler aufgetreten."

#--------------------------------------------------------------------------
# Custom Page - POPFile Classification Bucket Creation
#--------------------------------------------------------------------------

; Page Title and Sub-title displayed in the page header

!insertmacro PFI_LANG_STRING PFI_LANG_CBP_TITLE            "POPFile Klassifikationskategorien erstellen"
!insertmacro PFI_LANG_STRING PFI_LANG_CBP_SUBTITLE         "POPFile ben�tigt MINDESTENS ZWEI Kategorien, um Ihre Emails klassifizieren zu k�nnen"

; Text strings displayed on the custom page

!insertmacro PFI_LANG_STRING PFI_LANG_CBP_IO_INTRO         "Nach der Installation k�nnen Sie die Anzahl der Kategorien (und deren Name) ohne Probleme an ihre Bed�rfnisse anpassen.\r\n\r\nKategorienamen bestehen aus Kleinbuchstaben, Ziffern von 0 bis 9, Bindestrich oder Unterstrich."
!insertmacro PFI_LANG_STRING PFI_LANG_CBP_IO_CREATE        "Erstellen Sie eine neue Kategorie, indem Sie entweder einen Namen aus der Liste w�hlen oder einen Namen ihrer Wahl eingeben."
!insertmacro PFI_LANG_STRING PFI_LANG_CBP_IO_DELETE        "Um eine oder mehr Kategorien von der Liste zu l�schen, markieren Sie die entsprechenden 'Entfernen' K�stchen und klicken Sie auf 'Weiter'."
!insertmacro PFI_LANG_STRING PFI_LANG_CBP_IO_LISTHDR       "Bereits eingerichtete Kategorien"
!insertmacro PFI_LANG_STRING PFI_LANG_CBP_IO_REMOVE        "Entfernen"
!insertmacro PFI_LANG_STRING PFI_LANG_CBP_IO_CONTINUE      "Weiter"

; Text strings used for status messages under the bucket list

!insertmacro PFI_LANG_STRING PFI_LANG_CBP_IO_MSG_1         "Sie m�ssen keine weiteren Kategorien hinzuf�gen"
!insertmacro PFI_LANG_STRING PFI_LANG_CBP_IO_MSG_2         "Sie m�ssen MINDESTENS zwei Kategorien angeben"
!insertmacro PFI_LANG_STRING PFI_LANG_CBP_IO_MSG_3         "Mindestens eine weitere Kategorie wird ben�tigt"
!insertmacro PFI_LANG_STRING PFI_LANG_CBP_IO_MSG_4         "Der Installer kann nicht mehr als"
!insertmacro PFI_LANG_STRING PFI_LANG_CBP_IO_MSG_5         "Kategorien anlegen."

; Message box text strings

!insertmacro PFI_LANG_STRING PFI_LANG_CBP_MBDUPERR_1       "Eine Kategorie mit dem Namen"
!insertmacro PFI_LANG_STRING PFI_LANG_CBP_MBDUPERR_2       "wurde bereits angelegt."
!insertmacro PFI_LANG_STRING PFI_LANG_CBP_MBDUPERR_3       "Bitte w�hlen Sie einen anderen Namen f�r die neue Kategorie."

!insertmacro PFI_LANG_STRING PFI_LANG_CBP_MBMAXERR_1       "Der Installer kann nur bis zu"
!insertmacro PFI_LANG_STRING PFI_LANG_CBP_MBMAXERR_2       "Kategorien anlegen."
!insertmacro PFI_LANG_STRING PFI_LANG_CBP_MBMAXERR_3       "Nach der Installation k�nnen Sie mehr als"

!insertmacro PFI_LANG_STRING PFI_LANG_CBP_MBNAMERR_1       "Der Name"
!insertmacro PFI_LANG_STRING PFI_LANG_CBP_MBNAMERR_2       "ist ung�ltig."
!insertmacro PFI_LANG_STRING PFI_LANG_CBP_MBNAMERR_3       "Kategorienamen k�nnen nur Kleinbuchstaben von a bis z, Ziffern von 0 bis 9, - oder _ enthalten"
!insertmacro PFI_LANG_STRING PFI_LANG_CBP_MBNAMERR_4       "Bitte w�hlen Sie einen anderen Namen f�r die neue Kategorie."

!insertmacro PFI_LANG_STRING PFI_LANG_CBP_MBCONTERR_1      "POPFile ben�tigt MINDESTES ZWEI Kategorien, um ihre Emails klassifizieren zu k�nnen."
!insertmacro PFI_LANG_STRING PFI_LANG_CBP_MBCONTERR_2      "Bitte geben Sie den Namen einer zu erstellenden Kategorie ein,$\r$\n$\r$\nindem Sie entweder einen der Vorschl�ge aus der Liste ausw�hlen$\r$\n$\r$\noder indem Sie einen Namen Ihrer Wahl eingeben."
!insertmacro PFI_LANG_STRING PFI_LANG_CBP_MBCONTERR_3      "Sie m�ssen MINDESTENS ZWEI Kategorien anlegen, bevor Sie die Installation fortsetzen k�nnen."

!insertmacro PFI_LANG_STRING PFI_LANG_CBP_MBDONE_1         "Kategorien zur Nutzung durch POPFile wurden angelegt."
!insertmacro PFI_LANG_STRING PFI_LANG_CBP_MBDONE_2         "Sollen diese Kategorien f�r POPFile eingerichtet werden?"
!insertmacro PFI_LANG_STRING PFI_LANG_CBP_MBDONE_3         "W�hlen Sie 'Nein', wenn Sie Ihre Auswahl korrigieren m�chten."

!insertmacro PFI_LANG_STRING PFI_LANG_CBP_MBMAKERR_1       "Der Installer konnte"
!insertmacro PFI_LANG_STRING PFI_LANG_CBP_MBMAKERR_2       "der "
!insertmacro PFI_LANG_STRING PFI_LANG_CBP_MBMAKERR_3       "von Ihnen angegebenen Kategorien nicht einrichten."
!insertmacro PFI_LANG_STRING PFI_LANG_CBP_MBMAKERR_4       "Nach Abschlu� der Installation k�nnen Sie �ber die Benutzeroberfl�che die fehlende(n) Kategorie(n) nachtr�glich einrichten."

#--------------------------------------------------------------------------
# Custom Page - Email Client Reconfiguration
#--------------------------------------------------------------------------

; Page Title and Sub-title displayed in the page header

!insertmacro PFI_LANG_STRING PFI_LANG_MAILCFG_TITLE        "Email Konfiguration"
!insertmacro PFI_LANG_STRING PFI_LANG_MAILCFG_SUBTITLE     "POPFile kann einige Emailprogramme f�r Sie neu konfigurieren."

; Text displayed on the custom page

!insertmacro PFI_LANG_STRING PFI_LANG_MAILCFG_IO_TEXT_1    "Programme, die mit (*) markiert sind, k�nnen automatisch konfiguriert werden - vorausgesetzt, einfache Konten werden verwendet.\r\n\r\nEs wird dringendst empfohlen, Konten, die eine Authentifizierung ben�tigen, manuell zu konfigurieren."
!insertmacro PFI_LANG_STRING PFI_LANG_MAILCFG_IO_TEXT_2    "WICHTIG: BEENDEN SIE DIE BETROFFENEN EMAILPROGRAMME JETZT!\r\n\r\nDiese Funktion befindet sich noch in Entwicklung (einige Outlook Konten k�nnen z.B. nicht gefunden werden).\r\n\r\nBitte �berpr�fen Sie, ob die Neukonfiguration erfolgreich war (bevor Sie das Emailprogramm verwenden)."

!insertmacro PFI_LANG_STRING PFI_LANG_MAILCFG_IO_CANCEL    "Die Konfiguration wurde vom Benutzer abgebrochen"

#--------------------------------------------------------------------------
# Text used on buttons to skip configuration of email clients
#--------------------------------------------------------------------------

!insertmacro PFI_LANG_STRING PFI_LANG_MAILCFG_IO_SKIPALL   "�berspringen"
!insertmacro PFI_LANG_STRING PFI_LANG_MAILCFG_IO_SKIPONE   "�berspringen"

#--------------------------------------------------------------------------
# Message box warnings that an email client is still running
#--------------------------------------------------------------------------

!insertmacro PFI_LANG_STRING PFI_LANG_MBCLIENT_EXP         "ACHTUNG: Outlook Express scheint ge�ffnet zu sein!"
!insertmacro PFI_LANG_STRING PFI_LANG_MBCLIENT_OUT         "ACHTUNG: Outlook scheint ge�ffnet zu sein!"
!insertmacro PFI_LANG_STRING PFI_LANG_MBCLIENT_EUD         "ACHTUNG: Eudora scheint ge�ffnet zu sein!"

!insertmacro PFI_LANG_STRING PFI_LANG_MBCLIENT_STOP_1      "Bitte beenden Sie das Emailprogramme. Klicken Sie dann auf 'Wiederholen', um die Konfiguration fortzusetzen."
!insertmacro PFI_LANG_STRING PFI_LANG_MBCLIENT_STOP_2      "(Klicken Sie auf 'Ignorieren', um die Konfiguration trotzdem fortzusetzen. Dies ist nicht empfohlen.)"
!insertmacro PFI_LANG_STRING PFI_LANG_MBCLIENT_STOP_3      "Klicken Sie auf 'Abbrechen', um die Konfiguration f�r dieses Email Programm zu �berspringen."

!insertmacro PFI_LANG_STRING PFI_LANG_MBCLIENT_STOP_4      "Bitte beenden Sie das Emailprogramm. Klicken Sie dann auf 'Wiederholen', um die Einstellungen wiederherzustellen."
!insertmacro PFI_LANG_STRING PFI_LANG_MBCLIENT_STOP_5      "(Klicken Sie auf 'Ignorieren', um die Wiederherstellung trotzdem durchzuf�hren. Dies ist nicht empfohlen.)"
!insertmacro PFI_LANG_STRING PFI_LANG_MBCLIENT_STOP_6      "Klicken Sie auf 'Abbrechen', um die Wiederherstellung der Originaleinstellungen zu �berspringen."

#--------------------------------------------------------------------------
# Custom Page - Reconfigure Outlook/Outlook Express
#--------------------------------------------------------------------------

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
!insertmacro PFI_LANG_STRING PFI_LANG_OOECFG_IO_FOOTNOTE   "Markieren Sie die K�stchen der Konten, die neu konfiguriert werden sollen.\r\nWenn Sie POPFile deinstallieren, werden die alten Einstellungen wiederhergestellt."

; Message Box to confirm changes to Outlook Express account configuration

!insertmacro PFI_LANG_STRING PFI_LANG_EXPCFG_MBIDENTITY    "Outlook Express Identit�t:"
!insertmacro PFI_LANG_STRING PFI_LANG_EXPCFG_MBACCOUNT     "Outlook Express Konto:"

!insertmacro PFI_LANG_STRING PFI_LANG_OUTCFG_MBIDENTITY    "Outlook Benutzer:"
!insertmacro PFI_LANG_STRING PFI_LANG_OUTCFG_MBACCOUNT     "Outlook Konto:"

!insertmacro PFI_LANG_STRING PFI_LANG_OOECFG_MBEMAIL       "Email Adresse:"
!insertmacro PFI_LANG_STRING PFI_LANG_OOECFG_MBSERVER      "POP3 Server:"
!insertmacro PFI_LANG_STRING PFI_LANG_OOECFG_MBUSERNAME    "POP3 Benutzername:"
!insertmacro PFI_LANG_STRING PFI_LANG_OOECFG_MBOEPORT      "POP3 Port:"
!insertmacro PFI_LANG_STRING PFI_LANG_OOECFG_MBOLDVALUE    "aktuell"
!insertmacro PFI_LANG_STRING PFI_LANG_OOECFG_MBQUESTION    "Account zur Nutzung mit POPFile konfigurieren ?"

; Title and Column headings for report/log files

!insertmacro PFI_LANG_STRING PFI_LANG_EXPCFG_LOG_BEFORE    "Outlook Express Einstellungen bisher"
!insertmacro PFI_LANG_STRING PFI_LANG_EXPCFG_LOG_AFTER     "�nderungen, die an den Outlook Express Einstellungen vorgenommen werden"

!insertmacro PFI_LANG_STRING PFI_LANG_OUTCFG_LOG_BEFORE    "Outlook Einstellungen bisher"
!insertmacro PFI_LANG_STRING PFI_LANG_OUTCFG_LOG_AFTER     "�ndeurngen, die an den Outlook Einstellungen vorgenommen werden"

!insertmacro PFI_LANG_STRING PFI_LANG_OOECFG_LOG_END       "(Ende)"

!insertmacro PFI_LANG_STRING PFI_LANG_EXPCFG_LOG_IDENTITY  "'IDENTIT�T'"
!insertmacro PFI_LANG_STRING PFI_LANG_OUTCFG_LOG_IDENTITY  "'OUTLOOK BENUTZER'"

!insertmacro PFI_LANG_STRING PFI_LANG_OOECFG_LOG_ACCOUNT   "'KONTO'"

!insertmacro PFI_LANG_STRING PFI_LANG_OOECFG_LOG_EMAIL     "'EMAIL ADRESSE'"
!insertmacro PFI_LANG_STRING PFI_LANG_OOECFG_LOG_SERVER    "'POP3 SERVER'"
!insertmacro PFI_LANG_STRING PFI_LANG_OOECFG_LOG_USER      "'POP3 BENUTZERNAME'"
!insertmacro PFI_LANG_STRING PFI_LANG_OOECFG_LOG_PORT      "'POP3 PORT'"

!insertmacro PFI_LANG_STRING PFI_LANG_OOECFG_LOG_NEWSERVER "'NEUER POP3 SERVER'"
!insertmacro PFI_LANG_STRING PFI_LANG_OOECFG_LOG_NEWUSER   "'NEUER POP3 BENUTZERNAME'"
!insertmacro PFI_LANG_STRING PFI_LANG_OOECFG_LOG_NEWPORT   "'NEUER POP3 PORT'"

#--------------------------------------------------------------------------
# Custom Page - Reconfigure Eudora
#--------------------------------------------------------------------------

; Page Title and Sub-title displayed in the page header

!insertmacro PFI_LANG_STRING PFI_LANG_EUCFG_TITLE          "Eudora konfigurieren"
!insertmacro PFI_LANG_STRING PFI_LANG_EUCFG_SUBTITLE       "POPFile kann Eudora automatisch zur Nutzung mit POPFile konfigurieren"

; Text displayed on the custom page

!insertmacro PFI_LANG_STRING PFI_LANG_EUCFG_IO_CANCELLED   "Eudora Konfiguration vom Benutzer abgebrochen"

!insertmacro PFI_LANG_STRING PFI_LANG_EUCFG_IO_INTRO_1     "POPFile hat die folgenden Eudorabenutzer entdeckt"
!insertmacro PFI_LANG_STRING PFI_LANG_EUCFG_IO_INTRO_2     " und cann diese automatischa f�r die Benutzung mit POPFile konfigurieren."
!insertmacro PFI_LANG_STRING PFI_LANG_EUCFG_IO_CHECKBOX    "Diesen Benutzer f�r POPFile einrichten"
!insertmacro PFI_LANG_STRING PFI_LANG_EUCFG_IO_DOMINANT    "<Dominant> personality"
!insertmacro PFI_LANG_STRING PFI_LANG_EUCFG_IO_PERSONA     "Benutzer"
!insertmacro PFI_LANG_STRING PFI_LANG_EUCFG_IO_EMAIL       "Email Adresse:"
!insertmacro PFI_LANG_STRING PFI_LANG_EUCFG_IO_SERVER      "POP3 Server:"
!insertmacro PFI_LANG_STRING PFI_LANG_EUCFG_IO_USERNAME    "POP3 Benutzername:"
!insertmacro PFI_LANG_STRING PFI_LANG_EUCFG_IO_POP3PORT    "POP3 Port:"
!insertmacro PFI_LANG_STRING PFI_LANG_EUCFG_IO_RESTORE     "Wenn Sie POPFile deinstallieren, werden die alten Einstellungen wiederhergestellt"

#--------------------------------------------------------------------------
# Custom Page - POPFile can now be started
#--------------------------------------------------------------------------

; Page Title and Sub-title displayed in the page header

!insertmacro PFI_LANG_STRING PFI_LANG_LAUNCH_TITLE         "POPFile kann nun gestartet werden"
!insertmacro PFI_LANG_STRING PFI_LANG_LAUNCH_SUBTITLE      "Die POPFile Benutzeroberfl�che funktioniert nur, wenn POPFile gestartet wurde"

; Text displayed on the custom page

!insertmacro PFI_LANG_STRING PFI_LANG_LAUNCH_IO_INTRO      "POPFile jetzt starten?"
!insertmacro PFI_LANG_STRING PFI_LANG_LAUNCH_IO_NO         "Nein (Die Benutzeroberfl�che kann bis zum Start von POPFile nicht verwendet werden)"
!insertmacro PFI_LANG_STRING PFI_LANG_LAUNCH_IO_DOSBOX     "POPFile starten (in einem Fenster)"
!insertmacro PFI_LANG_STRING PFI_LANG_LAUNCH_IO_BCKGRND    "POPFile im Hintergrund starten (kein Fenster anzeigen)"
!insertmacro PFI_LANG_STRING PFI_LANG_LAUNCH_IO_NOTE_1     "Wenn POPFile gestartet wurde, k�nnen Sie die Benutzeroberfl�che aufrufen, indem"
!insertmacro PFI_LANG_STRING PFI_LANG_LAUNCH_IO_NOTE_2     "(a) Sie auf das POPFile-Symbol neben der Uhr doppelklicken oder indem"
!insertmacro PFI_LANG_STRING PFI_LANG_LAUNCH_IO_NOTE_3     "(b) Sie Start --> Programme --> POPFile --> POPFile User Interface w�hlen."

; Banner message displayed whilst waiting for POPFile to start

!insertmacro PFI_LANG_STRING PFI_LANG_LAUNCH_BANNER_1      "Start von POPFile vorbereiten."
!insertmacro PFI_LANG_STRING PFI_LANG_LAUNCH_BANNER_2      "Dies kann einige Sekunden dauern..."

#--------------------------------------------------------------------------
# Standard MUI Page - Installation Page (for the 'Corpus Conversion Monitor' utility)
#--------------------------------------------------------------------------

!insertmacro PFI_LANG_STRING PFI_LANG_CONVERT_MUTEX        "Eine andere Version der Corpus Konvertierung l�uft bereits!"
!insertmacro PFI_LANG_STRING PFI_LANG_CONVERT_PRIVATE      "Die 'Corpus Konvertierung' ist Teil des POPFile Installationsprogramms"
!insertmacro PFI_LANG_STRING PFI_LANG_CONVERT_NOFILE       "Fehler: Konvertierungsdatendatei existiert nicht!"
!insertmacro PFI_LANG_STRING PFI_LANG_CONVERT_NOPOPFILE    "Fehler: POPFile Pfad nicht gefunden"
!insertmacro PFI_LANG_STRING PFI_LANG_CONVERT_ENVNOTSET    "Fehler: Kann Umgebungsvariable nicht setzen"
!insertmacro PFI_LANG_STRING PFI_LANG_CONVERT_NOKAKASI     "Fehler: Kakasi Pfad nicht gefunden"
!insertmacro PFI_LANG_STRING PFI_LANG_CONVERT_STARTERR     "Ein Fehler ist beim Start des Konvertierungsprozesses aufgetreten"
!insertmacro PFI_LANG_STRING PFI_LANG_CONVERT_FATALERR     "A fatal error occurred during the corpus conversion process !"
!insertmacro PFI_LANG_STRING PFI_LANG_CONVERT_ESTIMATE     "Gesch�tzte Wartezeit: "
!insertmacro PFI_LANG_STRING PFI_LANG_CONVERT_MINUTES      "Minuten"
!insertmacro PFI_LANG_STRING PFI_LANG_CONVERT_WAITING      "(warte auf Konvertierung der ersten Datei)"
!insertmacro PFI_LANG_STRING PFI_LANG_CONVERT_TOTALFILES   "Es m�ssen insgesamt $G_BUCKET_COUNT Dateien konvertiert werden"
!insertmacro PFI_LANG_STRING PFI_LANG_CONVERT_PROGRESS_N   "Nach $G_ELAPSED_TIME.$G_DECPLACES Minuten m�ssen noch $G_STILL_TO_DO Dateien konvertiert werden"
!insertmacro PFI_LANG_STRING PFI_LANG_CONVERT_PROGRESS_1   "Nach $G_ELAPSED_TIME.$G_DECPLACES Minuten mu� noch eine Datei konvertiert werden"
!insertmacro PFI_LANG_STRING PFI_LANG_CONVERT_SUMMARY      "Die Konvertierung dauerte $G_ELAPSED_TIME.$G_DECPLACES Minuten"

#--------------------------------------------------------------------------
# Standard MUI Page - Uninstall POPFile
#--------------------------------------------------------------------------

; Uninstall Progress Reports displayed above the progress bar

!insertmacro PFI_LANG_STRING PFI_LANG_UN_PROGRESS_1        "POPFile beenden..."
!insertmacro PFI_LANG_STRING PFI_LANG_UN_PROGRESS_2        "Startmen�-Eintr�ge von POPFile l�schen..."
!insertmacro PFI_LANG_STRING PFI_LANG_UN_PROGRESS_3        "Kernkomponenten l�schen..."
!insertmacro PFI_LANG_STRING PFI_LANG_UN_PROGRESS_4        "Outlook Express Einstellungen wiederherstellen..."
!insertmacro PFI_LANG_STRING PFI_LANG_UN_PROGRESS_5        "Skins l�schen..."
!insertmacro PFI_LANG_STRING PFI_LANG_UN_PROGRESS_6        "Minimal-Perl-Umgebung l�schen..."
!insertmacro PFI_LANG_STRING PFI_LANG_UN_PROGRESS_7        "Outlook Einstellungen wiederherstellen..."
!insertmacro PFI_LANG_STRING PFI_LANG_UN_PROGRESS_8        "Eudora Einstellungen wiederherstellen..."

; Uninstall Log Messages

!insertmacro PFI_LANG_STRING PFI_LANG_UN_LOG_1             "Beende POPFile am Port"
!insertmacro PFI_LANG_STRING PFI_LANG_UN_LOG_2             "Ge�ffnet"
!insertmacro PFI_LANG_STRING PFI_LANG_UN_LOG_3             "Wiederhergestellt"
!insertmacro PFI_LANG_STRING PFI_LANG_UN_LOG_4             "Geschlossen"
!insertmacro PFI_LANG_STRING PFI_LANG_UN_LOG_5             "Alle Dateien im POPFile-Verzeichnis l�schen"
!insertmacro PFI_LANG_STRING PFI_LANG_UN_LOG_6             "Hinweis: Es konnten nicht alle Dateien im POPFile-Verzeichnis gel�scht werden"
!insertmacro PFI_LANG_STRING PFI_LANG_UN_LOG_7             "Datenprobleme"
!insertmacro PFI_LANG_STRING PFI_LANG_UN_LOG_8             "L�sche alle Dateien aus dem POPFile Benutzerdaten-VerzeichnisRemoving all files from POPFile 'User Data' directory"
!insertmacro PFI_LANG_STRING PFI_LANG_UN_LOG_9             "HINWEIS: Nicht alle Dateien konnten aus den Benutzerdaten-Verzeichnis gel�scht werden"

; Message Box text strings

!insertmacro PFI_LANG_STRING PFI_LANG_UN_MBDIFFUSER_1      "'$G_WINUSERNAME' will die Daten eines anderen Benutzers l�schen"

!insertmacro PFI_LANG_STRING PFI_LANG_UN_MBNOTFOUND_1      "POPFile scheint nicht im folgenden Verzeichnis installiert zu sein:"
!insertmacro PFI_LANG_STRING PFI_LANG_UN_MBNOTFOUND_2      "Trotzdem fortfahren (nicht empfohlen)?"

!insertmacro PFI_LANG_STRING PFI_LANG_UN_ABORT_1           "Deinstallation vom Anwender abgebrochen"

!insertmacro PFI_LANG_STRING PFI_LANG_UN_MBCLIENT_1        "'Outlook Express' Problem!"
!insertmacro PFI_LANG_STRING PFI_LANG_UN_MBCLIENT_2        "'Outlook' Problem!"
!insertmacro PFI_LANG_STRING PFI_LANG_UN_MBCLIENT_3        "'Eudora' Problem!"

!insertmacro PFI_LANG_STRING PFI_LANG_UN_MBEMAIL_1         "Kann Originaleinstellungen nicht wiederherstellen"
!insertmacro PFI_LANG_STRING PFI_LANG_UN_MBEMAIL_2         "Fehlerbericht anzeigen?"

!insertmacro PFI_LANG_STRING PFI_LANG_UN_MBRERUN_1         "Einige Emailprogrammeinstellungen konnten nicht wiederhergestellt werden!"
!insertmacro PFI_LANG_STRING PFI_LANG_UN_MBRERUN_2         "(Details: siehe $INSTDIR Verzeichnis)"
!insertmacro PFI_LANG_STRING PFI_LANG_UN_MBRERUN_3         "Klicken Sie auf 'Nein', um diese Fehler zu ignorieren und alles zu l�schen"
!insertmacro PFI_LANG_STRING PFI_LANG_UN_MBRERUN_4         "Klicken Sie auf 'Ja', um diese Daten zu behalten (und einen sp�teren Versuch zu erm�glichen)"

!insertmacro PFI_LANG_STRING PFI_LANG_UN_MBREMDIR_1        "Wollen Sie alle Dateien im POPFile-Verzeichnis l�schen? (Wenn Sie irgendetwas erstellt haben, was sie behalten m�chten, w�hlen Sie Nein)"
!insertmacro PFI_LANG_STRING PFI_LANG_UN_MBREMDIR_2        "Wollen Sie alle Dateien im Benutzerdatenverzeichnis l�schen?$\r$\n$\r$\n(Wenn Sie irgendetwas erstellt haben, was sie behalten m�chten, w�hlen Sie Nein)"

!insertmacro PFI_LANG_STRING PFI_LANG_UN_MBREMERR_1        "Hinweis"
!insertmacro PFI_LANG_STRING PFI_LANG_UN_MBREMERR_2        "konnte nicht entfernt werden."

#--------------------------------------------------------------------------
# Mark the end of the language data
#--------------------------------------------------------------------------

!undef PFI_LANG

#--------------------------------------------------------------------------
# End of 'German-pfi.nsh'
#--------------------------------------------------------------------------
