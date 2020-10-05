#!/usr/bin/env wish
# Copyright © 2020 Mark Summerfield. All rights reserved.


namespace eval const {

    variable VERSION 7.0.0
    variable INVALID -1
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
        variable FONTSIZE fontSize

    variable COLUMNS_DEFAULT 9
    variable ROWS_DEFAULT 9
    variable MAX_COLORS_DEFAULT 4
    variable DELAY_MS_DEFAULT 200
    variable HIGH_SCORE_DEFAULT 0

    variable COLORS {
        "#800000" "#F99999"
        "#800000" "#F99999"
        "#008000" "#99F999"
        "#808000" "#F9F999"
        "#000080" "#9999F9"
        "#800080" "#F999F9"
        "#008080" "#99F9F9"
        "#808080" "#F9F9F9"
    }
    variable INVALID_COLOR ""

    variable USER_WON won
    variable GAME_OVER over
}
