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
LanguageCode                            pl
LanguageCharset                         ISO-8859-2
LanguageDirection                       ltr

# This is used to get the appropriate subdirectory for the manual

ManualLanguage                          en

# Common words that are used on their own all over the interface

Apply                                   Zatwierd�
On                                      W��czony
Off                                     Wy��czony
TurnOn                                  W��cz
TurnOff                                 Wy��cz
Add                                     Dodaj
Remove                                  Usu�
Previous                                Poprzedni
Next                                    Nast�pny
From                                    Od
Subject                                 Temat
Cc                                      CC
Classification                          Klasyfikacja
Reclassify                              Klasyfikuj
Probability                             Prawdopodobie�stwo
Scores                                  Punkty
QuickMagnets                            Szybki Musik
Undo                                    Cofnij
Close                                   Zamknij
Find                                    Znajd�
Filter                                  Filtr
Yes                                     Tak
No                                      Nie
ChangeToYes                             Zmie� na tak
ChangeToNo                              Zmie� na nie
Bucket                                  Folder
Magnet                                  Musik
Delete                                  Skasuj
Create                                  Utw�rz
To                                      Do
Total                                   Ca�kowity
Rename                                  Zmie�
Frequency                               Cz�stotliwo��
Probability                             Prawdopodobie�stwo
Score                                   Punkty
Lookup                                  Szukaj
Word                                    S�owo
Count                                   Licz
Update                                  Aktualizuj
Refresh                                 Od�wie�

# The header and footer that appear on every UI page
Header_Title                            Centrum Sterowania POPFile
Header_Shutdown                         Wy��cz daemona POPFile
Header_History                          Historia
Header_Buckets                          Foldery
Header_Configuration                    Konfiguracja
Header_Advanced                         Zaawansowane
Header_Security                         Bezpiecze�stwo
Header_Magnets                          Musiki

Footer_HomePage                         Strona g��wna POPFile
Footer_Manual                           Pomoc (angielski)
Footer_Forums                           Forum dyskusyjne
Footer_FeedMe                           Wspomo�enie finansowe
Footer_RequestFeature                   Zg�o� pomys� udoskonalenia
Footer_MailingList                      Lista dyskusyjna

Configuration_Error1                    Separator musi by� jednym znakiem
Configuration_Error2                    Numer portu musi si� mie�ci� mi�dzy 1 a 65535
Configuration_Error3                    Port POP3 musi si� zawiera� mi�dzy 1 a 65535
Configuration_Error4                    Rozmiar strony musi si� zawiera� mi�dzy 1 a 1000
Configuration_Error5                    Liczba dni historii musi si� zawiera� mi�dzy 1 a 366
Configuration_Error6                    TCP timeout musi by� mi�dzy 10 a 300
Configuration_Error7                    Port XML RPC musi by� mi�dzy 1 i 65535
Configuration_POP3Port                  Port POP3
Configuration_POP3Update                Zmieniono port POP3 na %s; ta zmiana zadzia�a dopiero po restarcie POPFile'a.
Configuration_XMLRPCUpdate              Zmieniono port XML-RPC na %s; ta zmiana zadzia�a dopiero po restarcie POPFile'a
Configuration_XMLRPCPort                Port XML-RPC
Configuration_SMTPPort                  Port SMTP
Configuration_SMTPUpdate                Zmieniono port SMTP na %s; ta zmiana zadzia�a dopiero po restarcie POPFile'a
Configuration_NNTPPort                  Port NNTP
Configuration_NNTPUpdate                Zmieniono port NNTP na %s; ta zmiana zadzia�a dopiero po restarcie POPFile'a
Configuration_POP3Separator             POP3 serwer:port:u�ytkownik separator
Configuration_NNTPSeparator             NNTP serwer:port:u�ytkownik separator
Configuration_POP3SepUpdate             Zmieniono separator POP3 na %s
Configuration_NNTPSepUpdate             Zmieniono separator NNTP na %s
Configuration_UI                        Port interface'u WWW
Configuration_UIUpdate                  Zmieniono port interface'u WWW na %s; ta zmiana zadzia�a dopiero po restarcie POPFile'a
Configuration_History                   Liczba wiadomo�ci na stron�
Configuration_HistoryUpdate             Zmieniono liczb� wiadomo�ci na stron� na %s
Configuration_Days                      Liczba dni zachowania historii
Configuration_DaysUpdate                Zmieniono liczb� dni zachowania historii na %s
Configuration_UserInterface             Interface u�ytkownika
Configuration_Skins                     Wygl�d
Configuration_SkinsChoose               Wybierz wygl�d
Configuration_Language                  J�zyk
Configuration_LanguageChoose            Wybierz j�zyk
Configuration_ListenPorts               Opcje modu�u
Configuration_HistoryView               Widok historii
Configuration_TCPTimeout                Timeout po��czenia
Configuration_TCPTimeoutSecs            Timeout po��czenia w sekundach
Configuration_TCPTimeoutUpdate          Zmieniono timeout po��czenia na %s
Configuration_ClassificationInsertion   Modyfikacja nag��wk�w
Configuration_SubjectLine               Modyfikacja tematu wiadomo�ci
Configuration_XTCInsertion              Nag��wek X-Text-Classification
Configuration_XPLInsertion              Nag��wek X-POPFile-Link
Configuration_Logging                   Rejestracja czynno�ci
Configuration_None                      Brak
Configuration_ToScreen                  Ekran
Configuration_ToFile                    Plik
Configuration_ToScreenFile              Ekran i plik
Configuration_LoggerOutput              Rejestracja do:
Configuration_GeneralSkins              Wygl�d
Configuration_SmallSkins                Ma�e
Configuration_TinySkins                 Bardzo ma�e
Configuration_CurrentLogFile            &lt;aktualny plik rejestru&gt;

Advanced_Error1                         '%s' jest ju� na li�cie ignorowanych s��w
Advanced_Error2                         S�owa ignorowane mog� zawiera� znaki alfanumeryczne, ., _, -, lub @
Advanced_Error3                         S�owo '%s' dodane do listy ignorowanych s��w
Advanced_Error4                         '%s' nie jest na li�cie ignorowanych s��w
Advanced_Error5                         S�owo '%s' usuni�te z listy ignorowanych s��w
Advanced_StopWords                      Ignorowane s�owa
Advanced_Message1                       POPFile ignoruje nast�puj�ce cz�sto wystepuj�ce s�owa:
Advanced_AddWord                        Dodaj s�owo
Advanced_RemoveWord                     Usu� s�owo

History_Filter                          &nbsp;(pokazuj� folder <font color="%s">%s</font>)
History_FilterBy                        Filtruj wed�ug
History_Search                          &nbsp;(wyszukiwanie wg pola Od/Temat %s)
History_Title                           Ostatnie wiadomo�ci
History_Jump                            Id� do wiadomo�ci
History_ShowAll                         Poka� wszystko
History_ShouldBe                        Powinno by�
History_NoFrom                          brak linii Od
History_NoSubject                       brak linii Temat
History_ClassifyAs                      Klasyfikuj jako
History_MagnetUsed                      U�yto Musik
History_MagnetBecause                   <b>U�yto Musik</b><p>Zaklasyfikowano do <font color="%s">%s</font> z powodu musika %s </p>
History_ChangedTo                       Zmieniono na <font color="%s">%s
History_Already                         Ju� przeklasyfikowano jako <font color="%s">%s</font>
History_RemoveAll                       Usu� wszystkie
History_RemovePage                      Usu� stron�
History_Remove                          Aby usun�� pola ze strony kliknij (nie usuwa bazy s��w):
History_SearchMessage                   Szukaj wg p�l Od/Temat
History_NoMessages                      Brak wiadomo�ci
History_ShowMagnet                      musikowane
History_ShowNoMagnet                    odmusikowane
History_Magnet                          &nbsp;(pokazuj� wiadomo�ci z musikami)
History_NoMagnet                        &nbsp;(pokazuj� wiadomo�ci bez musik�w)
History_ResetSearch                     Resetuj

Password_Title                          Has�o
Password_Enter                          Wpisz has�o
Password_Go                             Dalej!
Password_Error1                         Z�e has�o

Security_Error1                         Port musi by� mi�dzy 1 a 65535
Security_Stealth                        Operacje w trybie niewidocznym
Security_NoStealthMode                  Nie (tryb niewidoczny)
Security_ExplainStats                   (gdy to jest w��czone POPFile wysy�a raz dziennie nast�puj�ce trzy warto�ci do skryptu na www.usethesource.com: bc (liczba folder�w, kt�re posiadasz), mc (liczba klasyfikowanych wiadomo�ci) i ec (liczba b��d�w klasyfikacji).  S� one gromadzone w pliku i wykorzystam je do publikacji o ludziach u�ywaj�cych POPFile'a i jak on dzia�a.  M�j serwer przechowuje dane przez 5 dni a nast�pnie je kasuje; Nie przechowuj� �adnych danych o adresach IP, itp.)
Security_ExplainUpdate                  (gdy to jest w��czone POPFile wysy�a raz dziennie nast�puj�ce trzy warto�ci do skryptu na www.usethesource.com: ma (numer wersji POPFile'a), mi (numer podwersji POPFile'a) i bn (numer kompilacji POPFile'a).  POPFile otrzymuje graficzn� informacj� na g��wnej stronie je�li pojawi si� nowa wersja.  M�j serwer przechowuje dane przez 5 dni a nast�pnie je kasuje; Nie przechowuj� �adnych danych o adresach IP, itp.)
Security_PasswordTitle                  Has�o interface'u u�ytkownika
Security_Password                       Has�o
Security_PasswordUpdate                 Zmieniono has�o na %s
Security_AUTHTitle                      Zdalne serwery
Security_SecureServer                   Serwer POP3 SPA/AUTH
Security_SecureServerUpdate             Zmieniono bezpieczny serwer POP3 SPA/AUTH na %s; ta zmiania zadzia�a dopiero po restarcie POPFile'a
Security_SecurePort                     Port POP3 SPA/AUTH
Security_SecurePortUpdate               Zmieniono port POP3 SPA/AUTH na %s; ta zmiania zadzia�a dopiero po restarcie POPFile'a
Security_SMTPServer                     Serwer SMTP
Security_SMTPServerUpdate               Zmieniono serwer SMTP na %s; ta zmiania zadzia�a dopiero po restarcie POPFile'a
Security_SMTPPort                       Port SMTP
Security_SMTPPortUpdate                 Zmieniono port SMTP na %s; ta zmiania zadzia�a dopiero po restarcie POPFile'a
Security_POP3                           Akceptuj po��czenia POP3 ze zdalnych komputer�w (wymaga restartu POPFile'a)
Security_SMTP                           Akceptuj po��czenia SMTP ze zdalnych komputer�w (wymaga restartu POPFile'a)
Security_NNTP                           Akceptuj po��czenia NNTP ze zdalnych komputer�w (wymaga restartu POPFile'a)
Security_UI                             Akceptuj po��czenia HTTP (Interface u�ytkownika) ze zdalnych komputer�w (wymaga restartu POPFile'a)
Security_XMLRPC                         Akceptuj po��czenia XML-RPC ze zdalnych komputer�w (wymaga restartu POPFile'a)
Security_UpdateTitle                    Sprawdzanie automatycznej aktualizacji
Security_Update                         Sprawd� codziennie zmiany w POPFile'u
Security_StatsTitle                     Statystyki
Security_Stats                          Wysy�aj statystyki codziennie

Magnet_Error1                           Musik '%s' ju� wyst�puje w folderze '%s'
Magnet_Error2                           Nowy musik '%s' jest niezgodny z musikiem '%s' w folderze '%s' i mo�e spowodowa� problemy. Nie dodano nowego musika.
Magnet_Error3                           Utw�rz nowy musik '%s' w folderze '%s'
Magnet_CurrentMagnets                   Aktualne musiki
Magnet_Message1                         Nast�puj�ce musiki spowoduj� klasyfikacj� list�w zawsze w okre�lonych folderach.
Magnet_CreateNew                        Utw�rz nowy musik
Magnet_Explanation                      Nast�puj�ce rodzaje musik�w s� dost�pne:</b> <ul><li><b>Adres lub nazwa nadawcy:</b> na przyk�ad: john@company.com dotyczy konkretnego adresu, <br />company.com dotyczy wszystkich nadawc�w z company.com, <br />John Doe dotyczy konkretnej osoby, John dotyczy wszystkich John�w</li><li><b>Adres lub nazwa Do/Cc:</b> Jak w przypadku pola Od, ale dotyczy p�l Do:/Cc: </li> <li><b>S�owa w temacie:</b> na przyk�ad: hello dotyczy wszystkich wiadomo�ci z hello w temacie</li></ul>
Magnet_MagnetType                       Rodzaj musika
Magnet_Value                            Warto��
Magnet_Always                           Zawsze idzie do folderu
Magnet_Jump                             Id� do strony musik�w

Bucket_Error1                           Nazwy folder�w mog� zawiera� tylko ma�e litery od a do z, cyfry 0 do 9,  oraz - i _
Bucket_Error2                           Folder %s ju� istnieje
Bucket_Error3                           Utworzono folder %s
Bucket_Error4                           Prosz� wpisa� w�a�ciwe s�owo
Bucket_Error5                           Zmieniono nazw� folderu %s na %s
Bucket_Error6                           Usuni�to folder %s
Bucket_Title                            Podsumowanie
Bucket_BucketName                       Nazwa folderu
Bucket_WordCount                        Liczba s��w
Bucket_WordCounts                       Zliczanie s��w
Bucket_UniqueWords                      Unikatowe s�owa
Bucket_SubjectModification              Modyfikacja tematu wiadomo�ci
Bucket_ChangeColor                      Zmie� kolor
Bucket_NotEnoughData                    Brak wystarczaj�cych danych
Bucket_ClassificationAccuracy           Poprawno�� klasyfikacji
Bucket_EmailsClassified                 Wiadomo�ci zaklasyfikowane
Bucket_EmailsClassifiedUpper            Wiadomo�ci zaklasyfikowane
Bucket_ClassificationErrors             B��dy klasyfikacji
Bucket_Accuracy                         Poprawno��
Bucket_ClassificationCount              Liczba klasyfikacji
Bucket_ClassificationFP                 B��d dodania
Bucket_ClassificationFN                 B��d niedodania
Bucket_ResetStatistics                  Resetuj
Bucket_LastReset                        Ostatni reset
Bucket_CurrentColor                     %s obecny kolor to %s
Bucket_SetColorTo                       Ustaw kolor %s na %s
Bucket_Maintenance                      Utrzymanie
Bucket_CreateBucket                     Utw�rz folder o nazwie
Bucket_DeleteBucket                     Usu� folder o nazwie
Bucket_RenameBucket                     Zmie� nazw� folderu
Bucket_Lookup                           Szukaj
Bucket_LookupMessage                    Szukaj s�owa w folderze
Bucket_LookupMessage2                   Szukaj dla
Bucket_LookupMostLikely                 List ze s�owem <b>%s</b> prawdopodobnie powinien si� znale�� w <font color="%s">%s</font>
Bucket_DoesNotAppear                    <p><b>%s</b> nie wystepuje w �adnym folderze
Bucket_DisabledGlobally                 Zablokowane globalnie
Bucket_To                               do
Bucket_Quarantine                       Kwarantanna

SingleBucket_Title                      Szczeg�y dla %s
SingleBucket_WordCount                  Liczba s��w w folderze
SingleBucket_TotalWordCount             Ca�kowita liczba s��w
SingleBucket_Percentage                 Procent ca�o�ci
SingleBucket_WordTable                  Tabela s��w dla %s
SingleBucket_Message1                   Kliknij liter� w indeksie, aby zobaczy� list� s��w rozpoczynaj�cych si� od tej litery.  Kliknij na dowolne s�owo, aby zobaczy� jego rozk�ad prawdopodobie�stwa.
SingleBucket_Unique                     S�owo %s jest unikatowe
SingleBucket_ClearBucket                Usu� wszystkie s�owa

Session_Title                           Sesja POPFile'a zosta�a zako�czona
Session_Error                           Twoja sesja POPFile'a zosta�a zako�czona.  Mog�o si� to zdarzy� w wyniku restartu POPFile'a lub zamkni�cia przegl�darki. Kliknij na jeden z powy�szych link�w.

View_Title                              Widok pojedynczej wiadomo�ci

Header_MenuSummary                      Ta tabela pozwala na dost�p do r�nych element�w centrum sterowania.
History_MainTableSummary                Ta tabela pokazuje nadawc�w i tematy odstatnio odebranych wiadomo�ci i pozwala na reklasyfikacj�.  Klikni�cie na temat spowoduje pokazanie ca�ej wiadomo�ci, wraz z informacj� o powodach klasyfikacji.  Kolumna 'Powinno by�' pozwala na okre�lenie w�a�ciwego folderu lub cofni�cie operacji. Kolumna 'Usu�' pozwala usun�� okre�lone wiadomo�ci z historii, je�li ich ju� nie potrzebujesz.
History_OpenMessageSummary              Ta tabela zawiera pe�ny tekst wiadomo�ci, ze s�owami u�ytymi do klasyfikacji pod�wietlonymi w kolorze folderu, do kt�rego najlepiej pasuj�.
Bucket_MainTableSummary                 Ta tabela pokazuje przegl�d folder�w klasyfikacyjnych.  Ka�dy wiersz pokazuje nazw� folderu, liczb� s��w w nim zawartych, liczb� niepowtarzalnych s��w w folderze, mo�liwo�� zmiany tematu wiadomo�ci po zaklasyfikowaniu do folderu, opcj� kwarantanny oraz tabel� kolor�w wy�wietlania (do wyboru).
Bucket_StatisticsTableSummary           Ta tabela przedstawia trzy rodzaje statystyk dzia�ania POPFile'a.  Pierwsza okre�la poprawno�� klasyfikacji, druga liczb� zaklasyfikowanych wiadomo�ci do poszczeg�lnych folder�w, a trzecia liczb� s��w w folderach i ich udzia� w ca�ej liczbie.
Bucket_MaintenanceTableSummary          Ta tabela zawiera formularz do tworzenia, zmiany i usuwania folder�w oraz wyszukiwania s��w w folderach, a tak�e pokazywania rozk�ad�w prawdopodobie�stwa.
Bucket_AccuracyChartSummary             Ta tabela pokazuje graficznie poprawno�� klasyfikacji
Bucket_BarChartSummary                  Ta tabela pokazuje graficznie rozk�ad procentowy dla ka�dego folderu.  Jest wykorzystywana do pokazywania liczby wiadomo�ci i liczby s��w.
Bucket_LookupResultsSummary             Ta tabela pokazuje rozk�ad prawdopodobie�stwa dla ka�dego s�owa.  Dla ka�dego folderu, pokazuje cz�stotliwo�� wyst�powania s�owa, prawdopodobie�stwo wyst�pienia w folderze, oraz og�lny wp�yw na wynik, je�li s�owo wyst�pi w wiadomo�ci.
Bucket_WordListTableSummary             Ta tabela przedstawia alfabetycznie list� s��w w folderach.
Magnet_MainTableSummary                 Ta tabela pokazuje list� musik�w klasyfikuj�cych automatycznie wiadomo�ci zgodnie z przyj�tymi na sztywno zasadami.  W ka�dym wierszu znajduje si� musik, przypisany folder oraz przycisk do usuni�cia musika.
Configuration_MainTableSummary          Ta tabela zawiera fomularze do konfigurowania POPFile'a.
Configuration_InsertionTableSummary     Ta tabela zawiera prze��czniki okreslaj�ce czy dokonywa� zmian w nag��wkach wiadomo�ci przy przesy�aniu do programu pocztowego.
Security_MainTableSummary               Ta tabela zawiera kontrolki ustawiaj�ce bezpiecze�stwo POPFile'a, mo�liwo�� sprawdzania aktualizacji oraz mo�liwo�� wysy�ania statystyk o dzia�aniu POPFile'a do centralnego rejestru programu znajduj�cego si� na serwerze autora.
Advanced_MainTableSummary               Ta tabela zawiera list� s��w ignorowanych przez POPFile'a w traksie klasyfikacji wiadomo�ci z powodu ich cz�stego wyst�powania.  S� one zorganizowane wierszami, alfabetycznie..

