AC_PREREQ([2.69])
AC_INIT([pppd], 
        [2.4.10],
        [https://github.com/enaess/ppp])

m4_ifdef([AM_SILENT_RULES],[AM_SILENT_RULES([yes])])
AC_CONFIG_MACRO_DIR([m4])
AM_INIT_AUTOMAKE
AC_LANG(C)
AC_CONFIG_SRCDIR([pppd/main.c])
AC_CONFIG_HEADERS([pppd/config.h pppd/pppdconf.h])

# Checks for programs.
AC_PROG_CC
AM_PROG_CC_C_O
AC_PROG_INSTALL
AC_PROG_LIBTOOL

AC_CANONICAL_HOST
build_linux=no
build_sunos=no

case "${host_os}" in
    linux*)
	build_linux=yes
	;;
    solaris2*)
	build_sunos=yes
	;;
    *)
	AC_MSG_ERROR(["OS ${host_os} not supported"])
	;;
esac

AM_CONDITIONAL([LINUX], [test "${build_linux}" = "yes" ])
AM_CONDITIONAL([SUNOS], [test "${build_sunos}" = "yes" ])

AS_IF([test "${build_sunos}" = "yes"],
      [CFLAGS="$CFLAGS -DSOL2"])

#
# Checks for header files.
AC_HEADER_STDBOOL
AC_CHECK_HEADERS([  \
    asm/types.h     \
    arpa/inet.h     \
    crypt.h         \
    fcntl.h         \
    getopt.h        \
    netdb.h         \
    paths.h         \
    shadow.h        \
    stdint.h        \
    stdlib.h        \
    string.h        \
    syslog.h        \
    stdbool.h       \
    pty.h           \
    time.h          \
    utmp.h          \
    unistd.h        \
    sys/types.h     \
    sys/socket.h    \
    sys/wait.h      \
    sys/ioctl.h     \
    sys/param.h     \
    sys/socket.h    \
    sys/time.h      \
    sys/uio.h       \
    syslog.h        \
    net/bpf.h       \
    net/ethernet.h  \
    net/if.h        \
    net/if_arp.h    \
    net/if_dl.h     \
    net/if_ether.h  \
    net/if_types.h  \
    netinet/if_ether.h \
    netpacket/packet.h])

#
# Check for linux specific headers
AS_IF([test "${build_linux}" = "yes" ], [
    AC_CHECK_HEADERS([  \
        linux/if.h      \
        linux/if_ether.h \
        linux/if_packet.h \
        linux/pppox.h   \
        linux/termios.h])])

#
# Checks for typedefs, structures, and compiler characteristics.
AC_TYPE_MODE_T
AC_TYPE_SIZE_T
AC_TYPE_UINT16_T
AC_TYPE_UINT32_T
AC_TYPE_UINT8_T
AC_CHECK_SIZEOF(unsigned int)
AC_CHECK_SIZEOF(unsigned long)
AC_CHECK_SIZEOF(unsigned short)

# Checks for library functions.
AC_FUNC_ALLOCA
AC_FUNC_FORK
AC_FUNC_CHOWN
AC_FUNC_MALLOC
AC_CHECK_FUNCS([    \
    dup2            \
    gethostname     \
    localtime_r     \
    memmove         \
    memset          \
    mkdir           \
    select          \
    socket          \
    strerror        \
    strcasecmp      \
    strncasecmp     \
    strchr          \
    strdup          \
    strrchr         \
    strstr          \
    strtol          \
    strtoul         \
    strtoull])

#
# Check if libcrypt have crypt() function
AC_CHECK_LIB([crypt], [crypt],
    AC_SUBST([CRYPT_LIBS], ["-lcrypt"]))

#
# Check if libutil have logwtmp() function
AC_CHECK_LIB([util], [logwtmp],
    AC_SUBST([UTIL_LIBS], ["-lutil"]))

AC_ARG_ENABLE([systemd],
    AS_HELP_STRING([--enable-systemd], [Enable support for systemd notification]))
AS_IF([test "x${enable_systemd}" = "xyes"],
    AC_DEFINE([SYSTEMD], 1, [Enable support for systemd notifications]))
AM_CONDITIONAL(WITH_SYSTEMD, test "${enable_systemd}" = "yes")

#
# Enable Microsoft Callback Protocol Support, disabled by default
AC_ARG_ENABLE([cbcp],
    AS_HELP_STRING([--enable-cbcp], [Enable Microsoft Callback Protocol]))
AS_IF([test "x${enable_cbcp}" = "xyes" ],
    AC_DEFINE([CBCP_SUPPORT], 1, [Have Microsoft Callback Protocol support]))
AM_CONDITIONAL(WITH_CBCP, test "${enable_cbcp}" = "yes")

#
# Disable Microsoft extensions will remove CHAP and MPPE support
AC_ARG_ENABLE([microsoft-extensions],
    AS_HELP_STRING([--disable-microsoft-extensions], [Disable Microsoft CHAP / MPPE extensions]))
AS_IF([test "x$enable_microsoft_extensions" != "xno"],
    AC_DEFINE([CHAPMS], 1, ["Have Microsoft CHAP support"]))
AM_CONDITIONAL(WITH_CHAPMS, test "${enable_microsoft_extensions}" != "no")
AS_IF([test "x$enable_microsoft_extensions" != "xno"],
    AC_DEFINE([MPPE], 1, ["Have Microsoft MPPE support"]))
AM_CONDITIONAL(WITH_MPPE, test "${enable_microsoft_extensions}" != "no")

# 
# Disable IPv6 support
AC_ARG_ENABLE([ipv6-support],
    AS_HELP_STRING([--disable-ipv6-support], [Disable IPv6 support]))
AS_IF([test "x$enable_ipv6_support" != "xno"],
    AC_DEFINE(INET6, 1, ["Have IPv6 support"]))
AM_CONDITIONAL(WITH_INET6, test "${enable_ipv6_support}" != "no")

#
# Disable Multilink support
AC_ARG_ENABLE([multilink],
    AS_HELP_STRING([--disable-multilink], [Disable multilink support]))
AS_IF([test "${build_sunos}" = "yes"], [
    AC_MSG_WARN([Multilink support not available on SunOS])
    enable_multilink="no"])
AS_IF([test "x$enable_multilink" != "xno"], 
    AC_DEFINE([HAVE_MULTILINK], 1, ["Have multilink support"]))
AM_CONDITIONAL(WITH_MULTILINK, test "${enable_multilink}" != "no")

#
# TDB support is controlled by the multilink flag
AS_IF([test "x$enable_multilink" != "xno"], 
    AC_DEFINE([USE_TDB], 1, ["Include TDB support"]))
AM_CONDITIONAL(WITH_TDB, test "${enable_multilink}" != "no")

#
# Disable support for activating pppd on packet activity (filter support)
AC_ARG_ENABLE([filter],
    AS_HELP_STRING([--disable-filter], [Disable packet activity filter support]))
AS_IF([test "x$enable_filter" != "xno"],
    [AC_MSG_CHECKING([for pcap_create in -lpcap])
     LIBS_OLD="$LIBS"
     LIBS="$LIBS -lpcap"
     AC_LINK_IFELSE(
        [AC_LANG_PROGRAM([@%:@include <pcap.h>], [pcap_create(0,0);])],
        [AC_MSG_RESULT([yes])],
        [AC_MSG_ERROR([--enable-filter is enabled by default, but libpcap is isn't found])])
     LIBS="$LIBS_OLD"
     ])
AS_IF([test "x$enable_filter" != "xno"], 
    AC_DEFINE([FILTER], 1, ["Have packet activity filter support"]))
AM_CONDITIONAL(WITH_FILTER, test "${enable_filter}" != "no")

# 
# Enable support for loadable plugins
AC_ARG_ENABLE([plugins],
    AS_HELP_STRING([--disable-plugins], [Disable support for loadable plugins]))
AS_IF([test "x$enable_plugins" != "xno"],
    AC_DEFINE([PLUGINS], 1, ["Have support for loadable plugins"]))
AM_CONDITIONAL(WITH_PLUGINS, test "${enable_plugins}" != "no")

#
# Disable EAP-PEAP support
AC_ARG_ENABLE([peap],
    AS_HELP_STRING([--disable-peap], [Disable PEAP authentication support]))
AS_IF([test "x$enable_peap" != "xno"], 
    AC_DEFINE([USE_PEAP], 1, ["Have PEAP authentication support"]))
AM_CONDITIONAL(WITH_PEAP, test "${enable_peap}" != "no")

#
# Disable EAP-TLS support
AC_ARG_ENABLE([eaptls],
    AS_HELP_STRING([--disable-eaptls], [Disable EAP-TLS authentication support]))
AS_IF([test "x$enable_eaptls" != "xno"], 
    AC_DEFINE([USE_EAPTLS], 1, ["Have PEAP authentication support"]))
AM_CONDITIONAL(WITH_EAPTLS, test "${enable_eaptls}" != "no")

#
# Disable OpenSSL engine support
AC_ARG_ENABLE([openssl-engine],
    AS_HELP_STRING([--disable-openssl-engine], [Disable OpenSSL engine support]))
AS_IF([test "x$enable_openssl_engine" != "xno"], [],
    AC_DEFINE([OPENSSL_NO_ENGINE], 1, ["OpenSSL engine support"]))

#
# Specify runtime directory
AC_ARG_ENABLE([plugin-dir], 
	AC_HELP_STRING([--with-plugin-dir=DIR], [Specify the plugin directory for pppd]))
AS_IF([test -n "$with_plugin_dir"],
	[PPPD_PLUGIN_DIR="$with_plugin_dir"],
	[PPPD_PLUGIN_DIR="${libdir}/pppd/$VERSION"])
AC_SUBST(PPPD_PLUGIN_DIR, "$PPPD_PLUGIN_DIR", [The pppd plugin directory])

#
# Specify runtime directory
AC_ARG_ENABLE([runtime-dir], 
	AC_HELP_STRING([--with-runtime-dir=DIR], [Specify the runtime directory for pppd]))
AS_IF([test -n "$with_runtime_dir"],
	[PPPD_RUNTIME_DIR="$with_runtime_dir"],
	[PPPD_RUNTIME_DIR="${localstatedir}/run/pppd"])
AC_SUBST(PPPD_RUNTIME_DIR)

#
# Specify runtime directory
AC_ARG_ENABLE([logfile-dir],
	AC_HELP_STRING([--with-logfile-dir=DIR], [Specify the log directory for pppd]))
AS_IF([test -n "$with_logfile_dir"],
	[PPPD_LOGFILE_DIR="$with_logfile_dir"],
	[PPPD_LOGFILE_DIR="${localstatedir}/log/pppd"])
AC_SUBST(PPPD_LOGFILE_DIR)

#
# Enable PAM support
AC_ARG_ENABLE([pam],
    AS_HELP_STRING([--with-pam], [Enable support for Pluggable Authentication Modules (see ftp.redhat.com:/pub/pam/)]))
AS_IF([test "x$enable_pam" = "xyes"], 
    AC_DEFINE([USE_PAM], 1, ["Support for Pluggable Authentication Modules"]))
AM_CONDITIONAL(WITH_PAM, test "${enable_pam}" = "yes")

#
# Check for OpenSSL
AX_CHECK_OPENSSL([], [
    AC_DEFINE([USE_MD4], 1, [Use included md4 included with pppd])
    AC_DEFINE([USE_MD5], 1, [Use included md5 included with pppd])
    AC_DEFINE([USE_CRYPT], 1, [Use included des included with pppd])
    AC_DEFINE([USE_SHA], 1, [Use included sha included with pppd])])
AM_CONDITIONAL(WITH_OPENSSL, test "${with_openssl}" != "no")

#
# Check if OpenSSL has compiled in support for various ciphers
AS_IF([ test "${with_openssl}" != "no" ], [
    AX_CHECK_OPENSSL_DEFINE([OPENSSL_NO_MD4], [md4],,
        [AC_DEFINE([USE_MD4], 1, [Use included md4 included with pppd])]) 

    AX_CHECK_OPENSSL_DEFINE([OPENSSL_NO_MD5], [md5],,
        [AC_DEFINE([USE_MD5], 1, [Use included md5 included with pppd])]) 

    AX_CHECK_OPENSSL_DEFINE([OPENSSL_NO_DES], [des],,
        [AC_DEFINE([USE_CRYPT], 1, [Use included des included with pppd])]) 

    AX_CHECK_OPENSSL_DEFINE([OPENSSL_NO_SHA], [sha],,
        [AC_DEFINE([USE_SHA], 1, [Use included sha included with pppd])]) 
], [
    AS_IF([test "x$enable_eaptls" != "xno"] && [test "x$enable_peap" != "xno" ],
        [AC_MSG_ERROR([OpenSSL not found, and if this is your intention then run configure --disable-peap --disable-eaptls])])
])

AM_CONDITIONAL(OPENSSL_HAVE_MD4, test "${ac_cv_openssl_md4}" != "no")
AM_CONDITIONAL(OPENSSL_HAVE_MD5, test "${ac_cv_openssl_md5}" != "no")
AM_CONDITIONAL(OPENSSL_HAVE_DES, test "${ac_cv_openssl_des}" != "no")
AM_CONDITIONAL(OPENSSL_HAVE_SHA, test "${ac_cv_openssl_sha}" != "no")

#
# If OpenSSL doesn't support DES, then use the one from libcrypt (glibc dropped support for this in 2.27).
AS_IF([test "${ac_cv_openssl_des}" = "no" ], [
    AC_CHECK_LIB([crypt], [encrypt], 
        [LIBS="$LIBS -lcrypt"],
        [AC_MSG_ERROR([OpenSSL not found or does not support DES, and libcrypt also doesn't support encrypt])]
    )
])

#
# With libsrp support
AX_CHECK_SRP

#
# With libatm support
AX_CHECK_ATM

AC_CONFIG_FILES([
    Makefile
    chat/Makefile
    pppd/Makefile
    pppd/pppd.pc
    pppd/plugins/Makefile
    pppd/plugins/pppoe/Makefile
    pppd/plugins/pppoatm/Makefile
    pppd/plugins/pppol2tp/Makefile
    pppd/plugins/radius/Makefile
    pppdump/Makefile
    pppstats/Makefile])
AC_OUTPUT

echo "
$PACKAGE_NAME version $PACKAGE_VERSION
    Prefix...............: $prefix
    Runtime Dir..........: $PPPD_RUNTIME_DIR
    Logfile Dir..........: $PPPD_LOGFILE_DIR
    Plugin Dir...........: $PPPD_PLUGIN_DIR
    With OpenSSL.........: ${with_openssl:-yes}
    With libsrp..........: ${with_srp:-no}
    With libatm..........: ${with_atm:-no}
    C Compiler...........: $CC $CFLAGS
    Linker...............: $LD $LDFLAGS $LIBS

Features enabled
    Microsoft Extensions.: ${enable_microsoft_extensions:-yes}
    Multilink............: ${enable_multilink:-yes}
    Filter...............: ${enable_filter:-yes}
    PAM..................: ${enable_pam:-no}
    EAP-TLS..............: ${enable_eaptls:-yes}
    EAP-PEAP.............: ${enable_peap:-yes}
    Plugins..............: ${enable_plugins:-yes}
    CBCP.................: ${enable_cbcp:-no}
"
