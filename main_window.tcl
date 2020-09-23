#!/usr/bin/env wish
# Copyright © 2020 Mark Summerfield. All rights reserved.


namespace eval main_window {

    variable score 0
    variable high_score 0
    variable status_timer_id {}

    proc make_window {} {
        make_widgets
        make_layout
        make_bindings
        # TODO load win size/pos & high score
    }


    proc make_widgets {} {
        ttk::frame .main
        ttk::frame .main.toolbar
        ttk::button .main.toolbar.new -text New -style Toolbutton \
            -image [image create photo icon -file $::IMG_PATH/new.png] \
            -command actions::on_new
        # TODO
        tk::canvas .main.board -background $const::BACKGROUND_COLOR
        ttk::frame .main.status_bar
        ttk::label .main.status_bar.label
        ttk::label .main.status_bar.score_label -text "0 • 0"
        status_message "Click a tile to play…"
    }


    proc make_layout {} {
        grid .main -sticky nsew
        grid .main.toolbar -sticky ew
        grid .main.toolbar.new -sticky w
        grid .main.board -sticky nsew -pady $const::PAD
        grid .main.status_bar -sticky ew
        grid .main.status_bar.label -row 0 -column 0 -sticky we
        grid .main.status_bar.score_label -row 0 -column 1 -sticky e
        grid columnconfigure .main.status_bar 0 -weight 1
        grid columnconfigure .main 0 -weight 1
        grid rowconfigure .main 1 -weight 1
        grid columnconfigure . 0 -weight 1
        grid rowconfigure . 0 -weight 1
    }


    proc make_bindings {} {
        bind . <Control-q> { actions::on_quit }
        bind . <Escape> { actions::on_quit }
        # TODO complete
    }


    proc status_message {msg {ms 5000}} {
        after cancel $main_window::status_timer_id
        .main.status_bar.label configure -text $msg
        if {$ms > 0} {
            set main_window::status_timer_id \
                [after $ms main_window::clear_status_message]
        }
    }

    
    proc clear_status_message {} {
        .main.status_bar.label configure -text ""
    }
}
