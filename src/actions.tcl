#!/usr/bin/env wish
# Copyright © 2020 Mark Summerfield. All rights reserved.

namespace eval actions {}


proc actions::on_new {} {
    board::new_game
    focus .main.board
}


proc actions::on_score {score} {
    .main.status_bar.score_label configure \
        -text "[util::commas $score] • [util::commas $board::high_score]"
}


proc actions::on_game_over {score} {
    main_window::status_message "Click New…"
    on_score $score
}


proc actions::on_options {} {
    if {[options_form::show_modal]} {
        main_window::status_message "Updated options. Click New…"
    }
    focus .main.board
}


proc actions::on_about {} {
    about_form::show_modal
    focus .main.board
}


proc actions::on_help {} {
    help_form::show
}


proc actions::on_quit {} {
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
