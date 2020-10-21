#!/usr/bin/env wish
# Copyright © 2020 Mark Summerfield. All rights reserved.

package require inifile

namespace eval util {}


proc util::commas {x} {
    regsub -all \\d(?=(\\d{3})+([regexp -inline {\.\d*$} $x]$)) $x {\0,}
}


proc util::get_ini_filename {} {
    if {[tk windowingsystem] eq "win32"} {
        set names {~/gravitate.ini $::APP_PATH/gravitate.ini}
        set index 0
    } else {
        set names {~/.config/gravitate.ini ~/.gravitate.ini
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


proc util::make_default_ini {name} {
    set ini [::ini::open $name -encoding utf-8 w]
    try {
        set section $app::BOARD
        ::ini::set $ini $section $app::COLUMNS $app::COLUMNS_DEFAULT
        ::ini::set $ini $section $app::ROWS $app::ROWS_DEFAULT
        ::ini::set $ini $section $app::MAX_COLORS $app::MAX_COLORS_DEFAULT
        ::ini::set $ini $section $app::DELAY_MS $app::DELAY_MS_DEFAULT
        ::ini::set $ini $section $app::HIGH_SCORE $app::HIGH_SCORE_DEFAULT
        set section $app::WINDOW
        set invalid $app::INVALID
        ::ini::set $ini $section $app::WINDOW_HEIGHT $invalid
        ::ini::set $ini $section $app::WINDOW_WIDTH $invalid
        ::ini::set $ini $section $app::WINDOW_X $invalid
        ::ini::set $ini $section $app::WINDOW_Y $invalid
        ::ini::set $ini $section $app::FONTSIZE \
            [dict get [font actual TkDefaultFont] -size]
        ::ini::commit $ini
    } finally {
        ::ini::close $ini
    }
}


proc util::open_webpage {url} {
    if {[tk windowingsystem] eq "win32"} {
        set cmd [list {*}[auto_execok start] {}]
    } else {
        set cmd [auto_execok xdg-open]
    }
    try {
        exec {*}$cmd $url &
    } trap CHILDSTATUS {err} {
        puts "failed to open $url: $err"
    }
}


proc util::isnan {x} {
    return [expr {![string is double $x] || $x != $x}]
}
