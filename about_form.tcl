#!/usr/bin/env wish
# Copyright © 2020 Mark Summerfield. All rights reserved.

namespace eval about_form {

    proc show {} {
        make_widgets
        make_layout
        make_bindings
        ui::prepare_form .about "About — $const::APPNAME" \
            { about_form::on_close }
        focus .about.text
    }


    proc make_widgets {} {
        tk::toplevel .about
        tk::text .about.text -width 50 -height 14 -wrap word \
            -background "#F0F0F0" 
        populate_about_text
        .about.text configure -state disabled
        ttk::button .about.close_button -text Close -compound left \
            -image [image create photo -file $::IMG_PATH/close.png] \
            -command { about_form::on_close } -underline 0 
    }


    proc make_layout {} {
        grid .about.text -sticky nsew
        grid .about.close_button
    }


    proc make_bindings {} {
        bind .about <Alt-c> { about_form::on_close }
        bind .about <Escape> { about_form::on_close }
    }


    proc on_close {} {
        grab release .about
        destroy .about
    }

    proc populate_about_text {} {
        create_text_tags
        .about.text insert end "Gravitate v$const::VERSION\n" title
        .about.text insert end "A TileFall/SameGame-like game.\n" \
            strapline
        .about.text insert end "License: GPLv3\n" body
        .about.text insert end "Tcl v$::tcl_patchLevel on\
            $::tcl_platform(os) $::tcl_platform(osVersion)\
            $::tcl_platform(machine)" body
        # TODO copyright etc.
    }


    proc create_text_tags {} {
        .about.text tag configure title -foreground navy -justify center \
            -font title_font
        .about.text tag configure strapline -foreground navy \
            -justify center -font body_font
        .about.text tag configure body -foreground darkgreen \
            -justify center -font body_font
    }
}
