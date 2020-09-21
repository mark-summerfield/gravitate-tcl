#!/usr/bin/env wish
# Copyright © 2020 Mark Summerfield. All rights reserved.


foreach filename {const.tcl main_window.tcl} {
    source -encoding "utf-8" $filename
}


proc main {} {
    wm withdraw .
    wm title . $const::APPNAME
    image create photo icon -file images/gravitate.png
    wm iconphoto . icon
    wm minsize . 260 300
    wm protocol . WM_DELETE_WINDOW main_window::on_quit
    main_window::make_window
    wm deiconify .
}


main
