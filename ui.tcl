#!/usr/bin/env wish
# Copyright © 2020 Mark Summerfield. All rights reserved.

package require inifile


namespace eval ui {

    proc prepare_form {window title on_close {modal true}} {
        wm withdraw $window
        if {$modal} {
            wm transient $window .
        }
        set x [expr {[winfo x [winfo parent $window]] + 20}]
        set y [expr {[winfo y [winfo parent $window]] + 40}]
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


    proc create_text_tags {widget} {
        $widget tag configure spaceabove -spacing1 [expr {$const::VGAP * 2}]
        $widget tag configure center -justify center
        $widget tag configure title -foreground navy -font h1
        $widget tag configure navy -foreground navy
        $widget tag configure green -foreground darkgreen
        $widget tag configure italic -font italic
        $widget tag configure url -underline true -underlinefg darkgreen
        $widget tag configure hr -overstrike true -overstrikefg lightgray \
	    -spacing3 10
    }


    proc font_info {family_ size_ {read_ini true}} {
        upvar $family_ family $size_ size
        set size [expr {$::tcl_platform(platform) eq "unix" ? 12 : 10}]
        set family Helvetica
        set font_data [font actual TkDefaultFont]
        if {![dict exists $font_data -family]} {
            dict set font_data -family $family
        }
        if {![dict exists $font_data -size]} {
            dict set font_data -size $size
        }
        if {$read_ini} {
            set ini [::ini::open [util::get_ini_filename] \
                     -encoding "utf-8" r]
            try {
                set section $const::WINDOW
                dict set font_data -family [::ini::value $ini $section \
                                            $const::FONTFAMILY $family]
                dict set font_data -size [::ini::value $ini $section \
                                          $const::FONTSIZE $size]
            } finally {
                ::ini::close $ini
            }
        }
        set family [dict get $font_data -family]
        set size [dict get $font_data -size]
    }


    proc make_fonts {} {
        font_info family size
        set h1 [expr {int(ceil($size * 1.2))}]
        font create h1 -family $family -size $h1 -weight bold
        font create body -family $family -size $size
        font create italic -family $family -size $size -slant italic
    }


}
