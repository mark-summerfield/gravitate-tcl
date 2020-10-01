#!/usr/bin/env wish
# Copyright © 2020 Mark Summerfield. All rights reserved.

package require lambda


namespace eval board {

    variable score 0
    variable game_over true
    variable user_won false
    variable columns $const::COLUMNS_DEFAULT
    variable rows $const::ROWS_DEFAULT
    variable max_colors $const::MAX_COLORS_DEFAULT
    variable delay_ms $const::DELAY_MS_DEFAULT
    variable selected {-1 -1}
    variable tiles {}
    variable drawing false


    proc color_count {} {
        return 7 ;# TODO
    }


    proc make {} {
        tk::canvas .main.board -background $const::BACKGROUND_COLOR
        make_bindings
    }


    proc make_bindings {} {
        bind . <space> { board::on_space }
        bind . <Up> [::lambda {} { board::on_move_key %k }]
        bind . <Down> [::lambda {} { board::on_move_key %k }]
        bind . <Left> [::lambda {} { board::on_move_key %k }]
        bind . <Right> [::lambda {} { board::on_move_key %k }]
        bind .main.board <1> { board::on_click %x %y}
        bind .main.board <Configure> { board::on_configure %w %h}
    }


    proc on_space {} {
        puts "on_space"
    }


    proc on_move_key {key} {
        puts "on_move_key $key"
    }


    proc on_click {x y} {
        puts "on_click ($x, $y)"
    }


    proc on_configure {width height} {
        if {$width != [.main.board cget -width] || \
                $height != [.main.board cget -height]} {
            draw
        }
    }


    proc draw {} {
        puts "draw"
    }
}
