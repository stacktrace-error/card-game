extends Effect

@export var change_to = "game"
@export var all_players = false

func trigger():
	Global.change_scene(change_to, all_players)
