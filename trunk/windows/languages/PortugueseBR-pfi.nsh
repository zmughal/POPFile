#--------------------------------------------------------------------------
# PortugueseBR-pfi.nsh
#
# This file contains the "PortugueseBR" text strings used by the Windows installer
# and other NSIS-based Windows utilities for POPFile (includes customised versions
# of strings provided by NSIS and strings which are unique to POPFile).
#
# These strings are grouped according to the page/window and script where they are used
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
# Translation created by: Adriano Rafael Gomes <adrianorg@users.sourceforge.net>
# Translation updated by: Adriano Rafael Gomes <adrianorg@users.sourceforge.net>
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

!define PFI_LANG  "PORTUGUESEBR"

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

!insertmacro PFI_LANG_STRING PFI_LANG_BE_PATIENT           "Espere por favor."
!insertmacro PFI_LANG_STRING PFI_LANG_TAKE_A_FEW_SECONDS   "Isto pode levar alguns segundos..."

###########################################################################
###########################################################################

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; Shared: Message displayed when wizard does not seem to belong to the current installation [adduser.nsi, runpopfile.nsi]
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

!insertmacro PFI_LANG_STRING PFI_LANG_COMPAT_NOTFOUND      "Erro: N�o foi encontrada uma vers�o compat�vel de ${C_PFI_PRODUCT}!"

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; Shared: Message box shown (before the WELCOME page) if another installer is running [installer.nsi, adduser.nsi]
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

!insertmacro PFI_LANG_STRING PFI_LANG_INSTALLER_MUTEX      "Uma outra c�pia do instalador do POPFile j� est� rodando!"

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; Shared: Message box shown if 'SetEnvironmentVariableA' fails [installer.nsi, adduser.nsi, MonitorCC.nsi]
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

!insertmacro PFI_LANG_STRING PFI_LANG_CONVERT_ENVNOTSET    "Erro: Imposs�vel setar uma vari�vel de ambiente"

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; Shared: Used in message box shown if existing files found when installing [installer.nsi, adduser.nsi]
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

!insertmacro PFI_LANG_STRING PFI_LANG_DIRSELECT_MBWARN_2   "Voc� quer atualiz�-la?"

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; Shared: Standard MUI Page - INSTFILES
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

; When upgrading an existing installation, change the normal "Install" button to "Upgrade" [installer.nsi, adduser.nsi]

!insertmacro PFI_LANG_STRING PFI_LANG_INST_BTN_UPGRADE     "Atualizar"

; Installation Progress Reports displayed above the progress bar [installer.nsi, adduser.nsi]

!insertmacro PFI_LANG_STRING PFI_LANG_INST_PROG_UPGRADE    "Verificando se esta � uma instala��o para atualiza��o..."
!insertmacro PFI_LANG_STRING PFI_LANG_INST_PROG_SHORT      "Criando os atalhos do POPFile..."
!insertmacro PFI_LANG_STRING PFI_LANG_INST_PROG_LANGS      "Instalando os arquivos de l�nguas do POPFile..."

; Installation Progress Reports displayed above the progress bar [installer.nsi, adduser.nsh, getssl.nsh]

!insertmacro PFI_LANG_STRING PFI_LANG_INST_PROG_ENDSEC     "Clique em Avan�ar para continuar"

; Installation Log Messages [installer.nsi, adduser.nsi]

!insertmacro PFI_LANG_STRING PFI_LANG_INST_LOG_SHUTDOWN    "Desligando a vers�o anterior do POPFile usando a porta"

; Installation Log Messages [installer.nsi, addssl.nsi]

!insertmacro PFI_LANG_STRING PFI_LANG_PROG_SAVELOG         "Saving install log file..."

; Message Box text strings [installer.nsi, adduser.nsi, pfi-library.nsh]

!insertmacro PFI_LANG_STRING PFI_LANG_MBMANSHUT_1          "Imposs�vel desligar o $G_PLS_FIELD_1 automaticamente."
!insertmacro PFI_LANG_STRING PFI_LANG_MBMANSHUT_2          "Por favor desligue o $G_PLS_FIELD_1 manualmente agora."
!insertmacro PFI_LANG_STRING PFI_LANG_MBMANSHUT_3          "Quando o $G_PLS_FIELD_1 tiver sido desligado, clique 'OK' para continuar."

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; Shared: Message box shown if problem detected when trying to save the log file [installer.nsi, addssl.nsi, backup.nsi, restore.nsi]
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

!insertmacro PFI_LANG_STRING PFI_LANG_MB_SAVELOG_ERROR     "Error: problem detected when saving the log file"

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; Shared: Message boxes shown if uninstallation is not straightforward [installer.nsi, adduser.nsi]
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

!insertmacro PFI_LANG_STRING PFI_LANG_UN_MBDIFFUSER_1      "'$G_WINUSERNAME' est� tentando remover dados pertencentes a outro usu�rio"

!insertmacro PFI_LANG_STRING PFI_LANG_UN_MBNOTFOUND_1      "N�o parece que o POPFile esteja instalado nesta pasta"
!insertmacro PFI_LANG_STRING PFI_LANG_UN_MBNOTFOUND_2      "Continuar mesmo assim (n�o recomendado) ?"

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; Shared: Message box shown if uninstaller is cancelled by the user [installer.nsi, adduser.nsi]
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

!insertmacro PFI_LANG_STRING PFI_LANG_UN_ABORT_1           "Desinstala��o cancelada pelo usu�rio"

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; Shared: Standard MUI Page - UNPAGE_INSTFILES [installer.nsi, adduser.nsi]
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

; Uninstall Progress Reports displayed above the progress bar

!insertmacro PFI_LANG_STRING PFI_LANG_UN_PROG_SHUTDOWN     "Desligando o POPFile..."
!insertmacro PFI_LANG_STRING PFI_LANG_UN_PROG_SHORT        "Deletando entradas no 'Menu Iniciar' para o POPFile..."

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; Shared: Message box shown if uninstaller failed to remove files/folders [installer.nsi, adduser.nsi]
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

; TempTranslationNote: PFI_LANG_UN_MBREMERR_A = PFI_LANG_UN_MBREMERR_1 + ": $G_PLS_FIELD_1 " + PFI_LANG_UN_MBREMERR_2

!insertmacro PFI_LANG_STRING PFI_LANG_UN_MBREMERR_A        "Nota: $G_PLS_FIELD_1 n�o pode ser removido."

###########################################################################
###########################################################################

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; POPFile Installer: Message box shown (before the WELCOME page) offering to display the release notes [installer.nsi]
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

!insertmacro PFI_LANG_STRING PFI_LANG_MBRELNOTES_1         "Exibir as Notas de Libera��o do POPFile ?"
!insertmacro PFI_LANG_STRING PFI_LANG_MBRELNOTES_2         "� recomendado responder Sim se voc� estiver atualizando o POPFile (pode ser necess�rio voc� fazer uma c�pia de seguran�a ANTES de atualizar)"

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; POPFile Installer: Standard MUI Page - WELCOME [installer.nsi]
;
; The PFI_LANG_WELCOME_INFO_TEXT string should end with a '${IO_NL}${IO_NL}$_CLICK' sequence).
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

!insertmacro PFI_LANG_STRING PFI_LANG_WELCOME_INFO_TEXT    "Este assistente te guiar� durante a instala��o do POPFile.${IO_NL}${IO_NL}� recomendado que voc� feche todas as outras aplica��es antes de iniciar a Instala��o.${IO_NL}${IO_NL}$_CLICK"
!insertmacro PFI_LANG_STRING PFI_LANG_WELCOME_ADMIN_TEXT   "NOTA IMPORTANTE:${IO_NL}${IO_NL}O usu�rio corrente N�O tem direitos de 'Administrador'.${IO_NL}${IO_NL}Se suporte a multi-usu�rio � requerido, � recomendado que voc� cancele esta instala��o e use uma conta de 'Administrador' para instalar o POPFile."

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; POPFile Installer: Custom Page - Check Perl Requirements [installer.nsi]
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

; Page Title displayed in the page header (there is no sub-title for this page)

!insertmacro PFI_LANG_STRING PFI_LANG_PERLREQ_TITLE        "Detectados Componentes do Sistema Desatualizados"

; Text strings displayed on the custom page

; TempTranslationNote: PFI_LANG_PERLREQ_IO_TEXT_A =  PFI_LANG_PERLREQ_IO_TEXT_1
; TempTranslationNote: PFI_LANG_PERLREQ_IO_TEXT_B =  PFI_LANG_PERLREQ_IO_TEXT_2
; TempTranslationNote: PFI_LANG_PERLREQ_IO_TEXT_C =  PFI_LANG_PERLREQ_IO_TEXT_3
; TempTranslationNote: PFI_LANG_PERLREQ_IO_TEXT_D =  PFI_LANG_PERLREQ_IO_TEXT_4
; TempTranslationNote: PFI_LANG_PERLREQ_IO_TEXT_E =  PFI_LANG_PERLREQ_IO_TEXT_5 + " $G_PLS_FIELD_1${IO_NL}${IO_NL}"
; TempTranslationNote: PFI_LANG_PERLREQ_IO_TEXT_F =  PFI_LANG_PERLREQ_IO_TEXT_6
; TempTranslationNote: PFI_LANG_PERLREQ_IO_TEXT_G =  PFI_LANG_PERLREQ_IO_TEXT_7

!insertmacro PFI_LANG_STRING PFI_LANG_PERLREQ_IO_TEXT_A    "O browser padr�o � usado para exibir a Interface de Usu�rio do POPFile (seu centro de controle).${IO_NL}${IO_NL}"
!insertmacro PFI_LANG_STRING PFI_LANG_PERLREQ_IO_TEXT_B    "O POPFile n�o requer um browser espec�fico, ele funcionar� com praticamente qualquer browser.${IO_NL}${IO_NL}"
!insertmacro PFI_LANG_STRING PFI_LANG_PERLREQ_IO_TEXT_C    "Uma vers�o m�nima do Perl est� para ser instalada (o POPFile � escrito em Perl).${IO_NL}${IO_NL}"
!insertmacro PFI_LANG_STRING PFI_LANG_PERLREQ_IO_TEXT_D    "O Perl fornecido com o POPFile faz uso de alguns componentes do Internet Explorer e requer o Internet Explorer 5.5 (ou uma vers�o mais atual)."
!insertmacro PFI_LANG_STRING PFI_LANG_PERLREQ_IO_TEXT_E    "O instalador detectou que este sistema tem o Internet Explorer $G_PLS_FIELD_1${IO_NL}${IO_NL}"
!insertmacro PFI_LANG_STRING PFI_LANG_PERLREQ_IO_TEXT_F    "� poss�vel que algumas caracter�sticas do POPFile n�o funcionem corretamente neste sistema.${IO_NL}${IO_NL}"
!insertmacro PFI_LANG_STRING PFI_LANG_PERLREQ_IO_TEXT_G    "Se voc� tiver algum problema com o POPFile, uma atualiza��o para uma vers�o mais nova do Internet Explorer pode ajudar."

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; POPFile Installer: Standard MUI Page - COMPONENTS [installer.nsi]
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

!insertmacro PFI_LANG_STRING DESC_SecPOPFile               "Instala os arquivos principais necess�rios para o POPFile, incluindo uma vers�o m�nima do Perl."
!insertmacro PFI_LANG_STRING DESC_SecSkins                 "Instala skins do POPFile que permitem a voc� trocar a apar�ncia da interface de usu�rio do POPFile."
!insertmacro PFI_LANG_STRING DESC_SecLangs                 "Instala vers�es da interface de usu�rio em outras l�nguas."

!insertmacro PFI_LANG_STRING DESC_SubSecOptional           "Componentes extra do POPFile (para usu�rios avan�ados)"
!insertmacro PFI_LANG_STRING DESC_SecIMAP                  "Instala o m�dulo IMAP do POPFile"
!insertmacro PFI_LANG_STRING DESC_SecNNTP                  "Instala o proxy NNTP do POPFile"
!insertmacro PFI_LANG_STRING DESC_SecSMTP                  "Instala o proxy SMTP do POPFile"
!insertmacro PFI_LANG_STRING DESC_SecSOCKS                 "Instala componentes extra do Perl que permitem aos proxies do POPFile usar SOCKS"
!insertmacro PFI_LANG_STRING DESC_SecSSL                   "Downloads and installs the Perl components and SSL libraries which allow POPFile to make SSL connections to mail servers"
!insertmacro PFI_LANG_STRING DESC_SecXMLRPC                "Instala o m�dulo XMLRPC do POPFile (para acessar a API do POPFile) e o suporte do Perl requerido."

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; POPFile Installer: Standard MUI Page - DIRECTORY (for POPFile program files) [installer.nsi]
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

; Page Title shown in the page header and Text shown above the box showing the folder selected for the installation

!insertmacro PFI_LANG_STRING PFI_LANG_ROOTDIR_TITLE        "Escolha o Local de Instala��o dos Arquivos de Programa"
!insertmacro PFI_LANG_STRING PFI_LANG_ROOTDIR_TEXT_DESTN   "Pasta de Destino para o Programa POPFile"

; Message box warnings used when verifying the installation folder chosen by user

!insertmacro PFI_LANG_STRING PFI_LANG_DIRSELECT_MBWARN_1   "Instala��o anterior encontrada em"

; Text strings used when user has NOT selected a component found in the existing installation

!insertmacro PFI_LANG_STRING MBCOMPONENT_PROB_1            "Voc� quer atualizar o componente $G_PLS_FIELD_1 existente?"
!insertmacro PFI_LANG_STRING MBCOMPONENT_PROB_2            "(usar componentes desatualizados do POPFile pode causar problemas)"

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; POPFile Installer: Custom Page - Setup Summary [installer.nsi]
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

; Page Title and Sub-title displayed in the page header
; $G_WINUSERNAME holds the Windows login name and $G_WINUSERTYPE holds 'Admin', 'Power', 'User', 'Guest' or 'Unknown'

!insertmacro PFI_LANG_STRING PFI_LANG_SUMMARY_TITLE        "Setup Summary for '$G_WINUSERNAME' ($G_WINUSERTYPE)"
!insertmacro PFI_LANG_STRING PFI_LANG_SUMMARY_SUBTITLE     "These settings will be used to install the POPFile program"

; Display selected installation location and whether or not an upgrade will be performed
; $G_ROOTDIR holds the installation location, e.g. C:\Program Files\POPFile

!insertmacro PFI_LANG_STRING PFI_LANG_SUMMARY_NEWLOCN      "New POPFile installation at $G_ROOTDIR"
!insertmacro PFI_LANG_STRING PFI_LANG_SUMMARY_UPGRADELOCN  "Upgrade existing POPFile installation at $G_ROOTDIR"

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

!insertmacro PFI_LANG_STRING PFI_LANG_INSTFINISH_TITLE     "Arquivos de Programa Instalados"
!insertmacro PFI_LANG_STRING PFI_LANG_INSTFINISH_SUBTITLE  "${C_PFI_PRODUCT} deve ser configurado antes de ser usado"

; Installation Progress Reports displayed above the progress bar

!insertmacro PFI_LANG_STRING PFI_LANG_INST_PROG_CORE       "Instalando os arquivos principais do POPFile..."
!insertmacro PFI_LANG_STRING PFI_LANG_INST_PROG_PERL       "Instalando os arquivos m�nimos do Perl..."
!insertmacro PFI_LANG_STRING PFI_LANG_INST_PROG_SKINS      "Instalando os arquivos de skins do POPFile..."
!insertmacro PFI_LANG_STRING PFI_LANG_INST_PROG_XMLRPC     "Instalando os arquivos XMLRPC do POPFile..."

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; POPFile Installer: Standard MUI Page - UNPAGE_INSTFILES [installer.nsi]
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

; Uninstall Progress Reports displayed above the progress bar

!insertmacro PFI_LANG_STRING PFI_LANG_UN_PROG_CORE         "Deletando arquivos principais do POPFile..."
!insertmacro PFI_LANG_STRING PFI_LANG_UN_PROG_SKINS        "Deletando arquivos de skins do POPFile..."
!insertmacro PFI_LANG_STRING PFI_LANG_UN_PROG_PERL         "Deletando arquivos m�nimos do Perl..."

; Uninstall Log Messages

!insertmacro PFI_LANG_STRING PFI_LANG_UN_LOG_SHUTDOWN      "Desligando o POPFile usando a porta"
!insertmacro PFI_LANG_STRING PFI_LANG_UN_LOG_DELROOTDIR    "Removendo todos os arquivos da pasta do POPFile"
!insertmacro PFI_LANG_STRING PFI_LANG_UN_LOG_DELROOTERR    "Nota: imposs�vel remover todos os arquivos da pasta do POPFile"

; Message Box text strings

!insertmacro PFI_LANG_STRING PFI_LANG_UN_MBREMDIR_1        "Voc� quer remover todos os arquivos da sua pasta do POPFile ?${MB_NL}${MB_NL}$G_ROOTDIR${MB_NL}${MB_NL}(Se voc� tiver qualquer coisa que voc� criou e quer manter, clique N�o)"

###########################################################################
###########################################################################

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; SSL Setup: Standard MUI Page - WELCOME
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

!insertmacro PFI_LANG_STRING PSS_LANG_WELCOME_TITLE        "Welcome to the $(^NameDA) Wizard"
!insertmacro PFI_LANG_STRING PSS_LANG_WELCOME_TEXT         "This utility will download and install the files needed to allow POPFile to use SSL when accessing mail servers.${IO_NL}${IO_NL}This version does not configure any email accounts to use SSL, it just installs the necessary Perl components and DLLs.${IO_NL}${IO_NL}This product downloads software developed by the OpenSSL Project for use in the OpenSSL Toolkit (http://www.openssl.org/)${IO_NL}${IO_NL}~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~${IO_NL}${IO_NL}   PLEASE SHUT DOWN POPFILE NOW${IO_NL}${IO_NL}~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~${IO_NL}${IO_NL}$_CLICK"

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
!insertmacro PFI_LANG_STRING PSS_LANG_PROG_CHECKIFRUNNING  "Checking if POPFile is running..."
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

!insertmacro PFI_LANG_STRING PFI_LANG_PROG_CHECKINTERNET   "Checking Internet connection..."
!insertmacro PFI_LANG_STRING PFI_LANG_PROG_STARTDOWNLOAD   "Downloading $G_PLS_FIELD_1 file from $G_PLS_FIELD_2"
!insertmacro PFI_LANG_STRING PFI_LANG_PROG_FILECOPY        "Copying $G_PLS_FIELD_2 files..."
!insertmacro PFI_LANG_STRING PFI_LANG_PROG_FILEEXTRACT     "Extracting files from $G_PLS_FIELD_2 archive..."

!insertmacro PFI_LANG_STRING PFI_LANG_TAKE_SEVERAL_SECONDS "(this may take several seconds)"

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; Get SSL: Message Box strings used when installing SSL Support [getssl.nsh]
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

!insertmacro PFI_LANG_STRING PFI_LANG_MB_INTERNETCONNECT   "The SSL Support files will be downloaded from the Internet${MB_NL}${MB_NL}Please connect to the Internet and the click 'OK'${MB_NL}${MB_NL}or click 'Cancel' to cancel this part of the installation"

!insertmacro PFI_LANG_STRING PFI_LANG_MB_NSISDLFAIL_1      "Download of $G_PLS_FIELD_1 file failed"
!insertmacro PFI_LANG_STRING PFI_LANG_MB_NSISDLFAIL_2      "(error: $G_PLS_FIELD_2)"

!insertmacro PFI_LANG_STRING PFI_LANG_MB_UNPACKFAIL        "Error detected while installing files in $G_PLS_FIELD_1 folder"

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; Get SSL: NSISdl strings (displayed by the plugin which downloads the SSL files) [getssl.nsh]
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;
; The NSISdl plugin shows two progress bars, for example:
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

!insertmacro PFI_LANG_STRING PFI_LANG_ADDUSER_INFO_TEXT    "Este assistente vai guiar voc� pela configura��o do POPFile para o usu�rio '$G_WINUSERNAME'.${IO_NL}${IO_NL}� recomendado que voc� feche todas as outras aplica��es antes de continuar.${IO_NL}${IO_NL}$_CLICK"

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; Add User: Standard MUI Page - DIRECTORY [adduser.nsi]
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

; $G_WINUSERNAME holds the Windows login name for the user running the wizard

!insertmacro PFI_LANG_STRING PFI_LANG_USERDIR_TITLE        "Escolha o Local dos Dados do POPFile para '$G_WINUSERNAME'"
!insertmacro PFI_LANG_STRING PFI_LANG_USERDIR_SUBTITLE     "Escolha a pasta para guardar os Dados do POPFile para '$G_WINUSERNAME'"
!insertmacro PFI_LANG_STRING PFI_LANG_USERDIR_TEXT_TOP     "Esta vers�o do POPFile usa conjuntos de arquivos de dados separados para cada usu�rio.${MB_NL}${MB_NL}O Instalador vai usar a seguinte pasta para os dados do POPFile pertencentes ao usu�rio'$G_WINUSERNAME'. Para usar uma pasta diferente para este usu�rio, clique em Procurar e selecione uma outra pasta. $_CLICK"
!insertmacro PFI_LANG_STRING PFI_LANG_USERDIR_TEXT_DESTN   "Pasta a ser usada para guardar os dados do POPFile para '$G_WINUSERNAME'"

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; Add User: Standard MUI Page - INSTFILES [adduser.nsi]
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

; Page Title and Sub-title displayed in the page header

!insertmacro PFI_LANG_STRING PFI_LANG_ADDUSER_TITLE        "Configurando o POPFile para o usu�rio '$G_WINUSERNAME'"
!insertmacro PFI_LANG_STRING PFI_LANG_ADDUSER_SUBTITLE     "Por favor espere enquanto os arquivos de configura��o do POPFile s�o atualizados para este usu�rio"

; When resetting POPFile to use newly restored 'User Data', change "Install" button to "Restore"

!insertmacro PFI_LANG_STRING PFI_LANG_INST_BTN_RESTORE     "Restaurar"

; Installation Progress Reports displayed above the progress bar

!insertmacro PFI_LANG_STRING PFI_LANG_INST_PROG_CORPUS     "Fazendo o backup do corpus. Isto pode levar alguns segundos..."
!insertmacro PFI_LANG_STRING PFI_LANG_INST_PROG_SQLBACKUP  "Fazendo c�pia de seguran�a da base de dados SQLite antiga..."
!insertmacro PFI_LANG_STRING PFI_LANG_INST_PROG_FINDCORPUS "Procurando por corpus existente em arquivo plano ou BerkeleyDB..."
!insertmacro PFI_LANG_STRING PFI_LANG_INST_PROG_MAKEBAT    "Gerando o arquivo batch 'pfi-run.bat'..."
!insertmacro PFI_LANG_STRING PFI_LANG_INST_PROG_REGSET     "Atualizando configura��es no registro e vari�veis de ambiente..."

; Message Box text strings

; TempTranslationNote: PFI_LANG_MBSTPWDS_A = "POPFile 'stopwords' " + PFI_LANG_MBSTPWDS_1
; TempTranslationNote: PFI_LANG_MBSTPWDS_B = PFI_LANG_MBSTPWDS_2
; TempTranslationNote: PFI_LANG_MBSTPWDS_C = PFI_LANG_MBSTPWDS_3 + " 'stopwords.bak')"
; TempTranslationNote: PFI_LANG_MBSTPWDS_D = PFI_LANG_MBSTPWDS_4 + " 'stopwords.default')"

!insertmacro PFI_LANG_STRING PFI_LANG_MBSTPWDS_A           "POPFile 'stopwords' encontrado arquivo de uma instala��o anterior."
!insertmacro PFI_LANG_STRING PFI_LANG_MBSTPWDS_B           "Atualizar este arquivo ?"
!insertmacro PFI_LANG_STRING PFI_LANG_MBSTPWDS_C           "Clique 'Sim' para atualizar (o arquivo antigo ser� salvo como 'stopwords.bak')"
!insertmacro PFI_LANG_STRING PFI_LANG_MBSTPWDS_D           "Clique 'N�o' para manter o arquivo antigo (o arquivo novo ser� salvo como 'stopwords.default')"

!insertmacro PFI_LANG_STRING PFI_LANG_MBCORPUS_1           "Erro detectado quando o instalador tentou fazer o backup do corpus antigo."

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; Add User: Message box warnings used when verifying the installation folder chosen by user [adduser.nsi]
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

!insertmacro PFI_LANG_STRING PFI_LANG_DIRSELECT_MBWARN_3   "Dados de configura��o anteriores encontrados em"
!insertmacro PFI_LANG_STRING PFI_LANG_DIRSELECT_MBWARN_4   "Encontrados dados de configura��o restaurados"
!insertmacro PFI_LANG_STRING PFI_LANG_DIRSELECT_MBWARN_5   "Voc� quer usar os dados restaurados?"

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; Add User: Custom Page - POPFile Installation Options [adduser.nsi]
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

; Page Title and Sub-title displayed in the page header

!insertmacro PFI_LANG_STRING PFI_LANG_OPTIONS_TITLE        "Op��es de Instala��o do POPFile"
!insertmacro PFI_LANG_STRING PFI_LANG_OPTIONS_SUBTITLE     "N�o altere estas op��es a menos que voc� precise realmente mud�-las"

; Text strings displayed on the custom page

!insertmacro PFI_LANG_STRING PFI_LANG_OPTIONS_IO_POP3      "Escolha a porta padr�o para conex�es POP3 (recomendado 110)"
!insertmacro PFI_LANG_STRING PFI_LANG_OPTIONS_IO_GUI       "Escolha a porta padr�o para conex�es da 'Interface de Usu�rio' (recomendado 8080)"
!insertmacro PFI_LANG_STRING PFI_LANG_OPTIONS_IO_STARTUP   "Executar o POPFile automaticamente quando o Windows iniciar"
!insertmacro PFI_LANG_STRING PFI_LANG_OPTIONS_IO_WARNING   "AVISO IMPORTANTE"
!insertmacro PFI_LANG_STRING PFI_LANG_OPTIONS_IO_MESSAGE   "SE ESTIVER ATUALIZANDO O POPFILE --- O INSTALADOR VAI DESLIGAR A VERS�O EXISTENTE"

; Message Boxes used when validating user's selections

; TempTranslationNote: PFI_LANG_OPTIONS_MBPOP3_A = PFI_LANG_OPTIONS_MBPOP3_1 + " '$G_POP3'."
; TempTranslationNote: PFI_LANG_OPTIONS_MBPOP3_B = PFI_LANG_OPTIONS_MBPOP3_2
; TempTranslationNote: PFI_LANG_OPTIONS_MBPOP3_C = PFI_LANG_OPTIONS_MBPOP3_3

!insertmacro PFI_LANG_STRING PFI_LANG_OPTIONS_MBPOP3_A     "A porta POP3 n�o pode ser definida '$G_POP3'."
!insertmacro PFI_LANG_STRING PFI_LANG_OPTIONS_MBPOP3_B     "A porta deve ser um n�mero entre 1 e 65535."
!insertmacro PFI_LANG_STRING PFI_LANG_OPTIONS_MBPOP3_C     "Por favor altere sua sele��o de porta POP3."

; TempTranslationNote: PFI_LANG_OPTIONS_MBGUI_A = PFI_LANG_OPTIONS_MBGUI_1 + " '$G_GUI'."
; TempTranslationNote: PFI_LANG_OPTIONS_MBGUI_B = PFI_LANG_OPTIONS_MBGUI_2
; TempTranslationNote: PFI_LANG_OPTIONS_MBGUI_C = PFI_LANG_OPTIONS_MBGUI_3

!insertmacro PFI_LANG_STRING PFI_LANG_OPTIONS_MBGUI_A      "A porta 'Interface de Usu�rio' n�o pode ser definida '$G_GUI'."
!insertmacro PFI_LANG_STRING PFI_LANG_OPTIONS_MBGUI_B      "A porta deve ser um n�mero entre 1 e 65535."
!insertmacro PFI_LANG_STRING PFI_LANG_OPTIONS_MBGUI_C      "Por favor altere sua sele��o de porta para 'Interface de Usu�rio'."

!insertmacro PFI_LANG_STRING PFI_LANG_OPTIONS_MBDIFF_1     "A porta POP3 deve ser diferente da porta 'Interface de Usu�rio'."
!insertmacro PFI_LANG_STRING PFI_LANG_OPTIONS_MBDIFF_2     "Por favor altere sua sele��o de portas."

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

!insertmacro PFI_LANG_STRING PFI_LANG_CBP_DEFAULT_BUCKETS  "spam|pessoal|trabalho|outros"
!insertmacro PFI_LANG_STRING PFI_LANG_CBP_SUGGESTED_NAMES  "admin|admin-lista|compras|computadores|entrada|escola|familia|financeiro|geral|lixo|miscelanea|nao_spam|negocios|outros|passa-tempo|pessoal|recreacao|seguranca|spam|trabalho|viagem"

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; Add User: Custom Page - POPFile Classification Bucket Creation [CBP.nsh]
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

; Page Title and Sub-title displayed in the page header

!insertmacro PFI_LANG_STRING PFI_LANG_CBP_TITLE            "Cria��o de Balde de Classifica��o do POPFile"
!insertmacro PFI_LANG_STRING PFI_LANG_CBP_SUBTITLE         "O POPFile precisa PELO MENOS DOIS baldes para poder classificar seus emails"

; Text strings displayed on the custom page

!insertmacro PFI_LANG_STRING PFI_LANG_CBP_IO_INTRO         "Depois da instala��o, o POPFile torna f�cil alterar o n�mero de baldes (e seus nomes) para satisfazer suas necessidades.${IO_NL}${IO_NL}Os nomes dos baldes devem ser palavras �nicas, usando letras min�sculas, d�gitos de 0 a 9, h�fens e sublinhados."
!insertmacro PFI_LANG_STRING PFI_LANG_CBP_IO_CREATE        "Crie um novo balde selecionando um nome da lista abaixo ou digitando um nome de sua escolha."
!insertmacro PFI_LANG_STRING PFI_LANG_CBP_IO_DELETE        "Para deletar um ou mais baldes da lista, marque a(s) caixa(s) 'Remover' relevante(s) e clique no bot�o 'Continuar'."
!insertmacro PFI_LANG_STRING PFI_LANG_CBP_IO_LISTHDR       "Baldes a serem usados pelo POPFile"
!insertmacro PFI_LANG_STRING PFI_LANG_CBP_IO_REMOVE        "Remover"
!insertmacro PFI_LANG_STRING PFI_LANG_CBP_IO_CONTINUE      "Continuar"

; Text strings used for status messages under the bucket list

; TempTranslationNote: PFI_LANG_CBP_IO_MSG_A = PFI_LANG_CBP_IO_MSG_1
; TempTranslationNote: PFI_LANG_CBP_IO_MSG_B = PFI_LANG_CBP_IO_MSG_2
; TempTranslationNote: PFI_LANG_CBP_IO_MSG_C = PFI_LANG_CBP_IO_MSG_3
; TempTranslationNote: PFI_LANG_CBP_IO_MSG_D = PFI_LANG_CBP_IO_MSG_4 + " $G_PLS_FIELD_1 " + PFI_LANG_CBP_IO_MSG_5

!insertmacro PFI_LANG_STRING PFI_LANG_CBP_IO_MSG_A         "N�o � necess�rio adicionar mais nenhum balde"
!insertmacro PFI_LANG_STRING PFI_LANG_CBP_IO_MSG_B         "Voc� deve definir PELO MENOS DOIS baldes"
!insertmacro PFI_LANG_STRING PFI_LANG_CBP_IO_MSG_C         "Pelo menos mais um balde � requerido"
!insertmacro PFI_LANG_STRING PFI_LANG_CBP_IO_MSG_D         "O instalador n�o pode criar mais que $G_PLS_FIELD_1 baldes"

; Message box text strings

; TempTranslationNote: PFI_LANG_CBP_MBDUPERR_A = PFI_LANG_CBP_MBDUPERR_1 + " '$G_PLS_FIELD_1' " + PFI_LANG_CBP_MBDUPERR_2
; TempTranslationNote: PFI_LANG_CBP_MBDUPERR_B = PFI_LANG_CBP_MBDUPERR_3

!insertmacro PFI_LANG_STRING PFI_LANG_CBP_MBDUPERR_A       "Um balde chamado '$G_PLS_FIELD_1' j� foi definido."
!insertmacro PFI_LANG_STRING PFI_LANG_CBP_MBDUPERR_B       "Por favor escolha um nome diferente para o novo balde."

; TempTranslationNote: PFI_LANG_CBP_MBMAXERR_A = PFI_LANG_CBP_MBMAXERR_1 + " $G_PLS_FIELD_1 " + PFI_LANG_CBP_MBMAXERR_2
; TempTranslationNote: PFI_LANG_CBP_MBMAXERR_B = PFI_LANG_CBP_MBMAXERR_3 + " $G_PLS_FIELD_1 " + PFI_LANG_CBP_MBMAXERR_2

!insertmacro PFI_LANG_STRING PFI_LANG_CBP_MBMAXERR_A       "O instalador pode somente criar at� $G_PLS_FIELD_1 baldes."
!insertmacro PFI_LANG_STRING PFI_LANG_CBP_MBMAXERR_B       "Uma vez que o POPFile tenha sido instalado, voc� poder� criar mais que $G_PLS_FIELD_1 baldes"

; TempTranslationNote: PFI_LANG_CBP_MBNAMERR_A = PFI_LANG_CBP_MBNAMERR_1 + " '$G_PLS_FIELD_1' " + PFI_LANG_CBP_MBNAMERR_2
; TempTranslationNote: PFI_LANG_CBP_MBNAMERR_B = PFI_LANG_CBP_MBNAMERR_3
; TempTranslationNote: PFI_LANG_CBP_MBNAMERR_C = PFI_LANG_CBP_MBNAMERR_4

!insertmacro PFI_LANG_STRING PFI_LANG_CBP_MBNAMERR_A       "O nome '$G_PLS_FIELD_1' n�o � um nome v�lido para um balde."
!insertmacro PFI_LANG_STRING PFI_LANG_CBP_MBNAMERR_B       "Nomes de balde somente podem conter as letras de a at� z min�sculas, n�meros de 0 a 9, mais - e _"
!insertmacro PFI_LANG_STRING PFI_LANG_CBP_MBNAMERR_C       "Por favor escolha um nome diferente para o novo balde."

!insertmacro PFI_LANG_STRING PFI_LANG_CBP_MBCONTERR_1      "O POPFile requer PELO MENOS DOIS baldes para poder classificar seus emails."
!insertmacro PFI_LANG_STRING PFI_LANG_CBP_MBCONTERR_2      "Por favor entre o nome de um balde para ser criado,${MB_NL}${MB_NL}escolhendo um nome sugerido da lista${MB_NL}${MB_NL}ou digitando um nome de sua escolha."
!insertmacro PFI_LANG_STRING PFI_LANG_CBP_MBCONTERR_3      "Voc� deve definir PELO MENOS DOIS baldes antes de continuar sua instala��o do POPFile."

; TempTranslationNote: PFI_LANG_CBP_MBDONE_A = "$G_PLS_FIELD_1 " + PFI_LANG_CBP_MBDONE_1
; TempTranslationNote: PFI_LANG_CBP_MBDONE_B = PFI_LANG_CBP_MBDONE_2
; TempTranslationNote: PFI_LANG_CBP_MBDONE_C = PFI_LANG_CBP_MBDONE_3

!insertmacro PFI_LANG_STRING PFI_LANG_CBP_MBDONE_A         "$G_PLS_FIELD_1 baldes foram definidos para uso do POPFile."
!insertmacro PFI_LANG_STRING PFI_LANG_CBP_MBDONE_B         "Voc� quer configurar o POPFile para usar estes baldes ?"
!insertmacro PFI_LANG_STRING PFI_LANG_CBP_MBDONE_C         "Clique 'N�o' se voc� quer alterar sua sele��o de baldes."

; TempTranslationNote: PFI_LANG_CBP_MBMAKERR_A = PFI_LANG_CBP_MBMAKERR_1 + " $G_PLS_FIELD_1 " + PFI_LANG_CBP_MBMAKERR_2 + " $G_PLS_FIELD_2 " + PFI_LANG_CBP_MBMAKERR_3
; TempTranslationNote: PFI_LANG_CBP_MBMAKERR_B = PFI_LANG_CBP_MBMAKERR_4

!insertmacro PFI_LANG_STRING PFI_LANG_CBP_MBMAKERR_A       "O instalador n�o foi capaz de criar $G_PLS_FIELD_1 de $G_PLS_FIELD_2 baldes que voc� selecionou."
!insertmacro PFI_LANG_STRING PFI_LANG_CBP_MBMAKERR_B       "Uma vez que o POPFile tenha sido instalado, voc� pode usar seu pain�l de controle${MB_NL}${MB_NL} na 'Interface de Usu�rio' para criar o(s) balde(s) que faltar(em)."

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; Add User: Custom Page - Email Client Reconfiguration [adduser.nsi]
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

; Page Title and Sub-title displayed in the page header

!insertmacro PFI_LANG_STRING PFI_LANG_MAILCFG_TITLE        "Configura��o do Cliente de Email"
!insertmacro PFI_LANG_STRING PFI_LANG_MAILCFG_SUBTITLE     "O POPFile pode reconfigurar v�rios clientes de email para voc�"

; Text displayed on the custom page

!insertmacro PFI_LANG_STRING PFI_LANG_MAILCFG_IO_TEXT_1    "Clientes de email marcados (*) podem ser reconfigurados automaticamente, assumindo que contas simples sejam usadas.${IO_NL}${IO_NL}� altamente recomendado que contas que requeiram autentica��o sejam configuradas manualmente."
!insertmacro PFI_LANG_STRING PFI_LANG_MAILCFG_IO_TEXT_2    "IMPORTANTE: POR FAVOR FECHE OS CLIENTES DE EMAIL RECONFIGUR�VEIS AGORA${IO_NL}${IO_NL}Esta caracter�stica ainda est� em desenvolvimento (algumas contas do Outlook podem n�o serem detectadas).${IO_NL}${IO_NL}Por favor verifique se a reconfigura��o foi bem sucedida (antes de usar o cliente de email)."

!insertmacro PFI_LANG_STRING PFI_LANG_MAILCFG_IO_CANCEL    "Reconfigura��o do cliente de email cancelada pelo usu�rio"

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; Add User: Text used on buttons to skip configuration of email clients [adduser.nsi]
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

!insertmacro PFI_LANG_STRING PFI_LANG_MAILCFG_IO_SKIPALL   "Pular Todos"
!insertmacro PFI_LANG_STRING PFI_LANG_MAILCFG_IO_SKIPONE   "Pular Cliente"

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; Add User: Message box warnings that an email client is still running [adduser.nsi]
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

!insertmacro PFI_LANG_STRING PFI_LANG_MBCLIENT_EXP         "AVISO: o Outlook Express parece estar rodando!"
!insertmacro PFI_LANG_STRING PFI_LANG_MBCLIENT_OUT         "AVISO: o Outlook parece estar rodando!"
!insertmacro PFI_LANG_STRING PFI_LANG_MBCLIENT_EUD         "AVISO: o Eudora parece estar rodando!"

!insertmacro PFI_LANG_STRING PFI_LANG_MBCLIENT_STOP_1      "Por favor FECHE o programa de email e clique 'Repetir' para reconfigur�-lo"
!insertmacro PFI_LANG_STRING PFI_LANG_MBCLIENT_STOP_2      "(Voc� pode clicar 'Ignorar' para reconfigur�-lo, mas isto n�o � recomendado)"
!insertmacro PFI_LANG_STRING PFI_LANG_MBCLIENT_STOP_3      "Clique 'Anular' para pular a reconfigura��o deste programa de email"

; Following three strings are used when uninstalling

!insertmacro PFI_LANG_STRING PFI_LANG_MBCLIENT_STOP_4      "Por favor FECHE o programa de email e clique 'Repetir' para restaurar a configura��o"
!insertmacro PFI_LANG_STRING PFI_LANG_MBCLIENT_STOP_5      "(Voc� pode clicar 'Ignorar' para restaurar a configura��o, mas isto n�o � recomendado)"
!insertmacro PFI_LANG_STRING PFI_LANG_MBCLIENT_STOP_6      "Clique 'Anular' para pular a restaura��o da configura��o original"

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; Add User: Custom Page - Reconfigure Outlook/Outlook Express [adduser.nsi]
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

; Page Title and Sub-title displayed in the page header

!insertmacro PFI_LANG_STRING PFI_LANG_EXPCFG_TITLE         "Reconfigurar o Outlook Express"
!insertmacro PFI_LANG_STRING PFI_LANG_EXPCFG_SUBTITLE      "O POPFile pode reconfigurar o Outlook Express para voc�"

!insertmacro PFI_LANG_STRING PFI_LANG_OUTCFG_TITLE         "Reconfigurar o Outlook"
!insertmacro PFI_LANG_STRING PFI_LANG_OUTCFG_SUBTITLE      "O POPFile pode reconfigurar o Outlook para voc�"

; Text displayed on the custom page

!insertmacro PFI_LANG_STRING PFI_LANG_EXPCFG_IO_CANCELLED  "Reconfigura��o do Outlook Express cancelada pelo usu�rio"
!insertmacro PFI_LANG_STRING PFI_LANG_OUTCFG_IO_CANCELLED  "Reconfigura��o do Outlook cancelada pelo usu�rio"

!insertmacro PFI_LANG_STRING PFI_LANG_OOECFG_IO_BOXHDR     "contas"
!insertmacro PFI_LANG_STRING PFI_LANG_OOECFG_IO_ACCOUNTHDR "Conta"
!insertmacro PFI_LANG_STRING PFI_LANG_OOECFG_IO_EMAILHDR   "Endere�o de Email"
!insertmacro PFI_LANG_STRING PFI_LANG_OOECFG_IO_SERVERHDR  "Servidor"
!insertmacro PFI_LANG_STRING PFI_LANG_OOECFG_IO_USRNAMEHDR "Nome do Usu�rio"
!insertmacro PFI_LANG_STRING PFI_LANG_OOECFG_IO_FOOTNOTE   "Marque a(s) caixa(s) para reconfigurar a(s) conta(s).${IO_NL}Se voc� desinstalar o POPFile as configura��es originais ser�o restauradas."

; Message Box to confirm changes to Outlook/Outlook Express account configuration

!insertmacro PFI_LANG_STRING PFI_LANG_EXPCFG_MBIDENTITY    "Identidade Outlook Express:"
!insertmacro PFI_LANG_STRING PFI_LANG_EXPCFG_MBACCOUNT     "Conta Outlook Express:"

!insertmacro PFI_LANG_STRING PFI_LANG_OUTCFG_MBIDENTITY    "Usu�rio Outlook:"
!insertmacro PFI_LANG_STRING PFI_LANG_OUTCFG_MBACCOUNT     "Conta Outlook:"

!insertmacro PFI_LANG_STRING PFI_LANG_OOECFG_MBEMAIL       "Endere�o de email:"
!insertmacro PFI_LANG_STRING PFI_LANG_OOECFG_MBSERVER      "Servidor POP3:"
!insertmacro PFI_LANG_STRING PFI_LANG_OOECFG_MBUSERNAME    "Nome de usu�rio POP3:"
!insertmacro PFI_LANG_STRING PFI_LANG_OOECFG_MBOEPORT      "Porta POP3:"
!insertmacro PFI_LANG_STRING PFI_LANG_OOECFG_MBOLDVALUE    "correntemente"
!insertmacro PFI_LANG_STRING PFI_LANG_OOECFG_MBQUESTION    "Reconfigurar esta conta para funcionar com o POPFile ?"

; Title and Column headings for report/log files

!insertmacro PFI_LANG_STRING PFI_LANG_EXPCFG_LOG_BEFORE    "Configura��o do Outlook Express antes de qualquer altera��o ser feita"
!insertmacro PFI_LANG_STRING PFI_LANG_EXPCFG_LOG_AFTER     "Altera��es feitas na Configura��o do Outlook Express"

!insertmacro PFI_LANG_STRING PFI_LANG_OUTCFG_LOG_BEFORE    "Configura��o do Outlook antes de qualquer altera��o ser feita"
!insertmacro PFI_LANG_STRING PFI_LANG_OUTCFG_LOG_AFTER     "Altera��es feitas na Configura��o do Outlook"

!insertmacro PFI_LANG_STRING PFI_LANG_OOECFG_LOG_END       "(fim)"

!insertmacro PFI_LANG_STRING PFI_LANG_EXPCFG_LOG_IDENTITY  "'IDENTIDADE'"
!insertmacro PFI_LANG_STRING PFI_LANG_OUTCFG_LOG_IDENTITY  "'USU�RIO OUTLOOK'"

!insertmacro PFI_LANG_STRING PFI_LANG_OOECFG_LOG_ACCOUNT   "'CONTA'"

!insertmacro PFI_LANG_STRING PFI_LANG_OOECFG_LOG_EMAIL     "'ENDERE�O DE EMAIL'"
!insertmacro PFI_LANG_STRING PFI_LANG_OOECFG_LOG_SERVER    "'SERVIDOR POP3'"
!insertmacro PFI_LANG_STRING PFI_LANG_OOECFG_LOG_USER      "'NOME DE USU�RIO POP3'"
!insertmacro PFI_LANG_STRING PFI_LANG_OOECFG_LOG_PORT      "'PORTA POP3'"

!insertmacro PFI_LANG_STRING PFI_LANG_OOECFG_LOG_NEWSERVER "'NOVO SERVIDOR POP3'"
!insertmacro PFI_LANG_STRING PFI_LANG_OOECFG_LOG_NEWUSER   "'NOVO NOME DE USU�RIO POP3'"
!insertmacro PFI_LANG_STRING PFI_LANG_OOECFG_LOG_NEWPORT   "'NOVA PORTA POP3'"

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; Add User: Custom Page - Reconfigure Eudora [adduser.nsi]
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

; Page Title and Sub-title displayed in the page header

!insertmacro PFI_LANG_STRING PFI_LANG_EUCFG_TITLE          "Reconfigurar o Eudora"
!insertmacro PFI_LANG_STRING PFI_LANG_EUCFG_SUBTITLE       "O POPFile pode reconfigurar o Eudora para voc�"

; Text displayed on the custom page

!insertmacro PFI_LANG_STRING PFI_LANG_EUCFG_IO_CANCELLED   "Reconfigura��o do Eudora cancelada pelo usu�rio"

!insertmacro PFI_LANG_STRING PFI_LANG_EUCFG_IO_INTRO_1     "O POPFile detectou a seguinte personalidade do Eudora"
!insertmacro PFI_LANG_STRING PFI_LANG_EUCFG_IO_INTRO_2     " e pode automaticamente configur�-la para funcionar com o POPFile"
!insertmacro PFI_LANG_STRING PFI_LANG_EUCFG_IO_CHECKBOX    "Reconfigurar esta personalidade para funcionar com o POPFile"
!insertmacro PFI_LANG_STRING PFI_LANG_EUCFG_IO_DOMINANT    "Personalidade <dominante>"
!insertmacro PFI_LANG_STRING PFI_LANG_EUCFG_IO_PERSONA     "personalidade"
!insertmacro PFI_LANG_STRING PFI_LANG_EUCFG_IO_EMAIL       "Endere�o de email:"
!insertmacro PFI_LANG_STRING PFI_LANG_EUCFG_IO_SERVER      "Servidor POP3:"
!insertmacro PFI_LANG_STRING PFI_LANG_EUCFG_IO_USERNAME    "Nome de usu�rio POP3:"
!insertmacro PFI_LANG_STRING PFI_LANG_EUCFG_IO_POP3PORT    "Porta POP3:"
!insertmacro PFI_LANG_STRING PFI_LANG_EUCFG_IO_RESTORE     "Se voc� desinstalar o POPFile as configura��es originais ser�o restauradas"

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; Add User: Custom Page - POPFile can now be started [adduser.nsi]
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

; Page Title and Sub-title displayed in the page header

!insertmacro PFI_LANG_STRING PFI_LANG_LAUNCH_TITLE         "O POPFile pode ser iniciado agora"
!insertmacro PFI_LANG_STRING PFI_LANG_LAUNCH_SUBTITLE      "A Interface de Usu�rio do POPFile somente funciona se o POPFile tiver sido iniciado"

; Text displayed on the custom page

!insertmacro PFI_LANG_STRING PFI_LANG_LAUNCH_IO_INTRO      "Iniciar o POPFile agora ?"
!insertmacro PFI_LANG_STRING PFI_LANG_LAUNCH_IO_NO         "N�o (a 'Interface de Usu�rio' n�o pode ser usada se o POPFile n�o for iniciado)"
!insertmacro PFI_LANG_STRING PFI_LANG_LAUNCH_IO_DOSBOX     "Executar o POPFile (em uma janela)"
!insertmacro PFI_LANG_STRING PFI_LANG_LAUNCH_IO_BCKGRND    "Executar o POPFile em segundo plano (nenhuma janela � exibida)"
!insertmacro PFI_LANG_STRING PFI_LANG_LAUNCH_IO_NOICON     "Executar o POPFile (n�o exibir o �cone na bandeja do sistema)"
!insertmacro PFI_LANG_STRING PFI_LANG_LAUNCH_IO_TRAYICON   "Executar o POPFile com o �cone na bandeja do sistema"
!insertmacro PFI_LANG_STRING PFI_LANG_LAUNCH_IO_NOTE_1     "Uma vez que o POPFile tenha sido iniciado, voc� pode exibir a 'Interface de Usu�rio'"
!insertmacro PFI_LANG_STRING PFI_LANG_LAUNCH_IO_NOTE_2     "(a) dando um duplo-clique no �cone do POPFile na bandeja do sistema,   OU"
!insertmacro PFI_LANG_STRING PFI_LANG_LAUNCH_IO_NOTE_3     "(b) usando Iniciar --> Programas --> POPFile --> Interface de Usu�rio do POPFile."

; Banner message displayed whilst waiting for POPFile to start

!insertmacro PFI_LANG_STRING PFI_LANG_LAUNCH_BANNER_1      "Preparando para iniciar o POPFile."
!insertmacro PFI_LANG_STRING PFI_LANG_LAUNCH_BANNER_2      "Isto pode levar alguns segundos..."

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; Add User: Standard MUI Page - FINISH [adduser.nsi]
;
; The PFI_LANG_FINISH_RUN_TEXT text should be a short phrase (not a long paragraph)
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

; $G_WINUSERNAME holds the Windows login name of the user running the wizard

!insertmacro PFI_LANG_STRING PFI_LANG_ADDUSER_FINISH_INFO "O POPFile foi configurado para o usu�rio '$G_WINUSERNAME'.${IO_NL}${IO_NL}Clique em Finalizar para fechar este assistente."

!insertmacro PFI_LANG_STRING PFI_LANG_FINISH_RUN_TEXT      "Interface de Usu�rio do POPFile"
!insertmacro PFI_LANG_STRING PFI_LANG_FINISH_WEB_LINK_TEXT "Clique aqui para visitar o web site do POPFile"

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; Add User: Standard MUI Page - Uninstall Confirmation Page (for the 'Add POPFile User' wizard) [adduser.nsi]
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

; $G_WINUSERNAME holds the Windows login name for the user running the uninstall wizard

!insertmacro PFI_LANG_STRING PFI_LANG_REMUSER_TITLE        "Desinstalar dados do POPFile para o usu�rio '$G_WINUSERNAME'"
!insertmacro PFI_LANG_STRING PFI_LANG_REMUSER_SUBTITLE     "Remover dados de configura��o do POPFile para este usu�rio do seu computador"

!insertmacro PFI_LANG_STRING PFI_LANG_REMUSER_TEXT_TOP     "Os dados de configura��o do POPFile para o usu�rio '$G_WINUSERNAME' ser�o desinstalados da seguinte pasta. $_CLICK"

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; Add User: Standard MUI Page - Uninstallation Page (for the 'Add POPFile User' wizard) [adduser.nsi]
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

; $G_WINUSERNAME holds the Windows login name for the user running the uninstall wizard

!insertmacro PFI_LANG_STRING PFI_LANG_REMOVING_TITLE       "Desinstalando dados do POPFile para o usu�rio '$G_WINUSERNAME'"
!insertmacro PFI_LANG_STRING PFI_LANG_REMOVING_SUBTITLE    "Por favor espere enquanto os arquivos de configura��o do POPFile para este usu�rio s�o deletados"

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; Add User: Standard MUI Page - UNPAGE_INSTFILES [adduser.nsi]
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

; Uninstall Progress Reports displayed above the progress bar

!insertmacro PFI_LANG_STRING PFI_LANG_UN_PROG_OUTEXPRESS   "Restaurando configura��es do Outlook Express..."
!insertmacro PFI_LANG_STRING PFI_LANG_UN_PROG_OUTLOOK      "Restaurando configura��es do Outlook..."
!insertmacro PFI_LANG_STRING PFI_LANG_UN_PROG_EUDORA       "Restaurando configura��es do Eudora..."
!insertmacro PFI_LANG_STRING PFI_LANG_UN_PROG_DBMSGDIR     "Deletando o corpus e o diret�rio 'Mensagens Recentes'..."
!insertmacro PFI_LANG_STRING PFI_LANG_UN_PROG_CONFIG       "Deletando dados de condigura��o..."
!insertmacro PFI_LANG_STRING PFI_LANG_UN_PROG_EXESTATUS    "Verificando o estado do programa..."
!insertmacro PFI_LANG_STRING PFI_LANG_UN_PROG_REGISTRY     "Deletando entradas do POPFile no registro..."

; Uninstall Log Messages

!insertmacro PFI_LANG_STRING PFI_LANG_UN_LOG_OPENED        "Aberto"
!insertmacro PFI_LANG_STRING PFI_LANG_UN_LOG_RESTORED      "Restaurado"
!insertmacro PFI_LANG_STRING PFI_LANG_UN_LOG_CLOSED        "Fechado"
!insertmacro PFI_LANG_STRING PFI_LANG_UN_LOG_DATAPROBS     "Problemas nos dados"
!insertmacro PFI_LANG_STRING PFI_LANG_UN_LOG_DELUSERDIR    "Removendo todos os arquivos do diret�rio 'User Data' do POPFile"
!insertmacro PFI_LANG_STRING PFI_LANG_UN_LOG_DELUSERERR    "Nota: imposs�vel remover todos os arquivos do diret�rio 'User Data' do POPFile"

; Message Box text strings

!insertmacro PFI_LANG_STRING PFI_LANG_UN_MBCLIENT_1        "Problema no 'Outlook Express'!"
!insertmacro PFI_LANG_STRING PFI_LANG_UN_MBCLIENT_2        "Problema no 'Outlook'!"
!insertmacro PFI_LANG_STRING PFI_LANG_UN_MBCLIENT_3        "Problema no 'Eudora'!"

!insertmacro PFI_LANG_STRING PFI_LANG_UN_MBEMAIL_1         "N�o foi poss�vel restaurar toda a configura��o original"
!insertmacro PFI_LANG_STRING PFI_LANG_UN_MBEMAIL_2         "Exibir o relat�rio de erros?"

!insertmacro PFI_LANG_STRING PFI_LANG_UN_MBRERUN_1         "Algumas configura��es do cliente de email n�o foram restauradas!"
!insertmacro PFI_LANG_STRING PFI_LANG_UN_MBRERUN_2         "(Detalhes podem ser encontrados na pasta $INSTDIR )"
!insertmacro PFI_LANG_STRING PFI_LANG_UN_MBRERUN_3         "Clique em 'N�o' para ignorar estes erros e deletar tudo"
!insertmacro PFI_LANG_STRING PFI_LANG_UN_MBRERUN_4         "Clique em 'Sim' para manter estes dados (para tentar outra vez mais tarde)"

!insertmacro PFI_LANG_STRING PFI_LANG_UN_MBREMDIR_2        "Voc� quer remover todos os arquivos do seu diret�rio 'User Data' do POPFile?${MB_NL}${MB_NL}$G_USERDIR${MB_NL}${MB_NL}(Se voc� tiver qualquer coisa que voc� criou e quer manter, clique em N�o)"

!insertmacro PFI_LANG_STRING PFI_LANG_UN_MBDELMSGS_1       "Voc� quer remover todos os arquivos do seu diret�rio 'Mensagens Recentes'?"

###########################################################################
###########################################################################

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; Corpus Conversion: Standard MUI Page - INSTFILES [MonitorCC.nsi]
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

!insertmacro PFI_LANG_STRING PFI_LANG_CONVERT_TITLE        "Convers�o do Corpus do POPFile"
!insertmacro PFI_LANG_STRING PFI_LANG_CONVERT_SUBTITLE     "O corpus existente deve ser convertido para funcionar com esta vers�o do POPFile"

!insertmacro PFI_LANG_STRING PFI_LANG_ENDCONVERT_TITLE     "Completada a Convers�o do Corpus do POPFile"
!insertmacro PFI_LANG_STRING PFI_LANG_ENDCONVERT_SUBTITLE  "Clique em Fechar para continuar"

!insertmacro PFI_LANG_STRING PFI_LANG_BADCONVERT_TITLE     "A Convers�o do Corpus do POPFile Falhou"
!insertmacro PFI_LANG_STRING PFI_LANG_BADCONVERT_SUBTITLE  "Clique em Cancelar para continuar"

!insertmacro PFI_LANG_STRING PFI_LANG_CONVERT_MUTEX        "Uma outra c�pia do 'Monitor de Convers�o do Corpus' j� est� rodando!"
!insertmacro PFI_LANG_STRING PFI_LANG_CONVERT_PRIVATE      "O 'Monitor de Convers�o do Corpus' � parte do instalador do POPFile"
!insertmacro PFI_LANG_STRING PFI_LANG_CONVERT_NOFILE       "Erro: o arquivo de dados da convers�o do Corpus n�o existe!"
!insertmacro PFI_LANG_STRING PFI_LANG_CONVERT_NOPOPFILE    "Erro: falta o caminho do POPFile"
!insertmacro PFI_LANG_STRING PFI_LANG_CONVERT_STARTERR     "Ocorreu um erro ao iniciar o processo de convers�o do corpus"
!insertmacro PFI_LANG_STRING PFI_LANG_CONVERT_FATALERR     "Ocorreu um erro fatal durante o processo de convers�o do corpus!"
!insertmacro PFI_LANG_STRING PFI_LANG_CONVERT_ESTIMATE     "Tempo restante estimado: "
!insertmacro PFI_LANG_STRING PFI_LANG_CONVERT_MINUTES      "minutos"
!insertmacro PFI_LANG_STRING PFI_LANG_CONVERT_WAITING      "(esperando pelo primeiro arquivo a ser convertido)"
!insertmacro PFI_LANG_STRING PFI_LANG_CONVERT_TOTALFILES   "Existem $G_BUCKET_COUNT arquivos de balde para serem convertidos"
!insertmacro PFI_LANG_STRING PFI_LANG_CONVERT_PROGRESS_N   "Depois de $G_ELAPSED_TIME.$G_DECPLACES minutos existem $G_STILL_TO_DO arquivos para converter"
!insertmacro PFI_LANG_STRING PFI_LANG_CONVERT_PROGRESS_1   "Depois de $G_ELAPSED_TIME.$G_DECPLACES minutos existe um arquivo para converter"
!insertmacro PFI_LANG_STRING PFI_LANG_CONVERT_SUMMARY      "A Convers�o do Corpus levou $G_ELAPSED_TIME.$G_DECPLACES minutos"

###########################################################################
###########################################################################

#--------------------------------------------------------------------------
# Mark the end of the language data
#--------------------------------------------------------------------------

!undef PFI_LANG

#--------------------------------------------------------------------------
# End of 'PortugueseBR-pfi.nsh'
#--------------------------------------------------------------------------
