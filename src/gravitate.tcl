#!/usr/bin/env wish
# Copyright © 2020 Mark Summerfield. All rights reserved.

if {[llength $argv] > 0 && [tk windowingsystem] eq "win32" &&
        [lindex $argv 0] in {-D --debug} } {
    console show 
}
if {[info exists ::freewrap::runMode] &&
        $::freewrap::runMode eq "wrappedExec"} {
    set ::APP_PATH /zvfs/home/mark/app/gravitate/tcl/src
} else {
    set name [info script]
    if {[file type $name] == "link"} {
        set name [file readlink $name]
    }
    set ::APP_PATH [file normalize [file dirname $name]]
}
set ::IMG_PATH "$::APP_PATH/images"

foreach filename {
        const.tcl
        app.tcl
        main_window.tcl
        about_form.tcl
        help_form.tcl
        options_form.tcl
        actions.tcl
        board.tcl
        board_delete_tile.tcl
        util.tcl
        ui.tcl
    } {
    source -encoding utf-8 $::APP_PATH/$filename
}


app::main
