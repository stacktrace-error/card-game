extends Node
class_name GameTheme

@export var theme_name = "default"

var color_body = Color("2f2d39")
var pal = [Color("feb380"), Color("d1efff"), Color("92dd7e"), Color("bf92f9"), Color("b0bac0")]
var pal_accent = [Color("c45f5f"), Color("869cbe"), Color("3a8f64"), Color("665c9f"), Color("6e7080")] #TODO determine whether these are needed
var pal_background = [Color("4d4e58"), Color("7b7b7b")]

# Textures
var atlas = CardAtlas.new()
var atlas2 = CardAtlas.new()
var back = load_tex("card-back")
var pile_back = load_tex("pile-back")

# g
var trns = Transform2D()

# background
const width = 14000.0
const height = 8000.0
const lines = Vector2(6000.0, 6000.0)
const line_spacing = 400.0
const line_speed = 0.1
const line_width = 200.0
const line_width_mul_edge = 1
const line_width_mul_middle = 0.2
var line_width_curve = Curve.new()
var curve_points = [Vector2(0, line_width_mul_edge), Vector2(0.5, line_width_mul_middle), Vector2(1, line_width_mul_edge)]
var back_rect = Rect2(-width / 2, -height / 2, width, height)
const pile_back_offset = Vector2(-507, -657)

func _init():
	atlas.set_atlas(load_tex("card"))
	atlas2.set_atlas(load_tex("card"))
	
	for i in curve_points: line_width_curve.add_point(i)
	line_width_curve.bake()
	
	Settings.register_theme(self)
	Settings.game_theme = self

func draw_card_front(c:Card, xoffset, yoffset, rotoffset, scale):
	draw_halves(c, xoffset, yoffset, rotoffset, scale, atlas.at(c.colors(0), 1 if c.accented else 0), atlas2.at(c.colors(1), 1 if c.accented else 0))
	draw_halves(c, xoffset, yoffset, rotoffset, scale, atlas.at(c.colors(0), 2), atlas2.at(c.colors(1), 2))
	atlas.at(0, 0) # I do not know why I have to reset it here, but drawing 2 colorblinds at once breaks without it
	draw_halves(c, xoffset, yoffset, rotoffset, scale, c.glyphs[0].texture, c.glyphs[1].texture)

func draw_card_back(c:Card, xoffset, yoffset, rotoffset, scale):
	transform(c, xoffset, yoffset, rotoffset, scale)
	c.draw_texture(back, Global.CARD_DRAW_OFFSET, Color.WHITE)

func draw_background(on:Node2D):
	transform(on, 0, 0, 0, 1.0)
	on.draw_rect(back_rect, pal_background[0])
	
	var balls = Time.get_ticks_msec() * line_speed
	var vec = Global.tmpv1
	vec[1] = 0
	for i in roundi(width / line_spacing):
		var g = fmod(balls + (i * line_spacing), width)
		vec[0] = g - (width / 2)
		on.draw_line(vec + lines, vec - lines, pal_background[1], line_width * line_width_curve.sample_baked(g / width))
	
	if Global.game.menu_name == "game":
		transform(on, 0, -on.position[1], 0, Settings.card_scale)
		on.draw_texture(pile_back, pile_back_offset, Color.WHITE)

func get_glyph_tex(_name):
	return load_tex("glyphs/glyph-" + _name)


#region helper functions
func draw_halves(c, xoffset, yoffset, rotoffset, scale, tex1, tex2):
	transform(c, xoffset, yoffset, rotoffset, scale)
	if tex1: c.draw_texture(tex1, Global.CARD_DRAW_OFFSET, Color.WHITE)
	#else: print(tex1)
	
	transform(c, xoffset, yoffset, rotoffset + PI, scale)
	if tex2: c.draw_texture(tex2, Global.CARD_DRAW_OFFSET, Color.WHITE)

func transform(on, xoffset, yoffset, rotoffset, scale):
	# origin
	Global.tmpv1[0] = xoffset
	Global.tmpv1[1] = yoffset
	trns[2] = Global.tmpv1.rotated(rotoffset)
	
	# scale	
	trns[0][0] = scale if not on is Card else scale * abs(on.flipScl)
	trns[0][1] = 0
	trns[1][0] = 0
	trns[1][1] = scale
	
	# rotation
	trns = trns.rotated(rotoffset)
	
	on.draw_set_transform_matrix(trns)

func load_tex(stri):
	return load("res://assets/sprites/" + stri + ".png")
#endregion


#region no touchy unless needed
func draw_card(c:Card, xoffset, yoffset, rotoffset, scale):
	if c.flip < 0.5: draw_card_back(c, xoffset, yoffset, rotoffset, scale)
	else: draw_card_front(c, xoffset, yoffset, rotoffset, scale)
#endregion
