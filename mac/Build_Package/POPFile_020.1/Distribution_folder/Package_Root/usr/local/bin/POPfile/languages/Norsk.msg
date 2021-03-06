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
LanguageCode                            no
LanguageCharset                         ISO-8859-1
LanguageDirection                       ltr

# This is used to get the appropriate subdirectory for the manual
ManualLanguage                          no

# Common words that are used on their own all over the interface
Apply                                   Bruk
On                                      P�
Off                                     Av
TurnOn                                  Sl� p�
TurnOff                                 Sl� av
Add                                     Legg til
Remove                                  Fjern
Previous                                Forrige
Next                                    Neste
From                                    Fra
Subject                                 Emne
Classification                          Klassifisering
Reclassify                              Re-klassifisering
Undo                                    Angre
Close                                   Lukk
Find                                    S�k
Filter                                  Filtrer
Yes                                     Ja
No                                      Nei
ChangeToYes                             Skift til Ja
ChangeToNo                              Skift til Nei
Bucket                                  B�tte
Magnet                                  Magnet
Delete                                  Slett
Create                                  Opprett
To                                      Til
Total                                   Total
Rename                                  Omd�p
Frequency                               Frekvens
Probability                             Sannsynlighet
Score                                   Resultat
Lookup                                  S�k etter

# The header and footer that appear on every UI page
Header_Title                            POPFile Kontrollsenter
Header_Shutdown                         Lukk POPFile
Header_History                          Logg
Header_Buckets                          B�tter
Header_Configuration                    Konfigurering
Header_Advanced                         Avansert
Header_Security                         Sikkerhet
Header_Magnets                          Magneter

Footer_HomePage                         POPFile Hjemmeside
Footer_Manual                           Manual
Footer_Forums                           Diskusjonsforum
Footer_FeedMe                           Mat meg!
Footer_RequestFeature                   Ettersp�r funksjoner
Footer_MailingList                      Mailingliste

Configuration_Error1                    Skilletegnet skal v�re ett enkelt tegn
Configuration_Error2                    Brukergrensesnittets port skal v�re et nummer mellom 1 og 65535
Configuration_Error3                    POP3-porten skal v�re et nummer mellom 1 og 65535
Configuration_Error4                    Sidens st�rrelse skal v�re mellom 1 og 1000
Configuration_Error5                    Antall dager i loggen skal v�re et tall mellom 1 og 366
Configuration_Error6                    TCP-tidsavbrudd skal v�re et tall mellom 10 og 300
Configuration_POP3Port                  POP3-porten
Configuration_POP3Update                Oppdaterte porten til %s; Denne endringen vil ikke tre i kraft f�r POPFile er startet p� nytt
Configuration_Separator                 Skilletegn
Configuration_SepUpdate                 Oppdaterte skilletegnet til %s
Configuration_UI                        Brukergrensesnittets web-port
Configuration_UIUpdate                  Oppdaterte Brukergrensesnittets web-port til %s; endringen vil ikke tre i kraft f�r POPFile startes p� nytt
Configuration_History                   Antall e-post pr. side
Configuration_HistoryUpdate             Oppdaterte antall e-post pr. side til %s
Configuration_Days                      Antall dager oppf�ringer i loggen skal beholdes
Configuration_DaysUpdate                Oppdaterte antall dager oppf�ringer i loggen skal beholdes til %s
Configuration_UserInterface             Brukergrensesnittet
Configuration_Skins                     Skins
Configuration_SkinsChoose               Velg skin
Configuration_Language                  Spr�k
Configuration_LanguageChoose            Velg spr�k
Configuration_ListenPorts               POP3-porten
Configuration_HistoryView               Logg-visning
Configuration_TCPTimeout                TCP-forbindelsens tidsavbrudd
Configuration_TCPTimeoutSecs            TCP-forbindelsens tidsavbrudd i sekunder
Configuration_TCPTimeoutUpdate          Oppdaterte TCP-forbindelsens tidsavbrudd til %s
Configuration_ClassificationInsertion   Klassifikasjonsm�ter (innsetting)
Configuration_SubjectLine               Emnelinje-innsetting
Configuration_XTCInsertion              X-Text-Classification innsetting
Configuration_XPLInsertion              X-POPFile-Link innsetting
Configuration_Logging                   Logging
Configuration_None                      Ingen
Configuration_ToScreen                  Til Skjerm
Configuration_ToFile                    Til Fil
Configuration_ToScreenFile              Til Skjerm og Fil
Configuration_LoggerOutput              Logger output
Configuration_GeneralSkins              Skins
Configuration_SmallSkins                Small Skins
Configuration_TinySkins                 Tiny Skins

Advanced_Error1                         '%s' Er allerede i Stoppordlisten
Advanced_Error2                         Stoppord kan kun inneholde Alfanumeriske tegn, ., _, -, eller @ tegn
Advanced_Error3                         '%s' er lagt til i stoppordlisten
Advanced_Error4                         '%s' er ikke i stoppordlisten
Advanced_Error5                         '%s' er fjernet fra stoppordlisten
Advanced_StopWords                      Stoppord
Advanced_Message1                       Disse ordene blir ignorert fra all klassifisering fordi de forekommer meget ofte.
Advanced_AddWord                        Legg til ord
Advanced_RemoveWord                     Fjern ord

History_Filter                          &nbsp;(vis kun b�tten<font color="%s">%s</font>)
History_FilterBy                        Filter By
History_Search                          &nbsp;(s�k emne for %s)
History_Title                           Siste meldinger
History_Jump                            Hopp til melding
History_ShowAll                         Vis alle
History_ShouldBe                        Skulle v�re
History_NoFrom                          ingen Fra-linje
History_NoSubject                       ingen Emne-linje
History_ClassifyAs                      klassifisert som
History_MagnetUsed                      Magnet brukt
History_ChangedTo                       Endret til <font color="%s">%s
History_Already                         Re-klassifisert som <font color="%s">%s</font>
History_RemoveAll                       Fjern alle
History_RemovePage                      Fjern side
History_Remove                          For � fjerne oppf�ringer i loggen, klikk
History_SearchMessage                   S�k Emne
History_NoMessages                      Ingen meldinger

Password_Title                          Passord
Password_Enter                          Skriv inn passord
Password_Go                             OK!
Password_Error1                         Feil passord

Security_Error1                         Den sikre porten skal v�re et tall mellom 1 og 65535
Security_Stealth                        Stealth Mode/Server Operation
Security_NoStealthMode                  Nei (Stealth Mode)
Security_ExplainStats                   (Denne funksjonen sender en gang per dag de etterf�lgene tre verdiene til et script hos wwwu.sethesource.com: bc (det totale antall b�tter du har) mc (det totale antall i meldinger som POPFile har klassifisert ) og ec (det totale antall klassifiseringsfeil). Disse blir lageret i en fil og jeg vil bruke disse data til � offentligj�re statistikk omkring hvordan folk bruker POPFile og hvor godt POPFile virker. Min web-server beholder denne log-filen omtrent 5 dager og blir s� slettet; Jeg lagrer ingen forbindelse mellom statistikken og individuelle IP-adresser.)
Security_ExplainUpdate                  (Denne funksjonen sender en gang per dag de  etterf�lgene tre verdiene til et script hos wwwu.sethesource.com: ma (hovedversjonsnummeret p� din installerte POPFile), mi (under-versjonsnummeret p� din installerte POPFile) og bn (build nummer p� din installerte POPFile). POPFile mottar et svar i form av et stykke grafikk som vises i toppen av siden, hvis en ny version er tilgjengelig. Min web-server tar vare p� denne log-filen omtrent 5 dager og de blir s� slettet; Jeg lagrer ingen forbindelse mellom statistikken og individuelle IP-adresser.)
Security_PasswordTitle                  Brukergrensesnittets Passord
Security_Password                       Passord
Security_PasswordUpdate                 Oppdater passord til %s
Security_AUTHTitle                      Godkjenning av sikkert passord
Security_SecureServer                   Sikker Server
Security_SecureServerUpdate             Opdaterte sikker server til %s; denne endringen vil ikke tre i kraft f�r omstart av POPFile
Security_SecurePort                     Sikker port
Security_SecurePortUpdate               Opdaterte porten til %s; denne endringen vil ikke tre i kraft f�r omstart av POPFile
Security_POP3                           Godta POP3-tilkoblinger fra andre maskiner
Security_UI                             Godta HTTP (Brukergrensesnitt) tilkoblinger fra andre maskiner
Security_UpdateTitle                    Automatisk Oppdaterings-kontroll
Security_Update                         Kontroller daglig om det finnes oppdateringer til POPFile
Security_StatsTitle                     Statistikk-rapportering
Security_Stats                          Send statistikk tilbake til John daglig

Magnet_Error1                           Magneten '%s' finnes allrede i b�tten'%s' 
Magnet_Error2                           Den nye magneten '%s' er i konflikt med magneten '%s' i b�tten '%s' og kan gi flertydige resultater. Den nye magneten ble ikke tilf�yd.
Magnet_Error3                           Opprettet den nye magneten '%s' i b�tten '%s'
Magnet_CurrentMagnets                   N�v�rende Magneter
Magnet_Message1                         De f�lgende magnetene gj�r at e-post alltid blir klassifisert til den spesifiserte b�tten.
Magnet_CreateNew                        Opprett Ny Magnet
Magnet_Explanation                      Tre typer magneter er anbefalt: <ul><li>Fra adressen eller navn:</b> For eksempel: john@firma.dk for � matche en spesifikk adresse, <br />firma.dk for � matche alle som sender fra firma.dk, <br />John Doe for � matche en spesifikk person, John for � matche alle John'er</li><li><b>Til adresse eller navn:</b> Samme som en Fra: Magnet men bare for Til: Adressen i en e-post</li><li><b>Emne-ord:</b> For eksempel: hei for � matche alle meldinger med ordet hei i emnet</li></ul>
Magnet_MagnetType                       Magnettyper
Magnet_Value                            Verdier
Magnet_Always                           Tilh�rer alltid b�tten

Bucket_Error1                           B�ttenes navn kan kun inneholde bokstavene a til z med sm� bokstaver, samt - og _
Bucket_Error2                           B�tten med navnet %s eksisterer allerede
Bucket_Error3                           Opprett b�tten med navnet %s
Bucket_Error4                           Skriv venligst ikke et tomt ord
Bucket_Error5                           Omd�p b�tten %s til %s
Bucket_Error6                           Slett b�tten %s
Bucket_Title                            Oversikt
Bucket_BucketName                       B�ttenes navn
Bucket_WordCount                        Ordtelling
Bucket_WordCounts                       Ordfordeling
Bucket_UniqueWords                      Unike ord
Bucket_SubjectModification              Emne-modifisering
Bucket_ChangeColor                      Skift farge
Bucket_NotEnoughData                    Ikke nok data
Bucket_ClassificationAccuracy           Klassifikasjons-n�yaktighet
Bucket_EmailsClassified                 Antall e-post klassifisert
Bucket_EmailsClassifiedUpper            Antall e-post klassifisert
Bucket_ClassificationErrors             Klassifiseringsfeil
Bucket_Accuracy                         N�yaktighet
Bucket_ClassificationCount              Klassifiseringstelling
Bucket_ResetStatistics                  Nullstill Statistikkene
Bucket_LastReset                        Sist nullstilt
Bucket_CurrentColor                     %s N�v�rende farge er %s
Bucket_SetColorTo                       Sett %s fargen til %s
Bucket_Maintenance                      Vedlikehold
Bucket_CreateBucket                     Oppret b�tten med navnet
Bucket_DeleteBucket                     Slett b�tten med navnet
Bucket_RenameBucket                     Omd�p b�tten med navnet
Bucket_Lookup                           S�k etter
Bucket_LookupMessage                    S�k etter ord i b�ttene
Bucket_LookupMessage2                   S�keresultatet for
Bucket_LookupMostLikely                 Det er mest sannsynlig at <b>%s</b> forekommer i <font color="%s">%s</font>
Bucket_DoesNotAppear                    <p><b>%s</b> forekommer ikke i noen av b�ttene
Bucket_DisabledGlobally                 Deaktivert globalt
Bucket_To                               til
Bucket_Quarantine                       Karantene

SingleBucket_Title                      Detaljer for %s
SingleBucket_WordCount                  Totalt antall ord i b�tten
SingleBucket_TotalWordCount             Totalt antall ord
SingleBucket_Percentage                 Prosentandelen av totalen
SingleBucket_WordTable                  Ord tabell for %s
SingleBucket_Message1                   Markerte (*) ord er blitt brukt til � klassifisere i denne POPFile-sesjonen. Trykk p� hvilket som helst ord for � sl� opp dens sannsynlighet for alle b�ttene.
SingleBucket_Unique                     %s unike

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

