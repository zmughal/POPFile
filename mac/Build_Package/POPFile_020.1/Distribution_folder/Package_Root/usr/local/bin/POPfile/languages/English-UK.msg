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
LanguageCode                            en
LanguageCharset                         ISO-8859-1
LanguageDirection                       ltr

# This is used to get the appropriate subdirectory for the manual
ManualLanguage                          en

# Common words that are used on their own all over the interface
Apply                                   Apply
On                                      On
Off                                     Off
TurnOn                                  Turn On
TurnOff                                 Turn Off
Add                                     Add
Remove                                  Remove
Previous                                Previous
Next                                    Next
From                                    From
Subject                                 Subject
Cc                                      Cc 
Classification                          Classification
Reclassify                              Reclassify
Probability                             Probability
Scores                                  Scores
QuickMagnets                            QuickMagnets
Undo                                    Undo
Close                                   Close
Find                                    Find
Filter                                  Filter
Yes                                     Yes
No                                      No
ChangeToYes                             Change to Yes
ChangeToNo                              Change to No
Bucket                                  Bucket
Magnet                                  Magnet
Delete                                  Delete
Create                                  Create
To                                      To
Total                                   Total
Rename                                  Rename
Frequency                               Frequency
Probability                             Probability
Score                                   Score
Lookup                                  Lookup
Word                                    Word
Count                                   Count
Update                                  Update
Refresh                                 Refresh

# The header and footer that appear on every UI page
Header_Title                            POPFile Control Centre
Header_Shutdown                         Shutdown POPFile
Header_History                          History
Header_Buckets                          Buckets
Header_Configuration                    Configuration
Header_Advanced                         Advanced
Header_Security                         Security
Header_Magnets                          Magnets

Footer_HomePage                         POPFile Home Page
Footer_Manual                           Manual
Footer_Forums                           Forums
Footer_FeedMe                           Donate
Footer_RequestFeature                   Request Feature
Footer_MailingList                      Mailing List

Configuration_Error1                    The separator character must be a single character
Configuration_Error2                    The user interface port must be a number between 1 and 65535
Configuration_Error3                    The POP3 listen port must be a number between 1 and 65535
Configuration_Error4                    The page size must be a number between 1 and 1000
Configuration_Error5                    The number of days in the history must be a number between 1 and 366
Configuration_Error6                    The TCP timeout must be a number between 10 and 300
Configuration_Error7                    The XML RPC listen port must be a number between 1 and 65535
Configuration_POP3Port                  POP3 listen port
Configuration_POP3Update                Updated POP3 port to %s; this change will not take affect until you restart POPFile
Configuration_XMLRPCUpdate              Updated XML-RPC port to %s; this change will not take affect until you restart POPFile
Configuration_XMLRPCPort                XML-RPC listen port
Configuration_SMTPPort                  SMTP listen port
Configuration_SMTPUpdate                Updated SMTP port to %s; this change will not take affect until you restart POPFile
Configuration_NNTPPort                  NNTP listen port
Configuration_NNTPUpdate                Updated NNTP port to %s; this change will not take affect until you restart POPFile
Configuration_POP3Separator             POP3 host:port:user separator character
Configuration_NNTPSeparator             NNTP host:port:user separator character
Configuration_POP3SepUpdate             Updated POP3 separator to %s
Configuration_NNTPSepUpdate             Updated NNTP separator to %s
Configuration_UI                        User interface web port
Configuration_UIUpdate                  Updated user interface web port to %s; this change will not take affect until you restart POPFile
Configuration_History                   Number of messages per page
Configuration_HistoryUpdate             Updated number of messages per page to %s
Configuration_Days                      Number of days of history to keep
Configuration_DaysUpdate                Updated number of days of history to %s
Configuration_UserInterface             User Interface
Configuration_Skins                     Skins
Configuration_SkinsChoose               Choose skin
Configuration_Language                  Language
Configuration_LanguageChoose            Choose language
Configuration_ListenPorts               Module Options
Configuration_HistoryView               History View
Configuration_TCPTimeout                Connection Timeout
Configuration_TCPTimeoutSecs            Connection timeout in seconds
Configuration_TCPTimeoutUpdate          Updated connection timeout to %s
Configuration_ClassificationInsertion   Message Text Insertion
Configuration_SubjectLine               Subject line modification
Configuration_XTCInsertion              X-Text-Classification Header
Configuration_XPLInsertion              X-POPFile-Link Header
Configuration_Logging                   Logging
Configuration_None                      None
Configuration_ToScreen                  To Screen
Configuration_ToFile                    To File
Configuration_ToScreenFile              To Screen and File
Configuration_LoggerOutput              Logger output
Configuration_GeneralSkins              Skins
Configuration_SmallSkins                Small Skins
Configuration_TinySkins                 Tiny Skins
Configuration_CurrentLogFile            &lt;current log file&gt;

Advanced_Error1                         '%s' already in the Ignored Words list
Advanced_Error2                         Ignored words can only contain alphanumeric, ., _, -, or @ characters
Advanced_Error3                         '%s' added to the Ignored Words list
Advanced_Error4                         '%s' is not in the Ignored Words list
Advanced_Error5                         '%s' removed from the Ignored Words list
Advanced_StopWords                      Ignored Words
Advanced_Message1                       POPFile ignores the following frequently-used words:
Advanced_AddWord                        Add word
Advanced_RemoveWord                     Remove word

History_Filter                          &nbsp;(just showing bucket <font color="%s">%s</font>)
History_FilterBy                        Filter By
History_Search                          &nbsp;(searched for from/subject %s)
History_Title                           Recent Messages
History_Jump                            Jump to message
History_ShowAll                         Show All
History_ShouldBe                        Should be
History_NoFrom                          no from line
History_NoSubject                       no subject line
History_ClassifyAs                      Classify as
History_MagnetUsed                      Magnet used
History_MagnetBecause                   <b>Magnet Used</b><p>Classified to <font color="%s">%s</font> because of magnet %s </p>
History_ChangedTo                       Changed to <font color="%s">%s
History_Already                         Reclassified as <font color="%s">%s</font>
History_RemoveAll                       Remove All
History_RemovePage                      Remove Page
History_Remove                          To remove entries in the history click
History_SearchMessage                   Search From/Subject
History_NoMessages                      No messages
History_ShowMagnet                      magnetized
History_ShowNoMagnet                    unmagnetized
History_Magnet                          &nbsp;(just showing magnet classified messages)
History_NoMagnet                        &nbsp;(just showing non-magnet classified messages)
History_ResetSearch                     Reset

Password_Title                          Password
Password_Enter                          Enter password
Password_Go                             Go!
Password_Error1                         Incorrect password

Security_Error1                         The port must be a number between 1 and 65535
Security_Stealth                        Stealth Mode/Server Operation
Security_NoStealthMode                  No (Stealth Mode)
Security_ExplainStats                   (With this turned on POPFile sends once per day the following three values to a script on www.usethesource.com: bc (the total number of buckets that you have), mc (the total number of messages that POPFile has classified) and ec (the total number of classification errors).  These get stored in a file and I will use this to publish some statistics about how people use POPFile and how well it works.  My web server keeps its log files for about 5 days and then they get deleted; I am not storing any connection between the statistics and individual IP addresses.)
Security_ExplainUpdate                  (With this turned on POPFile sends once per day the following three values to a script on www.usethesource.com: ma (the major version number of your installed POPFile), mi (the minor version number of your installed POPFile) and bn (the build number of your installed POPFile).  POPFile receives a response in the form of a graphic that appears at the top of the page if a new version is available.  My web server keeps its log files for about 5 days and then they get deleted; I am not storing any connection between the update checks and individual IP addresses.)
Security_PasswordTitle                  User Interface Password
Security_Password                       Password
Security_PasswordUpdate                 Updated password to %s
Security_AUTHTitle                      Remote Servers
Security_SecureServer                   POP3 SPA/AUTH server
Security_SecureServerUpdate             Updated POP3 SPA/AUTH secure server to %s; this change will not take affect until you restart POPFile
Security_SecurePort                     POP3 SPA/AUTH port
Security_SecurePortUpdate               Updated POP3 SPA/AUTH port to %s; this change will not take affect until you restart POPFile
Security_SMTPServer                     SMTP chain server
Security_SMTPServerUpdate               Updated SMTP chain server to %s; this change will not take affect until you restart POPFile
Security_SMTPPort                       SMTP chain port
Security_SMTPPortUpdate                 Updated SMTP chain port to %s; this change will not take affect until you restart POPFile
Security_POP3                           Accept POP3 connections from remote machines (requires POPFile restart)
Security_SMTP                           Accept SMTP connections from remote machines (requires POPFile restart)
Security_NNTP                           Accept NNTP connections from remote machines (requires POPFile restart)
Security_UI                             Accept HTTP (User Interface) connections from remote machines  (requires POPFile restart)
Security_XMLRPC                         Accept XML-RPC connections from remote machines (requires POPFile restart)
Security_UpdateTitle                    Automatic Update Checking
Security_Update                         Check daily for updates to POPFile
Security_StatsTitle                     Reporting Statistics
Security_Stats                          Send statistics daily

Magnet_Error1                           Magnet '%s' already exists in bucket '%s'
Magnet_Error2                           New magnet '%s' clashes with magnet '%s' in bucket '%s' and could cause ambiguous results.  New magnet was not added.
Magnet_Error3                           Create new magnet '%s' in bucket '%s'
Magnet_CurrentMagnets                   Current Magnets
Magnet_Message1                         The following magnets cause mail to always be classified into the specified bucket.
Magnet_CreateNew                        Create New Magnet
Magnet_Explanation                      These types of magnets are available:</b> <ul><li><b>From address or name:</b> For example: john@company.com to match a specific address, <br />company.com to match everyone who sends from company.com, <br />John Doe to match a specific person, John to match all Johns</li><li><b>To/Cc address or name:</b> Like a From: magnet but for the To:/Cc: address in a message</li> <li><b>Subject words:</b> For example: hello to match all messages with hello in the subject</li></ul>
Magnet_MagnetType                       Magnet type
Magnet_Value                            Value
Magnet_Always                           Always goes to bucket
Magnet_Jump                             Jump to magnet page

Bucket_Error1                           Bucket names can only contain the letters a to z in lower case, numbers 0 to 9,  plus - and _
Bucket_Error2                           Bucket named %s already exists
Bucket_Error3                           Created bucket named %s
Bucket_Error4                           Please enter a non-blank word
Bucket_Error5                           Renamed bucket %s to %s
Bucket_Error6                           Deleted bucket %s
Bucket_Title                            Summary
Bucket_BucketName                       Bucket Name
Bucket_WordCount                        Word Count
Bucket_WordCounts                       Word Counts
Bucket_UniqueWords                      Unique Words
Bucket_SubjectModification              Subject Modification
Bucket_ChangeColor                      Change Colour
Bucket_NotEnoughData                    Not enough data
Bucket_ClassificationAccuracy           Classification Accuracy
Bucket_EmailsClassified                 Messages classified
Bucket_EmailsClassifiedUpper            Messages Classified
Bucket_ClassificationErrors             Classification errors
Bucket_Accuracy                         Accuracy
Bucket_ClassificationCount              Classification Count
Bucket_ClassificationFP                 False Positives
Bucket_ClassificationFN                 False Negatives
Bucket_ResetStatistics                  Reset Statistics
Bucket_LastReset                        Last Reset
Bucket_CurrentColor                     %s current colour is %s
Bucket_SetColorTo                       Set %s colour to %s
Bucket_Maintenance                      Maintenance
Bucket_CreateBucket                     Create bucket with name
Bucket_DeleteBucket                     Delete bucket named
Bucket_RenameBucket                     Rename bucket named
Bucket_Lookup                           Lookup
Bucket_LookupMessage                    Lookup word in buckets
Bucket_LookupMessage2                   Lookup result for
Bucket_LookupMostLikely                 <b>%s</b> is most likely to appear in <font color="%s">%s</font>
Bucket_DoesNotAppear                    <p><b>%s</b> does not appear in any of the buckets
Bucket_DisabledGlobally                 Disabled globally
Bucket_To                               to
Bucket_Quarantine                       Quarantine

SingleBucket_Title                      Detail for %s
SingleBucket_WordCount                  Bucket word count
SingleBucket_TotalWordCount             Total word count
SingleBucket_Percentage                 Percentage of total
SingleBucket_WordTable                  Word Table for %s
SingleBucket_Message1                   Click a letter in the index to see the list of words that start with that letter.  Click any word to lookup its probability for all buckets.
SingleBucket_Unique                     %s unique
SingleBucket_ClearBucket                Remove All Words

Session_Title                           POPFile Session Expired
Session_Error                           Your POPFile session has expired.  This could have been caused by starting and stopping POPFile but leaving your web browser open.  Please click one of the links above to continue using POPFile.

View_Title                              Single Message View

Header_MenuSummary                      This table is the navigation menu which allows access to each of the different pages of the control centre.
History_MainTableSummary                This table shows the sender and subject of recently received messages and allows them to be reviewed and reclassified.  Clicking on the subject line will show the full message text, along with information about why it was classified as it was.  The 'Should be' column allows you to specify which bucket the message belongs in, or to undo that change.  The 'Delete' column allows you to delete specific messages from the history if you don't need them anymore.
History_OpenMessageSummary              This table contains the full text of a message message, with the words that are used for classification highlighted according to the bucket that was most relevant for each.
Bucket_MainTableSummary                 This table provides an overview of the classification buckets.  Each row shows the bucket name, the word count total for that bucket, the actual number of individual words in each bucket, whether the message's subject line will be modified when it gets classified to that bucket, whether to quarantine the messages received in that bucket, and a table to pick the colour used in displaying anything related to that bucket in the control centre.
Bucket_StatisticsTableSummary           This table provides three sets of statistics on the overall performance of POPFile.  The first is how accurate its classification is, the second is how many messages have been classified, and to which buckets, and the third is how many words are in each bucket, and what their relative percentages are.
Bucket_MaintenanceTableSummary          This table contains forms that allow you to create, delete or rename buckets, and to lookup a word in all of the buckets to see its relative probabilities.
Bucket_AccuracyChartSummary             This table graphically represents the accuracy of the message classification.
Bucket_BarChartSummary                  This table graphically represents a percentage allocation for each of the different buckets.  It is used for both number of messages classified, and total word counts.
Bucket_LookupResultsSummary             This table shows the probabilities associated with any given word of the corpus.  For each bucket, it shows the frequency that that word occurs, the probability that it will occur in that bucket, and the overall effect on the score of the bucket if that word exists in a message.
Bucket_WordListTableSummary             This table provides a listing of all the words for a particular bucket, organized by common first letter for each row.
Magnet_MainTableSummary                 This table shows the list of magnets that are used to automatically classify message according to fixed rules.  Each row shows how the magnet is defined, what bucket it is intended for, and a button to delete the magnet.
Configuration_MainTableSummary          This table contains a number of forms to allow you to control the configuration of POPFile.
Configuration_InsertionTableSummary     This table contains buttons that determine whether or not certain modifications are made to the headers or subject line of the message before it is passed on to the message client.
Security_MainTableSummary               This table provides sets of controls that affect the security of the overall configuration of POPFile, whether it should automatically check for updates to the program, and whether statistics about POPFile's performance should be sent to the central datastore of the program's author for general information.
Advanced_MainTableSummary               This table provides a list of words that POPFile ignores when classifying message due to their relative frequency in message in general.  They are organized per row according to the first letter of the words.

