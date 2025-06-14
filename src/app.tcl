#!/usr/bin/env wish
# Copyright © 2020 Mark Summerfield. All rights reserved.


namespace eval app {}


proc app::main {} {
    wishinit
    tk appname Gravitate
    wm withdraw .
    wm title . [tk appname]
    wm iconname . [tk appname]
    wm iconphoto . -default [image create photo -file $::IMG_PATH/icon.png]
    wm minsize . 260 300
    wm protocol . WM_DELETE_WINDOW actions::on_quit
    ui::make_fonts
    option add *font default
    ttk::style configure TButton -font default
    main_window::show
    wm deiconify .
    raise .
    focus .
}

proc wishinit {} {
    catch {
        set fh [open [file join [file home] .wishinit.tcl]]
        set raw [read $fh]
        close $fh
        eval $raw
    }
    set LINEHEIGHT [expr {[font metrics font -linespace] * 1.0125}]
    ttk::style configure Treeview -rowheight $LINEHEIGHT
    ttk::style configure TCheckbutton -indicatorsize \
        [expr {$LINEHEIGHT * 0.75}]
    set ::ICON_SIZE [expr {max(24, round(20 * [tk scaling]))}]
}
