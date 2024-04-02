extends Node2D

func _draw(): Settings.game_theme.draw_background(self)

func _process(_delta): queue_redraw()
