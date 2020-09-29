#!/usr/bin/env wish
# Copyright © 2020 Mark Summerfield. All rights reserved.

if {[info exists ::freewrap::runMode] &&
        $::freewrap::runMode eq "wrappedExec"} {
    set ::APP_PATH /zvfs/home/mark/app/gravitate/tcl
} else {
    set ::APP_PATH [file normalize [file dirname [info script]]]
}
set ::IMG_PATH "$::APP_PATH/images"

foreach filename {
        const.tcl
        main_window.tcl
        about_form.tcl
        help_form.tcl
        options_form.tcl
        actions.tcl
        util.tcl
        ui.tcl
    } {
    source -encoding "utf-8" $::APP_PATH/$filename
}


proc main {} {
    wm withdraw .
    wm title . $const::APPNAME
    wm iconname . $const::APPNAME
    wm iconphoto . -default [image create photo -file $::IMG_PATH/icon.png]
    wm minsize . 260 300
    wm protocol . WM_DELETE_WINDOW actions::on_quit
    main_window::make_window
    wm deiconify .
    raise .
    focus .
}


main
