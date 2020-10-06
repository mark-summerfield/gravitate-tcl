#!/usr/bin/env wish
# Copyright © 2020 Mark Summerfield. All rights reserved.

package require inifile


namespace eval ui {

    proc prepare_form {window title on_close {modal true} {dx 20} {dy 40}} {
        wm withdraw $window
        if {$modal} {
            wm transient $window .
        }
        set x [expr {[winfo x [winfo parent $window]] + $dx}]
        set y [expr {[winfo y [winfo parent $window]] + $dy}]
        wm geometry $window "+$x+$y"
        wm title $window $title
        wm protocol $window WM_DELETE_WINDOW $on_close
        if {$modal} {
            grab $window
        }
        wm deiconify $window
        raise $window
        focus $window
    }


    proc add_text_tags {widget} {
	set margin 12
        $widget tag configure spaceabove -spacing1 [expr {$const::VGAP * 2}]
        $widget tag configure margins -lmargin1 $margin -lmargin2 \
	    $margin -rmargin $margin
        $widget tag configure center -justify center
        $widget tag configure title -foreground navy -font h1
        $widget tag configure navy -foreground navy
        $widget tag configure green -foreground darkgreen
        $widget tag configure bold -font bold
        $widget tag configure italic -font italic
        $widget tag configure url -underline true -underlinefg darkgreen
        $widget tag configure hr -overstrike true -overstrikefg lightgray \
	    -spacing3 10
    }


    proc make_fonts {} {
        set the_font [font actual TkDefaultFont]
        set family [dict get $the_font -family]
        set size [dict get $the_font -size]
        set h1 [expr {int(ceil($size * 1.2))}]
        set big [expr {int(ceil($size * 3.5))}]
        font create big -family Times -size $big -weight bold
        font create h1 -family $family -size $h1 -weight bold
        font create default -family $family -size $size
        font create bold -family $family -size $size -weight bold
        font create italic -family $family -size $size -slant italic
    }


    proc update_fonts {size} {
        font configure h1 -size [expr {int(ceil($size * 1.2))}]
        font configure default -size $size
        font configure bold -size $size
        font configure italic -size $size
    }


    # Modified copy of Tcl/Tk's palette.tcl's ::tk::Darken
    # percent < 100 darken (1 = darkest); percent > 100 brighten
    proc adjusted_color {color percent} {
        lassign [winfo rgb . $color] r g b
        set r [expr {min(255, ($r / 256) * $percent / 100)}]
        set g [expr {min(255, ($g / 256) * $percent / 100)}]
        set b [expr {min(255, ($b / 256) * $percent / 100)}]
        return [format "#%02X%02X%02X" $r $g $b]
    }
}
