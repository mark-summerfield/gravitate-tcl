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
    set section $app::WINDOW
    set ini [::ini::open [util::get_ini_filename] -encoding utf-8]
    try {
        set scale [::ini::value $ini $section $app::SCALE 1.0]
        ::ini::set $ini $section $app::SCALE $scale
        ::ini::set $ini $section $app::WINDOW_WIDTH \
            [expr {int($width / $scale)}]
        ::ini::set $ini $section $app::WINDOW_HEIGHT \
            [expr {int($height / $scale)}]
        ::ini::set $ini $section $app::WINDOW_X \
            [expr {int($x / $scale)}]
        ::ini::set $ini $section $app::WINDOW_Y \
            [expr {int($y / $scale)}]
        ::ini::commit $ini
    } finally {
        ::ini::close $ini
    }
    exit
}
