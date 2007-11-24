#--------------------------------------------------------------------------
# English-parser.nsh
#
# This file contains the "English" text strings used by the special
# "English only" build of the Windows installer for POPFile. This
# special build only uses English text, unlike the normal multi-language
# build of the installer.
#
# Copyright (c) 2007 John Graham-Cumming
#
#   This file is part of POPFile
#
#   POPFile is free software; you can redistribute it and/or modify it
#   under the terms of version 2 of the GNU General Public License as
#   published by the Free Software Foundation.
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

;-------------------------------------------------------------------------------------------
; Custom Page - Choose Nihongo Parser
;-------------------------------------------------------------------------------------------

; Page title and sub-title

!define C_NPLS_HEADER_ChooseParser  "Please choose Japanese wakachi-gaki (split words) parser program:"
!define C_NPLS_DESC_ChooseParser    "To analyze Japanese e-mails by POPFile we have to split (wakachi-gaki) the e-mail body texts into words."

; Description shown in the text box when 'Kakasi' has been selected

!define C_NPLS_DESC_Kakasi          "This is the program used by POPFile 0.22.5 (and earlier releases of POPFile).$\r$\n$\r$\nThe wakachi-gaki accuracy is poorer than MeCab (because Kakasi does not have information about words constructed using Hira-gana or Kata-kana), but Kakasi uses smaller dictionaries than MeCab (about 2 MB instead of 40 MB).$\r$\n$\r$\nThe POPFile installer contains Kakasi and its dictionaries."

; Description shown in the text box when 'MeCab' has been selected

!define C_NPLS_DESC_MeCab           "The wakachi-gaki accuracy is better than Kakasi, but MeCab uses larger dictionaries (about 40 MB).$\r$\n$\r$\nThe POPFile installer does not contain MeCab. About 13 MB will be downloaded from the Internet if MeCab is selected."

; Description shown in the text box when 'Internal' has been selected

!define C_NPLS_DESC_Internal        "Instead of using external programs, the parser splits texts by the kinds of characters (i.e. Kanji, Hira-gana or Kata-kana).$\r$\n$\r$\nThe wakachi-gaki accuracy is poorer than programs which use dictionaries, but it does not use dictionaries so it is faster."

; Flags setting for the text box (allows English version to use a vertical scroll bar even if the Japanese version does not use one)

!define C_NPLS_DESC_Flags           "READONLY|MULTILINE|VSCROLL"

; Text for the three radio buttons used to select the parser to be installed

!define C_NPLS_Option_Kakasi        "&Kakasi: KAnji KAna Simple Inverter (Recommended)"
!define C_NPLS_Option_MeCab         "&MeCab: Yet Another Part-of-Speech and Morphological Analyzer"
!define C_NPLS_Option_Internal      "The &Internal parser: splitting by the kinds of characters"

; Text and URL used in the area below the description text box

!define C_NPLS_Note                 "* The wakachi-gaki accuracy does not relate directly to POPFile's classification accuracy.\r\n   In an experiment POPFile's accuracy was not significantly affected by the choice of parser.\r\n\r\n* Changing wakachi-gaki program may temporarily reduce POPFile's classification accuracy.\r\n\r\n* You can change the wakachi-gaki program after the installation. For more information, click"
!define C_NPLS_Link                 "http://getpopfile.org/wiki/jp:faq:mecab"

;-------------------------------------------------------------------------------------------
; Standard MUI Page - COMPONENTS (text used when the mouse hovers over the "Nihongo Parser" entry)
; Note: The $G_PARSER variable will contain the lowercase name of the parser to be installed
;-------------------------------------------------------------------------------------------

!define C_NPLS_DESC_SecParser       "POPFile uses a parser (Kakasi, MeCab or Internal) to split Japanese text into words. The '$G_PARSER' parser has been selected for this installation"

;-------------------------------------------------------------------------------------------
; Custom Page - Setup Summary Page (lists the items which are going to be installed)
;-------------------------------------------------------------------------------------------

!define C_NPLS_SUMMARY_KAKASI      "Nihongo parser (the 'Kakasi' parser will be installed)"
!define C_NPLS_SUMMARY_MECAB       "Nihongo parser (the 'MeCab' parser will be downloaded and installed)"
!define C_NPLS_SUMMARY_INTERNAL    "Nihongo parser (the 'internal' parser will be used)"

;-------------------------------------------------------------------------------------------
; Standard MUI Page - INSTFILES (messages displayed when attempting to download the MeCab files)
;-------------------------------------------------------------------------------------------

; Message shown above the progress bar while comparing the expected and actual MD5 sums for the files listed in 'mecab.md5'

!define C_NPLS_VERIFYING_MECAB     "Verifying the files in the '$G_PLS_FIELD_1' folder..."

; Message shown above the progress bar with the result of the 'mecab.md5' MD5 checks

!define C_NPLS_MECAB_MD5_RESULT    "MeCab validity check result: $G_PLS_FIELD_1"

; Message shown if internet connection does not appear to be working

!define C_NPLS_CHECKINTERNET       "The MeCab files will be downloaded from the Internet.${MB_NL}${MB_NL}Your Internet connection seems to be down or disabled.${MB_NL}${MB_NL}Please reconnect and click Retry to resume installation"

; Message shown if unable to download and install the MeCab files)

!define C_NPLS_REPEATMECAB         "Unable to install the MeCab files!${MB_NL}${MB_NL}To try again later use the 'Add/Remove Programs' entry${MB_NL}${MB_NL}for POPFile ${C_POPFILE_MAJOR_VERSION}.${C_POPFILE_MINOR_VERSION}.${C_POPFILE_REVISION}${C_POPFILE_RC}"

#--------------------------------------------------------------------------
# End of 'English-parser.nsh'
#--------------------------------------------------------------------------
