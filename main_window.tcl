#!/usr/bin/env wish
# Copyright © 2020 Mark Summerfield. All rights reserved.


namespace eval main_window {

    variable score 0
    variable high_score 0

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
            -command main_window::on_new
        tk::canvas .main.canvas -background $const::BACKGROUND_COLOR
        ttk::label .main.status_label -text $::APP_PATH
        # TODO configure
    }


    proc make_layout {} {
        grid .main -sticky nsew
        grid .main.toolbar -sticky ew
        grid .main.toolbar.new -sticky w
        grid .main.canvas -sticky nsew -pady $const::PAD
        grid .main.status_label -sticky ew
        grid columnconfigure .main 0 -weight 1
        grid rowconfigure .main 1 -weight 1
        grid columnconfigure . 0 -weight 1
        grid rowconfigure . 0 -weight 1
    }


    proc make_bindings {} {
        bind . <Control-q> { main_window::on_quit }
        bind . <Escape> { main_window::on_quit }
        # TODO complete
    }


    proc on_new {} {
        puts "on_new" ;# TODO
    }


    proc on_quit {} {
        puts on_quit ;# TODO save win size/pos
        exit
    }

}
