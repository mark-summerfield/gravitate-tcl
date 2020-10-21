#!/usr/bin/env wish
# Copyright © 2020 Mark Summerfield. All rights reserved.

package require lambda
package require struct::list

namespace eval board {}


variable board::high_score $app::HIGH_SCORE_DEFAULT
variable board::score 0
variable board::game_over true
variable board::user_won false
variable board::columns $app::COLUMNS_DEFAULT
variable board::rows $app::ROWS_DEFAULT
variable board::max_colors $app::MAX_COLORS_DEFAULT
variable board::delay_ms $app::DELAY_MS_DEFAULT
variable board::selectedx $app::INVALID
variable board::selectedy $app::INVALID
variable board::tiles {}
variable board::drawing false
variable board::moving false
variable board::DELAY_SCALER 5


proc board::make {} {
    tk::canvas .main.board -background $app::BACKGROUND_COLOR
    make_bindings
}


proc board::make_bindings {} {
    bind . <space> { board::on_space }
    bind . <Up> [::lambda {} { board::on_move_key %K }]
    bind . <Down> [::lambda {} { board::on_move_key %K }]
    bind . <Left> [::lambda {} { board::on_move_key %K }]
    bind . <Right> [::lambda {} { board::on_move_key %K }]
    bind .main.board <1> { board::on_click %x %y}
    bind .main.board <Configure> { board::on_configure %w %h}
}


proc board::new_game {} {
    set board::game_over false
    set board::user_won false
    set board::score 0
    set board::selectedx $app::INVALID
    set board::selectedy $app::INVALID
    read_options
    initialize_board
    announce $app::SCORE_EVENT
    draw
}


proc board::read_options {} {
    set ini [::ini::open [util::get_ini_filename] -encoding utf-8 r]
    try {
        set section $app::BOARD
        set board::columns [::ini::value $ini $section $app::COLUMNS \
            $app::COLUMNS_DEFAULT]
        set board::rows [::ini::value $ini $section $app::ROWS \
            $app::ROWS_DEFAULT]
        set board::max_colors [::ini::value $ini $section \
            $app::MAX_COLORS $app::MAX_COLORS_DEFAULT]
        set board::delay_ms [::ini::value $ini $section \
            $app::DELAY_MS $app::DELAY_MS_DEFAULT]
    } finally {
        ::ini::close $ini
    }
}


proc board::initialize_board {} {
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


proc board::get_colors {} {
    set all_colors [dict keys $app::COLORS]
    set colors [struct::list shuffle $all_colors]
    return [lrange $colors 0 [expr {$board::max_colors - 1}]]
}


proc board::announce {event} {
    event generate .main.board $event -data $board::score
}


proc board::on_space {} {
    if {$board::game_over || $board::drawing || ![is_selected_valid]} {
        return
    }
    delete_tile $board::selectedx $board::selectedy
}


proc board::on_move_key {key} {
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
                [lindex $board::tiles $x $y] ne $app::INVALID_COLOR} {
            set board::selectedx $x
            set board::selectedy $y
        }
    }
    draw
}


proc board::on_click {x y} {
    if {$board::game_over || $board::drawing} {
        return
    }
    tile_size_ width height
    set x [expr {int($x / round($width))}]
    set y [expr {int($y / round($height))}]
    if {[is_selected_valid]} {
        set board::selectedx $app::INVALID
        set board::selectedy $app::INVALID
        draw
    }
    delete_tile $x $y
}


proc board::on_configure {width height} {
    if {$width != [.main.board cget -width] ||
            $height != [.main.board cget -height]} {
        draw
    }
}


proc board::draw {{delay_ms 0}} {
    if {$delay_ms > 0} {
        after $delay_ms board::draw
    } else {
        draw_board
        set board::moving false
    }
}


proc board::tile_size_ {width_ height_} {
    upvar 1 $width_ width $height_ height
    set width [expr {[winfo width .main.board] / double($board::columns)}]
    set height [expr {[winfo height .main.board] / double($board::rows)}]
}


proc board::is_selected_valid {} {
    return [expr {$board::selectedx != $app::INVALID &&
                  $board::selectedy != $app::INVALID}]
}


proc board::draw_board {} {
    if {![llength $board::tiles] || $board::drawing} {
        return
    }
    set $board::drawing true
    .main.board delete all
    tile_size_ width height
    set edge [expr {min($width, $height) / 9.0}]
    for {set x 0} {$x < $board::columns} {incr x} {
        for {set y 0} {$y < $board::rows} {incr y} {
            draw_tile $x $y $width $height $edge
        }
    }
    if {$board::user_won || $board::game_over} {
        draw_game_over
    }
    set $board::drawing false
}


proc board::draw_tile {x y width height edge} {
    set x1 [expr {$x * $width}]
    set y1 [expr {$y * $height}]
    set x2 [expr {$x1 + $width}]
    set y2 [expr {$y1 + $height}]
    set color [lindex $board::tiles $x $y]
    if {$color eq $app::INVALID_COLOR} {
        .main.board create rectangle $x1 $y1 $x2 $y2 \
            -fill $app::BACKGROUND_COLOR -outline white
    } else {
        get_color_pair_ $color $board::game_over light dark
        draw_segments $x1 $y1 $x2 $y2 $light $dark $edge
        set ix1 [expr {$x1 + $edge}]
        set iy1 [expr {$y1 + $edge}]
        set ix2 [expr {$x2 - $edge}]
        set iy2 [expr {$y2 - $edge}]
        ui::draw_gradient .main.board $ix1 $iy1 $ix2 $iy2 $light $dark
        if {$x == $board::selectedx && $y == $board::selectedy} {
            draw_focus $x1 $y1 $x2 $y2 $edge
        }
    }
}


proc board::draw_segments {x1 y1 x2 y2 light dark edge} {
    draw_segment $light $x1 $y1 [expr {$x1 + $edge}] \
        [expr {$y1 + $edge}] [expr {$x2 - $edge}] \
        [expr {$y1 + $edge}] $x2 $y1
    draw_segment $light $x1 $y1 $x1 $y2 [expr {$x1 + $edge}] \
        [expr {$y2 - $edge}] [expr {$x1 + $edge}] \
        [expr {$y1 + $edge}]
    draw_segment $dark [expr {$x2 - $edge}] [expr {$y1 + $edge}] \
        $x2 $y1 $x2 $y2 [expr {$x2 - $edge}] [expr {$y2 - $edge}]
    draw_segment $dark $x1 $y2 [expr {$x1 + $edge}] \
        [expr {$y2 - $edge}] [expr {$x2 - $edge}] \
        [expr {$y2 - $edge}] $x2 $y2
}


proc board::draw_segment {color args} {
    .main.board create polygon {*}$args -fill $color
}


proc board::get_color_pair_ {color game_over light_ dark_} {
    upvar 1 $light_ light $dark_ dark
    if {![dict exists $app::COLORS $color]} {
        # Not found ∴ dimmed
        set light $color
        set dark [ui::adjusted_color $color 50] ;# darken by 50%
    } else {
        set light [dict get $app::COLORS $color]
        set dark $color
        if {$game_over} {
            set light [ui::adjusted_color $light 67] ;# darken by 67%
            set dark [ui::adjusted_color $dark 67] ;# darken by 67%
        }
    }
}


proc board::draw_game_over {} {
    set msg [expr {$board::user_won ? "You Won!" : "Game Over"}]
    if {$board::user_won && $board::score > $board::high_score} {
        append msg "\nNew Highscore"
    }
    set color [expr {$board::user_won ? "#FF00FF" : "#00FF00"}]
    set x [expr {[winfo width .main.board] / 2}]
    set y [expr {[winfo height .main.board] / 2}]
    .main.board create text [expr {$x + 2}] [expr {$y + 2}] -font big \
        -justify center -fill "#C0C0C0" -text $msg
    .main.board create text $x $y -font big -justify center -fill $color \
        -text $msg
}


proc board::draw_focus {x1 y1 x2 y2 edge} {
    set edge [expr {$edge * 4 / 3.0 }]
    set x1 [expr {$x1 + $edge}]
    set y1 [expr {$y1 + $edge}]
    set x2 [expr {$x2 - $edge}]
    set y2 [expr {$y2 - $edge}]
    .main.board create rectangle $x1 $y1 $x2 $y2 -dash -
}
