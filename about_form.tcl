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
        tk::text .about.text -width 50 -height 9 -wrap word \
            -background "#F0F0F0" -font body -spacing3 4
        populate_about_text
        .about.text configure -state disabled
        ttk::button .about.ok_button -text OK -compound left \
            -image [image create photo -file $::IMG_PATH/ok.png] \
            -command { about_form::on_close } -underline 0 
    }


    proc make_layout {} {
        grid .about.text -sticky nsew
        grid .about.ok_button
    }


    proc make_bindings {} {
        bind .about <Alt-o> { about_form::on_close }
        bind .about <Escape> { about_form::on_close }
        bind .about <Return> { about_form::on_close }
        .about.text tag bind url <Double-1> {
            about_form::on_click_url @%x,%y
        }
    }

    proc on_click_url {index} {
        set start $index
        while {$start > 0 && [.about.text get $start] != " " &&
                [.about.text get $start] != "\n"} {
            set start [.about.text index "$start -1c"]
        }
        set end $index
        while {[.about.text get $end] != " " &&
                [.about.text get $end] != "\n"} {
            set end [.about.text index "$end +1c"]
        }
        set word [string trim [.about.text get $start $end]]
        puts "<$word>" ; # TODO
    }


    proc on_close {} {
        grab release .about
        destroy .about
    }

    proc populate_about_text {} {
        ui::create_text_tags .about.text
        set img [.about.text image create end -align center \
                 -image [image create photo -file $::IMG_PATH/icon.png]]
        .about.text tag add body $img
        .about.text insert end "\nGravitate v$const::VERSION\n" {body title}
        .about.text insert end "A TileFall/SameGame-like game.\n" \
            {body navy}
        set year [clock format [clock seconds] -format %Y]
        if {$year > 2020} {
            set year "2020-[string range $year end-1 end]"
        }
        set bits [expr {8 * $::tcl_platform(wordSize)}]
        .about.text insert end "www.qtrac.eu/gravitate.html\n" \
            {body green url}
        .about.text insert end "Copyright © $year Mark Summerfield.\
                                \nAll Rights Reserved.\n" {body green}
        .about.text insert end "License: GPLv3.\n" {body green}
        .about.text insert end "Tcl v$::tcl_patchLevel ${bits}-bit on\
            $::tcl_platform(os) $::tcl_platform(osVersion)\
            $::tcl_platform(machine)." body
    }


}
