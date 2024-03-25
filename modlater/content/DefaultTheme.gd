extends GameTheme

var card = AtlasTexture.new()
var colorblind = AtlasTexture.new()
var back : Texture2D

func _init():
	card.set_atlas(load_tex("card"))
	colorblind.set_atlas(load_tex("card-colorblind"))
	back = load_tex("card-back")
	
	theme_name = "default"
	Settings.register_theme(self)
	Settings.game_theme = self


func draw_card_front(c, xoffset, yoffset, rotoffset, scale):
	card_colors(c, xoffset, yoffset, rotoffset, scale)
	card_colorblinds(c, xoffset, yoffset, rotoffset, scale)
	card_glyphs(c, xoffset, yoffset, rotoffset, scale)

func draw_card_back(c, xoffset, yoffset, rotoffset, scale):
	transform(c, xoffset, yoffset, rotoffset, scale)
	c.draw_texture(back, Global.CARD_DRAW_OFFSET, Color.WHITE)

func get_glyph_tex(_name):
	return load_tex("glyphs/glyph-" + _name)

func load_tex(stri):
	return load("res://modlater/assets/sprites/" + stri + ".png")


#region pain
func card_colors(c, xoffset, yoffset, rotoffset, scale):
	transform(c, xoffset, yoffset, rotoffset, scale)
	card_atlas_at(card, c.color1, 1 if c.accented else 0)
	c.draw_texture(card, Global.CARD_DRAW_OFFSET, Color.WHITE)
	
	transform(c, xoffset, yoffset, rotoffset + PI, scale)
	card_atlas_at(card, c.color2, 1 if c.accented else 0)
	c.draw_texture(card, Global.CARD_DRAW_OFFSET, Color.WHITE)

func card_colorblinds(c, xoffset, yoffset, rotoffset, scale):
	transform(c, xoffset, yoffset, rotoffset, scale)
	card_atlas_at(colorblind, c.color1, 0)
	c.draw_texture(colorblind, Global.CARD_DRAW_OFFSET, Color.WHITE)
	
	transform(c, xoffset, yoffset, rotoffset + PI, scale)
	card_atlas_at(colorblind, c.color2, 0)
	c.draw_texture(colorblind, Global.CARD_DRAW_OFFSET, Color.WHITE)

func card_glyphs(c, xoffset, yoffset, rotoffset, scale):
	var g
	transform(c, xoffset, yoffset, rotoffset, scale)
	g = Settings.get_glyph_tex(c.glyph1)
	c.draw_texture(g, Global.CARD_DRAW_OFFSET, Color.WHITE)
	
	transform(c, xoffset, yoffset, rotoffset + PI, scale)
	g = Settings.get_glyph_tex(c.glyph2)
	c.draw_texture(g, Global.CARD_DRAW_OFFSET, Color.WHITE)
#endregion
