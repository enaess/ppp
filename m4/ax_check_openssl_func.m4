# SYNOPSIS
#
#   AX_CHECK_OPENSSL_FUNC([include], [func], [action-if-found[, action-if-not-found]])
#
# DESCRIPTION
#
#   Look for OpenSSL in a number of default spots, or in a user-selected
#   spot (via --with-openssl).  Sets
#

#serial 1

AC_DEFUN([_AX_FUNC_OPENSSL], [
    save_LIBS="$LIBS"
    save_LDFLAGS="$LDFLAGS"
    save_CPPFLAGS="$CPPFLAGS"
    LDFLAGS="$LDFLAGS $OPENSSL_LDFLAGS"
    LIBS="$OPENSSL_LIBS $LIBS"
    CPPFLAGS="$OPENSSL_INCLUDES $CPPFLAGS"
    AC_LINK_IFELSE(
        [AC_LANG_PROGRAM([$1], [$2])],
        [
            AC_MSG_RESULT([yes])
            $3
        ], [
            AC_MSG_RESULT([no])
            $4
        ])
    CPPFLAGS="$save_CPPFLAGS"
    LDFLAGS="$save_LDFLAGS"
    LIBS="$save_LIBS"
])

AC_DEFUN([AX_FUNC_OPENSSL_MD4], [
    AC_MSG_CHECKING([if openssl supports md4])
    _AX_FUNC_OPENSSL([[@%:@include <openssl/md4.h>]],
        [[MD4_Init(NULL);]],
        [ac_cv_openssl_working_md4=yes]
        $1,
        [ac_cv_openssl_working_md4=no]
        $2
    )
])

AC_DEFUN([AX_CHECK_OPENSSL_DEFINE], [
    AC_MSG_CHECKING([for $2 support in openssl])
    save_CPPFLAGS="$CPPFLAGS"
    CPPFLAGS="$OPENSSL_INCLUDES $CPPFLAGS"
    AC_PREPROC_IFELSE([
        AC_LANG_PROGRAM(
            [[@%:@include <openssl/opensslconf.h>]],
            [[#ifdef $1
              #error "No support for $1"
              #endif]])],
        AC_MSG_RESULT([yes])
        [ac_cv_openssl_$2=yes]
        $3,
        AC_MSG_RESULT([no])
        [ac_cv_openssl_$2=no]
        $4
    )
    CPPFLAGS="$save_CPPFLAGS"
])

