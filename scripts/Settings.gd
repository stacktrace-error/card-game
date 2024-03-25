extends Node

var game_themes = Array()
var game_theme : GameTheme

var glyphs = Array()
var byRarity = [[]]
var rarityChances = [70, 20, 10] # TODO this should probably be configurable or have a changable formula?

# TODO move to somewhere that is saved.
var last_theme = "default"
# TODO glyph rarity overrides using a dictionary? could be used for disabling as well.

func register_theme(theme):
	game_themes.append(theme)


func register_glyph(glyph):
	glyphs.append(glyph)
	
	if(glyph.allow_autogen):
		var v = glyph.rarity
		if v >= byRarity.size(): byRarity.resize(v + 1)
		
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
	
	# INFO Advance upward to figure out the tier, example:
	# 	rand is 95, chances are 70/30
	# 	70 is lower than 95, therefore out of the range of the first tier
	# 	advance 30
	# 	100 is higher than 95, select this tier
	while a < 25 and g == Global.GLYPH_EMPTY:
		var rand = randf_range(0, 100)
		var counter = 0.0
		for i in byRarity.size():
			counter += rarityChances[i] #advance by next tier's chance
			if counter > rand:
				if byRarity[i]: g = byRarity[i].pick_random() #pick current tier if advanced high enough
				break
		a += 1
		if a == 25: print("random_glyph() has hit 25 reroll cap.")
	return g
