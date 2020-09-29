#!/bin/bash
tokei -f -c80 -tTcl -slines
nagelfar.tcl -H -tab 4 *.tcl \
    | grep -v '^[ \t]\+Argument' \
    | grep -v Found.constant.. \
    | grep -v Wrong.number.of.arguments.*to..ini::open \
    | grep -v Unknown.command.*::ini:: \
    | grep -v Unknown.command.*::lambda \
    | grep -v Unknown.command.*_form::show.* \
    | grep -v Unknown.command.*main_window::make_window \
    | grep -v Unknown.command.*struct::set \
    | grep -v Unknown.command.*ui::create_text_tags \
    | grep -v Unknown.command.*ui::font_data \
    | grep -v Unknown.command.*ui::make_fonts \
    | grep -v Unknown.command.*ui::prepare_form \
    | grep -v Unknown.command.*util::commas \
    | grep -v Unknown.command.*util::get_ini_filename \
    | grep -v Unknown.command.*util::open_webpage
git st
