#!/usr/bin/env wish
# Copyright © 2020 Mark Summerfield. All rights reserved.

set width 350
set height 350

ttk::frame .win
ttk::button .win.quit -text Quit -command on_quit -underline 0
bind . <Alt-q> { .win.quit invoke }
bind . <Escape> { .win.quit invoke }

proc on_quit {} {
    puts on_quit
    exit
}

set pad 3
pack .win -fill both -expand 1
grid .win.quit -row 1 -column 0 -sticky w -padx $pad -pady $pad
grid columnconfigure .win 0 -weight 1
grid rowconfigure .win 0 -weight 1

wm title . Gravitate
set x [expr { ([winfo vrootwidth .] - $width) / 2 }]
set y [expr { ([winfo vrootheight .] - $height) / 2 }]
wm geometry . ${width}x${height}+${x}+${y}
