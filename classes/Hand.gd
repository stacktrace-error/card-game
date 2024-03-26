extends Node2D
class_name Hand

signal attempt_play(hand, card)

var to_draw = 0

var played_card : Card
var hovered_card : Card:
	set(value):
		if hovered_card: hovered_card.hovering = false
		if value: value.hovering = true
		hovered_card = value

var width = 4000.0:
	get: return width
var spacing : float:
	get: return width / (get_child_count() - 1)


func _input(event):
	if(hovered_card and event.is_action_pressed("confirm")):
		play(hovered_card)
	else: if(event.is_action_pressed("draw")):
		to_draw += 1

func _process(_delta):
	if to_draw > 0:
		add_child(Card.new())
		to_draw -= 1
	
	var cards = get_children()
	if not cards: return
	if(get_child_count() > 1):
		for i in cards.size():
			Global.tmpv1[0] = -(width * 0.5) + (spacing * i)
			
			var c = cards[i]
			var h = Utilities.smooth_interp(c.hover)
			c.position = Global.tmpv1.rotated(global_rotation)
			c.yoffset = h * -200
			c.scloffset = h * 0.1
	else: get_child(0).position = Vector2.ZERO

func play(card):
	if not played_card:
		played_card = card
		attempt_play.emit(self, card)

func finish_play(pile, card, success):
	if success and played_card == card:
		hovered_card = null
		card.reparent(pile)
	played_card = null


func hover(card):
	print("hovered")
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
		print(node.hovered.get_connections())

func _on_child_exiting_tree(node):
	if node is Card:
		node.hovered.disconnect(hover)
		node.unhovered.disconnect(unhover)
