extends Node2D
class_name Hand

signal attempt_play(player, card)

var hovered_card : Card:
	set(value):
		if hovered_card: hovered_card.hovering = false
		if value: value.hovering = true
		hovered_card = value

var played_card : Card

var width = 4000.0:
	get: return width if get_child_count() > 1 else 0

var spacing : float:
	get: return width / (get_child_count() - 1)


func _input(event):
	if(hovered_card and event.is_action_pressed("confirm")):
		pass

func _process(_delta):
	var cards = get_children()
	for i in cards.size():
		Global.tmpv1[0] = -(width * 0.5) + (spacing * i)
		cards[i].position = Global.tmpv1.rotated(global_rotation)

func play(card):
	if not played_card:
		played_card = card
		attempt_play.emit(self, card)

func finish_play(card, succeeded):
	if succeeded and played_card == card:
		
	played_card = null


func _on_tree_entered():
	Global.hands.append(self)

func _on_tree_exited():
	


func hover(card):
	hovered_card = card

func unhover(card):
	if hovered_card == card:
		hovered_card = null

func _on_child_entered_tree(node):
	if node is Card:
		node.hovered.connect(hover)
		node.unhovered.connect(unhover)

func _on_child_exited_tree(node):
	if node is Card:
		node.hovered.disconnect(hover)
		node.unhovered.disconnect(unhover)
