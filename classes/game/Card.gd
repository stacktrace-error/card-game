extends Area2D
class_name Card

signal hovered(card)
signal unhovered(card)

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

var hovering = false

# Ranges from 0-1.
@export var flip = 0
var hover = 0

# Used by card drawning.
var flipScl : float: 
	get: return Utilities.smooth_interp(flip) * 2 - 1.0
var hov : float:
	get: return Utilities.smooth_interp(hover)

func _process(delta):
	if(hovering):
		if(hover < 0.99): hover += delta * 6
		else: hover = 1
	else:
		if(hover > 0.01): hover -= delta * 6
		else: hover = 0
	
	queue_redraw()

func reset_offsets():
	xoffset = 0
	yoffset = 0
	rotoffset = 0
	scloffset = 0

func get_glyph(index:int): #TODO
	return get_child(index)

func get_color(index:int):
	return get_glyph(index).color

func _draw():
	if(Settings.game_theme): Settings.game_theme.draw_card(self, xoffset, yoffset, rotoffset, scl + scloffset)

func _ready():
	var g = Settings.random_glyph()
	if get_child_count(): g = get_child(0)
	
	if g.force_full_card:
		add_child(g.duplicate())
		add_child(Global.GLYPH_EMPTY.duplicate())
	else:
		var m = [Settings.random_glyph(), g]
		m.sort_custom(func(a, b): return a.value > b.value)
		for i in 2: add_child(m[i].duplicate())
		
	add_child(Global.CARD_COLLISION.duplicate())
	
	tree_entered.connect(_on_tree_entered)
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)

func _on_tree_entered():
	reset_offsets()

func _on_mouse_entered():
	hovered.emit(self)

func _on_mouse_exited():
	unhovered.emit(self)
