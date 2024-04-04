extends Node

signal scene_changed

const CARD_SIZE = Vector2(822, 1122)
const CARD_DRAW_OFFSET = Vector2(-411, -561)
var CARD_SHAPE = RectangleShape2D.new()
var CARD_COLLISION = CollisionShape2D.new()

var GLYPH_EMPTY = Glyph.new()

var SOUND_CARD_HOVER = add_sound("res://assets/sounds/noammo.ogg", 1)
var SOUND_CARD_PLAY = add_sound("res://assets/sounds/click.ogg", 1.5)

# Temporary vectors/arrays.
var tmpv1 = Vector2()
var tmpv2 = Vector2()
var tmpv3 = Vector2()

var tmpa1 = Array()
var tmpa2 = Array()

var game : Game

var glyphs = [GLYPH_EMPTY]

var sceneless_menus = {}
var menu_cards = {}


#region glyphs
func register_glyph(glyph:Glyph):
	glyphs.append(glyph)

func get_glyph(_name):
	for i in glyphs: if i.glyph_name == _name: return i
	push_warning("could not find glyph " + _name)
	return Global.GLYPH_EMPTY
#endregion


#region scenes
func change_scene(_name, all_players = false):
	if not all_players: deferred_change_scene.call_deferred(_name)
	else: all_change_scene.rpc(_name)

@rpc("call_local", "any_peer")
func all_change_scene(_name):
	deferred_change_scene.call_deferred(_name)

func deferred_change_scene(_name):
	disconnection(game)
	game.free()
	
	if sceneless_menus.has(_name): game = sceneless_menus[_name].duplicate()
	else: game = ResourceLoader.load("res://scenes/" + _name + ".tscn").instantiate()
	get_tree().root.add_child(game, true)
	
	scene_changed.emit()

func connection(_game):
	Hand.attempt_play.connect(_game.respond_play)
	_game.finish_play.connect(Hand.finish_play)

func disconnection(_game):
	Hand.attempt_play.disconnect(_game.respond_play)
	_game.finish_play.disconnect(Hand.finish_play)

func content_load():
	sceneless_menus = {"game": Game.new(8, Array(), glyphs)}
	menu_cards = {
		"mainmenu": [Card.new("create-ip"), Card.new("join-ip")],
		"createip": [Card.new("lobby-created"), Card.new("back-main")],
		"joinip": [Card.new("lobby-joined"), Card.new("back-main")],
		"lobbycreated": [Card.new("start-game"), Card.new("back-create-ip")],
		"lobbyjoined": [Card.new("back-join-ip")]
	}
#endregion

func _ready():
	CARD_SHAPE.set_size(CARD_SIZE * Settings.card_scale)
	CARD_COLLISION.set_shape(CARD_SHAPE)

func card_from_array(c:Array): return Card.new(c[0], c[1], c[2], c[3])

func cards_from_arrays(arrs:Array):
	tmpa1.clear() 
	for yarhar in arrs: tmpa1.append(card_from_array(yarhar)) # it's a pirate
	return tmpa1

func add_sound(_name, volume):
	var sound = AudioStreamPlayer.new()
	sound.stream = load(_name)
	sound.volume_db = volume
	add_child(sound)
	return get_child(-1)
