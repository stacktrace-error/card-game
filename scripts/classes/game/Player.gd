extends Node
class_name Player

var player_name = "nullevoy"

func _enter_tree(): set_multiplayer_authority(name.to_int())
