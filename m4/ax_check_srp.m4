#serial 1

AC_DEFUN([AX_CHECK_SRP], [
    AC_ARG_WITH([srp],
        [AS_HELP_STRING([--with-srp=DIR],
            [With libsrp support, see http://srp.stanford.edu])],
        [
            case "$withval" in
            "" | y | ye | yes)
                srpdirs="/usr/local /usr/lib /usr"  
              ;;
            n | no)
                with_srp=""
              ;;
            *)
                srpdirs="$withval"
              ;;
            esac
        ])
    
    if [ test -n "${with_srp}" ] ; then
        SRP_LIBS="-lsrp"
        for srpdir in $srpdirs; do
            AC_MSG_CHECKING([for srp.h in $srpdir])
            if test -f "$srpdir/include/srp.h"; then
                SRP_CFLAGS="-I$srpdir/include"
                SRP_LDFLAGS="-L$srpdir/lib"
                AC_MSG_RESULT([yes])
                break
            else
                AC_MSG_RESULT([no])
            fi
        done

        # try the preprocessor and linker with our new flags,
        # being careful not to pollute the global LIBS, LDFLAGS, and CPPFLAGS

        AC_MSG_CHECKING([if compiling and linking against libsrp works])

        save_LIBS="$LIBS"
        save_LDFLAGS="$LDFLAGS"
        save_CPPFLAGS="$CPPFLAGS"
        LDFLAGS="$LDFLAGS $SRP_LDFLAGS"
        LIBS="$SRP_LIBS $LIBS"
        CPPFLAGS="$SRP_CFLAGS $CPPFLAGS"
        AC_LINK_IFELSE(
            [AC_LANG_PROGRAM(
                [#include <srp.h>
                 #include <stddef.h>], 
                [SRP_use_engine(NULL);])],
            [
                AC_MSG_RESULT([yes])
                with_srp=yes
                $1
            ], [
                AC_MSG_RESULT([no])
                with_srp=""
                $2
            ])
        CPPFLAGS="$save_CPPFLAGS"
        LDFLAGS="$save_LDFLAGS"
        LIBS="$save_LIBS"

        AC_SUBST([SRP_CFLAGS])
        AC_SUBST([SRP_LIBS])
        AC_SUBST([SRP_LDFLAGS])
    fi

    AM_CONDITIONAL(WITH_SRP, test -n "${with_srp}")
])

