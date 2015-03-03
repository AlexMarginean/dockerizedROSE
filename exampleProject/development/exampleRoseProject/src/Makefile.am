BOOST_CPPFLAGS = -pthread 
ROSE_LIBS = -lrose
bin_PROGRAMS = identityTranslator 

identityTranslator_SOURCES = main.cpp
identityTranslator_LDADD = -lrose -lboost_thread  -lboost_filesystem -lboost_system -lboost_iostreams 
identityTranslator_CPPFLAGS = -I$(top_srcdir)/include -I$(ROSE_INCLUDE_DIR) $(BOOST_CPPFLAGS) 
identityTranslator_LDFLAGS = -pthread 
