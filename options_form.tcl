#!/usr/bin/env wish
# Copyright © 2020 Mark Summerfield. All rights reserved.

namespace eval options_form {

    variable ok false

    proc show_modal {} {
        make_widgets
        make_layout
        make_bindings
	load_options
        ui::prepare_form .options "Options — $const::APPNAME" \
            { options_form::on_close }
        focus .options.columns_spinbox
        tkwait window .options
        return $options_form::ok
    }


    proc make_widgets {} {
        tk::toplevel .options
	ttk::label .options.columns_label -text Columns -underline 2
	ttk::spinbox .options.columns_spinbox -from 5 -to 30 -format %2.0f
	ttk::label .options.rows_label -text Rows -underline 0
	ttk::spinbox .options.rows_spinbox -from 5 -to 30 -format %2.0f
	ttk::label .options.max_colors_label -text "Max. Colors" \
	    -underline 0
	ttk::spinbox .options.max_colors_spinbox -from 2 \
	    -to [board::color_count] -format %2.0f
        # TODO delayMs fontFamily fontSize
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
	set pad $const::PAD
	grid .options.columns_label -row 0 -column 0 -padx $pad \
	    -pady $pad
	grid .options.columns_spinbox -row 0 -column 1 -sticky ew \
	    -padx $pad -pady $pad
	grid .options.rows_label -row 1 -column 0 -padx $pad -pady $pad
	grid .options.rows_spinbox -row 1 -column 1 -sticky ew -padx $pad \
	    -pady $pad
	grid .options.max_colors_label -row 2 -column 0 -padx $pad \
	    -pady $pad
	grid .options.max_colors_spinbox -row 2 -column 1 -sticky ew \
	    -padx $pad -pady $pad
        grid .options.buttons.ok_button -row 0 -column 0 -padx $pad \
	    -pady $pad
        grid .options.buttons.close_button -row 0 -column 1 -padx $pad \
	    -pady $pad
	grid .options.buttons -row 7 -column 0 -columnspan 2 -padx $pad \
	    -pady $pad
        grid columnconfigure .options 1 -weight 1
    }


    proc make_bindings {} {
	bind .options <Alt-l> { focus .options.columns_spinbox }
	bind .options <Alt-m> { focus .options.max_colors_spinbox }
	bind .options <Alt-r> { focus .options.rows_spinbox }
        bind .options <Alt-o> { options_form::on_ok }
        bind .options <Return> { options_form::on_ok }
        bind .options <Alt-c> { options_form::on_close }
        bind .options <Escape> { options_form::on_close }
    }


    proc load_options {} {
        # TODO
	puts "load_options from ini file and set widget values"
    }


    proc on_ok {} {
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
