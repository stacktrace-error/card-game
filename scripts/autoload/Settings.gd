extends Node

var game_themes = Array()
var game_theme : GameTheme

# TODO move to somewhere that is saved.
var last_theme = "default"

func register_theme(theme:GameTheme):
	game_themes.append(theme)
