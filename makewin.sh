#!/bin/bash
cd src
MAIN=gravitate.tcl
EXE=`basename $MAIN .tcl`.exe
freewrap $MAIN \
    -o $EXE \
    -w ~/opt/freewrap/win32/freewrap.exe \
    -i images/icon.ico \
    -9 \
    `ls *.tcl|grep -v $MAIN` \
    images/*.png
rm -f results.txt
mv $EXE ..
