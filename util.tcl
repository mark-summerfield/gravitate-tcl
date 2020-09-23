#!/usr/bin/env wish
# Copyright © 2020 Mark Summerfield. All rights reserved.


namespace eval util {

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
        # TODO none exist so create it with defaults
        return $name
    }

}
