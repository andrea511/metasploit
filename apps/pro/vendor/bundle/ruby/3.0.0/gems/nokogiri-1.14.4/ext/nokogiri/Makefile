
SHELL = /bin/sh

# V=0 quiet, V=1 verbose.  other values don't work.
V = 0
Q1 = $(V:1=)
Q = $(Q1:0=@)
ECHO1 = $(V:1=@ :)
ECHO = $(ECHO1:0=@ echo)
NULLCMD = :

#### Start of system configuration section. ####

srcdir = .
topdir = /C/Users/vagrant/pro/pkg/w32/ruby/include/ruby-3.0.0
hdrdir = $(topdir)
arch_hdrdir = /C/Users/vagrant/pro/pkg/w32/ruby/include/ruby-3.0.0/x64-mingw32
PATH_SEPARATOR = :
VPATH = $(srcdir):$(arch_hdrdir)/ruby:$(hdrdir)/ruby
prefix = $(DESTDIR)/C/Users/vagrant/pro/pkg/w32/ruby
rubysitearchprefix = $(rubylibprefix)/$(sitearch)
rubyarchprefix = $(rubylibprefix)/$(arch)
rubylibprefix = $(libdir)/$(RUBY_BASE_NAME)
exec_prefix = $(prefix)
vendorarchhdrdir = $(vendorhdrdir)/$(sitearch)
sitearchhdrdir = $(sitehdrdir)/$(sitearch)
rubyarchhdrdir = $(rubyhdrdir)/$(arch)
vendorhdrdir = $(rubyhdrdir)/vendor_ruby
sitehdrdir = $(rubyhdrdir)/site_ruby
rubyhdrdir = $(includedir)/$(RUBY_VERSION_NAME)
vendorarchdir = $(vendorlibdir)/$(sitearch)
vendorlibdir = $(vendordir)/$(ruby_version)
vendordir = $(rubylibprefix)/vendor_ruby
sitearchdir = $(DESTDIR)./.gem.20230522-388-90bapz
sitelibdir = $(DESTDIR)./.gem.20230522-388-90bapz
sitedir = $(rubylibprefix)/site_ruby
rubyarchdir = $(rubylibdir)/$(arch)
rubylibdir = $(rubylibprefix)/$(ruby_version)
sitearchincludedir = $(includedir)/$(sitearch)
archincludedir = $(includedir)/$(arch)
sitearchlibdir = $(libdir)/$(sitearch)
archlibdir = $(libdir)/$(arch)
ridir = $(datarootdir)/$(RI_BASE_NAME)
mandir = $(datarootdir)/man
localedir = $(datarootdir)/locale
libdir = $(exec_prefix)/lib
psdir = $(docdir)
pdfdir = $(docdir)
dvidir = $(docdir)
htmldir = $(docdir)
infodir = $(datarootdir)/info
docdir = $(datarootdir)/doc/$(PACKAGE)
oldincludedir = $(DESTDIR)/usr/include
includedir = $(prefix)/include
runstatedir = $(localstatedir)/run
localstatedir = $(prefix)/var
sharedstatedir = $(prefix)/com
sysconfdir = $(DESTDIR)
datadir = $(datarootdir)
datarootdir = $(prefix)/share
libexecdir = $(exec_prefix)/libexec
sbindir = $(exec_prefix)/sbin
bindir = $(exec_prefix)/bin
archdir = $(rubyarchdir)


CC_WRAPPER = 
CC = x86_64-w64-mingw32-gcc
CXX = x86_64-w64-mingw32-g++
LIBRUBY = lib$(RUBY_SO_NAME).dll.a
LIBRUBY_A = lib$(RUBY_SO_NAME)-static.a
LIBRUBYARG_SHARED = -l$(RUBY_SO_NAME)
LIBRUBYARG_STATIC = -l$(RUBY_SO_NAME)-static $(MAINLIBS)
empty =
OUTFLAG = -o $(empty)
COUTFLAG = -o $(empty)
CSRCFLAG = $(empty)

RUBY_EXTCONF_H = 
cflags   = $(optflags) $(debugflags) $(warnflags)
cxxflags = 
optflags = -O3 -fno-omit-frame-pointer
debugflags = -ggdb3
warnflags = -Wall -Wextra -Wdeprecated-declarations  -Wimplicit-function-declaration -Wimplicit-int  -Wpointer-arith -Wwrite-strings  -Wmissing-noreturn -Wno-cast-function-type -Wno-constant-logical-operand -Wno-long-long -Wno-missing-field-initializers -Wno-overlength-strings -Wno-packed-bitfield-compat -Wno-parentheses-equality -Wno-self-assign -Wno-tautological-compare -Wno-unused-parameter -Wno-unused-value  -Wsuggest-attribute=noreturn -Wunused-variable
cppflags = 
CCDLFLAGS = 
CFLAGS   = $(CCDLFLAGS) -O3 -DFD_SETSIZE=2048 -fno-omit-frame-pointer -fno-fast-math -Wall -Wextra -Wno-unused-parameter -Wno-parentheses -Wno-long-long -Wno-missing-field-initializers -Wunused-variable -Wpointer-arith -Wwrite-strings -Wdeclaration-after-statement -Wimplicit-function-declaration -Wno-declaration-after-statement -O2 -g -Winline -Wmissing-noreturn -Wconversion -Wno-sign-conversion $(ARCH_FLAG)
INCFLAGS = -I. -I$(arch_hdrdir) -I$(hdrdir)/ruby/backward -I$(hdrdir) -I$(srcdir)
DEFS     = -D_FILE_OFFSET_BITS=64
CPPFLAGS = -DHAVE_GUMBO_PARSE_WITH_OPTIONS -DHAVE_XMLHASFEATURE -DHAVE_XMLFIRSTELEMENTCHILD -DHAVE_XMLRELAXNGSETPARSERSTRUCTUREDERRORS -DHAVE_XMLRELAXNGSETVALIDSTRUCTUREDERRORS -DHAVE_XMLSCHEMASETVALIDSTRUCTUREDERRORS -DHAVE_XMLSCHEMASETPARSERSTRUCTUREDERRORS -DHAVE_RB_GC_LOCATION -DHAVE_RB_CATEGORY_WARNING -D_WIN32_WINNT=0x0600 -D__MINGW_USE_VC2005_COMPAT $(DEFS) $(cppflags)  "-Idummypath" -IC:/Users/vagrant/pro/pkg/w32/bun/vendor/bundle/ruby/3.0.0/gems/nokogiri-1.14.4/ext/nokogiri/ports/x64-mingw32/libgumbo/1.0.0-nokogiri/include -DNOKOGIRI_OTHER_LIBRARY_VERSIONS="\"libgumbo:1.0.0-nokogiri\""
CXXFLAGS = $(CCDLFLAGS)  $(ARCH_FLAG)
ldflags  = -L. 
dldflags =  -Wl,--enable-auto-image-base,--enable-auto-import $(DEFFILE) 
ARCH_FLAG = -m64
DLDFLAGS = $(ldflags) $(dldflags) $(ARCH_FLAG)
LDSHARED = $(CC) -m64 -shared -static-libgcc
LDSHAREDXX = $(CXX) -m64 -shared -static-libgcc -static-libstdc++
AR = x86_64-w64-mingw32-gcc-ar
EXEEXT = .exe

RUBY_INSTALL_NAME = $(RUBY_BASE_NAME)
RUBY_SO_NAME = x64-msvcrt-ruby300
RUBYW_INSTALL_NAME = $(RUBYW_BASE_NAME)
RUBY_VERSION_NAME = $(RUBY_BASE_NAME)-$(ruby_version)
RUBYW_BASE_NAME = rubyw
RUBY_BASE_NAME = ruby

arch = x64-mingw32
sitearch = x64-msvcrt
ruby_version = 3.0.0
ruby = $(bindir)/$(RUBY_BASE_NAME)
RUBY = $(ruby)
ruby_headers = $(hdrdir)/ruby.h $(hdrdir)/ruby/backward.h $(hdrdir)/ruby/ruby.h $(hdrdir)/ruby/defines.h $(hdrdir)/ruby/missing.h $(hdrdir)/ruby/intern.h $(hdrdir)/ruby/st.h $(hdrdir)/ruby/subst.h $(arch_hdrdir)/ruby/config.h

RM = rm -f
RM_RF = $(RUBY) -run -e rm -- -rf
RMDIRS = rmdir --ignore-fail-on-non-empty -p
MAKEDIRS = /usr/bin/mkdir -p
INSTALL = /usr/bin/install -c
INSTALL_PROG = $(INSTALL) -m 0755
INSTALL_DATA = $(INSTALL) -m 644
COPY = cp
TOUCH = exit >

#### End of system configuration section. ####

preload = 
libpath = . $(libdir) C:/Users/vagrant/pro/pkg/w32/bun/vendor/bundle/ruby/3.0.0/gems/nokogiri-1.14.4/ext/nokogiri/ports/x64-mingw32/libgumbo/1.0.0-nokogiri/lib
LIBPATH =  -L. -L$(libdir) -LC:/Users/vagrant/pro/pkg/w32/bun/vendor/bundle/ruby/3.0.0/gems/nokogiri-1.14.4/ext/nokogiri/ports/x64-mingw32/libgumbo/1.0.0-nokogiri/lib
DEFFILE = $(TARGET)-$(arch).def

CLEANFILES = mkmf.log $(DEFFILE)
DISTCLEANFILES = 
DISTCLEANDIRS = 

extout = 
extout_prefix = 
target_prefix = /nokogiri
LOCAL_LIBS = 
LIBS = $(LIBRUBYARG_SHARED) -lexslt -lxslt -lxml2 -lz  C:/Users/vagrant/pro/pkg/w32/bun/vendor/bundle/ruby/3.0.0/gems/nokogiri-1.14.4/ext/nokogiri/ports/x64-mingw32/libgumbo/1.0.0-nokogiri/lib/libgumbo.a -lshell32 -lws2_32 -liphlpapi -limagehlp -lshlwapi  
ORIG_SRCS = gumbo.c html4_document.c html4_element_description.c html4_entity_lookup.c html4_sax_parser_context.c html4_sax_push_parser.c libxml2_backwards_compat.c nokogiri.c test_global_handlers.c xml_attr.c xml_attribute_decl.c xml_cdata.c xml_comment.c xml_document.c xml_document_fragment.c xml_dtd.c xml_element_content.c xml_element_decl.c xml_encoding_handler.c xml_entity_decl.c xml_entity_reference.c xml_namespace.c xml_node.c xml_node_set.c xml_processing_instruction.c xml_reader.c xml_relax_ng.c xml_sax_parser.c xml_sax_parser_context.c xml_sax_push_parser.c xml_schema.c xml_syntax_error.c xml_text.c xml_xpath_context.c xslt_stylesheet.c
SRCS = $(ORIG_SRCS) 
OBJS = gumbo.o html4_document.o html4_element_description.o html4_entity_lookup.o html4_sax_parser_context.o html4_sax_push_parser.o libxml2_backwards_compat.o nokogiri.o test_global_handlers.o xml_attr.o xml_attribute_decl.o xml_cdata.o xml_comment.o xml_document.o xml_document_fragment.o xml_dtd.o xml_element_content.o xml_element_decl.o xml_encoding_handler.o xml_entity_decl.o xml_entity_reference.o xml_namespace.o xml_node.o xml_node_set.o xml_processing_instruction.o xml_reader.o xml_relax_ng.o xml_sax_parser.o xml_sax_parser_context.o xml_sax_push_parser.o xml_schema.o xml_syntax_error.o xml_text.o xml_xpath_context.o xslt_stylesheet.o
HDRS = $(srcdir)/nokogiri.h
LOCAL_HDRS = 
TARGET = nokogiri
TARGET_NAME = nokogiri
TARGET_ENTRY = Init_$(TARGET_NAME)
DLLIB = $(TARGET).so
EXTSTATIC = 
STATIC_LIB = 

TIMESTAMP_DIR = .
BINDIR        = $(bindir)
RUBYCOMMONDIR = $(sitedir)$(target_prefix)
RUBYLIBDIR    = $(sitelibdir)$(target_prefix)
RUBYARCHDIR   = $(sitearchdir)$(target_prefix)
HDRDIR        = $(sitehdrdir)$(target_prefix)
ARCHHDRDIR    = $(sitearchhdrdir)$(target_prefix)
TARGET_SO_DIR =
TARGET_SO     = $(TARGET_SO_DIR)$(DLLIB)
CLEANLIBS     = $(TARGET_SO) 
CLEANOBJS     = *.o  *.bak

all:    $(DLLIB)
static: $(STATIC_LIB)
.PHONY: all install static install-so install-rb
.PHONY: clean clean-so clean-static clean-rb

clean-static::
clean-rb-default::
clean-rb::
clean-so::
clean: clean-so clean-static clean-rb-default clean-rb
		-$(Q)$(RM) $(CLEANLIBS) $(CLEANOBJS) $(CLEANFILES) .*.time

distclean-rb-default::
distclean-rb::
distclean-so::
distclean-static::
distclean: clean distclean-so distclean-static distclean-rb-default distclean-rb
		-$(Q)$(RM) Makefile $(RUBY_EXTCONF_H) conftest.* mkmf.log
		-$(Q)$(RM) core ruby$(EXEEXT) *~ $(DISTCLEANFILES)
		-$(Q)$(RMDIRS) $(DISTCLEANDIRS) 2> /dev/null || true

realclean: distclean
install: install-so install-rb

install-so: $(DLLIB) $(TIMESTAMP_DIR)/.sitearchdir.-.nokogiri.time
	$(INSTALL_PROG) $(DLLIB) $(RUBYARCHDIR)
clean-static::
	-$(Q)$(RM) $(STATIC_LIB)
install-rb: pre-install-rb do-install-rb install-rb-default
install-rb-default: pre-install-rb-default do-install-rb-default
pre-install-rb: Makefile
pre-install-rb-default: Makefile
do-install-rb:
do-install-rb-default:
pre-install-rb-default:
	@$(NULLCMD)
$(TIMESTAMP_DIR)/.sitearchdir.-.nokogiri.time:
	$(Q) $(MAKEDIRS) $(@D) $(RUBYARCHDIR)
	$(Q) $(TOUCH) $@

site-install: site-install-so site-install-rb
site-install-so: install-so
site-install-rb: install-rb

.SUFFIXES: .c .m .cc .mm .cxx .cpp .o .S

.cc.o:
	$(ECHO) compiling $(<)
	$(Q) $(CXX) $(INCFLAGS) $(CPPFLAGS) $(CXXFLAGS) $(COUTFLAG)$@ -c $(CSRCFLAG)$<

.cc.S:
	$(ECHO) translating $(<)
	$(Q) $(CXX) $(INCFLAGS) $(CPPFLAGS) $(CXXFLAGS) $(COUTFLAG)$@ -S $(CSRCFLAG)$<

.mm.o:
	$(ECHO) compiling $(<)
	$(Q) $(CXX) $(INCFLAGS) $(CPPFLAGS) $(CXXFLAGS) $(COUTFLAG)$@ -c $(CSRCFLAG)$<

.mm.S:
	$(ECHO) translating $(<)
	$(Q) $(CXX) $(INCFLAGS) $(CPPFLAGS) $(CXXFLAGS) $(COUTFLAG)$@ -S $(CSRCFLAG)$<

.cxx.o:
	$(ECHO) compiling $(<)
	$(Q) $(CXX) $(INCFLAGS) $(CPPFLAGS) $(CXXFLAGS) $(COUTFLAG)$@ -c $(CSRCFLAG)$<

.cxx.S:
	$(ECHO) translating $(<)
	$(Q) $(CXX) $(INCFLAGS) $(CPPFLAGS) $(CXXFLAGS) $(COUTFLAG)$@ -S $(CSRCFLAG)$<

.cpp.o:
	$(ECHO) compiling $(<)
	$(Q) $(CXX) $(INCFLAGS) $(CPPFLAGS) $(CXXFLAGS) $(COUTFLAG)$@ -c $(CSRCFLAG)$<

.cpp.S:
	$(ECHO) translating $(<)
	$(Q) $(CXX) $(INCFLAGS) $(CPPFLAGS) $(CXXFLAGS) $(COUTFLAG)$@ -S $(CSRCFLAG)$<

.c.o:
	$(ECHO) compiling $(<)
	$(Q) $(CC) $(INCFLAGS) $(CPPFLAGS) $(CFLAGS) $(COUTFLAG)$@ -c $(CSRCFLAG)$<

.c.S:
	$(ECHO) translating $(<)
	$(Q) $(CC) $(INCFLAGS) $(CPPFLAGS) $(CFLAGS) $(COUTFLAG)$@ -S $(CSRCFLAG)$<

.m.o:
	$(ECHO) compiling $(<)
	$(Q) $(CC) $(INCFLAGS) $(CPPFLAGS) $(CFLAGS) $(COUTFLAG)$@ -c $(CSRCFLAG)$<

.m.S:
	$(ECHO) translating $(<)
	$(Q) $(CC) $(INCFLAGS) $(CPPFLAGS) $(CFLAGS) $(COUTFLAG)$@ -S $(CSRCFLAG)$<

$(TARGET_SO): $(DEFFILE) $(OBJS) Makefile
	$(ECHO) linking shared-object nokogiri/$(DLLIB)
	-$(Q)$(RM) $(@)
	$(Q) $(LDSHARED) -o $@ $(OBJS) $(LIBPATH) $(DLDFLAGS) $(LOCAL_LIBS) $(LIBS)



$(DEFFILE): 
	$(ECHO) generating $(@)
	$(Q) (echo EXPORTS && echo $(TARGET_ENTRY)) > $@

###
# -*-makefile-*-
# DO NOT DELETE

gumbo.o: $(srcdir)/nokogiri.h
html_document.o: $(srcdir)/nokogiri.h
html_element_description.o: $(srcdir)/nokogiri.h
html_entity_lookup.o: $(srcdir)/nokogiri.h
html_sax_parser_context.o: $(srcdir)/nokogiri.h
html_sax_push_parser.o: $(srcdir)/nokogiri.h
libxml2_backwards_compat.o: $(srcdir)/nokogiri.h
nokogiri.o: $(srcdir)/nokogiri.h
test_global_handlers.o: $(srcdir)/nokogiri.h
xml_attr.o: $(srcdir)/nokogiri.h
xml_attribute_decl.o: $(srcdir)/nokogiri.h
xml_cdata.o: $(srcdir)/nokogiri.h
xml_comment.o: $(srcdir)/nokogiri.h
xml_document.o: $(srcdir)/nokogiri.h
xml_document_fragment.o: $(srcdir)/nokogiri.h
xml_dtd.o: $(srcdir)/nokogiri.h
xml_element_content.o: $(srcdir)/nokogiri.h
xml_element_decl.o: $(srcdir)/nokogiri.h
xml_encoding_handler.o: $(srcdir)/nokogiri.h
xml_entity_decl.o: $(srcdir)/nokogiri.h
xml_entity_reference.o: $(srcdir)/nokogiri.h
xml_namespace.o: $(srcdir)/nokogiri.h
xml_node.o: $(srcdir)/nokogiri.h
xml_node_set.o: $(srcdir)/nokogiri.h
xml_processing_instruction.o: $(srcdir)/nokogiri.h
xml_reader.o: $(srcdir)/nokogiri.h
xml_relax_ng.o: $(srcdir)/nokogiri.h
xml_sax_parser.o: $(srcdir)/nokogiri.h
xml_sax_parser_context.o: $(srcdir)/nokogiri.h
xml_sax_push_parser.o: $(srcdir)/nokogiri.h
xml_schema.o: $(srcdir)/nokogiri.h
xml_syntax_error.o: $(srcdir)/nokogiri.h
xml_text.o: $(srcdir)/nokogiri.h
xml_xpath_context.o: $(srcdir)/nokogiri.h
xslt_stylesheet.o: $(srcdir)/nokogiri.h

all: clean-ports
clean-ports: $(DLLIB)
	-$(Q)$(RUBY) $(srcdir)/extconf.rb --clean --disable-static
