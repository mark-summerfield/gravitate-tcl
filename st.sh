#!/bin/bash
tokei -f -c80 -tTcl -slines
nagelfar.tcl *.tcl \
    | grep -v Found.constant.. \
    | grep -v Unknown.command.*struct::set
git st
