#!/usr/bin/env wish
# Copyright © 2020 Mark Summerfield. All rights reserved.


namespace eval const {

    variable VERSION 7.0.4
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
        "#A00000" "#F88888"
        "#A00000" "#F88888"
        "#00A000" "#88F888"
        "#A0A000" "#F8F888"
        "#0000A0" "#8888F8"
        "#A000A0" "#F888F8"
        "#00A0A0" "#88F8F8"
        "#A0A0A0" "#F8F8F8"
    }
    variable INVALID_COLOR ""
    variable GAME_OVER_EVENT <<GameOver>>
    variable SCORE_EVENT <<Score>>
}
