#!/usr/bin/env wish
# Copyright © 2020 Mark Summerfield. All rights reserved.

package require inifile


namespace eval util {

    proc commas {x} {
        regsub -all \\d(?=(\\d{3})+([regexp -inline {\.\d*$} $x]$)) $x {\0,}
    }

    proc get_ini_filename {} {
        if {$::tcl_platform(platform) == "windows"} {
            set names {~/gravitate.ini $::APP_PATH/gravitate.ini}
            set index 0
        } else {
            set names {~/.config/gravitate.ini ~/.gravitate.ini \
                       $::APP_PATH/gravitate.ini}
            set index [expr {[file isdirectory ~/.config] ? 0 : 1}]
        }
        foreach name $names {
            set name [file normalize $name]
            if {[file exists $name]} {
                return $name
            }
        }
        set name [lindex $names $index]
        make_default_ini $name
        return $name
    }


    proc make_default_ini {name} {
        set ini [::ini::open $name -encoding "utf-8" w]
        try {
            set section $const::BOARD
            ::ini::set $ini $section $const::COLUMNS $const::COLUMNS_DEFAULT
            ::ini::set $ini $section $const::ROWS $const::ROWS_DEFAULT
            ::ini::set $ini $section $const::MAX_COLORS \
                $const::MAX_COLORS_DEFAULT
            ::ini::set $ini $section $const::DELAY_MS \
                $const::DELAY_MS_DEFAULT
            ::ini::set $ini $section $const::HIGH_SCORE \
                $const::HIGH_SCORE_DEFAULT
            set section $const::WINDOW
            set invalid $const::WINDOW_INVALID
            ::ini::set $ini $section $const::WINDOW_HEIGHT $invalid
            ::ini::set $ini $section $const::WINDOW_WIDTH $invalid
            ::ini::set $ini $section $const::WINDOW_X $invalid
            ::ini::set $ini $section $const::WINDOW_Y $invalid
            ::ini::commit $ini
        } finally {
            ::ini::close $ini
        }
    }

    proc prepare_dialog {window title icon on_close {modal true}} {
        wm withdraw $window
        if {$modal} {
            wm transient $window .
        }
        set x [expr {[winfo x [winfo parent $window]] + 20}]
        set y [expr {[winfo y [winfo parent $window]] + 40}]
        wm geometry $window "+$x+$y"
        wm title $window $title
        wm iconphoto $window [image create photo -file $icon]
        wm protocol $window WM_DELETE_WINDOW $on_close
        raise $window
        focus $window
        if {$modal} {
            grab $window
        }
        wm deiconify $window
    }
}
