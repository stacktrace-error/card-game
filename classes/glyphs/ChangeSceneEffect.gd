extends Effect

@export var change_to = "game"

func trigger(cards):
	Global.change_scene(change_to)
