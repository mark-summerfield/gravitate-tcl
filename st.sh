#!/bin/bash
tokei -f -c80 -tTcl -slines
nagelfar.tcl *.tcl \
    | grep -v Found.constant.. \
    | grep -v Unknown.command.*struct::set \
    | grep -v Unknown.command.*::lambda \
    | grep -v Unknown.command.*::ini:: \
    | grep -v Wrong.number.of.arguments.*to..ini::open \
    | grep -v Unknown.command.*main_window::make_window \
    | grep -v Unknown.command.*util::commify \
    | grep -v Unknown.command.*util::get_ini_filename
git st
