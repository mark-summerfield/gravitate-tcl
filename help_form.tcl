#!/usr/bin/env wish
# Copyright © 2020 Mark Summerfield. All rights reserved.

namespace eval help_form {

    proc show {} {
        if {[winfo exists .help]} {
            wm deiconify .help
        } else {
            make_widgets
            make_layout
            make_bindings
            ui::prepare_form .help "Help — $const::APPNAME" \
                { help_form::on_close } false
        }
        focus .help.text
    }


    proc make_widgets {} {
        tk::toplevel .help
        tk::text .help.text -width 50 -height 16 -wrap word \
            -background "#F0F0F0" -yscrollcommand { .help.vbar set } \
            -font body -spacing3 2
        populate_help_text
        .help.text configure -state disabled
        ttk::scrollbar .help.vbar -command { .help.text yview }
        ttk::button .help.ok_button -text OK -compound left \
            -image [image create photo -file $::IMG_PATH/ok.png] \
            -command { help_form::on_close } -underline 0 
    }


    proc make_layout {} {
        grid .help.text -row 0 -column 0 -sticky nsew
        grid .help.vbar -row 0 -column 1 -sticky ns
        grid .help.ok_button -row 1 -column 0 -columnspan 2
        grid columnconfigure .help 0 -weight 1
        grid rowconfigure .help 0 -weight 1
    }


    proc make_bindings {} {
        bind .help <Alt-o> { help_form::on_close }
        bind .help <Escape> { help_form::on_close }
        bind .help <Return> { help_form::on_close }
    }


    proc on_close {} {
        grab release .help
        wm withdraw .help
    }


    proc populate_help_text {} {
        ui::create_text_tags .help.text
        .help.text insert end "Gravitate\n" {body title}
        .help.text insert end "The purpose of the game is to\
                               remove all the tiles.\n" {body navy}
        # TODO
    }


}
#<body style="background-color: %s;">
#<center><font size=+2 color=navy><b>Gravitate</b></font></center>
#<p><font size=+1 color=navy><center>
#The purpose of the game is to remove all the tiles.</center></font>
#</p>
#<p>
#Click a tile that has at least one vertically or
#horizontally adjoining tile of the same color to remove it and any
#vertically or horizontally adjoining tiles of the same color, and
#<i>their</i> vertically or horizontally adjoining tiles, and so on.
#<i>(So clicking a tile with no adjoining tiles of the same color does
#nothing.)</i> The more tiles that are removed in one go, the higher
#the score.
#</p>
#<p>
#Gravitate works like TileFall and the SameGame except that instead of
#tiles falling to the bottom and moving off to the left, they
#“gravitate” to the middle.
#</p>
#<hr>
#<table>
#<tr><td><font color="#004E00">Key</font></td>
#    <td><font color="#004E00">Action</font></td></tr>
#<tr><td><b>a</b></td><td>Show About box</td></tr>
#<tr><td><b>h</b> or <b>F1</b></td><td>Show Help (this window)</td></tr>
#<tr><td><b>n</b></td><td>New game</td></tr>
#<tr><td><b>o</b></td><td>View or edit options</td></tr>
#<tr><td><b>q</b></td><td>Quit</td></tr>
#<tr><td><b>←</b></td><td>Move focus left</td></tr>
#<tr><td><b>→</b></td><td>Move focus right</td></tr>
#<tr><td><b>↑</b></td><td>Move focus up</td></tr>
#<tr><td><b>↓</b></td><td>Move focus down</td></tr>
#<tr><td><b>Space</b></td><td>Click focused tile</td></tr>
#</table>
