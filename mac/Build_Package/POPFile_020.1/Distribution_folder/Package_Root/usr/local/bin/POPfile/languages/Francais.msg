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
LanguageCode                            fr
LanguageCharset                         ISO-8859-1
LanguageDirection                       ltr

# This is used to get the appropriate subdirectory for the manual
ManualLanguage                          fr

# Common words that are used on their own all over the interface
Apply                                   Appliquer
On                                      Actif
Off                                     Inactif
TurnOn                                  Activer
TurnOff                                 D�sactiver
Add                                     Ajouter
Remove                                  Retirer
Previous                                Pr�c�dent
Next                                    Suivant
From                                    De
Subject                                 Sujet
Classification                          Classification
Reclassify                              Reclassifier
Undo                                    Annuler
Close                                   Fermer
Find                                    Chercher
Filter                                  Filtrer
Yes                                     Oui
No                                      Non
ChangeToYes                             Passer � Oui
ChangeToNo                              Passer � Non
Bucket                                  Cat�gorie
Magnet                                  Aimant
Delete                                  Supprimer
Create                                  Cr�er
To                                      A
Total                                   Total
Rename                                  Renommer
Frequency                               Fr�quence
Probability                             Probabilit�
Score                                   Score
Lookup                                  Consulter

# The header and footer that appear on every UI page
Header_Title                            Centre de Commande de POPFile
Header_Shutdown                         Arr�ter POPFile
Header_History                          Historique
Header_Buckets                          Cat�gories
Header_Configuration                    Configuration
Header_Advanced                         Avanc�
Header_Security                         S�curit�
Header_Magnets                          Aimants

Footer_HomePage                         Site web de POPFile
Footer_Manual                           Manuel
Footer_Forums                           Forums
Footer_FeedMe                           Encouragez-moi!
Footer_RequestFeature                   Demande d'�volution
Footer_MailingList                      Liste de diffusion

Configuration_Error1                    Le caract�re s�parateur doit �tre un unique caract�re
Configuration_Error2                    Le port de l'interface utilisateur doit �tre un nombre compris entre 1 et 65535
Configuration_Error3                    Le port d'�coute POP3 doit �tre un nombre compris entre 1 et 65535
Configuration_Error4                    La taille de page doit �tre un nombre compris entre 1 et 1000
Configuration_Error5                    Le nombre de jours d'historique doit �tre un nombre compris entre 1 et 366
Configuration_Error6                    Le d�lai d'expiration TCP doit �tre un nombre compris entre 10 et 300
Configuration_POP3Port                  Port d'�coute POP3
Configuration_POP3Update                Port pass� � %s; ce changement ne prendra effet qu'au prochain red�marrage de POPFile
Configuration_Separator                 S�parateur
Configuration_SepUpdate                 S�parateur chang� en %s
Configuration_UI                        Port web d'interface utilisateur
Configuration_UIUpdate                  Port web d'interface utilisateur pass� � %s; ce changement ne prendra effet qu'au prochain red�marrage de POPFile
Configuration_History                   Nombre de messages par page
Configuration_HistoryUpdate             Nombre de messages par page pass� � %s
Configuration_Days                      Nombre de jours d'historique � conserver
Configuration_DaysUpdate                Nombre de jours d'historique pass� � %s
Configuration_UserInterface             Interface Utilisateur
Configuration_Skins                     Apparences
Configuration_SkinsChoose               Choisir une apparence
Configuration_Language                  Langue
Configuration_LanguageChoose            Choisir une langue
Configuration_ListenPorts               Ports d'Ecoute
Configuration_HistoryView               Pages d'Historique
Configuration_TCPTimeout                D�lai d'Expiration de Connexion TCP
Configuration_TCPTimeoutSecs            D�lai d'expiration de connexion TCP en secondes
Configuration_TCPTimeoutUpdate          D�lai d'expiration de connexion TCP pass� � %s
Configuration_ClassificationInsertion   Informations de Classification
Configuration_SubjectLine               Modification de la ligne Sujet
Configuration_XTCInsertion              Insertion de X-Text-Classification
Configuration_XPLInsertion              Insertion de X-POPFile-Link
Configuration_Logging                   Journalisation
Configuration_None                      auncune
Configuration_ToScreen                  � l'�cran
Configuration_ToFile                    dans un fichier
Configuration_ToScreenFile              �cran et fichier
Configuration_LoggerOutput              Sortie
Configuration_GeneralSkins              Skins
Configuration_SmallSkins                Small Skins
Configuration_TinySkins                 Tiny Skins

Advanced_Error1                         '%s' est d�j� dans la liste des mots ignor�s
Advanced_Error2                         Les mots ignor�s ne peuvent contenir que des caract�res alphanum�riques ou ., _, -, @
Advanced_Error3                         '%s' ajout� � la liste des mots ignor�s
Advanced_Error4                         '%s' n'est pas dans la liste des mots ignor�s
Advanced_Error5                         '%s' retir� de la liste des mots ignor�s
Advanced_StopWords                      Mots ignor�s
Advanced_Message1                       Les mots suivants sont ignor�s dans toutes les classifications comme ils apparaissent tr�s souvent.
Advanced_AddWord                        Ajouter un mot
Advanced_RemoveWord                     Retirer un mot

History_Filter                          &nbsp;(ne montrant que la cat�gorie <font color="%s">%s</font>)
History_FilterBy                        Filter By
History_Search                          &nbsp;(recherche du sujet %s)
History_Title                           Messages r�cents
History_Jump                            Aller au message
History_ShowAll                         Tout afficher
History_ShouldBe                        Devrait �tre
History_NoFrom                          pas de ligne De
History_NoSubject                       pas de ligne Sujet
History_ClassifyAs                      Classifi� comme
History_MagnetUsed                      Aimant utilis�
History_ChangedTo                       Chang� en <font color="%s">%s
History_Already                         D�j� reclassifi� comme <font color="%s">%s</font>
History_RemoveAll                       Supprimer tout
History_RemovePage                      Supprimer page
History_Remove                          Pour supprimer des entr�es dans l'historique cliquez
History_SearchMessage                   Chercher De/Sujet
History_NoMessages                      Pas de messages
History_ShowMagnet                      Aimant�
History_Magnet                          &nbsp;(ne montrant que les messages classifi�s par aimant)
History_ResetSearch                     Initialiser

Password_Title                          Mot de Passe
Password_Enter                          Entrez le mot de passe
Password_Go                             Continuer
Password_Error1                         Mot de passe incorrect

Security_Error1                         Le port s�curis� doit �tre un nombre compris entre 1 et 65535
Security_Stealth                        Mode Furtif/Fonctionnement du Serveur
Security_NoStealthMode                  Non (Mode Furtif)
Security_ExplainStats                   (Quand ceci est activ� POPFile envoie une fois par jour les trois valeurs suivantes � un script � www.usethesource.com: bc (le nombre total de vos cat�gories), mc (le nombre total de messages classifi�s par POPFile) et ec (le nombre total d'erreurs de classification).  Elles sont alors stock�es dans un fichier que j'utiliserai pour publier quelques statistiques sur comment les gens utilisent POPFile et si �a marche bien.  Mon serveur web conserve ses fichiers log pendant environ 5 jours puis les efface; je ne recueille aucun lien entre les statisques et les adresses IP individuelles.)
Security_ExplainUpdate                  (Quand ceci est activ� POPFile envoie une fois par jour les trois valeurs suivantes � un script � www.usethesource.com: ma (le num�ro de version principal de votre POPFile), mi (le num�ro de version secondaire de votre POPFile) et bn (le num�ro de compilation de votre POPFile).  POPFile re�oit une r�ponse sous la forme d'un graphique qui appara�t en haut de la page si une version plus r�cente est disponible.  Mon serveur web conserve ses fichiers log pendant environ 5 jours puis les efface; je ne recueille aucun lien entre les contr�les de mise � jour et les adresses IP individuelles.)
Security_PasswordTitle                  Mot de passe de l'interface utilisateur
Security_Password                       Mot de passe
Security_PasswordUpdate                 Mot de passe chang� en %s
Security_AUTHTitle                      Authentification par mot de passe s�curis�/AUTH
Security_SecureServer                   Serveur s�curis�
Security_SecureServerUpdate             Serveur s�curis� pass� � %s; ce changement ne prendra effet qu'au prochain red�marrage de POPFile
Security_SecurePort                     Port s�curis�
Security_SecurePortUpdate               Port s�curis� pass� � %s; ce changement ne prendra effet qu'au prochain red�marrage de POPFile
Security_POP3                           Accepter les connexions POP3 de machines distantes
Security_UI                             Accepter les connexions HTTP (Interface Utilisateur) de machines distantes
Security_UpdateTitle                    Contr�le automatique de mise � jour
Security_Update                         V�rifier quotidiennement les mises � jour de POPFile
Security_StatsTitle                     Compte-rendu de statistiques
Security_Stats                          Envoyer quotidiennement des statistiques � John

Magnet_Error1                           L'aimant '%s' existe d�j� pour la cat�gorie '%s'
Magnet_Error2                           Le nouvel aimant '%s' interf�re avec l'aimant '%s' de la cat�gorie '%s' et pourrait causer des r�sultats ambig�es.  Le nouvel aimant n'est pas ajout�.
Magnet_Error3                           Nouvel aimant '%s' cr�� pour la cat�gorie '%s'
Magnet_CurrentMagnets                   Aimants actuels
Magnet_Message1                         Les aimants suivants entrainent la classification syst�matique d'un message dans la cat�gorie sp�cifi�e.
Magnet_CreateNew                        Cr�er un nouvel aimant
Magnet_Explanation                      Trois types d'aimants sont disponibles:</b> <ul><li><b>Adresse ou nom de l'exp�diteur:</b> Par exemple: john@company.com pour capter une adresse sp�cifique, <br />company.com pour capter les messages de tous les exp�diteurs de company.com, <br />John Doe pour capter une personne en particulier, John pour capter tous les John</li><li><b>Adresse ou nom du destinataire:</b> Comme un aimant De: mais pour l'adresse du destinataire du message</li><li><b>Mots du sujet:</b> Par exemple: bonjour pour capter tous les messages avec bonjour dans le sujet</li></ul>
Magnet_MagnetType                       Type d'aimant
Magnet_Value                            Valeur
Magnet_Always                           Toujours envoyer dans la cat�gorie

Bucket_Error1                           Les noms de cat�gories ne peuvent contenir que les minuscules de a to z ainsi que - and _
Bucket_Error2                           La cat�gorie nomm�e %s existe d�j�
Bucket_Error3                           Cat�gorie nomm�e %s cr��e
Bucket_Error4                           Veuillez entrer un mot non blanc
Bucket_Error5                           Cat�gorie %s renomm�e en %s
Bucket_Error6                           Cat�gorie %s effac�e
Bucket_Title                            R�sum�
Bucket_BucketName                       Nom de cat�gorie
Bucket_WordCount                        Nombre de mots
Bucket_WordCounts                       Nombres de Mots
Bucket_UniqueWords                      Mots distincts
Bucket_SubjectModification              Modification du sujet
Bucket_ChangeColor                      Changer la couleur
Bucket_NotEnoughData                    Pas assez de donn�es
Bucket_ClassificationAccuracy           Performance de Classification
Bucket_EmailsClassified                 Messages classifi�s
Bucket_EmailsClassifiedUpper            Messages Classifi�s
Bucket_ClassificationErrors             Erreurs de classification
Bucket_Accuracy                         Performance
Bucket_ClassificationCount              Nombre de classifications
Bucket_ResetStatistics                  Initialiser les statisques
Bucket_LastReset                        Derni�re initialisation
Bucket_CurrentColor                     La couleur actuelle de %s est %s
Bucket_SetColorTo                       Changer la couleur de %s en %s
Bucket_Maintenance                      Maintenance
Bucket_CreateBucket                     Cr�er une cat�gorie nomm�e
Bucket_DeleteBucket                     Effacer la cat�gorie nomm�e
Bucket_RenameBucket                     Renommer la cat�gorie nomm�e
Bucket_Lookup                           Examiner
Bucket_LookupMessage                    Examiner le mot dans les cat�gories
Bucket_LookupMessage2                   Examiner le r�sultat pour
Bucket_LookupMostLikely                 <b>%s</b> a le plus de chance d'appara�tre dans <font color="%s">%s</font>
Bucket_DoesNotAppear                    <p><b>%s</b> n'appara�t dans aucune cat�gorie
Bucket_DisabledGlobally                 D�sactiv� globalement
Bucket_To                               en
Bucket_Quarantine                       Mise en quarantaine

SingleBucket_Title                      D�tail pour %s
SingleBucket_WordCount                  Nombre de mots de la cat�gorie
SingleBucket_TotalWordCount             Nombre total de mots
SingleBucket_Percentage                 Pourcentage du total
SingleBucket_WordTable                  Table des mots pour %s
SingleBucket_Message1                   Les mots signal�s (*) ont �t� utilis�s pour la classification dans cette session POPFile.  Cliquez sur un mot pour examiner sa probabilit� pour tous les cat�gories.
SingleBucket_Unique                     %s seul

Session_Title                           Session POPFile expir�e
Session_Error                           Votre session POPFile a expir�.  Cela peut �tre d� � un arr�t/relance de POPFile alors que le navigateur est rest� ouvert.  Veuillez cliquer sur l'un des liens ci-dessus pour continuer � utiliser POPFile.

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

