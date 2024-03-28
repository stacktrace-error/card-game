extends Node

const CARD_SIZE = Vector2(822, 1122)
const CARD_DRAW_OFFSET = Vector2(-411, -561)

var CARD_SHAPE = RectangleShape2D.new()
var CARD_COLLISION = CollisionShape2D.new()

var GLYPH_EMPTY = Glyph.new()

var SOUND_CARD_HOVER = add_sound("res://assets/sounds/noammo.ogg", 2)
var SOUND_CARD_PlAY = add_sound("res://assets/sounds/click.ogg", 3)

# Temporary vectors.
var tmpv1 = Vector2()
var tmpv2 = Vector2()
var tmpv3 = Vector2()

var current_scene

func _init():
	CARD_SHAPE.set_size(CARD_SIZE)
	CARD_COLLISION.set_shape(CARD_SHAPE)

func add_sound(_name, volume):
	var sound = AudioStreamPlayer.new()
	sound.stream = load(_name)
	sound.volume_db = volume
	add_child(sound)
	return get_child(-1)


func change_scene(_name):
	call_deferred("_deferred_change_scene", _name)

func _deferred_change_scene(_name):
	current_scene.free()
	var s = ResourceLoader.load("res://" + _name + ".tscn")
	current_scene = s.instantiate()
	get_tree().root.add_child(current_scene)
