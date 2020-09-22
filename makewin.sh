#!/bin/bash
freewrap gravitate.tcl \
    -o Gravitate.exe \
    -w ~/opt/freewrap/win32/freewrap.exe \
    -i images/icon.ico \
    -9 \
    const.tcl \
    main_window.tcl \
    images/*.png
