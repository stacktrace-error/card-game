extends Node2D
class_name Game

signal finish_play(card, success)
signal new_card(color1, color2, glyph1, glyph2, accents)

@export var menu_name = "game"

@export var starting_count = 0
var starting_hand = Array()
var rarityChances = [70, 20, 10]

var byRarity = [[]]
#TODO rarity dict


func _ready():
	Global.game = self
	Global.connection(self)
	
	Hand.clear_cards()
	if menu_name and Global.menu_cards.has(menu_name):
		var arr = Array()
		for i:Card in Global.menu_cards[menu_name]: arr.append(i.copy())
		Hand.draw_array(arr)
	
	Hand.draw_array(starting_hand)
	Hand.draw_count(starting_count)
	
	child_entered_tree.connect(func(): if get_child_count() > 16: get_child(0).free())

func _init(start_count = 0, start_hand = [], glyphs = []):
	starting_count = start_count
	starting_hand = start_hand
	
	if true: #TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO 
		for i in Global.glyphs:
			if(i.allow_autogen):
				var v = i.rarity
				if v >= byRarity.size(): byRarity.resize(v + 1)

				if not byRarity[v]: byRarity[v] = Array()
				byRarity[v].append(i)

func card():
	var g = random_glyph()
	var g2 = Global.GLYPH_EMPTY if g.force_full_card else random_glyph()
	
	return Card.new(g.glyph_name, g2.glyph_name)

func random_glyph():	
	# INFO Advance upward to figure out the tier, example:
	# 	rand is 95, chances are 70/30
	# 	70 is lower than 95, therefore out of the range of the first tier
	# 	advance 30
	# 	100 is higher than 95, select this tier
	for a in 25:
		var rand = randf_range(0, 100)
		var counter = 0.0
		for i in byRarity.size():
			counter += rarityChances[i] #advance by next tier's chance
			if counter > rand and byRarity[i]: return byRarity[i].pick_random() #pick current tier if advanced high enough
	print("random_glyph() has hit 25 reroll cap.")
	return Global.GLYPH_EMPTY

func _process(_delta):
	for i in get_children():
		if i is Card: 
			i.position = i.position.lerp(Vector2.ZERO, _delta * 20)
			i.flip = 1
			
			var dst = clamp(i.position.distance_to(Vector2.ZERO) * 0.2, 0, 1)
			i.scloffset = Utilities.smooth_interp(dst) * 0.1
			i.rotoffset = (i.get_angle_to(Vector2.ZERO) + (PI*0.5)) * dst

@rpc("any_peer", "call_local")
func play(_card, id):
	var c = _card if _card is Card else instance_from_id(_card.object_id)
	
	if id != Multiplayer.id():
		Global.tmpv1[0] = 0
		Global.tmpv1[1] = -2000
		c.position = Global.tmpv1
	
	c.reparent(self)
	c.play()
	Global.SOUND_CARD_PlAY.play()

func respond_play(_card:Card):
	play.rpc(_card, Multiplayer.id())
	finish_play.emit(_card, true)
