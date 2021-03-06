# Copyright (c) 2003 John Graham-Cumming
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

# This is used to get the appropriate subdirectory for the manual

LanguageCode				sv
LanguageCharset				ISO-8859-1
LanguageDirection                       ltr

# Common words that are used on their own all over the interface
Apply                                   Verkst�ll
On                                      On
Off                                     Off
TurnOn                                  S�tt p�
TurnOff                                 St�ng av
Add                                     L�gg till
Remove                                  Ta bort
Previous                                F�reg�ende
Next                                    N�sta
From                                    Fr�n
Subject                                 �mne
Classification                          Klassifikation
Reclassify                              Reklassifikation
Undo                                    �ngra
Close                                   St�ng av server
Find                                    S�k
Filter                                  Filter
Yes                                     Ja
No                                      Nej
ChangeToYes                             �ndra till Ja
ChangeToNo                              �ndra till Nej
Bucket                                  Hink
Magnet                                  Magnet
Delete                                  Ta bort
Create                                  Skapa
To                                      Till
Total                                   Totalt
Rename                                  D�p om
Frequency                               Frekvens
Probability                             Sannolikhet
Score                                   Resultat
Lookup                                  Leta efter

# The header and footer that appear on every UI page
Header_Title                            Kontrollpanel
Header_Shutdown                         St�ng
Header_History                          Historia
Header_Buckets                          Hinkar
Header_Configuration                    Konfiguration
Header_Advanced                         Avancerat
Header_Security                         S�kerhet
Header_Magnets                          Magneter

Footer_HomePage                         Hem
Footer_Manual                           Manual
Footer_Forums                           Forum
Footer_FeedMe                           �terkoppling
Footer_RequestFeature                   F�resl� funktioner
Footer_MailingList                      Mailinglistor

Configuration_Error1                    Det avskiljande tecknet kan bara vara ett tecken.
Configuration_Error2                    Webgr�nssnittets post m�ste vara ett tal mellan 1 och 65535
Configuration_Error3                    POP3 porten m�ste vara ett tal mellan 1 och 65535
Configuration_Error4                    Sidans storlek m�ste vara ett tal mellan 1 och 1000
Configuration_Error5                    Antal dagar i 'histora' m�ste vara ett tal mellan 1 och 366
Configuration_Error6                    TCP timeout m�ste vara ett tal mellan 10 och 300
Configuration_POP3Port                  POP3 port
Configuration_POP3Update                Uppdaterade porten till %s; denna �ndring kommer inte att g�lla f�rr�n servern �r omstartad.
Configuration_Separator                 Avskiljare
Configuration_SepUpdate                 Uppdaterade det avskiljande tecknet till %s
Configuration_UI                        Webgr�nssnittets HTTP port
Configuration_UIUpdate                  Uppdaterade webgr�nssnittets HTTP port till %s; denna �ndring kommer inte att g�lla f�rr�n servern �r omstartad.
Configuration_History                   Antal epost per sida
Configuration_HistoryUpdate             Uppdaterede antal email per sida till %s
Configuration_Days                      Antal dagar histora skall beh�llas
Configuration_DaysUpdate                Uppdaterede antal dagar histora skall sparas: %s
Configuration_UserInterface             Gr�nssnitt
Configuration_Skins                     Utseende ytan
Configuration_SkinsChoose               V�lj tema
Configuration_Language                  Spr�k
Configuration_LanguageChoose            V�lj spr�k
Configuration_ListenPorts               POP3
Configuration_HistoryView               Formatera 'Historia' vyn
Configuration_TCPTimeout                TCP f�rbindelsens timeout
Configuration_TCPTimeoutSecs            TCP f�rbindelsens timeout i sekunder
Configuration_TCPTimeoutUpdate          Updatera TCP f�rbindelsens timeout till %s
Configuration_ClassificationInsertion   Klassifikation epost headers
Configuration_SubjectLine               �mnesrad modifiering
Configuration_XTCInsertion              X-Text-Klassification ins�ttning
Configuration_XPLInsertion              X-POPFile-L�nk ins�ttning
Configuration_Logging                   Logging
Configuration_None                      Ingen
Configuration_ToScreen                  Till sk�rm
Configuration_ToFile                    Till fil
Configuration_ToScreenFile              Till sk�rm och fil
Configuration_LoggerOutput              Loggning utdata

Advanced_Error1                         '%s' finns redan i stoppord listan
Advanced_Error2                         Stoppord kan bara inneh�lla alfanumeriska tecken, ., _, -, eller @ tegn
Advanced_Error3                         '%s' �r lagt till stopordlistan
Advanced_Error4                         '%s' finns inte i stoppordlistan
Advanced_Error5                         '%s' �r borttaget fr�n stoppordlistan
Advanced_StopWords                      Stoppord
Advanced_Message1                       F�ljande ord ignoreras av klassifikationen eftersom de f�rekommer ofta.
Advanced_AddWord                        L�gg till ord
Advanced_RemoveWord                     Ta bort ord

History_Filter                          &nbsp;(visa bara spannet <font color=%s>%s</font>)
History_Search                          &nbsp;(s�k �mne f�r %s)
History_Title                           Historia
History_Jump                            Spring til besked
History_ShowAll                         Visa alla
History_ShouldBe                        skulle vara
History_NoFrom                          inget fr�n rad
History_NoSubject                       iget �mne rad
History_ClassifyAs                      klassificerat som
History_MagnetUsed                      Magnet anv�nd
History_ChangedTo                       �ndrat till <font color=%s>%s
History_Already                         Redan reklassificerat som <font color=%s>%s</font>
History_RemoveAll                       Ta bort alla
History_RemovePage                      Ta bort sida
History_Remove                          f�r att ta bort historia
History_SearchMessage                   S�k �mne
History_NoMessages                      Inga meddelanden

Password_Title                          L�senord
Password_Enter                          Indtast kodeord
Password_Go                             Go!
Password_Error1                         Fel l�senord

Security_Error1                         Den s�kra porten m�ste vara ett tal mellan 1 och 65535
Security_Stealth                        Server k�rl�ge
Security_NoStealthMode                  Nej (Lokalt l�ge)
Security_ExplainStats                   (Data anv�nds f�r att f�rb�ttra servern)
Security_ExplainUpdate                  (Om uppdatering finns tillg�nglig kommer en logotyp att visas p� sidan)
Security_PasswordTitle                  L�senord till webgr�nssnittet
Security_Password                       L�senord
Security_PasswordUpdate                 Uppdaterar l�senord till %s
Security_AUTHTitle                      L�senord f�r epostkonto med extra autentisering
Security_SecureServer                   Server
Security_SecureServerUpdate             Uppdaterade servern till %s; denna �ndring kommer inte att tr�da i kraft f�rr�n servern �r omstartad
Security_SecurePort                     Port
Security_SecurePortUpdate               Uppdaterade porten till  %s; denna �ndring kommer inte att tr�da i kraft f�rr�n servern �r omstartad 
Security_POP3                           Acceptera anslutningar till POP3 fr�n externa k�lla
Security_UI                             Acceptera HTTP anslutningar fr�n extern k�lla
Security_UpdateTitle                    Automatisk uppdatering
Security_Update                         S�k efter uppdateringar varje dag
Security_StatsTitle                     Statistikrapportering
Security_Stats                          Skicka statistik till programmets skapare dagligen

Magnet_Error1                           Magnet '%s' finns redan i '%s' 
Magnet_Error2                           Det nya statiska filtret '%s' kommer i konflikt med det statiska filtret '%s' i '%s' och kan skapa tvetydiga resultat. Det nya statiska filtret skapades inte.
Magnet_Error3                           Skapade ny magnet '%s' i '%s'
Magnet_CurrentMagnets                   Aktuella magneter
Magnet_Message1                         F�ljande magneter garanterar att email alltid hamnar i en viss hink.
Magnet_CreateNew                        Skapa ny magnet
Magnet_Explanation                      Tre typer av magneter �r tillg�ngliga: <ul><li>Fr�n adressen eller namnet:</b> Till exempel: test@f�retag.se f�r att matcha en specifik adress, <br>f�retag.se f�r att matcha alla avs�ndare fr�n f�retaget, <br>John Doe f�r att matcha en specifik person, John f�r att matcha alla Johns<li><b>Till adressen eller namnet:</b> Liksom ovan men f�r to: eller till: -raden. <li><b>�mnet:</b> Till exempel: Hej! f�r att matcha alla 'Hej!' i �mnesraden.</ul>
Magnet_MagnetType                       Magnettyper
Magnet_Value                            V�rden
Magnet_Always                           Tillh�r alltid magneten

Bucket_Error1                           Hinkens namn kan bara inneh�lla bokst�verna a till z (sm� bokst�ver) samt - och _
Bucket_Error2                           Hinken med namnet %s finns redan
Bucket_Error3                           Uppr�tta hink med namnet %s
Bucket_Error4                           Var god fyll i ett ord
Bucket_Error5                           D�p inte om hinken %s till %s
Bucket_Error6                           Tog bort hinken %s
Bucket_Title                            �verblick
Bucket_BucketName                       Hinkens namn
Bucket_WordCount                        Antal
Bucket_WordCounts                       F�rdelning av ord
Bucket_UniqueWords                      Unika ord
Bucket_SubjectModification              �mnesrad modifiering
Bucket_ChangeColor                      Byt f�rg
Bucket_NotEnoughData                    Finns inte data
Bucket_ClassificationAccuracy           Klassifikationens exakthet
Bucket_EmailsClassified                 Antal email
Bucket_EmailsClassifiedUpper            Antal email
Bucket_ClassificationErrors             Antal fel
Bucket_Accuracy                         Exakthet
Bucket_ClassificationCount              Antal klassificeringar
Bucket_ResetStatistics                  Nollst�ll statistiken
Bucket_LastReset                        F�rra nollst�llningen
Bucket_CurrentColor                     %s nuvarande f�rg �r %s
Bucket_SetColorTo                       S�tt %s f�rgen till %s
Bucket_Maintenance                      Hantering
Bucket_CreateBucket                     Skapa hink med namnet
Bucket_DeleteBucket                     Ta bort hink med namnet
Bucket_RenameBucket                     D�p om hink
Bucket_Lookup                           Hitta
Bucket_LookupMessage                    Hitta ord i hink
Bucket_LookupMessage2                   Hitta f�r
Bucket_LookupMostLikely                 Det �r mest sannolikt att <b>%s</b> kommer att visas i <font color=%s>%s</font>
Bucket_DoesNotAppear                    <p><b>%s</b> kommer inte att visas i n�gon hink
Bucket_DisabledGlobally                 Deaktivera globalt
Bucket_To					    till
Bucket_Quarantine                       Karant�n

SingleBucket_Title                      Fler detaljer f�r %s
SingleBucket_WordCount                  Totalt antal ord i hinken
SingleBucket_TotalWordCount             Totalt antal ord
SingleBucket_Percentage                 Procent
SingleBucket_WordTable                  Ordtabell f�r %s
SingleBucket_Message1                   Markerat (*) ord har anv�nts till klassifiering i denna sessionen. Tryck p� ett ord f�r att visa dess sannolikhet i alla hinkar.
SingleBucket_Unique                     %s unique

Session_Title				Sessionen har g�tt ut
Session_Error				Din session har g�tt ut. Detta kan ha orsakats genom att starta och st�nga av servern medan webl�saren har f�rblivit �ppen. Klicka p� en av l�nkarna ovan f�r att forts�tta anv�nda webgr�nsnittet.