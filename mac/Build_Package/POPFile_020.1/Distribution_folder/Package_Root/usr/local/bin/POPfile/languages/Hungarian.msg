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
LanguageCode                            hu
LanguageCharset                         ISO-8859-2
LanguageDirection                       ltr

# This is used to get the appropriate subdirectory for the manual
ManualLanguage                          hu

# Common words that are used on their own all over the interface
Apply                                   Alkalmaz
On                                      Be
Off                                     Ki
TurnOn                                  Bekapcsol
TurnOff                                 Kikapcsol
Add                                     Hozz�ad
Remove                                  Elvesz
Previous                                El�z�
Next                                    K�vetkez�
From                                    Felad�
Subject                                 T�ma
Classification                          Oszt�lyoz�s
Reclassify                              �jraoszt�lyoz
Undo                                    Undo
Close                                   Bez�r
Find                                    Keres
Filter                                  Sz�r�
Yes                                     Igen
No                                      Nem
ChangeToYes                             Kapcsold Igen-re
ChangeToNo                              Kapcsold Nem-re
Bucket                                  Tart�ly
Magnet                                  M�gnes
Delete                                  T�r�l
Create                                  L�trehoz
To                                      Cimzett
Total                                   �sszesit�s
Rename                                  �tnevez
Frequency                               Frekvencia
Probability                             Val�szin�s�g
Score                                   Pontsz�m
Lookup                                  Lookup

# The header and footer that appear on every UI page
Header_Title                            POPFile Vez�rl�k�zpont
Header_Shutdown                         Shutdown POPFile
Header_History                          History
Header_Buckets                          Tart�lyok
Header_Configuration                    Be�llit�sok
Header_Advanced                         Halad�
Header_Security                         Biztons�g
Header_Magnets                          M�gnesek

Footer_HomePage                         POPFile Honlap
Footer_Manual                           K�zik�nyv
Footer_Forums                           F�rumok
Footer_FeedMe                           Adj enni!
Footer_RequestFeature                   Tulajdons�g k�r�se
Footer_MailingList                      Levlista

Configuration_Error1                    Az elv�laszt� karakter nem lehet hosszabb 1 karaktern�l
Configuration_Error2                    A felhaszn�l�i interf�sz port egy sz�m kell hogy legyen 1 �s 65535 k�z�tt.
Configuration_Error3                    A POP3 port egy sz�m kell hogy legyen 1 �s 65535 k�z�tt.
Configuration_Error4                    A lapsz�m egy sz�m kell hogy legyen 1 �s 1000 k�z�tt.
Configuration_Error5                    A history-ban l�v� napok sz�ma egy sz�m kell hogy legyen 1 �s 366 k�z�tt.
Configuration_Error6                    A TCP id�t�ll�p�s egy sz�m kell hogy legyen 10 �s 300 k�z�tt.
Configuration_POP3Port                  POP3 figyel� port
Configuration_POP3Update                Az �j port: %s; A v�ltoztat�s �letbel�ptet�s�hez �jra kell inditanod POPFile-t.
Configuration_Separator                 Elv�laszt� karakter
Configuration_SepUpdate                 Az �j elv�laszt� karakter: %s
Configuration_UI                        Felhaszn�l�i interf�sz web port
Configuration_UIUpdate                  Az �j felhaszn�l�i interf�sz web port %s; A v�ltoztat�s �letbel�ptet�s�hez �jra kell inditanod POPFile-t.
Configuration_History                   Egy lapon l�v� emailek sz�ma
Configuration_HistoryUpdate             Az egy lapon l�v� emailek sz�ma megv�ltozott: %s
Configuration_Days                      A history-ban meg�rizend� napok sz�ma
Configuration_DaysUpdate                A history-ban meg�rizend� napok sz�m�nak �j �rt�ke: %s
Configuration_UserInterface             Felhaszn�l�i fel�let
Configuration_Skins                     Skinek
Configuration_SkinsChoose               V�lassz skin-t
Configuration_Language                  Nyelv
Configuration_LanguageChoose            V�lassz nyelvet
Configuration_ListenPorts               Figyelj portokon
Configuration_HistoryView               History N�zet
Configuration_TCPTimeout                TCP Kapcsolat Timeout
Configuration_TCPTimeoutSecs            TCP kapcsolat timeout m�sodpercekben
Configuration_TCPTimeoutUpdate          A TCP kapcsolat timeout �j �rt�ke: %s
Configuration_ClassificationInsertion   Oszt�lyoz�s beilleszt�s
Configuration_SubjectLine               Beilleszt�s az email t�m�j�ba
Configuration_XTCInsertion              X-Text-Classification alkalmaz�sa
Configuration_XPLInsertion              X-POPFile-Link beilleszt�se
Configuration_Logging                   Napl�z�s
Configuration_None                      Nincs
Configuration_ToScreen                  K�perny�re
Configuration_ToFile                    F�jlba
Configuration_ToScreenFile              K�perny�re �s f�jlba
Configuration_LoggerOutput              Napl�z� kimenet

Advanced_Error1                         '%s' m�r hozz� lett adva a blokkol� szavakhoz
Advanced_Error2                         A figyelmen kiv�l hagyott szavak csak bet�ket, sz�mokat �s a k�vetkez� karaktereket tartalmayhatj�k:, ., _, -, @
Advanced_Error3                         '%s' hozz�adva a blokkolt szavak list�j�hoz
Advanced_Error4                         '%s' nincs a blokkolt szavak k�z�tt
Advanced_Error5                         '%s' t�r�lve a blokkolt szavak k�z�l
Advanced_StopWords                      Figyelmen kiv�l hagyott szavak
Advanced_Message1                       A k�vetkez� szavak minden oszt�lyoz�sb�l ki fognak maradni, mivel t�l s�r�n fordulnak el�.
Advanced_AddWord                        Sz� hozz�ad�sa
Advanced_RemoveWord                     Sz� t�rl�se

History_Filter                          &nbsp;(csak a <font color=%s>%s</font> kont�ner tartalma l�that�)
History_Search                          &nbsp;(Tal�latok %s t�m�ra)
History_Title                           Utolj�ra be�rkezett �zenetek
History_Jump                            �zenetre ugr�s
History_ShowAll                         Mutasd mindet
History_ShouldBe                        Kellene lennie
History_NoFrom                          nincs felad�
History_NoSubject                       nincs t�ma
History_ClassifyAs                      Oszt�lyozd mint
History_MagnetUsed                      Elt�rit� m�gnes:
History_ChangedTo                       �j �rt�k: <font color=%s>%s
History_Already                         �jraoszt�lyozva mint <font color=%s>%s</font>
History_RemoveAll                       Mindet t�r�l
History_RemovePage                      T�r�ld ezt az oldalt
History_Remove                          Klikkelj hogy t�r�ld a bejegyz�seket a History-b�l
History_SearchMessage                   Keress felad�/t�ma alapj�n
History_NoMessages                      Nincs �zenet
History_ShowMagnet                      M�gnesezett
History_Magnet                          &nbsp;(Csak m�gnesek �ltal oszt�lyozott �zenetek l�tszanak)
History_ResetSearch                     Null�z�s

Password_Title                          Jelsz�
Password_Enter                          Ird be a jelsz�t
Password_Go                             Mehet!
Password_Error1                         Rossz jelsz�

Security_Error1                         A secure port egy sz�m kell hogy legyen 1 �s 65535 k�z�tt
Security_Stealth                        Lopakod� (Stealth) �zemm�d/Szerver M�k�d�s
Security_NoStealthMode                  Nem (Stealth �zemm�d)
Security_ExplainStats                   (Ha ez be van kapcsolva, akkor a POPFile naponta egyszer elk�ldi a k�vetkez� 3 v�ltoz� �rt�k�t egy script-nek a www.usethesource.com-ra: bc (a kont�nerek sz�ma) mc (a POPFile �ltal oszt�lyozott �zenetek sz�ma) ec (az oszt�lyoz�si hib�k sz�ma). Ezeket az adatokat egy �llom�myban tartom, �s arra haszn�lom �ket hogy n�h�ny statisztikai adatok publik�ljak a POPFile hat�konys�g�r�l �s arr�l hogy az emberek hogyan hasyn�lj�k a programot. A Web szerverem kb. 5 napig �rzi meg az inform�ci�t, majd t�rli. Nem t�rolok semmif�le kapcsolatot a begy�jt�tt adatok �s az IP cimek k�z�tt.)
Security_ExplainUpdate                  (Ha ez be van kapcsolva, akkor a POPFile naponta egyszer elk�ldi a k�vetkez� 3 v�ltoz� �rt�k�t egy script-nek a www.usethesource.com-ra: ma (az �ltalad haszn�lt POPFile f� verzi�sz�ma) mi (az �ltalad haszn�lt POPFile al-verzi�sz�ma) bn (az �ltalad haszn�lt POPFile build sz�ma). Az �ltalad haszn�lt POPFile kapni fog egy grafik�t a szervert�l, ami a lap tetej�n lesz l�that� ha egy �jabb verzi� el�rhet�. Ezeket az adatokat egy �llom�myban tartom, �s arra haszn�lom �ket hogy n�h�ny statisztikai adatok publik�ljak a POPFile hat�konys�g�r�l �s arr�l hogy az emberek hogyan hasyn�lj�k a programot. A Web szerverem kb. 5 napig �rzi meg az inform�ci�t, majd t�rli. Nem t�rolok semmif�le kapcsolatot a begy�jt�tt adatok �s az IP cimek k�z�tt.) 
Security_PasswordTitle                  Felhasz�l�i fel�let jelsz�
Security_Password                       Jelsz�
Security_PasswordUpdate                 Az �j jelsz�: %s
Security_AUTHTitle                      Secure Password Authentication/AUTH
Security_SecureServer                   Secure szerver
Security_SecureServerUpdate             Az �j secure szerver: %s; Ez a v�ltoz�s nem fog �rv�nybe l�pni amig ujra nem inditod a POPFile-t.
Security_SecurePort                     Secure port
Security_SecurePortUpdate               Az �j port: %s; Ez a v�ltoz�s nem fog �rv�nybe l�pni amig ujra nem inditod a POPFile-t.
Security_POP3                           POP3 kapcsolat enged�lyez�se t�voli g�pekkel
Security_UI                             HTTP (Felhaszn�l�i fel�let) enged�lyez�se t�voli g�pekkel
Security_UpdateTitle                    Automatikus �j verzi� ellen�rz�s
Security_Update                         Naponta ellen�rizze hogy van-e �j POPFile verzi�
Security_StatsTitle                     Statisztika k�ld�se
Security_Stats                          K�ldd el a statisztik�kat John�nak minden nap

Magnet_Error1                           A m�gnes '%s' m�r l�tezik a '%s' kont�nerben
Magnet_Error2                           Az �j m�gnes '%s' �sszeragadhat a '%s' m�gnessel �s hib�s eredm�nyeket okozhat a '%s' kont�nerben. Az �j m�gnes nem lett hozz�adva a rendszerhez.
Magnet_Error3                           Hozd l�tre a '%s' m�gnest a '%s' kont�nerben.
Magnet_CurrentMagnets                   M�gnesek
Magnet_Message1                         A k�vetkez� m�gnes minden egyes levelet a megadott kont�nerbe fog ir�nyitani.
Magnet_CreateNew                        Hozz l�tre �j m�gnest
Magnet_Explanation                      H�rom fajta m�gnes l�tezik:</b> <ul><li><b>Felad� cime vagy neve:</b> P�ld�ul: john@company.com, ha egy bizonyos email cimet keres�nk<br>company.com ha mindenkit meg akarunk tal�lni aki a company.com cimr�l j�n, <br>"John Doe" ha egy bizonyos embert akarunk kisz�rni, John meg fog tal�lni minden John-t<li><b>Cimyett cime vagy neve:</b> Ugyanaz mint a Felad�, de ez a Cimzett nev�ben �s cim�ben keres.<li><b>T�ma:</b> P�ld�ul: hello meg fog tal�lni minden email-t aminek a sz� "hello" a t�m�j�ban szerepel</ul>
Magnet_MagnetType                       M�gnes tipus
Magnet_Value                            �rt�k
Magnet_Always                           Mindig a kont�nerbe megy

Bucket_Error1                           Kont�ner nevek csak kisbet�ket tartalmazhatnak a-t�l z-ig, valamint a - �s _ jeleket
Bucket_Error2                           M�r l�tezik egy %s nev� kont�ner
Bucket_Error3                           A %s nev� kont�ner l�trehozva
Bucket_Error4                           K�rem adjon meg egy nem-�res sz�t
Bucket_Error5                           Kont�ner �tnevezve %-r�l %s-ra
Bucket_Error6                           A %s nev� kont�nert t�r�ltem
Bucket_Title                            �sszefoglal�
Bucket_BucketName                       Kont�ner n�v
Bucket_WordCount                        Szavak sz�ma
Bucket_WordCounts                       Szavak sz�mai
Bucket_UniqueWords                      Egyedi szavak
Bucket_SubjectModification              T�ma megv�ltoztat�s
Bucket_ChangeColor                      Szin megv�ltoztat�sa
Bucket_NotEnoughData                    Nincs el�g adat
Bucket_ClassificationAccuracy           Az oszt�lyoz�s pontoss�ga
Bucket_EmailsClassified                 Oszt�lyozott Emailek sz�ma
Bucket_EmailsClassifiedUpper            Oszt�lyozott Emailek sz�ma
Bucket_ClassificationErrors             Oszt�lyoz�si hib�k
Bucket_Accuracy                         Pontoss�g
Bucket_ClassificationCount              Oszt�lyoz�sok sz�ma
Bucket_ResetStatistics                  Statisztika null�z�sa
Bucket_LastReset                        Utols� null�z�s
Bucket_CurrentColor                     %s a jelenlgi szin %s
Bucket_SetColorTo                       %s szin %s-ra �llit�sa
Bucket_Maintenance                      Karbantart�s
Bucket_CreateBucket                     Kont�ner l�trehoz�sa:
Bucket_DeleteBucket                     Kont�ner t�rl�se:
Bucket_RenameBucket                     Kont�ner �tnevez�se:
Bucket_Lookup                           Keres�s
Bucket_LookupMessage                    Sz� keres�se a kont�nerekben
Bucket_LookupMessage2                   Keres�s eredm�nye:
Bucket_LookupMostLikely                 <b>%s</b> legval�szin�bben a k�vetkez� helyen fog megjelenni: <font color=%s>%s</font>
Bucket_DoesNotAppear                    <p><b>%s</b> egyik kont�nerben sem tal�lhat�
Bucket_DisabledGlobally                 Glob�lisan letiltott
Bucket_To                               to
Bucket_Quarantine                       Karant�n

SingleBucket_Title                      %s r�szletei
SingleBucket_WordCount                  Kont�nerben l�v� szavak sz�ma
SingleBucket_TotalWordCount             �sszes sz� sz�ma
SingleBucket_Percentage                 Teljes sz�zal�k
SingleBucket_WordTable                  Sz�t�bl�zat % -nak
SingleBucket_Message1                   A csillaggal jel�lt szavak(*) r�szt vettek az oszt�lyz�sban a POPFile legut�bbi indit�sa �ta. Kattints egy sz�ra hogy megn�zd a kont�nerenk�nti val�szin�s�g�t.
SingleBucket_Unique                     %s egyedi

Session_Title                           POPFile Session Lej�rt
Session_Error                           Ez a POPFile session lej�rt.  Egy lehets�ges ok hogy elinditotta �s le�llitotta a POPFile-t, de a b�ng�sz�t nyitva hagyta. K�rem kattintson a fel�l l�v� linkek egyik�re.
