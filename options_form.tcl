#!/usr/bin/env wish
# Copyright © 2020 Mark Summerfield. All rights reserved.

namespace eval options_form {

    variable ok false

    proc show_modal {} {
        variable ok
        make_widgets
        make_layout
        make_bindings
        util::prepare_dialog .options "Options — $const::APPNAME" \
            $::IMG_PATH/icon.png { options_form::on_close }
        # focus .options.? # TODO
        tkwait window .options
        return $ok
    }


    proc make_widgets {} {
        tk::toplevel .options
        # TODO labels & entries|spins
        ttk::button .options.ok_button -text OK -compound left \
            -image [image create photo -file $::IMG_PATH/ok.png] \
            -command { options_form::on_ok } -underline 0 
        ttk::button .options.close_button -text Cancel -compound left \
            -image [image create photo -file $::IMG_PATH/close.png] \
            -command { options_form::on_close } -underline 0 
    }


    proc make_layout {} {
        grid .options.ok_button -row 1 -column 0
        grid .options.close_button -row 1 -column 1
        grid columnconfigure .options 0 -weight 1
        grid rowconfigure .options 0 -weight 1
    }


    proc make_bindings {} {
        bind .options <Alt-o> { options_form::on_ok }
        bind .options <Alt-c> { options_form::on_close }
        bind .options <Escape> { options_form::on_close }
    }


    proc on_ok {} {
        variable ok
        set ok true
        do_close
    }


    proc on_close {} {
        variable ok
        set ok false
        do_close
    }


    proc do_close {} {
        grab release .options
        destroy .options
    }

}
