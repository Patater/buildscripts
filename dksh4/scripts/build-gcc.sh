#!/bin/sh

#---------------------------------------------------------------------------------
# build and install binutils
#---------------------------------------------------------------------------------

mkdir -p $target/binutils
cd $target/binutils

if [ ! -f configured-binutils ]
then
	CFLAGS=$cflags LDFLAGS=$ldflags ../../binutils-$BINUTILS_VER/configure \
	--prefix=$prefix --target=$target --disable-nls --disable-debug \
	--enable-lto --enable-plugins \
	--enable-poison-system-directories \
	--disable-dependency-tracking  --disable-werror \
	$CROSS_PARAMS \
	|| { echo "Error configuring binutils"; exit 1; }
	touch configured-binutils
fi

if [ ! -f built-binutils ]
then
	$MAKE || { echo "Error building binutils"; exit 1; }
	touch built-binutils
fi


if [ ! -f installed-binutils ]
then
	$MAKE install || { echo "Error installing binutils"; exit 1; }
	touch installed-binutils
fi
cd $BUILDDIR

#---------------------------------------------------------------------------------
# build and install just the c compiler
#---------------------------------------------------------------------------------
mkdir -p $target/gcc
cd $target/gcc


if [ ! -f configured-gcc ]
then
	CFLAGS="$cflags" LDFLAGS="$ldflags" CFLAGS_FOR_TARGET="-O2" LDFLAGS_FOR_TARGET="" ../../gcc-$GCC_VER/configure \
	--enable-languages=c,c++,objc,obj-c++ \
    --with-endian=little \
	--enable-poison-system-directories \
	--with-multilib-list=m4,m4-single,m4-single-only,m4-nofpu \
	--disable-dependency-tracking \
	--disable-threads \
	--disable-win32-registry --disable-nls \
	--disable-debug \
	--disable-libmudflap --disable-libssp --disable-libgomp \
	--disable-libstdcxx-pch \
	--enable-lto $plugin_ld \
	--with-newlib \
	--with-headers=../../newlib-$NEWLIB_VER/newlib/libc/include \
	--target=$target \
	--prefix=$prefix \
	--with-bugurl="http://wiki.devkitpro.org/index.php/Bug_Reports" \
	--with-pkgversion="devkitSH4 release 0" \
	$CROSS_PARAMS \
	|| { echo "Error configuring gcc"; exit 1; }
	touch configured-gcc
fi


if [ ! -f built-gcc ]
then
	$MAKE all-gcc || { echo "Error building gcc"; exit 1; }
	touch built-gcc
fi


if [ ! -f installed-gcc ]
then
	$MAKE install-gcc || { echo "Error installing gcc"; exit 1; }
	touch installed-gcc
fi

unset CFLAGS
cd $BUILDDIR
#
#unset CFLAGS
#unset CFLAGS_FOR_HOST
#unset LDFLAGS
#
##---------------------------------------------------------------------------------
## build and install newlib
##---------------------------------------------------------------------------------
#mkdir -p $target/newlib
#cd $target/newlib
#
#if [ ! -f configured-newlib ]
#then
#	../../newlib-$NEWLIB_VER/configure \
#	--target=$target \
#	--prefix=$prefix \
#	--disable-dependency-tracking \
#	|| { echo "Error configuring newlib"; exit 1; }
#	touch configured-newlib
#fi
#
#if [ ! -f built-newlib ]
#then
#	$MAKE || { echo "Error building newlib"; exit 1; }
#	touch built-newlib
#fi
#
#if [ ! -f installed-newlib ]
#then
#	$MAKE install || { echo "Error installing newlib"; exit 1; }
#	touch installed-newlib
#fi
#
##---------------------------------------------------------------------------------
## build and install the final compiler
##---------------------------------------------------------------------------------
#
#cd $BUILDDIR
#
#cd $target/gcc
#
#if [ ! -f built-stage2 ]
#then
#	$MAKE all || { echo "Error building gcc stage2"; exit 1; }
#	touch built-stage2
#fi
#
#if [ ! -f installed-stage2 ]
#then
#	$MAKE install || { echo "Error installing gcc stage2"; exit 1; }
#	touch installed-stage2
#fi
#
#rm -fr $prefix/$target/sys-include
#cd $BUILDDIR/pspsdk-$PSPSDK_VER
#
##---------------------------------------------------------------------------------
## build and install the psp sdk
##---------------------------------------------------------------------------------
#echo "building pspsdk ..."
#
#if [ ! -f built-sdk ]
#then
#	$MAKE || { echo "ERROR BUILDING PSPSDK"; exit 1; }
#	touch built-sdk
#fi
#
#if [ ! -f installed-sdk ]
#then
#	$MAKE install || { echo "ERROR INSTALLING PSPSDK"; exit 1; }
#	touch installed-sdk
#fi
#
#cd $BUILDDIR
#
##---------------------------------------------------------------------------------
## build and install the debugger
##---------------------------------------------------------------------------------
#mkdir -p $target/gdb
#cd $target/gdb
#
#if [ ! -f configured-gdb ]
#then
#	CFLAGS=$cflags LDFLAGS=$ldflags ../../gdb-$GDB_VER/configure \
#	--disable-nls --prefix=$prefix --target=$target --disable-werror \
#	--disable-dependency-tracking \
#	$CROSS_PARAMS \
#	|| { echo "Error configuring gdb"; exit 1; }
#	touch configured-gdb
#fi
#
#if [ ! -f built-gdb ]
#then
#	$MAKE || { echo "Error building gdb"; exit 1; }
#	touch built-gdb
#fi
#
#if [ ! -f installed-gdb ]
#then
#	$MAKE install || { echo "Error installing gdb"; exit 1; }
#	touch installed-gdb
#fi
#
