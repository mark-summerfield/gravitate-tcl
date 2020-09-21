#!/usr/bin/env wish
# Copyright © 2020 Mark Summerfield. All rights reserved.


proc main {} {
    wm withdraw .
    wm title . Gravitate
    image create photo icon -file images/gravitate.png
    wm iconphoto . icon
    wm protocol . WM_DELETE_WINDOW main_window::on_quit
    main_window::make_window
    wm deiconify .
}


foreach filename {main_window.tcl} {
    source $filename
}


main
