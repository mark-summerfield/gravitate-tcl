#!/usr/bin/env wish
# Copyright © 2020 Mark Summerfield. All rights reserved.

package require inifile


namespace eval ui {

    proc prepare_form {window title on_close {modal true}} {
        wm withdraw $window
        if {$modal} {
            wm transient $window .
        }
        set x [expr {[winfo x [winfo parent $window]] + 20}]
        set y [expr {[winfo y [winfo parent $window]] + 40}]
        wm geometry $window "+$x+$y"
        wm title $window $title
        wm protocol $window WM_DELETE_WINDOW $on_close
        raise $window
        focus $window
        if {$modal} {
            grab $window
        }
        wm deiconify $window
    }


    proc create_text_tags {widget} {
        $widget tag configure body -justify center
        $widget tag configure title -foreground navy -font h1
        $widget tag configure navy -foreground navy
        $widget tag configure green -foreground darkgreen
        $widget tag configure italic -font italic
        $widget tag configure url -underline true -underlinefg darkgreen
    }
}
