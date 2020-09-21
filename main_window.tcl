#!/usr/bin/env wish
# Copyright © 2020 Mark Summerfield. All rights reserved.


namespace eval main_window {

    variable score 0
    variable high_score 0

    proc make_window {} {
        ttk::frame .main
        make_bindings
    }


    proc make_bindings {} {
        bind . <Control-q> { main_window::on_quit }
        bind . <Escape> { main_window::on_quit }
    }


    proc on_quit {} {
        puts on_quit
        exit
    }

}
