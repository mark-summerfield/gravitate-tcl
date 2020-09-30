#!/usr/bin/env wish
# Copyright © 2020 Mark Summerfield. All rights reserved.

package require inifile


namespace eval util {

    proc commas {x} {
        regsub -all \\d(?=(\\d{3})+([regexp -inline {\.\d*$} $x]$)) $x {\0,}
    }

    proc get_ini_filename {} {
        if {[tk windowingsystem] eq "win32"} {
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
        set ini [::ini::open $name -encoding utf-8 w]
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
            ::ini::set $ini $section $const::SCALING [tk scaling]
            ::ini::commit $ini
        } finally {
            ::ini::close $ini
        }
    }


    proc open_webpage {url} {
        if {[tk windowingsystem] eq "win32"} {
            set cmd [list {*}[auto_execok start] {}]
        } else {
            set cmd [auto_execok xdg-open]
        }
        try {
            exec {*}$cmd $url &
        } trap CHILDSTATUS {err opts} {
            puts "failed to open $url: $err"
        }
    }
}
