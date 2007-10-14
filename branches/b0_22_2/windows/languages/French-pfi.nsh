#--------------------------------------------------------------------------
# French-pfi.nsh
#
# This file contains the "French" text strings used by the Windows installer
# and other NSIS-based Windows utilities for POPFile (includes customised versions
# of strings provided by NSIS and strings which are unique to POPFile).
#
# These strings are grouped according to the page/window and script where they are used
#
# Copyright (c) 2003-2007 John Graham-Cumming
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
# Translation created by: Olivier Guillion (olivier at myriad-online.com)
# Translation updated by: Olivier Guillion (olivier at myriad-online.com)
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

!define PFI_LANG  "FRENCH"

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

!insertmacro PFI_LANG_STRING PFI_LANG_BE_PATIENT           "Veuillez patienter."
!insertmacro PFI_LANG_STRING PFI_LANG_TAKE_A_FEW_SECONDS   "Ceci peut prendre quelques secondes..."

###########################################################################
###########################################################################

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; Shared: Message displayed when wizard does not seem to belong to the current installation [adduser.nsi, runpopfile.nsi]
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

!insertmacro PFI_LANG_STRING PFI_LANG_COMPAT_NOTFOUND      "Erreur: aucune version compatible de ${C_PFI_PRODUCT} n'a �t� trouv�e !"

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; Shared: Message box shown (before the WELCOME page) if another installer is running [installer.nsi, adduser.nsi]
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

!insertmacro PFI_LANG_STRING PFI_LANG_INSTALLER_MUTEX      "Une autre instance de l'installateur de POPFile est d�j� en cours d'ex�cution !"

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; Shared: Message box shown if 'SetEnvironmentVariableA' fails [installer.nsi, adduser.nsi, MonitorCC.nsi]
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

!insertmacro PFI_LANG_STRING PFI_LANG_CONVERT_ENVNOTSET    "Erreur : Impossible de fixer une variable d'environnement"

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; Shared: Standard MUI Page - DIRECTORY
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

; Used in message box shown if SFN support has been disabled [installer.nsi, adduser.nsi]

!insertmacro PFI_LANG_STRING PFI_LANG_DIRSELECT_MBNOSFN    "To install on the '$G_PLS_FIELD_1' drive${MB_NL}${MB_NL}please select a folder location which does not contain spaces"

; Used in message box shown if existing files found when installing [installer.nsi, adduser.nsi]

!insertmacro PFI_LANG_STRING PFI_LANG_DIRSELECT_MBWARN_2   "Voulez-vous la mettre � jour ?"

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; Shared: Standard MUI Page - INSTFILES
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

; When upgrading an existing installation, change the normal "Install" button to "Upgrade" [installer.nsi, adduser.nsi]

!insertmacro PFI_LANG_STRING PFI_LANG_INST_BTN_UPGRADE     "Mettre � jour"

; Installation Progress Reports displayed above the progress bar [installer.nsi, adduser.nsi]

!insertmacro PFI_LANG_STRING PFI_LANG_INST_PROG_UPGRADE    "Je v�rifie s'il s'agit de l'installation d'une mise � jour..."
!insertmacro PFI_LANG_STRING PFI_LANG_INST_PROG_SHORT      "Creation des raccourcis de POPFile..."
!insertmacro PFI_LANG_STRING PFI_LANG_INST_PROG_LANGS      "Installation des fichiers de langue de l'interface de POPFile..."

; Installation Progress Reports displayed above the progress bar [installer.nsi, adduser.nsi, getssl.nsh]

!insertmacro PFI_LANG_STRING PFI_LANG_INST_PROG_ENDSEC     "Cliquez sur 'Suivant' pour continuer"

; Progress Reports displayed above the progress bar when downloading/installing SSL support [addssl.nsi, getssl.nsh]

!insertmacro PFI_LANG_STRING PFI_LANG_PROG_CHECKIFRUNNING  "Checking if POPFile is running..."

; Installation Log Messages [installer.nsi, adduser.nsi]

!insertmacro PFI_LANG_STRING PFI_LANG_INST_LOG_SHUTDOWN    "Fermeture de la version pr�c�dente de POPFile en utilisant le port"

; Installation Log Messages [installer.nsi, addssl.nsi]

!insertmacro PFI_LANG_STRING PFI_LANG_PROG_SAVELOG         "Saving install log file..."

; Message Box text strings [installer.nsi, adduser.nsi, pfi-library.nsh]

!insertmacro PFI_LANG_STRING PFI_LANG_MBMANSHUT_1          "Impossible de fermer '$G_PLS_FIELD_1' automatiquement."
!insertmacro PFI_LANG_STRING PFI_LANG_MBMANSHUT_2          "Veuillez fermer '$G_PLS_FIELD_1' manuellement maintenant."
!insertmacro PFI_LANG_STRING PFI_LANG_MBMANSHUT_3          "Quand '$G_PLS_FIELD_1' sera ferm�, cliquez sur 'OK' pour continuer."

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; Shared: Message box shown if problem detected when trying to save the log file [installer.nsi, addssl.nsi, backup.nsi, restore.nsi]
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

!insertmacro PFI_LANG_STRING PFI_LANG_MB_SAVELOG_ERROR     "Error: problem detected when saving the log file"

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; Shared: Message boxes shown if uninstallation is not straightforward [installer.nsi, adduser.nsi]
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

!insertmacro PFI_LANG_STRING PFI_LANG_UN_MBDIFFUSER_1      "'$G_WINUSERNAME' tente de supprimer des donn�es appartenant � un autre utilisateur"

!insertmacro PFI_LANG_STRING PFI_LANG_UN_MBNOTFOUND_1      "POPFile ne semble pas install� dans le r�pertoire"
!insertmacro PFI_LANG_STRING PFI_LANG_UN_MBNOTFOUND_2      "Continuer quand m�me (non recommand�) ?"

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; Shared: Message box shown if uninstaller is cancelled by the user [installer.nsi, adduser.nsi]
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

!insertmacro PFI_LANG_STRING PFI_LANG_UN_ABORT_1           "D�sinstallation abandonn�e par l'utilisateur"

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; Shared: Standard MUI Page - UNPAGE_INSTFILES [installer.nsi, adduser.nsi]
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

; Uninstall Progress Reports displayed above the progress bar

!insertmacro PFI_LANG_STRING PFI_LANG_UN_PROG_SHUTDOWN     "Fermeture de POPFile..."
!insertmacro PFI_LANG_STRING PFI_LANG_UN_PROG_SHORT        "Suppression des entr�es de POPFile dans le menu D�marrer..."

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; Shared: Message box shown if uninstaller failed to remove files/folders [installer.nsi, adduser.nsi]
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

; TempTranslationNote: PFI_LANG_UN_MBREMERR_A = PFI_LANG_UN_MBREMERR_1 + ": $G_PLS_FIELD_1 " + PFI_LANG_UN_MBREMERR_2

!insertmacro PFI_LANG_STRING PFI_LANG_UN_MBREMERR_A        "Note: $G_PLS_FIELD_1 n'a pas pu �tre supprim�."

###########################################################################
###########################################################################

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; POPFile Installer: Message box shown (before the WELCOME page) offering to display the release notes [installer.nsi]
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

!insertmacro PFI_LANG_STRING PFI_LANG_MBRELNOTES_1         "Voir les 'Release Notes' de POPFile ?"
!insertmacro PFI_LANG_STRING PFI_LANG_MBRELNOTES_2         "'Oui' recommand� si vous effectuez une mise � jour de POPFile (vous pouvez avoir besoin d'effectuer une sauvegarde AVANT de mettre � jour)"

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; POPFile Installer: Standard MUI Page - WELCOME [installer.nsi]
;
; The PFI_LANG_WELCOME_INFO_TEXT string should end with a '${IO_NL}${IO_NL}$_CLICK' sequence).
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

!insertmacro PFI_LANG_STRING PFI_LANG_WELCOME_INFO_TEXT    "Vous �tes sur le point d'installer POPFile sur votre ordinateur.${IO_NL}${IO_NL}Avant de d�buter l'installation, il est recommand� de fermer toutes les autres applications.${IO_NL}${IO_NL}$_CLICK"
!insertmacro PFI_LANG_STRING PFI_LANG_WELCOME_ADMIN_TEXT   "NOTE IMPORTANTE :${IO_NL}${IO_NL}L'utilisateur actuel n'a PAS les droits 'Administrateur'.${IO_NL}${IO_NL}Si la gestion multi-utilisateurs est n�cessaire, il est pr�f�rable d'abandonner cette installation et d'utiliser un compte 'Administrateur' pour installer POPFile."

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; POPFile Installer: Custom Page - Check Perl Requirements [installer.nsi]
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

; Page Title displayed in the page header (there is no sub-title for this page)

!insertmacro PFI_LANG_STRING PFI_LANG_PERLREQ_TITLE        "Composants syst�me non � jour d�tect�s"

; Text strings displayed on the custom page

; TempTranslationNote: PFI_LANG_PERLREQ_IO_TEXT_A =  PFI_LANG_PERLREQ_IO_TEXT_1
; TempTranslationNote: PFI_LANG_PERLREQ_IO_TEXT_B =  PFI_LANG_PERLREQ_IO_TEXT_2
; TempTranslationNote: PFI_LANG_PERLREQ_IO_TEXT_C =  PFI_LANG_PERLREQ_IO_TEXT_3
; TempTranslationNote: PFI_LANG_PERLREQ_IO_TEXT_D =  PFI_LANG_PERLREQ_IO_TEXT_4
; TempTranslationNote: PFI_LANG_PERLREQ_IO_TEXT_E =  PFI_LANG_PERLREQ_IO_TEXT_5 + " $G_PLS_FIELD_1${IO_NL}${IO_NL}"
; TempTranslationNote: PFI_LANG_PERLREQ_IO_TEXT_F =  PFI_LANG_PERLREQ_IO_TEXT_6
; TempTranslationNote: PFI_LANG_PERLREQ_IO_TEXT_G =  PFI_LANG_PERLREQ_IO_TEXT_7

!insertmacro PFI_LANG_STRING PFI_LANG_PERLREQ_IO_TEXT_A    "Le navigateur par d�faut est utilis� pour visualiser l'interface utilisateur de POPFile (son centre de contr�le).${IO_NL}${IO_NL}"
!insertmacro PFI_LANG_STRING PFI_LANG_PERLREQ_IO_TEXT_B    "POPFile ne n�cessite pas un navigateur sp�cifique, il fonctionnera avec la plupart des navigateurs.${IO_NL}${IO_NL}"
!insertmacro PFI_LANG_STRING PFI_LANG_PERLREQ_IO_TEXT_C    "Une version minimale de Perl va �tre install�e (POPFile est �crit en Perl). "
!insertmacro PFI_LANG_STRING PFI_LANG_PERLREQ_IO_TEXT_D    "Le Perl fourni avec POPFile utilise certains composants d'Internet Explorer et n�cessite Internet Explorer 5.5 (ou une version plus r�cente)."
!insertmacro PFI_LANG_STRING PFI_LANG_PERLREQ_IO_TEXT_E    "L'installateur a d�tect� que ce syst�me poss�de Internet Explorer $G_PLS_FIELD_1${IO_NL}${IO_NL}"
!insertmacro PFI_LANG_STRING PFI_LANG_PERLREQ_IO_TEXT_F    "Il est possible que certaines fonctions de POPFile ne fonctionnent pas correctement sur ce syst�me.${IO_NL}${IO_NL}"
!insertmacro PFI_LANG_STRING PFI_LANG_PERLREQ_IO_TEXT_G    "Si vous avez des probl�mes lors de l'utilisation de POPFile, une mise � jour d'Internet Explorer en une version plus r�cente peut s'av�rer utile."

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; POPFile Installer: Standard MUI Page - COMPONENTS [installer.nsi]
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

!insertmacro PFI_LANG_STRING DESC_SecPOPFile               "Installe les fichiers de base n�cessaires � POPFile, comprenant une version minimale de Perl."
!insertmacro PFI_LANG_STRING DESC_SecSkins                 "Installe les habillages de POPFile qui vous permettent de changer l'apparence de l'interface utilisateur de POPFile."
!insertmacro PFI_LANG_STRING DESC_SecLangs                 "Installe les versions en langue non Anglaise de l'interface de POPFile."

!insertmacro PFI_LANG_STRING DESC_SubSecOptional           "Composants suppl�mentaires de POPFile (utilisateurs exp�riment�s)"
!insertmacro PFI_LANG_STRING DESC_SecIMAP                  "Installe le module IMAP de POPFile"
!insertmacro PFI_LANG_STRING DESC_SecNNTP                  "Installe le proxy NNTP de POPFile"
!insertmacro PFI_LANG_STRING DESC_SecSMTP                  "Installe le proxy SMTP de POPFile"
!insertmacro PFI_LANG_STRING DESC_SecSOCKS                 "Installe les composants suppl�mentaires du Perl permettant aux proxies de POPFile d'utiliser SOCKS"
!insertmacro PFI_LANG_STRING DESC_SecSSL                   "Downloads and installs the Perl components and SSL libraries which allow POPFile to make SSL connections to mail servers"
!insertmacro PFI_LANG_STRING DESC_SecXMLRPC                "Installe le module XMLRPC de POPFile (pour acc�der � l'API de POPFile) et le support Perl n�cessaire."

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; POPFile Installer: Standard MUI Page - DIRECTORY (for POPFile program files) [installer.nsi]
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

; Page Title shown in the page header and Text shown above the box showing the folder selected for the installation

!insertmacro PFI_LANG_STRING PFI_LANG_ROOTDIR_TITLE        "S�lectionnez l'emplacement d'installation de POPFile"
!insertmacro PFI_LANG_STRING PFI_LANG_ROOTDIR_TEXT_DESTN   "Dossier de destination du programme POPFile"

; Message box warnings used when verifying the installation folder chosen by user

!insertmacro PFI_LANG_STRING PFI_LANG_DIRSELECT_MBWARN_1   "Installation pr�c�dente trouv�e �"

; Text strings used when user has NOT selected a component found in the existing installation

!insertmacro PFI_LANG_STRING MBCOMPONENT_PROB_1            "Voulez-vous mettre � jour le composant $G_PLS_FIELD_1 existant ?"
!insertmacro PFI_LANG_STRING MBCOMPONENT_PROB_2            "(l'utilisation de composants de POPFile non � jour peut entra�ner des probl�mes)"

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; POPFile Installer: Custom Page - Setup Summary [installer.nsi]
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

; Page Title and Sub-title displayed in the page header
; $G_WINUSERNAME holds the Windows login name and $G_WINUSERTYPE holds 'Admin', 'Power', 'User', 'Guest' or 'Unknown'

!insertmacro PFI_LANG_STRING PFI_LANG_SUMMARY_TITLE        "Setup Summary for '$G_WINUSERNAME' ($G_WINUSERTYPE)"
!insertmacro PFI_LANG_STRING PFI_LANG_SUMMARY_SUBTITLE     "These settings will be used to install the POPFile program"

; Display selected installation location and whether or not an upgrade will be performed
; $G_ROOTDIR holds the installation location, e.g. C:\Program Files\POPFile

!insertmacro PFI_LANG_STRING PFI_LANG_SUMMARY_NEWLOCN      "New POPFile installation at $G_PLS_FIELD_2"
!insertmacro PFI_LANG_STRING PFI_LANG_SUMMARY_UPGRADELOCN  "Upgrade existing POPFile installation at $G_PLS_FIELD_2"

; By default all of these components are installed (but Kakasi is only installed when Japanese/Nihongo language is chosen)

!insertmacro PFI_LANG_STRING PFI_LANG_SUMMARY_BASICLIST    "Basic POPFile components to be installed:"
!insertmacro PFI_LANG_STRING PFI_LANG_SUMMARY_POPFILECORE  "POPFile program files"
!insertmacro PFI_LANG_STRING PFI_LANG_SUMMARY_MINPERL      "Minimal Perl"
!insertmacro PFI_LANG_STRING PFI_LANG_SUMMARY_DEFAULTSKIN  "Default UI Skin"
!insertmacro PFI_LANG_STRING PFI_LANG_SUMMARY_DEFAULTLANG  "Default UI Language"
!insertmacro PFI_LANG_STRING PFI_LANG_SUMMARY_EXTRASKINS   "Additional UI Skins"
!insertmacro PFI_LANG_STRING PFI_LANG_SUMMARY_EXTRALANGS   "Additional UI Languages"
!insertmacro PFI_LANG_STRING PFI_LANG_SUMMARY_KAKASI       "Kakasi package"

; By default none of the optional components is installed (user has to select them)

!insertmacro PFI_LANG_STRING PFI_LANG_SUMMARY_OPTIONLIST   "Optional POPFile components to be installed:"
!insertmacro PFI_LANG_STRING PFI_LANG_SUMMARY_NONE         "(none)"
!insertmacro PFI_LANG_STRING PFI_LANG_SUMMARY_IMAP         "IMAP module"
!insertmacro PFI_LANG_STRING PFI_LANG_SUMMARY_NNTP         "NNTP proxy"
!insertmacro PFI_LANG_STRING PFI_LANG_SUMMARY_SMTP         "SMTP proxy"
!insertmacro PFI_LANG_STRING PFI_LANG_SUMMARY_SOCKS        "SOCKS support"
!insertmacro PFI_LANG_STRING PFI_LANG_SUMMARY_SSL          "SSL support"
!insertmacro PFI_LANG_STRING PFI_LANG_SUMMARY_XMLRPC       "XMLRPC module"

; The last line in the summary explains how to change the installation selections

!insertmacro PFI_LANG_STRING PFI_LANG_SUMMARY_BACKBUTTON   "To make changes, use the 'Back' button to return to previous pages"

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; POPFile Installer: Standard MUI Page - INSTFILES [installer.nsi]
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

; Page Title and Sub-title displayed in the page header after installing all the files

!insertmacro PFI_LANG_STRING PFI_LANG_INSTFINISH_TITLE     "Les fichiers du programme sont install�s"
!insertmacro PFI_LANG_STRING PFI_LANG_INSTFINISH_SUBTITLE  "${C_PFI_PRODUCT} doit �tre configur� avant de pouvoir �tre utilis�"

; Installation Progress Reports displayed above the progress bar

!insertmacro PFI_LANG_STRING PFI_LANG_INST_PROG_CORE       "Installation des fichiers de base de POPFile..."
!insertmacro PFI_LANG_STRING PFI_LANG_INST_PROG_PERL       "Installation des fichiers minimaux du Perl..."
!insertmacro PFI_LANG_STRING PFI_LANG_INST_PROG_SKINS      "Installation des fichiers d'habillage de POPFile..."
!insertmacro PFI_LANG_STRING PFI_LANG_INST_PROG_XMLRPC     "Installation des fichiers XMLRPC de POPFile..."

; Message box used to get permission to delete the old minimal Perl before installing the new one

!insertmacro PFI_LANG_STRING PFI_LANG_MINPERL_MBREMOLD     "Delete everything in old minimal Perl folder before installing the new version ?${MB_NL}${MB_NL}($G_PLS_FIELD_1)"

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; POPFile Installer: Custom Page - Select uninstaller mode [installer.nsi]
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

; Page Title and Sub-title displayed in the page header of the uninstaller's first page

!insertmacro PFI_LANG_STRING PFI_LANG_UN_MODE_TITLE        "Select POPFile uninstaller mode"
!insertmacro PFI_LANG_STRING PFI_LANG_UN_MODE_SUBTITLE     "Modify or uninstall the installation in the $INSTDIR folder"

; Text for the MODIFY mode radio-button and the label underneath it

!insertmacro PFI_LANG_STRING PFI_LANG_UN_IO_MODE_RADIO     "Modify the existing POPFile installation"
!insertmacro PFI_LANG_STRING PFI_LANG_UN_IO_MODE_LABEL     "(e.g. add SSL Support)"

; Text for the UNINSTALL mode radio-button and the label underneath it

!insertmacro PFI_LANG_STRING PFI_LANG_UN_IO_UNINST_RADIO   "Uninstall the POPFile program"
!insertmacro PFI_LANG_STRING PFI_LANG_UN_IO_UNINST_LABEL   "(remove all of the POPFile program files from the computer)"

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; POPFile Installer: Standard MUI Page - UNPAGE_DIRECTORY [installer.nsi]
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

; Page Title/Sub-Title shown in the page header

!insertmacro PFI_LANG_STRING PFI_LANG_UN_DIR_TITLE         "Location of existing POPFile installation"
!insertmacro PFI_LANG_STRING PFI_LANG_UN_DIR_SUBTITLE      "This is where the selected POPFile components will be installed"

; Text explaining what this page shows

!insertmacro PFI_LANG_STRING PFI_LANG_UN_DIR_EXPLANATION   "Setup will modify the POPFile installation in this folder by adding extra components to it. To change the component selection, click the Back button. $_CLICK"

; Text shown above the box showing the folder where the extra components will be installed

!insertmacro PFI_LANG_STRING PFI_LANG_UN_DIR_TEXT_DESTN    "Destination folder for the new POPFile components"

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; POPFile Installer: Standard MUI Page - UNPAGE_INSTFILES [installer.nsi]
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

; Page Sub-title displayed when MODIFYING the installation (one of the standard MUI strings is used for the Title)

!insertmacro PFI_LANG_STRING PFI_LANG_UN_INST_SUBTITLE     "Please wait while $(^NameDA) is being updated"

; Page Title and Sub-Title shown instead of the default "Uninstallation complete..." page header

!insertmacro PFI_LANG_STRING PFI_LANG_UN_INST_OK_TITLE     "Add/Remove operation complete"
!insertmacro PFI_LANG_STRING PFI_LANG_UN_INST_OK_SUBTITLE  "Add/Remove operation was completed successfully."

; Page Title and Sub-Title shown instead of the default "Uninstallation Aborted..." page header

!insertmacro PFI_LANG_STRING PFI_LANG_UN_INST_BAD_TITLE    "Add/Remove operation aborted"
!insertmacro PFI_LANG_STRING PFI_LANG_UN_INST_BAD_SUBTITLE "Add/Remove operation was not completed successfully."

; Uninstall Progress Reports displayed above the progress bar

!insertmacro PFI_LANG_STRING PFI_LANG_UN_PROG_CORE         "Suppression des fichiers de base de POPFile..."
!insertmacro PFI_LANG_STRING PFI_LANG_UN_PROG_SKINS        "Suppression des fichiers d'habillage de POPFile..."
!insertmacro PFI_LANG_STRING PFI_LANG_UN_PROG_PERL         "Suppression des fichiers minimaux du Perl..."

; Uninstall Log Messages

!insertmacro PFI_LANG_STRING PFI_LANG_UN_LOG_SHUTDOWN      "Fermeture de POPFile en utilisant le port"
!insertmacro PFI_LANG_STRING PFI_LANG_UN_LOG_DELROOTDIR    "Suppression de tous les fichiers du r�pertoire de POPFile"
!insertmacro PFI_LANG_STRING PFI_LANG_UN_LOG_DELROOTERR    "Note : impossible de supprimer tous les fichiers du r�pertoire de POPFile"

; Message Box text strings

!insertmacro PFI_LANG_STRING PFI_LANG_UN_MBREMDIR_1        "Voulez-vous supprimer tous les fichiers de votre r�pertoire de POPFile ?${MB_NL}${MB_NL}$G_ROOTDIR${MB_NL}${MB_NL}(S'il contient quoi que ce soit que vous avez cr�� et d�sirez conserver, cliquez 'Non')"


###########################################################################
###########################################################################

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; SSL Setup: Standard MUI Page - WELCOME
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

!insertmacro PFI_LANG_STRING PSS_LANG_WELCOME_TITLE        "Welcome to the $(^NameDA) Wizard"
!insertmacro PFI_LANG_STRING PSS_LANG_WELCOME_TEXT         "This utility will download and install the files needed to allow POPFile to use SSL when accessing mail servers.${IO_NL}${IO_NL}This version does not configure any email accounts to use SSL, it just installs the necessary Perl components and DLLs.${IO_NL}${IO_NL}This product downloads and installs software developed by the OpenSSL Project for use in the OpenSSL Toolkit (http://www.openssl.org/)${IO_NL}${IO_NL}~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~${IO_NL}${IO_NL}   PLEASE SHUT DOWN POPFILE NOW${IO_NL}${IO_NL}~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~${IO_NL}${IO_NL}$_CLICK"

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; SSL Setup: Standard MUI Page - LICENSE
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

!insertmacro PFI_LANG_STRING PSS_LANG_LICENSE_SUBHDR       "Please review the license terms before using $(^NameDA)."
!insertmacro PFI_LANG_STRING PSS_LANG_LICENSE_BOTTOM       "If you accept the terms of the agreement, click the check box below. You must accept the agreement to use $(^NameDA). $_CLICK"

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; SSL Setup: Standard MUI Page - DIRECTORY
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

!insertmacro PFI_LANG_STRING PSS_LANG_DESTNDIR_TITLE       "Choose existing POPFile 0.22 (or later) installation"
!insertmacro PFI_LANG_STRING PSS_LANG_DESTNDIR_SUBTITLE    "SSL support should only be added to an existing POPFile installation"
!insertmacro PFI_LANG_STRING PSS_LANG_DESTNDIR_TEXT_TOP    "SSL support must be installed using the same installation folder as the POPFile program${MB_NL}${MB_NL}This utility will add SSL support to the version of POPFile which is installed in the following folder. To install in a different POPFile installation, click Browse and select another folder. $_CLICK"
!insertmacro PFI_LANG_STRING PSS_LANG_DESTNDIR_TEXT_DESTN  "Existing POPFile 0.22 (or later) installation folder"

!insertmacro PFI_LANG_STRING PSS_LANG_DESTNDIR_MB_WARN_1   "POPFile 0.22 (or later) does NOT seem to be installed in${MB_NL}${MB_NL}$G_PLS_FIELD_1"
!insertmacro PFI_LANG_STRING PSS_LANG_DESTNDIR_MB_WARN_2   "Are you sure you want to use this folder ?"

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; SSL Setup: Standard MUI Page - INSTFILES
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

; Initial page header

!insertmacro PFI_LANG_STRING PSS_LANG_STD_HDR              "Installing SSL support (for POPFile 0.22 or later)"
!insertmacro PFI_LANG_STRING PSS_LANG_STD_SUBHDR           "Please wait while the SSL files are downloaded and installed..."

; Successful completion page header

!insertmacro PFI_LANG_STRING PSS_LANG_END_HDR              "POPFile SSL Support installation completed"
!insertmacro PFI_LANG_STRING PSS_LANG_END_SUBHDR           "SSL support for POPFile has been installed successfully"

; Unsuccessful completion page header

!insertmacro PFI_LANG_STRING PSS_LANG_ABORT_HDR            "POPFile SSL Support installation failed"
!insertmacro PFI_LANG_STRING PSS_LANG_ABORT_SUBHDR         "The attempt to add SSL support to POPFile has failed"

; Progress reports

!insertmacro PFI_LANG_STRING PSS_LANG_PROG_INITIALISE      "Initializing..."
!insertmacro PFI_LANG_STRING PSS_LANG_PROG_USERCANCELLED   "POPFile SSL Support installation cancelled by the user"
!insertmacro PFI_LANG_STRING PSS_LANG_PROG_SUCCESS         "POPFile SSL support installed"

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; SSL Setup: Standard MUI Page - FINISH
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

!insertmacro PFI_LANG_STRING PSS_LANG_FINISH_TITLE         "Completing the $(^NameDA) Wizard"
!insertmacro PFI_LANG_STRING PSS_LANG_FINISH_TEXT          "SSL support for POPFile has been installed.${IO_NL}${IO_NL}You can now start POPFile and configure POPFile and your email client to use SSL.${IO_NL}${IO_NL}Click Finish to close this wizard."

!insertmacro PFI_LANG_STRING PSS_LANG_FINISH_README        "Important information"

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; SSL Setup: Miscellaneous Strings
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

!insertmacro PFI_LANG_STRING PSS_LANG_MUTEX                "Another copy of the SSL Setup wizard is running!"

!insertmacro PFI_LANG_STRING PSS_LANG_COMPAT_NOTFOUND      "Warning: Cannot find compatible version of POPFile !"

!insertmacro PFI_LANG_STRING PSS_LANG_ABORT_WARNING        "Are you sure you want to quit the $(^NameDA) Wizard?"

!insertmacro PFI_LANG_STRING PSS_LANG_PREPAREPATCH         "Updating Module.pm (to avoid slow speed SSL downloads)"
!insertmacro PFI_LANG_STRING PSS_LANG_PATCHSTATUS          "Module.pm patch status: $G_PLS_FIELD_1"
!insertmacro PFI_LANG_STRING PSS_LANG_PATCHCOMPLETED       "Module.pm file has been updated"
!insertmacro PFI_LANG_STRING PSS_LANG_PATCHFAILED          "Module.pm file has not been updated"

###########################################################################
###########################################################################

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; Get SSL: Strings used when downloading and installing the optional SSL files [getssl.nsh]
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

; Progress reports

!insertmacro PFI_LANG_STRING PFI_LANG_PROG_STARTDOWNLOAD   "Downloading $G_PLS_FIELD_1 file from $G_PLS_FIELD_2"
!insertmacro PFI_LANG_STRING PFI_LANG_PROG_FILECOPY        "Copying $G_PLS_FIELD_2 files..."
!insertmacro PFI_LANG_STRING PFI_LANG_PROG_FILEEXTRACT     "Extracting files from $G_PLS_FIELD_2 archive..."

!insertmacro PFI_LANG_STRING PFI_LANG_TAKE_SEVERAL_SECONDS "(this may take several seconds)"

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; Get SSL: Message Box strings used when installing SSL Support [getssl.nsh]
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

!insertmacro PFI_LANG_STRING PFI_LANG_MB_CHECKINTERNET     "The SSL Support files will be downloaded from the Internet.${MB_NL}${MB_NL}Your Internet connection seems to be down or disabled.${MB_NL}${MB_NL}Please reconnect and click Retry to resume installation"

!insertmacro PFI_LANG_STRING PFI_LANG_MB_NSISDLFAIL_1      "Download of $G_PLS_FIELD_1 file failed"
!insertmacro PFI_LANG_STRING PFI_LANG_MB_NSISDLFAIL_2      "(error: $G_PLS_FIELD_2)"

!insertmacro PFI_LANG_STRING PFI_LANG_MB_UNPACKFAIL        "Error detected while installing files in $G_PLS_FIELD_1 folder"

!insertmacro PFI_LANG_STRING PFI_LANG_MB_REPEATSSL         "Unable to install the optional SSL files!${MB_NL}${MB_NL}To try again later, run the command${MB_NL}${MB_NL}$G_PLS_FIELD_1 /SSL"

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; Get SSL: Strings used when patching SSL.pm from IO::Socket::SSL [getssl.nsh]
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

!insertmacro PFI_LANG_STRING PFI_LANG_SSLPREPAREPATCH      "Downgrading SSL.pm to v0.97"
!insertmacro PFI_LANG_STRING PFI_LANG_SSLPATCHSTATUS       "SSL.pm patch status: $G_PLS_FIELD_2"
!insertmacro PFI_LANG_STRING PFI_LANG_SSLPATCHCOMPLETED    "SSL.pm file has been downgraded to v0.97"
!insertmacro PFI_LANG_STRING PFI_LANG_SSLPATCHFAILED       "SSL.pm file has not been downgraded to v0.97"

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

!insertmacro PFI_LANG_STRING PFI_LANG_NSISDL_DOWNLOADING   "Downloading %s"
!insertmacro PFI_LANG_STRING PFI_LANG_NSISDL_CONNECTING    "Connecting ..."
!insertmacro PFI_LANG_STRING PFI_LANG_NSISDL_SECOND        "second"
!insertmacro PFI_LANG_STRING PFI_LANG_NSISDL_MINUTE        "minute"
!insertmacro PFI_LANG_STRING PFI_LANG_NSISDL_HOUR          "hour"
!insertmacro PFI_LANG_STRING PFI_LANG_NSISDL_PLURAL        "s"
!insertmacro PFI_LANG_STRING PFI_LANG_NSISDL_PROGRESS      "%dkB (%d%%) of %dkB @ %d.%01dkB/s"
!insertmacro PFI_LANG_STRING PFI_LANG_NSISDL_REMAINING     " (%d %s%s remaining)"

###########################################################################
###########################################################################

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; Add User: Standard MUI Page - WELCOME [adduser.nsi]
;
; The PFI_LANG_ADDUSER_INFO_TEXT string should end with a '${IO_NL}${IO_NL}$_CLICK' sequence).
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

!insertmacro PFI_LANG_STRING PFI_LANG_ADDUSER_INFO_TEXT    "Cet assistant va vous guider lors de la configuration de POPFile pour l'utilisateur '$G_WINUSERNAME'.${IO_NL}${IO_NL}Il est recommand� de fermer toutes les autres applications avant de continuer.${IO_NL}${IO_NL}$_CLICK"

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; Add User: Standard MUI Page - DIRECTORY [adduser.nsi]
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

; $G_WINUSERNAME holds the Windows login name for the user running the wizard

!insertmacro PFI_LANG_STRING PFI_LANG_USERDIR_TITLE        "S�lectionnez l'emplacement des donn�es de POPFile"
!insertmacro PFI_LANG_STRING PFI_LANG_USERDIR_SUBTITLE     "Choisissez le dossier dans lequel ranger les donn�es de POPFile pour '$G_WINUSERNAME'"
!insertmacro PFI_LANG_STRING PFI_LANG_USERDIR_TEXT_TOP     "Cette version de POPFile utilise des jeux de fichiers de donn�es diff�rents pour chaque utilisateur.${MB_NL}${MB_NL}L'installateur utilisera les dossiers suivants pour les donn�es de POPFile appartenant � l'utilisateur  '$G_WINUSERNAME'. Pour utiliser un dossier diff�rent pour cet utilisateur, cliquez sur 'Parcourir' et s�lectionnez un autre dossier. $_CLICK"
!insertmacro PFI_LANG_STRING PFI_LANG_USERDIR_TEXT_DESTN   "Dossier � utiliser pour stocker les donn�es de POPFile de '$G_WINUSERNAME'"

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; Add User: Standard MUI Page - INSTFILES [adduser.nsi]
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

; Page Title and Sub-title displayed in the page header

!insertmacro PFI_LANG_STRING PFI_LANG_ADDUSER_TITLE        "Configuration de POPFile pour l'utilisateur '$G_WINUSERNAME'"
!insertmacro PFI_LANG_STRING PFI_LANG_ADDUSER_SUBTITLE     "Veuillez patienter pendant que les fichiers de configuration de POPFile sont mis � jour pour cet utilisateur"

; When resetting POPFile to use newly restored 'User Data', change "Install" button to "Restore"

!insertmacro PFI_LANG_STRING PFI_LANG_INST_BTN_RESTORE     "Restaurer"

; Installation Progress Reports displayed above the progress bar

!insertmacro PFI_LANG_STRING PFI_LANG_INST_PROG_CORPUS     "Sauvegarde du corpus. Ceci peut prendre quelques secondes..."
!insertmacro PFI_LANG_STRING PFI_LANG_INST_PROG_SQLBACKUP  "Sauvegarde de l'ancienne base de donn�es SQLite..."
!insertmacro PFI_LANG_STRING PFI_LANG_INST_PROG_FINDCORPUS "Recherche des fichiers de corpus en mode texte ou BerkeleyDB..."
!insertmacro PFI_LANG_STRING PFI_LANG_INST_PROG_MAKEBAT    "G�n�ration du fichier de commande 'pfi-run.bat'..."
!insertmacro PFI_LANG_STRING PFI_LANG_INST_PROG_REGSET     "Mise � jour du registre et des variables d'environnement..."

; Message Box text strings

; TempTranslationNote: PFI_LANG_MBSTPWDS_A = "POPFile 'stopwords' " + PFI_LANG_MBSTPWDS_1
; TempTranslationNote: PFI_LANG_MBSTPWDS_B = PFI_LANG_MBSTPWDS_2
; TempTranslationNote: PFI_LANG_MBSTPWDS_C = PFI_LANG_MBSTPWDS_3 + " 'stopwords.bak')"
; TempTranslationNote: PFI_LANG_MBSTPWDS_D = PFI_LANG_MBSTPWDS_4 + " 'stopwords.default')"

!insertmacro PFI_LANG_STRING PFI_LANG_MBSTPWDS_A           "POPFile 'stopwords' fichiers d'une installation pr�c�dente trouv�s."
!insertmacro PFI_LANG_STRING PFI_LANG_MBSTPWDS_B           "D'accord pour mettre � jour ce fichier ?"
!insertmacro PFI_LANG_STRING PFI_LANG_MBSTPWDS_C           "Cliquez 'Oui' pour le mettre � jour (l'ancien fichier sera sauvegard� sous le nom 'stopwords.bak')"
!insertmacro PFI_LANG_STRING PFI_LANG_MBSTPWDS_D           "Cliquez 'Non' pour conserver l'ancien fichier (le nouveau fichier sera sauvegard� sous le nom 'stopwords.default')"

!insertmacro PFI_LANG_STRING PFI_LANG_MBCORPUS_1           "Erreur d�tect�e lors de la tentative de sauvegarde de l'ancien corpus."

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; Add User: Message box warnings used when verifying the installation folder chosen by user [adduser.nsi]
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

!insertmacro PFI_LANG_STRING PFI_LANG_DIRSELECT_MBWARN_3   "Donn�es de configuration pr�c�dentes trouv�es �"
!insertmacro PFI_LANG_STRING PFI_LANG_DIRSELECT_MBWARN_4   "Donn�es de configuration restaur�es trouv�es"
!insertmacro PFI_LANG_STRING PFI_LANG_DIRSELECT_MBWARN_5   "Voulez-vous utiliser les donn�es restaur�es ?"

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; Add User: Custom Page - POPFile Installation Options [adduser.nsi]
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

; Page Title and Sub-title displayed in the page header

!insertmacro PFI_LANG_STRING PFI_LANG_OPTIONS_TITLE        "Options d'installation de POPFile"
!insertmacro PFI_LANG_STRING PFI_LANG_OPTIONS_SUBTITLE     "Laissez ces options inchang�es sauf si vraiment n�cessaire"

; Text strings displayed on the custom page

!insertmacro PFI_LANG_STRING PFI_LANG_OPTIONS_IO_POP3      "Choisissez le num�ro de port par d�faut pour les connexions POP3 (110 recommand�)"
!insertmacro PFI_LANG_STRING PFI_LANG_OPTIONS_IO_GUI       "Choisissez le port par d�faut pour l'Interface Utilisateur (8080 recommand�)"
!insertmacro PFI_LANG_STRING PFI_LANG_OPTIONS_IO_STARTUP   "D�marrer POPFile automatiquement lors du d�marrage de Windows"
!insertmacro PFI_LANG_STRING PFI_LANG_OPTIONS_IO_WARNING   "AVIS IMPORTANT"
!insertmacro PFI_LANG_STRING PFI_LANG_OPTIONS_IO_MESSAGE   "SI VOUS METTEZ POPFILE A JOUR --- L'INSTALLATEUR VA FERMER LA VERSION EXISTANTE"

; Message Boxes used when validating user's selections

; TempTranslationNote: PFI_LANG_OPTIONS_MBPOP3_A = PFI_LANG_OPTIONS_MBPOP3_1 + " '$G_POP3'."
; TempTranslationNote: PFI_LANG_OPTIONS_MBPOP3_B = PFI_LANG_OPTIONS_MBPOP3_2
; TempTranslationNote: PFI_LANG_OPTIONS_MBPOP3_C = PFI_LANG_OPTIONS_MBPOP3_3

!insertmacro PFI_LANG_STRING PFI_LANG_OPTIONS_MBPOP3_A     "Le port POP3 ne peut pas �tre fix� � '$G_POP3'."
!insertmacro PFI_LANG_STRING PFI_LANG_OPTIONS_MBPOP3_B     "Le port doit �tre un nombre compris entre 1 et 65535."
!insertmacro PFI_LANG_STRING PFI_LANG_OPTIONS_MBPOP3_C     "Veuillez modifier le port POP3."

; TempTranslationNote: PFI_LANG_OPTIONS_MBGUI_A = PFI_LANG_OPTIONS_MBGUI_1 + " '$G_GUI'."
; TempTranslationNote: PFI_LANG_OPTIONS_MBGUI_B = PFI_LANG_OPTIONS_MBGUI_2
; TempTranslationNote: PFI_LANG_OPTIONS_MBGUI_C = PFI_LANG_OPTIONS_MBGUI_3

!insertmacro PFI_LANG_STRING PFI_LANG_OPTIONS_MBGUI_A      "Le port de l'Interface Utilisateur ne peut pas �tre fix� � '$G_GUI'."
!insertmacro PFI_LANG_STRING PFI_LANG_OPTIONS_MBGUI_B      "Le port doit �tre un nombre compris entre 1 et 65535."
!insertmacro PFI_LANG_STRING PFI_LANG_OPTIONS_MBGUI_C      "Veuillez modifier le port de l'Interface Utilisateur"

!insertmacro PFI_LANG_STRING PFI_LANG_OPTIONS_MBDIFF_1     "Le port POP3 doit �tre diff�rent du port de l'Interface Utilisateur."
!insertmacro PFI_LANG_STRING PFI_LANG_OPTIONS_MBDIFF_2     "Veuillez modifier votre s�lection des ports."

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

!insertmacro PFI_LANG_STRING PFI_LANG_CBP_DEFAULT_BUCKETS  "spam|personnel|professionnel|autre"
!insertmacro PFI_LANG_STRING PFI_LANG_CBP_SUGGESTED_NAMES  "admin|affaires|autre|boite_de_reception|divers|etudes|famille|finances|general|informatique|list-admin|loisirs|non_spam|personnel|pourriel|professionnel|recreation|securite|shopping|spam|voyages"

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; Add User: Custom Page - POPFile Classification Bucket Creation [CBP.nsh]
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

; Page Title and Sub-title displayed in the page header

!insertmacro PFI_LANG_STRING PFI_LANG_CBP_TITLE            "Cr�ation des cat�gories de classifications de POPFile"
!insertmacro PFI_LANG_STRING PFI_LANG_CBP_SUBTITLE         "POPFile a besoin D'AU MOINS DEUX cat�gories pour pouvoir classifier vos messages"

; Text strings displayed on the custom page

!insertmacro PFI_LANG_STRING PFI_LANG_CBP_IO_INTRO         "Apr�s installation, il vous sera facile de changer le nombre (et le nom) des cat�gories pour correspondre � vos besoins.${IO_NL}${IO_NL}Les noms des cat�gories doivent �tre en un seul mot, n'utilisant que des minuscules, des chiffres de 0 � 9, des tirets et des soulign�s."
!insertmacro PFI_LANG_STRING PFI_LANG_CBP_IO_CREATE        "Cr�ez une nouvelle cat�gorie soit en d�lectionnant un nom dans la liste ci-dessois, ou en tapant le nom de votre choix."
!insertmacro PFI_LANG_STRING PFI_LANG_CBP_IO_DELETE        "Pour supprimer une ou plusieurs cat�gories de la liste, cochez les cases 'Retirer' correspondantes et cliquez sur le bouton 'Continuer'."
!insertmacro PFI_LANG_STRING PFI_LANG_CBP_IO_LISTHDR       "Cat�gorie � utiliser dans POPFile"
!insertmacro PFI_LANG_STRING PFI_LANG_CBP_IO_REMOVE        "Retirer"
!insertmacro PFI_LANG_STRING PFI_LANG_CBP_IO_CONTINUE      "Continuer"

; Text strings used for status messages under the bucket list

; TempTranslationNote: PFI_LANG_CBP_IO_MSG_A = PFI_LANG_CBP_IO_MSG_1
; TempTranslationNote: PFI_LANG_CBP_IO_MSG_B = PFI_LANG_CBP_IO_MSG_2
; TempTranslationNote: PFI_LANG_CBP_IO_MSG_C = PFI_LANG_CBP_IO_MSG_3
; TempTranslationNote: PFI_LANG_CBP_IO_MSG_D = PFI_LANG_CBP_IO_MSG_4 + " $G_PLS_FIELD_1 " + PFI_LANG_CBP_IO_MSG_5

!insertmacro PFI_LANG_STRING PFI_LANG_CBP_IO_MSG_A         "Il est inutile d'ajouter d'autres cat�gories"
!insertmacro PFI_LANG_STRING PFI_LANG_CBP_IO_MSG_B         "Vous devez d�finir AU MOINS DEUX cat�gories"
!insertmacro PFI_LANG_STRING PFI_LANG_CBP_IO_MSG_C         "Au moins une cat�gorie de plus est n�cessaire"
!insertmacro PFI_LANG_STRING PFI_LANG_CBP_IO_MSG_D         "L'installateur ne peut pas cr�er plus de $G_PLS_FIELD_1 cat�gories"

; Message box text strings

; TempTranslationNote: PFI_LANG_CBP_MBDUPERR_A = PFI_LANG_CBP_MBDUPERR_1 + " '$G_PLS_FIELD_1' " + PFI_LANG_CBP_MBDUPERR_2
; TempTranslationNote: PFI_LANG_CBP_MBDUPERR_B = PFI_LANG_CBP_MBDUPERR_3

!insertmacro PFI_LANG_STRING PFI_LANG_CBP_MBDUPERR_A       "Une cat�gorie nomm�e '$G_PLS_FIELD_1' a d�j� �t� d�finie."
!insertmacro PFI_LANG_STRING PFI_LANG_CBP_MBDUPERR_B       "Veuillez choisir un autre nom pour la nouvelle cat�gorie."

; TempTranslationNote: PFI_LANG_CBP_MBMAXERR_A = PFI_LANG_CBP_MBMAXERR_1 + " $G_PLS_FIELD_1 " + PFI_LANG_CBP_MBMAXERR_2
; TempTranslationNote: PFI_LANG_CBP_MBMAXERR_B = PFI_LANG_CBP_MBMAXERR_3 + " $G_PLS_FIELD_1 " + PFI_LANG_CBP_MBMAXERR_2

!insertmacro PFI_LANG_STRING PFI_LANG_CBP_MBMAXERR_A       "L'installateur ne peut cr�er que jusqu'� $G_PLS_FIELD_1 cat�gories."
!insertmacro PFI_LANG_STRING PFI_LANG_CBP_MBMAXERR_B       "Une fois que POPFile a �t� install� vous pouvez cr�er plus de $G_PLS_FIELD_1 cat�gories"

; TempTranslationNote: PFI_LANG_CBP_MBNAMERR_A = PFI_LANG_CBP_MBNAMERR_1 + " '$G_PLS_FIELD_1' " + PFI_LANG_CBP_MBNAMERR_2
; TempTranslationNote: PFI_LANG_CBP_MBNAMERR_B = PFI_LANG_CBP_MBNAMERR_3
; TempTranslationNote: PFI_LANG_CBP_MBNAMERR_C = PFI_LANG_CBP_MBNAMERR_4

!insertmacro PFI_LANG_STRING PFI_LANG_CBP_MBNAMERR_A       "Le nom '$G_PLS_FIELD_1' n'est pas un nom valide pour une cat�gorie."
!insertmacro PFI_LANG_STRING PFI_LANG_CBP_MBNAMERR_B       "Les noms de cat�gories ne peuvent contenir que les minuscules de a � z ainsi que - and _"
!insertmacro PFI_LANG_STRING PFI_LANG_CBP_MBNAMERR_C       "Veuillez choisir un autre nom pour la nouvelle cat�gorie."

!insertmacro PFI_LANG_STRING PFI_LANG_CBP_MBCONTERR_1      "POPFile a besoin d'AU MOINS DEUX cat�gories pour pouvoir classifier vos messages."
!insertmacro PFI_LANG_STRING PFI_LANG_CBP_MBCONTERR_2      "Veuillez entrer le nom de la cat�gorie � cr�er${MB_NL}${MB_NL}soit en le choisissant dans la liste${MB_NL}${MB_NL}soit en tapant le nom de votre choix."
!insertmacro PFI_LANG_STRING PFI_LANG_CBP_MBCONTERR_3      "Vous devez d�finir AU MOINS DEUX cat�gories avant de poursuivre l'installation de POPFile."

; TempTranslationNote: PFI_LANG_CBP_MBDONE_A = "$G_PLS_FIELD_1 " + PFI_LANG_CBP_MBDONE_1
; TempTranslationNote: PFI_LANG_CBP_MBDONE_B = PFI_LANG_CBP_MBDONE_2
; TempTranslationNote: PFI_LANG_CBP_MBDONE_C = PFI_LANG_CBP_MBDONE_3

!insertmacro PFI_LANG_STRING PFI_LANG_CBP_MBDONE_A         "$G_PLS_FIELD_1 cat�gories ont �t� d�finies pour �tre utilis�es par POPFile."
!insertmacro PFI_LANG_STRING PFI_LANG_CBP_MBDONE_B         "Voulez-vous configurer POPFile pour utiliser ces cat�gories ?"
!insertmacro PFI_LANG_STRING PFI_LANG_CBP_MBDONE_C         "Cliquez sur 'Non' si vous d�sirer modifier votre choix des cat�gories."

; TempTranslationNote: PFI_LANG_CBP_MBMAKERR_A = PFI_LANG_CBP_MBMAKERR_1 + " $G_PLS_FIELD_1 " + PFI_LANG_CBP_MBMAKERR_2 + " $G_PLS_FIELD_2 " + PFI_LANG_CBP_MBMAKERR_3
; TempTranslationNote: PFI_LANG_CBP_MBMAKERR_B = PFI_LANG_CBP_MBMAKERR_4

!insertmacro PFI_LANG_STRING PFI_LANG_CBP_MBMAKERR_A       "L'installateur n'a pas pu cr�er $G_PLS_FIELD_1 des $G_PLS_FIELD_2 cat�gories que vous avez choisies."
!insertmacro PFI_LANG_STRING PFI_LANG_CBP_MBMAKERR_B       "Une fois POPFile install�, vous pouvez utiliser le panneau de contr�le${MB_NL}${MB_NL}de l'interface utilisateur pour cr�er les cat�gories manquantes."

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; Add User: Custom Page - Email Client Reconfiguration [adduser.nsi]
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

; Page Title and Sub-title displayed in the page header

!insertmacro PFI_LANG_STRING PFI_LANG_MAILCFG_TITLE        "Configuration du client de messagerie"
!insertmacro PFI_LANG_STRING PFI_LANG_MAILCFG_SUBTITLE     "POPFile peut reconfigurer divers clients de messagerie automatiquement"

; Text displayed on the custom page

!insertmacro PFI_LANG_STRING PFI_LANG_MAILCFG_IO_TEXT_1    "Les clients de messagerie marqu�s par (*) peuvent �tre reconfigur�s automatiquement, � condition que des comptes simples soient utilis�s.${IO_NL}${IO_NL}Il est fortement recommand� de configurer manuellement les comptes n�cessitant une authentification."
!insertmacro PFI_LANG_STRING PFI_LANG_MAILCFG_IO_TEXT_2    "IMPORTANT: VEUILLEZ FERMER LES CLIENTS DE MESSAGERIES MAINTENANT${IO_NL}${IO_NL}Cette fonctionnalit� est encore en cours de d�veloppement (p. ex. certains comptes Outlook peuvent ne pas �tre d�tect�s).${IO_NL}${IO_NL}Veuillez v�rifier que la reconfiguration a bien �t� effectu�e avant d'utiliser votre client de messagerie)."

!insertmacro PFI_LANG_STRING PFI_LANG_MAILCFG_IO_CANCEL    "Reconfiguration du client de messagerie abandonn�e par l'utilisateur"
!insertmacro PFI_LANG_STRING PFI_LANG_MAILCFG_IO_NOMATCHES "No suitable email clients found"

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; Add User: Text used on buttons to skip configuration of email clients [adduser.nsi]
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

!insertmacro PFI_LANG_STRING PFI_LANG_MAILCFG_IO_SKIPALL   "Ignorer tous"
!insertmacro PFI_LANG_STRING PFI_LANG_MAILCFG_IO_SKIPONE   "Ignorer le client"

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; Add User: Message box warnings that an email client is still running [adduser.nsi]
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

!insertmacro PFI_LANG_STRING PFI_LANG_MBCLIENT_EXP         "ATTENTION: Outlook Express est en cours d'utilisation !"
!insertmacro PFI_LANG_STRING PFI_LANG_MBCLIENT_OUT         "ATTENTION: Outlook est en cours d'utilisation !"
!insertmacro PFI_LANG_STRING PFI_LANG_MBCLIENT_EUD         "ATTENTION: Eudora est en cours d'utilisation !"

!insertmacro PFI_LANG_STRING PFI_LANG_MBCLIENT_STOP_1      "Veuillez FERMER le programme de messagerie et cliquer sur 'R�essayer' pour le reconfiguer"
!insertmacro PFI_LANG_STRING PFI_LANG_MBCLIENT_STOP_2      "(Vous pouvez cliquer sur 'Ignorer' pour le reconfigurer, mais ceci n'est pas recommand�)"
!insertmacro PFI_LANG_STRING PFI_LANG_MBCLIENT_STOP_3      "Cliquez sur 'Abandonner' pour ne pas effectuer la reconfiguration de ce programme de messagerie"

; Following three strings are used when uninstalling

!insertmacro PFI_LANG_STRING PFI_LANG_MBCLIENT_STOP_4      "Veuillez FERMER le programme de messagerie et cliquer sur 'R�essayer' pour restaurer les param�tres"
!insertmacro PFI_LANG_STRING PFI_LANG_MBCLIENT_STOP_5      "(Vous pouvez cliquer sur 'Ignorer' pour restaurer les param�tres, mais ceci n'est pas recommand�)"
!insertmacro PFI_LANG_STRING PFI_LANG_MBCLIENT_STOP_6      "Cliquez sur 'Abandonner' pour ne pas effectuer la restauration des param�tres d'origine"

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; Add User: Custom Page - Reconfigure Outlook/Outlook Express [adduser.nsi]
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

; Page Title and Sub-title displayed in the page header

!insertmacro PFI_LANG_STRING PFI_LANG_EXPCFG_TITLE         "Reconfigurer Outlook Express"
!insertmacro PFI_LANG_STRING PFI_LANG_EXPCFG_SUBTITLE      "POPFile peut reconfigurer Outlook Express � votre place"

!insertmacro PFI_LANG_STRING PFI_LANG_OUTCFG_TITLE         "Reconfigurer Outlook"
!insertmacro PFI_LANG_STRING PFI_LANG_OUTCFG_SUBTITLE      "POPFile peut reconfigurer Outlook � votre place"

; Text displayed on the custom page

!insertmacro PFI_LANG_STRING PFI_LANG_EXPCFG_IO_CANCELLED  "Reconfiguration d'Outlook Express abandonn�e par l'utilisateur"
!insertmacro PFI_LANG_STRING PFI_LANG_OUTCFG_IO_CANCELLED  "Reconfiguration d'Outlook abandonn�e par l'utilisateur"

!insertmacro PFI_LANG_STRING PFI_LANG_OOECFG_IO_BOXHDR     "comptes"
!insertmacro PFI_LANG_STRING PFI_LANG_OOECFG_IO_ACCOUNTHDR "Compte"
!insertmacro PFI_LANG_STRING PFI_LANG_OOECFG_IO_EMAILHDR   "Adresse �lectronique"
!insertmacro PFI_LANG_STRING PFI_LANG_OOECFG_IO_SERVERHDR  "Serveur"
!insertmacro PFI_LANG_STRING PFI_LANG_OOECFG_IO_USRNAMEHDR "Nom d'utilisateur"
!insertmacro PFI_LANG_STRING PFI_LANG_OOECFG_IO_FOOTNOTE   "Cocher les cases pour reconfigurer les comptes.${IO_NL}Si vous d�sinstallez POPFile, les param�tres d'origine seront restaur�s."

; Message Box to confirm changes to Outlook/Outlook Express account configuration

!insertmacro PFI_LANG_STRING PFI_LANG_EXPCFG_MBIDENTITY    "Identit� Outlook Express :"
!insertmacro PFI_LANG_STRING PFI_LANG_EXPCFG_MBACCOUNT     "Compte Outlook Express :"

!insertmacro PFI_LANG_STRING PFI_LANG_OUTCFG_MBIDENTITY    "Utilisateur Outlook :"
!insertmacro PFI_LANG_STRING PFI_LANG_OUTCFG_MBACCOUNT     "Compte Outlook :"

!insertmacro PFI_LANG_STRING PFI_LANG_OOECFG_MBEMAIL       "Adresse �lectronique :"
!insertmacro PFI_LANG_STRING PFI_LANG_OOECFG_MBSERVER      "Serveur POP3 :"
!insertmacro PFI_LANG_STRING PFI_LANG_OOECFG_MBUSERNAME    "Nom d'utilisateur POP3 :"
!insertmacro PFI_LANG_STRING PFI_LANG_OOECFG_MBOEPORT      "Port POP3 :"
!insertmacro PFI_LANG_STRING PFI_LANG_OOECFG_MBSMTPLOGIN   "SMTP username will be set to ' $G_PLS_FIELD_2'"
!insertmacro PFI_LANG_STRING PFI_LANG_OOECFG_MBOLDVALUE    "actuellement"
!insertmacro PFI_LANG_STRING PFI_LANG_OOECFG_MBQUESTION    "Reconfigurer ce compte pour fonctionner avec POPFile ?"

; Title and Column headings for report/log files

!insertmacro PFI_LANG_STRING PFI_LANG_EXPCFG_LOG_BEFORE    "Param�tres d'Outlook Express avant que les modifications soient effectu�es"
!insertmacro PFI_LANG_STRING PFI_LANG_EXPCFG_LOG_AFTER     "Modifications apport�es aux param�tres d'Outlook Express"

!insertmacro PFI_LANG_STRING PFI_LANG_OUTCFG_LOG_BEFORE    "Param�tres d'Outlook avant que les modifications soient effectu�es"
!insertmacro PFI_LANG_STRING PFI_LANG_OUTCFG_LOG_AFTER     "Modifications apport�es aux param�tres d'Outlook"

!insertmacro PFI_LANG_STRING PFI_LANG_OOECFG_LOG_END       "(fin)"

!insertmacro PFI_LANG_STRING PFI_LANG_EXPCFG_LOG_IDENTITY  "'IDENTITE'"
!insertmacro PFI_LANG_STRING PFI_LANG_OUTCFG_LOG_IDENTITY  "'UTILISATEUR OUTLOOK'"

!insertmacro PFI_LANG_STRING PFI_LANG_OOECFG_LOG_ACCOUNT   "'COMPTE'"

!insertmacro PFI_LANG_STRING PFI_LANG_OOECFG_LOG_EMAIL     "'ADRESSE ELECTRONIQUE'"
!insertmacro PFI_LANG_STRING PFI_LANG_OOECFG_LOG_SERVER    "'SERVEUR POP3'"
!insertmacro PFI_LANG_STRING PFI_LANG_OOECFG_LOG_USER      "'UTILISATEUR POP3'"
!insertmacro PFI_LANG_STRING PFI_LANG_OOECFG_LOG_PORT      "'PORT POP3'"

!insertmacro PFI_LANG_STRING PFI_LANG_OOECFG_LOG_NEWSERVER "'NOUVEAU SERVEUR POP3'"
!insertmacro PFI_LANG_STRING PFI_LANG_OOECFG_LOG_NEWUSER   "'NOUVEL UTILISATEUR POP3'"
!insertmacro PFI_LANG_STRING PFI_LANG_OOECFG_LOG_NEWPORT   "'NOUVEAU PORT POP3'"

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; Add User: Custom Page - Reconfigure Eudora [adduser.nsi]
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

; Page Title and Sub-title displayed in the page header

!insertmacro PFI_LANG_STRING PFI_LANG_EUCFG_TITLE          "Reconfigurer Eudora"
!insertmacro PFI_LANG_STRING PFI_LANG_EUCFG_SUBTITLE       "POPFile peut reconfigurer Eudora � votre place"

; Text displayed on the custom page

!insertmacro PFI_LANG_STRING PFI_LANG_EUCFG_IO_CANCELLED   "Reconfiguration d'Eudora abandonn�e par l'utilisateur"

!insertmacro PFI_LANG_STRING PFI_LANG_EUCFG_IO_INTRO_1     "POPFile a d�tect� les personnalit�s Eudora suivantes"
!insertmacro PFI_LANG_STRING PFI_LANG_EUCFG_IO_INTRO_2     " et peut les configurer automatiquement pour fonctionner avec POPFile"
!insertmacro PFI_LANG_STRING PFI_LANG_EUCFG_IO_CHECKBOX    "Reconfigurer cette personnalit� pour fonctionner avec POPFile"
!insertmacro PFI_LANG_STRING PFI_LANG_EUCFG_IO_DOMINANT    "personnalit� <Dominante>"
!insertmacro PFI_LANG_STRING PFI_LANG_EUCFG_IO_PERSONA     "personnalit�"
!insertmacro PFI_LANG_STRING PFI_LANG_EUCFG_IO_EMAIL       "Adresse �lectronique :"
!insertmacro PFI_LANG_STRING PFI_LANG_EUCFG_IO_SERVER      "Serveur POP3 :"
!insertmacro PFI_LANG_STRING PFI_LANG_EUCFG_IO_USERNAME    "Nom d'utilisateur POP3 :"
!insertmacro PFI_LANG_STRING PFI_LANG_EUCFG_IO_POP3PORT    "Port POP3 :"
!insertmacro PFI_LANG_STRING PFI_LANG_EUCFG_IO_RESTORE     "Si vous d�sinstallez POPFile, les param�tres d'origine seront restaur�s."

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; Add User: Custom Page - POPFile can now be started [adduser.nsi]
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

; Page Title and Sub-title displayed in the page header

!insertmacro PFI_LANG_STRING PFI_LANG_LAUNCH_TITLE         "POPFile peut maintenant �tre d�marr�"
!insertmacro PFI_LANG_STRING PFI_LANG_LAUNCH_SUBTITLE      "L'interface utilisateur de POPFile ne fonctionne que si POPFile a �t� d�marr�"

; Text displayed on the custom page

!insertmacro PFI_LANG_STRING PFI_LANG_LAUNCH_IO_INTRO      "D�marrer POPFile maintenant ?"
!insertmacro PFI_LANG_STRING PFI_LANG_LAUNCH_IO_NO         "Non (l'Interface Utilisateur ne peut pas �tre utilis�e si POPFile n'est pas lanc�)"
!insertmacro PFI_LANG_STRING PFI_LANG_LAUNCH_IO_DOSBOX     "D�marrer POPFile (dans une fen�tre)"
!insertmacro PFI_LANG_STRING PFI_LANG_LAUNCH_IO_BCKGRND    "D�marrer POPFile en t�che de fond (aucune fen�tre visible)"
!insertmacro PFI_LANG_STRING PFI_LANG_LAUNCH_IO_NOICON     "D�marrer POPFile (pas d'ic�ne dans la barre de t�ches)"
!insertmacro PFI_LANG_STRING PFI_LANG_LAUNCH_IO_TRAYICON   "D�marrer POPFile avec une ic�ne dans la barre de t�ches"
!insertmacro PFI_LANG_STRING PFI_LANG_LAUNCH_IO_NOTE_1     "Une fois POPFile d�marr�, vous pouvez utiliser l'Interface Utilisateur"
!insertmacro PFI_LANG_STRING PFI_LANG_LAUNCH_IO_NOTE_2     "(a) en double-cliquant l'ic�ne de POPFile dans la barre de t�ches, OU"
!insertmacro PFI_LANG_STRING PFI_LANG_LAUNCH_IO_NOTE_3     "(b) en utilisant D�marrer --> Programmes --> POPFile --> Interface Utilisateur de POPFile."

; Banner message displayed whilst waiting for POPFile to start

!insertmacro PFI_LANG_STRING PFI_LANG_LAUNCH_BANNER_1      "Pr�paration au d�marrage de POPFile."
!insertmacro PFI_LANG_STRING PFI_LANG_LAUNCH_BANNER_2      "Ceci peut prendre quelques secondes..."

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; Add User: Standard MUI Page - FINISH [adduser.nsi]
;
; The PFI_LANG_FINISH_RUN_TEXT text should be a short phrase (not a long paragraph)
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

; $G_WINUSERNAME holds the Windows login name of the user running the wizard

!insertmacro PFI_LANG_STRING PFI_LANG_ADDUSER_FINISH_INFO "POPFile a �t� configur� pour l'utilisateur '$G_WINUSERNAME'.${IO_NL}${IO_NL}Cliquez sur 'Fermer' pour fermer cet assistant."

!insertmacro PFI_LANG_STRING PFI_LANG_FINISH_RUN_TEXT      "Interface Utilisateur de POPFile"
!insertmacro PFI_LANG_STRING PFI_LANG_FINISH_WEB_LINK_TEXT "Click here to visit the POPFile web site"

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; Add User: Standard MUI Page - Uninstall Confirmation Page (for the 'Add POPFile User' wizard) [adduser.nsi]
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

; $G_WINUSERNAME holds the Windows login name for the user running the uninstall wizard

!insertmacro PFI_LANG_STRING PFI_LANG_REMUSER_TITLE        "D�sinstallation des donn�es de POPFile pour l'utilisateur '$G_WINUSERNAME'"
!insertmacro PFI_LANG_STRING PFI_LANG_REMUSER_SUBTITLE     "Supprime les donn�es de configuration de POPFile pour cet utilisateur"

!insertmacro PFI_LANG_STRING PFI_LANG_REMUSER_TEXT_TOP     "Les donn�es de configuration de POPFile pour l'utilisateur '$G_WINUSERNAME' vont �tre d�sinstall�es du dossier suivant. $_CLICK"

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; Add User: Standard MUI Page - Uninstallation Page (for the 'Add POPFile User' wizard) [adduser.nsi]
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

; $G_WINUSERNAME holds the Windows login name for the user running the uninstall wizard

!insertmacro PFI_LANG_STRING PFI_LANG_REMOVING_TITLE       "D�sinstallation des donn�es de POPFile pour l'utilisateur '$G_WINUSERNAME'"
!insertmacro PFI_LANG_STRING PFI_LANG_REMOVING_SUBTITLE    "Veuillez patienter pendant la suppression des donn�es de POPFile pour cet utilisateur"

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; Add User: Standard MUI Page - UNPAGE_INSTFILES [adduser.nsi]
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

; Uninstall Progress Reports displayed above the progress bar

!insertmacro PFI_LANG_STRING PFI_LANG_UN_PROG_OUTEXPRESS   "Restauration des param�tres d'Outlook Express..."
!insertmacro PFI_LANG_STRING PFI_LANG_UN_PROG_OUTLOOK      "Restauration des param�tres d'Outlook..."
!insertmacro PFI_LANG_STRING PFI_LANG_UN_PROG_EUDORA       "Restauration des param�tres d'Eudora..."
!insertmacro PFI_LANG_STRING PFI_LANG_UN_PROG_DBMSGDIR     "Suppression du corpus et du r�pertoire 'Messages r�cents'..."
!insertmacro PFI_LANG_STRING PFI_LANG_UN_PROG_CONFIG       "Suppression des donn�es de configuration..."
!insertmacro PFI_LANG_STRING PFI_LANG_UN_PROG_EXESTATUS    "V�rification de l'�tat du programme..."
!insertmacro PFI_LANG_STRING PFI_LANG_UN_PROG_REGISTRY     "Suppression des entr�es du registre de POPFile..."

; Uninstall Log Messages

!insertmacro PFI_LANG_STRING PFI_LANG_UN_LOG_EXPRUN        "Outlook Express is still running!"
!insertmacro PFI_LANG_STRING PFI_LANG_UN_LOG_OUTRUN        "Outlook is still running!"
!insertmacro PFI_LANG_STRING PFI_LANG_UN_LOG_EUDRUN        "Eudora is still running!"
!insertmacro PFI_LANG_STRING PFI_LANG_UN_LOG_IGNORE        "User requested restore while email program is running"

!insertmacro PFI_LANG_STRING PFI_LANG_UN_LOG_OPENED        "Ouvert"
!insertmacro PFI_LANG_STRING PFI_LANG_UN_LOG_RESTORED      "Restaur�"
!insertmacro PFI_LANG_STRING PFI_LANG_UN_LOG_CLOSED        "Ferm�"
!insertmacro PFI_LANG_STRING PFI_LANG_UN_LOG_DATAPROBS     "Probl�mes de donn�es"
!insertmacro PFI_LANG_STRING PFI_LANG_UN_LOG_DELUSERDIR    "Suppression de tous les fichiers du r�pertoire 'Donn�es Utilisateur' de POPFile"
!insertmacro PFI_LANG_STRING PFI_LANG_UN_LOG_DELUSERERR    "Note : impossible de supprimer tous les fichiers du r�pertoire 'Donn�es Utilisateur' de POPFile"

; Message Box text strings

!insertmacro PFI_LANG_STRING PFI_LANG_UN_MBCLIENT_1        "Probl�me 'Outlook Express' !"
!insertmacro PFI_LANG_STRING PFI_LANG_UN_MBCLIENT_2        "Probl�me 'Outlook' !"
!insertmacro PFI_LANG_STRING PFI_LANG_UN_MBCLIENT_3        "Probl�me 'Eudora' !"

!insertmacro PFI_LANG_STRING PFI_LANG_UN_MBEMAIL_1         "Impossible de restaurer certains param�tres d'origine"
!insertmacro PFI_LANG_STRING PFI_LANG_UN_MBEMAIL_2         "Montrer le rapport d'erreur ?"

!insertmacro PFI_LANG_STRING PFI_LANG_UN_MBRERUN_1         "Certains param�tres du client de messagerie n'ont pas �t� restaur�s !"
!insertmacro PFI_LANG_STRING PFI_LANG_UN_MBRERUN_2         "(Des d�tails sont disponibles dans le r�pertoire $INSTDIR)"
!insertmacro PFI_LANG_STRING PFI_LANG_UN_MBRERUN_3         "Cliquez 'Non' pour ignorer ces erreurs et tout supprimer"
!insertmacro PFI_LANG_STRING PFI_LANG_UN_MBRERUN_4         "Cliquez 'Oui' pour conserver ces donn�es (et permettre une nouvelle tentative ult�rieurement)"

!insertmacro PFI_LANG_STRING PFI_LANG_UN_MBREMDIR_2        "Voulez-vous supprimer tous les fichiers de votre r�pertoire 'Donn�es Utilisateur' de POPFile ?${MB_NL}${MB_NL}$G_USERDIR${MB_NL}${MB_NL}(S'il contient quoi que ce soit que vous avez cr�� et d�sirez conserver, cliquez 'Non')"

!insertmacro PFI_LANG_STRING PFI_LANG_UN_MBDELMSGS_1       "Voulez-vous supprimer tous les fichiers de votre r�pertoire 'Messages r�cents' ?"

###########################################################################
###########################################################################

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; Corpus Conversion: Standard MUI Page - INSTFILES [MonitorCC.nsi]
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

!insertmacro PFI_LANG_STRING PFI_LANG_CONVERT_TITLE        "Conversion du Corpus de POPFile"
!insertmacro PFI_LANG_STRING PFI_LANG_CONVERT_SUBTITLE     "Le corpus existant doit �tre converti pour fonctionner avec cette version de POPFile"

!insertmacro PFI_LANG_STRING PFI_LANG_ENDCONVERT_TITLE     "Conversion du corpus de POPFile termin�e"
!insertmacro PFI_LANG_STRING PFI_LANG_ENDCONVERT_SUBTITLE  "Cliquez 'Fermer' pour continuer"

!insertmacro PFI_LANG_STRING PFI_LANG_BADCONVERT_TITLE     "La conversion du corpus de POPFile a �chou�"
!insertmacro PFI_LANG_STRING PFI_LANG_BADCONVERT_SUBTITLE  "Cliquez 'Annuler' pour continuer"

!insertmacro PFI_LANG_STRING PFI_LANG_CONVERT_MUTEX        "Une autre instance de 'Corpus Conversion Monitor' est d�j� en cours d'ex�cution !"
!insertmacro PFI_LANG_STRING PFI_LANG_CONVERT_PRIVATE      "'Corpus Conversion Monitor' fait partie de l'installateur de POPFile"
!insertmacro PFI_LANG_STRING PFI_LANG_CONVERT_NOFILE       "Erreur : le fichier de donn�es de la conversion de Corpus n'existe pas !"
!insertmacro PFI_LANG_STRING PFI_LANG_CONVERT_NOPOPFILE    "Erreur : chemin d'acc�s � POPFile manquant"
!insertmacro PFI_LANG_STRING PFI_LANG_CONVERT_STARTERR     "Une erreur est survenue lors du lancement du processus de conversion de corpus"
!insertmacro PFI_LANG_STRING PFI_LANG_CONVERT_FATALERR     "Une erreur fatale est survenue lors du processus de conversion de corpus !"
!insertmacro PFI_LANG_STRING PFI_LANG_CONVERT_ESTIMATE     "Temps restant estim� : "
!insertmacro PFI_LANG_STRING PFI_LANG_CONVERT_MINUTES      "minutes"
!insertmacro PFI_LANG_STRING PFI_LANG_CONVERT_WAITING      "(attente du premier fichier � convertir)"
!insertmacro PFI_LANG_STRING PFI_LANG_CONVERT_TOTALFILES   "Il y a $G_BUCKET_COUNT fichiers de cat�gories � convertir"
!insertmacro PFI_LANG_STRING PFI_LANG_CONVERT_PROGRESS_N   "Apr�s $G_ELAPSED_TIME.$G_DECPLACES minutes, il reste $G_STILL_TO_DO fichiers � convertir"
!insertmacro PFI_LANG_STRING PFI_LANG_CONVERT_PROGRESS_1   "Apr�s $G_ELAPSED_TIME.$G_DECPLACES minutes il reste un fichier � convertir"
!insertmacro PFI_LANG_STRING PFI_LANG_CONVERT_SUMMARY      "La conversion de Corpus a pris $G_ELAPSED_TIME.$G_DECPLACES minutes"

###########################################################################
###########################################################################

#--------------------------------------------------------------------------
# Mark the end of the language data
#--------------------------------------------------------------------------

!undef PFI_LANG

#--------------------------------------------------------------------------
# End of 'French-pfi.nsh'
#--------------------------------------------------------------------------
