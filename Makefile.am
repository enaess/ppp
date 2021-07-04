ACLOCAL_AMFLAGS="-Im4"

SUBDIRS = chat pppd pppstats pppdump

if WITH_PLUGINS
SUBDIRS += pppd/plugins
endif

sampledir = $(sysconfdir)/@PACKAGE@

sample_DATA = \
    etc.ppp/options \
    etc.ppp/chap-secrets \
    etc.ppp/pap-secrets \
    etc.ppp/eaptls-server \
    etc.ppp/eaptls-client \
    etc.ppp/openssl.cnf

EXTRA_HEADERS = \
    include/linux/if_ppp.h \
    include/linux/ppp-comp.h \
    include/linux/ppp_defs.h \
    include/net/if_ppp.h \
    include/net/ppp-comp.h \
    include/net/ppp_defs.h \
    include/net/pppio.h \
    include/net/slcompress.h \
    include/net/vjcompress.h

EXTRA_DIST= \
    $(sample_DATA) \
    $(EXTRA_HEADERS)
