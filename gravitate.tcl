#!/usr/bin/env wish
# Copyright © 2020 Mark Summerfield. All rights reserved.

if {[info exists ::freewrap::runMode] &&
        $::freewrap::runMode == "wrappedExec"} {
    set ::APP_PATH /zvfs/home/mark/app/gravitate/tcl
} else {
    set ::APP_PATH [file normalize [file dirname [info script]]]
}

foreach filename {const.tcl
                  main_window.tcl
                  actions.tcl} {
    source -encoding "utf-8" $::APP_PATH/$filename
}


proc main {} {
    wm withdraw .
    wm title . $const::APPNAME
    image create photo icon -file $::APP_PATH/images/icon.png
    wm iconphoto . icon
    wm minsize . 260 300
    wm protocol . WM_DELETE_WINDOW actions::on_quit
    main_window::make_window
    wm deiconify .
}


main
