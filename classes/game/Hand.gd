extends Node2D
class_name Hand

signal attempt_play(hand, card)

var to_draw = 0

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

var max_width = 5500.0
var spacing = 350.0:
	get: return min(spacing, 1000.0 if card_count < 2 else max_width / (card_count - 1))
var offset = 850.0:
	get: return 0.0 if not hovered_card else offset * 0.5 + 350.0 - spacing


#region cards
func _input(event):
	if(hovered_card and event.is_action_pressed("confirm")):
		play(hovered_card)
	else: if(event.is_action_pressed("draw")):
		to_draw += 1

func _process(delta):
	Global.tmpv1 = Vector2.ZERO
	cards = get_children().filter(func(x): return x is Card)
	card_count = cards.size()
	
	# position the cards
	if(card_count > 1):
		Global.tmpv1[0] = -(spacing * (card_count - 1) * 0.5) - offset
		
		for i in card_count:
			var c = cards[i]
			# if hovered card, add an offset
			if c == hovered_card: Global.tmpv1[0] += offset
			
			# move current card
			c.position = c.position.lerp(Global.tmpv1, delta * 10)
			c.yoffset = c.hov * -200
			c.scloffset = c.hov * 0.1
			
			# next card's intended position
			Global.tmpv1[0] += spacing
			Global.tmpv1[1] = 0
			if c == hovered_card: Global.tmpv1[0] += offset # must be added twice
	
	else: if card_count == 1: 
		cards[0].position = cards[0].position.lerp(Global.tmpv1, delta * 10)
		Global.tmpv1[0] = spacing
	
	# draw new cards
	if not card_count == 0 and cards[-1].flip < 1:
		cards[-1].flip += (delta * 2.5) 
	
	else: if to_draw > 0:
		var drawn = Card.new()
		Global.tmpv1[1] = 10000
		drawn.position = Global.tmpv1
		drawn.flip = -0.5
		
		add_child(drawn)
		to_draw -= 1

func _ready():
	if get_parent() is Game: to_draw = get_parent().starting_hand
#endregion


#region playing
func play(card:Card):
	if not played_card and card.flip > 0.99:
		played_card = card
		attempt_play.emit(self, card)

func finish_play(pile:Game, card:Card, success:bool):
	if success and played_card == card:
		hovered_card = null
		Global.SOUND_CARD_PlAY.play()
		card.reparent(pile)
	played_card = null
#endregion


#region hover bullshittery
func hover(card):
	hovered_card = card

func unhover(card):
	if hovered_card == card:
		hovered_card = null

func _init():
	child_entered_tree.connect(_on_child_entered_tree)
	child_exiting_tree.connect(_on_child_exiting_tree)

func _on_child_entered_tree(node):
	if node is Card:
		node.hovered.connect(hover)
		node.unhovered.connect(unhover)

func _on_child_exiting_tree(node):
	if node is Card:
		node.hovered.disconnect(hover)
		node.unhovered.disconnect(unhover)
#endregion
