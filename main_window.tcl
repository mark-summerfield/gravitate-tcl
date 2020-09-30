#!/usr/bin/env wish
# Copyright © 2020 Mark Summerfield. All rights reserved.

package require inifile
package require lambda


namespace eval main_window {

    variable score 0
    variable high_score 0
    variable status_timer_id {}

    proc make_window {} {
        make_widgets
        make_layout
        make_bindings
        read_options
        actions::on_new
        status_message "Click a tile to play…"
    }


    proc make_widgets {} {
        ttk::frame .main
        ttk::frame .main.toolbar
        ttk::button .main.toolbar.new -text New -style Toolbutton \
            -image [image create photo -file $::IMG_PATH/new.png] \
            -command actions::on_new
        ttk::button .main.toolbar.options -text Options -style Toolbutton \
            -image [image create photo -file $::IMG_PATH/options.png] \
            -command actions::on_options
        ttk::button .main.toolbar.about -text About -style Toolbutton \
            -image [image create photo -file $::IMG_PATH/about.png] \
            -command actions::on_about
        ttk::button .main.toolbar.help -text Help -style Toolbutton \
            -image [image create photo -file $::IMG_PATH/help.png] \
            -command actions::on_help
        ttk::button .main.toolbar.quit -text Quit -style Toolbutton \
            -image [image create photo -file $::IMG_PATH/shutdown.png] \
            -command actions::on_quit
        tk::canvas .main.board -background $const::BACKGROUND_COLOR
        ttk::frame .main.status_bar
        ttk::label .main.status_bar.label
        ttk::label .main.status_bar.score_label
    }


    proc make_layout {} {
        grid .main -sticky nsew
        grid .main.toolbar -sticky ew
        grid .main.toolbar.new -row 0 -column 0 -sticky w
        grid .main.toolbar.options -row 0 -column 1 -sticky w
        grid .main.toolbar.about -row 0 -column 2 -sticky w
        grid .main.toolbar.help -row 0 -column 3 -sticky w
        grid .main.toolbar.quit -row 0 -column 4 -sticky e
        grid columnconfigure .main.toolbar 1 -weight 1
        grid columnconfigure .main.toolbar 4 -weight 1
        grid .main.board -sticky nsew -pady $const::PAD
        grid .main.status_bar -sticky ew
        grid .main.status_bar.label -row 0 -column 0 -sticky we
        grid .main.status_bar.score_label -row 0 -column 1 -sticky e
        grid columnconfigure .main.status_bar 0 -weight 1
        grid columnconfigure .main 0 -weight 1
        grid rowconfigure .main 1 -weight 1
        grid columnconfigure . 0 -weight 1
        grid rowconfigure . 0 -weight 1
    }


    proc make_bindings {} {
        bind . n { actions::on_new }
        bind . o { actions::on_options }
        bind . a { actions::on_about }
        bind . h { actions::on_help }
        bind . <F1> { actions::on_help }
        bind . q { actions::on_quit }
        bind . <Escape> { actions::on_quit }
    }


    proc read_options {} {
        set ini [::ini::open [util::get_ini_filename] -encoding utf-8 r]
        try {
            set section $const::BOARD
            set main_window::high_score \
                [::ini::value $ini $section $const::HIGH_SCORE -1]
            if {$main_window::high_score == -1} {
                set main_window::high_score [::ini::value $ini $section \
                    $const::HIGH_SCORE_COMPAT $const::HIGH_SCORE_DEFAULT]
            }
            .main.status_bar.score_label configure \
                -text "0 • [util::commas $main_window::high_score]"
            set section $const::WINDOW
            set invalid $const::WINDOW_INVALID
            set width [::ini::value $ini $section $const::WINDOW_WIDTH \
                       $invalid]
            set height [::ini::value $ini $section $const::WINDOW_HEIGHT \
                        $invalid] 
            set x [::ini::value $ini $section $const::WINDOW_X $invalid] 
            set y [::ini::value $ini $section $const::WINDOW_Y $invalid] 
            if {$width != $invalid && $height != $invalid &&
                    $x != $invalid && $y != $invalid} {
                wm geometry . "${width}x$height+$x+$y"
            }
            set scaling [::ini::value $ini $section $const::SCALING \
                         [tk scaling]]
            if {[tk scaling] != $scaling} {
                tk scaling $scaling
            }
        } finally {
            ::ini::close $ini
        }
    }


    proc status_message {msg {ms 5000}} {
        after cancel $main_window::status_timer_id
        .main.status_bar.label configure -text $msg
        if {$ms > 0} {
            set main_window::status_timer_id \
                [after $ms [::lambda {} {
                    .main.status_bar.label configure -text "" }]]
        }
    }
}
