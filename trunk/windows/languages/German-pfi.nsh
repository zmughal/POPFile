#--------------------------------------------------------------------------
# German-pfi.nsh
#
# This file contains additional "German" text strings used by the Windows installer
# for POPFile (these strings are unique to POPFile).
#
# See 'German-mui.nsh' for the strings which modify standard NSIS MUI messages.
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

!define PFI_LANG  "GERMAN"

#--------------------------------------------------------------------------
# Startup message box offering to display the Release Notes
#--------------------------------------------------------------------------

!insertmacro PFI_LANG_STRING PFI_LANG_MBRELNOTES_1        "Hinweise zu dieser POPFile-Version anzeigen?"
!insertmacro PFI_LANG_STRING PFI_LANG_MBRELNOTES_2        "Falls Sie von einer �lteren Version updaten, sollten Sie 'Ja' w�hlen. (Sie sollten evtl. Backups VOR dem Update anlegen)"

#--------------------------------------------------------------------------
# Standard MUI Page - Choose Components
#--------------------------------------------------------------------------

!insertmacro PFI_LANG_STRING DESC_SecPOPFile              "Installiert die Kernkomponenten inklusive einer Minimalversion des Perl-Interpreters."
!insertmacro PFI_LANG_STRING DESC_SecSkins                "Installiert POPFile Skins, mit denen Sie die Benutzeroberfl�che von POPFile anpassen k�nnen."
!insertmacro PFI_LANG_STRING DESC_SecLangs                "Installiert Unterst�tzung f�r weitere (nicht-englische) Sprachen."

#--------------------------------------------------------------------------
# Custom Page - POPFile Installation Options
#--------------------------------------------------------------------------

; Page Title and Sub-title displayed in the page header

!insertmacro PFI_LANG_STRING PFI_LANG_OPTIONS_TITLE       "POPFile Installationseinstellungen"
!insertmacro PFI_LANG_STRING PFI_LANG_OPTIONS_SUBTITLE    "Lassen Sie diese Einstellungen unver�ndert, sofern Sie sie nicht �ndern m�ssen"

; Text strings displayed on the custom page

!insertmacro PFI_LANG_STRING PFI_LANG_OPTIONS_IO_POP3     "W�hlen Sie den Standart-Port f�r POP3-Verbindungen (110 empfohlen)"
!insertmacro PFI_LANG_STRING PFI_LANG_OPTIONS_IO_GUI      "W�hlen Sie den Standard-Port f�r Verbindungen zur Benutzeroberfl�che (8080 empfohlen)"
!insertmacro PFI_LANG_STRING PFI_LANG_OPTIONS_IO_STARTUP  "POPFile mit Windows starten"
!insertmacro PFI_LANG_STRING PFI_LANG_OPTIONS_IO_WARNING  "WICHTIGER HINWEIS"
!insertmacro PFI_LANG_STRING PFI_LANG_OPTIONS_IO_MESSAGE  "WENN SIE POPFILE UPDATEN: SETUP WIRD DIE VORHANDENE VERSION BEENDEN, FALLS DIESE IM HINTERGRUND L�UFT"

; Message Boxes used when validating user's selections

!insertmacro PFI_LANG_STRING PFI_LANG_OPTIONS_MBUNINST_1    "Vorhandene Installation gefunden:"
!insertmacro PFI_LANG_STRING PFI_LANG_OPTIONS_MBUNINST_2    "Wollen Sie diese Deinstallieren?"
!insertmacro PFI_LANG_STRING PFI_LANG_OPTIONS_MBUNINST_3    "Es wird empfohlen, dies zu tun."

!insertmacro PFI_LANG_STRING PFI_LANG_OPTIONS_MBPOP3_1    "Der POP3-Port kann nicht �bernommen werden."
!insertmacro PFI_LANG_STRING PFI_LANG_OPTIONS_MBPOP3_2    "Der Port mu� eine Zahl zwischen 1 und 65535 sein."
!insertmacro PFI_LANG_STRING PFI_LANG_OPTIONS_MBPOP3_3    "Bitte korrigieren Sie ihre Eingabe f�r den POP3-Port."

!insertmacro PFI_LANG_STRING PFI_LANG_OPTIONS_MBGUI_1     "Der Port f�r die Benutzeroberfl�che kann nicht �bernommen werden."
!insertmacro PFI_LANG_STRING PFI_LANG_OPTIONS_MBGUI_2     "Der Port mu� eine Zahl zwischen 1 und 65535 sein."
!insertmacro PFI_LANG_STRING PFI_LANG_OPTIONS_MBGUI_3     "Bitte korrigieren Sie ihre Eingabe f�r den Port f�r die Benutzeroberfl�che."

!insertmacro PFI_LANG_STRING PFI_LANG_OPTIONS_MBDIFF_1    "POP3-Port und Port f�r die Benutzeroberfl�che d�rfen nicht identisch sein."
!insertmacro PFI_LANG_STRING PFI_LANG_OPTIONS_MBDIFF_2    "Bitte �ndern Sie ihre Port-Einstellungen."

; Banner message displayed whilst uninstalling old version

!insertmacro PFI_LANG_STRING PFI_LANG_OPTIONS_BANNER_1     "Bitte haben Sie einen Moment Geduld."
!insertmacro PFI_LANG_STRING PFI_LANG_OPTIONS_BANNER_2     "Dies kann einige Sekunden dauern..."

#--------------------------------------------------------------------------
# Standard MUI Page - Installing POPfile
#--------------------------------------------------------------------------

; Installation Progress Reports displayed above the progress bar

!insertmacro PFI_LANG_STRING PFI_LANG_INST_PROG_UPGRADE   "Suche evtl. existierende �ltere Versionen..."
!insertmacro PFI_LANG_STRING PFI_LANG_INST_PROG_CORE      "Installiere Kernkomponenten..."
!insertmacro PFI_LANG_STRING PFI_LANG_INST_PROG_PERL      "Installiere Minimal-Perl-Umgebung..."
!insertmacro PFI_LANG_STRING PFI_LANG_INST_PROG_SHORT     "Erzeuge Verkn�pfungen..."
!insertmacro PFI_LANG_STRING PFI_LANG_INST_PROG_FFCBACK   "Erstelle Corpus Backup. Dies kann einige Sekunden dauern..."
!insertmacro PFI_LANG_STRING PFI_LANG_INST_PROG_SKINS     "Installiere Skins..."
!insertmacro PFI_LANG_STRING PFI_LANG_INST_PROG_LANGS     "Installiere Sprachdateien..."
!insertmacro PFI_LANG_STRING PFI_LANG_INST_PROG_ENDSEC    "Klicken Sie auf Weiter um fortzufahren"

; Installation Log Messages

!insertmacro PFI_LANG_STRING PFI_LANG_INST_LOG_1          "Beende �ltere POPFile Version am Port"

; Message Box text strings

!insertmacro PFI_LANG_STRING PFI_LANG_MBSTPWDS_1          "Datei einer �lteren Version gefunden."
!insertmacro PFI_LANG_STRING PFI_LANG_MBSTPWDS_2          "Diese Datei aktualisieren?"
!insertmacro PFI_LANG_STRING PFI_LANG_MBSTPWDS_3          "W�hlen Sie 'Ja', um diese zu aktualisieren (Die alte Datei wird gespeichert unter"
!insertmacro PFI_LANG_STRING PFI_LANG_MBSTPWDS_4          "W�hlen Sie 'Nein', um die alte Datei zu behalten (Die neue Datei wird gespeichert unter"

!insertmacro PFI_LANG_STRING PFI_LANG_MBCFGBK_1           "Backup von"
!insertmacro PFI_LANG_STRING PFI_LANG_MBCFGBK_2           "existiert bereits"
!insertmacro PFI_LANG_STRING PFI_LANG_MBCFGBK_3           "Diese Datei �berschreiben?"
!insertmacro PFI_LANG_STRING PFI_LANG_MBCFGBK_4           "W�hlen Sie 'Ja', um diese zu �berschreiben, 'Nein', um kein neues Backup anzulegen."

!insertmacro PFI_LANG_STRING PFI_LANG_MBMANSHUT_1         "Unable to shutdown POPFile automatically."
!insertmacro PFI_LANG_STRING PFI_LANG_MBMANSHUT_2         "Please shutdown POPFile manually now."
!insertmacro PFI_LANG_STRING PFI_LANG_MBMANSHUT_3         "When POPFile has been shutdown, click 'OK' to continue."

!insertmacro PFI_LANG_STRING PFI_LANG_MBFFCERR_1          "Error detected when the installer tried to backup the old corpus."

#--------------------------------------------------------------------------
# Custom Page - POPFile Classification Bucket Creation
#--------------------------------------------------------------------------

; Page Title and Sub-title displayed in the page header

!insertmacro PFI_LANG_STRING PFI_LANG_CBP_TITLE           "POPFile Klassifikationskategorien erstellen"
!insertmacro PFI_LANG_STRING PFI_LANG_CBP_SUBTITLE        "POPFile ben�tigt MINDESTENS ZWEI Kategorien, um Ihre Emails klassifizieren zu k�nnen"

; Text strings displayed on the custom page

!insertmacro PFI_LANG_STRING PFI_LANG_CBP_IO_INTRO        "Nach der Installation k�nnen Sie die Anzahl der Kategorien (und deren Name) ohne Probleme an ihre Bed�rfnisse anpassen.\r\n\r\nKategorienamen bestehen aus Kleinbuchstaben, Ziffern von 0 bis 9, Bindestrich oder Unterstrich."
!insertmacro PFI_LANG_STRING PFI_LANG_CBP_IO_CREATE       "Erstellen Sie eine neue Kategorie, indem Sie entweder einen Namen aus der Liste w�hlen oder einen Namen ihrer Wahl eingeben."
!insertmacro PFI_LANG_STRING PFI_LANG_CBP_IO_DELETE       "Um eine oder mehr Kategorien von der Liste zu l�schen, markieren Sie die entsprechenden 'Entfernen' K�stchen und klicken Sie auf 'Weiter'."
!insertmacro PFI_LANG_STRING PFI_LANG_CBP_IO_LISTHDR      "Bereits eingerichtete Kategorien"
!insertmacro PFI_LANG_STRING PFI_LANG_CBP_IO_REMOVE       "Entfernen"
!insertmacro PFI_LANG_STRING PFI_LANG_CBP_IO_CONTINUE     "Weiter"

; Text strings used for status messages under the bucket list

!insertmacro PFI_LANG_STRING PFI_LANG_CBP_IO_MSG_1        "Sie m�ssen keine weiteren Kategorien hinzuf�gen"
!insertmacro PFI_LANG_STRING PFI_LANG_CBP_IO_MSG_2        "Sie m�ssen MINDESTENS zwei Kategorien angeben"
!insertmacro PFI_LANG_STRING PFI_LANG_CBP_IO_MSG_3        "Mindestens eine weitere Kategorie wird ben�tigt"
!insertmacro PFI_LANG_STRING PFI_LANG_CBP_IO_MSG_4        "Der Installer kann nicht mehr als"
!insertmacro PFI_LANG_STRING PFI_LANG_CBP_IO_MSG_5        "Kategorien anlegen."

; Message box text strings

!insertmacro PFI_LANG_STRING PFI_LANG_CBP_MBDUPERR_1      "Eine Kategorie mit dem Namen"
!insertmacro PFI_LANG_STRING PFI_LANG_CBP_MBDUPERR_2      "wurde bereits angelegt."
!insertmacro PFI_LANG_STRING PFI_LANG_CBP_MBDUPERR_3      "Bitte w�hlen Sie einen anderen Namen f�r die neue Kategorie."

!insertmacro PFI_LANG_STRING PFI_LANG_CBP_MBMAXERR_1      "Der Installer kann nur bis zu"
!insertmacro PFI_LANG_STRING PFI_LANG_CBP_MBMAXERR_2      "Kategorien anlegen."
!insertmacro PFI_LANG_STRING PFI_LANG_CBP_MBMAXERR_3      "Nach der Installation k�nnen Sie mehr als"

!insertmacro PFI_LANG_STRING PFI_LANG_CBP_MBNAMERR_1      "Der Name"
!insertmacro PFI_LANG_STRING PFI_LANG_CBP_MBNAMERR_2      "ist ung�ltig."
!insertmacro PFI_LANG_STRING PFI_LANG_CBP_MBNAMERR_3      "Kategorienamen k�nnen nur Kleinbuchstaben von a bis z, Ziffern von 0 bis 9, - oder _ enthalten"
!insertmacro PFI_LANG_STRING PFI_LANG_CBP_MBNAMERR_4      "Bitte w�hlen Sie einen anderen Namen f�r die neue Kategorie."

!insertmacro PFI_LANG_STRING PFI_LANG_CBP_MBCONTERR_1     "POPFile ben�tigt MINDESTES ZWEI Kategorien, um ihre Emails klassifizieren zu k�nnen."
!insertmacro PFI_LANG_STRING PFI_LANG_CBP_MBCONTERR_2     "Bitte geben Sie den Namen einer zu erstellenden Kategorie ein,$\r$\n$\r$\nindem Sie entweder einen der Vorschl�ge aus der Liste ausw�hlen$\r$\n$\r$\noder indem Sie einen Namen Ihrer Wahl eingeben."
!insertmacro PFI_LANG_STRING PFI_LANG_CBP_MBCONTERR_3     "Sie m�ssen MINDESTENS ZWEI Kategorien anlegen, bevor Sie die Installation fortsetzen k�nnen."

!insertmacro PFI_LANG_STRING PFI_LANG_CBP_MBDONE_1        "Kategorien zur Nutzung durch POPFile wurden angelegt."
!insertmacro PFI_LANG_STRING PFI_LANG_CBP_MBDONE_2        "Sollen diese Kategorien f�r POPFile eingerichtet werden?"
!insertmacro PFI_LANG_STRING PFI_LANG_CBP_MBDONE_3        "W�hlen Sie 'Nein', wenn Sie Ihre Auswahl korrigieren m�chten."

!insertmacro PFI_LANG_STRING PFI_LANG_CBP_MBMAKERR_1      "Der Installer konnte"
!insertmacro PFI_LANG_STRING PFI_LANG_CBP_MBMAKERR_2      "der "
!insertmacro PFI_LANG_STRING PFI_LANG_CBP_MBMAKERR_3      "von Ihnen angegebenen Kategorien nicht einrichten."
!insertmacro PFI_LANG_STRING PFI_LANG_CBP_MBMAKERR_4      "Nach Abschlu� der Installation k�nnen Sie �ber die Benutzeroberfl�che die fehlende(n) Kategorie(n) nachtr�glich einrichten."

#--------------------------------------------------------------------------
# Custom Page - Reconfigure Outlook Express
#--------------------------------------------------------------------------

; Page Title and Sub-title displayed in the page header

!insertmacro PFI_LANG_STRING PFI_LANG_OECFG_TITLE         "Outlook Express konfigurieren"
!insertmacro PFI_LANG_STRING PFI_LANG_OECFG_SUBTITLE      "POPFile kann Outlook Express automatisch zur Nutzung mit POPFile konfigurieren"

; Text displayed on the custom page

!insertmacro PFI_LANG_STRING PFI_LANG_OECFG_IO_INTRO      "POPFile hat die folgenden Outlook Express Email-Konten erkannt und kann diese automatisch zur Nutzung mit POPFile konfigurieren"
!insertmacro PFI_LANG_STRING PFI_LANG_OECFG_IO_CHECKBOX   "Account zur Nutzung mit POPFile konfigurieren"
!insertmacro PFI_LANG_STRING PFI_LANG_OECFG_IO_EMAIL      "Email Adresse:"
!insertmacro PFI_LANG_STRING PFI_LANG_OECFG_IO_SERVER     "POP3 Server:"
!insertmacro PFI_LANG_STRING PFI_LANG_OECFG_IO_USERNAME   "POP3 Benutzername:"
!insertmacro PFI_LANG_STRING PFI_LANG_OECFG_IO_RESTORE    "Wenn Sie POPFile deinstallieren, werden die alten Einstellungen wiederhergestellt"

!insertmacro PFI_LANG_STRING PFI_LANG_OECFG_IO_LINK_1     "Account f�r die"
!insertmacro PFI_LANG_STRING PFI_LANG_OECFG_IO_LINK_2     "Identit�t"

#--------------------------------------------------------------------------
# Custom Page - POPFile can now be started
#--------------------------------------------------------------------------

; Page Title and Sub-title displayed in the page header

!insertmacro PFI_LANG_STRING PFI_LANG_LAUNCH_TITLE        "POPFile kann nun gestartet werden"
!insertmacro PFI_LANG_STRING PFI_LANG_LAUNCH_SUBTITLE     "Die POPFile Benutzeroberfl�che funktioniert nur, wenn POPFile gestartet wurde"

; Text displayed on the custom page

!insertmacro PFI_LANG_STRING PFI_LANG_LAUNCH_IO_INTRO     "POPFile jetzt starten?"
!insertmacro PFI_LANG_STRING PFI_LANG_LAUNCH_IO_NO        "Nein (Die Benutzeroberfl�che kann bis zum Start von POPFile nicht verwendet werden)"
!insertmacro PFI_LANG_STRING PFI_LANG_LAUNCH_IO_DOSBOX    "POPFile starten (in einem Fenster)"
!insertmacro PFI_LANG_STRING PFI_LANG_LAUNCH_IO_BCKGRND   "POPFile im Hintergrund starten (kein Fenster anzeigen)"
!insertmacro PFI_LANG_STRING PFI_LANG_LAUNCH_IO_NOTE_1    "Wenn POPFile gestartet wurde, k�nnen Sie die Benutzeroberfl�che aufrufen, indem"
!insertmacro PFI_LANG_STRING PFI_LANG_LAUNCH_IO_NOTE_2    "(a) Sie auf das POPFile-Symbol neben der Uhr doppelklicken oder indem"
!insertmacro PFI_LANG_STRING PFI_LANG_LAUNCH_IO_NOTE_3    "(b) Sie Start --> Programme --> POPFile --> POPFile User Interface w�hlen."

; Banner message displayed whilst waiting for POPFile to start

!insertmacro PFI_LANG_STRING PFI_LANG_LAUNCH_BANNER_1     "Start von POPFile vorbereiten."
!insertmacro PFI_LANG_STRING PFI_LANG_LAUNCH_BANNER_2     "Dies kann einige Sekunden dauern..."

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

!insertmacro PFI_LANG_UNSTRING PFI_LANG_PROGRESS_1        "POPFile beenden..."
!insertmacro PFI_LANG_UNSTRING PFI_LANG_PROGRESS_2        "Startmen�-Eintr�ge von POPFile l�schen..."
!insertmacro PFI_LANG_UNSTRING PFI_LANG_PROGRESS_3        "Kernkomponenten l�schen..."
!insertmacro PFI_LANG_UNSTRING PFI_LANG_PROGRESS_4        "Outlook Express Einstellungen wiederherstellen..."
!insertmacro PFI_LANG_UNSTRING PFI_LANG_PROGRESS_5        "Skins l�schen..."
!insertmacro PFI_LANG_UNSTRING PFI_LANG_PROGRESS_6        "Minimal-Perl-Umgebung l�schen..."

; Uninstall Log Messages

!insertmacro PFI_LANG_UNSTRING PFI_LANG_LOG_1             "Beende POPFile am Port"
!insertmacro PFI_LANG_UNSTRING PFI_LANG_LOG_2             "Ge�ffnet"
!insertmacro PFI_LANG_UNSTRING PFI_LANG_LOG_3             "Wiederhergestellt"
!insertmacro PFI_LANG_UNSTRING PFI_LANG_LOG_4             "Geschlossen"
!insertmacro PFI_LANG_UNSTRING PFI_LANG_LOG_5             "Alle Dateien im POPFile-Verzeichnis l�schen"
!insertmacro PFI_LANG_UNSTRING PFI_LANG_LOG_6             "Hinweis: Es konnten nicht alle Dateien im POPFile-Verzeichnis gel�scht werden"

; Message Box text strings

!insertmacro PFI_LANG_UNSTRING PFI_LANG_MBNOTFOUND_1      "POPFile scheint nicht im folgenden Verzeichnis installiert zu sein:"
!insertmacro PFI_LANG_UNSTRING PFI_LANG_MBNOTFOUND_2      "Trotzdem fortfahren (nicht empfohlen)?"

!insertmacro PFI_LANG_UNSTRING PFI_LANG_ABORT_1           "Deinstallation vom Anwender abgebrochen"

!insertmacro PFI_LANG_UNSTRING PFI_LANG_MBREMDIR_1        "Wollen Sie alle Dateien im POPFile-Verzeichnis l�schen? (Wenn Sie irgendetwas erstellt haben, was sie behalten m�chten, w�hlen Sie Nein)"

!insertmacro PFI_LANG_UNSTRING PFI_LANG_MBREMERR_1        "Hinweis"
!insertmacro PFI_LANG_UNSTRING PFI_LANG_MBREMERR_2        "konnte nicht entfernt werden."

#--------------------------------------------------------------------------
# Mark the end of the language data
#--------------------------------------------------------------------------

!undef PFI_LANG

#--------------------------------------------------------------------------
# End of 'German-pfi.nsh'
#--------------------------------------------------------------------------
