#!/usr/bin/env wish
# Copyright © 2020 Mark Summerfield. All rights reserved.


source -encoding "utf-8" const.tcl


namespace eval main_window {

    variable score 0
    variable high_score 0

    proc make_window {} {
        ttk::frame .main
        make_widgets
        make_layout
        make_bindings
        # TODO load win size/pos & high score
    }


    proc make_widgets {} {
        ttk::frame .main.toolbar
        tk::canvas .main.canvas
        ttk::label .main.status_label
        # TODO
        puts make_widgets
    }


    proc make_layout {} {
        grid .main.toolbar -sticky ew
        grid .main.canvas -sticky nsew
        grid .main.status_label -sticky ew
        grid columnconfigure . 0 -weight 1
        grid rowconfigure . 1 -weight 1
        puts make_layout ;# TODO
    }


    proc make_bindings {} {
        bind . <Control-q> { main_window::on_quit }
        bind . <Escape> { main_window::on_quit }
    }


    proc on_quit {} {
        puts on_quit ;# TODO save win size/pos
        exit
    }

}
