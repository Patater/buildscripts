#!/bin/bash

export DEVKITSH4=$TOOLPATH/devkitSH4
export DEVKITPRO=$TOOLPATH

#---------------------------------------------------------------------------------
# copy base rulesets
#---------------------------------------------------------------------------------
cp -v $BUILDSCRIPTDIR/dksh4/rules/* $prefix

#---------------------------------------------------------------------------------
# Build and install the dreamcast crt
#---------------------------------------------------------------------------------
cp -v $BUILDSCRIPTDIR/dksh4/crtls/* $prefix/$target/lib/
cd $prefix/$target/lib/
$MAKE CRT=dreamcast
