#!/usr/bin/env wish
# Copyright © 2020 Mark Summerfield. All rights reserved.

package require lambda
package require struct::set


namespace eval board {

    variable score 0
    variable game_over true
    variable user_won false
    variable columns $const::COLUMNS_DEFAULT
    variable rows $const::ROWS_DEFAULT
    variable max_colors $const::MAX_COLORS_DEFAULT
    variable delay_ms $const::DELAY_MS_DEFAULT
    variable selected {$const::INVALID $const::INVALID}
    variable tiles {}
    variable drawing false
    # TODO a dict with keys size,color1,color2 and values tk images
    variable cache


    proc color_count {} {
        return [dict size $const::COLORS]
    }


    proc make {} {
        tk::canvas .main.board -background $const::BACKGROUND_COLOR
        make_bindings
    }


    proc make_bindings {} {
        bind . <space> { board::on_space }
        bind . <Up> [::lambda {} { board::on_move_key %K }]
        bind . <Down> [::lambda {} { board::on_move_key %K }]
        bind . <Left> [::lambda {} { board::on_move_key %K }]
        bind . <Right> [::lambda {} { board::on_move_key %K }]
        bind .main.board <1> { board::on_click %x %y}
        bind .main.board <Configure> { board::on_configure %w %h}
    }


    proc new_game {} {
        set board::game_over false
        set board::user_won false
        set board::score 0
        set board::selected {$const::INVALID $const::INVALID}
        set ini [::ini::open [util::get_ini_filename] -encoding utf-8 r]
        try {
            set section $const::BOARD
            set board::columns [::ini::value $ini $section $const::COLUMNS \
                 $const::COLUMNS_DEFAULT]
            set board::rows [::ini::value $ini $section $const::ROWS \
                 $const::ROWS_DEFAULT]
            set board::max_colors [::ini::value $ini $section \
                $const::MAX_COLORS $const::MAX_COLORS_DEFAULT]
            set board::delay_ms [::ini::value $ini $section \
                $const::DELAY_MS $const::DELAY_MS_DEFAULT]
        } finally {
            ::ini::close $ini
        }
        set colors [get_colors $board::max_colors]
        set tiles [list]
        for {set x 0} {$x < $board::columns} {incr x} {
            set row [list]
            for {set y 0} {$y < $board::rows} {incr y} {
                set index [expr {int(rand() * $board::max_colors)}]
                lappend row [lindex $colors $index]
            }
            lappend tiles $row
        }
        announce_score
        draw
    }


    proc get_colors {max_colors} {
        set all_colors [dict keys $const::COLORS]
        set colors {}
        while {[::struct::set size $colors] < $max_colors} {
            set index [expr {int(rand() * [llength $all_colors])}]
            ::struct::set include colors [lindex $all_colors $index]
        }
        return $colors
    }


    proc announce_score {} {
        event generate .main.board <<Modified>> -data $board::score
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
