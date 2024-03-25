extends Node2D
class_name Hand


var hovered_card : Card:
	set(value):
		if hovered_card: hovered_card.hovering = false
		if value: value.hovering = true
		hovered_card = value

func _on_child_entered_tree(node):
	if node is Card:
		node.hovered.connect(hover)
		node.unhovered.connect(unhover)

func hover(card):
	hovered_card = card

func unhover(card):
	if hovered_card == card:
		hovered_card = null
