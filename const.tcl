#!/usr/bin/env wish
# Copyright © 2020 Mark Summerfield. All rights reserved.


namespace eval const {

    variable APPNAME Gravitate
    variable VERSION 7.0.0
    variable PAD 3
    variable VGAP 6
    variable BACKGROUND_COLOR "#FFFEE0"

    variable BOARD Board
        variable COLUMNS columns
        variable ROWS rows
        variable MAX_COLORS maxColors
        variable DELAY_MS delayMs
        variable HIGH_SCORE highScore
        variable HIGH_SCORE_COMPAT HighScore
    variable WINDOW Window
        variable WINDOW_HEIGHT height
        variable WINDOW_WIDTH width
        variable WINDOW_X x
        variable WINDOW_Y y
        variable FONTFAMILY fontFamily
        variable FONTSIZE fontSize

    variable COLUMNS_DEFAULT 9
    variable ROWS_DEFAULT 9
    variable MAX_COLORS_DEFAULT 4
    variable DELAY_MS_DEFAULT 200
    variable HIGH_SCORE_DEFAULT 0
    variable WINDOW_INVALID -1
}
