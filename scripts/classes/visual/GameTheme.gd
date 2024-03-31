extends Node
class_name GameTheme

@export var theme_name = "default"

var color_body = Color("2f2d39")
var pal = [Color("feb380"), Color("d1efff"), Color("92dd7e"), Color("bf92f9"), Color("b0bac0")]
var pal_accent = [Color("c45f5f"), Color("869cbe"), Color("3a8f64"), Color("665c9f"), Color("6e7080")] #TODO determine whether these are needed

# Textures
var atlas = CardAtlas.new()
var atlas2 = CardAtlas.new()
var back : Texture2D

# g
var trns = Transform2D()


func _init():
	atlas.set_atlas(load_tex("card"))
	atlas2.set_atlas(load_tex("card"))
	back = load_tex("card-back")
	
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

func draw_background():
	pass

func get_glyph_tex(_name):
	return load_tex("glyphs/glyph-" + _name)


#region helper functions
func draw_halves(c, xoffset, yoffset, rotoffset, scale, tex1, tex2):
	transform(c, xoffset, yoffset, rotoffset, scale)
	if tex1: c.draw_texture(tex1, Global.CARD_DRAW_OFFSET, Color.WHITE)
	#else: print(tex1)
	
	transform(c, xoffset, yoffset, rotoffset + PI, scale)
	if tex2: c.draw_texture(tex2, Global.CARD_DRAW_OFFSET, Color.WHITE)

func transform(c, xoffset, yoffset, rotoffset, scale):
	# origin
	Global.tmpv1[0] = xoffset
	Global.tmpv1[1] = yoffset
	trns[2] = Global.tmpv1.rotated(rotoffset)
	
	# scale	
	trns[0][0] = scale * abs(c.flipScl)
	trns[0][1] = 0
	trns[1][0] = 0
	trns[1][1] = scale
	
	# rotation
	trns = trns.rotated(rotoffset)
	
	c.draw_set_transform_matrix(trns)

func load_tex(stri):
	return load("res://assets/sprites/" + stri + ".png")
#endregion


#region no touchy unless needed
func draw_card(c:Card, xoffset, yoffset, rotoffset, scale):
	if c.flip < 0.5: draw_card_back(c, xoffset, yoffset, rotoffset, scale)
	else: draw_card_front(c, xoffset, yoffset, rotoffset, scale)
#endregion
