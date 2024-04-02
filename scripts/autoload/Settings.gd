extends Node

var game_themes = Array()
var game_theme : GameTheme

var card_scale = 0.8

# TODO move to somewhere that is saved.
var last_theme = "default"

func register_theme(theme:GameTheme):
	game_themes.append(theme)
