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

# Identify the language and character set used for the interface
LanguageCode                            pt
LanguageCharset                         ISO-8859-1
LanguageDirection                       ltr

# This is used to get the appropriate subdirectory for the manual
ManualLanguage                          br
 
# Common words that are used on their own all over the interface
Apply                                   Aplicar
On                                      Ligado
Off                                     Desligado
TurnOn                                  Ligar
TurnOff                                 Desligar
Add                                     Adicionar
Remove                                  Remover
Previous                                Anterior
Next                                    Seguinte
From                                    Originador
Subject                                 Assunto
Cc                                      Cc
Classification                          Classifica��o
Reclassify                              Reclassificar
Undo                                    Desfazer
Close                                   Fechar
Find                                    Procurar
Filter                                  Filtrar
Yes                                     Sim
No                                      N�o
ChangeToYes                             Alterar para Sim
ChangeToNo                              Alterar para N�o
Bucket                                  Recept�culo
Magnet                                  �man
Delete                                  Apagar
Create                                  Criar
To                                      Para
Total                                   Total
Rename                                  Renomear
Frequency                               Frequ�ncia
Probability                             Probabilidade
Score                                   Pontua��o
Lookup                                  Procurar
Refresh                                 Refrescar
Word                                    Palavra
Update                                  Actualizar
Count                                   Ocorr�ncias
Scores                                  Classifica��es
QuickMagnets                             Criar �man


View_Title                              Detalhes da mensagem

# The header and footer that appear on every UI page
Header_Title                            Centro de Controle POPFile
Header_Shutdown                         Desligar POPFile
Header_History                          Hist�rico
Header_Buckets                          Recept�culos
Header_Configuration                    Configura��o
Header_Advanced                         Avan�ado
Header_Security                         Seguran�a
Header_Magnets                          �mans

Footer_HomePage                         POPFile na internet
Footer_Manual                           Manual
Footer_Forums                           F�rums
Footer_FeedMe                           Doa��es
Footer_RequestFeature                   Pedir uma funcionalidade
Footer_MailingList                      Lista de Email

Configuration_Error1                    O caracter separador deve ser um �nico caracter
Configuration_Error2                    O porta da interface do utilizador deve ser um n�mero entre 1 e 65535
Configuration_Error3                    A porta de escuta POP3 deve ser um n�mero entre 1 e 65535
Configuration_Error4                    O tamanho da p�gina deve ser um n�mero entre 1 e 1000
Configuration_Error5                    O n�mero de dias no hist�rico deve ser um n�mero entre 1 e 366
Configuration_Error6                    O tempo limite TCP deve ser um n�mero entre 10 e 300
Configuration_Error7                    A porta de escuta XML RPC deve ser um n�mero entre 1 e 65535
Configuration_POP3Port                  Porta de escuta POP3
Configuration_POP3Update                Alterada a porta para %s; esta altera��o n�o ter� efeito at� que voc� reinicie o POPFile
Configuration_NNTPPort                  Porta de escuta NNTP
Configuration_NNTPUpdate                Alterada a porta NNTP para %s; esta altera��o n�o ter� efeito at� que voc� reinicie o POPFile
Configuration_SMTPPort                  Porta de escuta SMTP
Configuration_SMTPUpdate                Alterada a porta SMTP para %s; esta altera��o n�o ter� efeito at� que voc� reinicie o POPFile
Configuration_XMLRPCPort                Porta de escuta XML RPC
Configuration_XMLRPCUpdate              Alterada a porta XML RPC para %s; esta altera��o n�o ter� efeito at� que voc� reinicie o POPFile
Configuration_POP3Separator             Caracter separador POP3 (host:port:user)
Configuration_NNTPSeparator             Caracter separador NNTP (host:port:user)
Configuration_POP3SepUpdate             Alterado o separador POP3 para %s
Configuration_NNTPSepUpdate             Alterado o separador NNTP para %s
Configuration_UI                        Porta da interface do utilizador (web)
Configuration_UIUpdate                  Alterada a porta da interface web do utilizador para %s; esta altera��o n�o ter� efeito at� que voc� reinicie o POPFile
Configuration_History                   N�mero de emails por p�gina
Configuration_HistoryUpdate             Alterado o n�mero de emails por p�gina para %s
Configuration_Days                      N�mero de dias para manter no hist�rico
Configuration_DaysUpdate                Alterado o n�mero de dias para manter no hist�rico para %s
Configuration_UserInterface             Interface do Utilizador
Configuration_Skins                     Aspecto
Configuration_SkinsChoose               Escolha o aspecto
Configuration_Language                  L�ngua
Configuration_LanguageChoose            Escolha a l�ngua
Configuration_ListenPorts               Portas de Escuta
Configuration_HistoryView               Exibir Hist�rico
Configuration_TCPTimeout                Tempo Limite de Conex�o TCP
Configuration_TCPTimeoutSecs            Tempo limite de conex�o TCP em segundos
Configuration_TCPTimeoutUpdate          Alterado o tempo limite de conex�o TCP para %s
Configuration_ClassificationInsertion   Inser��o de Classifica��o
Configuration_SubjectLine               Modifica��o do assunto
Configuration_XTCInsertion              Inser��o de X-Text-Classification
Configuration_XPLInsertion              Inser��o de X-POPFile-Link
Configuration_Logging                   Registo de actividade
Configuration_None                      em nenhum lado
Configuration_ToScreen                  no ecr�
Configuration_ToFile                    num ficheiro
Configuration_ToScreenFile              no ecr�n e num ficheiro
Configuration_LoggerOutput              Registar actividade
Configuration_GeneralSkins              Aspecto normal
Configuration_SmallSkins                Aspecto pequeno
Configuration_TinySkins                 Aspecto min�sculo
Configuration_CurrentLogFile            &lt;registo de actividade actual&gt;

Advanced_Error1                         '%s' j� est� na lista de palavras ignoradas
Advanced_Error2                         Palavras ignoradas podem somente conter caracteres alfanum�ricos, ., _, -, ou @
Advanced_Error3                         '%s' adicionado na lista de palavras ignoradas
Advanced_Error4                         '%s' n�o est� na lista de palavras ignoradas
Advanced_Error5                         '%s' removido da lista de palavras ignoradas
Advanced_StopWords                      Palavras Ignoradas
Advanced_Message1                       As seguintes palavras s�o ignoradas de todas as classifica��es porque ocorrem muito frequentemente.
Advanced_AddWord                        Adicionar palavra
Advanced_RemoveWord                     Remover palavra

History_Filter                          &nbsp;(apenas mostrando o recept�culo <font color="%s">%s</font>)
History_FilterBy                        Filtrar por
History_ResetSearch                     Mostar todos
History_Search                          &nbsp;(procurar pelo assunto %s)
History_Title                           Mensagens Recentes
History_Jump                            Ir para a mensagem
History_ShowAll                         Exibir Tudo
History_ShouldBe                        Deveria ser
History_NoFrom                          sem originador
History_NoSubject                       sem assunto
History_ClassifyAs                      Classificar como
History_MagnetUsed                      �man usado
History_MagnetBecause                   <b>�man usado</b><p>Classificado em <font color="%s">%s</font> por causa do �man %s </p>
History_ChangedTo                       Alterado para <font color="%s">%s
History_Already                         J� reclassificado como <font color="%s">%s</font>
History_RemoveAll                       Remover Tudo
History_RemovePage                      Remover esta P�gina
History_Remove                          Para remover entradas do hist�rico use
History_SearchMessage                   Procurar Assunto
History_NoMessages                      Nenhuma mensagem
History_ShowMagnet                      Magnetizadas
History_ShowNoMagnet                    N�o magnetizadas
History_Magnet                          &nbsp;(mensagens classificadas por �man)
History_NoMagnet                        &nbsp;(mensagens n�o classificadas por �man)

Password_Title                          Senha
Password_Enter                          Digite a senha
Password_Go                             Entrar!
Password_Error1                         Senha incorreta

Security_Error1                         A porta segura deve ser um n�mero entre 1 e 65535
Security_Stealth                        Modo Stealth/Opera��o Servidor
Security_NoStealthMode                  N�o (Modo Stealth)
Security_ExplainStats                   (Com isto ligado o POPFile envia uma vez por dia os seguintes tr�s valores para um script em www.usethesource.com: bc (o n�mero total de recept�culos que voc� tem), mc (o n�mero total de mensagens que o POPFile classificou) e ec (o n�mero total de erros de classifica��o).  Isto fica guardado num arquivo que eu vou usar para publicar algumas estat�sticas sobre como as pessoas usam o POPFile e o qu�o bem ele funciona.  O meu servidor web mant�m o seus arquivos de log por mais ou menos 5 dias antes de os apagar; Eu n�o guardo nenhuma liga��o entre as estat�stcas e os endere�os IP de cada um.)
Security_ExplainUpdate                  (Com isto ligado o POPFile envia uma vez por dia os seguintes tr�s valores para um script em www.usethesource.com: ma (o n�mero maior da vers�o do seu POPFile), mi (o n�mero menor da vers�o do seu POPFile) and bn (o n�mero do build da sua vers�o do POPFile). O POPFile recebe uma resposta na forma de um gr�fico que aparece no topo da p�gina se uma nova vers�o estiver dispon�vel.  Meu servidor web mant�m seus arquivos de log por mais ou menos 5 antes de os apagar; Eu n�o guardo nenhuma liga��o entre as verifica��es de vers�o e os endere�os IP de cada um.)
Security_PasswordTitle                  Senha da Interface de utilizador
Security_Password                       Senha
Security_PasswordUpdate                 Alterada a senha para %s
Security_AUTHTitle                      Autentica��o Segura de Senha/AUTH
Security_SecureServer                   Servidor Seguro
Security_SecureServerUpdate             Alterado o servidor seguro para %s; esta altera��o n�o ter� efeito at� que voc� reinicie o POPFile
Security_SecurePort                     Porta segura
Security_SecurePortUpdate               Alterada a porta para %s; esta altera��o n�o ter� efeito at� que voc� reinicie o POPFile
Security_SMTPServer                     Servidor SMTP real
Security_SMTPServerUpdate               Alterado o servidor SMTP real para %s; esta altera��o n�o ter� efeito at� que voc� reinicie o POPFile
Security_SMTPPort                       Porta do servidor SMTP real
Security_SMTPPortUpdate                 Alterada a porta do servidor SMTP real para %s; esta altera��o n�o ter� efeito at� que voc� reinicie o POPFile
Security_POP3                           Aceitar conex�es POP3 de m�quinas remotas
Security_NNTP                           Aceitar conex�es NNTP de m�quinas remotas
Security_XMLRPC                         Aceitar conex�es XMLRPC de m�quinas remotas
Security_SMTP                           Aceitar conex�es SMTP de m�quinas remotas
Security_UI                             Aceitar conex�es HTTP (Interface de utilizador) de m�quinas remotas
Security_UpdateTitle                    Verifica��o Autom�tica de Atualiza��es
Security_Update                         Verificar diariamente atualiza��es para o POPFile
Security_StatsTitle                     Reportar Estat�sticas
Security_Stats                          Enviar estat�sticas para o John diariamente

Magnet_Error1                           �man '%s' j� existe no recept�culo '%s'
Magnet_Error2                           O novo �man '%s' colide com o �man '%s' no recept�culo '%s' e pode causar resultados amb�guos.  O novo �man n�o foi adicionado.
Magnet_Error3                           Criar novo �man '%s' no recept�culo '%s'
Magnet_CurrentMagnets                   �mans Actuais
Magnet_Message1                         Os seguintes �mans atraem as mensagens para recept�culo especificado.
Magnet_CreateNew                        Criar Novo �man
Magnet_Explanation                      Tr�s tipos de �man est�o dispon�veis: <ul><li>De um endere�o ou nome:</b> Por exemplo: adriano@companhia.com para apanhar um endere�o espec�fico, <br />companhia.com para apanhar todo mundo que manda mensagens de companhia.com, <br />Adriano Gomes para apanhar uma pessoa espec�fica, Adriano para apanhar todos os Adrianos</li><li><b>Para um endere�o ou nome:</b> Como um �man Originador: mas para o endere�o Para: de uma mensagem </li><li><b>Palavras no assunto:</b> Por exemplo: ol� para apanhar todas as mensagens com ol� no assunto</li></ul>
Magnet_MagnetType                       Tipo do �man
Magnet_Value                            Valor
Magnet_Always                           Colocar sempre no recept�culo
Magnet_Jump                             Detalhes do �man

Bucket_Error1                           Nomes de recept�culos apenas podem conter as letras de a at� z min�sculas mais - e _
Bucket_Error2                           O recept�culo %s j� existe
Bucket_Error3                           Criado o recept�culo %s
Bucket_Error4                           Por favor digite uma palavra que n�o seja em branco
Bucket_Error5                           Renomeado o recept�culo %s para %s
Bucket_Error6                           Apagado o recept�culo %s
Bucket_Title                            Sum�rio
Bucket_BucketName                       Nome do recept�culo
Bucket_WordCount                        Palavras
Bucket_WordCounts                       Distribui��o de Palavras
Bucket_UniqueWords                      Palavras �nicas
Bucket_SubjectModification              Modifica��o do Assunto
Bucket_ChangeColor                      Alterar Cor
Bucket_NotEnoughData                    Dados insuficientes
Bucket_ClassificationAccuracy           Exactid�o da Classifica��o
Bucket_EmailsClassified                 Mensagens classificadas
Bucket_EmailsClassifiedUpper            Distribui��o de Mensagens
Bucket_ClassificationErrors             Erros de classifica��o
Bucket_Accuracy                         Exactid�o
Bucket_ClassificationCount              Mensagens
Bucket_ClassificationFP                 Falsos Positivos
Bucket_ClassificationFN                 Falsos Negativos
Bucket_ResetStatistics                  Reiniciar contagem
Bucket_LastReset                        In�cio da contagem
Bucket_CurrentColor                     A c�r actual do recept�culo "%s" � "%s"
Bucket_SetColorTo                       Alterar a c�r do recept�culo "%s" para "%s"
Bucket_Maintenance                      Manuten��o
Bucket_CreateBucket                     Criar um recept�culo com o nome
Bucket_DeleteBucket                     Apagar o recept�culo chamado
Bucket_RenameBucket                     Renomear o recept�culo chamado
Bucket_Lookup                           Procurar
Bucket_LookupMessage                    Procurar por palavra nos recept�culos
Bucket_LookupMessage2                   Procurar no resultado por
Bucket_LookupMostLikely                 <b>%s</b> � mais prov�vel aparecer em <font color="%s">%s</font>
Bucket_DoesNotAppear                    <p><b>%s</b> n�o aparece em nenhum dos recept�culos
Bucket_DisabledGlobally                 Desligado globalmente
Bucket_To                               para
Bucket_Quarantine                       Quarentena

SingleBucket_Title                      Detalhes do recept�culo %s
SingleBucket_WordCount                  Contagem de palavras do recept�culo
SingleBucket_TotalWordCount             Contagem total de palavras
SingleBucket_Percentage                 Percentagem do total
SingleBucket_WordTable                  Tabela de palavras do recept�culo %s
SingleBucket_Message1                   Palavras com asterisco (*) foram usadas para classifica��o durante esta sess�o do POPFile.  Clique em qualquer palavra para procurar sua probabilidade para todos os recept�culos.
SingleBucket_Unique                     %s �nicas
SingleBucket_ClearBucket                Apagar todas as palavras do recept�culo

Session_Title                           Sess�o Expirada
Session_Error                           A sua sess�o POPFile expirou. Isto ocorre quando se reinicia o POPFile com o browser aberto. Por favor clique nos links do topo do ecran para continuar.

Header_MenuSummary                      This table is the navigation menu which allows access to each of the different pages of the control center.
History_MainTableSummary                This table shows the sender and subject of recently received messages and allows them to be reviewed and reclassified.  Clicking on the subject line will show the full message text, along with information about why it was classified as it was.  The 'Should be' column allows you to specify which bucket the message belongs in, or to undo that change.  The 'Delete' column allows you to delete specific messages from the history if you don't need them anymore.
History_OpenMessageSummary              This table contains the full text of an email message, with the words that are used for classification highlighted according to the bucket that was most relevant for each.
Bucket_MainTableSummary                 This table provides an overview of the classification buckets.  Each row shows the bucket name, the word count total for that bucket, the actual number of individual words in each bucket, whether the email's subject line will be modified when it gets classified to that bucket, whether to quarantine the messages received in that bucket, and a table to pick the color used in displaying anything related to that bucket in the control center.
Bucket_StatisticsTableSummary           This table provides three sets of statistics on the overall performance of PopFile.  The first is how accurate its classification is, the second is how many emails have been classified, and to which buckets, and the third is how many words are in each bucket, and what their relative percentages are.
Bucket_MaintenanceTableSummary          This table contains forms that allow you to create, delete or rename buckets, and to lookup a word in all of the buckets to see its relative probabilities.
Bucket_AccuracyChartSummary             This table graphically represents the accuracy of the email classification.
Bucket_BarChartSummary                  This table graphically represents a percentage allocation for each of the different buckets.  It is used for both number of emails classified, and total word counts.
Bucket_LookupResultsSummary             This table shows the probabilities associated with any given word of the corpus.  For each bucket, it shows the frequency that that word occurs, the probability that it will occur in that bucket, and the overall effect on the score of the bucket if that word exists in an email.
Bucket_WordListTableSummary             This table provides a listing of all the words for a particular bucket, organized by common first letter for each row.
Magnet_MainTableSummary                 This table shows the list of magnets that are used to automatically classify email according to fixed rules.  Each row shows how the magnet is defined, what bucket it is intended for, and a button to delete the magnet.
Configuration_MainTableSummary          This table contains a number of forms to allow you to control the configuration of PopFile.
Configuration_InsertionTableSummary     This table contains buttons that determine whether or not certain modifications are made to the headers or subject line of the email before it is passed on to the email client.
Security_MainTableSummary               This table provides sets of controls that affect the security of the overall configuration of PopFile, whether it should automatically check for updates to the program, and whether statistics about PopFile's performance should be sent to the central datastore of the program's author for general information.
Advanced_MainTableSummary               This table provides a list of words that PopFile ignores when classifying email due to their relative frequency in email in general.  They are organized per row according to the first letter of the words.

