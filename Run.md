# How to run
## Basic setup
-  Instal [MSYS2][1], assume install in the `C:\User\%USERNAME%\Msys64` folder, prepare the build environment and tcl in MSYS2 console(run `msys2_shell.cmd`):
    >     pacman -Suy
    >     pacman -S mingw-w64-x86_64-toolchain
    >     pacman -S mingw-w64-x86_64-tcllib  mingw-w64-x86_64-tclx mingw-w64-x86_64-tclvfs mingw-w64-x86_64-tkimg mingw-w64-x86_64-tklib mingw-w64-x86_64-bwidget mingw-w64-x86_64-tktable
[1]: https://www.msys2.org/

-    Build the [treectrl][2] in Mingw64 console(run `mingw64.exe`):
        -    clone source
             >     git clone https://github.com/apnadkarni/tktreectrl
             >     cd tktreectrl/
        -    Add support to Mingw64 and solve build error, modify `configure`
                ```diff
                @@ -2282,11 +2282,11 @@ $as_echo "ok (TEA ${TEA_VERSION})" >&6; }
                 	    *mingw32*)
                 		compile_for_windows="yes"
                 	esac
                     fi
                     case "`uname -s`" in
                -	*win32*|*WIN32*|*MINGW32_*)
                +	*win32*|*WIN32*|*MINGW32_*|*MINGW64_*)
                 	    compile_for_windows="yes"
                 	    ;;
                     esac
                     if test $compile_for_windows = yes ; then
                 	    # Extract the first word of "cygpath", so it can be a program name with args.
                @@ -6217,11 +6217,11 @@ if test "${TEA_PLATFORM}" = "windows" ; then
                     done




                -    vars="gdi32.lib user32.lib"
                +    vars="gdi32.lib user32.lib UxTheme.lib"
                     for i in $vars; do
                 	if test "${TEA_PLATFORM}" = "windows" -a "$GCC" = "yes" ; then
                 	    # Convert foo.lib to -lfoo for GCC.  No-op if not *.lib
                 	    i=`echo "$i" | sed -e 's/^\([^-].*\)\.lib$/-l\1/i'`
                 	fi
                @@ -6319,11 +6319,11 @@ $as_echo_n "checking for Windows native path bug in windres... " >&6; }
                   ac_status=$?
                   $as_echo "$as_me:${as_lineno-$LINENO}: \$? = $ac_status" >&5
                   test $ac_status = 0; }; } ; then
                 		{ $as_echo "$as_me:${as_lineno-$LINENO}: result: no" >&5
                 $as_echo "no" >&6; }
                -		RC_DEPARG='"$(shell $(CYGPATH) $<)"'
                +		RC_DEPARG='"$<"'
                 	    else
                 		{ $as_echo "$as_me:${as_lineno-$LINENO}: result: yes" >&5
                 $as_echo "yes" >&6; }
                 	    fi
                 	    conftest=
                ```
        -    make & install
             >     ./configure
             >     make install

[2]: https://github.com/apnadkarni/tktreectrl

-    Build the [Trf][3] which required by the app tape in Mingw64 console(run `mingw64.exe`):
        -    clone source
             >     git clone git://git.altlinux.org/gears/t/tcl-trf.git
             >     cd tcl-trf
        -    after applying the below patch, copy `tcl-trf/win/Makefile.gnu` as `tcl-trf/win/Makefile`
                ```diff
                --- a/generic/sha/sha.h
                +++ b/generic/sha/sha.h
                @@ -18,7 +18,7 @@ typedef unsigned int  UINT32;
                 #ifdef _WIN32
                 #	pragma warning ( disable : 4142 )
                 #endif
                -typedef unsigned long UINT32;
                +typedef unsigned int UINT32;
                 #endif
                 #endif

                --- a/win/Makefile.gnu
                +++ b/win/Makefile.gnu
                @@ -7,7 +7,7 @@
                 EXTENSION	= Trf
                 VERSION		= 2.1.4
                 #TCL_VERSION	= 81
                -TCL_VERSION	= 82
                +TCL_VERSION	= 86

                 TRF_DLL_FILE	    = ${EXTENSION}21.dll
                 TRF_LIB_FILE	    = lib${EXTENSION}21.a
                @@ -31,10 +31,11 @@ BZ2_LIBRARY	= -DBZ2_LIB_NAME=\"bz2.dll\"
                 srcdir		=	.
                 TMPDIR		=	.

                +TCL_DIRECTORY_ROOT = /C/Users/$(USERNAME)/Msys64/mingw64
                 # Directories in which the Tcl core can be found
                -TCL_INC_DIR	= /progra~1/tcl/include
                -TCL_LIB_DIR	= /progra~1/tcl/lib
                -TCL_LIB_SPEC	= /progra~1/tcl/lib/libtclstub$(TCL_VERSION).a
                +TCL_INC_DIR	= $(TCL_DIRECTORY_ROOT)/include
                +TCL_LIB_DIR	= $(TCL_DIRECTORY_ROOT)/lib
                +TCL_LIB_SPEC	= $(TCL_DIRECTORY_ROOT)/lib/libtclstub$(TCL_VERSION).a

                 # Libraries to be included with trf.dll
                 TCL_SHARED_LIBS		=
                @@ -45,7 +46,7 @@ TCL_SHARED_LIBS		=
                 # at configure-time with the --exec-prefix and --prefix options
                 # to the "configure" script.

                -prefix		=	/progra~1/Tcl
                +prefix		=	$(TCL_DIRECTORY_ROOT)
                 exec_prefix	=	$(prefix)

                 # Directory containing scripts supporting the work of this makefile
                @@ -81,7 +82,7 @@ MAN_INSTALL_DIR =	$(INSTALL_ROOT)$(prefix)/man

                 # To change the compiler switches, for example to change from -O
                 # to -g, change the following line:
                -CFLAGS		=	-O2 -fnative-struct -mno-cygwin -DNDEBUG -DUSE_TCL_STUBS -D__WIN32__ -DWIN32 -D_WINDOWS -DZLIB_DLL -DTCL_THREADS -DHAVE_STDLIB_H
                +CFLAGS		=	-O2                             -DNDEBUG -DUSE_TCL_STUBS -D__WIN32__ -DWIN32 -D_WINDOWS -DZLIB_DLL -DTCL_THREADS -DHAVE_STDLIB_H  -DPACKAGE_NAME="\"${EXTENSION}\""  -DPACKAGE_VERSION="\"${VERSION}\""

                 # To disable ANSI-C procedure prototypes reverse the comment characters
                 # on the following lines:
                @@ -116,8 +117,8 @@ INSTALL = $(tool)/install-sh -c
                 # these definitions by hand. The second definition should be used
                 # in conjunction with Tcl 8.1.

                -TRF_SHLIB_CFLAGS =
                -#TRF_SHLIB_CFLAGS = -DTCL_USE_STUBS
                +#TRF_SHLIB_CFLAGS =
                +TRF_SHLIB_CFLAGS = -DTCL_USE_STUBS


                 # The symbol below provides support for dynamic loading and shared
                @@ -156,11 +157,11 @@ CC		=	gcc
                 AS = as
                 LD = ld
                 DLLTOOL = dlltool
                -DLLWRAP = dllwrap -mnocygwin
                +DLLWRAP = gcc -shared
                 WINDRES = windres

                -DLL_LDFLAGS = -mwindows -Wl,-e,_DllMain@12
                -DLL_LDLIBS = -L/progra~1/tcl/lib -ltclstub$(TCL_VERSION)
                +DLL_LDFLAGS = -mwindows
                +DLL_LDLIBS = -L$(TCL_DIRECTORY_ROOT)/lib -ltclstub$(TCL_VERSION)

                 baselibs   = -lkernel32 $(optlibs) -ladvapi32
                 winlibs    = $(baselibs) -luser32 -lgdi32 -lcomdlg32 -lwinspool
                @@ -171,7 +172,7 @@ guilibsdll = $(libcdll) $(winlibs)
                 TRF_DEFINES	= -D__WIN32__ -DSTATIC_BUILD  ${TRF_SHLIB_CFLAGS} -DTRF_VERSION="\"${VERSION}\"" ${SSL_LIBRARY} ${ZLIB_STATIC} ${BZLIB_STATIC} -DBUGS_ON_EXIT

                 # $(TCL_CC_SWITCHES)
                -INCLUDES	=	-I. -I$(srcdir) -I../generic -I$(TCL_INC_DIR)
                +INCLUDES	=	-I. -I$(srcdir) -I../generic -I$(TCL_INC_DIR) -I$(TCL_INC_DIR)/tcl8.6/tcl-private/win -I$(TCL_INC_DIR)/tcl8.6/tcl-private/generic
                 DEFINES		=	$(PROTO_FLAGS) $(MEM_DEBUG_FLAGS) $(TRF_SHLIB_CFLAGS) \
                 			$(TRF_DEFINES)

                @@ -412,7 +413,7 @@ dllEntry.o:	dllEntry.c
                 #-------------------------------------------------------#

                 $(TRF_DLL_FILE):	$(OBJECTS) trfres.o dllEntry.o trf.def
                -	$(DLLWRAP) -s $(DLL_LDFLAGS) -mno-cygwin -o $@ $(OBJECTS) \
                +	$(DLLWRAP) -s $(DLL_LDFLAGS)             -o $@ $(OBJECTS) \
                 		trfres.o dllEntry.o --def trf.def \
                 		$(DLL_LDLIBS)

                @@ -436,12 +437,18 @@ trfres.o: trf.rc
                 #-------------------------------------------------------#

                 clean:
                -	del $(OBJECTS) $(TRF_DLL_FILE)
                -	del TAGS depend *~ */*~ core* tests/core* so_locations lib*.so*
                +	rm -fr $(OBJECTS) $(TRF_DLL_FILE)
                +	rm -fr TAGS depend *~ */*~ core* tests/core* so_locations lib*.so*

                 distclean:	clean
                -	del config.*
                -	del Makefile
                +	rm -fr config.*
                +	rm -fr Makefile
                +
                +INSTALL_TARGET_DIR := $(TCL_LIB_DIR)/$(EXTENSION)$(VERSION)
                +install: all
                +	mkdir -p $(INSTALL_TARGET_DIR)
                +	cp -pRvf $(TRF_DLL_FILE) $(INSTALL_TARGET_DIR)
                +	cp -pRvf pkgIndex.tcl    $(INSTALL_TARGET_DIR)

                 #-------------------------------------------------------#
                 # DO NOT DELETE THIS LINE -- make depend depends on it.
                --- a/win/pkgIndex.tcl
                +++ b/win/pkgIndex.tcl
                @@ -10,6 +10,6 @@ proc trfifneeded dir {
                     } else {
                 	regsub {\.} [info tclversion] {} version
                     }
                -    package ifneeded Trf 2.1 "load [list [file join $dir trf21$version.dll]] Trf"
                +    package ifneeded Trf 2.1.4 "load [list [file join $dir trf21$version.dll]] Trf"
                 }
                 trfifneeded $dir
                ```
        -    make & install
             >     cd tcl-trf/win
             >     make install

[3]: https://git.altlinux.org/gears/t/tcl-trf.git

-    Build the `tdom`, following the [link][4] to download the source and build in mingw64.
        >     cd src
        >     ./configure
        >     make install

[4]: http://www.tdom.org/index.html/dir?ci=release

-    Build the `Mk4tcl`, following the [link][5] to build in mingw64.
        >     git clone https://github.com/pooryorick/metakit/
        >     cd metakit/tcl
        -    Add support to Mingw64 and solve build error, modify `configure`
                ```diff
                 @@ -1341,11 +1341,11 @@ echo "${ECHO_T}warning: requested TEA version \"3.6\", have \"${TEA_VERSION}\""
                     else
                 	echo "$as_me:$LINENO: result: ok (TEA ${TEA_VERSION})" >&5
                 echo "${ECHO_T}ok (TEA ${TEA_VERSION})" >&6
                     fi
                     case "`uname -s`" in
                -	*win32*|*WIN32*|*CYGWIN_NT*|*CYGWIN_9*|*CYGWIN_ME*|*MINGW32_*)
                +	*win32*|*WIN32*|*CYGWIN_NT*|*CYGWIN_9*|*CYGWIN_ME*|*MINGW32_*|*MINGW64_*)
                ```
        -    make & install
             >     ./configure
             >     make install


[5]: https://github.com/pooryorick/metakit/

- Install [ActiveState's Tcl][6] to get the header file `cmpInt.h`, otherwise the `tclcompiler` will build fail due to can not find the file  `cmpInt.h`.

[6]: https://www.activestate.com/products/tcl/

## Build necessary packages
-    Clone source and build(Assume the working directory is `/C/Users/$USERNAME`):
        >     git clone https://github.com/cyangy/tdk

        -    Build the `tclcompiler` in Mingw64 console(run `mingw64.exe`)
             >     cd tdk/lib/tclcompiler
        -    Copy the `cmpInt.h` from `C:\Program Files\ActiveTCL\include` to `tclcompiler` folder(or you can use `-I` of `CFLAGS` to specify the include folder)
        -    make
             >     ./configure
             >     make
        -    Build the `tclparser`
             >     cd tdk/lib/tclparser
             >     ./configure
             >     make
        -    Build the `pkg-src`
             >     cd tdk/pkg-src/win32
             >     ./configure
             >     make install
## Run Debugger app
-    After copying `tdk\app\debug\lib\*` to` tdk\lib`, you can run the debugger like this(in windows CMD)
        >   `tclsh.exe "C:\Users\%USERNAME%\tdk\app\debug\main.tcl"`
-    The Debugger window will appears and you can debug your tcl script. If the error `checker, analyze problem: Error in constructor: couldn't execute "-onepass": no such file or directory` happen, that's means the debugger can not find the `tclchecker` app. Do the following to solve this(Make sure the check app can run successfully before doing this, refer next section, the first item).
        -    In the directory `tdk\app\debug`, create a new batch file `tclchecker.bat` , then fill it with the content below
                ```batch
               tclsh.exe "%~dp0\..\check\main.tcl" %*
                ```
        -    Then run the debugger like this
                ```batch
               set "PATH=C:\Users\%USERNAME%\tdk\app\debug;%PATH%"
               tclsh.exe "C:\Users\%USERNAME%\tdk\app\debug\main.tcl"
                ```
# Run All of the apps
For some apps, you may need to copy the files to specified directory to make the app run(in windows CMD).
-   need copy `tdk\app\check\lib\app-check` to `tdk\lib`
    >    `tclsh.exe "C:\Users\%USERNAME%\tdk\app\check\main.tcl"`
-   need copy `tdk\app\comp\lib\*` to `tdk\lib`
    >    `tclsh.exe "C:\Users\%USERNAME%\tdk\app\comp\main.tcl"`
-   need copy `tdk\app\debug\lib\*` to `tdk\lib`
    >    `tclsh.exe "C:\Users\%USERNAME%\tdk\app\debug\main.tcl"`
-   need copy `tdk\app\inspector\lib\*` to `tdk\lib` , and copy `tdk\app\inspector\images` to `tdk\`
    >    `tclsh.exe "C:\Users\%USERNAME%\tdk\app\inspector\main.tcl"`
-   no need copy
    >    `tclsh.exe "C:\Users\%USERNAME%\tdk\app\launch\main.tcl"`
-   no need copy
    >    `tclsh.exe "C:\Users\%USERNAME%\tdk\app\lsmfs\main.tcl"`
-   need copy `tdk\app\tape\lib\*` to `tdk\lib`
    >    `tclsh.exe "C:\Users\%USERNAME%\tdk\app\tape\main.tcl"`
-   no need copy
    >    `tclsh.exe "C:\Users\%USERNAME%\tdk\app\tclapp\entry.tcl"`
-   no need copy `tdk\app\tclsvc\lib\*` to `tdk\lib`, but `tclsvc` can not run without `tclsvc84.exe`, and should be run as administrator, you can follow [this link][7] to make it works.
    >    `tclsh.exe "C:\Users\%USERNAME%\tdk\app\tclsvc\main.tcl"`
-   need copy `tdk\app\vfse\lib\*` to `tdk\lib`
    >    `tclsh.exe "C:\Users\%USERNAME%\tdk\app\vfse\main.tcl"`
-   no need copy
    >    `tclsh.exe "C:\Users\%USERNAME%\tdk\app\xref\main.tcl"`

[7]: https://github.com/quietboil/tclsvc


# Reference
- https://groups.google.com/g/comp.lang.tcl/c/5OpsoGb-Nyo
- https://wiki.tcl-lang.org/page/Tcl+Dev+Kit
