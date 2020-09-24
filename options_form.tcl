#!/usr/bin/env wish
# Copyright © 2020 Mark Summerfield. All rights reserved.

namespace eval options_form {

    variable ok false

    proc show_window {} {
        variable ok
        make_widgets
        make_layout
        make_bindings
        wm transient .options .
        wm protocol .options WM_DELETE_WINDOW options_form::on_close
        wm title .options "Options — $const::APPNAME"
        wm iconphoto .options [image create photo \
                               -file $::IMG_PATH/icon.png]
        raise .options
        focus .options
        grab .options
        # focus .options.text
        return $ok
    }


    proc make_widgets {} {
        tk::toplevel .options
        ttk::button .options.close_button -text Close -compound left \
            -image [image create photo -file $::IMG_PATH/close.png] \
            -command { options_form::on_close } -underline 0 
    }


    proc make_layout {} {
        grid .options.close_button -row 1 -column 0 -columnspan 2
        grid columnconfigure .options 0 -weight 1
        grid rowconfigure .options 0 -weight 1
    }


    proc make_bindings {} {
        bind .options <Alt-c> { options_form::on_close }
        bind .options <Escape> { options_form::on_close }
    }


    proc on_close {} {
        variable ok
        set ok false
        grab release .options
        destroy .options
    }

}
