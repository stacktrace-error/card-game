extends Node2D
class_name Game

signal finish_play(card, success)
signal new_card(color1, color2, glyph1, glyph2, accents)

@export var menu_name = "game"

@export var starting_count = 0
var starting_hand = Array()
var rarity_chances = [70.0, 20.0, 10.0]

var by_rarity = [[]]
#TODO rarity dict

var players = [1]
var player_index = 0
var turn_step = 1

#region setup
func _ready():
	Global.game = self
	Global.connection(self)
	
	Hand.clear_cards()
	if menu_name and Global.menu_cards.has(menu_name):
		var arr = Array()
		for i in Global.menu_cards[menu_name]: arr.append(i.copy())
		Hand.draw_array(arr)
	
	Hand.draw_array(starting_hand)
	Hand.draw_count(starting_count)
	
	child_entered_tree.connect(func(_x): 
		if get_child_count() > 16: get_child(0).free()
		_x.flip = 1
	)
	for i in Multiplayer.get_children(): if i.name != "1": players.append(i.name.to_int())

func _init(start_count = 0, start_hand = [], glyphs = []):
	starting_count = start_count
	starting_hand = start_hand
	
	if true: #TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO 
		for i in Global.glyphs:
			if(i.allow_autogen):
				var v = i.rarity
				if v >= by_rarity.size(): by_rarity.resize(v + 1)

				if not by_rarity[v]: by_rarity[v] = Array()
				by_rarity[v].append(i)
#endregion


#region logic
func _process(_delta): #TODO HOVER TO VIEW CARDS TODO HOVER TO VIEW CARDS TODO HOVER TO VIEW CARDS TODO HOVER TO VIEW CARDS
	for i in get_children():
		if i is Card: 
			i.position = i.position.lerp(Vector2.ZERO, _delta * 20)
			i.flip = 1
			
			var dst = clamp(i.position.distance_to(Vector2.ZERO) * 0.2, 0, 1)
			i.scloffset = Utilities.smooth_interp(dst) * 0.1
			i.rotoffset = (i.get_angle_to(Vector2.ZERO) + (PI*0.5)) * dst

@rpc("any_peer", "call_local")
func play(_card, to_array:Array):
	var c = _card
	
	if not c is Card:
		c = Global.card_from_array(to_array)
		Global.tmpv1[0] = 0
		Global.tmpv1[1] = -2000
		c.position = Global.tmpv1
		c.rotation = -PI
		add_child(c)
	else: c.reparent(self)
	
	c.rotation += randf_range(-0.1, 0.1)
	
	c.play()
	Global.SOUND_CARD_PLAY.play()
	player_index = index_in_x_turns(turn_step)

func index_in_x_turns(turns):
	if players.size() == 1: return 0
	
	var n = player_index + turns
	while n >= players.size(): n -= players.size()
	while n <= -players.size(): n += players.size()
	
	return n

func respond_play(_card:Card):
	if Multiplayer.id() == current_player():
		play.rpc(_card, _card.to_array())
		finish_play.emit(_card, true)
		return
	finish_play.emit(_card, false)

func player_in_x_turns(turns): return players[index_in_x_turns(turns)]

func current_player(): return players[player_index]

@rpc("any_peer", "call_local") func set_turn_step(step:int): turn_step = step
#endregion


#region card random
func random_glyph(min_rarity = 0, brick_chance = 0.0, no_fulls = false):
	if brick_chance > 0.05 and randf_range(0.0, 100.0) < brick_chance and not no_fulls: return Global.get_glyph("brick")
	# INFO Advance upward to figure out the tier, example:
	# 	rand is 95, chances are 70/30
	# 	70 is lower than 95, therefore out of the range of the first tier
	# 	advance 30
	# 	100 is higher than 95, select this tier
	var start = 0.0
	for i in min_rarity: start += rarity_chances[i]
	
	for a in 25:
		var rand = randf_range(start, 100.0)
		var counter = 0.0
		for i in by_rarity.size():
			counter = clampf(counter + rarity_chances[i], 0.0, 100.0) #advance by next tier's chance
			if counter > rand and by_rarity[i]: return by_rarity[i].pick_random() #pick current tier if advanced high enough
	push_warning("random_glyph() has hit 25 reroll cap.")
	return Global.GLYPH_EMPTY

func card(min_rarity = 0, brick_chance = 0.0):
	var g = random_glyph(min_rarity, brick_chance)
	var g2 = Global.GLYPH_EMPTY if g.full_card else random_glyph(min_rarity, 0.0, true)
	
	return Card.new(g.glyph_name, g2.glyph_name)
#endregion
