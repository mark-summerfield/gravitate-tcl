#!/bin/bash
tokei -f -c80 -tTcl -slines
nagelfar.tcl *.tcl \
    | grep -v Found.constant.. \
    | grep -v Unknown.command.*struct::set \
    | grep -v Unknown.command.*main_window::make_window
git st
