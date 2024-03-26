extends Node
class_name Game

signal finish_play(pile, card, success)

@export var starting_card = true


func _init():
	child_entered_tree.connect(_on_child_entered_tree)
	child_exiting_tree.connect(_on_child_exiting_tree)

func _process(_delta):
	var cards = get_children()
	if not cards: return
	
	for i in cards:
		if i is Card: i.position = Vector2.ZERO

func _on_child_entered_tree(node):
	if node is Hand:
		node.attempt_play.connect(respond_play)
		finish_play.connect(node.finish_play)

func _on_child_exiting_tree(node):
	if node is Hand:
		node.attempt_play.disconnect(respond_play)
		finish_play.disconnect(node.finish_play)

func respond_play(_hand, card):
	finish_play.emit(self, card, true)
