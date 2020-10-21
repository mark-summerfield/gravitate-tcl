#!/usr/bin/env wish
# Copyright © 2020 Mark Summerfield. All rights reserved.

namespace eval help_form {}


proc help_form::show {} {
    if {[winfo exists .help]} {
        wm deiconify .help
    } else {
        make_widgets
        make_layout
        make_bindings
        ui::prepare_form .help "Help — [tk appname]" \
            { help_form::on_close } false
    }
    focus .help.text
}


proc help_form::make_widgets {} {
    tk::toplevel .help
    tk::text .help.text -width 50 -height 16 -wrap word \
        -background "#F0F0F0" -yscrollcommand { .help.vbar set } \
        -spacing3 6 -tabs 4c
    populate_help_text
    .help.text configure -state disabled
    ttk::scrollbar .help.vbar -command { .help.text yview }
    ttk::button .help.ok_button -text OK -compound left \
        -image [image create photo -file $::IMG_PATH/ok.png] \
        -command { help_form::on_close } -underline 0 
}


proc help_form::make_layout {} {
    grid .help.text -row 0 -column 0 -sticky nsew
    grid .help.vbar -row 0 -column 1 -sticky ns
    grid .help.ok_button -row 1 -column 0 -columnspan 2
    grid .help.text .help.vbar .help.ok_button -pady $app::PAD
    grid columnconfigure .help 0 -weight 1
    grid rowconfigure .help 0 -weight 1
}


proc help_form::make_bindings {} {
    bind .help <Alt-o> { help_form::on_close }
    bind .help <Escape> { help_form::on_close }
    bind .help <Return> { help_form::on_close }
}


proc help_form::on_close {} {
    grab release .help
    wm withdraw .help
}


proc help_form::populate_help_text {} {
    ui::add_text_tags .help.text
    .help.text insert end "Gravitate\n" {center title spaceabove}
    .help.text insert end "The purpose of the game is to\
                            remove all the tiles.\n" {center navy}
    .help.text insert end "Click a tile that has at least one\
        vertically or horizontally adjoining tile of the same color\
        to remove it and any vertically or horizontally adjoining\
        tiles of the same color, and "
    .help.text insert end their italic
    .help.text insert end " vertically or horizontally adjoining\
                            tiles, and so on."
    .help.text insert end " (So clicking a tile with no adjoining\
                            tiles of the same color does nothing.) " italic
    .help.text insert end "The more tiles that are removed in one\
                            go, the higher the score.\n"
    .help.text insert end "Gravitate works like TileFall and the\
        SameGame except that instead of tiles falling to the bottom\
        and moving off to the left, they “gravitate” to the\
        middle.\n"
    .help.text insert end "[string repeat " " 60]\n" {center hr}
    .help.text insert end "Key\tAction\n" green
    .help.text insert end "a\t" bold
    .help.text insert end "Show About box\n"
    .help.text insert end "h" bold
    .help.text insert end " or "
    .help.text insert end "F1\t" bold
    .help.text insert end "Show Help (this window)\n"
    .help.text insert end "n\t" bold
    .help.text insert end "New game\n"
    .help.text insert end "o\t" bold
    .help.text insert end "View or edit options\n"
    .help.text insert end "q" bold
    .help.text insert end " or "
    .help.text insert end "Esc\t" bold
    .help.text insert end "Quit\n"
    .help.text insert end "←\t" bold
    .help.text insert end "Move focus left\n"
    .help.text insert end "→\t" bold
    .help.text insert end "Move focus right\n"
    .help.text insert end "↑\t" bold
    .help.text insert end "Move focus up\n"
    .help.text insert end "↓\t" bold
    .help.text insert end "Move focus down\n"
    .help.text insert end "Space\t" bold
    .help.text insert end "Click focused tile\n"
    .help.text tag add margins 1.0 end
}
