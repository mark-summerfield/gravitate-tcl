#!/usr/bin/env wish
# Copyright © 2020 Mark Summerfield. All rights reserved.


namespace eval actions {

    proc on_new {} {
        puts "on_new" ;# TODO
    }


    proc on_quit {} {
        puts on_quit ;# TODO save win size/pos
        exit
    }

}
