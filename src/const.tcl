#!/usr/bin/env wish
# Copyright © 2020 Mark Summerfield. All rights reserved.

namespace eval const {}


variable const::VERSION 7.0.7
variable const::INVALID -1
variable const::PAD 3
variable const::VGAP 6
variable const::BACKGROUND_COLOR "#FFFEE0"

variable const::BOARD Board
    variable const::COLUMNS columns
    variable const::ROWS rows
    variable const::MAX_COLORS maxColors
    variable const::DELAY_MS delayMs
    variable const::HIGH_SCORE highScore
    variable const::HIGH_SCORE_COMPAT HighScore
variable const::WINDOW Window
    variable const::WINDOW_HEIGHT height
    variable const::WINDOW_WIDTH width
    variable const::WINDOW_X x
    variable const::WINDOW_Y y
    variable const::FONTSIZE fontSize

variable const::COLUMNS_DEFAULT 9
variable const::ROWS_DEFAULT 9
variable const::MAX_COLORS_DEFAULT 4
variable const::DELAY_MS_DEFAULT 200
variable const::HIGH_SCORE_DEFAULT 0

variable const::COLORS {
    "#A00000" "#F88888"
    "#A00000" "#F88888"
    "#00A000" "#88F888"
    "#A0A000" "#F8F888"
    "#0000A0" "#8888F8"
    "#A000A0" "#F888F8"
    "#00A0A0" "#88F8F8"
    "#A0A0A0" "#F8F8F8"
}
variable const::INVALID_COLOR ""
variable const::GAME_OVER_EVENT <<GameOver>>
variable const::SCORE_EVENT <<Score>>
