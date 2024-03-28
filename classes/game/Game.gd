extends Node
class_name Game

signal finish_play(pile, card, success)

@export var starting_card = true
@export var max_cards = 16
@export var starting_hand = 8

func _init():
	child_entered_tree.connect(_on_child_entered_tree)
	child_exiting_tree.connect(_on_child_exiting_tree)

func _process(_delta):
	var cards = get_children()
	if not cards: return
	
	for i in cards:
		if i is Card: 
			i.position = i.position.lerp(Vector2.ZERO, _delta * 20)
			
			var dst = clamp(i.position.distance_to(Vector2.ZERO) * 0.2, 0, 1)
			i.scloffset = Utilities.smooth_interp(dst) * 0.1
			i.rotoffset = (i.get_angle_to(Vector2.ZERO) + (PI*0.5)) * dst

func _on_child_entered_tree(node):
	if node is Hand:
		node.attempt_play.connect(respond_play)
		finish_play.connect(node.finish_play)

func _on_child_exiting_tree(node):
	if node is Hand:
		node.attempt_play.disconnect(respond_play)
		finish_play.disconnect(node.finish_play)

func respond_play(_hand:Hand, card:Card):
	finish_play.emit(self, card, true)
