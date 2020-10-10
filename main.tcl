#!/usr/bin/env wish
# Copyright © 2020 Mark Summerfield. All rights reserved.


namespace eval main {

    proc main {} {
        option add *insertOffTime 0
        tk appname Gravitate
        wm withdraw .
        wm title . [tk appname]
        wm iconname . [tk appname]
        wm iconphoto . -default [image create photo \
                                 -file $::IMG_PATH/icon.png]
        wm minsize . 260 300
        wm protocol . WM_DELETE_WINDOW actions::on_quit
        ui::make_fonts
        option add *font default
        main_window::make_window
        wm deiconify .
        raise .
        focus .
    }
}
