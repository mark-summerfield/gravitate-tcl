#!/bin/bash
tokei -f -c80 -tTcl -slines
nagelfar.tcl *.tcl \
    | grep -v Found.constant.. \
    | grep -v Unknown.command.*struct::set \
    | grep -v Unknown.command.*::lambda \
    | grep -v Unknown.command.*::ini:: \
    | grep -v Wrong.number.of.arguments.*to..ini::open \
    | grep -v Unknown.command.*main_window::make_window \
    | grep -v Unknown.command.*_form::show.* \
    | grep -v Unknown.command.*util::commas \
    | grep -v Unknown.command.*util::get_ini_filename \
    | grep -v Unknown.command.*util::prepare_dialog
git st
