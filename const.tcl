#!/usr/bin/env wish
# Copyright © 2020 Mark Summerfield. All rights reserved.


namespace eval const {

    variable VERSION 7.0.0
    variable PAD 3
    variable VGAP 6
    variable BACKGROUND_COLOR "#FFFEE0"
    variable INVALID -1

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
        variable FONTSIZE fontSize

    variable COLUMNS_DEFAULT 9
    variable ROWS_DEFAULT 9
    variable MAX_COLORS_DEFAULT 4
    variable DELAY_MS_DEFAULT 200
    variable HIGH_SCORE_DEFAULT 0

    variable COLORS {
        "#FF800000" "#FFF99999"
        "#FF800000" "#FFF99999"
        "#FF008000" "#FF99F999"
        "#FF808000" "#FFF9F999"
        "#FF000080" "#FF9999F9"
        "#FF800080" "#FFF999F9"
        "#FF008080" "#FF99F9F9"
        "#FF808080" "#FFF9F9F9"
    }
}
