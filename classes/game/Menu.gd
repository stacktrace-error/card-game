extends Node
class_name Menu

signal finish_play(pile, card, success)

func _ready():
	Global.current_scene = self

func _init():
	child_entered_tree.connect(_on_child_entered_tree)
	child_exiting_tree.connect(_on_child_exiting_tree)

func _on_child_entered_tree(node):
	if node is Hand:
		node.attempt_play.connect(respond_play)
		finish_play.connect(node.finish_play)

func _on_child_exiting_tree(node):
	if node is Hand:
		node.attempt_play.disconnect(respond_play)
		finish_play.disconnect(node.finish_play)

func respond_play(_hand:Hand, card:Card):
	finish_play.emit(null, card, true)
