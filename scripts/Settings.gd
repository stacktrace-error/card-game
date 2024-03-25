extends Node

var game_themes = Array()
var game_theme : GameTheme

var glyphs = Array()
var byRarity = [[]]
var rarityChances = [80, 20] # TODO this should probably be configurable or have a changable formula?

# TODO move to somewhere that is saved.
var last_theme = "default"
# TODO glyph rarity overrides using a dictionary? could be used for disabling as well.

func register_theme(theme):
	game_themes.append(theme)


func register_glyph(glyph):
	glyphs.append(glyph)
	
	if(glyph.allow_autogen):
		var v = glyph.rarity
		if v > glyphs.size(): byRarity.resize(v)
			
		if not byRarity[v]: byRarity[v] = Array()
		byRarity[v].append(glyph)
	
	print(byRarity)

func get_glyph(_name):
	var g = Global.GLYPH_EMPTY
	for i in glyphs:
		if i.glyph_name == _name:
			g = i
	return g

func get_glyph_tex(_name):
	var g = get_glyph(_name)
	return g.texture

func random_glyph():
	var g = Global.GLYPH_EMPTY
	var a = 0
	while a < 25 and g == Global.GLYPH_EMPTY:
		var rand = randf_range(0, 100) # Gets a random number up to 100
		var counter = 0.0
		for i in byRarity.size():
			if counter > rand:
				counter += rarityChances[i] # then moves through the tiers
			else:
				if byRarity[i]: g = byRarity[i].pick_random() # to see which tier's range it hit
				break
		a += 1
	return g
