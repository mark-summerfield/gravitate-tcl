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
        board.tcl
        util.tcl
        ui.tcl
    } {
    source -encoding utf-8 $::APP_PATH/$filename
}


proc main {} {
    option add *insertOffTime 0
    tk appname Gravitate
    wm withdraw .
    wm title . [tk appname]
    wm iconname . [tk appname]
    wm iconphoto . -default [image create photo -file $::IMG_PATH/icon.png]
    wm minsize . 260 300
    wm protocol . WM_DELETE_WINDOW actions::on_quit
    ui::make_fonts
    option add *font default
    main_window::make_window
    wm deiconify .
    raise .
    focus .
}


main
