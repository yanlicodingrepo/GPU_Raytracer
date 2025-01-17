#############################################################################
# Makefile for building: final
# Generated by qmake (3.0) (Qt 5.0.2) on: ?? ?? 28 03:19:43 2014
# Project:  final.pro
# Template: app
# Command: C:\Qt\5.0.2\msvc2012_64\bin\qmake.exe -spec win32-msvc2012 CONFIG+=debug -o Makefile final.pro
#############################################################################

MAKEFILE      = Makefile

first: debug
install: debug-install
uninstall: debug-uninstall
QMAKE         = C:\Qt\5.0.2\msvc2012_64\bin\qmake.exe
DEL_FILE      = del
CHK_DIR_EXISTS= if not exist
MKDIR         = mkdir
COPY          = copy /y
COPY_FILE     = $(COPY)
COPY_DIR      = xcopy /s /q /y /i
INSTALL_FILE  = $(COPY_FILE)
INSTALL_PROGRAM = $(COPY_FILE)
INSTALL_DIR   = $(COPY_DIR)
DEL_FILE      = del
SYMLINK       = 
DEL_DIR       = rmdir
MOVE          = move
SUBTARGETS    =  \
		debug \
		release


debug: FORCE
	@set MAKEFLAGS=$(MAKEFLAGS)
	$(MAKE) -f $(MAKEFILE).Debug
debug-make_first: FORCE
	@set MAKEFLAGS=$(MAKEFLAGS)
	$(MAKE) -f $(MAKEFILE).Debug 
debug-all: FORCE
	@set MAKEFLAGS=$(MAKEFLAGS)
	$(MAKE) -f $(MAKEFILE).Debug all
debug-clean: FORCE
	@set MAKEFLAGS=$(MAKEFLAGS)
	$(MAKE) -f $(MAKEFILE).Debug clean
debug-distclean: FORCE
	@set MAKEFLAGS=$(MAKEFLAGS)
	$(MAKE) -f $(MAKEFILE).Debug distclean
debug-install: FORCE
	@set MAKEFLAGS=$(MAKEFLAGS)
	$(MAKE) -f $(MAKEFILE).Debug install
debug-uninstall: FORCE
	@set MAKEFLAGS=$(MAKEFLAGS)
	$(MAKE) -f $(MAKEFILE).Debug uninstall
release: FORCE
	@set MAKEFLAGS=$(MAKEFLAGS)
	$(MAKE) -f $(MAKEFILE).Release
release-make_first: FORCE
	@set MAKEFLAGS=$(MAKEFLAGS)
	$(MAKE) -f $(MAKEFILE).Release 
release-all: FORCE
	@set MAKEFLAGS=$(MAKEFLAGS)
	$(MAKE) -f $(MAKEFILE).Release all
release-clean: FORCE
	@set MAKEFLAGS=$(MAKEFLAGS)
	$(MAKE) -f $(MAKEFILE).Release clean
release-distclean: FORCE
	@set MAKEFLAGS=$(MAKEFLAGS)
	$(MAKE) -f $(MAKEFILE).Release distclean
release-install: FORCE
	@set MAKEFLAGS=$(MAKEFLAGS)
	$(MAKE) -f $(MAKEFILE).Release install
release-uninstall: FORCE
	@set MAKEFLAGS=$(MAKEFLAGS)
	$(MAKE) -f $(MAKEFILE).Release uninstall

Makefile: final.pro ..\..\..\..\Qt\5.0.2\msvc2012_64\mkspecs\win32-msvc2012\qmake.conf ..\..\..\..\Qt\5.0.2\msvc2012_64\mkspecs\features\spec_pre.prf \
		..\..\..\..\Qt\5.0.2\msvc2012_64\mkspecs\common\shell-win32.conf \
		..\..\..\..\Qt\5.0.2\msvc2012_64\mkspecs\qconfig.pri \
		..\..\..\..\Qt\5.0.2\msvc2012_64\mkspecs\modules\qt_lib_axbase.pri \
		..\..\..\..\Qt\5.0.2\msvc2012_64\mkspecs\modules\qt_lib_axcontainer.pri \
		..\..\..\..\Qt\5.0.2\msvc2012_64\mkspecs\modules\qt_lib_axserver.pri \
		..\..\..\..\Qt\5.0.2\msvc2012_64\mkspecs\modules\qt_lib_bootstrap.pri \
		..\..\..\..\Qt\5.0.2\msvc2012_64\mkspecs\modules\qt_lib_clucene.pri \
		..\..\..\..\Qt\5.0.2\msvc2012_64\mkspecs\modules\qt_lib_concurrent.pri \
		..\..\..\..\Qt\5.0.2\msvc2012_64\mkspecs\modules\qt_lib_core.pri \
		..\..\..\..\Qt\5.0.2\msvc2012_64\mkspecs\modules\qt_lib_declarative.pri \
		..\..\..\..\Qt\5.0.2\msvc2012_64\mkspecs\modules\qt_lib_designer.pri \
		..\..\..\..\Qt\5.0.2\msvc2012_64\mkspecs\modules\qt_lib_designercomponents.pri \
		..\..\..\..\Qt\5.0.2\msvc2012_64\mkspecs\modules\qt_lib_gui.pri \
		..\..\..\..\Qt\5.0.2\msvc2012_64\mkspecs\modules\qt_lib_help.pri \
		..\..\..\..\Qt\5.0.2\msvc2012_64\mkspecs\modules\qt_lib_multimedia.pri \
		..\..\..\..\Qt\5.0.2\msvc2012_64\mkspecs\modules\qt_lib_multimediawidgets.pri \
		..\..\..\..\Qt\5.0.2\msvc2012_64\mkspecs\modules\qt_lib_network.pri \
		..\..\..\..\Qt\5.0.2\msvc2012_64\mkspecs\modules\qt_lib_opengl.pri \
		..\..\..\..\Qt\5.0.2\msvc2012_64\mkspecs\modules\qt_lib_platformsupport.pri \
		..\..\..\..\Qt\5.0.2\msvc2012_64\mkspecs\modules\qt_lib_printsupport.pri \
		..\..\..\..\Qt\5.0.2\msvc2012_64\mkspecs\modules\qt_lib_qml.pri \
		..\..\..\..\Qt\5.0.2\msvc2012_64\mkspecs\modules\qt_lib_qmldevtools.pri \
		..\..\..\..\Qt\5.0.2\msvc2012_64\mkspecs\modules\qt_lib_qmltest.pri \
		..\..\..\..\Qt\5.0.2\msvc2012_64\mkspecs\modules\qt_lib_qtmultimediaquicktools.pri \
		..\..\..\..\Qt\5.0.2\msvc2012_64\mkspecs\modules\qt_lib_quick.pri \
		..\..\..\..\Qt\5.0.2\msvc2012_64\mkspecs\modules\qt_lib_quickparticles.pri \
		..\..\..\..\Qt\5.0.2\msvc2012_64\mkspecs\modules\qt_lib_script.pri \
		..\..\..\..\Qt\5.0.2\msvc2012_64\mkspecs\modules\qt_lib_scripttools.pri \
		..\..\..\..\Qt\5.0.2\msvc2012_64\mkspecs\modules\qt_lib_sql.pri \
		..\..\..\..\Qt\5.0.2\msvc2012_64\mkspecs\modules\qt_lib_svg.pri \
		..\..\..\..\Qt\5.0.2\msvc2012_64\mkspecs\modules\qt_lib_testlib.pri \
		..\..\..\..\Qt\5.0.2\msvc2012_64\mkspecs\modules\qt_lib_uitools.pri \
		..\..\..\..\Qt\5.0.2\msvc2012_64\mkspecs\modules\qt_lib_v8.pri \
		..\..\..\..\Qt\5.0.2\msvc2012_64\mkspecs\modules\qt_lib_webkit.pri \
		..\..\..\..\Qt\5.0.2\msvc2012_64\mkspecs\modules\qt_lib_webkitwidgets.pri \
		..\..\..\..\Qt\5.0.2\msvc2012_64\mkspecs\modules\qt_lib_widgets.pri \
		..\..\..\..\Qt\5.0.2\msvc2012_64\mkspecs\modules\qt_lib_xml.pri \
		..\..\..\..\Qt\5.0.2\msvc2012_64\mkspecs\modules\qt_lib_xmlpatterns.pri \
		..\..\..\..\Qt\5.0.2\msvc2012_64\mkspecs\features\qt_functions.prf \
		..\..\..\..\Qt\5.0.2\msvc2012_64\mkspecs\features\qt_config.prf \
		..\..\..\..\Qt\5.0.2\msvc2012_64\mkspecs\win32-msvc2012\qmake.conf \
		..\..\..\..\Qt\5.0.2\msvc2012_64\mkspecs\features\spec_post.prf \
		..\..\..\..\Qt\5.0.2\msvc2012_64\mkspecs\features\exclusive_builds.prf \
		..\..\..\..\Qt\5.0.2\msvc2012_64\mkspecs\features\default_pre.prf \
		..\..\..\..\Qt\5.0.2\msvc2012_64\mkspecs\features\win32\default_pre.prf \
		..\..\..\..\Qt\5.0.2\msvc2012_64\mkspecs\features\resolve_config.prf \
		..\..\..\..\Qt\5.0.2\msvc2012_64\mkspecs\features\default_post.prf \
		..\..\..\..\Qt\5.0.2\msvc2012_64\mkspecs\features\win32\rtti.prf \
		..\..\..\..\Qt\5.0.2\msvc2012_64\mkspecs\features\warn_on.prf \
		..\..\..\..\Qt\5.0.2\msvc2012_64\mkspecs\features\qt.prf \
		..\..\..\..\Qt\5.0.2\msvc2012_64\mkspecs\features\resources.prf \
		..\..\..\..\Qt\5.0.2\msvc2012_64\mkspecs\features\moc.prf \
		..\..\..\..\Qt\5.0.2\msvc2012_64\mkspecs\features\win32\opengl.prf \
		..\..\..\..\Qt\5.0.2\msvc2012_64\mkspecs\features\uic.prf \
		..\..\..\..\Qt\5.0.2\msvc2012_64\mkspecs\features\win32\windows.prf \
		..\..\..\..\Qt\5.0.2\msvc2012_64\mkspecs\features\testcase_targets.prf \
		..\..\..\..\Qt\5.0.2\msvc2012_64\mkspecs\features\exceptions.prf \
		..\..\..\..\Qt\5.0.2\msvc2012_64\mkspecs\features\yacc.prf \
		..\..\..\..\Qt\5.0.2\msvc2012_64\mkspecs\features\lex.prf \
		final.pro \
		C:/Qt/5.0.2/msvc2012_64/lib/Qt5OpenGL.prl \
		C:/Qt/5.0.2/msvc2012_64/lib/Qt5Widgets.prl \
		C:/Qt/5.0.2/msvc2012_64/lib/Qt5Xml.prl \
		C:/Qt/5.0.2/msvc2012_64/lib/Qt5Gui.prl \
		C:/Qt/5.0.2/msvc2012_64/lib/Qt5Core.prl \
		C:/Qt/5.0.2/msvc2012_64/lib/libEGLd.prl \
		C:/Qt/5.0.2/msvc2012_64/lib/libGLESv2d.prl
	$(QMAKE) -spec win32-msvc2012 CONFIG+=debug -o Makefile final.pro
..\..\..\..\Qt\5.0.2\msvc2012_64\mkspecs\features\spec_pre.prf:
..\..\..\..\Qt\5.0.2\msvc2012_64\mkspecs\common\shell-win32.conf:
..\..\..\..\Qt\5.0.2\msvc2012_64\mkspecs\qconfig.pri:
..\..\..\..\Qt\5.0.2\msvc2012_64\mkspecs\modules\qt_lib_axbase.pri:
..\..\..\..\Qt\5.0.2\msvc2012_64\mkspecs\modules\qt_lib_axcontainer.pri:
..\..\..\..\Qt\5.0.2\msvc2012_64\mkspecs\modules\qt_lib_axserver.pri:
..\..\..\..\Qt\5.0.2\msvc2012_64\mkspecs\modules\qt_lib_bootstrap.pri:
..\..\..\..\Qt\5.0.2\msvc2012_64\mkspecs\modules\qt_lib_clucene.pri:
..\..\..\..\Qt\5.0.2\msvc2012_64\mkspecs\modules\qt_lib_concurrent.pri:
..\..\..\..\Qt\5.0.2\msvc2012_64\mkspecs\modules\qt_lib_core.pri:
..\..\..\..\Qt\5.0.2\msvc2012_64\mkspecs\modules\qt_lib_declarative.pri:
..\..\..\..\Qt\5.0.2\msvc2012_64\mkspecs\modules\qt_lib_designer.pri:
..\..\..\..\Qt\5.0.2\msvc2012_64\mkspecs\modules\qt_lib_designercomponents.pri:
..\..\..\..\Qt\5.0.2\msvc2012_64\mkspecs\modules\qt_lib_gui.pri:
..\..\..\..\Qt\5.0.2\msvc2012_64\mkspecs\modules\qt_lib_help.pri:
..\..\..\..\Qt\5.0.2\msvc2012_64\mkspecs\modules\qt_lib_multimedia.pri:
..\..\..\..\Qt\5.0.2\msvc2012_64\mkspecs\modules\qt_lib_multimediawidgets.pri:
..\..\..\..\Qt\5.0.2\msvc2012_64\mkspecs\modules\qt_lib_network.pri:
..\..\..\..\Qt\5.0.2\msvc2012_64\mkspecs\modules\qt_lib_opengl.pri:
..\..\..\..\Qt\5.0.2\msvc2012_64\mkspecs\modules\qt_lib_platformsupport.pri:
..\..\..\..\Qt\5.0.2\msvc2012_64\mkspecs\modules\qt_lib_printsupport.pri:
..\..\..\..\Qt\5.0.2\msvc2012_64\mkspecs\modules\qt_lib_qml.pri:
..\..\..\..\Qt\5.0.2\msvc2012_64\mkspecs\modules\qt_lib_qmldevtools.pri:
..\..\..\..\Qt\5.0.2\msvc2012_64\mkspecs\modules\qt_lib_qmltest.pri:
..\..\..\..\Qt\5.0.2\msvc2012_64\mkspecs\modules\qt_lib_qtmultimediaquicktools.pri:
..\..\..\..\Qt\5.0.2\msvc2012_64\mkspecs\modules\qt_lib_quick.pri:
..\..\..\..\Qt\5.0.2\msvc2012_64\mkspecs\modules\qt_lib_quickparticles.pri:
..\..\..\..\Qt\5.0.2\msvc2012_64\mkspecs\modules\qt_lib_script.pri:
..\..\..\..\Qt\5.0.2\msvc2012_64\mkspecs\modules\qt_lib_scripttools.pri:
..\..\..\..\Qt\5.0.2\msvc2012_64\mkspecs\modules\qt_lib_sql.pri:
..\..\..\..\Qt\5.0.2\msvc2012_64\mkspecs\modules\qt_lib_svg.pri:
..\..\..\..\Qt\5.0.2\msvc2012_64\mkspecs\modules\qt_lib_testlib.pri:
..\..\..\..\Qt\5.0.2\msvc2012_64\mkspecs\modules\qt_lib_uitools.pri:
..\..\..\..\Qt\5.0.2\msvc2012_64\mkspecs\modules\qt_lib_v8.pri:
..\..\..\..\Qt\5.0.2\msvc2012_64\mkspecs\modules\qt_lib_webkit.pri:
..\..\..\..\Qt\5.0.2\msvc2012_64\mkspecs\modules\qt_lib_webkitwidgets.pri:
..\..\..\..\Qt\5.0.2\msvc2012_64\mkspecs\modules\qt_lib_widgets.pri:
..\..\..\..\Qt\5.0.2\msvc2012_64\mkspecs\modules\qt_lib_xml.pri:
..\..\..\..\Qt\5.0.2\msvc2012_64\mkspecs\modules\qt_lib_xmlpatterns.pri:
..\..\..\..\Qt\5.0.2\msvc2012_64\mkspecs\features\qt_functions.prf:
..\..\..\..\Qt\5.0.2\msvc2012_64\mkspecs\features\qt_config.prf:
..\..\..\..\Qt\5.0.2\msvc2012_64\mkspecs\win32-msvc2012\qmake.conf:
..\..\..\..\Qt\5.0.2\msvc2012_64\mkspecs\features\spec_post.prf:
..\..\..\..\Qt\5.0.2\msvc2012_64\mkspecs\features\exclusive_builds.prf:
..\..\..\..\Qt\5.0.2\msvc2012_64\mkspecs\features\default_pre.prf:
..\..\..\..\Qt\5.0.2\msvc2012_64\mkspecs\features\win32\default_pre.prf:
..\..\..\..\Qt\5.0.2\msvc2012_64\mkspecs\features\resolve_config.prf:
..\..\..\..\Qt\5.0.2\msvc2012_64\mkspecs\features\default_post.prf:
..\..\..\..\Qt\5.0.2\msvc2012_64\mkspecs\features\win32\rtti.prf:
..\..\..\..\Qt\5.0.2\msvc2012_64\mkspecs\features\warn_on.prf:
..\..\..\..\Qt\5.0.2\msvc2012_64\mkspecs\features\qt.prf:
..\..\..\..\Qt\5.0.2\msvc2012_64\mkspecs\features\resources.prf:
..\..\..\..\Qt\5.0.2\msvc2012_64\mkspecs\features\moc.prf:
..\..\..\..\Qt\5.0.2\msvc2012_64\mkspecs\features\win32\opengl.prf:
..\..\..\..\Qt\5.0.2\msvc2012_64\mkspecs\features\uic.prf:
..\..\..\..\Qt\5.0.2\msvc2012_64\mkspecs\features\win32\windows.prf:
..\..\..\..\Qt\5.0.2\msvc2012_64\mkspecs\features\testcase_targets.prf:
..\..\..\..\Qt\5.0.2\msvc2012_64\mkspecs\features\exceptions.prf:
..\..\..\..\Qt\5.0.2\msvc2012_64\mkspecs\features\yacc.prf:
..\..\..\..\Qt\5.0.2\msvc2012_64\mkspecs\features\lex.prf:
final.pro:
C:/Qt/5.0.2/msvc2012_64/lib/Qt5OpenGL.prl:
C:/Qt/5.0.2/msvc2012_64/lib/Qt5Widgets.prl:
C:/Qt/5.0.2/msvc2012_64/lib/Qt5Xml.prl:
C:/Qt/5.0.2/msvc2012_64/lib/Qt5Gui.prl:
C:/Qt/5.0.2/msvc2012_64/lib/Qt5Core.prl:
C:/Qt/5.0.2/msvc2012_64/lib/libEGLd.prl:
C:/Qt/5.0.2/msvc2012_64/lib/libGLESv2d.prl:
qmake: FORCE
	@$(QMAKE) -spec win32-msvc2012 CONFIG+=debug -o Makefile final.pro

qmake_all: FORCE

make_first: debug-make_first release-make_first FORCE
all: debug-all release-all FORCE
clean: debug-clean release-clean FORCE
	-$(DEL_FILE) final.exp
	-$(DEL_FILE) final.ilk
	-$(DEL_FILE) vc*.pdb
	-$(DEL_FILE) vc*.idb
distclean: debug-distclean release-distclean FORCE
	-$(DEL_FILE) Makefile
	-$(DEL_FILE) final.pdb

debug-mocclean:
	@set MAKEFLAGS=$(MAKEFLAGS)
	$(MAKE) -f $(MAKEFILE).Debug mocclean
release-mocclean:
	@set MAKEFLAGS=$(MAKEFLAGS)
	$(MAKE) -f $(MAKEFILE).Release mocclean
mocclean: debug-mocclean release-mocclean

debug-mocables:
	@set MAKEFLAGS=$(MAKEFLAGS)
	$(MAKE) -f $(MAKEFILE).Debug mocables
release-mocables:
	@set MAKEFLAGS=$(MAKEFLAGS)
	$(MAKE) -f $(MAKEFILE).Release mocables
mocables: debug-mocables release-mocables

check: first
FORCE:

$(MAKEFILE).Debug: Makefile
$(MAKEFILE).Release: Makefile
