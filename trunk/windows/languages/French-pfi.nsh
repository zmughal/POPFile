#--------------------------------------------------------------------------
# French-pfi.nsh
#
# This file contains the "French" text strings used by the Windows installer
# for POPFile (includes customised versions of strings provided by NSIS and
# strings which are unique to POPFile).
#
# These strings are grouped according to the page/window where they are used
#
# Copyright (c) 2003-2005 John Graham-Cumming
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

!insertmacro PFI_LANG_STRING PFI_LANG_WELCOME_INFO_TEXT    "Vous �tes sur le point d'installer POPFile sur votre ordinateur.${IO_NL}${IO_NL}Avant de d�buter l'installation, il est recommand� de fermer toutes les autres applications.${IO_NL}${IO_NL}$_CLICK"
!insertmacro PFI_LANG_STRING PFI_LANG_WELCOME_ADMIN_TEXT   "NOTE IMPORTANTE :${IO_NL}${IO_NL}L'utilisateur actuel n'a PAS les droits 'Administrateur'.${IO_NL}${IO_NL}Si la gestion multi-utilisateurs est n�cessaire, il est pr�f�rable d'abandonner cette installation et d'utiliser un compte 'Administrateur' pour installer POPFile."

#--------------------------------------------------------------------------
# Standard MUI Page - Directory Page (for the main POPFile installer)
#--------------------------------------------------------------------------

!insertmacro PFI_LANG_STRING PFI_LANG_ROOTDIR_TITLE        "S�lectionnez l'emplacement d'installation de POPFile"
!insertmacro PFI_LANG_STRING PFI_LANG_ROOTDIR_TEXT_DESTN   "Dossier de destination du programme POPFile"

#--------------------------------------------------------------------------
# Standard MUI Page - Installation Page (for the main POPFile installer)
#--------------------------------------------------------------------------

!insertmacro PFI_LANG_STRING PFI_LANG_INSTFINISH_TITLE     "Les fichiers du programme sont install�s"
!insertmacro PFI_LANG_STRING PFI_LANG_INSTFINISH_SUBTITLE  "${C_PFI_PRODUCT} doit �tre configur� avant de pouvoir �tre utilis�"

#--------------------------------------------------------------------------
# Standard MUI Page - Finish (for the main POPFile installer)
#
# The PFI_LANG_FINISH_RUN_TEXT text should be a short phrase (not a long paragraph)
#--------------------------------------------------------------------------

!insertmacro PFI_LANG_STRING PFI_LANG_FINISH_RUN_TEXT      "Interface Utilisateur de POPFile"
!insertmacro PFI_LANG_STRING PFI_LANG_FINISH_WEB_LINK_TEXT "Click here to visit the POPFile web site"


;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; Used by 'Monitor Corpus Conversion' utility (main script: MonitorCC.nsi)
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

#--------------------------------------------------------------------------
# Standard MUI Page - Installation Page (for the 'Monitor Corpus Conversion' utility)
#--------------------------------------------------------------------------

!insertmacro PFI_LANG_STRING PFI_LANG_CONVERT_TITLE        "Conversion du Corpus de POPFile"
!insertmacro PFI_LANG_STRING PFI_LANG_CONVERT_SUBTITLE     "Le corpus existant doit �tre converti pour fonctionner avec cette version de POPFile"

!insertmacro PFI_LANG_STRING PFI_LANG_ENDCONVERT_TITLE     "Conversion du corpus de POPFile termin�e"
!insertmacro PFI_LANG_STRING PFI_LANG_ENDCONVERT_SUBTITLE  "Cliquez 'Fermer' pour continuer"

!insertmacro PFI_LANG_STRING PFI_LANG_BADCONVERT_TITLE     "La conversion du corpus de POPFile a �chou�"
!insertmacro PFI_LANG_STRING PFI_LANG_BADCONVERT_SUBTITLE  "Cliquez 'Annuler' pour continuer"


;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; Used by 'Add POPFile User' wizard (main script: adduser.nsi)
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

#--------------------------------------------------------------------------
# Standard MUI Page - Welcome (for the 'Add POPFile User' wizard)
#
# The sequence ${IO_NL}${IO_NL} inserts a blank line (note that the PFI_LANG_ADDUSER_INFO_TEXT string
# should end with a ${IO_NL}${IO_NL}$_CLICK sequence).
#--------------------------------------------------------------------------

!insertmacro PFI_LANG_STRING PFI_LANG_ADDUSER_INFO_TEXT    "Cet assistant va vous guider lors de la configuration de POPFile pour l'utilisateur '$G_WINUSERNAME'.${IO_NL}${IO_NL}Il est recommand� de fermer toutes les autres applications avant de continuer.${IO_NL}${IO_NL}$_CLICK"

#--------------------------------------------------------------------------
# Standard MUI Page - Directory Page (for the 'Add POPFile User' wizard)
#--------------------------------------------------------------------------

!insertmacro PFI_LANG_STRING PFI_LANG_USERDIR_TITLE        "S�lectionnez l'emplacement des donn�es de POPFile"
!insertmacro PFI_LANG_STRING PFI_LANG_USERDIR_SUBTITLE     "Choisissez le dossier dans lequel ranger les donn�es de POPFile pour '$G_WINUSERNAME'"
!insertmacro PFI_LANG_STRING PFI_LANG_USERDIR_TEXT_TOP     "Cette version de POPFile utilise des jeux de fichiers de donn�es diff�rents pour chaque utilisateur.${MB_NL}${MB_NL}L'installateur utilisera les dossiers suivants pour les donn�es de POPFile appartenant � l'utilisateur  '$G_WINUSERNAME'. Pour utiliser un dossier diff�rent pour cet utilisateur, cliquez sur 'Parcourir' et s�lectionnez un autre dossier. $_CLICK"
!insertmacro PFI_LANG_STRING PFI_LANG_USERDIR_TEXT_DESTN   "Dossier � utiliser pour stocker les donn�es de POPFile de '$G_WINUSERNAME'"

#--------------------------------------------------------------------------
# Standard MUI Page - Installation Page (for the 'Add POPFile User' wizard)
#--------------------------------------------------------------------------

!insertmacro PFI_LANG_STRING PFI_LANG_ADDUSER_TITLE        "Configuration de POPFile pour l'utilisateur '$G_WINUSERNAME'"
!insertmacro PFI_LANG_STRING PFI_LANG_ADDUSER_SUBTITLE     "Veuillez patienter pendant que les fichiers de configuration de POPFile sont mis � jour pour cet utilisateur"

#--------------------------------------------------------------------------
# Standard MUI Page - Finish (for the 'Add POPFile User' wizard)
#--------------------------------------------------------------------------

!insertmacro PFI_LANG_STRING PFI_LANG_ADDUSER_FINISH_INFO "POPFile a �t� configur� pour l'utilisateur '$G_WINUSERNAME'.${IO_NL}${IO_NL}Cliquez sur 'Fermer' pour fermer cet assistant."

#--------------------------------------------------------------------------
# Standard MUI Page - Uninstall Confirmation Page (for the 'Add POPFile User' wizard)
#--------------------------------------------------------------------------

!insertmacro PFI_LANG_STRING PFI_LANG_REMUSER_TITLE        "D�sinstallation des donn�es de POPFile pour l'utilisateur '$G_WINUSERNAME'"
!insertmacro PFI_LANG_STRING PFI_LANG_REMUSER_SUBTITLE     "Supprime les donn�es de configuration de POPFile pour cet utilisateur"

!insertmacro PFI_LANG_STRING PFI_LANG_REMUSER_TEXT_TOP     "Les donn�es de configuration de POPFile pour l'utilisateur '$G_WINUSERNAME' vont �tre d�sinstall�es du dossier suivant. $_CLICK"

#--------------------------------------------------------------------------
# Standard MUI Page - Uninstallation Page (for the 'Add POPFile User' wizard)
#--------------------------------------------------------------------------

!insertmacro PFI_LANG_STRING PFI_LANG_REMOVING_TITLE       "D�sinstallation des donn�es de POPFile pour l'utilisateur '$G_WINUSERNAME'"
!insertmacro PFI_LANG_STRING PFI_LANG_REMOVING_SUBTITLE    "Veuillez patienter pendant la suppression des donn�es de POPFile pour cet utilisateur"


#==========================================================================
# Strings used for custom pages, message boxes and banners
#==========================================================================

#--------------------------------------------------------------------------
# General purpose banner text (also suitable for page titles/subtitles)
#--------------------------------------------------------------------------

!insertmacro PFI_LANG_STRING PFI_LANG_BE_PATIENT           "Veuillez patienter."
!insertmacro PFI_LANG_STRING PFI_LANG_TAKE_A_FEW_SECONDS   "Ceci peut prendre quelques secondes..."

#--------------------------------------------------------------------------
# Message displayed when 'Add User' does not seem to be part of the current version
#--------------------------------------------------------------------------

!insertmacro PFI_LANG_STRING PFI_LANG_COMPAT_NOTFOUND      "Erreur: aucune version compatible de ${C_PFI_PRODUCT} n'a �t� trouv�e !"

#--------------------------------------------------------------------------
# Message displayed when installer exits because another copy is running
#--------------------------------------------------------------------------

!insertmacro PFI_LANG_STRING PFI_LANG_INSTALLER_MUTEX      "Une autre instance de l'installateur de POPFile est d�j� en cours d'ex�cution !"

#--------------------------------------------------------------------------
# Message box warnings used when verifying the installation folder chosen by user
#--------------------------------------------------------------------------

!insertmacro PFI_LANG_STRING PFI_LANG_DIRSELECT_MBWARN_1   "Installation pr�c�dente trouv�e �"
!insertmacro PFI_LANG_STRING PFI_LANG_DIRSELECT_MBWARN_2   "Voulez-vous la mettre � jour ?"
!insertmacro PFI_LANG_STRING PFI_LANG_DIRSELECT_MBWARN_3   "Donn�es de configuration pr�c�dentes trouv�es �"
!insertmacro PFI_LANG_STRING PFI_LANG_DIRSELECT_MBWARN_4   "Donn�es de configuration restaur�es trouv�es"
!insertmacro PFI_LANG_STRING PFI_LANG_DIRSELECT_MBWARN_5   "Voulez-vous utiliser les donn�es restaur�es ?"

#--------------------------------------------------------------------------
# Startup message box offering to display the Release Notes
#--------------------------------------------------------------------------

!insertmacro PFI_LANG_STRING PFI_LANG_MBRELNOTES_1         "Voir les 'Release Notes' de POPFile ?"
!insertmacro PFI_LANG_STRING PFI_LANG_MBRELNOTES_2         "'Oui' recommand� si vous effectuez une mise � jour de POPFile (vous pouvez avoir besoin d'effectuer une sauvegarde AVANT de mettre � jour)"

#--------------------------------------------------------------------------
# Custom Page - Check Perl Requirements
#--------------------------------------------------------------------------

; Page Title and Sub-title displayed in the page header

!insertmacro PFI_LANG_STRING PFI_LANG_PERLREQ_TITLE        "Composants syst�me non � jour d�tect�s"

; Text strings displayed on the custom page

!insertmacro PFI_LANG_STRING PFI_LANG_PERLREQ_IO_TEXT_1    "Le navigateur par d�faut est utilis� pour visualiser l'interface utilisateur de POPFile (son centre de contr�le).${IO_NL}${IO_NL}"
!insertmacro PFI_LANG_STRING PFI_LANG_PERLREQ_IO_TEXT_2    "POPFile ne n�cessite pas un navigateur sp�cifique, il fonctionnera avec la plupart des navigateurs.${IO_NL}${IO_NL}"
!insertmacro PFI_LANG_STRING PFI_LANG_PERLREQ_IO_TEXT_3    "Une version minimale de Perl va �tre install�e (POPFile est �crit en Perl). "
!insertmacro PFI_LANG_STRING PFI_LANG_PERLREQ_IO_TEXT_4    "Le Perl fourni avec POPFile utilise certains composants d'Internet Explorer et n�cessite Internet Explorer 5.5 (ou une version plus r�cente)."
!insertmacro PFI_LANG_STRING PFI_LANG_PERLREQ_IO_TEXT_5    "L'installateur a d�tect� que ce syst�me poss�de Internet Explorer"
!insertmacro PFI_LANG_STRING PFI_LANG_PERLREQ_IO_TEXT_6    "Il est possible que certaines fonctions de POPFile ne fonctionnent pas correctement sur ce syst�me.${IO_NL}${IO_NL}"
!insertmacro PFI_LANG_STRING PFI_LANG_PERLREQ_IO_TEXT_7    "Si vous avez des probl�mes lors de l'utilisation de POPFile, une mise � jour d'Internet Explorer en une version plus r�cente peut s'av�rer utile."

#--------------------------------------------------------------------------
# Standard MUI Page - Choose Components
#--------------------------------------------------------------------------

!insertmacro PFI_LANG_STRING DESC_SecPOPFile               "Installe les fichiers de base n�cessaires � POPFile, comprenant une version minimale de Perl."
!insertmacro PFI_LANG_STRING DESC_SecSkins                 "Installe les habillages de POPFile qui vous permettent de changer l'apparence de l'interface utilisateur de POPFile."
!insertmacro PFI_LANG_STRING DESC_SecLangs                 "Installe les versions en langue non Anglaise de l'interface de POPFile."

!insertmacro PFI_LANG_STRING DESC_SubSecOptional           "Composants suppl�mentaires de POPFile (utilisateurs exp�riment�s)"
!insertmacro PFI_LANG_STRING DESC_SecIMAP                  "Installe le module IMAP de POPFile"
!insertmacro PFI_LANG_STRING DESC_SecNNTP                  "Installe le proxy NNTP de POPFile"
!insertmacro PFI_LANG_STRING DESC_SecSMTP                  "Installe le proxy SMTP de POPFile"
!insertmacro PFI_LANG_STRING DESC_SecSOCKS                 "Installe les composants suppl�mentaires du Perl permettant aux proxies de POPFile d'utiliser SOCKS"
!insertmacro PFI_LANG_STRING DESC_SecXMLRPC                "Installe le module XMLRPC de POPFile (pour acc�der � l'API de POPFile) et le support Perl n�cessaire."

; Text strings used when user has NOT selected a component found in the existing installation

!insertmacro PFI_LANG_STRING MBCOMPONENT_PROB_1            "Voulez-vous mettre � jour le composant $G_PLS_FIELD_1 existant ?"
!insertmacro PFI_LANG_STRING MBCOMPONENT_PROB_2            "(l'utilisation de composants de POPFile non � jour peut entra�ner des probl�mes)"

#--------------------------------------------------------------------------
# Custom Page - POPFile Installation Options
#--------------------------------------------------------------------------

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

!insertmacro PFI_LANG_STRING PFI_LANG_OPTIONS_MBPOP3_1     "Le port POP3 ne peut pas �tre fix� �"
!insertmacro PFI_LANG_STRING PFI_LANG_OPTIONS_MBPOP3_2     "Le port doit �tre un nombre compris entre 1 et 65535."
!insertmacro PFI_LANG_STRING PFI_LANG_OPTIONS_MBPOP3_3     "Veuillez modifier le port POP3."

!insertmacro PFI_LANG_STRING PFI_LANG_OPTIONS_MBGUI_1      "Le port de l'Interface Utilisateur ne peut pas �tre fix� �"
!insertmacro PFI_LANG_STRING PFI_LANG_OPTIONS_MBGUI_2      "Le port doit �tre un nombre compris entre 1 et 65535."
!insertmacro PFI_LANG_STRING PFI_LANG_OPTIONS_MBGUI_3      "Veuillez modifier le port de l'Interface Utilisateur"

!insertmacro PFI_LANG_STRING PFI_LANG_OPTIONS_MBDIFF_1     "Le port POP3 doit �tre diff�rent du port de l'Interface Utilisateur."
!insertmacro PFI_LANG_STRING PFI_LANG_OPTIONS_MBDIFF_2     "Veuillez modifier votre s�lection des ports."

#--------------------------------------------------------------------------
# Standard MUI Page - Installing POPFile
#--------------------------------------------------------------------------

; When upgrading an existing installation, change the normal "Install" button to "Upgrade"
; (the page with the "Install" button will vary depending upon the page order in the script)

!insertmacro PFI_LANG_STRING PFI_LANG_INST_BTN_UPGRADE     "Mettre � jour"

; When resetting POPFile to use newly restored 'User Data', change "Install" button to "Restore"

!insertmacro PFI_LANG_STRING PFI_LANG_INST_BTN_RESTORE     "Restaurer"

; Installation Progress Reports displayed above the progress bar

!insertmacro PFI_LANG_STRING PFI_LANG_INST_PROG_UPGRADE    "Je v�rifie s'il s'agit de l'installation d'une mise � jour..."
!insertmacro PFI_LANG_STRING PFI_LANG_INST_PROG_CORE       "Installation des fichiers de base de POPFile..."
!insertmacro PFI_LANG_STRING PFI_LANG_INST_PROG_PERL       "Installation des fichiers minimaux du Perl..."
!insertmacro PFI_LANG_STRING PFI_LANG_INST_PROG_SHORT      "Creation des raccourcis de POPFile..."
!insertmacro PFI_LANG_STRING PFI_LANG_INST_PROG_CORPUS     "Sauvegarde du corpus. Ceci peut prendre quelques secondes..."
!insertmacro PFI_LANG_STRING PFI_LANG_INST_PROG_SKINS      "Installation des fichiers d'habillage de POPFile..."
!insertmacro PFI_LANG_STRING PFI_LANG_INST_PROG_LANGS      "Installation des fichiers de langue de l'interface de POPFile..."
!insertmacro PFI_LANG_STRING PFI_LANG_INST_PROG_XMLRPC     "Installation des fichiers XMLRPC de POPFile..."
!insertmacro PFI_LANG_STRING PFI_LANG_INST_PROG_REGSET     "Mise � jour du registre et des variables d'environnement..."
!insertmacro PFI_LANG_STRING PFI_LANG_INST_PROG_SQLBACKUP  "Sauvegarde de l'ancienne base de donn�es SQLite..."
!insertmacro PFI_LANG_STRING PFI_LANG_INST_PROG_FINDCORPUS "Recherche des fichiers de corpus en mode texte ou BerkeleyDB..."
!insertmacro PFI_LANG_STRING PFI_LANG_INST_PROG_MAKEBAT    "G�n�ration du fichier de commande 'pfi-run.bat'..."
!insertmacro PFI_LANG_STRING PFI_LANG_INST_PROG_ENDSEC     "Cliquez sur 'Suivant' pour continuer"

; Installation Log Messages

!insertmacro PFI_LANG_STRING PFI_LANG_INST_LOG_SHUTDOWN    "Fermeture de la version pr�c�dente de POPFile en utilisant le port"

; Message Box text strings

!insertmacro PFI_LANG_STRING PFI_LANG_MBSTPWDS_1           "fichiers d'une installation pr�c�dente trouv�s."
!insertmacro PFI_LANG_STRING PFI_LANG_MBSTPWDS_2           "D'accord pour mettre � jour ce fichier ?"
!insertmacro PFI_LANG_STRING PFI_LANG_MBSTPWDS_3           "Cliquez 'Oui' pour le mettre � jour (l'ancien fichier sera sauvegard� sous le nom"
!insertmacro PFI_LANG_STRING PFI_LANG_MBSTPWDS_4           "Cliquez 'Non' pour conserver l'ancien fichier (le nouveau fichier sera sauvegard� sous le nom"

!insertmacro PFI_LANG_STRING PFI_LANG_MBMANSHUT_1          "Impossible de fermer '$G_PLS_FIELD_1' automatiquement."
!insertmacro PFI_LANG_STRING PFI_LANG_MBMANSHUT_2          "Veuillez fermer '$G_PLS_FIELD_1' manuellement maintenant."
!insertmacro PFI_LANG_STRING PFI_LANG_MBMANSHUT_3          "Quand '$G_PLS_FIELD_1' sera ferm�, cliquez sur 'OK' pour continuer."

!insertmacro PFI_LANG_STRING PFI_LANG_MBCORPUS_1           "Erreur d�tect�e lors de la tentative de sauvegarde de l'ancien corpus."

#--------------------------------------------------------------------------
# Custom Page - POPFile Classification Bucket Creation
#--------------------------------------------------------------------------

; POPFile requires at least TWO buckets in order to work properly. PFI_LANG_CBP_DEFAULT_BUCKETS
; defines the default buckets and PFI_LANG_CBP_SUGGESTED_NAMES defines a list of suggested names
; to help the user get started with POPFile. Both lists use the | character as a name separator.

; Bucket names can only use the characters abcdefghijklmnopqrstuvwxyz_-0123456789
; (any names which contain invalid characters will be ignored by the installer)

; Empty lists ("") are allowed (but are not very user-friendly)

!insertmacro PFI_LANG_STRING PFI_LANG_CBP_DEFAULT_BUCKETS  "spam|personnel|professionnel|autre"
!insertmacro PFI_LANG_STRING PFI_LANG_CBP_SUGGESTED_NAMES  "admin|affaires|autre|boite_de_reception|divers|etudes|famille|finances|general|informatique|list-admin|loisirs|non_spam|personnel|pourriel|professionnel|recreation|securite|shopping|spam|voyages"

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

!insertmacro PFI_LANG_STRING PFI_LANG_CBP_IO_MSG_1         "Il est inutile d'ajouter d'autres cat�gories"
!insertmacro PFI_LANG_STRING PFI_LANG_CBP_IO_MSG_2         "Vous devez d�finir AU MOINS DEUX cat�gories"
!insertmacro PFI_LANG_STRING PFI_LANG_CBP_IO_MSG_3         "Au moins une cat�gorie de plus est n�cessaire"
!insertmacro PFI_LANG_STRING PFI_LANG_CBP_IO_MSG_4         "L'installateur ne peut pas cr�er plus de"
!insertmacro PFI_LANG_STRING PFI_LANG_CBP_IO_MSG_5         "cat�gories"

; Message box text strings

!insertmacro PFI_LANG_STRING PFI_LANG_CBP_MBDUPERR_1       "Une cat�gorie nomm�e"
!insertmacro PFI_LANG_STRING PFI_LANG_CBP_MBDUPERR_2       "a d�j� �t� d�finie."
!insertmacro PFI_LANG_STRING PFI_LANG_CBP_MBDUPERR_3       "Veuillez choisir un autre nom pour la nouvelle cat�gorie."

!insertmacro PFI_LANG_STRING PFI_LANG_CBP_MBMAXERR_1       "L'installateur ne peut cr�er que jusqu'�"
!insertmacro PFI_LANG_STRING PFI_LANG_CBP_MBMAXERR_2       "cat�gories."
!insertmacro PFI_LANG_STRING PFI_LANG_CBP_MBMAXERR_3       "Une fois que POPFile a �t� install� vous pouvez cr�er plus de"

!insertmacro PFI_LANG_STRING PFI_LANG_CBP_MBNAMERR_1       "Le nom"
!insertmacro PFI_LANG_STRING PFI_LANG_CBP_MBNAMERR_2       "n'est pas un nom valide pour une cat�gorie."
!insertmacro PFI_LANG_STRING PFI_LANG_CBP_MBNAMERR_3       "Les noms de cat�gories ne peuvent contenir que les minuscules de a � z ainsi que - and _"
!insertmacro PFI_LANG_STRING PFI_LANG_CBP_MBNAMERR_4       "Veuillez choisir un autre nom pour la nouvelle cat�gorie."

!insertmacro PFI_LANG_STRING PFI_LANG_CBP_MBCONTERR_1      "POPFile a besoin d'AU MOINS DEUX cat�gories pour pouvoir classifier vos messages."
!insertmacro PFI_LANG_STRING PFI_LANG_CBP_MBCONTERR_2      "Veuillez entrer le nom de la cat�gorie � cr�er${MB_NL}${MB_NL}soit en le choisissant dans la liste${MB_NL}${MB_NL}soit en tapant le nom de votre choix."
!insertmacro PFI_LANG_STRING PFI_LANG_CBP_MBCONTERR_3      "Vous devez d�finir AU MOINS DEUX cat�gories avant de poursuivre l'installation de POPFile."

!insertmacro PFI_LANG_STRING PFI_LANG_CBP_MBDONE_1         "cat�gories ont �t� d�finies pour �tre utilis�es par POPFile."
!insertmacro PFI_LANG_STRING PFI_LANG_CBP_MBDONE_2         "Voulez-vous configurer POPFile pour utiliser ces cat�gories ?"
!insertmacro PFI_LANG_STRING PFI_LANG_CBP_MBDONE_3         "Cliquez sur 'Non' si vous d�sirer modifier votre choix des cat�gories."

!insertmacro PFI_LANG_STRING PFI_LANG_CBP_MBMAKERR_1       "L'installateur n'a pas pu cr�er"
!insertmacro PFI_LANG_STRING PFI_LANG_CBP_MBMAKERR_2       "des"
!insertmacro PFI_LANG_STRING PFI_LANG_CBP_MBMAKERR_3       "cat�gories que vous avez choisies."
!insertmacro PFI_LANG_STRING PFI_LANG_CBP_MBMAKERR_4       "Une fois POPFile install�, vous pouvez utiliser le panneau de contr�le${MB_NL}${MB_NL}de l'interface utilisateur pour cr�er les cat�gories manquantes."

#--------------------------------------------------------------------------
# Custom Page - Email Client Reconfiguration
#--------------------------------------------------------------------------

; Page Title and Sub-title displayed in the page header

!insertmacro PFI_LANG_STRING PFI_LANG_MAILCFG_TITLE        "Configuration du client de messagerie"
!insertmacro PFI_LANG_STRING PFI_LANG_MAILCFG_SUBTITLE     "POPFile peut reconfigurer divers clients de messagerie automatiquement"

; Text displayed on the custom page

!insertmacro PFI_LANG_STRING PFI_LANG_MAILCFG_IO_TEXT_1    "Les clients de messagerie marqu�s par (*) peuvent �tre reconfigur�s automatiquement, � condition que des comptes simples soient utilis�s.${IO_NL}${IO_NL}Il est fortement recommand� de configurer manuellement les comptes n�cessitant une authentification."
!insertmacro PFI_LANG_STRING PFI_LANG_MAILCFG_IO_TEXT_2    "IMPORTANT: VEUILLEZ FERMER LES CLIENTS DE MESSAGERIES MAINTENANT${IO_NL}${IO_NL}Cette fonctionnalit� est encore en cours de d�veloppement (p. ex. certains comptes Outlook peuvent ne pas �tre d�tect�s).${IO_NL}${IO_NL}Veuillez v�rifier que la reconfiguration a bien �t� effectu�e avant d'utiliser votre client de messagerie)."

!insertmacro PFI_LANG_STRING PFI_LANG_MAILCFG_IO_CANCEL    "Reconfiguration du client de messagerie abandonn�e par l'utilisateur"

#--------------------------------------------------------------------------
# Text used on buttons to skip configuration of email clients
#--------------------------------------------------------------------------

!insertmacro PFI_LANG_STRING PFI_LANG_MAILCFG_IO_SKIPALL   "Ignorer tous"
!insertmacro PFI_LANG_STRING PFI_LANG_MAILCFG_IO_SKIPONE   "Ignorer le client"

#--------------------------------------------------------------------------
# Message box warnings that an email client is still running
#--------------------------------------------------------------------------

!insertmacro PFI_LANG_STRING PFI_LANG_MBCLIENT_EXP         "ATTENTION: Outlook Express est en cours d'utilisation !"
!insertmacro PFI_LANG_STRING PFI_LANG_MBCLIENT_OUT         "ATTENTION: Outlook est en cours d'utilisation !"
!insertmacro PFI_LANG_STRING PFI_LANG_MBCLIENT_EUD         "ATTENTION: Eudora est en cours d'utilisation !"

!insertmacro PFI_LANG_STRING PFI_LANG_MBCLIENT_STOP_1      "Veuillez FERMER le programme de messagerie et cliquer sur 'R�essayer' pour le reconfiguer"
!insertmacro PFI_LANG_STRING PFI_LANG_MBCLIENT_STOP_2      "(Vous pouvez cliquer sur 'Ignorer' pour le reconfigurer, mais ceci n'est pas recommand�)"
!insertmacro PFI_LANG_STRING PFI_LANG_MBCLIENT_STOP_3      "Cliquez sur 'Abandonner' pour ne pas effectuer la reconfiguration de ce programme de messagerie"

!insertmacro PFI_LANG_STRING PFI_LANG_MBCLIENT_STOP_4      "Veuillez FERMER le programme de messagerie et cliquer sur 'R�essayer' pour restaurer les param�tres"
!insertmacro PFI_LANG_STRING PFI_LANG_MBCLIENT_STOP_5      "(Vous pouvez cliquer sur 'Ignorer' pour restaurer les param�tres, mais ceci n'est pas recommand�)"
!insertmacro PFI_LANG_STRING PFI_LANG_MBCLIENT_STOP_6      "Cliquez sur 'Abandonner' pour ne pas effectuer la restauration des param�tres d'origine"

#--------------------------------------------------------------------------
# Custom Page - Reconfigure Outlook/Outlook Express
#--------------------------------------------------------------------------

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

#--------------------------------------------------------------------------
# Custom Page - Reconfigure Eudora
#--------------------------------------------------------------------------

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

#--------------------------------------------------------------------------
# Custom Page - POPFile can now be started
#--------------------------------------------------------------------------

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

#--------------------------------------------------------------------------
# Standard MUI Page - Installation Page (for the 'Corpus Conversion Monitor' utility)
#--------------------------------------------------------------------------

!insertmacro PFI_LANG_STRING PFI_LANG_CONVERT_MUTEX        "Une autre instance de 'Corpus Conversion Monitor' est d�j� en cours d'ex�cution !"
!insertmacro PFI_LANG_STRING PFI_LANG_CONVERT_PRIVATE      "'Corpus Conversion Monitor' fait partie de l'installateur de POPFile"
!insertmacro PFI_LANG_STRING PFI_LANG_CONVERT_NOFILE       "Erreur : le fichier de donn�es de la conversion de Corpus n'existe pas !"
!insertmacro PFI_LANG_STRING PFI_LANG_CONVERT_NOPOPFILE    "Erreur : chemin d'acc�s � POPFile manquant"
!insertmacro PFI_LANG_STRING PFI_LANG_CONVERT_ENVNOTSET    "Erreur : Impossible de fixer une variable d'environnement"
!insertmacro PFI_LANG_STRING PFI_LANG_CONVERT_NOKAKASI     "Erreur : Chemin d'acc�s � Kakasi manquant"
!insertmacro PFI_LANG_STRING PFI_LANG_CONVERT_STARTERR     "Une erreur est survenue lors du lancement du processus de conversion de corpus"
!insertmacro PFI_LANG_STRING PFI_LANG_CONVERT_FATALERR     "Une erreur fatale est survenue lors du processus de conversion de corpus !"
!insertmacro PFI_LANG_STRING PFI_LANG_CONVERT_ESTIMATE     "Temps restant estim� : "
!insertmacro PFI_LANG_STRING PFI_LANG_CONVERT_MINUTES      "minutes"
!insertmacro PFI_LANG_STRING PFI_LANG_CONVERT_WAITING      "(attente du premier fichier � convertir)"
!insertmacro PFI_LANG_STRING PFI_LANG_CONVERT_TOTALFILES   "Il y a $G_BUCKET_COUNT fichiers de cat�gories � convertir"
!insertmacro PFI_LANG_STRING PFI_LANG_CONVERT_PROGRESS_N   "Apr�s $G_ELAPSED_TIME.$G_DECPLACES minutes, il reste $G_STILL_TO_DO fichiers � convertir"
!insertmacro PFI_LANG_STRING PFI_LANG_CONVERT_PROGRESS_1   "Apr�s $G_ELAPSED_TIME.$G_DECPLACES minutes il reste un fichier � convertir"
!insertmacro PFI_LANG_STRING PFI_LANG_CONVERT_SUMMARY      "La conversion de Corpus a pris $G_ELAPSED_TIME.$G_DECPLACES minutes"

#--------------------------------------------------------------------------
# Standard MUI Page - Uninstall POPFile
#--------------------------------------------------------------------------

; Uninstall Progress Reports displayed above the progress bar

!insertmacro PFI_LANG_STRING PFI_LANG_UN_PROG_SHUTDOWN     "Fermeture de POPFile..."
!insertmacro PFI_LANG_STRING PFI_LANG_UN_PROG_SHORT        "Suppression des entr�es de POPFile dans le menu D�marrer..."
!insertmacro PFI_LANG_STRING PFI_LANG_UN_PROG_CORE         "Suppression des fichiers de base de POPFile..."
!insertmacro PFI_LANG_STRING PFI_LANG_UN_PROG_OUTEXPRESS   "Restauration des param�tres d'Outlook Express..."
!insertmacro PFI_LANG_STRING PFI_LANG_UN_PROG_SKINS        "Suppression des fichiers d'habillage de POPFile..."
!insertmacro PFI_LANG_STRING PFI_LANG_UN_PROG_PERL         "Suppression des fichiers minimaux du Perl..."
!insertmacro PFI_LANG_STRING PFI_LANG_UN_PROG_OUTLOOK      "Restauration des param�tres d'Outlook..."
!insertmacro PFI_LANG_STRING PFI_LANG_UN_PROG_EUDORA       "Restauration des param�tres d'Eudora..."
!insertmacro PFI_LANG_STRING PFI_LANG_UN_PROG_DBMSGDIR     "Suppression du corpus et du r�pertoire 'Messages r�cents'..."
!insertmacro PFI_LANG_STRING PFI_LANG_UN_PROG_EXESTATUS    "V�rification de l'�tat du programme..."
!insertmacro PFI_LANG_STRING PFI_LANG_UN_PROG_CONFIG       "Suppression des donn�es de configuration..."
!insertmacro PFI_LANG_STRING PFI_LANG_UN_PROG_REGISTRY     "Suppression des entr�es du registre de POPFile..."

; Uninstall Log Messages

!insertmacro PFI_LANG_STRING PFI_LANG_UN_LOG_SHUTDOWN      "Fermeture de POPFile en utilisant le port"
!insertmacro PFI_LANG_STRING PFI_LANG_UN_LOG_OPENED        "Ouvert"
!insertmacro PFI_LANG_STRING PFI_LANG_UN_LOG_RESTORED      "Restaur�"
!insertmacro PFI_LANG_STRING PFI_LANG_UN_LOG_CLOSED        "Ferm�"
!insertmacro PFI_LANG_STRING PFI_LANG_UN_LOG_DELROOTDIR    "Suppression de tous les fichiers du r�pertoire de POPFile"
!insertmacro PFI_LANG_STRING PFI_LANG_UN_LOG_DELROOTERR    "Note : impossible de supprimer tous les fichiers du r�pertoire de POPFile"
!insertmacro PFI_LANG_STRING PFI_LANG_UN_LOG_DATAPROBS     "Probl�mes de donn�es"
!insertmacro PFI_LANG_STRING PFI_LANG_UN_LOG_DELUSERDIR    "Suppression de tous les fichiers du r�pertoire 'Donn�es Utilisateur' de POPFile"
!insertmacro PFI_LANG_STRING PFI_LANG_UN_LOG_DELUSERERR    "Note : impossible de supprimer tous les fichiers du r�pertoire 'Donn�es Utilisateur' de POPFile"

; Message Box text strings

!insertmacro PFI_LANG_STRING PFI_LANG_UN_MBDIFFUSER_1      "'$G_WINUSERNAME' tente de supprimer des donn�es appartenant � un autre utilisateur"

!insertmacro PFI_LANG_STRING PFI_LANG_UN_MBNOTFOUND_1      "POPFile ne semble pas install� dans le r�pertoire"
!insertmacro PFI_LANG_STRING PFI_LANG_UN_MBNOTFOUND_2      "Continuer quand m�me (non recommand�) ?"

!insertmacro PFI_LANG_STRING PFI_LANG_UN_ABORT_1           "D�sinstallation abandonn�e par l'utilisateur"

!insertmacro PFI_LANG_STRING PFI_LANG_UN_MBCLIENT_1        "Probl�me 'Outlook Express' !"
!insertmacro PFI_LANG_STRING PFI_LANG_UN_MBCLIENT_2        "Probl�me 'Outlook' !"
!insertmacro PFI_LANG_STRING PFI_LANG_UN_MBCLIENT_3        "Probl�me 'Eudora' !"

!insertmacro PFI_LANG_STRING PFI_LANG_UN_MBEMAIL_1         "Impossible de restaurer certains param�tres d'origine"
!insertmacro PFI_LANG_STRING PFI_LANG_UN_MBEMAIL_2         "Montrer le rapport d'erreur ?"

!insertmacro PFI_LANG_STRING PFI_LANG_UN_MBRERUN_1         "Certains param�tres du client de messagerie n'ont pas �t� restaur�s !"
!insertmacro PFI_LANG_STRING PFI_LANG_UN_MBRERUN_2         "(Des d�tails sont disponibles dans le r�pertoire $INSTDIR)"
!insertmacro PFI_LANG_STRING PFI_LANG_UN_MBRERUN_3         "Cliquez 'Non' pour ignorer ces erreurs et tout supprimer"
!insertmacro PFI_LANG_STRING PFI_LANG_UN_MBRERUN_4         "Cliquez 'Oui' pour conserver ces donn�es (et permettre une nouvelle tentative ult�rieurement)"

!insertmacro PFI_LANG_STRING PFI_LANG_UN_MBREMDIR_1        "Voulez-vous supprimer tous les fichiers de votre r�pertoire de POPFile ?${MB_NL}${MB_NL}$G_ROOTDIR${MB_NL}${MB_NL}(S'il contient quoi que ce soit que vous avez cr�� et d�sirez conserver, cliquez 'Non')"
!insertmacro PFI_LANG_STRING PFI_LANG_UN_MBREMDIR_2        "Voulez-vous supprimer tous les fichiers de votre r�pertoire 'Donn�es Utilisateur' de POPFile ?${MB_NL}${MB_NL}$G_USERDIR${MB_NL}${MB_NL}(S'il contient quoi que ce soit que vous avez cr�� et d�sirez conserver, cliquez 'Non')"

!insertmacro PFI_LANG_STRING PFI_LANG_UN_MBDELMSGS_1       "Voulez-vous supprimer tous les fichiers de votre r�pertoire 'Messages r�cents' ?"

!insertmacro PFI_LANG_STRING PFI_LANG_UN_MBREMERR_1        "Note"
!insertmacro PFI_LANG_STRING PFI_LANG_UN_MBREMERR_2        "n'a pas pu �tre supprim�."

#--------------------------------------------------------------------------
# Mark the end of the language data
#--------------------------------------------------------------------------

!undef PFI_LANG

#--------------------------------------------------------------------------
# End of 'French-pfi.nsh'
#--------------------------------------------------------------------------
