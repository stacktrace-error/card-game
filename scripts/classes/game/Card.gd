extends Area2D
class_name Card

signal hovered(card)
signal unhovered(card)

@export var accented : bool

@export var glyphs : Array

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

func _init(gly1:String, gly2 = "empty", col1 = -1, col2 = -1):
	glyphs = [Global.get_glyph(gly1).duplicate(), Global.get_glyph(gly2).duplicate()]
	if col1 >= 0: glyphs[0].color = col1
	if col2 >= 0: glyphs[1].color = col2
	
	glyphs.sort_custom(func(a, b): return a.value > b.value)
	
	for i in glyphs: i.initialize(self)

func _ready():
	add_child(Global.CARD_COLLISION.duplicate())
	
	tree_entered.connect(func(): reset_offsets())
	mouse_entered.connect(func(): hovered.emit(self))
	mouse_exited.connect(func(): unhovered.emit(self))

func reset_offsets():
	xoffset = 0
	yoffset = 0
	rotoffset = 0
	scloffset = 0

func to_rpc(): return [glyphs[0].glyph_name, glyphs[0].glyph_name, colors(0), colors(1)]

func copy(): return new(glyphs[0].glyph_name, glyphs[1].glyph_name, colors(0), colors(1))

func play(): for i in glyphs: i.trigger()

func colors(index:int): return glyphs[index].color

func _draw(): if(Settings.game_theme): Settings.game_theme.draw_card(self, xoffset, yoffset, rotoffset, scl + scloffset)
