#!/usr/bin/env wish
# Copyright © 2020 Mark Summerfield. All rights reserved.

package require lambda
package require struct::list
package require struct::set


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
    variable moving false


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
        read_options
        initialize_board
        announce_score
        draw
    }


    proc read_options {} {
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
    }


    proc initialize_board {} {
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
    }


    proc get_colors {} {
        set all_colors [dict keys $const::COLORS]
        set colors [struct::list shuffle $all_colors]
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
        delete_tile $board::selectedx $board::selectedy
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
        delete_tile $x $y
    }


    proc on_configure {width height} {
        if {$width != [.main.board cget -width] ||
                $height != [.main.board cget -height]} {
            draw
        }
    }


    proc draw {{delay_ms 0}} {
        if {$delay_ms > 0} {
            after $delay_ms board::draw
        } else {
            draw_board
            set board::moving false
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
                draw_tile $x $y $width $height $edge $edge2
            }
        }
        if {$board::user_won || $board::game_over} {
            draw_game_over
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
            get_color_pair_ $color $board::game_over light dark
            # TODO segments + gradient filled center rect
            .main.board create rectangle $x1 $y1 $x2 $y2 -fill $light \
                -outline $const::BACKGROUND_COLOR
            if {$x == $board::selectedx && $y == $board::selectedy} {
                draw_focus $x1 $y1 $x2 $y2 $edge
            }
        }
    }


    proc get_color_pair_ {color game_over light_ dark_} {
        upvar 1 $light_ light $dark_ dark
        if {![dict exists $const::COLORS $color]} {
            # Not found ∴ dimmed
            set light $color
            set dark [ui::adjusted_color $color 50] ;# darken by 50%
        } else {
            set light [dict get $const::COLORS $color]
            set dark $color
            if {$game_over} {
                set light [ui::adjusted_color $light 67] ;# darken by 67%
                set dark [ui::adjusted_color $dark 67] ;# darken by 67%
            }
        }
    }


    proc draw_game_over {} {
        set msg [expr {$board::user_won ? "You Won!" : "Game Over"}]
        set color [expr {$board::user_won ? "#0000CC" : "#00CC00"}]
        set x [expr {[winfo width .main.board] / 2}]
        set y [expr {[winfo height .main.board] / 2}]
        .main.board create text [expr {$x + 2}] [expr {$y + 2}] \
            -font big -justify center -fill "#C0C0C0" -text $msg
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


    proc delete_tile {x y} {
        set color [lindex $board::tiles $x $y]
        if {$color eq $const::INVALID_COLOR || ![is_legal $x $y $color]} {
            return
        }
        dim_adjoining $x $y $color
    }


    proc is_legal {x y color} {
        # A legal click is on a colored tile that is adjacent to another
        # tile of the same color.
        if {$x > 0 && [lindex $board::tiles [expr {$x - 1}] $y] eq $color} {
            return true
        }
        if {$x + 1 < $board::columns && 
                [lindex $board::tiles [expr {$x + 1}] $y] eq $color} {
            return true
        }
        if {$y > 0 && [lindex $board::tiles $x [expr {$y - 1}]] eq $color} {
            return true
        }
        if {$y + 1 < $board::rows &&
                [lindex $board::tiles $x [expr {$y + 1}]] eq $color} {
            return true
        }
        return false
    }


    proc dim_adjoining {x y color} {
        set adjoining {}
        populate_adjoining_ $x $y $color adjoining
        foreach point $adjoining {
            lassign $point x y
            set color [ui::adjusted_color [lindex $board::tiles $x $y] 95]
            lset board::tiles $x $y $color
        }
        draw [expr {max(5, $board::delay_ms / 10)}]
        set callback [::lambda {adjoining} \
            {board::delete_adjoining $adjoining} $adjoining]
        after $board::delay_ms $callback
    }


    proc populate_adjoining_ {x y color adjoining_} {
        upvar 1 $adjoining_ adjoining
        if {$x < 0 || $x >= $board::columns || $y < 0 ||
                $y >= $board::rows} {
            return ;# Fallen off an edge
        }
        if {[lindex $board::tiles $x $y] ne $color} {
            return ;# Color doesn't match
        }
        set point [list $x $y]
        if {[::struct::set contains $adjoining $point]} {
            return ;# Already done
        }
        ::struct::set include adjoining $point
        populate_adjoining_ [expr {$x - 1}] $y $color adjoining
        populate_adjoining_ [expr {$x + 1}] $y $color adjoining
        populate_adjoining_ $x [expr {$y - 1}] $color adjoining
        populate_adjoining_ $x [expr {$y + 1}] $color adjoining
    }


    proc delete_adjoining {adjoining} {
        foreach point $adjoining {
            lassign $point x y
            lset board::tiles $x $y $const::INVALID_COLOR
        }
        draw [expr {max(5, $board::delay_ms / 10)}]
        set size [::struct::set size $adjoining]
        set callback [::lambda {size} {board::close_tiles_up $size} $size]
        after $board::delay_ms $callback
    }


    proc close_tiles_up {size} {
        move_tiles
        if {[is_selected_valid] &&
                [lindex $board::tiles $board::selectedx $board::selectedy]
                eq $const::INVALID_COLOR} {
            set board::selectedx [expr {$board::columns / 2}]
            set board::selectedy [expr {$board::rows / 2}]
        }
        draw
        incr board::score [expr {int(round(sqrt(double($board::columns) *
                                     $board::rows)) +
                                     pow($size, $board::max_colors / 2))}]
        announce_score
        check_game_over
    }


    proc move_tiles {} {
        set moves {}
        set moved true
        while {$moved} {
            set moved false
            foreach x [shuffled_numbers $board::columns] {
                foreach y [shuffled_numbers $board::rows] {
                    if {[lindex $board::tiles $x $y] ne 
                            $const::INVALID_COLOR } {
                        if {[move_is_possible_ $x $y moves]} {
                            set moved true
                            break
                        }
                    }
                }
            }
        }
    }


    proc shuffled_numbers {count} {
        set numbers {}
        for {set i 0} {$i < $count} {incr i} {
            lappend numbers $i
        }
        return [struct::list shuffle $numbers]
    }


    proc move_is_possible_ {x y moves_} {
        upvar 1 $moves_ moves
        set empties [get_empty_neighbours $x $y]
        if {![::struct::set empty $empties]} {
            nearest_to_middle_ $x $y $empties move nx ny
            set new_point [list $nx $ny]
            if {[dict exists $moves $new_point]} {
                lassign [dict get $moves $new_point] vx vy
                if {$vx == $x && $vy == $y} {
                    return false ;# avoid endless loop
                }
            }
            if {$move} {
                set color [lindex $board::tiles $x $y]
                lset board::tiles $nx $ny $color
                lset board::tiles $x $y $const::INVALID_COLOR
                set delay [expr {max(1, int(round($board::delay_ms / 7)))}]
                set board::moving true
                draw $delay
                vwait board::moving
                set point [list $x $y]
                dict set moves $point $new_point
                return true
            }
        }
        return false
    }


    proc get_empty_neighbours {x y} {
        set neighbours {}
        foreach {x y} [list [expr {$x - 1}] $y [expr {$x + 1}] $y \
                            $x [expr {$y - 1}] $x [expr {$y + 1}]] {
            if {0 <= $x && $x < $board::columns && 0 <= $y &&
                    $y < $board::rows && [lindex $board::tiles $x $y] eq 
                                         $const::INVALID_COLOR } {
                set point [list $x $y]
                ::struct::set include neighbours $point
            }
        }
        return $neighbours
    }


    proc nearest_to_middle_ {x y empties move_ nx_ ny_} {
        upvar 1 $move_ move $nx_ nx $ny_ ny
        set color [lindex $board::tiles $x $y]
        set midx [expr {$board::columns / 2}]
        set midy [expr {$board::rows / 2}]
        set old_radius [expr {hypot($midx - $x, $midy - $y)}]
        set shortest_radius NaN
        set rx $const::INVALID
        set ry $const::INVALID
        foreach point $empties {
            lassign $point nx ny
            if {[is_square $nx $ny]} {
                set new_radius [expr {hypot($midx - $nx, $midy - $ny)}]
                if {[is_legal $nx $ny $color]} {
                    # Make same colors slightly attract
                    set new_radius [expr {$new_radius - 0.1}]
                }
                if {$rx == $const::INVALID || $ry == $const::INVALID ||
                        $shortest_radius > $new_radius} {
                    set shortest_radius $new_radius
                    set rx $nx
                    set ry $ny
                }
            }
        }
        if {![util::isnan $shortest_radius] &&
                $old_radius > $shortest_radius} {
            set move true
            set nx $rx
            set ny $ry
            return
        }
        set move false
        set nx $x
        set ny $y
    }


    proc is_square {x y} {
        if {$x > 0 && [lindex $board::tiles [expr {$x - 1}] $y] ne
                $const::INVALID_COLOR} {
            return true
        }
        if {$x + 1 < $board::columns &&
                [lindex $board::tiles [expr {$x + 1}] $y] ne
                $const::INVALID_COLOR} {
            return true
        }
        if {$y > 0 && [lindex $board::tiles $x [expr {$y - 1}]] ne
                $const::INVALID_COLOR} {
            return true
        }
        if {$y + 1 < $board::rows &&
                [lindex $board::tiles $x [expr {$y + 1}]] ne
                $const::INVALID_COLOR} {
            return true
        }
        return false
    }


    proc check_game_over {} {
        set can_move [check_tiles]
        if {$board::user_won} {
            announce_game_over $const::USER_WON
        } elseif {!$can_move} {
            announce_game_over $const::GAME_OVER}
    }


    proc check_tiles {} {
        set count_for_color {}
        set board::user_won true
        set can_move false
        for {set x 0} {$x < $board::columns} {incr x} {
            for {set y 0} {$y < $board::rows} {incr y} {
                set color [lindex $board::tiles $x $y]
                if {$color ne $const::INVALID_COLOR} {
                    if {![dict exists $count_for_color $color]} {
                        dict set count_for_color $color 1
                    } else {
                        dict incr count_for_color $color
                    }
                    set board::user_won false
                    if {[is_legal $x $y $color]} {
                        set can_move true
                    }
                }
            }
        }
        dict for {color count} $count_for_color {
            if {$count == 1} {
                set can_move false
                break
            }
        }
        if {$board::user_won || !$can_move} {
            set board::game_over true
            draw
        }
        return $can_move
    }
}
