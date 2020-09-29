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
        tk::text .about.text -width 50 -height 11 -wrap word \
            -background "#F0F0F0" -font body -spacing3 $const::VGAP
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
        set indexes [.about.text tag prevrange url $index]
        set url [string trim [.about.text get {*}$indexes]]
        if {$url ne ""} {
            if {![regexp -nocase {^http://} $url]} {
                set url [string cat http:// $url]
            }
            util::open_webpage $url
        }
    }


    proc on_close {} {
        grab release .about
        destroy .about
    }


    proc populate_about_text {} {
        ui::create_text_tags .about.text
        set img [.about.text image create end -align center \
                 -image [image create photo -file $::IMG_PATH/icon.png]]
        .about.text tag add spaceabove $img
        .about.text tag add center $img
        .about.text insert end "\nGravitate v$const::VERSION\n" \
            {center title}
        .about.text insert end "A TileFall/SameGame-like game.\n" \
            {center navy}
        set year [clock format [clock seconds] -format %Y]
        if {$year > 2020} {
            set year "2020-[string range $year end-1 end]"
        }
        set bits [expr {8 * $::tcl_platform(wordSize)}]
        .about.text insert end "www.qtrac.eu/gravitate.html\n" \
            {center green url}
        .about.text insert end "Copyright © $year Mark Summerfield.\
                                \nAll Rights Reserved.\n" {center green}
        .about.text insert end "License: GPLv3.\n" {center green}
	.about.text insert end "[string repeat " " 60]\n" {center hr}
        .about.text insert end "Tcl v$::tcl_patchLevel ${bits}-bit on\
            $::tcl_platform(os) $::tcl_platform(osVersion)\
            $::tcl_platform(machine)." center
    }


}
