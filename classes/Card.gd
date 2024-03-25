extends Area2D
class_name Card

@export var glyph1 = "empty"
@export var glyph2 = "empty"
@export var color1 : int
@export var color2 : int

@export var accented : bool

var rotoffset = 0
var xoffset = 0
var yoffset = 0
var scl = 1:
	set(value):
		Global.tmpv1[0] = value
		Global.tmpv1[1] = value
		scale = Global.tmpv1
		scl = value

# Ranges from 0-1.
var flip = 0
var flipped = true

# Ranges from 0-1.
var hover = 0
var hovering = false

signal hovered(card)
signal unhovered(card)

# Used by card drawning.
var flipScl : float: 
	get: return Utilities.smooth_interp(flip) * 2 - 1.0

func _process(delta):
	if glyph1 == "empty": glyph1 = Settings.random_glyph().glyph_name
	if glyph2 == "empty": glyph2 = Settings.random_glyph().glyph_name
	if not color1: color1 = randi_range(0, 3)
	if not color2: color2 = randi_range(0, 3)
	
	if(flipped):
		if(flip < 0.99): flip += delta * 3
		else: flip = 1
	else:
		if(flip > 0.01): flip -= delta * 3
		else: flip = 0
	
	if(hovering):
		if(hover < 0.99): hover += delta * 6
		else: hover = 1
	else:
		if(hover > 0.01): hover -= delta * 6
		else: hover = 0
	
	queue_redraw()

func _draw():
	var h = Utilities.smooth_interp(hover)
	if(Settings.game_theme): Settings.game_theme.draw_card(self, 0, h * -200, 0, 1 + (h * 0.1))

func _on_mouse_entered():
	hovered.emit(self)

func _on_mouse_exited():
	unhovered.emit(self)
