#!/usr/bin/env wish
# Copyright © 2020 Mark Summerfield. All rights reserved.


namespace eval actions {

    proc on_new {} {
        board::new_game
    }


    proc on_options {} {
        if {[options_form::show_modal]} {
            main_window::status_message "Updated options. Click New…"
        }
    }


    proc on_about {} {
        about_form::show_modal
    }


    proc on_help {} {
        help_form::show
    }


    proc on_quit {} {
        set geom [wm geometry .]
        regexp {(\d+)x(\d+)[-+](\d+)[-+](\d+)} $geom _ width height x y
        set section $const::WINDOW
        set ini [::ini::open [util::get_ini_filename] -encoding utf-8]
        try {
            ::ini::set $ini $section $const::WINDOW_WIDTH $width
            ::ini::set $ini $section $const::WINDOW_HEIGHT $height
            ::ini::set $ini $section $const::WINDOW_X $x
            ::ini::set $ini $section $const::WINDOW_Y $y
            ::ini::commit $ini
        } finally {
            ::ini::close $ini
        }
        exit
    }
}
