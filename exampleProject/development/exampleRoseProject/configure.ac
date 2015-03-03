AC_INIT([retype], [0.01])
AC_OUTPUT
AC_PREREQ([2.68])
AC_CONFIG_SRCDIR([src/main.cpp])
AC_CONFIG_HEADERS([include/config.h])
AC_CONFIG_AUX_DIR([build-aux])
AM_INIT_AUTOMAKE([1.11 foreign subdir-objects -Wall -Werror])
#AC_CONFIG_FILES([Makefile src/Makefile src/translatorSrc/Makefile])
AC_CONFIG_FILES([Makefile src/Makefile])




#initialize libtool
LT_INIT([disable-shared])
AC_SUBST([LIBTOOL_DEPS])
AC_CONFIG_MACRO_DIR([m4])

#check operating system
AC_CANONICAL_HOST

case $host_os in
	"")
		SYS=unknown
		AC_DEFINE([OS], ["UNKNOWN"], [Description: Operating System Used])
		;;
	linux*)
		SYS=linux
		AC_DEFINE([OS], ["LINUX"], [Description: Operating System Used])
		;;
	darwin*)
		AC_DEFINE([OS], ["MACOSX"], [Description: Operating System Used])
		SYS=macos
		;;
	*)
		#default
		AC_MSG_ERROR([Your platform is not currently supporter])
		;;
esac

AM_CONDITIONAL(HAVE_LINUX, test "${SYS}" = "linux")
AM_CONDITIONAL(HAVE_MACOS, test "${SYS}" = "macos")
AM_CONDITIONAL(HAVE_UNKNOWN, test "${SYS}" = "unknown")

		



#various checks and such

AC_PROG_CC
AC_PROG_CXX
AC_OUTPUT
