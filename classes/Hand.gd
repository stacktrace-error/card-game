extends Node2D
class_name Hand

signal play(card)

var hovered_card : Card:
	set(value):
		if hovered_card: hovered_card.hovering = false
		if value: value.hovering = true
		hovered_card = value


func _input(event):
	if(hovered_card and event.is_action_pressed("confirm")):
		var log = [0, 0, 0]
		for i in 1000:
			var g = Settings.random_glyph()
			log[g.rarity] += 1
		print(log)


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
