#--------------------------------------------------------------------------
# Japanese-parser.nsh
#
# This file contains the "Japanese" text strings used by the Windows installer
# when installing the "Nihongo Parser". Normally the multi-language build of
# the installer uses language strings for the text but since the "Nihongo Parser"
# is only installed when the "Nihongo" (Japanese) language is selected, this
# file defines some constants instead of using LanguageString commands.
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

!define C_NPLS_HEADER_ChooseParser  "日本語の分かち書きに使用するプログラムを選択してください。"
!define C_NPLS_DESC_ChooseParser    "POPFile を使って日本語のメールを分析するためには、メールの本文を単語ごとに分割する（分かち書き）必要があります。"

; Description shown in the text box when 'Kakasi' has been selected

!define C_NPLS_DESC_Kakasi          "POPFile 0.22.5 までのバージョンで使用されていたプログラムです。$\r$\n$\r$\n分かち書きの精度は MeCab に比べると低い（ひらがなやカタカナで構成されている単語の情報を持っていない）ですが、MeCab に比べ辞書サイズが小さくてすみます（MeCab 40MB に対して 2MB 程度）。$\r$\n$\r$\nKakasi と辞書ファイルはインストーラに内蔵されています。"

; Description shown in the text box when 'MeCab' has been selected

!define C_NPLS_DESC_MeCab           "Kakasi よりもより正確な分かち書きを行うことができますが、辞書サイズが大きくなります（40MB 程度）。$\r$\n$\r$\nインストーラには内蔵されていません。MeCab オプションを選択した場合、およそ 13MB のファイルがインターネットよりダウンロードされ、インストールされます。"

; Description shown in the text box when 'Internal' has been selected

!define C_NPLS_DESC_Internal        "外部プログラムを使わずに、文字の種類（漢字、ひらがな、カタカナなど）だけをたよりに分かち書きを行います。$\r$\n$\r$\n辞書を使用した分かち書きに比べ分かち書きの精度は落ちますが、辞書を必要とせず、高速に動作します。"

; Flags setting for the text box (allows English version to use a vertical scroll bar even if the Japanese version does not use one)

!define C_NPLS_DESC_Flags           "READONLY|MULTILINE|VSCROLL"

; Text for the three radio buttons used to select the parser to be installed

!define C_NPLS_Option_Kakasi        "Kakasi: 漢字→かな(ローマ字)変換プログラム（推奨）(&K)"
!define C_NPLS_Option_MeCab         "MeCab: Yet Another Part-of-Speech and Morphological Analyzer (&M)"
!define C_NPLS_Option_Internal      "内蔵パーサ: 文字種による分割 (&I)"

; Text and URL used in the area below the description text box

!define C_NPLS_Note                 "※ 分かち書きの精度と POPFile の分類精度との間には直接の因果関係はなく、どのプログラムを使用しても POPFile の分類精度にはほとんど違いはないという結果が出ています。\r\n\r\n※ 分かち書きのプログラムを変更すると、一時的に POPFile の分類精度が低下する可能性があります。\r\n\r\n※ インストール後に分かち書きのプログラムを変更することもできます。詳しくは下のリンクをクリック。"
!define C_NPLS_Link                 "http://getpopfile.org/wiki/jp:faq:mecab"

;-------------------------------------------------------------------------------------------
; Standard MUI Page - COMPONENTS (text used when the mouse hovers over the "Nihongo Parser" entry)
;-------------------------------------------------------------------------------------------

!define C_NPLS_DESC_SecParser       "POPFile は日本語のテキストを単語ごとに分割するためのプログラムを使用します。今回は「$G_PARSER」が選択されています"

;-------------------------------------------------------------------------------------------
; Custom Page - Setup Summary Page (lists the items which are going to be installed)
;-------------------------------------------------------------------------------------------

!define C_NPLS_SUMMARY_KAKASI      "日本語処理プログラム（「Kakasi」がインストールされます）"
!define C_NPLS_SUMMARY_MECAB       "日本語処理プログラム（「MeCab」がダウンロード・インストールされます）"
!define C_NPLS_SUMMARY_INTERNAL    "日本語処理プログラム（「内蔵パーサ」が使用されます）"

;-------------------------------------------------------------------------------------------
; Standard MUI Page - INSTFILES (messages displayed when attempting to download the MeCab files)
;-------------------------------------------------------------------------------------------

; Message shown if internet connection does not appear to be working

!define C_NPLS_CHECKINTERNET       "The MeCab files will be downloaded from the Internet.${MB_NL}${MB_NL}Your Internet connection seems to be down or disabled.${MB_NL}${MB_NL}Please reconnect and click Retry to resume installation"

; Message shown if unable to download and install the MeCab files)

!define C_NPLS_REPEATMECAB         "Unable to install the MeCab files!${MB_NL}${MB_NL}To try again later, run the command${MB_NL}${MB_NL}$G_PLS_FIELD_1${MB_NL}${MB_NL}or use 'Add/Remove Programs' entry for POPFile"

#--------------------------------------------------------------------------
# End of 'Japanese-parser.nsh'
#--------------------------------------------------------------------------
