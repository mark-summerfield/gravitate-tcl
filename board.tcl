#!/usr/bin/env wish
# Copyright © 2020 Mark Summerfield. All rights reserved.

package require lambda
package require struct::list


namespace eval board {

    variable score 0
    variable game_over true
    variable user_won false
    variable columns $const::COLUMNS_DEFAULT
    variable rows $const::ROWS_DEFAULT
    variable max_colors $const::MAX_COLORS_DEFAULT
    variable delay_ms $const::DELAY_MS_DEFAULT
    variable selectedx $const::INVALID
    variable selectedy $const::INVALID
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
        set board::selectedx $const::INVALID
        set board::selectedy $const::INVALID
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
        set colors [get_colors]
        set board::tiles {}
        for {set x 0} {$x < $board::columns} {incr x} {
            set row {}
            for {set y 0} {$y < $board::rows} {incr y} {
                set index [expr {int(rand() * $board::max_colors)}]
                lappend row [lindex $colors $index]
            }
            lappend board::tiles $row
        }
        announce_score
        draw
    }


    proc get_colors {} {
        set all_colors [dict keys $const::COLORS]
        set colors [struct::list shuffle [lrange $all_colors 0 end]]
        return [lrange $colors 0 [expr {$board::max_colors - 1}]]
    }


    proc announce_score {} {
        event generate .main.board <<Score>> -data $board::score
    }


    proc announce_game_over {outcome} {
        # outcome must be $const::USER_WON or $const::GAME_OVER
        event generate .main.board <<GameOver>> \
            -data [list $board::score $outcome]
    }


    proc on_space {} {
        if {$board::game_over || $board::drawing || ![is_selected_valid]} {
            return
        }
        board::delete_tile $board::selectedx $board::selectedy
    }


    proc on_move_key {key} {
        if {$board::game_over || $board::drawing} {
            return
        }
        if {![is_selected_valid]} {
            set board::selectedx [expr {$board::columns / 2}]
            set board::selectedy [expr {$board::rows / 2}]
        } else {
            set x $board::selectedx
            set y $board::selectedy
            if {$key eq "Left"} {
                incr x -1
            } elseif {$key eq "Right"} {
                incr x
            } elseif {$key eq "Up"} {
                incr y -1
            } elseif {$key eq "Down"} {
                incr y
            }
            if {0 <= $x && $x <= $board::columns &&
                    0 <= $y && $y <= $board::rows &&
                    [lindex $board::tiles $x $y] ne $const::INVALID_COLOR} {
                set board::selectedx $x
                set board::selectedy $y
            }
        }
        draw
    }


    proc on_click {x y} {
        if {$board::game_over || $board::drawing} {
            return
        }
        tile_size_ width height
        set x [expr {int($x / round($width))}]
        set y [expr {int($y / round($height))}]
        if {[is_selected_valid]} {
            set board::selectedx $const::INVALID
            set board::selectedy $const::INVALID
            draw
        }
        board::delete_tile $x $y
    }


    proc on_configure {width height} {
        if {$width != [.main.board cget -width] || \
                $height != [.main.board cget -height]} {
            draw
        }
    }


    proc draw {{delay_ms 0} {force false}} {
        if {$delay_ms > 0} {
            after $delay_ms draw
            return
        }
        draw_board
        # do I need force or update at all?
        if {$force} {
            update idletasks
        } else {
            update
        }
    }


    proc tile_size_ {width_ height_} {
        upvar 1 $width_ width $height_ height
        set width [expr {[winfo width .main.board] / \
                         double($board::columns)}]
        set height [expr {[winfo height .main.board] / \
                          double($board::rows)}]
    }

    
    proc is_selected_valid {} {
        return [expr {$board::selectedx != $const::INVALID &&
                      $board::selectedy != $const::INVALID}]
    }


    proc delete_tile {x y} {
        puts "delete_tile ($x,$y)" 
    }


    proc draw_board {} {
        if {![llength $board::tiles] || $board::drawing} {
            return
        }
        set $board::drawing true
        .main.board delete all
        tile_size_ width height
        set edge [expr {min($width, $height) / 9.0}]
        set edge2 [expr {$edge * 2.0}]
        for {set x 0} {$x < $board::columns} {incr x} {
            for {set y 0} {$y < $board::rows} {incr y} {
                board::draw_tile $x $y $width $height $edge $edge2
            }
        }
        if {$board::user_won || $board::game_over} {
            board::draw_game_over
        }
        set $board::drawing false
    }


    proc draw_tile {x y width height edge edge2} {
        set x1 [expr {$x * $width}]
        set y1 [expr {$y * $height}]
        set x2 [expr {$x1 + $width}]
        set y2 [expr {$y1 + $height}]
        set color [lindex $board::tiles $x $y]
        if {$color eq $const::INVALID_COLOR} {
            .main.board create rectangle $x1 $y1 $x2 $y2 \
                -fill $const::BACKGROUND_COLOR -outline white
        } else {
            board::get_color_pair_ $color $board::game_over light dark
            # TODO segments + gradient filled center rect
            .main.board create rectangle $x1 $y1 $x2 $y2 -fill $light \
                -outline $const::BACKGROUND_COLOR
            if {$x == $board::selectedx && $y == $board::selectedy} {
                board::draw_focus $x1 $y1 $x2 $y2 $edge
            }
        }
    }


    proc get_color_pair_ {color game_over light_ dark_} {
        upvar 1 $light_ light $dark_ dark
        if {![dict exists $const::COLORS $color]} {
            # Not found ∴ dimmed
            set light $color
            set dark $color ;# TODO darken
        } else {
            set light [dict get $const::COLORS $color]
            set dark $color
            if {$game_over} {
                # TODO make dim
            }
        }
    }


    proc draw_game_over {} {
        set msg [expr {$board::user_won ? "You Won!" : "Game Over"}]
        set color [expr {$board::user_won ? "#0000BB" : "#009900"}]
        set x [expr {[winfo width .main.board] / 2}]
        set y [expr {[winfo height .main.board] / 2}]
        .main.board create text $x $y -font big -justify center \
            -fill $color -text $msg
    }


    proc draw_focus {x1 y1 x2 y2 edge} {
        set edge [expr {$edge * 4 / 3.0 }]
        set x1 [expr {$x1 + $edge}]
        set y1 [expr {$y1 + $edge}]
        set x2 [expr {$x2 - $edge}]
        set y2 [expr {$y2 - $edge}]
        .main.board create rectangle $x1 $y1 $x2 $y2 -dash -
    }
}
