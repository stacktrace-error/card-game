extends Node
class_name DrawCardEffect

@export var draw_amount : int
@export var cards_as_arrays : Array
var game: 
	get: return Global.game

func trigger():
	if draw_amount: Hand.draw_count.rpc_id(game.player_in_x_turns(game.turn_step), draw_amount)
	
	if cards_as_arrays: Hand.draw_arrays.rpc_id(Global.game.player_in_x_turns(Global.game.turn_step), cards_as_arrays)
