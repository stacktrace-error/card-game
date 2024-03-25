extends Node
class_name GameTheme

var theme_name : String

var color_body = Color("2f2d39")
var pal = [Color("feb380"), Color("d1efff"), Color("92dd7e"), Color("bf92f9"), Color("b0bac0")]
var pal_accent = [Color("c45f5f"), Color("869cbe"), Color("3a8f64"), Color("665c9f"), Color("6e7080")]

var vec = Global.tmpv1
var trns = Transform2D()

#region required override
func draw_card_front(_c, _xoffset, _yoffset, _rotoffset, _scale):
	pass

func draw_card_back(_c, _xoffset, _yoffset, _rotoffset, _scale):
	pass

func draw_background():
	pass

func get_glyph_tex(_name):
	pass
#endregion


#region helper functions
func card_atlas_at(atlas, row, collumn):
	vec[0] = Global.CARD_SIZE[0] * row  
	vec[1] = Global.CARD_SIZE[1] * collumn 
	atlas.region.position = vec
	atlas.region.size = Global.CARD_SIZE

func transform(c, xoffset, yoffset, rotoffset, scale):
	# origin
	vec[0] = xoffset
	vec[1] = yoffset
	trns[2] = vec.rotated(rotoffset)
	
	# scale	
	trns[0][0] = scale * abs(c.flipScl)
	trns[0][1] = 0
	trns[1][0] = 0
	trns[1][1] = scale
	
	# rotation
	trns = trns.rotated(rotoffset)
	
	c.draw_set_transform_matrix(trns)
#endregion


#region no touchy unless needed
func draw_card(card, xoffset, yoffset, rotoffset, scale):
	if card.flip < 0.5:
		draw_card_back(card, xoffset, yoffset, rotoffset, scale)
	else:
		draw_card_front(card, xoffset, yoffset, rotoffset, scale)
#endregion
