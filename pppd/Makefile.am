sbin_PROGRAMS = pppd
man8_MANS = pppd.8 srp-entry.8
if WITH_SRP
sbin_PROGRAMS += srp-entry
endif

pkgconfigdir   = $(libdir)/pkgconfig
pkgconfig_DATA = pppd.pc

pppd_includedir = $(includedir)/pppd
pppd_include_HEADERS = \
    cbcp.h \
    ccp.h \
    chap-md5.h \
    chap_ms.h \
    chap-new.h \
    eap.h \
    eap-tls.h \
    ecp.h \
    eui64.h \
    fsm.h \
    ipcp.h \
    ipv6cp.h \
    ipxcp.h \
    lcp.h \
    magic.h \
    md4.h \
    md5.h \
    mppe.h \
    patchlevel.h \
    pathnames.h \
    peap.h \
    pppcrypt.h \
    pppd.h \
    session.h \
    sha1.h \
    spinlock.h \
    tdb.h \
    upap.h 

pppd_SOURCES = \
    auth.c \
    ccp.c \
    chap-md5.c \
    chap-new.c \
    demand.c \
    eap.c \
    ecp.c \
    fsm.c \
    ipcp.c \
    ipxcp.c \
    lcp.c \
    magic.c \
    main.c \
    options.c \
    session.c \
    tty.c \
    upap.c \
    utils.c

if LINUX
pppd_SOURCES += sys-linux.c
endif

if SUNOS
pppd_SOURCES += sys-solaris.c
endif

pppd_CFLAGS = -I${top_srcdir}/include
pppd_LDFLAGS =
pppd_LIBS = @CRYPT_LIBS@ @UTIL_LIBS@

if WITH_CHAPMS
pppd_SOURCES += chap_ms.c
pppd_SOURCES += pppcrypt.c
else
if WITH_SRP
pppd_SOURCES += pppcrypt.c
endif
endif

if WITH_CBCP
pppd_SOURCES += cbcp.c
endif

if WITH_MPPE
pppd_SOURCES += mppe.c
endif

if WITH_FILTER
pppd_LIBS += -lpcap
endif

if WITH_PLUGINS
pppd_CFLAGS += -D_PATH_PLUGIN=@PPPD_PLUGIN_DIR@
pppd_LIBS += -ldl
if LINUX
pppd_LDFLAGS += -Wl,-E
endif
endif

if WITH_MULTILINK
pppd_SOURCES += multilink.c
endif

if WITH_TDB
pppd_SOURCES += tdb.c spinlock.c
endif

if WITH_INET6
pppd_SOURCES += ipv6cp.c eui64.c
endif

if WITH_PAM
pppd_LIBS += -lpam -ldl
endif

if WITH_EAPTLS
pppd_SOURCES += eap-tls.c
endif

if WITH_PEAP
pppd_SOURCES += peap.c
endif

if !WITH_OPENSSL
pppd_SOURCES += md5.c md4.c sha1.c
else
pppd_CFLAGS += @OPENSSL_INCLUDES@
pppd_LDFLAGS += @OPENSSL_LDFLAGS@
pppd_LIBS += @OPENSSL_LIBS@
if !OPENSSL_HAVE_SHA
pppd_SOURCES += sha1.c
endif
if !OPENSSL_HAVE_MD4
pppd_SOURCES += md4.c
endif
if !OPENSSL_HAVE_MD5
pppd_SOURCES += md5.c
endif
endif

if WITH_SYSTEMD
pppd_LIBS += -lsystemd
endif

if WITH_SRP
srp_entry_SOURCES = srp-entry.c
srp_entry_CFLAGS = @OPENSSL_INCLUDES@ @SRP_CFLAGS@
srp_entry_LDADD = @SRP_LIBS@ @OPENSSL_LIBS@ 
srp_entry_LDFLAGS = @OPENSSL_LDFLAGS@ @SRP_LDFLAGS@

pppd_CFLAGS += @SRP_CFLAGS@
pppd_LDFLAGS += @SRP_LDFLAGS@
pppd_LIBS += @SRP_LIBS@
endif

pppd_LDADD = $(pppd_LIBS)

EXTRA_DIST = \
    $(man8_MANS)
