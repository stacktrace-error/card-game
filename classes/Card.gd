extends Area2D
class_name Card

signal hovered(card)
signal unhovered(card)

@export var glyphs = ["empty", "empty"]
@export var colors = [-1, -1]

@export var accented : bool

@export var scl = 1:
	set(value):
		Global.tmpv1[0] = value
		Global.tmpv1[1] = value
		scale = Global.tmpv1
		scl = value

var xoffset = 0
var yoffset = 0
var rotoffset = 0
var scloffset = 0

var flipped = true
var hovering = false

# Ranges from 0-1.
var flip = 0
var hover = 0

# Used by card drawning.
var flipScl : float: 
	get: return Utilities.smooth_interp(flip) * 2 - 1.0

func _process(delta):
	for i in 2: if glyphs[i] == "empty": glyphs[i] = Settings.random_glyph().glyph_name
	for i in 2: if colors[i] < 0: colors[i] = randi_range(0, 3)
	
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
	if(Settings.game_theme): Settings.game_theme.draw_card(self, xoffset, yoffset, rotoffset, scl + scloffset)

func _ready():
	add_child(Global.CARD_COLLISION.duplicate())
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)

func _on_mouse_entered():
	hovered.emit(self)

func _on_mouse_exited():
	unhovered.emit(self)
