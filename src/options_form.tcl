#!/usr/bin/env wish
# Copyright © 2020 Mark Summerfield. All rights reserved.

package require tooltip


namespace eval options_form {

    variable ok false

    proc show_modal {} {
        make_widgets
        make_layout
        make_bindings
        load_options
        ui::prepare_form .options "Options — [tk appname]" \
            { options_form::on_close }
        focus .options.columns_spinbox
        tkwait window .options
        return $options_form::ok
    }


    proc make_widgets {} {
        tk::toplevel .options
        ttk::label .options.columns_label -text Columns -underline 2
        tk::spinbox .options.columns_spinbox -from 5 -to 30 -format %2.0f
        tooltip::tooltip .options.columns_spinbox \
            "Columns (default $const::COLUMNS_DEFAULT)"
        ttk::label .options.rows_label -text Rows -underline 0
        tk::spinbox .options.rows_spinbox -from 5 -to 30 -format %2.0f
        tooltip::tooltip .options.rows_spinbox \
            "Rows (default $const::ROWS_DEFAULT)"
        ttk::label .options.max_colors_label -text "Max. Colors" \
            -underline 0
        tk::spinbox .options.max_colors_spinbox -from 2 \
            -to [dict size $const::COLORS] -format %2.0f
        tooltip::tooltip .options.max_colors_spinbox \
            "Max. Colors (default $const::MAX_COLORS_DEFAULT)"
        ttk::label .options.delay_label -text "Delay (ms)" -underline 0
        tk::spinbox .options.delay_spinbox -from 0 -to 1000 -format %4.0f \
            -increment 10
        tooltip::tooltip .options.delay_spinbox \
            "Delay to show tile movement (default\
            $const::DELAY_MS_DEFAULT milliseconds)"
        ttk::label .options.fontsize_label -text "Font Size (pt)" \
            -underline 0
        tk::spinbox .options.fontsize_spinbox -from 8 -to 20 -format %2.0f \
            -command { ui::update_fonts %s }
        tooltip::tooltip .options.fontsize_spinbox \
            "Base Font Size (default\
            [dict get [font actual TkDefaultFont] -size] points)"
        ttk::frame .options.buttons
        ttk::button .options.buttons.ok_button -text OK -compound left \
            -image [image create photo -file $::IMG_PATH/ok.png] \
            -command { options_form::on_ok } -underline 0 
        ttk::button .options.buttons.close_button -text Cancel \
            -compound left \
            -image [image create photo -file $::IMG_PATH/close.png] \
            -command { options_form::on_close } -underline 0 
    }


    proc make_layout {} {
        grid .options.columns_label -row 0 -column 0
        grid .options.columns_spinbox -row 0 -column 1 -sticky ew
        grid .options.rows_label -row 1 -column 0
        grid .options.rows_spinbox -row 1 -column 1 -sticky ew
        grid .options.max_colors_label -row 2 -column 0
        grid .options.max_colors_spinbox -row 2 -column 1 -sticky ew
        grid .options.delay_label -row 3 -column 0
        grid .options.delay_spinbox -row 3 -column 1 -sticky ew
        grid .options.fontsize_label -row 4 -column 0
        grid .options.fontsize_spinbox -row 4 -column 1 -sticky ew
        grid .options.buttons.ok_button -row 0 -column 0
        grid .options.buttons.close_button -row 0 -column 1
        grid .options.buttons -row 5 -column 0 -columnspan 2
        grid .options.columns_label .options.columns_spinbox \
             .options.rows_label .options.rows_spinbox \
             .options.max_colors_label .options.max_colors_spinbox \
             .options.delay_label .options.delay_spinbox \
             .options.fontsize_label .options.fontsize_spinbox \
             .options.buttons.ok_button .options.buttons.close_button \
             -padx $const::PAD -pady $const::PAD
    }


    proc make_bindings {} {
        bind .options <Alt-d> { focus .options.delay_spinbox }
        bind .options <Alt-f> { focus .options.fontsize_spinbox }
        bind .options <Alt-l> { focus .options.columns_spinbox }
        bind .options <Alt-m> { focus .options.max_colors_spinbox }
        bind .options <Alt-r> { focus .options.rows_spinbox }
        bind .options <Alt-o> { options_form::on_ok }
        bind .options <Return> { options_form::on_ok }
        bind .options <Alt-c> { options_form::on_close }
        bind .options <Escape> { options_form::on_close }
    }


    proc load_options {} {
        set ini [::ini::open [util::get_ini_filename] -encoding utf-8 r]
        try {
            set section $const::BOARD
            .options.columns_spinbox set \
                [::ini::value $ini $section $const::COLUMNS \
                 $const::COLUMNS_DEFAULT]
            .options.rows_spinbox set \
                [::ini::value $ini $section $const::ROWS \
                 $const::ROWS_DEFAULT]
            .options.max_colors_spinbox set \
                [::ini::value $ini $section $const::MAX_COLORS \
                 $const::MAX_COLORS_DEFAULT]
            .options.delay_spinbox set \
                [::ini::value $ini $section $const::DELAY_MS \
                 $const::DELAY_MS_DEFAULT]
            .options.fontsize_spinbox set \
                [::ini::value $ini $const::WINDOW $const::FONTSIZE \
                 [dict get [font actual TkDefaultFont] -size]]
        } finally {
            ::ini::close $ini
        }
    }


    proc on_ok {} {
        set ini [::ini::open [util::get_ini_filename] -encoding utf-8]
        try {
            set section $const::BOARD
            ::ini::set $ini $section $const::COLUMNS \
                [.options.columns_spinbox get]
            ::ini::set $ini $section $const::ROWS \
                [.options.rows_spinbox get]
            ::ini::set $ini $section $const::MAX_COLORS \
                [.options.max_colors_spinbox get]
            ::ini::set $ini $section $const::DELAY_MS \
                [.options.delay_spinbox get]
            ::ini::set $ini $const::WINDOW $const::FONTSIZE \
                [.options.fontsize_spinbox get]
            ::ini::commit $ini
        } finally {
            ::ini::close $ini
        }
        do_close true
    }


    proc on_close {} {
        do_close
    }


    proc do_close {{result false}} {
        set options_form::ok $result
        grab release .options
        destroy .options
    }
}
