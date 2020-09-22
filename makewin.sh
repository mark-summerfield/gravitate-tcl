#!/bin/bash
MAIN=gravitate.tcl
freewrap $MAIN \
    -o `basename $MAIN .tcl`.exe \
    -w ~/opt/freewrap/win32/freewrap.exe \
    -i images/icon.ico \
    -9 \
    `ls *.tcl|grep -v $MAIN` \
    images/*.png

