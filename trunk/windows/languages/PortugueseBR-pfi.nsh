#--------------------------------------------------------------------------
# PortugueseBR-pfi.nsh
#
# This file contains the "PortugueseBR" text strings used by the Windows installer
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
# Translation created by: Adriano Rafael Gomes <adrianorg@users.sourceforge.net>
# Translation updated by: Adriano Rafael Gomes <adrianorg@users.sourceforge.net>
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

#==========================================================================
# Customised versions of strings used on standard MUI pages
#==========================================================================

#--------------------------------------------------------------------------
# Standard MUI Page - Welcome
#
# The sequence \r\n\r\n inserts a blank line (note that the PFI_LANG_WELCOME_INFO_TEXT string
# should end with a \r\n\r\n$_CLICK sequence).
#--------------------------------------------------------------------------

!insertmacro PFI_LANG_STRING PFI_LANG_WELCOME_INFO_TEXT \
"Este assistente te guiar� durante a instala��o do POPFile.\r\n\r\n� recomendado que voc� feche todas as outras aplica��es antes de iniciar a Instala��o.\r\n\r\n$_CLICK"

!insertmacro PFI_LANG_STRING PFI_LANG_WELCOME_ADMIN_TEXT \
"NOTA IMPORTANTE:\r\n\r\nO usu�rio corrente N�O tem direitos de 'Administrador'.\r\n\r\nSe suporte a multi-usu�rio � requerido, � recomendado que voc� cancele esta instala��o e use uma conta de 'Administrador' para instalar o POPFile."

#--------------------------------------------------------------------------
# Standard MUI Page - Finish
#
# The PFI_LANG_FINISH_RUN_TEXT text should be a short phrase (not a long paragraph)
#--------------------------------------------------------------------------

!insertmacro PFI_LANG_STRING PFI_LANG_FINISH_RUN_TEXT \
"Interface de Usu�rio do POPFile"

#==========================================================================
# Strings used for custom pages, message boxes and banners
#==========================================================================

#--------------------------------------------------------------------------
# General purpose banner text (also suitable for page titles/subtitles)
#--------------------------------------------------------------------------

!insertmacro PFI_LANG_STRING PFI_LANG_OPTIONS_BANNER_1    "Espere por favor."
!insertmacro PFI_LANG_STRING PFI_LANG_OPTIONS_BANNER_2    "Isto pode levar alguns segundos..."

#--------------------------------------------------------------------------
# Message box warning that a previous installation has been found
#--------------------------------------------------------------------------

!insertmacro PFI_LANG_STRING PFI_LANG_DIRSELECT_MBWARN_1  "Instala��o anterior encontrada em"
!insertmacro PFI_LANG_STRING PFI_LANG_DIRSELECT_MBWARN_2  "Voc� quer atualiz�-la?"

#--------------------------------------------------------------------------
# Startup message box offering to display the Release Notes
#--------------------------------------------------------------------------

!insertmacro PFI_LANG_STRING PFI_LANG_MBRELNOTES_1        "Exibir as Notas de Libera��o do POPFile ?"
!insertmacro PFI_LANG_STRING PFI_LANG_MBRELNOTES_2        "� recomendado responder Sim se voc� estiver atualizando o POPFile (pode ser necess�rio voc� fazer uma c�pia de seguran�a ANTES de atualizar)"

#--------------------------------------------------------------------------
# Custom Page - Check Perl Requirements
#--------------------------------------------------------------------------

; Page Title and Sub-title displayed in the page header

!insertmacro PFI_LANG_STRING PFI_LANG_PERLREQ_TITLE       "Detectados Componentes do Sistema Desatualizados"
!insertmacro PFI_LANG_STRING PFI_LANG_PERLREQ_SUBTITLE    "A vers�o do Perl usada pelo POPFile pode n�o funcionar corretamente neste sistema"

; Text strings displayed on the custom page

!insertmacro PFI_LANG_STRING PFI_LANG_PERLREQ_IO_TEXT_1   "Quando o POPFile exibir sua Interface de Usu�rio, o browser default corrente ser� usado.\r\n\r\nO POPFile n�o requer um browser espec�fico, ele funcionar� com praticamente qualquer browser.\r\n\r\nO POPFile � escrito em Perl, assim uma vers�o m�nima do Perl � instalada, a qual usa alguns componentes distribuidos com o Internet Explorer."
!insertmacro PFI_LANG_STRING PFI_LANG_PERLREQ_IO_TEXT_2   "O instalador detectou que este sistema tem o Internet Explorer"
!insertmacro PFI_LANG_STRING PFI_LANG_PERLREQ_IO_TEXT_3   "A vers�o de Perl fornecida com o POPFile requer o Internet Explorer 5.5 (ou mais atual).\r\n\r\n� recomendado que este sistema seja atualizado para usar o Internet Explorer 5.5 ou uma vers�o mais atual."

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

!insertmacro PFI_LANG_STRING PFI_LANG_OPTIONS_MBPOP3_1    "A porta POP3 n�o pode ser definida"
!insertmacro PFI_LANG_STRING PFI_LANG_OPTIONS_MBPOP3_2    "A porta deve ser um n�mero entre 1 e 65535."
!insertmacro PFI_LANG_STRING PFI_LANG_OPTIONS_MBPOP3_3    "Por favor altere sua sele��o de porta POP3."

!insertmacro PFI_LANG_STRING PFI_LANG_OPTIONS_MBGUI_1     "A porta 'Interface de Usu�rio' n�o pode ser definida"
!insertmacro PFI_LANG_STRING PFI_LANG_OPTIONS_MBGUI_2     "A porta deve ser um n�mero entre 1 e 65535."
!insertmacro PFI_LANG_STRING PFI_LANG_OPTIONS_MBGUI_3     "Por favor altere sua sele��o de porta para 'Interface de Usu�rio'."

!insertmacro PFI_LANG_STRING PFI_LANG_OPTIONS_MBDIFF_1    "A porta POP3 deve ser diferente da porta 'Interface de Usu�rio'."
!insertmacro PFI_LANG_STRING PFI_LANG_OPTIONS_MBDIFF_2    "Por favor altere sua sele��o de portas."

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

!insertmacro PFI_LANG_STRING PFI_LANG_MBMANSHUT_1         "Imposs�vel desligar o POPFile automaticamente."
!insertmacro PFI_LANG_STRING PFI_LANG_MBMANSHUT_2         "Por favor desligue o POPFile manualmente agora."
!insertmacro PFI_LANG_STRING PFI_LANG_MBMANSHUT_3         "Quando o POPFile tiver sido desligado, clique 'OK' para continuar."

!insertmacro PFI_LANG_STRING PFI_LANG_MBFFCERR_1          "Erro detectado quando o instalador tentou fazer o backup do corpus antigo."

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
# Custom Page - Email Client Reconfiguration
#--------------------------------------------------------------------------

; Page Title and Sub-title displayed in the page header

!insertmacro PFI_LANG_STRING PFI_LANG_MAILCFG_TITLE       "Configura��o do Cliente de Email"
!insertmacro PFI_LANG_STRING PFI_LANG_MAILCFG_SUBTITLE    "O POPFile pode reconfigurar v�rios clientes de email para voc�"

; Text displayed on the custom page

!insertmacro PFI_LANG_STRING PFI_LANG_MAILCFG_IO_TEXT_1   "Clientes de email marcados (*) podem ser reconfigurados automaticamente, assumindo que contas simples sejam usadas.\r\n\r\n� altamente recomendado que contas que requeiram autentica��o sejam configuradas manualmente."
!insertmacro PFI_LANG_STRING PFI_LANG_MAILCFG_IO_TEXT_2   "IMPORTANTE: POR FAVOR FECHE OS CLIENTES DE EMAIL RECONFIGUR�VEIS AGORA\r\n\r\nEsta caracter�stica ainda est� em desenvolvimento (algumas contas do Outlook podem n�o serem detectadas).\r\n\r\nPor favor verifique se a reconfigura��o foi bem sucedida (antes de usar o cliente de email)."

#--------------------------------------------------------------------------
# Message box warnings that an email client is still running
#--------------------------------------------------------------------------

!insertmacro PFI_LANG_STRING PFI_LANG_MBCLIENT_EXP        "AVISO: o Outlook Express parece estar rodando!"
!insertmacro PFI_LANG_STRING PFI_LANG_MBCLIENT_OUT        "AVISO: o Outlook parece estar rodando!"
!insertmacro PFI_LANG_STRING PFI_LANG_MBCLIENT_EUD        "AVISO: o Eudora parece estar rodando!"

!insertmacro PFI_LANG_STRING PFI_LANG_MBCLIENT_STOP_1     "Por favor FECHE o programa de email e clique 'Repetir' para reconfigur�-lo"
!insertmacro PFI_LANG_STRING PFI_LANG_MBCLIENT_STOP_2     "(Voc� pode clicar 'Ignorar' para reconfigur�-lo, mas isto n�o � recomendado)"
!insertmacro PFI_LANG_STRING PFI_LANG_MBCLIENT_STOP_3     "Clique 'Anular' para pular a reconfigura��o deste programa de email"

!insertmacro PFI_LANG_STRING PFI_LANG_MBCLIENT_STOP_4     "Por favor FECHE o programa de email e clique 'Repetir' para restaurar a configura��o"
!insertmacro PFI_LANG_STRING PFI_LANG_MBCLIENT_STOP_5     "(Voc� pode clicar 'Ignorar' para restaurar a configura��o, mas isto n�o � recomendado)"
!insertmacro PFI_LANG_STRING PFI_LANG_MBCLIENT_STOP_6     "Clique 'Anular' para pular a restaura��o da configura��o original"

#--------------------------------------------------------------------------
# Custom Page - Reconfigure Outlook/Outlook Express
#--------------------------------------------------------------------------

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
!insertmacro PFI_LANG_STRING PFI_LANG_OOECFG_IO_FOOTNOTE   "Marque a(s) caixa(s) para reconfigurar a(s) conta(s).\r\nSe voc� desinstalar o POPFile as configura��es originais ser�o restauradas."

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

#--------------------------------------------------------------------------
# Custom Page - Reconfigure Eudora
#--------------------------------------------------------------------------

; Page Title and Sub-title displayed in the page header

!insertmacro PFI_LANG_STRING PFI_LANG_EUCFG_TITLE         "Reconfigurar o Eudora"
!insertmacro PFI_LANG_STRING PFI_LANG_EUCFG_SUBTITLE      "O POPFile pode reconfigurar o Eudora para voc�"

; Text displayed on the custom page

!insertmacro PFI_LANG_STRING PFI_LANG_EUCFG_IO_CANCELLED  "Reconfigura��o do Eudora cancelada pelo usu�rio"

!insertmacro PFI_LANG_STRING PFI_LANG_EUCFG_IO_INTRO_1    "O POPFile detectou a seguinte personalidade do Eudora"
!insertmacro PFI_LANG_STRING PFI_LANG_EUCFG_IO_INTRO_2    " e pode automaticamente configur�-la para funcionar com o POPFile"
!insertmacro PFI_LANG_STRING PFI_LANG_EUCFG_IO_CHECKBOX   "Reconfigurar esta personalidade para funcionar com o POPFile"
!insertmacro PFI_LANG_STRING PFI_LANG_EUCFG_IO_DOMINANT   "Personalidade <dominante>"
!insertmacro PFI_LANG_STRING PFI_LANG_EUCFG_IO_PERSONA    "personalidade"
!insertmacro PFI_LANG_STRING PFI_LANG_EUCFG_IO_EMAIL      "Endere�o de email:"
!insertmacro PFI_LANG_STRING PFI_LANG_EUCFG_IO_SERVER     "Servidor POP3:"
!insertmacro PFI_LANG_STRING PFI_LANG_EUCFG_IO_USERNAME   "Nome de usu�rio POP3:"
!insertmacro PFI_LANG_STRING PFI_LANG_EUCFG_IO_POP3PORT   "Porta POP3:"
!insertmacro PFI_LANG_STRING PFI_LANG_EUCFG_IO_RESTORE    "Se voc� desinstalar o POPFile as configura��es originais ser�o restauradas"

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

!insertmacro PFI_LANG_STRING PFI_LANG_FLATFILE_TITLE       "Convers�o do Corpus do POPFile"
!insertmacro PFI_LANG_STRING PFI_LANG_FLATFILE_SUBTITLE    "O corpus existente deve ser convertido para funcionar com esta vers�o do POPFile"

; Text displayed on the custom page

!insertmacro PFI_LANG_STRING PFI_LANG_FLATFILE_IO_NOTE_1   "O POPFile ser� iniciado agora em uma janela de console para converter o corpus existente."
!insertmacro PFI_LANG_STRING PFI_LANG_FLATFILE_IO_NOTE_2   "ESTE PROCESSO PODE LEVAR V�RIOS MINUTOS (se o corpus for grande)."
!insertmacro PFI_LANG_STRING PFI_LANG_FLATFILE_IO_NOTE_3   "AVISO"
!insertmacro PFI_LANG_STRING PFI_LANG_FLATFILE_IO_NOTE_4   "N�O feche a janela de console do POPFile!"
!insertmacro PFI_LANG_STRING PFI_LANG_FLATFILE_IO_NOTE_5   "Quando aparecer 'POPFile Engine v${C_POPFILE_MAJOR_VERSION}.${C_POPFILE_MINOR_VERSION}.${C_POPFILE_REVISION} running' na janela de console, isto significa que"
!insertmacro PFI_LANG_STRING PFI_LANG_FLATFILE_IO_NOTE_6   "- O POPFile est� pronto para usar"
!insertmacro PFI_LANG_STRING PFI_LANG_FLATFILE_IO_NOTE_7   "- O POPFile pode ser desligado com seguran�a usando o Menu Iniciar"
!insertmacro PFI_LANG_STRING PFI_LANG_FLATFILE_IO_NOTE_8   "Clique Avan�ar para converter o corpus."

#--------------------------------------------------------------------------
# Standard MUI Page - Uninstall POPFile
#--------------------------------------------------------------------------

; Uninstall Progress Reports displayed above the progress bar

!insertmacro PFI_LANG_STRING PFI_LANG_UN_PROGRESS_1        "Desligando o POPFile..."
!insertmacro PFI_LANG_STRING PFI_LANG_UN_PROGRESS_2        "Deletando entradas no 'Menu Iniciar' para o POPFile..."
!insertmacro PFI_LANG_STRING PFI_LANG_UN_PROGRESS_3        "Deletando arquivos principais do POPFile..."
!insertmacro PFI_LANG_STRING PFI_LANG_UN_PROGRESS_4        "Restaurando configura��es do Outlook Express..."
!insertmacro PFI_LANG_STRING PFI_LANG_UN_PROGRESS_5        "Deletando arquivos de skins do POPFile..."
!insertmacro PFI_LANG_STRING PFI_LANG_UN_PROGRESS_6        "Deletando arquivos m�nimos do Perl..."
!insertmacro PFI_LANG_STRING PFI_LANG_UN_PROGRESS_7        "Restaurando configura��es do Outlook..."
!insertmacro PFI_LANG_STRING PFI_LANG_UN_PROGRESS_8        "Restaurando configura��es do Eudora..."

; Uninstall Log Messages

!insertmacro PFI_LANG_STRING PFI_LANG_UN_LOG_1             "Desligando o POPFile usando a porta"
!insertmacro PFI_LANG_STRING PFI_LANG_UN_LOG_2             "Aberto"
!insertmacro PFI_LANG_STRING PFI_LANG_UN_LOG_3             "Restaurado"
!insertmacro PFI_LANG_STRING PFI_LANG_UN_LOG_4             "Fechado"
!insertmacro PFI_LANG_STRING PFI_LANG_UN_LOG_5             "Removendo todos os arquivos da pasta do POPFile"
!insertmacro PFI_LANG_STRING PFI_LANG_UN_LOG_6             "Nota: imposs�vel remover todos os arquivos da pasta do POPFile"

; Message Box text strings

!insertmacro PFI_LANG_STRING PFI_LANG_UN_MBNOTFOUND_1      "N�o parece que o POPFile esteja instalado nesta pasta"
!insertmacro PFI_LANG_STRING PFI_LANG_UN_MBNOTFOUND_2      "Continuar mesmo assim (n�o recomendado) ?"

!insertmacro PFI_LANG_STRING PFI_LANG_UN_ABORT_1           "Desinstala��o cancelada pelo usu�rio"

!insertmacro PFI_LANG_STRING PFI_LANG_UN_MBREMDIR_1        "Voc� quer remover todos os arquivos da sua pasta do POPFile ?$\r$\n$\r$\n(Se voc� tiver qualquer coisa que voc� criou e quer manter, clique N�o)"

!insertmacro PFI_LANG_STRING PFI_LANG_UN_MBREMERR_1        "Nota"
!insertmacro PFI_LANG_STRING PFI_LANG_UN_MBREMERR_2        "n�o pode ser removido."

#--------------------------------------------------------------------------
# Mark the end of the language data
#--------------------------------------------------------------------------

!undef PFI_LANG

#--------------------------------------------------------------------------
# End of 'PortugueseBR-pfi.nsh'
#--------------------------------------------------------------------------
