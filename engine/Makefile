# POPFile Makefile
#
# This Makefile is used for the creation of POPFile packages
# and for testing
#
# Copyright (c) 2003-2011 John Graham-Cumming

include vars.mak

.PHONY: test package windows core languages skins coverage macosx rc

error:
	@echo Must specify one of coverage, test, package or windows
	@echo
	@echo "coverage - Run POPFile test suite with coverage information"
	@echo "cover    - Run POPFile test suite with coverage information provided by Devel::Cover"
	@echo "test     - Run POPFile test suite"
	@echo "eachtest - Run POPFile tests one by one"
	@echo "           (test and coverage pass TESTARGS to the test suite)"
	@echo
	@echo "windows  - Build Windows executables and installer"
	@echo "macosx   - Build Mac OS X package installer"
	@echo "xplat    - Build the cross-platform ZIP"
	@echo "package  - Build Windows installer, and create"
	@echo "           ZIP files for Windows and cross-platform"
	@echo "           version"
	@echo "rc       - After doing package moves ZIP files to be RC zip files"
	@echo "           The RC number is set with the RC parameter so do"
	@echo "           make rc RC=RC6 for example."

# test runs the POPFile unit test suite

coverage:
	@echo Running test suite with code coverage
ifdef TESTARGS
	@echo with arguments '$(TESTARGS)'
endif
	@$(MAKE) --no-print-directory -C tests runtest TESTARGS=$(TESTARGS) DEBUGARGS=-d:TestCoverage

cover:
	@echo Running test suite with code coverage by Devel::Cover
ifdef TESTARGS
	@echo with arguments '$(TESTARGS)'
endif
	@$(MAKE) --no-print-directory -C tests runtest TESTARGS=$(TESTARGS) COVERARGS=-MDevel::Cover=-db,cover_db,-coverage,statement,branch,condition,path,subroutine,-silent,ON,-summary,ON

test:
	@echo Running test suite
ifdef TESTARGS
	@echo with arguments '$(TESTARGS)'
endif
	@$(MAKE) --no-print-directory -C tests runtest TESTARGS=$(TESTARGS) DEBUGARGS=

warn:
	@echo Running test suite
ifdef TESTARGS
	@echo with arguments '$(TESTARGS)'
endif
	@$(MAKE) --no-print-directory -C tests runtest TESTARGS=$(TESTARGS) DEBUGARGS=-w

eachtest:
	@echo Running test suite
	@$(MAKE) --no-print-directory -C tests eachtest DEBUGARGS=

# Mac OS X is built in the Mac OS X directory

macosx: ; @$(MAKE) -C ../macosx

# Builds the 6 popfile*.exe Windows applications

winexe: popfile.exe popfileb.exe popfilef.exe popfileib.exe popfileif.exe ../windows/POPFileIcon/popfile.ico popfile-service.exe

COMMON_EXE_OPTIONS = --exe $@ --force --clean --dependent --xclude --icon ../windows/POPFileIcon/popfile.ico --script $< --info CompanyName="The POPFile Project" --info LegalCopyright="Copyright (c) $(POPFILE_BUILD_YEAR) John Graham-Cumming" --info LegalTrademarks="POPFile is a registered trademark of John Graham-Cumming" --info ProductName=POPFile --info ProductVersion=$(POPFILE_VERSION).0 --info FileDescription=POPFile --info FileVersion=$(POPFILE_VERSION).0
ifeq ($(EXE_DEBUG),1)
COMMON_EXE_OPTIONS += --debug
endif

# Builds the 5 basic Windows applications using PerlApp

popfile.exe: popfile-windows.pl $(POPFILE_VERSION_FILE)
	perlapp --gui $(COMMON_EXE_OPTIONS)

popfileif.exe: popfile-tray2.pl POPFile/Loader.pm $(POPFILE_VERSION_FILE)
	perlapp $(COMMON_EXE_OPTIONS)

popfileib.exe: popfile-tray2.pl POPFile/Loader.pm $(POPFILE_VERSION_FILE)
	perlapp --gui $(COMMON_EXE_OPTIONS)

popfilef.exe: popfile.pl POPFile/Loader.pm $(POPFILE_VERSION_FILE)
	perlapp $(COMMON_EXE_OPTIONS)

popfileb.exe: popfile.pl POPFile/Loader.pm $(POPFILE_VERSION_FILE)
	perlapp --gui $(COMMON_EXE_OPTIONS)

# Builds a Windows service version of POPFile using PerlSvc

SVC_OPTIONS = $(COMMON_EXE_OPTIONS) --lib $(ABSOLUTE_ENGINE_PATH)

popfile-service.exe: popfile-service.pl $(POPFILE_VERSION_FILE)
	perlsvc $(SVC_OPTIONS)

# windows builds the Windows installer

windows: winexe; @$(MAKE) -C ../windows

# build a ZIPped up package of POPFile

LANGUAGES := $(wildcard languages/*.msg)

BUILD_ZIP=7z a -tzip $(POPFILE_ZIP) $^
xplat: $(POPFILE_ZIP)
$(POPFILE_ZIP): core languages skins POPFile/popfile_version

core: popfile.pl bayes.pl pipe.pl insert.pl Classifier/*.pm POPFile/*.pm Proxy/*.pm Services/*.pm  Services/IMAP/*.pm UI/*.pm v$(POPFILE_VERSION).change v$(POPFILE_VERSION).change.nihongo license stopwords favicon.ico $(POPFILE_VERSION_FILE) Classifier/popfile.sql popfile.pck
	rm -f $(POPFILE_ZIP)
	$(BUILD_ZIP)

languages: languages/*.msg
	$(BUILD_ZIP)

.PHONY: skins_css skins_gif skins_thtml
skins: skins_css skins_gif skins_thtml
skins_css: skins/*/*.css
	$(BUILD_ZIP)
skins_gif: skins/*/*.gif  skins/*/*.gif skins/*/*.png
	$(BUILD_ZIP)
skins_thtml: skins/*/*.thtml
	$(BUILD_ZIP)

# package builds a zip file containing the POPFile package and the windows
# installer

package: $(POPFILE_ZIP) windows

# Used to convert the ZIP files to RC ZIP files and
# upload to SourceForge

rc: RELEASE_FILES := $(POPFILE_ZIP) ../windows/$(POPFILE_WINDOWS_ZIP)
rc:
	chmod go+r $(RELEASE_FILES)
	scp -p $(RELEASE_FILES) jgrahamc@popfile.sourceforge.net:/home/groups/p/po/popfile/htdocs

# The POPFile version number is stored in a file called POPFile/popfile_version
# which we always write if vars.mak has changed

$(POPFILE_VERSION_FILE): vars.mak
	@echo $(POPFILE_MAJOR_VERSION) > $@
	@echo $(POPFILE_MINOR_VERSION) >> $@
	@echo $(POPFILE_REVISION) >> $@

# Make's the POPFile packing list

.PHONY: packing popfile.pck
packing: popfile.pck

popfile.pck: popfile.pl bayes.pl pipe.pl insert.pl Classifier/*.pm POPFile/*.pm Proxy/*.pm Services/*.pm UI/*.pm
	@perl make_packing_list.pl $@ $^
# DO NOT DELETE
