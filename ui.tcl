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
        if {$modal} {
            grab $window
        }
        wm deiconify $window
        raise $window
        focus $window
    }


    proc create_text_tags {widget} {
        $widget tag configure center -justify center
        $widget tag configure title -foreground navy -font h1
        $widget tag configure navy -foreground navy
        $widget tag configure green -foreground darkgreen
        $widget tag configure italic -font italic
        $widget tag configure url -underline true -underlinefg darkgreen
    }


    proc font_data {{read_ini true}} {
        set size [expr {$::tcl_platform(platform) == "unix" ? 12 : 10}]
        set family Helvetica
        set font_data [font actual TkDefaultFont]
        if {![dict exists $font_data -family]} {
            dict set font_data -family $family
        }
        if {![dict exists $font_data -size]} {
            dict set font_data -size $size
        }
        if {$read_ini} {
            set ini [::ini::open [util::get_ini_filename] \
                     -encoding "utf-8" r]
            try {
                set section $const::WINDOW
                dict set font_data -family [::ini::value $ini $section \
                                            $const::FONTFAMILY $family]
                dict set font_data -size [::ini::value $ini $section \
                                          $const::FONTSIZE $size]
            } finally {
                ::ini::close $ini
            }
        }
        return $font_data
    }
}
