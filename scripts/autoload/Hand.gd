extends Node2D

signal attempt_play(card)

var to_draw = Array()

var cards : Array
var card_count : int
var played_card : Card
var hovered_card : Card:
	set(value):
		if hovered_card: hovered_card.hovering = false
		if value: 
			value.hovering = true
			Global.SOUND_CARD_HOVER.play()
		hovered_card = value

var draw_speed = 10
var max_width = 4400.0
var spacing = 350.0:
	get: return min(spacing * Settings.card_scale, 1000.0 if card_count < 2 else max_width / (card_count - 1))
var offset = 850.0:
	get: return 0.0 if not hovered_card else (offset * 0.5 + 350.0) * Settings.card_scale - spacing


#region cards
func _input(event):
	if(hovered_card and event.is_action_pressed("confirm")): play(hovered_card)
	if(event.is_action_pressed("draw")): draw_count(1)

func _process(delta):
	cards = get_children().filter(func(x): return x is Card)
	card_count = cards.size()
	
	# position the cards
	Global.tmpv1[0] = -(spacing * (card_count - 1) * 0.5) - offset
	Global.tmpv1[1] = Global.CARD_DRAW_OFFSET[1] * Settings.card_scale
	
	for i in card_count:
		var c = cards[i]
		# if hovered card, add an offset
		if c == hovered_card: Global.tmpv1[0] += offset
		
		# move current card
		c.position = c.position.lerp(Global.tmpv1, delta * draw_speed)
		c.yoffset = c.hov * -200
		c.scloffset = c.hov * 0.1
		c.flip = clamp(c.flip + (delta * draw_speed * 0.15), 0.0, 1.0)
		
		# next card's intended position
		Global.tmpv1[0] += spacing
		if c == hovered_card: Global.tmpv1[0] += offset # must be added twice
	
	# draw new cards	
	if (not to_draw.is_empty()) and (cards.is_empty() or cards[-1].flip == 1.0):
		var drawn = to_draw.pop_front()
		if not drawn is Card: return
		
		Global.tmpv1[1] = 10000
		drawn.position = Global.tmpv1
		drawn.flip = -0.5
		
		add_child(drawn)

func clear_cards():
	for i in get_children(): i.call_deferred("free")
	for i in to_draw: i.call_deferred("free")
	to_draw.clear()

@rpc("any_peer") func draw_count(count:int): if Global.game: for i in count: to_draw.append(Global.game.card())

@rpc("any_peer") func draw_arrays(cards_as_arrays:Array): draw_array(Global.cards_from_arrays(cards_as_arrays))

func draw_array(array:Array): to_draw.append_array(array)
#endregion


#region playing
func play(card:Card):
	if not played_card and card.flip > 0.99:
		played_card = card
		attempt_play.emit(card)

func finish_play(card:Card, success:bool):
	if success and played_card == card:
		hovered_card = null
	played_card = null
#endregion


#region hover bullshittery
func _ready():
	child_entered_tree.connect(_on_child_entered_tree)
	child_exiting_tree.connect(_on_child_exiting_tree)

func _on_child_entered_tree(node):
	node.hovered.connect(hover)
	node.unhovered.connect(unhover)

func _on_child_exiting_tree(node):
	node.hovered.disconnect(hover)
	node.unhovered.disconnect(unhover)
	
func hover(card): hovered_card = card

func unhover(card): if hovered_card == card: hovered_card = null
#endregion
