#--------------------------------------------------------------------------
# PortugueseBR-pfi.nsh
#
# Translated by Adriano Rafael Gomes <adrianorg@users.sourceforge.net>
#
# This file contains additional "PortugueseBR" text strings used by the Windows installer
# for POPFile (these strings are unique to POPFile).
#
# See 'PortugueseBR-mui.nsh' for the strings which modify standard NSIS MUI messages.
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

!define PFI_LANG  "PORTUGUESEBR"

#--------------------------------------------------------------------------
# Startup message box offering to display the Release Notes
#--------------------------------------------------------------------------

!insertmacro PFI_LANG_STRING PFI_LANG_MBRELNOTES_1        "Exibir as Notas de Libera��o do POPFile ?"
!insertmacro PFI_LANG_STRING PFI_LANG_MBRELNOTES_2        "� recomendado responder Sim se voc� estiver atualizando o POPFile (pode ser necess�rio voc� fazer uma c�pia de seguran�a ANTES de atualizar)"

#--------------------------------------------------------------------------
# Standard MUI Page - Choose Components
#--------------------------------------------------------------------------

!insertmacro PFI_LANG_STRING DESC_SecPOPFile              "Instala os arquivos principais necess�rios para o POPFile, incluindo uma vers�o m�nima do Perl."
!insertmacro PFI_LANG_STRING DESC_SecSkins                "Instala skins do POPFile que permitem a voc� trocar a apar�ncia da interface de usu�rio do POPFile."
!insertmacro PFI_LANG_STRING DESC_SecLangs                "Instala vers�es da interface de usu�rio em outras l�nguas."

#--------------------------------------------------------------------------
# Custom Page - POPFile Installation Options
#--------------------------------------------------------------------------

; Page Title and Sub-title displayed in the page header

!insertmacro PFI_LANG_STRING PFI_LANG_OPTIONS_TITLE       "Op��es de Instala��o do POPFile"
!insertmacro PFI_LANG_STRING PFI_LANG_OPTIONS_SUBTITLE    "N�o altere estas op��es a menos que voc� precise realmente mud�-las"

; Text strings displayed on the custom page

!insertmacro PFI_LANG_STRING PFI_LANG_OPTIONS_IO_POP3     "Escolha a porta padr�o para conex�es POP3 (recomendado 110)"
!insertmacro PFI_LANG_STRING PFI_LANG_OPTIONS_IO_GUI      "Escolha a porta padr�o para conex�es da 'Interface de Usu�rio' (recomendado 8080)"
!insertmacro PFI_LANG_STRING PFI_LANG_OPTIONS_IO_STARTUP  "Executar o POPFile automaticamente quando o Windows iniciar"
!insertmacro PFI_LANG_STRING PFI_LANG_OPTIONS_IO_WARNING  "AVISO IMPORTANTE"
!insertmacro PFI_LANG_STRING PFI_LANG_OPTIONS_IO_MESSAGE  "SE ESTIVER ATUALIZANDO O POPFILE --- O INSTALADOR VAI DESLIGAR A VERS�O EXISTENTE"

; Message Boxes used when validating user's selections

!insertmacro PFI_LANG_STRING PFI_LANG_OPTIONS_MBUNINST_1    "Instala��o anterior encontrada em"
!insertmacro PFI_LANG_STRING PFI_LANG_OPTIONS_MBUNINST_2    "Voc� quer desinstalar ?"
!insertmacro PFI_LANG_STRING PFI_LANG_OPTIONS_MBUNINST_3    "'Sim' recomendado"

!insertmacro PFI_LANG_STRING PFI_LANG_OPTIONS_MBPOP3_1    "A porta POP3 n�o pode ser definida"
!insertmacro PFI_LANG_STRING PFI_LANG_OPTIONS_MBPOP3_2    "A porta deve ser um n�mero entre 1 e 65535."
!insertmacro PFI_LANG_STRING PFI_LANG_OPTIONS_MBPOP3_3    "Por favor altere sua sele��o de porta POP3."

!insertmacro PFI_LANG_STRING PFI_LANG_OPTIONS_MBGUI_1     "A porta 'Interface de Usu�rio' n�o pode ser definida"
!insertmacro PFI_LANG_STRING PFI_LANG_OPTIONS_MBGUI_2     "A porta deve ser um n�mero entre 1 e 65535."
!insertmacro PFI_LANG_STRING PFI_LANG_OPTIONS_MBGUI_3     "Por favor altere sua sele��o de porta para 'Interface de Usu�rio'."

!insertmacro PFI_LANG_STRING PFI_LANG_OPTIONS_MBDIFF_1    "A porta POP3 deve ser diferente da porta 'Interface de Usu�rio'."
!insertmacro PFI_LANG_STRING PFI_LANG_OPTIONS_MBDIFF_2    "Por favor altere sua sele��o de portas."

; Banner message displayed whilst uninstalling old version

!insertmacro PFI_LANG_STRING PFI_LANG_OPTIONS_BANNER_1     "Espere por favor."
!insertmacro PFI_LANG_STRING PFI_LANG_OPTIONS_BANNER_2     "Isto pode levar alguns segundos..."

#--------------------------------------------------------------------------
# Standard MUI Page - Installing POPfile
#--------------------------------------------------------------------------

; Installation Progress Reports displayed above the progress bar

!insertmacro PFI_LANG_STRING PFI_LANG_INST_PROG_UPGRADE   "Verificando se esta � uma instala��o para atualiza��o..."
!insertmacro PFI_LANG_STRING PFI_LANG_INST_PROG_CORE      "Instalando os arquivos principais do POPFile..."
!insertmacro PFI_LANG_STRING PFI_LANG_INST_PROG_PERL      "Instalando os arquivos m�nimos do Perl..."
!insertmacro PFI_LANG_STRING PFI_LANG_INST_PROG_SHORT     "Criando os atalhos do POPFile..."
!insertmacro PFI_LANG_STRING PFI_LANG_INST_PROG_FFCBACK   "Fazendo o backup do corpus. Isto pode levar alguns segundos..."
!insertmacro PFI_LANG_STRING PFI_LANG_INST_PROG_SKINS     "Instalando os arquivos de skins do POPFile..."
!insertmacro PFI_LANG_STRING PFI_LANG_INST_PROG_LANGS     "Instalando os arquivos de l�nguas do POPFile..."
!insertmacro PFI_LANG_STRING PFI_LANG_INST_PROG_ENDSEC    "Clique em Avan�ar para continuar"

; Installation Log Messages

!insertmacro PFI_LANG_STRING PFI_LANG_INST_LOG_1          "Desligando a vers�o anterior do POPFile usando a porta"

; Message Box text strings

!insertmacro PFI_LANG_STRING PFI_LANG_MBSTPWDS_1          "encontrado arquivo de uma instala��o anterior."
!insertmacro PFI_LANG_STRING PFI_LANG_MBSTPWDS_2          "Atualizar este arquivo ?"
!insertmacro PFI_LANG_STRING PFI_LANG_MBSTPWDS_3          "Clique 'Sim' para atualizar (o arquivo antigo ser� salvo como"
!insertmacro PFI_LANG_STRING PFI_LANG_MBSTPWDS_4          "Clique 'N�o' para manter o arquivo antigo (o arquivo novo ser� salvo como"

!insertmacro PFI_LANG_STRING PFI_LANG_MBCFGBK_1           "C�pia de seguran�a de"
!insertmacro PFI_LANG_STRING PFI_LANG_MBCFGBK_2           "j� existe"
!insertmacro PFI_LANG_STRING PFI_LANG_MBCFGBK_3           "Sobrescrever este arquivo ?"
!insertmacro PFI_LANG_STRING PFI_LANG_MBCFGBK_4           "Clique 'Sim' para sobrescrever, clique 'N�o' para pular fazendo uma c�pia de seguran�a"

!insertmacro PFI_LANG_STRING PFI_LANG_MBMANSHUT_1         "Unable to shutdown POPFile automatically."
!insertmacro PFI_LANG_STRING PFI_LANG_MBMANSHUT_2         "Please shutdown POPFile manually now."
!insertmacro PFI_LANG_STRING PFI_LANG_MBMANSHUT_3         "When POPFile has been shutdown, click 'OK' to continue."

!insertmacro PFI_LANG_STRING PFI_LANG_MBFFCERR_1          "Error detected when the installer tried to backup the old corpus."

#--------------------------------------------------------------------------
# Custom Page - POPFile Classification Bucket Creation
#--------------------------------------------------------------------------

; Page Title and Sub-title displayed in the page header

!insertmacro PFI_LANG_STRING PFI_LANG_CBP_TITLE           "Cria��o de Balde de Classifica��o do POPFile"
!insertmacro PFI_LANG_STRING PFI_LANG_CBP_SUBTITLE        "O POPFile precisa PELO MENOS DOIS baldes para poder classificar seus emails"

; Text strings displayed on the custom page

!insertmacro PFI_LANG_STRING PFI_LANG_CBP_IO_INTRO        "Depois da instala��o, o POPFile torna f�cil alterar o n�mero de baldes (e seus nomes) para satisfazer suas necessidades.\r\n\r\nOs nomes dos baldes devem ser palavras �nicas, usando letras min�sculas, d�gitos de 0 a 9, h�fens e sublinhados."
!insertmacro PFI_LANG_STRING PFI_LANG_CBP_IO_CREATE       "Crie um novo balde selecionando um nome da lista abaixo ou digitando um nome de sua escolha."
!insertmacro PFI_LANG_STRING PFI_LANG_CBP_IO_DELETE       "Para deletar um ou mais baldes da lista, marque a(s) caixa(s) 'Remover' relevante(s) e clique no bot�o 'Continuar'."
!insertmacro PFI_LANG_STRING PFI_LANG_CBP_IO_LISTHDR      "Baldes a serem usados pelo POPFile"
!insertmacro PFI_LANG_STRING PFI_LANG_CBP_IO_REMOVE       "Remover"
!insertmacro PFI_LANG_STRING PFI_LANG_CBP_IO_CONTINUE     "Continuar"

; Text strings used for status messages under the bucket list

!insertmacro PFI_LANG_STRING PFI_LANG_CBP_IO_MSG_1        "N�o � necess�rio adicionar mais nenhum balde"
!insertmacro PFI_LANG_STRING PFI_LANG_CBP_IO_MSG_2        "Voc� deve definir PELO MENOS DOIS baldes"
!insertmacro PFI_LANG_STRING PFI_LANG_CBP_IO_MSG_3        "Pelo menos mais um balde � requerido"
!insertmacro PFI_LANG_STRING PFI_LANG_CBP_IO_MSG_4        "O instalador n�o pode criar mais que"
!insertmacro PFI_LANG_STRING PFI_LANG_CBP_IO_MSG_5        "baldes"

; Message box text strings

!insertmacro PFI_LANG_STRING PFI_LANG_CBP_MBDUPERR_1      "Um balde chamado"
!insertmacro PFI_LANG_STRING PFI_LANG_CBP_MBDUPERR_2      "j� foi definido."
!insertmacro PFI_LANG_STRING PFI_LANG_CBP_MBDUPERR_3      "Por favor escolha um nome diferente para o novo balde."

!insertmacro PFI_LANG_STRING PFI_LANG_CBP_MBMAXERR_1      "O instalador pode somente criar at�"
!insertmacro PFI_LANG_STRING PFI_LANG_CBP_MBMAXERR_2      "baldes."
!insertmacro PFI_LANG_STRING PFI_LANG_CBP_MBMAXERR_3      "Uma vez que o POPFile tenha sido instalado, voc� poder� criar mais que"

!insertmacro PFI_LANG_STRING PFI_LANG_CBP_MBNAMERR_1      "O nome"
!insertmacro PFI_LANG_STRING PFI_LANG_CBP_MBNAMERR_2      "n�o � um nome v�lido para um balde."
!insertmacro PFI_LANG_STRING PFI_LANG_CBP_MBNAMERR_3      "Nomes de balde somente podem conter as letras de a at� z min�sculas, n�meros de 0 a 9, mais - e _"
!insertmacro PFI_LANG_STRING PFI_LANG_CBP_MBNAMERR_4      "Por favor escolha um nome diferente para o novo balde."

!insertmacro PFI_LANG_STRING PFI_LANG_CBP_MBCONTERR_1     "O POPFile requer PELO MENOS DOIS baldes para poder classificar seus emails."
!insertmacro PFI_LANG_STRING PFI_LANG_CBP_MBCONTERR_2     "Por favor entre o nome de um balde para ser criado,$\r$\n$\r$\nescolhendo um nome sugerido da lista$\r$\n$\r$\nou digitando um nome de sua escolha."
!insertmacro PFI_LANG_STRING PFI_LANG_CBP_MBCONTERR_3     "Voc� deve definir PELO MENOS DOIS baldes antes de continuar sua instala��o do POPFile."

!insertmacro PFI_LANG_STRING PFI_LANG_CBP_MBDONE_1        "baldes foram definidos para uso do POPFile."
!insertmacro PFI_LANG_STRING PFI_LANG_CBP_MBDONE_2        "Voc� quer configurar o POPFile para usar estes baldes ?"
!insertmacro PFI_LANG_STRING PFI_LANG_CBP_MBDONE_3        "Clique 'N�o' se voc� quer alterar sua sele��o de baldes."

!insertmacro PFI_LANG_STRING PFI_LANG_CBP_MBMAKERR_1      "O instalador n�o foi capaz de criar"
!insertmacro PFI_LANG_STRING PFI_LANG_CBP_MBMAKERR_2      "de"
!insertmacro PFI_LANG_STRING PFI_LANG_CBP_MBMAKERR_3      "baldes que voc� selecionou."
!insertmacro PFI_LANG_STRING PFI_LANG_CBP_MBMAKERR_4      "Uma vez que o POPFile tenha sido instalado, voc� pode usar seu pain�l de controle$\r$\n$\r$\n na 'Interface de Usu�rio' para criar o(s) balde(s) que faltar(em)."

#--------------------------------------------------------------------------
# Custom Page - Reconfigure Outlook Express
#--------------------------------------------------------------------------

; Page Title and Sub-title displayed in the page header

!insertmacro PFI_LANG_STRING PFI_LANG_OECFG_TITLE         "Reconfigurar o Outlook Express"
!insertmacro PFI_LANG_STRING PFI_LANG_OECFG_SUBTITLE      "O POPFile pode reconfigurar o Outlook Express para voc�"

; Text displayed on the custom page

!insertmacro PFI_LANG_STRING PFI_LANG_OECFG_IO_INTRO      "O POPFile detectou a seguinte conta de email do Outlook Express e pode automaticamente configur�-la para funcionar com o POPFile"
!insertmacro PFI_LANG_STRING PFI_LANG_OECFG_IO_CHECKBOX   "Reconfigurar esta conta para funcionar com o POPFile"
!insertmacro PFI_LANG_STRING PFI_LANG_OECFG_IO_EMAIL      "Endere�o de email:"
!insertmacro PFI_LANG_STRING PFI_LANG_OECFG_IO_SERVER     "Servidor POP3:"
!insertmacro PFI_LANG_STRING PFI_LANG_OECFG_IO_USERNAME   "Nome de usu�rio POP3:"
!insertmacro PFI_LANG_STRING PFI_LANG_OECFG_IO_RESTORE    "Se voc� desinstalar o POPFile as configura��es originais ser�o restauradas"

!insertmacro PFI_LANG_STRING PFI_LANG_OECFG_IO_LINK_1     "conta para a"
!insertmacro PFI_LANG_STRING PFI_LANG_OECFG_IO_LINK_2     "identidade"

#--------------------------------------------------------------------------
# Custom Page - POPFile can now be started
#--------------------------------------------------------------------------

; Page Title and Sub-title displayed in the page header

!insertmacro PFI_LANG_STRING PFI_LANG_LAUNCH_TITLE        "O POPFile pode ser iniciado agora"
!insertmacro PFI_LANG_STRING PFI_LANG_LAUNCH_SUBTITLE     "A Interface de Usu�rio do POPFile somente funciona se o POPFile tiver sido iniciado"

; Text displayed on the custom page

!insertmacro PFI_LANG_STRING PFI_LANG_LAUNCH_IO_INTRO     "Iniciar o POPFile agora ?"
!insertmacro PFI_LANG_STRING PFI_LANG_LAUNCH_IO_NO        "N�o (a 'Interface de Usu�rio' n�o pode ser usada se o POPFile n�o for iniciado)"
!insertmacro PFI_LANG_STRING PFI_LANG_LAUNCH_IO_DOSBOX    "Executar o POPFile (em uma janela)"
!insertmacro PFI_LANG_STRING PFI_LANG_LAUNCH_IO_BCKGRND   "Executar o POPFile em segundo plano (nenhuma janela � exibida)"
!insertmacro PFI_LANG_STRING PFI_LANG_LAUNCH_IO_NOTE_1    "Uma vez que o POPFile tenha sido iniciado, voc� pode exibir a 'Interface de Usu�rio'"
!insertmacro PFI_LANG_STRING PFI_LANG_LAUNCH_IO_NOTE_2    "(a) dando um duplo-clique no �cone do POPFile na bandeja do sistema,   OU"
!insertmacro PFI_LANG_STRING PFI_LANG_LAUNCH_IO_NOTE_3    "(b) usando Iniciar --> Programas --> POPFile --> Interface de Usu�rio do POPFile."

; Banner message displayed whilst waiting for POPFile to start

!insertmacro PFI_LANG_STRING PFI_LANG_LAUNCH_BANNER_1     "Preparando para iniciar o POPFile."
!insertmacro PFI_LANG_STRING PFI_LANG_LAUNCH_BANNER_2     "Isto pode levar alguns segundos..."

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
!insertmacro PFI_LANG_STRING PFI_LANG_FLATFILE_IO_NOTE_8   "Click Next to convert the corpus."

#--------------------------------------------------------------------------
# Standard MUI Page - Uninstall POPFile
#--------------------------------------------------------------------------

; Uninstall Progress Reports displayed above the progress bar

!insertmacro PFI_LANG_UNSTRING PFI_LANG_PROGRESS_1        "Desligando o POPFile..."
!insertmacro PFI_LANG_UNSTRING PFI_LANG_PROGRESS_2        "Deletando entradas no 'Menu Iniciar' para o POPFile..."
!insertmacro PFI_LANG_UNSTRING PFI_LANG_PROGRESS_3        "Deletando arquivos principais do POPFile..."
!insertmacro PFI_LANG_UNSTRING PFI_LANG_PROGRESS_4        "Restaurando configura��es do Outlook Express..."
!insertmacro PFI_LANG_UNSTRING PFI_LANG_PROGRESS_5        "Deletando arquivos de skins do POPFile..."
!insertmacro PFI_LANG_UNSTRING PFI_LANG_PROGRESS_6        "Deletando arquivos m�nimos do Perl..."

; Uninstall Log Messages

!insertmacro PFI_LANG_UNSTRING PFI_LANG_LOG_1             "Desligando o POPFile usando a porta"
!insertmacro PFI_LANG_UNSTRING PFI_LANG_LOG_2             "Aberto"
!insertmacro PFI_LANG_UNSTRING PFI_LANG_LOG_3             "Restaurado"
!insertmacro PFI_LANG_UNSTRING PFI_LANG_LOG_4             "Fechado"
!insertmacro PFI_LANG_UNSTRING PFI_LANG_LOG_5             "Removendo todos os arquivos da pasta do POPFile"
!insertmacro PFI_LANG_UNSTRING PFI_LANG_LOG_6             "Nota: imposs�vel remover todos os arquivos da pasta do POPFile"

; Message Box text strings

!insertmacro PFI_LANG_UNSTRING PFI_LANG_MBNOTFOUND_1      "N�o parece que o POPFile esteja instalado nesta pasta"
!insertmacro PFI_LANG_UNSTRING PFI_LANG_MBNOTFOUND_2      "Continuar mesmo assim (n�o recomendado) ?"

!insertmacro PFI_LANG_UNSTRING PFI_LANG_ABORT_1           "Desinstala��o cancelada pelo usu�rio"

!insertmacro PFI_LANG_UNSTRING PFI_LANG_MBREMDIR_1        "Voc� quer remover todos os arquivos da sua pasta do POPFile ?$\r$\n$\r$\n(Se voc� tiver qualquer coisa que voc� criou e quer manter, clique N�o)"

!insertmacro PFI_LANG_UNSTRING PFI_LANG_MBREMERR_1        "Nota"
!insertmacro PFI_LANG_UNSTRING PFI_LANG_MBREMERR_2        "n�o pode ser removido."

#--------------------------------------------------------------------------
# Mark the end of the language data
#--------------------------------------------------------------------------

!undef PFI_LANG

#--------------------------------------------------------------------------
# End of 'PortugueseBR-pfi.nsh'
#--------------------------------------------------------------------------
