# Copyright (c) 2002-2011 John Graham-Cumming
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

.PHONY: all build clean optional

ENGINE=../engine
include $(ENGINE)/vars.mak

MAKENSIS_VERSION_STRING:=/DC_POPFILE_MAJOR_VERSION=$(POPFILE_MAJOR_VERSION) /DC_POPFILE_MINOR_VERSION=$(POPFILE_MINOR_VERSION) /DC_POPFILE_REVISION=$(POPFILE_REVISION) /DC_POPFILE_RC=$(RC)

MAKENSIS=echo ; echo Making $@ ; echo ; makensis.exe $(MAKENSIS_VERSION_STRING) /V4 /O$(patsubst %.exe,%.log,$(@F)) $(notdir $<)

BUILD_ZIP=7z a -tzip $(POPFILE_WINDOWS_ZIP) $^

SETUP:=setup$(RC).exe
ADDUSER=adduser.exe
MONITORCC=monitorcc.exe
MSGCAPTURE=msgcapture.exe
RUNPOPFILE=runpopfile.exe
RUNSQLITE=runsqlite.exe
STOP_PF=stop_pf.exe

DBSTATUS=test/pfidbstatus.exe
PFIDIAG=test/pfidiag.exe

APVERCHECK=toolkit/ap-vcheck.exe

PLUGINCHECK=toolkit/plugin-vcheck.exe
PLUGINSTATUS=plugin-status.nsh

CUSTOMUIS=UI/pfi_headerbmpr.exe UI/pfi_modern.exe
PFILANGS=pfi-languages.nsh languages/*-pfi.nsh
SCRIPTLIBS=pfi-library.nsh pfi-nsis-library.nsh

ADDSSL=add-ons/addssl.exe
DBICAPTURE=dbicapture.exe
ONDEMAND=add-ons/OnDemand.exe

ALLEXES := $(SETUP) $(ADDUSER) $(MONITORCC)  \
           $(MSGCAPTURE) $(RUNPOPFILE)       \
           $(RUNSQLITE) $(STOP_PF)           \
           $(DBSTATUS) $(PFIDIAG)            \
           $(APVERCHECK) $(PLUGINCHECK)      \
           $(POPFILE_WINDOWS_ZIP)            \
           $(ADDSSL) $(DBICAPTURE) $(ONDEMAND)

ALLNSISLOGS := *.log add-ons/*.log test/*.log toolkit/*.log

all: build

build: $(POPFILE_WINDOWS_ZIP)

$(POPFILE_WINDOWS_ZIP): $(SETUP)
	rm -f $@
	$(BUILD_ZIP)

clean:
	@rm -f $(ALLEXES) $(ALLNSISLOGS)

optional: $(ADDSSL) $(DBICAPTURE) $(ONDEMAND)

$(PLUGINSTATUS): $(PLUGINCHECK) toolkit/extra-plugins.md5
	@echo ; echo Making $@ ; $(PLUGINCHECK) ; touch $@

.SUFFIXES:
%.exe : %.nsi $(SCRIPTLIBS) hdr-common.bmp POPFileIcon/popfile.ico $(CUSTOMUIS) $(PLUGINSTATUS) ; @$(MAKENSIS)

$(SETUP): installer.nsi ; @$(MAKENSIS)
$(SETUP): $(ENGINE)/*.pl $(ENGINE)/Classifier/*.pm $(ENGINE)/Platform/MSWin32.pm $(ENGINE)/POPFile/*.pm $(ENGINE)/Proxy/*.pm $(ENGINE)/Services/*.pm $(ENGINE)/Services/IMAP/*.pm $(ENGINE)/UI/*.pm $(ENGINE)/v$(POPFILE_VERSION).change
$(SETUP): $(ENGINE)/languages/*.msg $(ENGINE)/skins/*/*.css $(ENGINE)/skins/*/*.gif $(ENGINE)/skins/*/*.thtml
$(SETUP): $(ENGINE)/popfile.exe $(ENGINE)/popfileb.exe $(ENGINE)/popfileib.exe $(ENGINE)/popfilef.exe $(ENGINE)/popfileif.exe $(ENGINE)/popfile-service.exe
$(SETUP): $(ADDUSER) $(MSGCAPTURE) $(RUNPOPFILE) $(RUNSQLITE) $(STOP_PF) $(DBSTATUS) $(PFIDIAG)
$(SETUP): $(APVERCHECK) $(PLUGINCHECK) $(CUSTOMUIS)
$(SETUP): getparser.nsh installer-SecMinPerl-body.nsh installer-SecPOPFile-body.nsh installer-SecPOPFile-func.nsh installer-Uninstall.nsh
$(SETUP): ioG.ini ioP.ini ioUM.ini $(PFILANGS) $(SCRIPTLIBS)
$(SETUP): special.bmp remove.ico hdr-common.bmp POPFileIcon/popfile.ico

$(ADDUSER): $(patsubst %.exe,%.nsi,$(ADDUSER))
$(ADDUSER): $(MONITORCC)
$(ADDUSER): CBP.nsh adduser-EMailConfig.nsh adduser-Uninstall.nsh adduser-Version.nsh
$(ADDUSER): ioA.ini ioB.ini ioC.ini ioE.ini ioF.ini $(PFILANGS)
$(ADDUSER): special.bmp remove.ico

# Note: $(DBICAPTURE) is NOT included in releases
#
$(DBICAPTURE): $(patsubst %.exe,%.nsi,$(DBICAPTURE))
$(DBICAPTURE): ioDTL.ini

$(MONITORCC): $(patsubst %.exe,%.nsi,$(MONITORCC))
$(MONITORCC): $(PFILANGS)

$(MSGCAPTURE): $(patsubst %.exe,%.nsi,$(MSGCAPTURE))

$(RUNPOPFILE): $(patsubst %.exe,%.nsi,$(RUNPOPFILE))
$(RUNPOPFILE): languages/English-pfi.nsh

$(RUNSQLITE): $(patsubst %.exe,%.nsi,$(RUNSQLITE))

$(STOP_PF) : stop_popfile.nsi shutdown.ico $(SCRIPTLIBS) $(PLUGINSTATUS)
	@$(MAKENSIS)

# A bug in the NSIS compiler means that some of the "predefines" do not get defined
# when compiling a script in a sub-directory. The version information for POPFile's
# NSIS-based utilities uses some of these missing "predefines". A simple workaround
# is to change to the sub-directory containing the script before compiling it.

$(DBSTATUS): test/pfidbstatus.nsi $(SCRIPTLIBS)
$(DBSTATUS): hdr-common.bmp POPFileIcon/popfile.ico
$(DBSTATUS): $(CUSTOMUIS) $(PLUGINSTATUS)
$(DBSTATUS):
	@cd $(dir $@) ; echo ; echo Making $@ ; echo ; makensis.exe /V4 /DCTS_INTEGRATED /O$(patsubst %.exe,%.log,$(@F)) $(notdir $<)

$(PFIDIAG): test/pfidiag.nsi $(SCRIPTLIBS)
$(PFIDIAG): hdr-common.bmp test/pfinfo.ico
$(PFIDIAG): $(CUSTOMUIS) $(PLUGINSTATUS)
$(PFIDIAG):
	@cd $(dir $@) ; $(MAKENSIS)

# Note: $(APVERCHECK) is used to check the Perl version when compiling $(SETUP)
#
$(APVERCHECK): toolkit/ap-vcheck.nsi POPFileIcon/popfile.ico
	@cd $(dir $@) ; $(MAKENSIS)

# Note: $(PLUGINCHECK) performs compile-time checks on the extra NSIS plugins used by POPFile
#
$(PLUGINCHECK): toolkit/plugin-vcheck.nsi $(SCRIPTLIBS) POPFileIcon/popfile.ico
	@cd $(dir $@) ; $(MAKENSIS)

# Note: $(ADDSSL) is NOT included in releases
#
$(ADDSSL): add-ons/addssl.nsi $(SCRIPTLIBS)
$(ADDSSL): add-ons/hdr-update.bmp add-ons/special-update.bmp POPFileIcon/popfile.ico
$(ADDSSL): $(CUSTOMUIS) $(PLUGINSTATUS)
$(ADDSSL):
	@cd $(dir $@) ; $(MAKENSIS)

# Note: $(ONDEMAND) is NOT included in releases
#
$(ONDEMAND): add-ons/OnDemand.nsi add-ons/OnDemand-default.ini add-ons/OnDemand.ico
$(ONDEMAND): $(SCRIPTLIBS) $(PLUGINSTATUS)
$(ONDEMAND):
	@cd $(dir $@) ; $(MAKENSIS)
