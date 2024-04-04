extends Node
class_name Player

var names = ["nullevoy", "FrooMeeth", "NNarcon", "JamerT"]
@export var player_name = "funsihfskzufgaugfu"

func _enter_tree(): 
	player_name = names.pick_random()
	set_multiplayer_authority(name.to_int())
