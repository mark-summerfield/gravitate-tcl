#!/bin/bash
tokei -f -c80 -tTcl -slines
nagelfar.tcl -H -tab 4 *.tcl \
    | grep -v '^[ \t]\+Argument' \
    | grep -v Found.constant.. \
    | grep -v Wrong.number.of.arguments.*to..ini::open \
    | grep -v board.tcl.*Unknown.variable.*width \
    | grep -v board.tcl.*Unknown.variable.*height \
    | grep -v Unknown.command.*::ini:: \
    | grep -v Unknown.command.*::lambda \
    | grep -v Unknown.command.*_form::show.* \
    | grep -v Unknown.command.*board::* \
    | grep -v Unknown.command.*main_window::* \
    | grep -v Unknown.command.*struct::set \
    | grep -v Unknown.command.*tooltip::tooltip \
    | grep -v Unknown.command.*ttk::spinbox \
    | grep -v Unknown.command.*ui::* \
    | grep -v Unknown.command.*util::* \
    | grep -v Unknown.variable.*const::.*
git st
