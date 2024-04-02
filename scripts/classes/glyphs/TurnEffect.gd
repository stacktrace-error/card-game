extends Node
class_name TurnEffect

@export var mul = -1

func trigger(): Global.game.set_turn_step(Global.game.turn_step * mul)
