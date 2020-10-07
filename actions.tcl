#!/usr/bin/env wish
# Copyright © 2020 Mark Summerfield. All rights reserved.


namespace eval actions {

    proc on_new {} {
        board::new_game
    }


    proc on_score {score} {
        .main.status_bar.score_label configure \
            -text "[util::commas $score] •\
                   [util::commas $main_window::high_score]"
    }


    proc on_game_over {score outcome} {
        set msg "Click New…"
        if {$outcome eq $const::USER_WON &&
                $score > $main_window::high_score} {
            set msg [string cat "New Highscore! " $msg]
            set main_window::high_score $score
            set ini [::ini::open [util::get_ini_filename] -encoding utf-8]
            try {
                ::ini::set $ini $const::BOARD $const::HIGH_SCORE $score
            } finally {
                ::ini::close $ini
            }
        }
        main_window::status_message $msg
        on_score $score
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
        regexp {(\d+)x(\d+)[-+](\d+)[-+](\d+)} [wm geometry .] \
            _ width height x y
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
