#!/usr/bin/env wish
# Copyright © 2020 Mark Summerfield. All rights reserved.

namespace eval app {}


variable app::VERSION 7.0.8
variable app::INVALID -1
variable app::PAD 3
variable app::VGAP 6
variable app::BACKGROUND_COLOR "#FFFEE0"

variable app::BOARD Board
    variable app::COLUMNS columns
    variable app::ROWS rows
    variable app::MAX_COLORS maxColors
    variable app::DELAY_MS delayMs
    variable app::HIGH_SCORE highScore
    variable app::HIGH_SCORE_COMPAT HighScore
variable app::WINDOW Window
    variable app::WINDOW_HEIGHT height
    variable app::WINDOW_WIDTH width
    variable app::WINDOW_X x
    variable app::WINDOW_Y y
    variable app::FONTSIZE fontSize

variable app::COLUMNS_DEFAULT 9
variable app::ROWS_DEFAULT 9
variable app::MAX_COLORS_DEFAULT 4
variable app::DELAY_MS_DEFAULT 200
variable app::HIGH_SCORE_DEFAULT 0

variable app::COLORS {
    "#A00000" "#F88888"
    "#A00000" "#F88888"
    "#00A000" "#88F888"
    "#A0A000" "#F8F888"
    "#0000A0" "#8888F8"
    "#A000A0" "#F888F8"
    "#00A0A0" "#88F8F8"
    "#A0A0A0" "#F8F8F8"
}
variable app::INVALID_COLOR ""
variable app::GAME_OVER_EVENT <<GameOver>>
variable app::SCORE_EVENT <<Score>>
