#!/usr/bin/env wish
# Copyright © 2020 Mark Summerfield. All rights reserved.

package require lambda
package require struct::list
package require struct::set


namespace eval board {

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
            set color [ui::adjusted_color [lindex $board::tiles $x $y] 98]
            lset board::tiles $x $y $color
        }
        draw [expr {max(5, $board::delay_ms / $board::DELAY_SCALER)}]
        set do_delete_adjoining [::lambda {adjoining} \
            {board::delete_adjoining $adjoining} $adjoining]
        after $board::delay_ms $do_delete_adjoining
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
        draw [expr {max(5, $board::delay_ms / $board::DELAY_SCALER)}]
        set size [::struct::set size $adjoining]
        set do_close_tiles_up [::lambda {size} \
            {board::close_tiles_up $size} $size]
        after $board::delay_ms $do_close_tiles_up
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
        incr board::score [
            expr {int(round(sqrt(double($board::columns) * $board::rows)) +
                  pow($size, $board::max_colors / 2))}]
        announce $const::SCORE_EVENT
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
                    return false ;# Avoid endless loop
                }
            }
            if {$move} {
                set color [lindex $board::tiles $x $y]
                lset board::tiles $nx $ny $color
                lset board::tiles $x $y $const::INVALID_COLOR
                set delay [expr {max(1, int(round($board::delay_ms /
                                            $board::DELAY_SCALER)))}]
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
            if {$board::score > $board::high_score} {
                set board::high_score $board::score
                set ini [::ini::open [util::get_ini_filename] \
                    -encoding utf-8]
                try {
                    ::ini::set $ini $const::BOARD \
                        $const::HIGH_SCORE $board::score
                    ::ini::set $ini $const::BOARD \
                        $const::HIGH_SCORE_COMPAT $board::score
                    ::ini::commit $ini
                } finally {
                    ::ini::close $ini
                }
            }
            announce $const::GAME_OVER_EVENT
        } elseif {!$can_move} {
            announce $const::GAME_OVER_EVENT
        }
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
