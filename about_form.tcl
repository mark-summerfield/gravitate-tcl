#!/usr/bin/env wish
# Copyright © 2020 Mark Summerfield. All rights reserved.

namespace eval about_form {

    proc show_window {} {
        make_widgets
        make_layout
        make_bindings
        wm transient .about .
        wm protocol .about WM_DELETE_WINDOW about_form::on_close
        wm title .about "About — $const::APPNAME"
        wm iconphoto .about [image create photo -file $::IMG_PATH/icon.png]
        raise .about
        focus .about
        grab .about
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
        .about.text insert end "Gravitate\n" title
    }


    proc create_text_tags {} {
        .about.text tag configure title -foreground navy -justify center \
            -font title_font
    }
}
