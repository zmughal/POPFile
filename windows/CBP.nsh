#----------------------------------------------------------------------------------------------
#
# CBP.nsh --- This file is used by 'installer.nsi', the NSIS script used to create the
#             Windows installer for POPFile. The CBP package allows the user to select several
#             buckets for use with a "clean" install of POPFile. Three built-in default values
#             can be overridden by creating suitable "!define" statements in 'installer.nsi'.
#
# Copyright (c) 2001-2003 John Graham-Cumming
#
#----------------------------------------------------------------------------------------------

# This version of 'CBP.nsh' was tested using NSIS 2.0b4 (CVS)

#//////////////////////////////////////////////////////////////////////////////////////////////
#
#                           External interface - starts here
#
#//////////////////////////////////////////////////////////////////////////////////////////////


  ; To use the CBP package, only two changes need to be made to "installer.nsi":
  ;
  ;   (1) Ensure the CBP package gets compiled, by inserting this block of code near the start:
  ;
  ;   <start of code block>
  ;
  ;   #----------------------------------------------------------------------------------------
  ;   # CBP Configuration Data (leave lines commented-out if defaults are satisfactory)
  ;   #----------------------------------------------------------------------------------------
  ;   #   ; Maximum number of buckets handled (in range 2 to 8)
  ;   #
  ;   #   !define CBP_MAX_BUCKETS 8
  ;   #
  ;   #   ; Default bucket selection (use "" if no buckets are to be pre-selected)
  ;   #
  ;   #   !define CBP_DEFAULT_LIST "in-box|junk|personal|work"
  ;   #
  ;   #   ; List of suggestions for bucket names (use "" if no suggestions are required)
  ;   #
  ;   #   !define CBP_SUGGESTION_LIST \
  ;   #   "admin|business|computers|family|financial|general|hobby|in-box|junk|list-admin|\
  ;   #   miscellaneous|not_spam|other|personal|recreation|school|security|shopping|spam|\
  ;   #   travel|work"
  ;   #----------------------------------------------------------------------------------------
  ;   # Make the CBP package available
  ;   #----------------------------------------------------------------------------------------
  ;
  ;   !include CBP.nsh
  ;
  ;   <end of code block>
  ;
  ;   (2) Add the "Create POPFile Buckets" page to the list of installer pages:
  ;
  ;         !insertmacro CBP_PAGECOMMAND_SELECTBUCKETS ": Create POPFile Buckets"
  ;
  ; These two changes will use the default settings in the CBP package. There are three default
  ; settings which can be overridden by un-commenting the appropriate lines in the inserted code
  ; block.
  ;
  ; Default setting 1:
  ; -----------------
  ;
  ;     !define CBP_MAX_BUCKETS 8
  ;
  ; Maximum number of buckets handled by the installer, a number in the range 2 to 8 inclusive.
  ; If a number outside this range is supplied, the CBP package will use 8 buckets by default.
  ;
  ;
  ; Default setting 2:
  ; -----------------
  ;
  ;     !define CBP_DEFAULT_LIST "in-box|junk|personal|work"
  ;
  ; The default list of bucket names presented when the "Create Bucket" page first appears.
  ; This list should contain a series of valid bucket names, separated by "|" characters.
  ; If no default buckets are required, use "" for this list. Alphabetic order is used here
  ; for convenience but any order can be used. Default buckets are created in order from left
  ; to right and if more than CBP_MAX_BUCKETS names are supplied, the "extra" names will be
  ; ignored. The CBP package will ignore any invalid or duplicated names in this list.
  ;
  ; Default setting 3:
  ; -----------------
  ;
  ;     !define CBP_SUGGESTION_LIST \
  ;     "admin|business|computers|family|financial|general|hobby|in-box|junk|list-admin|\
  ;     miscellaneous|not_spam|other|personal|recreation|school|security|shopping|spam|\
  ;     travel|work"
  ;
  ; The list of suggested names for buckets, provided as an aid to the user. This list should
  ; contain a series of valid bucket names, separated by "|" characters. If no suggestions are
  ; to be shown, use "" for this list. Alphabetic order is used here for convenience since the
  ; list presented to the user will follow the order given here, from left to right.
  ; The CBP package will ignore any invalid or duplicated names in this list.
  ;
  ; These commented-out "!define" statements are included in the code block to serve as a
  ; reminder of the default values and to make it easier to configure the CBP package.

#//////////////////////////////////////////////////////////////////////////////////////////////
#
#                           External interface - ends here
#
#//////////////////////////////////////////////////////////////////////////////////////////////

  ; Name of the INI file used to create the custom page for this package. Normally the
  ; 'CBP_CreateBucketsPage' function will call 'CBP_CreateINIfile' to create this INI file
  ; in the $PLUGINSDIR directory so it will be deleted automatically when the installer ends.

  !define CBP_C_INIFILE   CBP_PAGE.INI

  ; However, if 'installer.nsi' is modified to ensure that an INI file with this name is
  ; provided in the $PLUGINSDIR directory then the CBP package will use this INI file instead
  ; of calling 'CBP_CreateINIfile' to create one. It is up to the user to ensure that any INI
  ; file provided in this way meets the strict requirements of the CBP package otherwise chaos
  ; may well ensue! See the header comments in 'CBP_CreateINIfile' for further details.
  ; It is strongly recommended that any INI file provided by 'installer.nsi' is created by
  ; modifying a copy of the INI file created by the CBP_CreateINIfile function.

#==============================================================================================
# Function CBP_CheckCorpusStatus
#==============================================================================================
#
# This function is used to determine the type of POPFile installation we are performing.
# The CBP package is only used to create POPFile buckets when the installer is used to install
# POPFile in a folder which does not contain any corpus files from a previous installation.
#
# For flexibility, the path to be searched is passed on the stack instead of being hard-coded.
#----------------------------------------------------------------------------------------------
# Inputs:
#   (top of stack)                - the path where the corpus is expected to exist
#                                   (normally this will be the same as $INSTDIR)
#----------------------------------------------------------------------------------------------
# Outputs:
#   (top of stack)                - string containing one of three possible result codes:
#                                       "clean" (corpus directory not found),
#                                       "empty" (corpus directory exists but is empty), or
#                                       "dirty" (corpus directory is not empty)
#----------------------------------------------------------------------------------------------
# Global Registers Destroyed:
#   (none)
#
# Local Registers Destroyed:
#   (none)
#----------------------------------------------------------------------------------------------
# Global CBP Constants Used:
#   (none)
#----------------------------------------------------------------------------------------------
# CBP Functions Called:
#   (none)
#----------------------------------------------------------------------------------------------
# Called By:
#   CBP_CreateBucketsPage         - the function which "controls" the "Create Buckets" page
#----------------------------------------------------------------------------------------------
#  Usage Example:
#
#         Push $INSTDIR
#         Call CBP_CheckCorpusStatus
#         Pop $R0
#
#         ($R0 will be "clean", "empty" or "dirty" at this point)
#==============================================================================================

Function CBP_CheckCorpusStatus

  !define CBP_L_FILE_HANDLE   $R9
  !define CBP_L_RESULT        $R8
  !define CBP_L_SOURCE        $R7

  Exch ${CBP_L_SOURCE}          ; where we are supposed to look for the corpus files
  Push ${CBP_L_RESULT}
  Exch
  Push ${CBP_L_FILE_HANDLE}

  FindFirst ${CBP_L_FILE_HANDLE} ${CBP_L_RESULT} ${CBP_L_SOURCE}\corpus\*.*

  ; If the "corpus" directory does not exist "${CBP_L_FILE_HANDLE}" will be empty

  StrCmp ${CBP_L_FILE_HANDLE} "" clean_install

  ; If the "corpus" directory is empty we can still treat this as a "clean" install
  ; (At this point, ${CBP_L_RESULT} will hold "." which we ignore)

  ; NB: We really should be checking that the user has got at least two buckets in their
  ; previous installation, but that is a task for another day...

corpus_check:
  FindNext ${CBP_L_FILE_HANDLE} ${CBP_L_RESULT}
  StrCmp ${CBP_L_RESULT} ".." corpus_check
  StrCmp ${CBP_L_RESULT} "" empty_install

  ; Have found something in the "corpus" directory so this is not a "clean" install

  StrCpy ${CBP_L_RESULT} "dirty"
  goto return_result

empty_install:
  StrCpy ${CBP_L_RESULT} "empty"
  goto return_result

clean_install:
  StrCpy ${CBP_L_RESULT} "clean"

return_result:
  FindClose ${CBP_L_FILE_HANDLE}

  Pop ${CBP_L_FILE_HANDLE}
  Pop ${CBP_L_SOURCE}
  Exch ${CBP_L_RESULT}  ; place "clean", "empty" or "dirty" on top of the stack

  !undef CBP_L_FILE_HANDLE
  !undef CBP_L_RESULT
  !undef CBP_L_SOURCE

FunctionEnd

#==============================================================================================
# Function CBP_MakePOPFileBuckets
#==============================================================================================
#
# This function creates the buckets which are to be used by this installation of POPFile.
# The names of the buckets to be created are extracted from the INI file used to create the
# custom page used by the CBP package. It is assumed that the bucket names are found in
# consecutive fields in the INI file.
#
# Almost no error checking is performed upon the input parameters.
#
# At present a simple result code is returned. This could be replaced by a list of the names
# of the buckets which were not created (as a "|" separated list ?)
#
#----------------------------------------------------------------------------------------------
# Inputs:
#   (top of stack)                - the number of buckets to be created (in range 2 to 8)
#   (top of stack - 1)            - field number where the first bucket name is stored
#----------------------------------------------------------------------------------------------
# Outputs:
#   (top of stack)                - the number of bucket creation failures (in range 0 to 8)
#----------------------------------------------------------------------------------------------
# Global Registers Destroyed:
#   (none)
#
# Local Registers Destroyed:
#   (none)
#----------------------------------------------------------------------------------------------
# Global CBP Constants Used:
#   CBP_C_INIFILE                 - name of the INI file used to create the custom page
#----------------------------------------------------------------------------------------------
# CBP Functions Called:
#   (none)
#----------------------------------------------------------------------------------------------
# Called By:
#   CBP_CreateBucketsPage         - the function which "controls" the "Create Buckets" page
#----------------------------------------------------------------------------------------------
#  Usage Example:
#
#       Push $R3                      ; field number used to hold name of the first bucket
#       Push $R2                      ; number of buckets to be created (range 2 to 8)
#       Call CBP_MakePOPFileBuckets
#       Pop $R1                       ; number of buckets not created (range 0 to 8)
#==============================================================================================

Function CBP_MakePOPFileBuckets

  !define CBP_L_COUNT         $R9    ; holds number of buckets not yet created
  !define CBP_L_CREATE_NAME   $R8    ; name of bucket to be created
  !define CBP_L_FILE_HANDLE   $R7
  !define CBP_L_FIRST_FIELD   $R6    ; holds field number where first bucket name is stored
  !define CBP_L_LOOP_LIMIT    $R5    ; used to terminate the processing loop
  !define CBP_L_NAME          $R4    ; used when checking the corpus directory
  !define CBP_L_PTR           $R3    ; used to access the names in the bucket list

  Exch ${CBP_L_COUNT}         ; get number of buckets to be created
  Exch
  Exch ${CBP_L_FIRST_FIELD}   ; get number of the field containing the first bucket name
  Push ${CBP_L_CREATE_NAME}
  Push ${CBP_L_FILE_HANDLE}
  Push ${CBP_L_LOOP_LIMIT}
  Push ${CBP_L_NAME}
  Push ${CBP_L_PTR}

  ; Now we create the buckets selected by the user. At present this code is only executed
  ; for a "fresh" install, one where there are no corpus files, so we can simply create a
  ; bucket by creating a corpus directory with the same name as the bucket and putting
  ; a file called "table" there.  The "table" file just has a "$\r$\n" sequence in it.

  ; Process only the "used" entries in the bucket list

  StrCpy ${CBP_L_PTR} ${CBP_L_FIRST_FIELD}
  IntOp ${CBP_L_LOOP_LIMIT} ${CBP_L_PTR} + ${CBP_L_COUNT}

next_bucket:
  !insertmacro MUI_INSTALLOPTIONS_READ ${CBP_L_CREATE_NAME} "${CBP_C_INIFILE}" \
      "Field ${CBP_L_PTR}" "Text"
  StrCmp ${CBP_L_CREATE_NAME} "" incrm_ptr

  ; Double-check that the bucket we are about to create does not exist

  FindFirst ${CBP_L_FILE_HANDLE} ${CBP_L_NAME} $INSTDIR\corpus\${CBP_L_CREATE_NAME}\*.*
  StrCmp ${CBP_L_FILE_HANDLE} "" ok_to_create_bucket
  FindClose ${CBP_L_FILE_HANDLE}
  goto incrm_ptr

ok_to_create_bucket:
  FindClose ${CBP_L_FILE_HANDLE}
  ClearErrors
  CreateDirectory $INSTDIR\corpus\${CBP_L_CREATE_NAME}
  FileOpen ${CBP_L_FILE_HANDLE} $INSTDIR\corpus\${CBP_L_CREATE_NAME}\table w
  FileWrite ${CBP_L_FILE_HANDLE} "$\r$\n"
  FileClose ${CBP_L_FILE_HANDLE}
  IfErrors  incrm_ptr
  IntOp ${CBP_L_COUNT} ${CBP_L_COUNT} - 1

incrm_ptr:
  IntOp ${CBP_L_PTR} ${CBP_L_PTR} + 1
  IntCmp ${CBP_L_PTR} ${CBP_L_LOOP_LIMIT} finished_now next_bucket

finished_now:
  Pop ${CBP_L_PTR}
  Pop ${CBP_L_NAME}
  Pop ${CBP_L_LOOP_LIMIT}
  Pop ${CBP_L_FILE_HANDLE}
  Pop ${CBP_L_CREATE_NAME}
  Pop ${CBP_L_FIRST_FIELD}
  Exch ${CBP_L_COUNT}       ; top of stack now has number of buckets we were unable to create

  !undef CBP_L_COUNT
  !undef CBP_L_CREATE_NAME
  !undef CBP_L_FILE_HANDLE
  !undef CBP_L_FIRST_FIELD
  !undef CBP_L_LOOP_LIMIT
  !undef CBP_L_NAME
  !undef CBP_L_PTR

FunctionEnd

#//////////////////////////////////////////////////////////////////////////////////////////////
#                                                                                             #
#                     NO "USER SERVICEABLE" PARTS BEYOND THIS POINT                           #
#                                                                                             #
#//////////////////////////////////////////////////////////////////////////////////////////////

###############################################################################################
#
# "Global" constants for the CBP Package
#
###############################################################################################

#==============================================================================================
# "CBP Configuration Constants"
#==============================================================================================

  ; NB: CBP_DEFAULT_LIST, CBP_SUGGESTION_LIST and CBP_MAX_BUCKETS may be defined
  ;     in 'installer.nsi' to override the CBP default settings.

  ; CBP_MAX_BUCKETS defines the maximum number of buckets handled by the CBP package,
  ; and must be a number in the range 2 to 8 inclusive. If a number outside this range is
  ; supplied, the CBP package will use the default setting of 8 buckets.

  !ifdef CBP_MAX_BUCKETS
    !define BUCKET_LIMIT_${CBP_MAX_BUCKETS}
  !endif

  ; The buckets to be selected by default when the "Create Buckets" page first appears
  ; (use "" if no buckets are to be selected by default). If this list contains more names
  ; than the limit specified by CBP_MAX_BUCKETS, the "extra" names will be ignored.

  !ifdef CBP_DEFAULT_LIST
      !define CBP_C_DEFAULT_BUCKETS `${CBP_DEFAULT_LIST}`
  !else
      !define CBP_C_DEFAULT_BUCKETS "in-box|junk|personal|work"
  !endif

  ; The list of suggested bucket names for the "Create Bucket" combobox to use
  ; (use "" if no names are to appear). If one of these names gets selected, it
  ; is removed from the combobox list (it'll be restored if bucket is de-selected).

  !ifdef CBP_SUGGESTION_LIST
      !define CBP_C_SUGGESTED_BUCKETS `${CBP_SUGGESTION_LIST}`
  !else
      !define CBP_C_SUGGESTED_BUCKETS \
      "admin|business|computers|family|financial|general|hobby|in-box|junk|list-admin|\
      miscellaneous|not_spam|other|personal|recreation|school|security|shopping|spam|\
      travel|work"
  !endif

#==============================================================================================
# Macro used to insert the "Create Buckets" custom page into the list of installer pages
#==============================================================================================

  !macro CBP_PAGECOMMAND_SELECTBUCKETS CAPTION
    Page custom CBP_CreateBucketsPage "" "${CAPTION}"
  !macroend

#==============================================================================================
# "Global" constants used when accessing the INI file which defines the custom page layout
#==============================================================================================
# Used to make it easier to (re)design the custom page control layout.
# Values here match the INI file created by the CBP_CreateINIfile function
#----------------------------------------------------------------------------------------------

  ; Constant used to access the "Create Bucket" ComboBox

  !define CBP_C_CREATE_BN                 3

  ; Constants used to control the size of the "Create Bucket" ComboBox List

  !define CBP_C_FULL_COMBO_LIST          160
  !define CBP_C_MIN_COMBO_LIST           120

  ; Field number for the bucket creation progress reports

  !define CBP_C_MESSAGE                   5

  ; Constants specifying the fields which are common to all bucket list sizes

  !define CBP_C_FIRST_BN_CBOX               15    ; field holding the first check box
  !define CBP_C_FIRST_BN_CBOX_MINUS_ONE     14    ; used when processing the check boxes
  !define CBP_C_FIRST_BN_TEXT                7    ; field holding first bucket name
  !define CBP_C_LAST_BN_TEXT_PLUS_ONE       15    ; used when clearing out the bucket list

  ; Set up the limit on the number of buckets the installer can process (in the range 2 to 8)
  ; Also set up the two constants used to terminate processing loops

  ; If CBP_MAX_BUCKETS was supplied, BUCKET_LIMIT_x specifies the maximum number of buckets
  ; otherwise the CBP package will use its default setting of 8 buckets.

  !ifdef BUCKET_LIMIT_2
    !define CBP_C_MAX_BNCOUNT               2
    !define CBP_C_MAX_BN_TEXT_PLUS_ONE      9
    !define CBP_MAX_BN_CBOX_PLUS_ONE       17
  !else ifdef BUCKET_LIMIT_3
    !define CBP_C_MAX_BNCOUNT               3
    !define CBP_C_MAX_BN_TEXT_PLUS_ONE     10
    !define CBP_MAX_BN_CBOX_PLUS_ONE       18
  !else ifdef BUCKET_LIMIT_4
    !define CBP_C_MAX_BNCOUNT               4
    !define CBP_C_MAX_BN_TEXT_PLUS_ONE     11
    !define CBP_MAX_BN_CBOX_PLUS_ONE       19
  !else ifdef BUCKET_LIMIT_5
    !define CBP_C_MAX_BNCOUNT               5
    !define CBP_C_MAX_BN_TEXT_PLUS_ONE     12
    !define CBP_MAX_BN_CBOX_PLUS_ONE       20
  !else ifdef BUCKET_LIMIT_6
    !define CBP_C_MAX_BNCOUNT               6
    !define CBP_C_MAX_BN_TEXT_PLUS_ONE     13
    !define CBP_MAX_BN_CBOX_PLUS_ONE       21
  !else ifdef BUCKET_LIMIT_7
    !define CBP_C_MAX_BNCOUNT               7
    !define CBP_C_MAX_BN_TEXT_PLUS_ONE     14
    !define CBP_MAX_BN_CBOX_PLUS_ONE       22
  !else ifdef BUCKET_LIMIT_8
    !define CBP_C_MAX_BNCOUNT               8
    !define CBP_C_MAX_BN_TEXT_PLUS_ONE     15
    !define CBP_MAX_BN_CBOX_PLUS_ONE       23
  !else

    ; If CBP_MAX_BUCKETS was not defined or if it was not in the
    ; range 2 to 8 inclusive, CBP will use an upper limit of 8 for
    ; the bucket list.

    !define CBP_C_MAX_BNCOUNT               8
    !define CBP_C_MAX_BN_TEXT_PLUS_ONE     15
    !define CBP_MAX_BN_CBOX_PLUS_ONE       23
  !endif

  !ifdef CBP_MAX_BUCKETS
    !undef BUCKET_LIMIT_${CBP_MAX_BUCKETS}
  !endif

#==============================================================================================
# Function CBP_CreateINIfile
#==============================================================================================
# Used to create the InstallOptions INI file defining the custom page used to select the names
# of the POPFile buckets which are to be created for a "clean" install of POPFile.
#----------------------------------------------------------------------------------------------
# Inputs:
#   (none)
#----------------------------------------------------------------------------------------------
# Outputs:
#   (none)
#----------------------------------------------------------------------------------------------
# Global Registers Destroyed:
#   (none)
#
# Local Registers Destroyed:
#   (none)
#----------------------------------------------------------------------------------------------
# Global CBP Constants Used:
#   CBP_C_INIFILE                 - name of the INI file used to create the custom page
#----------------------------------------------------------------------------------------------
# CBP Functions Called:
#   (none)
#----------------------------------------------------------------------------------------------
# Called By:
#   CBP_CreateBucketsPage         - the function which "controls" the "Create Buckets" page
#----------------------------------------------------------------------------------------------
#  Usage Example:
#
#    Call CBP_CreateINIfile
#
#==============================================================================================

Function CBP_CreateINIfile

  ;--------------------------------------------------------------------------------------------
  ; Current layout of the 22 fields created by this function:
  ;
  ; [ 1] Instructions for this    [ 6] GroupBox enclosing the list of bucket names
  ;      custom page
  ;                               [ 7] Bucket 1 name  [15] Bucket 1 Remove box
  ;                               [ 8] Bucket 2 name  [16] Bucket 2 Remove box
  ; [ 2] "Create" combobox label  [ 9] Bucket 3 name  [17] Bucket 3 Remove box
  ;                               [10] Bucket 4 name  [18] Bucket 4 Remove box
  ; [ 3] the "Create" combobox    [11] Bucket 5 name  [19] Bucket 5 Remove box
  ;                               [12] Bucket 6 name  [20] Bucket 6 Remove box
  ; [ 4] "Deletion" notes         [13] Bucket 7 name  [21] Bucket 7 Remove box
  ;                               [14] Bucket 8 name  [22] Bucket 8 Remove box
  ;
  ;                               [ 5] - Progress report messages
  ;
  ; NB: These controls must all fit into the 300 x 140 unit 'custom page' area.
  ;
  ; NB: The CBP package makes several assumptions about the layout of these fields!
  ;
  ; [1] The 8 fields used to hold the names of the buckets must be consecutive.
  ;
  ; [2] The 8 fields used to hold the "Remove" boxes must also be consecutive.
  ;
  ; [3] The fields used to hold the "Remove" boxes must be the last fields in the
  ;     INI file because the "NumFields" setting is used to control the display
  ;     of these boxes (e.g. to remove all of the boxes, the CBP package sets
  ;     "NumFields" to one less than the field number of the first box.
  ;
  ; NB: The CBP package also stores some data in this file, in a section called "CBP Data"
  ;--------------------------------------------------------------------------------------------

  ; Constants used to position information on the left-half of the page

  !define INFO_LEFT_MARGIN      0
  !define INFO_RIGHT_MARGIN   131

  ; Constants used to position the bucket names

  !define BN_NAME_LEFT        157
  !define BN_NAME_RIGHT       -44

  ; Constants used to position the "Remove" boxes

  !define BN_REMOVE_LEFT      -42
  !define BN_REMOVE_RIGHT     -1

  ; Constants used to define the position of the 8 rows in the bucket list

  !define BN_ROW_1_TOP        12
  !define BN_ROW_1_BOTTOM     22

  !define BN_ROW_2_TOP        27
  !define BN_ROW_2_BOTTOM     37

  !define BN_ROW_3_TOP        42
  !define BN_ROW_3_BOTTOM     52

  !define BN_ROW_4_TOP        57
  !define BN_ROW_4_BOTTOM     67

  !define BN_ROW_5_TOP        72
  !define BN_ROW_5_BOTTOM     82

  !define BN_ROW_6_TOP        87
  !define BN_ROW_6_BOTTOM     97

  !define BN_ROW_7_TOP        102
  !define BN_ROW_7_BOTTOM     112

  !define BN_ROW_8_TOP        117
  !define BN_ROW_8_BOTTOM     127

  ; Basic macro used to create the INI file

  !macro CBP_WRITE_INI SECTION KEY VALUE
    WriteINIStr "$PLUGINSDIR\${CBP_C_INIFILE}" "${SECTION}" "${KEY}" "${VALUE}"
  !macroend

  ; Macro used to define a standard control for the custom page
  ; (used for ComboBoxes, the GroupBox and the info Labels)

  !macro CBP_DEFINE_CONTROL FIELD TYPE TEXT LEFT RIGHT TOP BOTTOM
    !insertmacro CBP_WRITE_INI "${FIELD}" "Type" "${TYPE}"

    StrCmp "${TYPE}" "ComboBox" 0 +3
    ; ComboBox control
    !insertmacro CBP_WRITE_INI "${FIELD}" "ListItems" "${TEXT}"
    goto +2

    ; GroupBox or Label control
    !insertmacro CBP_WRITE_INI "${FIELD}" "Text" "${TEXT}"

    ; Remainder is common to "ComboBox", "GroupBox" and "Label" controls
    !insertmacro CBP_WRITE_INI "${FIELD}" "Left" "${LEFT}"
    !insertmacro CBP_WRITE_INI "${FIELD}" "Right" "${RIGHT}"
    !insertmacro CBP_WRITE_INI "${FIELD}" "Top" "${TOP}"
    !insertmacro CBP_WRITE_INI "${FIELD}" "Bottom" "${BOTTOM}"
  !macroend

  ; Macro used to define a label which holds one of the 8 bucket names

  !macro CBP_DEFINE_BN_TEXT FIELD TEXT ROW
    !insertmacro CBP_DEFINE_CONTROL "${FIELD}" \
      "Label" \
      "${TEXT}" \
      "${BN_NAME_LEFT}" "${BN_NAME_RIGHT}"  "${BN_${ROW}_TOP}" "${BN_${ROW}_BOTTOM}"
  !macroend

  ; Macro used to define a checkbox for marking a bucket name for deletion

  !macro CBP_DEFINE_BN_REMOVE FIELD ROW
    !insertmacro CBP_DEFINE_CONTROL "${FIELD}" \
      "CheckBox" \
      "Remove" \
      "${BN_REMOVE_LEFT}" "${BN_REMOVE_RIGHT}" "${BN_${ROW}_TOP}" "${BN_${ROW}_BOTTOM}"
  !macroend

#----------------------------------------------------------------------------------------------
# Now create the INI file for the "Create Buckets" custom page
#----------------------------------------------------------------------------------------------

  ; The INI file header (all fields made visible)

  !insertmacro CBP_WRITE_INI "Settings" "NumFields" "22"
  !insertmacro CBP_WRITE_INI "Settings" "NextButtonText" "Continue"
  !insertmacro CBP_WRITE_INI "Settings" "BackEnabled" "0"
  !insertmacro CBP_WRITE_INI "Settings" "CancelEnabled" "0"

  ; Label giving brief instructions

  !insertmacro CBP_DEFINE_CONTROL "Field 1" \
      "Label" \
      "After installation, POPFile makes it easy to change the number of buckets \
      (and their names) to suit your needs.\r\n\r\nBucket names must be single words, \
      using lowercase letters, digits 0 to 9, hyphens and underscores." \
      "${INFO_LEFT_MARGIN}" "${INFO_RIGHT_MARGIN}" "0" "60"

  ; Label for the "Create Bucket" ComboBox

  !insertmacro CBP_DEFINE_CONTROL "Field 2" \
      "Label" \
      "Create a new bucket by either selecting a name from the list below or \
      typing a name of your own choice in the box below." \
      "${INFO_LEFT_MARGIN}" "${INFO_RIGHT_MARGIN}" "63" "87"

  ; ComboBox used to create a new bucket

  !insertmacro CBP_DEFINE_CONTROL "Field 3" \
      "ComboBox" \
      "A|B" \
      "${INFO_LEFT_MARGIN}" "${INFO_RIGHT_MARGIN}" "90" "170"

  ; Instruction for deleting bucket names from the list

  !insertmacro CBP_DEFINE_CONTROL "Field 4" \
      "Label" \
      "To delete one or more buckets from the list, tick the relevant 'Remove' box(es) \
      then click the 'Continue' button." \
      "${INFO_LEFT_MARGIN}" "${INFO_RIGHT_MARGIN}" "110" "190"

  ; Label used to display progress reports

  !insertmacro CBP_DEFINE_CONTROL "Field 5" \
      "Label" \
      " " \
      "155" "-1" "132" "140"

  ; Box enclosing the list of bucket names defined so far

  !insertmacro CBP_DEFINE_CONTROL "Field 6" \
      "GroupBox" \
      "Buckets to be used by POPFile" \
      "150" "300" "0" "130"

  ; Text for GroupBox lines 1 to 8

  !insertmacro CBP_DEFINE_BN_TEXT "Field 7"  "Bucket 1" "ROW_1"
  !insertmacro CBP_DEFINE_BN_TEXT "Field 8"  "Bucket 2" "ROW_2"
  !insertmacro CBP_DEFINE_BN_TEXT "Field 9"  "Bucket 3" "ROW_3"
  !insertmacro CBP_DEFINE_BN_TEXT "Field 10" "Bucket 4" "ROW_4"
  !insertmacro CBP_DEFINE_BN_TEXT "Field 11" "Bucket 5" "ROW_5"
  !insertmacro CBP_DEFINE_BN_TEXT "Field 12" "Bucket 6" "ROW_6"
  !insertmacro CBP_DEFINE_BN_TEXT "Field 13" "Bucket 7" "ROW_7"
  !insertmacro CBP_DEFINE_BN_TEXT "Field 14" "Bucket 8" "ROW_8"

  ; "Remove" box for GroupBox lines 1 to 8

  !insertmacro CBP_DEFINE_BN_REMOVE "Field 15" "ROW_1"
  !insertmacro CBP_DEFINE_BN_REMOVE "Field 16" "ROW_2"
  !insertmacro CBP_DEFINE_BN_REMOVE "Field 17" "ROW_3"
  !insertmacro CBP_DEFINE_BN_REMOVE "Field 18" "ROW_4"
  !insertmacro CBP_DEFINE_BN_REMOVE "Field 19" "ROW_5"
  !insertmacro CBP_DEFINE_BN_REMOVE "Field 20" "ROW_6"
  !insertmacro CBP_DEFINE_BN_REMOVE "Field 21" "ROW_7"
  !insertmacro CBP_DEFINE_BN_REMOVE "Field 22" "ROW_8"

  FlushINI "$PLUGINSDIR\${CBP_C_INIFILE}"

  !undef INFO_LEFT_MARGIN
  !undef INFO_RIGHT_MARGIN
  !undef BN_NAME_LEFT
  !undef BN_NAME_RIGHT
  !undef BN_REMOVE_LEFT
  !undef BN_REMOVE_RIGHT
  !undef BN_ROW_1_TOP
  !undef BN_ROW_1_BOTTOM
  !undef BN_ROW_2_TOP
  !undef BN_ROW_2_BOTTOM
  !undef BN_ROW_3_TOP
  !undef BN_ROW_3_BOTTOM
  !undef BN_ROW_4_TOP
  !undef BN_ROW_4_BOTTOM
  !undef BN_ROW_5_TOP
  !undef BN_ROW_5_BOTTOM
  !undef BN_ROW_6_TOP
  !undef BN_ROW_6_BOTTOM
  !undef BN_ROW_7_TOP
  !undef BN_ROW_7_BOTTOM
  !undef BN_ROW_8_TOP
  !undef BN_ROW_8_BOTTOM

FunctionEnd

#==============================================================================================
# Function CBP_CreateBucketsPage
#==============================================================================================
#
# This function "generates" the POPFile Bucket Selection page.
#
# The Bucket Selection page shows a list of up to 8 buckets which have been selected for
# creation, a data entry field for adding names to this list, and a check box beside each
# name so it can be removed from the list. More than one bucket can be deleted at a time.
#
# Users can mark a bucket name to be deleted and at the same time enter a bucket name to be
# created. This has the effect of renaming a bucket.
#
# The "Continue" button at the foot of the page is used to action any requests. If no name
# has been entered to create a new bucket and no buckets have been marked for deletion, it is
# assumed that the user is happy with the current list therefore if at least two buckets are
# in the list the function creates those buckets and exits.
#----------------------------------------------------------------------------------------------
# Inputs:
#   (none)
#----------------------------------------------------------------------------------------------
# Outputs:
#   (none)
#----------------------------------------------------------------------------------------------
# Global Registers Destroyed:
#   (none)
#
# Local Registers Destroyed:
#   (none)
#----------------------------------------------------------------------------------------------
# Global CBP Constants Used:
#   CBP_C_CREATE_BN               - field number of the "Create Bucket" combobox
#   CBP_C_DEFAULT_BUCKETS         - defines the default bucket selection
#   CBP_C_FIRST_BN_CBOX           - field holding the first "Remove" check box
#   CBP_C_FIRST_BN_CBOX_MINUS_ONE - used when determining how many "remove" boxes to show
#   CBP_C_FIRST_BN_TEXT           - field number of first entry in list of names
#   CBP_C_INIFILE                 - name of the INI file used to create the custom page
#   CBP_C_MAX_BNCOUNT             - maximum number of buckets installer can handle
#   CBP_C_MAX_BN_TEXT_PLUS_ONE    - used to terminate the loop
#   CBP_C_MESSAGE                 - field number for the progress report message
#----------------------------------------------------------------------------------------------
# CBP Functions Called:
#   CBP_CheckCorpusStatus         - used to determine if this is a "clean" install
#   CBP_CreateINIfile             - generates the INI file used to define the custom page
#   CBP_FindBucket                - looks for a name in the bucket list
#   CBP_MakePOPFileBuckets        - creates the buckets which POPFile will use
#   CBP_SetDefaultBuckets         - initialises the bucket list when page first shown
#   CBP_StrCheckName              - used to validate name entered via "Create" combobox
#   CBP_UpdateAddBucketList       - update list of suggested names seen in "Create" combobox
#----------------------------------------------------------------------------------------------
# Called By:
#   'installer.nsi'               - directly or via the CBP_PAGECOMMAND_SELECTBUCKETS macro
#----------------------------------------------------------------------------------------------
#  Usage Example:
#
#       Page custom CBP_CreateBucketsPage "" " - Create POPFile Buckets"
# or
#       !insertmacro CBP_PAGECOMMAND_SELECTBUCKETS " - Create POPFile Buckets"
#==============================================================================================

Function CBP_CreateBucketsPage

  !define CBP_L_COUNT         $R9    ; counts number of buckets selected
  !define CBP_L_CREATE_NAME   $R8    ; name (input via combobox) of bucket to be created
  !define CBP_L_LOOP_LIMIT    $R7    ; used when checking the "remove" boxes
  !define CBP_L_NAME          $R6    ; a bucket name
  !define CBP_L_PTR           $R5    ; used to access the names in the bucket list
  !define CBP_L_RESULT        $R4
  !define CBP_L_TEMP          $R3

  Push ${CBP_L_COUNT}
  Push ${CBP_L_CREATE_NAME}
  Push ${CBP_L_LOOP_LIMIT}
  Push ${CBP_L_NAME}
  Push ${CBP_L_PTR}
  Push ${CBP_L_RESULT}
  Push ${CBP_L_TEMP}

  ; We only offer to create POPFile buckets if we are not upgrading an existing POPFile system

  Push $INSTDIR
  Call CBP_CheckCorpusStatus
  Pop ${CBP_L_RESULT}
  StrCmp ${CBP_L_RESULT} "clean" display_bucket_page
  StrCmp ${CBP_L_RESULT} "empty" display_bucket_page

  ; The corpus directory exists and is not empty, so we exit without offering to create buckets

  Goto finished_now

display_bucket_page:
  IfFileExists "$PLUGINSDIR\${CBP_C_INIFILE}" use_INI_file
  Call CBP_CreateINIfile

use_INI_file:

  !insertmacro MUI_HEADER_TEXT "POPFile Classification Bucket Creation" \
      "POPFile needs AT LEAST TWO buckets in order to be able to classify your email"

  ; Reset the bucket list to the default settings

  ; The trailing "|" is used to cover the case where ${CBP_C_DEFAULT_BUCKETS} is an empty string

  Push `${CBP_C_DEFAULT_BUCKETS}|`
  Call CBP_SetDefaultBuckets
  Pop ${CBP_L_COUNT}

  ; Now allow the user to create their own list of buckets for POPFile

get_next_bucket_cmd:

  ; Update the status message under the list of bucket names

  IntCmp ${CBP_L_COUNT} 0 zero_so_far
  IntCmp ${CBP_L_COUNT} 1 just_one
  IntCmp ${CBP_L_COUNT} ${CBP_C_MAX_BNCOUNT} at_the_limit

  !insertmacro MUI_INSTALLOPTIONS_WRITE "${CBP_C_INIFILE}" "Field ${CBP_C_MESSAGE}" \
      "Text" "There is no need to add more buckets"
  goto update_lists

zero_so_far:
  !insertmacro MUI_INSTALLOPTIONS_WRITE "${CBP_C_INIFILE}" "Field ${CBP_C_MESSAGE}" \
      "Text" "You must define AT LEAST TWO buckets"
  goto update_lists

just_one:
  !insertmacro MUI_INSTALLOPTIONS_WRITE "${CBP_C_INIFILE}" "Field ${CBP_C_MESSAGE}" \
      "Text" "At least one more bucket is required"
  goto update_lists

at_the_limit:
  !insertmacro MUI_INSTALLOPTIONS_WRITE "${CBP_C_INIFILE}" "Field ${CBP_C_MESSAGE}" \
      "Text" "Installer cannot create more than ${CBP_C_MAX_BNCOUNT} buckets"

update_lists:

  ; Ensure no bucket selected for creation

  !insertmacro MUI_INSTALLOPTIONS_WRITE "${CBP_C_INIFILE}" "Field ${CBP_C_CREATE_BN}" "State" ""

  ; Ensure that only the appropriate "Remove" boxes are shown

  IntOp ${CBP_L_TEMP} ${CBP_L_COUNT} + ${CBP_C_FIRST_BN_CBOX_MINUS_ONE}
  WriteINIStr "$PLUGINSDIR\${CBP_C_INIFILE}" "Settings" "NumFields" "${CBP_L_TEMP}"

  ; Update new bucket suggestions (must be done AFTER updating the number of "Remove" boxes)

  Call CBP_UpdateAddBucketList

  ; Display the "Bucket Selection Page" and wait for user to enter data and click "Continue"

  !insertmacro MUI_INSTALLOPTIONS_DISPLAY_RETURN "${CBP_C_INIFILE}"
  Pop ${CBP_L_RESULT}

  StrCmp ${CBP_L_RESULT} "cancel" finished_now
  StrCmp ${CBP_L_RESULT} "back" finished_now

  ; Now check the user input... starting with the "Remove" check boxes as deletion has higher
  ; priority (we allow user to "Delete an existing bucket" and "Create a new bucket" when the
  ; bucket list is full)

  StrCpy ${CBP_L_NAME} ${CBP_C_FIRST_BN_TEXT}
  StrCpy ${CBP_L_PTR} ${CBP_C_FIRST_BN_CBOX}
  IntOp ${CBP_L_LOOP_LIMIT} ${CBP_C_FIRST_BN_CBOX} + ${CBP_L_COUNT}

look_for_ticks:
  !insertmacro MUI_INSTALLOPTIONS_READ ${CBP_L_TEMP} "${CBP_C_INIFILE}" \
      "Field ${CBP_L_PTR}" "State"
  IntCmp ${CBP_L_TEMP} 1 process_deletions
  IntOp ${CBP_L_NAME} ${CBP_L_NAME} + 1
  IntOp ${CBP_L_PTR} ${CBP_L_PTR} + 1
  IntCmp ${CBP_L_PTR} ${CBP_L_LOOP_LIMIT} no_deletes look_for_ticks

no_deletes:
  !insertmacro MUI_INSTALLOPTIONS_READ ${CBP_L_CREATE_NAME} "${CBP_C_INIFILE}" \
      "Field ${CBP_C_CREATE_BN}" "State"
  StrCmp ${CBP_L_CREATE_NAME} "" no_user_input create_bucket

process_deletions:
  Push ${CBP_L_NAME}

  ; Work through the current entries in the bucket list, removing any entries for which the
  ; "Remove" checkbox has been ticked (and clearing the tick). The end result will be a list
  ; of bucket names without any gaps in the list. If all names are removed then an empty list
  ; will be shown.

pd_loop:
  !insertmacro MUI_INSTALLOPTIONS_WRITE "${CBP_C_INIFILE}" "Field ${CBP_L_PTR}" "State" 0

pd_loop2:
  IntOp ${CBP_L_NAME} ${CBP_L_NAME} + 1
  IntOp ${CBP_L_PTR} ${CBP_L_PTR} + 1
  IntCmp ${CBP_L_PTR} ${CBP_L_LOOP_LIMIT} tidy_up
  !insertmacro MUI_INSTALLOPTIONS_READ ${CBP_L_TEMP} "${CBP_C_INIFILE}" \
      "Field ${CBP_L_PTR}" "State"
  IntCmp ${CBP_L_TEMP} 1 pd_loop
  !insertmacro MUI_INSTALLOPTIONS_READ ${CBP_L_TEMP} "${CBP_C_INIFILE}" \
      "Field ${CBP_L_NAME}" "Text"
  Exch ${CBP_L_NAME}
  !insertmacro MUI_INSTALLOPTIONS_WRITE "${CBP_C_INIFILE}" \
      "Field ${CBP_L_NAME}" "Text" ${CBP_L_TEMP}
  IntOp ${CBP_L_NAME} ${CBP_L_NAME} + 1
  Exch ${CBP_L_NAME}
  goto pd_loop2

tidy_up:
  Pop ${CBP_L_NAME}
  IntOp ${CBP_L_TEMP} ${CBP_L_NAME} - ${CBP_C_FIRST_BN_TEXT}

clear_bucket:
  !insertmacro MUI_INSTALLOPTIONS_WRITE "${CBP_C_INIFILE}" "Field ${CBP_L_NAME}" "Text" ""
  IntOp ${CBP_L_NAME} ${CBP_L_NAME} + 1
  IntOp ${CBP_L_COUNT} ${CBP_L_COUNT} - 1
  IntCmp ${CBP_L_TEMP} ${CBP_L_COUNT} all_tidy_now clear_bucket

all_tidy_now:

  ; Bucket list has no gaps in it now!
  ; User is allowed to delete bucket(s) and create a bucket in one operation

  !insertmacro MUI_INSTALLOPTIONS_READ ${CBP_L_CREATE_NAME} "${CBP_C_INIFILE}" \
      "Field ${CBP_C_CREATE_BN}" "State"
  StrCmp ${CBP_L_CREATE_NAME} "" get_next_bucket_cmd

create_bucket:
  Push ${CBP_L_CREATE_NAME}
  Call CBP_FindBucket
  Pop ${CBP_L_PTR}
  StrCmp ${CBP_L_PTR} 0 does_not_exist name_exists

does_not_exist:
  IntCmp ${CBP_L_COUNT} ${CBP_C_MAX_BNCOUNT} too_many
  Push ${CBP_L_CREATE_NAME}
  Call CBP_StrCheckName
  Pop ${CBP_L_NAME}
  StrCmp ${CBP_L_NAME} "" bad_name
  IntOp ${CBP_L_PTR} ${CBP_L_COUNT} + ${CBP_C_FIRST_BN_TEXT}
  !insertmacro MUI_INSTALLOPTIONS_WRITE "${CBP_C_INIFILE}" \
      "Field ${CBP_L_PTR}" "Text" ${CBP_L_NAME}
  IntOP ${CBP_L_COUNT} ${CBP_L_COUNT} + 1
  goto get_next_bucket_cmd

name_exists:
  MessageBox MB_OK "Sorry! A bucket called $\"${CBP_L_CREATE_NAME}$\" has already been \
      defined.$\n$\nPlease choose a different name for the new bucket."
  goto get_next_bucket_cmd

too_many:
  MessageBox MB_OK "Sorry! The installer can only create up to ${CBP_C_MAX_BNCOUNT} buckets.\
      $\n$\nOnce POPFile has been installed you can create more than ${CBP_C_MAX_BNCOUNT} \
      buckets."
  goto get_next_bucket_cmd

bad_name:
  MessageBox MB_OK "The name $\"${CBP_L_CREATE_NAME}$\" is not a valid name for a bucket.\
      $\n$\nBucket names can only contain lowercase letters, the digits 0 to 9, \
      hyphens and underscores.$\n$\nPlease choose a different name for the new bucket."
  goto get_next_bucket_cmd

no_user_input:
  IntCmp ${CBP_L_COUNT} 0 need_buckets
  IntCmp ${CBP_L_COUNT} 1 too_few
  MessageBox MB_YESNO "${CBP_L_COUNT} buckets have been defined for use by POPFile.$\n$\n\
      Do you want to configure POPFile to use these buckets?$\n$\nClick 'No' if you wish \
      to change your bucket selections." IDYES finished_buckets
  goto get_next_bucket_cmd

need_buckets:
  MessageBox MB_OK "POPFile requires AT LEAST TWO buckets before it can classify your email.\
      $\n$\nPlease enter the name of a bucket to be created, either by picking a suggested\
      $\n$\nname from the drop-down list or by typing in a name of your own choice."
  goto get_next_bucket_cmd

too_few:
  MessageBox MB_OK "Sorry! You must define AT LEAST TWO buckets$\n$\n\
      before continuing with the installation of POPFile."
  goto get_next_bucket_cmd

finished_buckets:
  Push ${CBP_C_FIRST_BN_TEXT}
  Push ${CBP_L_COUNT}
  Call CBP_MakePOPFileBuckets
  Pop ${CBP_L_RESULT}
  StrCmp ${CBP_L_RESULT} "0" finished_now
  MessageBox MB_OK "Sorry! The installer was unable to create ${CBP_L_RESULT} of the \
      ${CBP_L_COUNT} buckets you selected.$\n$\nOnce POPFile has been installed you can use \
      its 'User Interface'$\n$\ncontrol panel to create the missing bucket(s)."

finished_now:

  Pop ${CBP_L_TEMP}
  Pop ${CBP_L_RESULT}
  Pop ${CBP_L_PTR}
  Pop ${CBP_L_NAME}
  Pop ${CBP_L_LOOP_LIMIT}
  Pop ${CBP_L_CREATE_NAME}
  Pop ${CBP_L_COUNT}

  !undef CBP_L_COUNT
  !undef CBP_L_CREATE_NAME
  !undef CBP_L_LOOP_LIMIT
  !undef CBP_L_NAME
  !undef CBP_L_PTR
  !undef CBP_L_RESULT
  !undef CBP_L_TEMP

FunctionEnd

#==============================================================================================
# Function CBP_SetDefaultBuckets
#==============================================================================================
# Used to create the initial bucket list. The default buckets are added to the list of selected
# buckets then the remaining entries are cleared. The "Remove" check boxes are also reset.
# This function ignores any invalid names in the list of default bucket names.
#
# For convenience this function also validates the list of suggested bucket names and stores the
# results in the INI file used for the "Create Buckets" custom page.
#----------------------------------------------------------------------------------------------
# Inputs:
#   (top of stack)                - string containing the default bucket names,
#                                   separated by "|" chars
#                                   (string is "" or "|" if no defaults required)
#----------------------------------------------------------------------------------------------
# Outputs:
#   (top of stack)                - number of default buckets created,
#                                   in the range 0 to ${CBP_C_MAX_BNCOUNT}
#----------------------------------------------------------------------------------------------
# Global Registers Destroyed:
#   (none)
#
# Local Registers Destroyed:
#   (none)
#----------------------------------------------------------------------------------------------
# Global CBP Constants Used:
#   CBP_C_FIRST_BN_CBOX           - field number of first "Remove" check box
#   CBP_C_FIRST_BN_TEXT           - field number of first name in list of selected buckets
#   CBP_C_INIFILE                 - name of the INI file used to create the custom page
#   CBP_C_LAST_BN_TEXT_PLUS_ONE   - used to terminate the loop when clearing out unused entries
#   CBP_C_MAX_BN_TEXT_PLUS_ONE    - used to terminate the loop when adding default bucket names
#   CBP_C_SUGGESTED_BUCKETS       - string holding suggested bucket names, may be empty or "|"
#----------------------------------------------------------------------------------------------
# CBP Functions Called:
#   CBP_ExtractBN                 - extracts a bucket name from a "|" separated list
#   CBP_FindBucket                - used to check for duplicate names in the default bucket list
#   CBP_StrCheckName              - used to validate name from the list of default buckets
#   CBP_StrStr                    - used to check for duplicate names in suggestions list
#----------------------------------------------------------------------------------------------
# Called By:
#   CBP_CreateBucketsPage         - the function which "controls" the "Create Buckets" page
#----------------------------------------------------------------------------------------------
#  Usage Example:
#
#    Push "personal|spam|work"
#    Call CBP_SetDefaultBuckets
#    Pop $R0
#
#   ; $R0 holds '3' at this point, indicating that three default buckets were created
#
#==============================================================================================

Function CBP_SetDefaultBuckets

  !define CBP_L_BOX_PTR     $R9   ; used to access the "Remove" check boxes
  !define CBP_L_COUNT       $R8   ; counts number of buckets added to list
  !define CBP_L_NAME        $R7   ; a bucket name (from default list or from suggestions list)
  !define CBP_L_NAMELIST    $R6   ; the list of default bucket names
  !define CBP_L_PTR         $R5   ; used to process suggestions and access names in bucket list
  !define CBP_L_RESULT      $R4
  !define CBP_L_SUGGLIST    $R3   ; the list of (potential) suggested names

  Exch ${CBP_L_NAMELIST}    ; Get list of default names (will be "" or "|" if no names in list)
  Push ${CBP_L_COUNT}
  Exch
  Push ${CBP_L_BOX_PTR}
  Push ${CBP_L_NAME}
  Push ${CBP_L_PTR}
  Push ${CBP_L_RESULT}
  Push ${CBP_L_SUGGLIST}

  ; Validate the list of suggested bucket names (used to update the "Create Bucket" ComboBox)
  ; and store the results in the INI file for later use by the CBP_UpdateAddBucketList function

  StrCpy ${CBP_L_PTR} ""    ; used to hold the list of validated names
  StrCpy ${CBP_L_SUGGLIST} `${CBP_C_SUGGESTED_BUCKETS}|`
  StrCmp ${CBP_L_SUGGLIST} "|" suggestions_done
  StrCmp ${CBP_L_SUGGLIST} "||" suggestions_done

next_sugg:
  Push ${CBP_L_SUGGLIST}
  Call CBP_ExtractBN            ; extract next name from the list of suggested bucket names
  Pop ${CBP_L_SUGGLIST}
  Pop ${CBP_L_NAME}
  StrCmp ${CBP_L_NAME} "" suggestions_done
  Push ${CBP_L_NAME}
  Call CBP_StrCheckName         ; check if name is valid, return "" if invalid
  Pop ${CBP_L_NAME}
  StrCmp ${CBP_L_NAME} "" next_sugg
  Push "${CBP_L_PTR}|"
  Push "|${CBP_L_NAME}|"
  Call CBP_StrStr
  Pop ${CBP_L_RESULT}
  StrCmp ${CBP_L_RESULT} "" 0 next_sugg   ; if name is a duplicate, go look for next name
  StrCpy ${CBP_L_PTR} ${CBP_L_PTR}|${CBP_L_NAME}
  StrCmp ${CBP_L_SUGGLIST} "" suggestions_done next_sugg

suggestions_done:

  ; Now store the validated list of suggestions for bucket names.
  ; An empty suggestions list is represented by "|"

  StrCmp ${CBP_L_PTR} "" 0 save_suggestions
  StrCpy ${CBP_L_PTR} "|"

save_suggestions:
  !insertmacro MUI_INSTALLOPTIONS_WRITE "${CBP_C_INIFILE}" \
      "CBP Data" "Suggestions" ${CBP_L_PTR}

  ; Set up the default bucket list using the data supplied by the calling routine.
  ; If too many default names are supplied, we quietly ignore the "extra" ones.
  ; If duplicated names are supplied, only the first instance is used.

  StrCpy ${CBP_L_COUNT} 0
  StrCpy ${CBP_L_PTR} ${CBP_C_FIRST_BN_TEXT}
  StrCpy ${CBP_L_BOX_PTR} ${CBP_C_FIRST_BN_CBOX}

  StrCmp ${CBP_L_NAMELIST} "|" clear_unused_entry

loop:
  StrCmp ${CBP_L_NAMELIST} "" clear_unused_entry
  Push ${CBP_L_NAMELIST}
  Call CBP_ExtractBN        ; get next default name from the "|" separated list
  Pop ${CBP_L_NAMELIST}
  Call CBP_StrCheckName     ; check if name is valid
  Pop ${CBP_L_NAME}
  StrCmp ${CBP_L_NAME} "" loop  ; ignore invalid names
  Push ${CBP_L_NAME}
  Call CBP_FindBucket
  Pop ${CBP_L_RESULT}
  StrCmp ${CBP_L_RESULT} 0 0 loop ; ignore duplicates

  !insertmacro MUI_INSTALLOPTIONS_WRITE "${CBP_C_INIFILE}" \
        "Field ${CBP_L_PTR}" "Text" ${CBP_L_NAME}
  !insertmacro MUI_INSTALLOPTIONS_WRITE "${CBP_C_INIFILE}" \
        "Field ${CBP_L_BOX_PTR}" "State" 0
  IntOp ${CBP_L_COUNT} ${CBP_L_COUNT} + 1
  IntOp ${CBP_L_BOX_PTR} ${CBP_L_BOX_PTR} + 1
  IntOp ${CBP_L_PTR} ${CBP_L_PTR} + 1
  IntCmp ${CBP_L_PTR} ${CBP_C_MAX_BN_TEXT_PLUS_ONE} finished_defaults
  StrCmp ${CBP_L_NAMELIST} "" clear_unused_entry
  Goto loop

  ; Now clear the remaining entries in the list
  ; (we process all 8 entries to ensure we start with a clean slate)

clear_unused_entry:
  !insertmacro MUI_INSTALLOPTIONS_WRITE "${CBP_C_INIFILE}" "Field ${CBP_L_PTR}" "Text" ""
  !insertmacro MUI_INSTALLOPTIONS_WRITE "${CBP_C_INIFILE}" "Field ${CBP_L_BOX_PTR}" "State" 0
  IntOp ${CBP_L_PTR} ${CBP_L_PTR} + 1
  IntOp ${CBP_L_BOX_PTR} ${CBP_L_BOX_PTR} + 1

finished_defaults:
  IntCmp ${CBP_L_PTR} ${CBP_C_LAST_BN_TEXT_PLUS_ONE} finished_now clear_unused_entry

finished_now:
  Pop ${CBP_L_SUGGLIST}
  Pop ${CBP_L_RESULT}
  Pop ${CBP_L_PTR}
  Pop ${CBP_L_NAME}
  Pop ${CBP_L_BOX_PTR}
  Pop ${CBP_L_NAMELIST}
  Exch ${CBP_L_COUNT}     ; top of stack now has number of default buckets created

  !undef CBP_L_BOX_PTR
  !undef CBP_L_COUNT
  !undef CBP_L_NAME
  !undef CBP_L_NAMELIST
  !undef CBP_L_PTR
  !undef CBP_L_RESULT
  !undef CBP_L_SUGGLIST

FunctionEnd

#==============================================================================================
# Function CBP_StrCheckName
#==============================================================================================
# Converts a string containing a bucket name to lowercase and ensures it only contains
# characters in the ranges 'a' to 'z' and '0' to '9', plus the '-' and '_' characters.
# If any invalid characters are found, this function returns "" instead of the converted name.
#----------------------------------------------------------------------------------------------
# Inputs:
#   (top of stack)                - string containing a bucket name (may be an invalid name)
#----------------------------------------------------------------------------------------------
# Outputs:
#   (top of stack)                - valid form of bucket name (or "" if input was not valid)
#----------------------------------------------------------------------------------------------
# Global Registers Destroyed:
#   (None)
#
# Local Registers Destroyed:
#   (None)
#----------------------------------------------------------------------------------------------
# Global CBP Constants Used:
#   (None)
#----------------------------------------------------------------------------------------------
# CBP Functions Called:
#   (none)
#----------------------------------------------------------------------------------------------
# Called By:
#   CBP_CreateBucketsPage         - the function which "controls" the "Create Buckets" page
#   CBP_SetDefaultBuckets         - sets up default buckets and validates the suggestions list
#----------------------------------------------------------------------------------------------
#  Usage Example:
#
#    Push "THIS_IS_A_STRING"
#    Call CBP_StrCheckName
#    Pop $R0
#
#   ($R0 at this point is "this_is_a_string")
#
#   If the string contains invalid characters, a null string is returned.
#
#==============================================================================================

Function CBP_StrCheckName

  ; Bucket names can contain only lowercase letters, digits (0-9), underscores (_) & hyphens (-)

  !define CBP_VALIDCHARS    "abcdefghijklmnopqrstuvwxyz_-0123456789"
  
  Exch $0   ; The input string
  Push $1   ; Number of characters in ${CBP_VALIDCHARS}
  Push $2   ; Holds the result (either "" or a valid bucket name derived from the input string)
  Push $3   ; A character from the input string
  Push $4   ; The offset to a character in the "validity check" string
  Push $5   ; A character from the "validity check" string
  Push $6   ; Holds the current "validity check" string

  StrLen $1 "${CBP_VALIDCHARS}"
  StrCpy $2 ""
  
next_input_char:
  StrCpy $3 $0 1              ; Get next character from the input string
  StrCmp $3 "" done
  StrCpy $6 ${CBP_VALIDCHARS}$3  ; Add character to end of "validity check" to guarantee a match
  StrCpy $0 $0 "" 1
  StrCpy $4 -1
  
next_valid_char:
  IntOp $4 $4 + 1
  StrCpy $5 $6 1 $4   ; Extract next "valid" character (from "validity check" string)
  StrCmp $3 $5 0 next_valid_char
  IntCmp $4 $1 invalid_name 0 invalid_name  ; if match is with the char we added, name is bad
  StrCpy $2 $2$5      ; Use "valid" character to ensure we store lowercase letters in the result
  goto next_input_char
  
invalid_name:
  StrCpy $2 ""
  
done:
  StrCpy $0 $2      ; Result is either a valid bucket name or ""
  Pop $6
  Pop $5
  Pop $4
  Pop $3
  Pop $2
  Pop $1
  Exch $0           ; place result on top of the stack
  
  !undef CBP_VALIDCHARS

FunctionEnd

#==============================================================================================
# Function CBP_ExtractBN
#==============================================================================================
# Extracts a bucket name from a list of names separated by "|" characters.
#
# If the list of names starts with a "|", this will be ignored and the next name, if any,
# will be returned. If the list contains the sequence "||" this will be treated as "|".
# The sequence "|||" will be treated as an empty name.
#
# Some examples:
#
#     input: "box|car|van"      output: bucket name = "box", revised list = "car|van"
#     input: "box||car|van"     output: bucket name = "box", revised list = "|car|van"
#     input: "|car|van"         output: bucket name = "car", revised list = "van"
#     input: "van"              output: bucket name = "van", revised list = ""
#     input: "box|||car|van"    output: bucket name = "box", revised list = "||car|van"
#     input: "||car|van"        output: bucket name = "",    revised list = "car|van"
#----------------------------------------------------------------------------------------------
# Inputs:
#   (top of stack)                - string containing bucket names separated by "|" chars
#----------------------------------------------------------------------------------------------
# Outputs:
#   (top of stack)                - input string, minus the first bucket name and associated "|"
#   (top of stack - 1)            - first bucket name found in the string (minus the "|")
#----------------------------------------------------------------------------------------------
# Global Registers Destroyed:
#   (None)
#
# Local Registers Destroyed:
#   (None)
#----------------------------------------------------------------------------------------------
# Global CBP Constants Used:
#   (None)
#----------------------------------------------------------------------------------------------
# CBP Functions Called:
#   (none)
#----------------------------------------------------------------------------------------------
# Called By:
#   CBP_SetDefaultBuckets         - sets up default buckets (if any)
#   CBP_UpdateAddBucketList       - updates the list of names in "Create Bucket" combobox
#----------------------------------------------------------------------------------------------
#  Usage example:
#
#    Push "|business|junk|personal"   ; using "business|junk|personal" will give same result
#    Call CBP_ExtractBN
#    Pop $R0
#    Pop $R1
#
#   ($R0 at this point is "junk|personal")
#   ($R1 at this point is "business")
#
#   If no name found in the list, $R1 is ""
#   If last name has been extracted from the list, $R0 is ""
#
#==============================================================================================

Function CBP_ExtractBN

  Exch $0             ; get list of bucket names
  Push $1
  Push $2
  
  ; If the list of names starts with "|" character, ignore the "|"
  
  StrCpy $2 $0 1
  StrCmp $2 "|" 0 start_now
  StrCpy $0 $0 "" 1

start_now:

  StrCpy $1 ""        ; Reset the output name

Loop:
  StrCpy $2 $0 1      ; Get next character from the list
  StrCmp $2 "" Done
  StrCpy $0 $0 "" 1
  StrCmp $2 "|" Done
  StrCpy $1 $1$2      ; Append character to the output name
  Goto Loop

Done:
  Pop $2
  Exch $1             ; put output name on stack
  Exch
  Exch $0             ; put modified list of names on stack

FunctionEnd

#==============================================================================================
# Function CBP_FindBucket
#==============================================================================================
# Given a bucket name, look for it in the current list and return the field number of the
# matching bucket entry (if name not found, return 0).
#----------------------------------------------------------------------------------------------
# Inputs:
#   (top of stack)                - the bucket name to be found
#----------------------------------------------------------------------------------------------
# Outputs:
#   (top of stack)                - field number of matching bucket name
#                                   (If not found then = 0, else it is a number
#                                   between CBP_C_FIRST_BN_TEXT and CBP_C_MAX_BN_TEXT)
#----------------------------------------------------------------------------------------------
# Global Registers Destroyed:
#   (none)
#
# Local Registers Destroyed:
#   (none)
#----------------------------------------------------------------------------------------------
# Global CBP Constants Used:
#   CBP_C_FIRST_BN_CBOX_MINUS_ONE - used when determining how many bucket names to search
#   CBP_C_FIRST_BN_TEXT           - field number of first entry in list of names
#   CBP_C_INIFILE                 - name of the INI file used to create the custom page
#----------------------------------------------------------------------------------------------
# CBP Functions Called:
#   (none)
#----------------------------------------------------------------------------------------------
# Called By:
#   CBP_CreateBucketsPage         - the function which "controls" the "Create Buckets" page
#   CBP_SetDefaultBuckets         - sets up default buckets (if any)
#   CBP_UpdateAddBucketList       - updates the list of names shown by the "Create" combobox
#----------------------------------------------------------------------------------------------
#  Usage Example:
#
#    Push "a_bucket_name"
#    Call CBP_FindBucket
#    Pop $R0
#
#    ; $R0 is 0 if name not found, else it is field number of the name
#
#==============================================================================================

Function CBP_FindBucket

  !define CBP_L_LISTNAME    $R9     ; a name from the bucket list
  !define CBP_L_LOOP_LIMIT  $R8     ; used to terminate processing loop
  !define CBP_L_NAME        $R7     ; the name we are trying to find
  !define CBP_L_PTR         $R6     ; used to access the name fields in the list

  Exch ${CBP_L_NAME}      ; get name of bucket we are to look for
  Push ${CBP_L_PTR}
  Exch
  Push ${CBP_L_LISTNAME}
  Push ${CBP_L_LOOP_LIMIT}

  ; Set loop limit to one more than the field number of last name in the bucket list, using
  ; the number of "Remove" boxes on display to determine how many names, if any, are in the list

  ReadINIStr ${CBP_L_LOOP_LIMIT} "$PLUGINSDIR\${CBP_C_INIFILE}" "Settings" "NumFields"
  IntOp ${CBP_L_LOOP_LIMIT} ${CBP_L_LOOP_LIMIT} - ${CBP_C_FIRST_BN_CBOX_MINUS_ONE}
  IntOp ${CBP_L_LOOP_LIMIT} ${CBP_L_LOOP_LIMIT} + ${CBP_C_FIRST_BN_TEXT}

  ; Loop through the bucket list and check if the bucket name matches the one we are looking for

  StrCpy ${CBP_L_PTR} ${CBP_C_FIRST_BN_TEXT}

check_next_bucket:
  IntCmp ${CBP_L_PTR} ${CBP_L_LOOP_LIMIT} not_found
  !insertmacro MUI_INSTALLOPTIONS_READ ${CBP_L_LISTNAME} "${CBP_C_INIFILE}" \
      "Field ${CBP_L_PTR}" "Text"
  StrCmp ${CBP_L_NAME} ${CBP_L_LISTNAME} all_done
  IntOp ${CBP_L_PTR} ${CBP_L_PTR} + 1
  goto check_next_bucket

not_found:
  StrCpy ${CBP_L_PTR} 0

all_done:
  Pop ${CBP_L_LOOP_LIMIT}
  Pop ${CBP_L_LISTNAME}
  Pop ${CBP_L_NAME}
  Exch ${CBP_L_PTR}   ; top of stack is now field number of bucket name or 0 if name not found

  !undef CBP_L_LISTNAME
  !undef CBP_L_LOOP_LIMIT
  !undef CBP_L_NAME
  !undef CBP_L_PTR

FunctionEnd

#==============================================================================================
# Function CBP_UpdateAddBucketList
#==============================================================================================
# Updates the combobox list containing suggested names for buckets, ensuring that the list only
# shows names which have not yet been used. Called every time the page is updated.
#----------------------------------------------------------------------------------------------
# Inputs:
#   (none)
#----------------------------------------------------------------------------------------------
# Outputs:
#   (none)
#----------------------------------------------------------------------------------------------
# Global Registers Destroyed:
#   (none)
#
# Local Registers Destroyed:
#   (none)
#----------------------------------------------------------------------------------------------
# Global CBP Constants Used:
#   CBP_C_CREATE_BN               - field number of combobox used to enter new bucket names
#   CBP_C_FULL_COMBO_LIST         - make combobox list full size
#   CBP_C_INIFILE                 - name of the INI file used to create the custom page
#   CBP_C_MIN_COMBO_LIST          - make combobox list one entry high (because it is empty)
#----------------------------------------------------------------------------------------------
# CBP Functions Called:
#   CBP_ExtractBN                 - extracts a bucket name from a "|" separated list
#   CBP_FindBucket                - checks if a name appears in the bucket list
#----------------------------------------------------------------------------------------------
# Called By:
#   CBP_CreateBucketsPage         - the function which "controls" the "Create Buckets" page
#----------------------------------------------------------------------------------------------
#  Usage Example:
#
#    Call CBP_UpdateAddBucketList
#
#==============================================================================================

Function CBP_UpdateAddBucketList

  !define CBP_L_PTR         $R9       ; field number of name in bucket list, or 0 if not found
  !define CBP_L_SUGGLIST    $R8       ; the list of (potential) suggested names
  !define CBP_L_SUGGNAME    $R7       ; one name from the list of suggested names
  !define CBP_L_UNUSEDSUGG  $R6       ; unused suggestions (i.e. those not in bucket list)

  Push ${CBP_L_PTR}
  Push ${CBP_L_SUGGLIST}
  Push ${CBP_L_SUGGNAME}
  Push ${CBP_L_UNUSEDSUGG}

  ; Reset the list of suggested names which have not yet been used

  StrCpy ${CBP_L_UNUSEDSUGG} ""

  ; Set up the default list of suggested bucket names (if any).
  ; An empty list is represented by "|" in the INI file

  !insertmacro MUI_INSTALLOPTIONS_READ ${CBP_L_SUGGLIST} "${CBP_C_INIFILE}" \
      "CBP Data" "Suggestions"
  StrCmp ${CBP_L_SUGGLIST} "|" suggestions_done

next_sugg:
  Push ${CBP_L_SUGGLIST}
  Call CBP_ExtractBN            ; extract next name from the list of suggested bucket names
  Pop ${CBP_L_SUGGLIST}
  Pop ${CBP_L_SUGGNAME}
  StrCmp ${CBP_L_SUGGNAME} "" suggestions_done
  Push ${CBP_L_SUGGNAME}
  Call CBP_FindBucket
  Pop ${CBP_L_PTR}
  StrCmp ${CBP_L_PTR} 0 not_found next_sugg

not_found:
  StrCpy ${CBP_L_UNUSEDSUGG} ${CBP_L_UNUSEDSUGG}|${CBP_L_SUGGNAME}
  StrCmp ${CBP_L_SUGGLIST} "" suggestions_done next_sugg

suggestions_done:

  StrCpy ${CBP_L_UNUSEDSUGG} ${CBP_L_UNUSEDSUGG} "" 1

  ; Now update the combobox with the list of suggestions for bucket names

  !insertmacro MUI_INSTALLOPTIONS_WRITE "${CBP_C_INIFILE}" \
      "Field ${CBP_C_CREATE_BN}" "ListItems" ${CBP_L_UNUSEDSUGG}

  ; Adjust size of the ComboBox List to keep the display tidy

  StrCmp ${CBP_L_UNUSEDSUGG} "" min_size
  !insertmacro MUI_INSTALLOPTIONS_WRITE "${CBP_C_INIFILE}" \
      "Field ${CBP_C_CREATE_BN}" "Bottom" ${CBP_C_FULL_COMBO_LIST}
  goto end_update

min_size:
  !insertmacro MUI_INSTALLOPTIONS_WRITE "${CBP_C_INIFILE}" \
      "Field ${CBP_C_CREATE_BN}" "Bottom" ${CBP_C_MIN_COMBO_LIST}

end_update:

  Pop ${CBP_L_UNUSEDSUGG}
  Pop ${CBP_L_SUGGNAME}
  Pop ${CBP_L_SUGGLIST}
  Pop ${CBP_L_PTR}

  !undef CBP_L_PTR
  !undef CBP_L_SUGGLIST
  !undef CBP_L_SUGGNAME
  !undef CBP_L_UNUSEDSUGG

FunctionEnd

#==============================================================================================
# Function CBP_StrStr
#==============================================================================================
# Used to search within a string. Returns "" if string is not found, otherwise returns matching
# substring (which may be longer than the string we searched for).
#----------------------------------------------------------------------------------------------
# Inputs:
#   (top of stack)                - string to be searched for
#   (top of stack - 1)            - string in which to search
#----------------------------------------------------------------------------------------------
# Outputs:
#   (top of stack)                - "" if string not found, else the matching substring
#----------------------------------------------------------------------------------------------
# Global Registers Destroyed:
#   (none)
#
# Local Registers Destroyed:
#   (none)
#----------------------------------------------------------------------------------------------
# Global CBP Constants Used:
#   (none)
#----------------------------------------------------------------------------------------------
# CBP Functions Called:
#   (none)
#----------------------------------------------------------------------------------------------
# Called By:
#   CBP_SetDefaultBuckets         - sets up default buckets (if any)
#----------------------------------------------------------------------------------------------
#  Usage Example:
#
#    Push "this is a long string"
#    Push "long"
#    Call CBP_StrStr
#    Pop $R0
#
#   ($R0 at this point is "long string")
#
#==============================================================================================

Function CBP_StrStr
  Exch $R1    ; $R1 = needle, top of stack = old$R1, haystack
  Exch        ; Top of stack = haystack, old$R1
  Exch $R2    ; $R2 = haystack, top of stack = old$R2, old$R1

  Push $R3
  Push $R4
  Push $R5

  StrLen $R3 $R1
  StrCpy $R4 0

    ; $R1 = needle
    ; $R2 = haystack
    ; $R3 = len(needle)
    ; $R4 = cnt
    ; $R5 = tmp

loop:
  StrCpy $R5 $R2 $R3 $R4
  StrCmp $R5 $R1 done
  StrCmp $R5 "" done
  IntOp $R4 $R4 + 1
  Goto loop

done:
  StrCpy $R1 $R2 "" $R4

  Pop $R5
  Pop $R4
  Pop $R3

  Pop $R2
  Exch $R1
FunctionEnd

#==============================================================================================
# Now destroy all the local/internal "!defines" which were created at the start of this file
#==============================================================================================

  !undef CBP_C_INIFILE

  !undef CBP_C_DEFAULT_BUCKETS
  !undef CBP_C_SUGGESTED_BUCKETS

  !undef CBP_C_CREATE_BN

  !undef CBP_C_FULL_COMBO_LIST
  !undef CBP_C_MIN_COMBO_LIST

  !undef CBP_C_MESSAGE

  !undef CBP_C_FIRST_BN_CBOX
  !undef CBP_C_FIRST_BN_CBOX_MINUS_ONE
  !undef CBP_C_FIRST_BN_TEXT
  !undef CBP_C_LAST_BN_TEXT_PLUS_ONE

  !undef CBP_C_MAX_BNCOUNT
  !undef CBP_C_MAX_BN_TEXT_PLUS_ONE
  !undef CBP_MAX_BN_CBOX_PLUS_ONE

#==============================================================================================
# End of CBP.nsh
#==============================================================================================
